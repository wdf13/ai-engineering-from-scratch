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

- `docs/zh.md`：上游 translations 分支的机器译文，**存在明显术语误译，未逐段人工校对**；以 `docs/en.md` 为权威依据。
- `quiz.zh.json`：中文测验副本，stage、顺序和正确答案索引与官方完全一致。学习时不得提前公布正确答案。
- `outputs/prompt-optimizer-guide.zh.md`：中文版输出说明。
- `code/learn.ipynb`：个人学习记录，不得覆盖或清空。
- `source-manifest.json`：原始文件清单及 Git blob SHA，供完整性验证。

## 持续学习规则

进入下一课前先读 `learning-artifacts/cn/AGENTS.md`；必须递归查看官方课的全部文件并完成镜像与校验，不能只导入中文教材。学生独立计算和写代码，答题逐步验收，完成所有练习及 post-quiz 后更新根目录 `LEARNING.md`。
