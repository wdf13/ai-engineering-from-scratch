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
| 0 | Setup & Tooling | Done | 14 |
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
| 2026-09-24 | 00/10-terminal-and-shell | 3/3 | 掌握管道与重定向 (2>&1, dup2)、awk 列切分；搞透 SIGHUP 与 tmux 守护；SSH -L 端口转发与 find/xargs 机制全通。 |
| 2026-10-09 | 00/11-linux-for-ai | 3/3 | 掌握单根文件树、八进制权限掩码 (4-2-1)、apt 换源排错；理解 tmux Client-Server 架构；搞透网络下载与跨平台 sed 差异。 |
| 2026-10-09 | 00/12-debugging-and-profiling | 3/3 | 搞透 AI 三层调试模型；掌握 CUDA 异步与 Timer 测时陷阱；搞懂 Caching Allocator 显存保留机制；掌握 Forward Hook 查 shape、detect_nan 溯源与条件断点。 |
| 2026-10-09 | 01/01-linear-algebra-intuition | 3/3 | 掌握点积语义与余弦相似度；纯手写投影与正交化残差垂直；推通 90 度旋转矩阵与高斯消元求秩；搞透 LoRA 低秩分解 (4096x4096 -> 16 维分解 128x 压缩)。 |
| 2026-10-12 | 01/02-vectors-matrices-operations | 2/2 | 手写 Vector/Matrix 与两层前向；NumPy det 为 -2.0000000000000004；3×3 逆与 np.linalg.inv 一致；曾把 b2 记成 (4, 1)。 |
| 2026-10-12 | 01/03-matrix-transformations | 3/3 | 旋转矩阵由两列落点推出；曾把缩放 (2, 0.5) 的高说成 1；行列式是带符号面积；三次复合的 det 等于各 det 之积 1.2。 |
| 2026-10-14 | 01/04-calculus-for-ml | 3/3 | 数值导数与 2x 差约 1e-9；牛顿步对 x² 一步到 0；直线近似在 h=2 时 sin 差约 1.09；动量冲过井底翻到另一侧。 |
| 2026-10-14 | 01/05-chain-rule-and-autodiff | 3/3 | 手写 Value 得到 dy/dx1=3、dy/dx2=2；同一 x 两路梯度 3+1=4，不清零再反向变 8；XOR 损失从 4.15 降到 0.18，预测符号正确。 |
| 2026-10-21 | 01/06-probability-and-distributions | 3/3 | 完成 PMF/PDF、常见分布、CLT 与 Box–Muller；手写 Softmax/Log-Softmax/交叉熵、指数逆变换、独立骰子联合分布及序列 log 概率，SciPy/PyTorch 对照通过。曾困惑为什么 F⁻¹(U) 能采样，经 CDF 概率证明厘清；注意 log 域下溢与 PyTorch CE 需输入 logits。 |

## Review queue
- 00/01-dev-environment：如何确认 PyTorch 能用到 GPU（`torch.cuda.is_available()`，Apple 上是 MPS；`__version__` 只说明装了哪一版）
- 00/03-gpu-setup-and-cloud：`torch.cuda.synchronize()` 是等 GPU 算完再停表，不是 `.to("cuda")` 拷数据
