# 01/09 Information Theory — 信息论学习入口

**状态：进行中（2026-11-11 开课）。** 按官方 Learn Skill 和 `learning-artifacts/cn/AGENTS.md` 执行交互式教学；仅在完成所有核心知识检查、Build It、官方 Exercises、Ship It 与 stage=post Quiz 后登记完成。

## 权威来源与完整镜像

官方目录：`phases/01-math-foundations/09-information-theory/`  
个人完整镜像：`learning-artifacts/cn/phases/01-math-foundations/09-information-theory/`

根据 GitHub REST 递归文件树、Contents API 及 Git blob SHA，官方 4 个文件已完整复制，并复核原始内容相同：

| 官方相对路径 | 内容 | 完整性 |
|---|---|---|
| `docs/en.md` | 官方英文信息论教材 | 原文与 blob SHA 一致 |
| `code/information_theory.py` | 信息量、熵、交叉熵、KL、MI、标签平滑与演示 | 原文与 blob SHA 一致 |
| `quiz.json` | 前测与正式后测题库 | 原文与 blob SHA 一致 |
| `outputs/skill-information-theory.md` | 官方 Ship It 应用指南 | 原文与 blob SHA 一致 |

官方源码与测验的字节内容均未被修改。

## 中文学习文件

| 路径 | 内容和状态 |
|---|---|
| `docs/zh.md` | 根据英文原文重新翻译与技术校对的完整中文教材，覆盖全部核心章节、5 段 Build It 和 1 段 NumPy 实现；6 段官方 Python 围栏代码内容原样保留 |
| `quiz.zh.json` | 全部 5 题中文译文；原始顺序、stage、correct 答案索引和选项对应关系一致；不提前展示评分信息 |
| `outputs/skill-information-theory.zh.md` | 官方信息论应用指南的中文副本与适用条件校注 |
| `code/learn.ipynb` | 独立、只追加的学习 Notebook：学生原始回答、讲解、数学推导与真实实验记录 |
| `source-manifest.json` | 官方 blob SHA、复制校验和翻译验证状态 |

**中文译本溯源：** 上游仓库 `rohitg00/ai-engineering-from-scratch` 的 `translations` 分支有 `i18n/zh/phases/01-math-foundations/09-information-theory/docs/zh.md`，但该文件存在明显术语误译（例如熵、交叉熵及 KL 等概念）。因此没有直接将其当作完成版本，而是以当前官方英文内容为准重新翻译校对。关于有限样本互信息估计、PPL 不同语料及词表可比性等问题加入必要限定。

## 课程内容与验收清单

本清单按**学生已证实的掌握程度**更新；“讲义有内容”不等于“学生已学会”。

- [ ] 上一课回顾：从官方 01/08 Quiz 选两道题，完成非计分知识回顾
- [ ] The Problem：不确定性、压缩与模型分类损失的联系
- [ ] Information Content：自信息量公式、单位、概率边界和数值例子
- [ ] Entropy：期望、非负性、最大熵分布及完整手算
- [ ] Cross-Entropy：真实分布与模型分布、one-hot 情形、概率为零与 logits 的区分
- [ ] KL Divergence：公式推导、非负性、与 CE 的恒等式和非对称例子
- [ ] Joint / Conditional Entropy：链式法则、独立情形和互信息关系
- [ ] Mutual Information：从联合分布手算、独立性、非线性关系、特征选择有限样本局限
- [ ] Label Smoothing：软目标构造、交叉熵分解与正则化影响
- [ ] Maximum Likelihood：分类 CE=NLL 的公式推导与样本数归一化
- [ ] Bits vs Nats：对数底换算及框架输入输出
- [ ] Perplexity：困惑度公式与 token 序列的评估含义
- [ ] Build It：官方 5 组 Python 数值实现由学生独立完成并用真实运行验证
- [ ] Use It：NumPy/PyTorch 对照，数值精度、边界与概率校验
- [ ] Exercises 1：26 字母均匀分布与有明确数据源的真实字母频率熵
- [ ] Exercises 2：指定 logits/true class 的交叉熵手算、代码验证与零 Loss 极限
- [ ] Exercises 3：构造 KL 不对称例子并定量比较
- [ ] Exercises 4：实现并测试 token 序列 perplexity
- [ ] Ship It：结合实际 ML 场景生成可用、可检查的信息论指标决策指南
- [ ] Post Quiz：官方 `quiz.json` 中全部 3 道 stage=post 题逐题作答和评分

**课程暂不计入已完成。** 根目录 `LEARNING.md` 的 01/08-optimization 记录保持不变；Phase 1 原路径标记为 Skip，本课属于连续开展的数学基础选修，不据此把整个 Phase 1 标成 Done。

## 交互教学顺序

- 遵循 `skills/learn/SKILL.md`：先回顾上一课两道 Quiz，再 Problem → Concept（先直觉、理解检查，再完整数学推导与数值例子）→ Build It → Use It → 官方 Exercises 与 Ship It → Post Quiz。
- 学生独立输入结果和代码；每次只聚焦一个概念，先讲清机制和推导，再留下一项有意义的理解检查。
- 真实执行的代码才标“已运行”；未验证的实验标记为待运行。Notebook 只追加，不覆盖上一轮。
- GitHub 提交后重新 fetch_file 校验 SHA、Notebook 可解析性及条目数量。

