# 向量、矩阵与运算

> 每个神经网络，本质上都是多了几步额外工序的矩阵乘法。

**Type:** Build
**Languages:** Python, Julia
**Prerequisites:** Phase 1, Lesson 01 (线性代数直觉)
**Time:** ~60 minutes

## 学习目标

- 从零构建支持逐元素运算、矩阵乘法、转置、行列式和逆矩阵的 `Matrix` 类
- 明确区分逐元素相乘（Hadamard 积）与矩阵乘法，说明各自适用的场景
- 仅用手写的 `Matrix` 类实现单层稠密神经网络（`relu(W @ x + b)`）的前向传播
- 阐明广播（Broadcasting）规则，以及深度学习框架中偏置项（Bias）加法的底层工作机制

## 问题

当你想要构建一个神经网络并阅读源码时，经常会看到这一行：

```python
output = activation(weights @ input + bias)
```

这里的 `@` 是矩阵乘法，`weights` 是权重矩阵，`input` 是输入向量。如果你不知道这些运算的底层机制，这行代码就像黑盒魔法；但如果你亲自实现过它们，你就会明白：**整整一个神经网络层的全部前向传播，就被浓缩在这三步运算之中**。

模型处理的每一张图片都是像素值构成的矩阵；每个词嵌入（Word Embedding）都是一个高维向量；神经网络的每一层都是一次矩阵几何变换。如果你不能像理解变量一样熟练掌握矩阵运算，你就无法真正构建、调试和优化 AI 系统。

本课将带你从零手搓这些运算，彻底打破黑盒。

## 概念

### 向量：有序的数字列表

向量是带有方向和长度的数字列表。在 AI 中，向量用于表示数据点、特征或模型参数。

```text
v = [3, 4]        -- 二维向量
w = [1, 0, -2]    -- 三维向量
```

二维向量 `[3, 4]` 从坐标原点指向平面上的 $(3, 4)$ 点，其长度（模长）为 5（经典的 3-4-5 勾股数）。

### 矩阵：二维数字网格

矩阵是一个二维网格，包含行（rows）和列（columns）。一个 $m \times n$ 的矩阵拥有 $m$ 行和 $n$ 列。

```text
A = | 1  2  3 |     -- 2x3 矩阵（2 行 3 列）
    | 4  5  6 |
```

在神经网络中，权重矩阵将输入向量变换为输出向量。一个具有 784 个输入特征、128 个输出神经元的网络层，使用的是一个 $128 \times 784$ 的权重矩阵。

### 为什么形状（Shapes）至关重要

矩阵乘法必须遵循严格的维度守恒规则：
$$(m \times n) @ (n \times p) = (m \times p)$$

**内层维度必须完全相等**：

```text
(128 x 784) @ (784 x 1) = (128 x 1)
  权重矩阵      输入向量      输出向量

内层维度: 784 = 784  -- 合法有效
```

如果你在 PyTorch 中遇到 `RuntimeError: size mismatch` 形状不匹配报错，根源就在这里。

### 核心运算全景图

| 运算 | 几何与数学含义 | 神经网络中的具体用途 |
|---|---|---|
| 加法（Addition） | 逐元素合并 | 为网络层输出叠加偏置项（Bias） |
| 标量乘法（Scalar multiply） | 等比例缩放每一个元素 | 学习率乘梯度更新参数（$\text{lr} \times \text{grad}$） |
| 矩阵乘法（Matrix multiply） | 空间维度投影与特征重组 | 神经网络各层的前向传播（Forward pass） |
| 转置（Transpose） | 交换行和列（对角线翻转） | 反向传播中梯度的反向映射传导 |
| 行列式（Determinant） | 变换对空间体积的缩放比例 | 检验矩阵是否可逆、空间是否塌缩 |
| 逆矩阵（Inverse） | 撤销（逆转）一个几何变换 | 求解线性方程组、正规方程解析解 |
| 单位矩阵（Identity） | 恒等变换（什么都不变） | 参数正交初始化、ResNet 残差连接 |

### 逐元素相乘 vs 矩阵乘法

这是让无数初学者踩坑的根本区别：

- **逐元素相乘（Element-wise, Hadamard 积）**：两个矩阵形状必须完全相同，对应位置数字相乘：

```text
| 1  2 |   | 5  6 |   | 1*5  2*6 |   |  5  12 |
| 3  4 | * | 7  8 | = | 3*7  4*8 | = | 21  32 |
```

- **矩阵乘法（Matrix multiplication）**：第 $i$ 行与第 $j$ 列做点积，内层维度必须对齐：

```text
| 1  2 |   | 5  6 |   | 1*5+2*7  1*6+2*8 |   | 19  22 |
| 3  4 | @ | 7  8 | = | 3*5+4*7  3*6+4*8 | = | 43  50 |
```

