# Python 环境

> 依赖地狱是真的。虚拟环境是解药。

**Type:** Build
**Languages:** Shell
**Prerequisites:** Phase 0, Lesson 01
**Time:** ~30 minutes

## 学习目标

- 用 `uv`、`venv` 或 `conda` 建隔离的虚拟环境
- 写 `pyproject.toml`（含可选依赖组），并生成 lockfile 保证可复现
- 诊断并修复：全局安装、pip/conda 混用、CUDA 版本不匹配
- 为依赖冲突的项目做「按阶段分环境」的策略

## 问题

你给微调项目装了 PyTorch 2.4。下周另一个项目需要 PyTorch 2.1（CUDA 构建被钉死）。全局升级，第一个项目坏了；降回去，第二个又坏了。

这就是依赖地狱。AI/ML 里天天发生，因为：

- PyTorch、JAX、TensorFlow 各自带 CUDA 绑定
- 模型库会钉死框架版本
- 一次全局 `pip install` 会覆盖原来的包
- CUDA 11.8 的构建不能和 CUDA 12.x 驱动混用（反过来也不行）

办法：每个项目自己的隔离环境、自己的包。

## 概念

没有虚拟环境时，系统里只能有一个 `torch` 版本。有虚拟环境时，项目 A 的 `.venv/` 里可以是 torch 2.4，项目 B 里可以是 2.1，互不影响。

```figure
s0-env-isolation
```

## 从零实现

### 方案 1：uv venv（推荐）

`uv` 是目前最快的 Python 包管理器（通常比 pip 快 10–100 倍）。虚拟环境、Python 版本、依赖解析一个工具做完。

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh

uv python install 3.12

cd your-project
uv venv
source .venv/bin/activate
```

装包：

```bash
uv pip install torch numpy
```

一步建项目和 `pyproject.toml`：

```bash
uv init my-ai-project
cd my-ai-project
uv add torch numpy matplotlib
```

### 方案 2：venv（自带）

装不了 `uv` 时，用标准库 `venv`：

```bash
python3 -m venv .venv
source .venv/bin/activate  # Linux/macOS
.venv\Scripts\activate     # Windows

pip install torch numpy
```

比 `uv` 慢，但有 Python 就能用。

### 方案 3：conda（需要时才用）

Conda 能管非 Python 依赖：CUDA toolkit、cuDNN、C 库。适合：

- 要特定 CUDA toolkit、又不想装进系统
- 共享集群上不能装系统包
- 某库的安装说明写「用 conda」

```bash
# 装 miniconda（不要装完整 Anaconda）
curl -LsSf https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh
bash miniconda.sh -b

conda create -n myproject python=3.12
conda activate myproject

conda install pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia
```

一条规则：这个环境用 conda 建的，包也尽量用 conda 装。在 conda 环境里再 `pip install`，依赖跟踪会乱，很难查。

### 这门课：按阶段分环境

整门课共用一个环境也可以，但不要这么干。不同阶段的依赖有时会冲突。

策略：

```
ai-engineering-from-scratch/
├── .venv/                    <-- Phase 0-3 的轻量共用环境
├── phases/
│   ├── 04-neural-networks/
│   │   └── .venv/            <-- PyTorch 环境
│   ├── 05-cnns/
│   │   └── .venv/            <-- 同一套 PyTorch（符号链接或共用）
│   ├── 08-transformers/
│   │   └── .venv/            <-- 可能需要不同的 transformers 版本
│   └── 11-llm-apis/
│       └── .venv/            <-- API SDK，不必装 torch
```

`code/env_setup.sh` 会在仓库根目录建本课用的基础环境。

## pyproject.toml 基础

每个 Python 项目都应有 `pyproject.toml`。它替代 `setup.py`、`setup.cfg` 和 `requirements.txt`。

```toml
[project]
name = "ai-engineering-from-scratch"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "numpy>=1.26",
    "matplotlib>=3.8",
    "jupyter>=1.0",
    "scikit-learn>=1.4",
]

