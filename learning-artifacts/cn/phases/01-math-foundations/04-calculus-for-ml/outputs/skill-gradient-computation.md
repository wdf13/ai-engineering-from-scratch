---
name: skill-gradient-computation
description: 计算常见机器学习损失函数的梯度，并选择合适的求导方式
version: 1.0.0
phase: 1
lesson: 4
tags: [calculus, gradients, backpropagation]
---

# 机器学习里的梯度计算

神经网络里损失函数、激活函数和层运算的梯度，按这张表选用算法。

## 选择清单

1. 函数是幂、指数、对数、三角函数这些基本块拼出来的：用手算解析导数和链式法则。
2. 函数是自定义的，或者内部看不见：用数值微分 `(f(x+h) - f(x-h)) / (2h)`，`h = 1e-7`。
3. 函数是 PyTorch 或 JAX 里的张量运算：交给自动微分。再用数值微分核对。
4. 需要标量损失对一整张权重矩阵的梯度：沿着计算图，一个节点一个节点用链式法则往回乘。
5. 中间有不可导运算（argmax、取整、抽样）：用 straight-through 估计，或重参数化。

## 四种做法何时用

| 做法 | 何时用 | 代价 |
|---|---|---|
| 解析导数（手推） | 简单函数，核对自动微分的输出 | 运行时不另算 |
| 数值导数（有限差分） | 调试、梯度检查、黑盒函数 | n 个参数要做 2n 次前向 |
| 自动微分 | 任何可微计算图，默认选择 | 一次反向 |
| 符号计算（SymPy、Mathematica） | 为论文推导闭式梯度 | 只在推导时花费 |

## 常见导数

| 函数 | f(x) | f'(x) | 用在哪里 |
|---|---|---|---|
| 均方误差 | (1/n) sum(y_hat - y)^2 | (2/n)(y_hat - y) | 回归 |
| 二元交叉熵 | -(y log(p) + (1-y) log(1-p)) | 经过 sigmoid 之后是 p - y | 二分类 |
| 多类交叉熵 | -log(p_true_class) | 经过 softmax 之后是 p - one_hot(y) | 多分类 |
| Sigmoid | 1 / (1 + e^(-x)) | sigma(x) * (1 - sigma(x)) | 输出门、二分类输出 |
| Tanh | (e^x - e^(-x)) / (e^x + e^(-x)) | 1 - tanh(x)^2 | 早期隐藏层激活 |
| ReLU | max(0, x) | x > 0 时为 1，x < 0 时为 0 | 默认隐藏层激活 |
| Leaky ReLU | max(0.01x, x) | x > 0 时为 1，x < 0 时为 0.01 | 减轻神经元死亡 |
| GELU | x * Phi(x) | Phi(x) + x * phi(x) | Transformer |
| Softmax 第 i 项 | e^(x_i) / sum(e^(x_j)) | i=j 时 s_i(1-s_i)，i≠j 时 -s_i s_j | 输出层的雅可比 |
| Log-softmax | x_i - log(sum(e^(x_j))) | 第 i 项是 1 - softmax(x_i) | 数值稳定的交叉熵 |
| 线性层 | y = Wx + b | dL/dW = dL/dy * x^T，dL/db = dL/dy | 每一层 |
| L2 正则 | lambda * sum(w^2) | 2 * lambda * w | 权重衰减 |
| L1 正则 | lambda * sum(\|w\|) | lambda * sign(w) | 稀疏 |

## 常见错误

- 按批平均的损失（均方误差、交叉熵）忘了 `1/n`。梯度会被批大小缩放。
- 把 softmax 的梯度当成一个向量。它其实是雅可比矩阵。交叉熵和 softmax 合在一起时，梯度简化成 `p - y`，不必展开整张雅可比。
- 链式法则乘反了。从损失往回走：`dL/dW = dL/dy * dy/dW`。
- 数值导数的 `h` 太大（`0.1`）或太小（`1e-15`）。float64 用 `h = 1e-7`。
- 忘了 ReLU 在恰好 `x = 0` 时导数没有定义。实践里把它定成 0 或 0.5。

## 梯度检查

```text
对每个参数 w：
  numeric_grad = (loss(w + h) - loss(w - h)) / (2h)
  auto_grad = 反向传播得到的值
  relative_error = |numeric - auto| / max(|numeric|, |auto|, 1e-8)
  要求 relative_error < 1e-5
```

相对误差大于 `1e-3` 说明算错了。落在 `1e-5` 和 `1e-3` 之间时要查原因。