不同的运算，不同的规则，完全不同的数学输出。

### 广播机制（Broadcasting）

当你将一个 $1 \times 3$ 的偏置向量加到一个 $2 \times 3$ 的输出矩阵上时，两者的形状并不严格一致。**广播机制** 会沿着缺失的维度自动拉伸复制较小的数组，使其与大数组对齐：

```text
| 1  2  3 |   +   [10, 20, 30]
| 4  5  6 |

广播机制将偏置向量沿行方向拉伸：

| 1  2  3 |   | 10  20  30 |   | 11  22  33 |
| 4  5  6 | + | 10  20  30 | = | 14  25  36 |
```

现代主流深度学习框架（NumPy、PyTorch、TensorFlow）都在底层自动完成了这种广播扩展。

## 动手构建（Build It）

### 第一步：Vector 向量类

```python
class Vector:
    def __init__(self, data):
        self.data = list(data)
        self.size = len(self.data)

    def __repr__(self):
        return f"Vector({self.data})"

    def __add__(self, other):
        return Vector([a + b for a, b in zip(self.data, other.data)])

    def __sub__(self, other):
        return Vector([a - b for a, b in zip(self.data, other.data)])

    def __mul__(self, scalar):
        return Vector([x * scalar for x in self.data])

    def dot(self, other):
        return sum(a * b for a, b in zip(self.data, other.data))

    def magnitude(self):
        return sum(x ** 2 for x in self.data) ** 0.5
```

### 第二步：Matrix 矩阵类与核心运算

```python
class Matrix:
    def __init__(self, data):
        self.data = [list(row) for row in data]
        self.rows = len(self.data)
        self.cols = len(self.data[0])
        self.shape = (self.rows, self.cols)

    def __repr__(self):
        rows_str = "\n  ".join(str(row) for row in self.data)
        return f"Matrix({self.shape}):\n  {rows_str}"

    def __add__(self, other):
        return Matrix([
            [self.data[i][j] + other.data[i][j] for j in range(self.cols)]
            for i in range(self.rows)
        ])

    def __sub__(self, other):
        return Matrix([
            [self.data[i][j] - other.data[i][j] for j in range(self.cols)]
            for i in range(self.rows)
        ])

    def scalar_multiply(self, scalar):
        return Matrix([
            [self.data[i][j] * scalar for j in range(self.cols)]
            for i in range(self.rows)
        ])

    def element_wise_multiply(self, other):
        return Matrix([
            [self.data[i][j] * other.data[i][j] for j in range(self.cols)]
            for i in range(self.rows)
        ])

    def matmul(self, other):
        return Matrix([
            [
                sum(self.data[i][k] * other.data[k][j] for k in range(self.cols))
                for j in range(other.cols)
            ]
            for i in range(self.rows)
        ])

    def transpose(self):
        return Matrix([
            [self.data[j][i] for j in range(self.rows)]
            for i in range(self.cols)
        ])

    def determinant(self):
        if self.shape == (1, 1):
            return self.data[0][0]
        if self.shape == (2, 2):
            return self.data[0][0] * self.data[1][1] - self.data[0][1] * self.data[1][0]
        det = 0
        for j in range(self.cols):
            minor = Matrix([
                [self.data[i][k] for k in range(self.cols) if k != j]
                for i in range(1, self.rows)
            ])
            det += ((-1) ** j) * self.data[0][j] * minor.determinant()
        return det

    def inverse_2x2(self):
        det = self.determinant()
        if det == 0:
            raise ValueError("矩阵为奇异矩阵，不存在逆矩阵")
        return Matrix([
            [self.data[1][1] / det, -self.data[0][1] / det],
            [-self.data[1][0] / det, self.data[0][0] / det]
        ])

    @staticmethod
    def identity(n):
        return Matrix([
            [1 if i == j else 0 for j in range(n)]
            for i in range(n)
        ])
```

### 第三步：验证基本运算

```python
A = Matrix([[1, 2], [3, 4]])
B = Matrix([[5, 6], [7, 8]])

print("A + B =", (A + B).data)
print("A @ B =", A.matmul(B).data)
print("A^T =", A.transpose().data)
print("det(A) =", A.determinant())
print("A^-1 =", A.inverse_2x2().data)

I = Matrix.identity(2)
print("A @ A^-1 =", A.matmul(A.inverse_2x2()).data)
```

### 第四步：纯手搓一个真实的神经网络层

