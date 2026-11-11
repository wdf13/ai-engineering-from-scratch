# Ship It：Transformer 优化器选择指南（个人实践交付版）

> 课程：01/08 Optimization · 日期：2026-11-11 · 状态：**Ship It 已完成，正式 Post Quiz 待进行**  
> 依据：官方 `phases/01-math-foundations/08-optimization/outputs/prompt-optimizer-guide.md`。本文件为学生决策方案及教师复核，不修改官方原文。超参数是待验证的初始候选，不是跨任务的最优值。

## 任务定义与决策边界

从零训练 Transformer，总预算 **10,000 次 optimizer.step()**；对每次成功的参数更新调用一次 scheduler.step()。具体数据集、参数规模、有效 batch size、精度与设备未限定，训练是否有效必须由后续实际任务实验确认。

学生原始回答已完整保存在 `../code/learn.ipynb`，这里保留原始方案的关键配置：AdamW、峰值 lr=0.001、weight_decay=0.1、Warmup 1000 步、Cosine 9000 步、全局梯度范数阈值 5、优先排查高学习率、不因验证指标停滞直接切换 SGD。

**用户最终确认**（原文）：

> 我只是把weight_decay=0.1作为正则化超参数，并不要求权重精确减少10%，请据此修订Ship It方案。

因此 `weight_decay=0.1` 被视为**可调正则化超参数**，不是要求单步或全程权重数值减少 10% 的约束。

## 1. 推荐优化器与初始超参数

| 配置 | 主实验 | 合理性与验证方式 |
|---|---|---|
| Optimizer | AdamW | 将 weight decay 从自适应梯度矩估计解耦 |
| 峰值学习率 | **0.001** | 保留学生选择；对 Transformer 是相对激进的候选，建议同预算追加 0.0003 的控制实验 |
| Betas | (0.9, 0.999) | 作为 AdamW 常用初值，需观察损失稳定性 |
| Epsilon | 1e-8 | AdamW 常用初值 |
| Weight decay | **0.1** | 用户确认作为正则化超参数；依据验证指标调整 |
| 参数组 | 矩阵/权重张量设 0.1，bias/Norm 等一维参数设 0 | 常见工程配方，可根据模型结构修改 |
| Gradient clipping | Global L2 norm，**max_norm=5.0** | 保留学生选择；建议同时评估阈值 1.0，并记录裁剪频率 |

**精确含义**：AdamW 当前步纯 weight decay 对参数的乘性系数为 \((1-\eta_t\lambda)\)。峰值 lr=0.001、lambda=0.1 时，单步纯衰减系数为 0.9999，即衰减项为 **0.01%**。实际参数总变化还包含任务损失的 Adam 更新。Weight decay 参数不是固定权重百分比目标。

## 2. 学习率计划与调用顺序

- 采用线性 Warmup：前 **1000** 次调度，LR 从 peak_lr×0.01（1e-5）升至 peak_lr（0.001）。
- 随后 CosineAnnealingLR：剩余 **9000** 次调度，从峰值平滑下降到 0。
- SequentialLR 的里程碑为 **[1000]**，不是 [9000]。
- 每次成功的 optimizer.step() 后调用 scheduler.step()；使用 AMP 时，被 GradScaler 跳过的优化器更新不应错误推进按 optimizer-update 计数的调度器。
- 与“前期用大学习率快速寻找”不同，Warmup **先用较小 LR 保持初期稳定**，之后才到达峰值。到第 1000 次 scheduler.step() 结束时**下一次更新**将使用 0.001；第 1001 次 optimizer.step() 是第一个使用峰值的更新。

## 3. 最小可运行 PyTorch 配置

下例的 TransformerEncoderLayer 和随机数据仅用于验证配置、API 调用和一次计算图反向传播；**并未训练一个真实任务的 Transformer 模型**。

    import torch
    from torch import nn

    model = nn.TransformerEncoderLayer(
        d_model=16, nhead=4, dim_feedforward=32, batch_first=True
    ).double()

    decay, no_decay = [], []
    for p in model.parameters():
        if not p.requires_grad:
            continue
        (decay if p.ndim >= 2 else no_decay).append(p)

    optimizer = torch.optim.AdamW(
        [{"params": decay, "weight_decay": 0.1},
         {"params": no_decay, "weight_decay": 0.0}],
        lr=0.001, betas=(0.9, 0.999), eps=1e-8,
    )
    warmup = torch.optim.lr_scheduler.LinearLR(
        optimizer, start_factor=0.01, end_factor=1.0, total_iters=1000
    )
    cosine = torch.optim.lr_scheduler.CosineAnnealingLR(
        optimizer, T_max=9000, eta_min=0.0
    )
    scheduler = torch.optim.lr_scheduler.SequentialLR(
        optimizer, [warmup, cosine], milestones=[1000]
    )

    # 仅演示一个训练更新；真实训练须替换为任务数据和正确损失
    batch = torch.randn(2, 4, 16, dtype=torch.float64)
    optimizer.zero_grad(set_to_none=True)
    outputs = model(batch)
    loss = (outputs - batch).square().mean()
    loss.backward()
    original_norm = torch.nn.utils.clip_grad_norm_(
        model.parameters(), max_norm=5.0, error_if_nonfinite=True
    )
    optimizer.step()
    scheduler.step()
    print(loss.item(), original_norm.item(), optimizer.param_groups[0]["lr"])

