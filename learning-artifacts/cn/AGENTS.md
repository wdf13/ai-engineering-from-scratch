# 个人中文学习镜像：持久化操作规则

**适用范围**：`learning-artifacts/cn/` 及其子目录，面向仓库 `wdf13/ai-engineering-from-scratch` 的 `my-progress` 学习分支。每次开始新课、继续旧课或从其他编程助手接手之前，优先读取本文件、根目录 `LEARNING.md`、该课 `README.md` 和学习 Notebook。

## 新课启动必须先执行：完整课程镜像

1. **先列清单**：查看权威目录 `phases/<阶段>/<课>/` 的实际递归文件树，列出 `docs/`、`code/`、`outputs/`、`quiz.json` 及其他所有文件。不能假设目录只含一篇讲义，不能只根据记忆枚举文件。
2. **整课复制**：在 `learning-artifacts/cn/phases/<阶段>/<课>/` 下严格保留全部官方文件的相对路径，原封不动复制英文文档、所有编程语言代码、原始 quiz、输出材料和其他官方文件。优先直接引用同一仓库的 Git blob SHA，保证镜像字节一致。
3. **中文辅助材料**：上游 `translations` 分支有中文课件就取出并存为 `docs/zh.md`，注明出处与翻译校对状态；官方 `docs/en.md` 保持原样。机器译文可能存在明显技术错误，必须对照英文，未经校对不得声称准确。
4. **测验与输出中文副本**：保留官方 `quiz.json` 与 `outputs/*` 不变；翻译用 `quiz.zh.json`、`outputs/<文件名>.zh.md` 等独立路径。中文 quiz 的 `stage`、题序、选项顺序及 `correct` 下标与官方严格一致；教学时不提前向学习者泄露答案。
5. **保留学习成果**：`code/learn.ipynb` 是独立的个人学习进度日志，只追加学生原始代码、回答、推导、真实运行的测试与讲评。任何批量镜像不得覆盖它，也不得覆盖以前记录。
6. **同步完成检查**：核对官方文件清单与镜像原始文件清单一一对应，检验 Git blob SHA 或内容一致；检查中文课件、测试及输出文件已落位，Notebook 可打开。验证完成后才开始新课教学。
7. **教学和成绩**：按一问一答方式让学习者独立计算与写代码；对结果进行数学检查及实际可运行测试。每次讲评保存到 `my-progress` 分支 Notebook；必须完成官方所有练习及后测才能将整课标记完成并更新 `LEARNING.md`。

## 官方课程顺序和评分检查点

- 每课完整镜像后先读取该课原版 `quiz.json`，按 `stage=pre` 的原始次序逐题完成前测；不得在学生作答前透露 `correct` 或解析。前后测的题数以该课 JSON 为准，不能推测。
- 然后依照 `docs/en.md` 的顺序推进目标、Problem、Concept、Build It 各步骤、Use It、Ship It、全部 Exercises，最后依次进行 `stage=post` 正式后测。补充推导、代码和测试应注明“补充”，不可替代官方练习。
- 每次保留学生原始提交、验收与真实验证结果；只有所有 Exercises 和 Post Quiz 完成才标记整课完成，更新根目录 `LEARNING.md`。
- 如果误漏前测，只能迟做并标注“补做前测，非真实课前基线”，补做后恢复原先教学进度，不抹除既有作答。

## Git 工作流

本地仓库位于 WSL `~/ai-engineering-from-scratch`。在本地学习前先看 `git status`，处理未提交修改后执行 `git fetch origin`、`git switch my-progress`、`git pull --ff-only origin my-progress`。绝不以强制重置的方式丢弃用户文件。

## 权威性与存储边界

官方 `phases/` 是原文及代码权威来源；`learning-artifacts/cn` 是学习副本，`LEARNING.md` 是跨课状态。此文件是可被后续 GitHub/编程助手主动读取的**仓库级持久说明**，不代表已直接修改 ChatGPT 产品内部的项目记忆或项目设置。