[project.optional-dependencies]
torch = ["torch>=2.3", "torchvision>=0.18"]
llm = ["anthropic>=0.39", "openai>=1.50"]
```

然后安装：

```bash
uv pip install -e ".[torch]"    # 基础 + PyTorch
uv pip install -e ".[llm]"     # 基础 + LLM SDK
uv pip install -e ".[torch,llm]" # 全装
```

## Lockfile

Lockfile 把每个依赖（含间接依赖）钉到精确版本。谁按 lockfile 装，得到的包就一样。

```bash
# 用 uv add 时会自动生成 uv.lock
uv add numpy

# pip-tools 写法
uv pip compile pyproject.toml -o requirements.lock
uv pip install -r requirements.lock
```

把 lockfile 提交进 git。别人 clone 之后按 lockfile 装，版本就一致。

## 常见错误

### 1. 装到全局

```bash
pip install torch  # 不好：装进系统 Python

source .venv/bin/activate
pip install torch  # 好：装进虚拟环境
```

看包装到哪：

```bash
which python       # 应是 .venv/bin/python，不是 /usr/bin/python
which pip          # 应是 .venv/bin/pip
```

### 2. pip 和 conda 混用

```bash
conda create -n myenv python=3.12
conda activate myenv
conda install pytorch -c pytorch
pip install some-other-package   # 不好：会打乱 conda 的依赖跟踪
conda install some-other-package # 好：让 conda 管全部
```

必须在 conda 里用 pip 时（有的包只有 pip）：先把 conda 包装完，pip 放最后。

### 3. 忘记激活

```bash
python train.py           # 系统 Python，缺包
source .venv/bin/activate
python train.py           # 项目 Python，包在
```

提示符里应出现环境名：

```
(.venv) $ python train.py
```

### 4. 把 .venv 提交进 git

```bash
echo ".venv/" >> .gitignore
```

虚拟环境往往 200MB–2GB，不能跨机器拷。提交 `pyproject.toml` 和 lockfile。

### 5. CUDA 版本不匹配

```bash
nvidia-smi                # 驱动 CUDA 版本（例如 12.4）
python -c "import torch; print(torch.version.cuda)"  # PyTorch 的 CUDA 版本

# 两者必须兼容。
# PyTorch 的 CUDA 版本必须 <= 驱动 CUDA 版本。
```

## 用生产工具

跑安装脚本，创建本课环境：

```bash
bash phases/00-setup-and-tooling/06-python-environments/code/env_setup.sh
```

它会在仓库根目录建 `.venv`，装核心依赖并做检查。

## 练习

1. 跑 `env_setup.sh`，确认检查全过
2. 再建一个虚拟环境，装不同版本的 numpy，确认两个环境互相隔离
3. 写一份同时需要 PyTorch 和 Anthropic SDK 的 `pyproject.toml`（你可以用 openai/DeepSeek 代替 Anthropic）
4. 故意不激活 venv 做一次全局安装，看包装到哪，然后卸掉

## 关键术语

| 术语 | 人们常说 | 实际含义 |
|------|----------|----------|
| Virtual environment | 「一个 venv」 | 独立目录，里面有一套 Python 解释器和包，和系统 Python 分开 |
| Lockfile | 「钉死的依赖」 | 列出每个包的精确版本，保证各台机器装出来一样 |
| pyproject.toml | 「新的 setup.py」 | 标准的 Python 项目配置，替代 setup.py / setup.cfg / requirements.txt |
| Transitive dependency | 「依赖的依赖」 | 你装 A，A 依赖 B，B 依赖 C，则 C 是 A 的间接依赖 |
| CUDA mismatch | 「GPU 不能用」 | PyTorch 编译时的 CUDA 版本和当前驱动支持的版本对不上 |
