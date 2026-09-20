# My AI Engineering Path
<!-- Managed by the ai-engineering-from-scratch learning skills.
     Repo: https://github.com/rohitg00/ai-engineering-from-scratch -->

## Mission
做一个具体的产品；本人是软件工程研究生，需要研究 AI 工程这一方向。学完要能自己搭建 agent、自己搭建各类模型，并对各类模型做进一步研究。授课用简体中文。日常学习目录在 WSL Ubuntu：`/home/wang/ai-engineering-from-scratch`。先学完 Phase 0 全 12 课（第一章：环境与工具），在 WSL 里把环境配齐；GPU 训练走服务器（MCP 给助手用）。再补线性代数、梯度、链式法则，然后走 3→7→10→11→13→14。卡住就按缺口补课，不回头重走整阶段。

## Loop
一课一个圈，圈圈相同。你做主，我当教练。

1. 开课：我给出本课路径，并写好中文对照 `learning-artifacts/cn/phases/<阶段>/<课>/docs/cn.md`（官方 `docs/en.md` 不动）。
2. 你读：先读对照里的「问题 + 概念」，用自己的话发我 3～5 句。我只纠正理解，不出选择题，不替你总结完。
3. 你写：按「从零实现」自己打代码或命令。写在 `learning-artifacts/cn/phases/<阶段>/<课>/code/` 里，或把代码贴到对话。我可以指出下一小段该写什么，但不替你写完、不先跑官方现成脚本当你的作业。
4. 你跑：从仓库根目录执行。把命令、退出码、关键输出发我。退出码 0 表示进程正常结束；非 0 是失败，我们一起看报错。
5. 你改：在不看答案的前提下改一小处，确认不是抄通的。
6. 课末测：题目来自该课官方 `quiz.json` 的 `post` 题（通常 2～3 道），中文题干，选项只留题面。先答后讲。低于 70% 进入 Review queue。
7. 收尾：我把日期、课号、分数、一句笔记写入 `LEARNING.md`。下一课从第 1 步再转一圈。

我在中间做的事：译对照、盯循环不被跳过、在你写/跑之后给反馈、课末按 `quiz.json` 提问、记进度。我不做的事：提问前把答案写进讲解、用选项说明暗示对错、用跑通官方 `code/` 代替你动手。

## Placement
- Date: 2026-09-20
- Score: self-selected
- Entry point: Phase 0 Setup & Tooling（第一章整章学完，再进数学和主线）
- Pace: ~30 hours/week

## Path
| Phase | Name | Status | Est. hours |
|-------|------|--------|------------|
| 0 | Setup & Tooling | Do | 14 |
| 1 | Math Foundations | Skip | -- |
| 2 | ML Fundamentals | Skip | -- |
| 3 | Deep Learning Core | Do | 15 |
| 4 | Computer Vision | Skip | -- |
| 5 | NLP — Foundations to Advanced | Skip | -- |
| 6 | Speech & Audio | Skip | -- |
| 7 | Transformers Deep Dive | Do | 14 |
| 8 | Generative AI | Skip | -- |
| 9 | Reinforcement Learning | Skip | -- |
| 10 | LLMs from Scratch | Do | 26 |
| 11 | LLM Engineering | Do | 17 |
| 12 | Multimodal AI | Skip | -- |
| 13 | Tools & Protocols | Do | 43 |
| 14 | Agent Engineering | Do | 55 |
| 15 | Autonomous Systems | Do | 20 |
| 16 | Multi-Agent & Swarms | Do | 28 |
| 17 | Infrastructure & Production | Do | 32 |
| 18 | Ethics, Safety & Alignment | Do | 31 |
| 19 | Capstone Projects | Do | 620 |

## Progress log
| Date | Lesson | Quiz | Note |
|------|--------|------|------|
| 2026-09-20 | 00/01-dev-environment | 2/3 | WSL 入门预检 2/2，Node/cargo/Julia/PyTorch 均为 PASS；加速器 CPU only。课末曾把 `torch.__version__` 当成 GPU 检查。 |

## Review queue
- 00/01-dev-environment：如何确认 PyTorch 能用到 GPU（`torch.cuda.is_available()`，Apple 上是 MPS；`__version__` 只说明装了哪一版）
