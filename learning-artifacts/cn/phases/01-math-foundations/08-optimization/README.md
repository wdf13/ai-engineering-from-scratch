# 01/08 Optimization — 课程镜像与学习入口

此目录保存官方 01/08 的全部五个原始文件，另加中文材料和独立学习 Notebook。课程仍处于**学习中**，不得标记完成。

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
- [ ] Learning Rate Schedules：Step Decay、Cosine 数学推导、Warmup + Decay 的完整理解与实践
- [ ] Convex vs Non-convex：严格定义、局部/全局最优、适用条件
- [ ] Loss Landscape：参数空间二维切片可视化、方法与局限
- [ ] AdamW 解耦权重衰减：与 Adam/L2 惩罚的差异及数值例子
- [ ] Use It 延伸：参数组、梯度裁剪及如何在生产训练中配置调度频率
- [ ] Ship It：官方 outputs/prompt-optimizer-guide.md 对应的实操交付
- [ ] Post Quiz：官方 quiz.json 中全部 stage=post 问题逐题作答与评分

**课程暂为进行中**。用户明确反馈：填空/验收比例过高，原理讲解不足。接下来按官方课程顺序补足核心概念；一轮深入讲清一个小节，再做理解检查。未完成上述事项前不得标记整课完成。

## 持续学习规则

进入下一课前先读 `learning-artifacts/cn/AGENTS.md`；必须递归查看官方课的全部文件并完成镜像与校验，不能只导入中文教材。学生独立计算和写代码，答题逐步验收，完成所有练习及 post-quiz 后更新根目录 `LEARNING.md`。