```python
import random

inputs = Matrix([[0.5], [0.8], [0.2]])
weights = Matrix([
    [random.uniform(-1, 1) for _ in range(3)]
    for _ in range(2)
])
bias = Matrix([[0.1], [0.1]])

def relu_matrix(m):
    return Matrix([[max(0, val) for val in row] for row in m.data])

pre_activation = weights.matmul(inputs) + bias
output = relu_matrix(pre_activation)

print(f"输入形状: {inputs.shape}")
print(f"权重形状: {weights.shape}")
print(f"输出形状: {output.shape}")
print(f"前向传播输出值: {output.data}")
```

这就是一个纯原生的单层稠密前馈神经网络：`output = relu(W @ x + b)`。任何深层大模型中的 Dense 层，其前向计算本质完全一致。

## 生产对比（Use It）

在实际工程中，NumPy 只需几行代码就能完成上述全部操作，而且速度快几个数量级：

```python
import numpy as np

A = np.array([[1, 2], [3, 4]])
B = np.array([[5, 6], [7, 8]])

print("A + B =\n", A + B)
print("A * B (逐元素乘积) =\n", A * B)
print("A @ B (矩阵乘法) =\n", A @ B)
print("A^T =\n", A.T)
print("det(A) =", np.linalg.det(A))
print("A^-1 =\n", np.linalg.inv(A))
print("单位矩阵 I =\n", np.eye(2))

# 神经网络层前向传播
inputs = np.random.randn(3, 1)
weights = np.random.randn(2, 3)
bias = np.array([[0.1], [0.1]])
output = np.maximum(0, weights @ inputs + bias)

print(f"\n神经网络层: {weights.shape} @ {inputs.shape} = {output.shape}")
print(f"输出:\n{output}")
```

NumPy 的 `@` 底层直接调用由 C 和 Fortran 编写的高性能 BLAS 库，数学原理完全相同，但性能提升上百倍。

NumPy 中的广播机制示例：
```python
matrix = np.array([[1, 2, 3], [4, 5, 6]])
bias = np.array([10, 20, 30])
print(matrix + bias)
```
NumPy 自动将 1D 偏置沿两个行广播扩展。这正是 PyTorch 等框架给 batch 数据叠加 bias 的底层机制。

## 产出物（Ship It）

本课产出了一个通过几何直觉讲解矩阵运算的提示词模版：`outputs/prompt-matrix-operations.md`。

你在本课手写的 `Matrix` 类，将成为我们在 Phase 3 第 10 课从零构建微型神经网络框架的基石。

## 课后练习（Exercises）

1. **验证逆矩阵**：计算 $A @ A^{-1}$，确认结果为单位矩阵 $I$。尝试 3 个不同的 $2 \times 2$ 矩阵。当行列式为 0 时会发生什么？
2. **实现 3x3 逆矩阵**：扩展 `Matrix` 类，使用伴随矩阵法（Adjugate method）计算 $3 \times 3$ 矩阵的逆，并与 `np.linalg.inv` 交叉对比结果。
3. **搭建双层神经网络**：仅使用手写的 `Matrix` 类，搭建一个输入维度 3 $\to$ 隐藏层 4 $\to$ 输出层 2 的双层网络，初始化随机权重并验证前向传播输出维度。

## 核心术语对照表

| 术语 | 常见通俗误解 | 精准数学与工程定义 |
|---|---|---|
| Vector（向量） | “带箭头的线” | 有序数字列表。在 AI 中代表高维空间中的语义或特征点。 |
| Matrix（矩阵） | “一个二维数字表格” | 线性变换映射。将向量从一个特征空间映射到另一个特征空间。 |
| Matrix multiply（矩阵乘法） | “数字对应相乘” | 前者各行与后者各列的点积。顺序不可随意颠倒（$A @ B \neq B @ A$）。 |
| Transpose（转置） | “把矩阵翻一下” | 交换行和列。将 $m \times n$ 变为 $n \times m$，在反向传播中用于逆向映射梯度。 |
| Determinant（行列式） | “矩阵算出来的一个数字” | 衡量变换对二维面积或三维体积缩放的倍率。为 0 代表空间被压扁降维，无法恢复。 |
| Inverse（逆矩阵） | “矩阵的倒数” | 能够完全撤销原变换的逆向矩阵。仅在行列式不为 0（非奇异）时存在。 |
| Identity matrix（单位矩阵） | “对角线是 1 的无聊矩阵” | 相当于矩阵乘法中的“数字 1”。在 ResNet 残差连接和正交初始化中是绝对核心。 |
| Broadcasting（广播机制） | “自动补全维度的黑魔法” | 沿缺失或长度为 1 的轴拉伸较小数组，使其在不实际拷贝内存的前提下与大数组对齐。 |
| Element-wise（逐元素运算） | “普通乘法” | 对应坐标位置的数字各自相乘。在注意力 Mask 和激活函数中广泛使用。 |