实现要点：先 backward 再 clip，再 optimizer.step()，最后 scheduler.step()。clip_grad_norm_ **返回裁剪前**梯度范数，且改变 .grad。参数组的 `p.ndim>=2` 是本例的简化规则，不是所有模型结构的统一规范。

## 4. 监控指标与异常处理

每个优化器更新步或固定间隔记录：实际 LR、训练 Loss、验证集 Loss/任务指标、裁剪前梯度范数、裁剪频率、非有限数值事件、必要时参数更新幅度。控制实验须保持数据划分、更新预算、评估指标和随机性口径一致。

| 异常 | 优先检查 | 动作 |
|---|---|---|
| Loss 爆炸/NaN | LR 轨迹、输入/标签中的 NaN/Inf、损失实现、梯度非有限、AMP 溢出 | 必要时将峰值 LR 下调，定位第一个异常 batch 或算子，核查裁剪及梯度缩放 |
| Loss 降得很慢 | Warmup 是否过长、峰值 LR、梯度范数分布、模型容量、数据管线 | 检查实际 LR 与瓶颈，再开展单变量对照 |
| Train Loss 下降，Validation Loss 上升 | 泛化差距、验证数据一致性、评估模式 | 考虑正则化、数据增强或早停 |
| Train Loss 下降，验证指标平台 | 验证指标定义、分布偏移、评估噪声、LR 是否合适 | 不立刻定性为过拟合，检查验证 Loss 与任务指标走势 |

## 5. 何时修改策略或切换优化器

默认先使用 AdamW 跑通可复现的任务基线。若实际训练不稳定，先修正数值问题、学习率和数据管线，再考虑优化器替换。若验证性能长期不改善，首先区分过拟合、优化不足、评估噪声与数据分布问题；**不自动切换 SGD**。若确需比较 SGD+Momentum，应使用同等训练预算、合理各自学习率与调度器、多个随机种子或等效置信度评估，不预设哪一种必然泛化更好。

建议的少量有根据的对照实验：
1. 保留主实验 (peak LR=0.001, WD=0.1, clip=5)；
2. 仅降低峰值 LR 至 0.0003，其余不变，评估稳定性和验证指标；
3. 如果频繁出现很大梯度，再将 max_norm 从 5 调为 1 进行单变量对照；
4. 视验证集表现考虑 WD 取 0.01 与 0.1 的对照，不要求精确的参数缩减百分比。

## 教师复核与可复现实验

**实际执行环境**：PyTorch 2.10.0+cpu，float64，单参数纯衰减测试；另用 TransformerEncoderLayer(d_model=16,nhead=4) 随机输入完成一次真实 backward/clip/optimizer/scheduler step。

- 零任务梯度、w0=2、peak LR=0.001、WD=0.1、Warmup=1000、Cosine=9000、共 10000 步：w_final = **1.2124318317805753**。
- 纯衰减因子 \(\prod_{t=0}^{9999}(1-\eta_t\lambda)=0.6062159158902877\)，累计减少 **39.3784%**。这是特意隔离机制的数值试验，**不是**用户设定的 10% 目标，更不是 Transformer 训练成效。
- Warmup 第 1 次更新实际 LR=1e-5；第 1000 次使用 0.00099901；第 1001 次使用 0.001；第 10000 次结束后 LR 为 0。
- 一次模型梯度计算与参数组/裁剪/调度调用链运行通过；随机数据演示不代表任何真实模型效果。
- 对照实验与实际任务效果**尚未执行**，不宣称存在训练或泛化提升。

## 课程状态

- [x] 已保存学生原始方案与后续语义澄清
- [x] 根据确认把 WD=0.1 定义为正则化候选，而非精确权重收缩目标
- [x] 给出完整的五部分优化器决策与可运行配置
- [x] 数值及基本调用链实际复核
- [ ] 官方 `quiz.json` 的三个 stage=post 题逐题作答并评分

**Ship It 交付验收通过；本课仍需 Post Quiz 才能登记完成。**
