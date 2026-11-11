# 01/08 Optimization — 课程镜像与学习入口

此目录保存官方 01/08 的全部五个原始文件，另加中文材料和独立学习 Notebook。课程于 **2026-11-11 完成**，本课原始镜像、个人 Notebook、独立交付和官方测验均已留存。

## 原始文件（与仓库官方版本内容完全相同）

| 文件 | 内容 |
|---|---|
| `docs/en.md` | 官方英文讲义 |
| `code/optimizers.py` | Python：GD、Momentum、Adam 与演示 |
| `code/main.jl` | Julia：优化器实现与演示 |
| `quiz.json` | 官方前测和后测，答案仅用于评分 |
| `outputs/prompt-optimizer-guide.md` | 官方输出提示词 |

## 中文与个人资料

- `docs/zh.md`：依据官方英文原文完成全章精译和技术校对；17 个代码与图示块的主体内容与英文原版一致，已适配 GitHub 公式和代码围栏，并添加必要的理论译注。仍以 `docs/en.md` 为权威依据。
- `quiz.zh.json`：中文测验副本，stage、顺序和正确答案索引与官方完全一致。学习时不得提前公布正确答案。
- `outputs/prompt-optimizer-guide.zh.md`：中文版输出说明。
- `code/learn.ipynb`：个人学习记录，不得覆盖或清空。
- `source-manifest.json`：原始文件清单及 Git blob SHA，供完整性验证。

## 本课内容覆盖清单与修复计划（2026-11-09 审计）

此清单基于原始 docs/en.md、quiz.json 和个人 Notebook 的实际学习证据；完成一项须有具体讲解、学生回答或实际实验记录，不能只因出现 API 代码就打勾。

- [x] The Problem：优化问题与梯度下降目标
- [x] GD / Learning Rate：公式、手写代码、步长扫描及发散处理
- [x] Batch GD / SGD / Mini-batch：样本粒度、随机性及无偏性条件
- [x] Momentum：速度更新、历史状态、Rosenbrock 对照及过冲解释
- [x] Adam：双矩、偏差修正、逐步实现并与 PyTorch 数值核对
- [x] Exponential Decay：从零实现、合并回 GD、固定学习率对照
- [x] Saddle Point：Hessian、曲率方向、三种优化器逃逸实验
- [x] Build It：Rosenbrock 数值优化器与收敛轨迹
- [x] 官方 Exercises 1-4：代码、结果和相关概念检查
- [x] Use It 部分：PyTorch SGD/AdamW/CosineAnnealingLR 调用已能运行
- [x] Learning Rate Schedules：Step Decay、Cosine 与 Warmup + Decay 公式及实际步数；学生完成 warmup=1000/cosine=9000、T_max 调用单位与错误里程碑理解题，并完成 PyTorch 验证（2026-11-10）
- [x] Convex vs Non-convex：严格定义、局部/全局最优、适用条件；学生用 g(x)=(x²-1)² 的 Jensen 反例和二阶导数证明并通过理解检查（2026-11-10）
- [x] Loss Landscape：已生成 Rosenbrock 的真实二维等高线图；学习高维二维切片定义与局限，学生通过谷底线梯度、Hessian 条件数及 GD 误差收缩理解检查（2026-11-10）
- [x] AdamW 解耦权重衰减：与耦合 L2/Adam 的矩估计区别、实际数值实验；学生完成衰减比例、分组与双矩影响理解检查（2026-11-11）
- [x] Use It 延伸：参数组、梯度裁剪及训练步级调度频率；学生通过 weight_decay=0 与 global-norm clipping 理解检查，PyTorch 2.10.0 CPU 实际验证（2026-11-11）
- [x] Ship It：学生完成 AdamW Transformer 优化器五部分方案，明确 weight_decay=0.1 为正则化超参数；已生成可运行配置并完成 PyTorch 2.10 CPU 冒烟测试，实操交付见 outputs/ship-it-optimizer-guide-my-progress.md（2026-11-11）
- [x] Post Quiz：官方 quiz.json 的三道 stage=post 题按顺序独立作答并评分，Q1=D、Q2=B、Q3=B，最终 3/3（2026-11-11）

**课程状态：已完成（2026-11-11）。** 用户此前指出填空和浅层验收不能替代概念教学，已据此补充严格数学推导、理解检查与实际实验；所有官方 Exercises、Ship It 与 Post Quiz 已完成并记录。Phase 1 仅完成部分单课，未把整个阶段标记为 Done。

## 持续学习规则

进入下一课前先读 `learning-artifacts/cn/AGENTS.md`；必须递归查看官方课的全部文件并完成镜像与校验，不能只导入中文教材。学生独立计算和写代码，答题逐步验收，完成所有练习及 post-quiz 后更新根目录 `LEARNING.md`。
