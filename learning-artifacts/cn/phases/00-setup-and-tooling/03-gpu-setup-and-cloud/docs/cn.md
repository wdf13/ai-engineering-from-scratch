# GPU 配置与云

> 用 CPU 学习没问题。真要训练，需要 GPU。

**Type:** Build
**Languages:** Python
**Prerequisites:** Phase 0, Lesson 01
**Time:** ~45 minutes

## 学习目标

- 用 `nvidia-smi` 和 PyTorch 的 CUDA API 确认本机有没有 GPU
- 在 Google Colab 里选 T4 GPU，做免费的云端实验
- 对比 CPU / GPU 上的矩阵乘法，量加速比
- 用 fp16 经验法则估算显存里能塞下多大的模型

## 问题

Phase 1–3 多数课在 CPU 上就能跑。但从 CNN、Transformer、LLM（大约 Phase 4 起）开始，需要 GPU。CPU 上 8 小时的训练，GPU 上可能 10 分钟。

三条路：本机 GPU、云 GPU、Google Colab（免费）。

## 概念

```
你的选项：

1. 本机 NVIDIA GPU
   费用：0（已经有卡的话）
   配置：装 CUDA + cuDNN
   适合：日常用、大数据集

2. Google Colab（免费档）
   费用：0
   配置：无
   适合：快速实验、家里没卡

3. 云 GPU（Lambda、RunPod、Vast.ai）
   费用：$0.20–2.00/小时
   配置：SSH + 安装
   适合：认真训练、大模型
```

```figure
s0-gpu-dispatch
```

## 从零实现

### 选项 1：本机 NVIDIA GPU

先看有没有卡：

```bash
nvidia-smi
```

装带 CUDA 的 PyTorch：

```python
import torch

print(f"CUDA available: {torch.cuda.is_available()}")
print(f"CUDA version: {torch.version.cuda}")
if torch.cuda.is_available():
    print(f"GPU: {torch.cuda.get_device_name(0)}")
    print(f"Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.1f} GB")
```

### 选项 2：Google Colab

1. 打开 [colab.research.google.com](https://colab.research.google.com)
2. Runtime > Change runtime type > T4 GPU
3. 跑 `!nvidia-smi` 确认

可以把本课程的 notebook 直接传到 Colab。

### 选项 3：云 GPU

Lambda Labs、RunPod、Vast.ai 一类：

```bash
ssh user@your-gpu-instance

pip install torch torchvision torchaudio
python -c "import torch; print(torch.cuda.get_device_name(0))"
```

### 没有 GPU？也没问题

多数课能在 CPU 上跑。真正需要 GPU 的课会写明，并给 Colab 链接。

```python
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(f"Using: {device}")
```

## 从零实现：GPU vs CPU 基准

```python
import torch
import time

size = 5000

a_cpu = torch.randn(size, size)
b_cpu = torch.randn(size, size)

start = time.time()
c_cpu = a_cpu @ b_cpu
cpu_time = time.time() - start
print(f"CPU: {cpu_time:.3f}s")

if torch.cuda.is_available():
    a_gpu = a_cpu.to("cuda")
    b_gpu = b_cpu.to("cuda")

    torch.cuda.synchronize()
    start = time.time()
    c_gpu = a_gpu @ b_gpu
    torch.cuda.synchronize()
    gpu_time = time.time() - start
    print(f"GPU: {gpu_time:.3f}s")
    print(f"Speedup: {cpu_time / gpu_time:.0f}x")
```

## 练习

1. 跑上面的基准，对比 CPU 和 GPU 时间
2. 没有本地 GPU 就到 Google Colab 上跑，再对比
3. 看显存有多大，估算能塞下的最大模型（经验：fp16 每个参数 2 字节）

## 关键术语

| 术语 | 人们常说 | 实际含义 |
|------|----------|----------|
| CUDA | 「GPU 编程」 | NVIDIA 的并行计算平台，让代码跑在 GPU 上 |
| VRAM | 「显存」 | GPU 上的显存，和内存分开。限制模型能有多大 |
| fp16 | 「半精度」 | 16 位浮点，显存大约是 fp32 的一半，精度损失通常很小 |
| Tensor Core | 「专门算矩阵的硬件」 | GPU 上专做矩阵乘的单元，比普通核心快 4–8 倍 |
