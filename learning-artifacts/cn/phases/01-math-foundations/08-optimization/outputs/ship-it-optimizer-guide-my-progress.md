# Ship It：优化器选择指南（个人实践草稿，待复核）

> 对应课程：01/08 Optimization；官方材料为 phases/01-math-foundations/08-optimization/outputs/prompt-optimizer-guide.md。此文件是**个人实践草稿**，不改动官方材料。日期：2026-11-11。状态：**待用户修订确认**，不是已验收的课程交付成果。

## 任务设定

- 模型：从零训练 Transformer；数据集、模型参数量、batch size 和硬件未指定
- 总优化器参数更新预算：10,000
- optimizer.step 和 scheduler.step 频率：每 mini-batch 各调用一次，且 scheduler.step 在 optimizer.step 后执行
- 目标：训练损失稳定下降，同时验证集泛化指标改善；调参需要独立验证

## 学生原始方案（未经修改）

> lr 我选择0.001 weight_decay = 0.1 我想让它的权重按照10%的进行衰退,lr设置0.001 是为了让warmup能有上升空间, 我想让warmup走1000步,cosine走9000步让他前期通过大的学习率快速寻找,在1000步的时候切换,使用global norm 初始 max_norm 设置为5,不想让梯度太大了,我会优先检查学习率是否偏大,让学习率降低,不会loss下降代表我们再持续学习,但是验证指标长时间不改善这要考虑到过拟合的问题

## 1. 初始优化器与参数

- 学生选择：AdamW，peak LR=0.001，weight_decay=0.1。
- 评审：AdamW 是合适的基线；峰值 0.001 可作为激进候选，但官方 Transformer 经验起点 LR 在 1e-4~3e-4，建议与 1e-4、3e-4 做固定预算对比，而非断言 0.001 更好。
- 纠正：每步纯权重衰减比例为 lr_t * weight_decay，LR 达峰值时是 0.001 * 0.1 = 0.0001 = **0.01%**，不是 10%。实际参数总变化还取决于任务梯度。
- 待明确：“希望权重按照 10% 衰退”究竟是单步、全程累计，还是仅指正则化强度超参数。

## 2. 学习率调度

- Warmup：1,000 次调度；Cosine Decay：9,000 次调度；切换 milestone=[1000]。这三项正确。
- 可以使用 LinearLR(start_factor=0.01,end_factor=1.0,total_iters=1000) + CosineAnnealingLR(T_max=9000,eta_min=0) + SequentialLR。
- 若峰值为 0.001，那么 Warmup 起点为 1e-5，到第一次切换时达到 0.001，然后随 Cosine 下降；Warmup 并不是一开始就用较大学习率。
- 需要记录每次更新实际使用 LR 和下一次预备 LR，防止 off-by-one 与频率错误。

## 3. 梯度裁剪

- 学生选择：Global Norm Clipping, max_norm=5。
- 可以作为候选阈值，但相较官方 Transformer 示例 max_norm=1 更宽松。建议记录裁剪前范数、裁剪触发频率、训练损失和验证指标，再判断是否调整。
- 对 AMP 混合精度训练，在 clip_grad_norm_ 前正确 unscale_；梯度范数阈值不等于 AdamW 参数更新范数的上限。

## 4. 不稳定与异常信号

- 首先检查：真实学习率轨迹、梯度范数及其分布、loss 是否非有限、输入及标签是否非有限、梯度缩放/数值溢出、数据管线和损失实现。
- 若训练损失爆炸/NaN：可先降低 peak LR 或缩短过于激进的阶段，检查 warmup/clip 是否生效。必要时定位第一个产生 NaN/Inf 的 batch 与算子，不能简单视为学习率过大。
- 同时观察：train loss、validation loss/任务指标、梯度裁剪比率、更新幅度，固定随机种子及相同更新预算比较。

## 5. 何时改变优化器

- 仅因为验证集指标长期不改善，不应自动切换 SGD。
- train loss 持续下降同时 validation loss 回升、泛化差距扩大时，更支持过拟合，需要检查数据划分、正则化、早停、数据增强。
- validation 指标平台期也可能来自优化停滞、学习率配置、噪声、分布偏移或指标本身问题，应分解原因，必要时再将 AdamW 与 SGD+Momentum 比较。
- 官方指南中“Adam 一定走向 sharp minima、SGD 一定泛化更好”只是经验简化，不能作为无条件定理。

## 数值验收：仅衰减项的可复现实验

环境：PyTorch 2.10.0+cpu，float64；单参数 w=2，任务梯度为存在的零张量，AdamW peak LR=0.001, weight_decay=0.1；LinearLR warmup 1,000 步、cosine 9,000 步，T_max=9000；总 10,000 次 optimizer.step + scheduler.step。

结果：第 10,000 次更新后 w=1.212431831781，纯衰减保留因子 0.6062159158902877，累计减少约 39.38%。这验证了总衰减是逐步因子乘积，不是把 weight_decay=0.1 解释成“全程减少 10%”。**此实验没有真实 Transformer 训练，不可当作模型精度或泛化结论。**

## 待用户最终确认

- [ ] 对 10% 衰减目标的语义与对应正则化参数作出说明
- [ ] 明确学习率峰值选择的对照实验设计（可以保留 lr=0.001 作为一组）
- [ ] 按五部分最终完善方案，师生复核后将 Ship It 标记完成
- [ ] 进行原始 quiz.json 的三道 stage=post 正式后测
