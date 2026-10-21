# 01/07 — 贝叶斯定理与统计思维（Bayes' Theorem & Statistical Thinking）

本目录位于 **learning-artifacts/cn** 下，独立于官方课程目录 `phases/`。与先前 01/06 一样，保存供自己阅读、跟练、补充答案的完整课程副本。

## 文件索引

| 路径 | 内容 | 状态 |
|---|---|---|
| [docs/zh.md](docs/zh.md) | **完整中文讲义**：原官方 485 行文档对应的全部章节、公式、原封不动的代码/图示块、4 道练习、Hints、术语和参考资料 | 已准备 |
| [docs/en.md](docs/en.md) | 官方讲义英文原文，方便逐节核对 | 已复制 |
| [code/bayes.py](code/bayes.py) | 官方完整可运行实现：贝叶斯计算、朴素贝叶斯、MLE/MAP、Beta 更新、A/B 测试等 | 已复制 |
| [code/learn.ipynb](code/learn.ipynb) | **个人学习 Notebook**：热身、推导、学生动手实现、实验和课后复盘；本课暂未开始评分 | 待逐步学习 |
| [quiz.json](quiz.json) | 官方 pre/post 测验原始数据（含正确答案，用于课程系统评分） | 已复制 |
| [quiz.zh.json](quiz.zh.json) | 中文版 pre/post 测验，题序及答案下标与官方完全一致 | 已翻译 |
| [outputs/prompt-bayesian-reasoning.md](outputs/prompt-bayesian-reasoning.md) | 官方贝叶斯推理提示词原文 | 已复制 |
| [outputs/prompt-bayesian-reasoning.zh.md](outputs/prompt-bayesian-reasoning.zh.md) | 该提示词的完整中文翻译 | 已翻译 |

## 来源与对应关系

官方来源：`rohitg00/ai-engineering-from-scratch` 仓库 `main` 分支的
`phases/01-math-foundations/07-bayes-theorem/`。

中文版 `docs/zh.md` **保留全部 20 个原版围栏内容块**（LaTeX、Python、Mermaid 和特殊插图指令），按原文出现的次序排列；所有 27 个章节标题对应齐全，并翻译其余解释性文字、表格、Exercises、Hints、Key Terms 与 Further Reading。为让 Python 直接可执行，英语短信样本、变量名、代码字符串没有强行翻译。译者补充说明均标注为“译注”。

**学习规则**：`quiz.json` 和 `quiz.zh.json` 含正式答案，循序学习时先不要查看 `correct` 字段；导师会根据官方 `stage=post` 逐题出题。此时仍未把 01/07 记录为完成。

## 本地拉取（在你的 WSL 仓库根目录）

```bash
cd ~/ai-engineering-from-scratch
git switch my-progress
git pull --ff-only origin my-progress
```

阅读完整翻译：

```bash
less learning-artifacts/cn/phases/01-math-foundations/07-bayes-theorem/docs/zh.md
```

运行官方无第三方依赖的示例：

```bash
python3 learning-artifacts/cn/phases/01-math-foundations/07-bayes-theorem/code/bayes.py
```

在 VS Code/Jupyter 中打开 `learning-artifacts/cn/phases/01-math-foundations/07-bayes-theorem/code/learn.ipynb` 开始逐段练习。

**课程结构**：The Problem → The Concept → Build It → Use It → Ship It → Exercises → Post Quiz，配合 MLE/MAP、共轭先验、顺序贝叶斯更新与 Bayesian A/B Testing。
