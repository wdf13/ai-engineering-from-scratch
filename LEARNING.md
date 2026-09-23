# My AI Engineering Path
<!-- Managed by the ai-engineering-from-scratch learning skills.
     Repo: https://github.com/rohitg00/ai-engineering-from-scratch -->

## Mission
做一个具体的产品；本人是软件工程研究生，需要研究 AI 工程这一方向。学完要能自己搭建 agent、自己搭建各类模型，并对各类模型做进一步研究。用简体中文授课；日常目录 WSL `~/ai-engineering-from-scratch`；LLM 调用可用 DeepSeek。先学完 Phase 0，再补线性代数/梯度/链式法则，然后 3→7→10→11→13→14。

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
| 2026-09-20 | 00/02-git-and-collaboration | 3/3 | origin=fork wdf13，upstream=官方；分支 my-progress 已 SSH push。 |
| 2026-09-21 | 00/03-gpu-setup-and-cloud | 2/3 | WSL 无 nvidia-smi/cuda False；服务器 gtg_b2_a100 上 A100 4000² 约 3x。synchronize 误当成拷数据。 |
| 2026-09-21 | 00/04-apis-and-keys | 3/3 | DeepSeek-flash：SDK 与裸 HTTP 均通；401 后改密钥。Anthropic 头仍用 x-api-key。 |
| 2026-09-21 | 00/05-jupyter-notebooks | 3/3 | WSL 内核 .venv；%timeit 练习 + Restart & Run All 全绿。 |
| 2026-09-21 | 00/06-python-environments | 3/3 | env_setup 复用 .venv 全过；iso-demo 三套 numpy 隔离；pyproject 含 torch/llm 可选组。练习 4：系统 Python 触发 PEP 668，未 --break-system-packages。 |
| 2026-09-23 | 00/07-docker-for-ai | 3/3 | WSL hello-world 通过。未构建 ai-dev 大镜像；gpu3 上 Toolkit 已装，wzh 不在 docker 组。 |
| 2026-09-23 | 00/08-editor-setup | 3/3 | WSL 里已有标尺、Black、终端拆分；Remote SSH 用已有 gpu3 别名。 |
| 2026-09-23 | 00/09-data-management | 3/3 | IMDB 25000/25000；wiki 流式 5 条（配置改为 20231101.en）；CSV 1.3M vs Parquet 804K；划分 17500/2500/5000。 |

## Review queue
- 00/01-dev-environment：如何确认 PyTorch 能用到 GPU（`torch.cuda.is_available()`，Apple 上是 MPS；`__version__` 只说明装了哪一版）
- 00/03-gpu-setup-and-cloud：`torch.cuda.synchronize()` 是等 GPU 算完再停表，不是 `.to("cuda")` 拷数据
