import random


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

    def normalize(self):
        mag = self.magnitude()
        return Vector([x / mag for x in self.data])


class Matrix:
    def __init__(self, data):
        self.data = [list(row) for row in data]
        self.rows = len(self.data)
        self.cols = len(self.data[0])
        self.shape = (self.rows, self.cols)

    def __repr__(self):
        col_widths = []
        for j in range(self.cols):
            width = max(len(f"{self.data[i][j]:.4f}") for i in range(self.rows))
            col_widths.append(width)
        lines = []
        for i in range(self.rows):
            row_str = "  ".join(
                f"{self.data[i][j]:{col_widths[j]}.4f}" for j in range(self.cols)
            )
            bracket_l = "|" if 0 < i < self.rows - 1 else ("/" if i == 0 else "\\")
            bracket_r = "|" if 0 < i < self.rows - 1 else ("\\" if i == 0 else "/")
            lines.append(f"  {bracket_l} {row_str} {bracket_r}")
        header = f"Matrix {self.rows}x{self.cols}:"
        return header + "\n" + "\n".join(lines)

    def __add__(self, other):
        if isinstance(other, Matrix):
            # 情况 1: 形状完全相同
            if other.shape == self.shape:
                return Matrix([
                    [self.data[i][j] + other.data[i][j] for j in range(self.cols)]
                    for i in range(self.rows)
                ])
            # 情况 2: 偏置行广播 (1, cols)
            if other.rows == 1 and other.cols == self.cols:
                return Matrix([
                    [self.data[i][j] + other.data[0][j] for j in range(self.cols)]
                    for i in range(self.rows)
                ])
            # 情况 3: 偏置列广播 (rows, 1)
            if other.cols == 1 and other.rows == self.rows:
                return Matrix([
                    [self.data[i][j] + other.data[i][0] for j in range(self.cols)]
                    for i in range(self.rows)
                ])
        raise ValueError(f"无法相加形状 {self.shape} 与 {other.shape}")

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
        if self.cols != other.rows:
            raise ValueError(
                f"无法相乘形状 {self.shape} 与 {other.shape}: "
                f"内层维度不匹配 {self.cols} != {other.rows}"
            )
        return Matrix([
            [
                sum(self.data[i][k] * other.data[k][j] for k in range(self.cols))
                for j in range(other.cols)
            ]
            for i in range(self.rows)
        ])

    def __matmul__(self, other):
        return self.matmul(other)

    def transpose(self):
        return Matrix([
            [self.data[j][i] for j in range(self.rows)]
            for i in range(self.cols)
        ])

    @property
    def T(self):
        return self.transpose()

    def determinant(self):
        if self.rows != self.cols:
            raise ValueError("行列式只适用于方阵")
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
        if self.shape != (2, 2):
            raise ValueError("此方法仅适用于 2x2 矩阵")
        det = self.determinant()
        if abs(det) < 1e-10:
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

    @staticmethod
    def zeros(rows, cols):
        return Matrix([[0] * cols for _ in range(rows)])

    @staticmethod
    def random(rows, cols, low=-1.0, high=1.0):
        return Matrix([
            [random.uniform(low, high) for _ in range(cols)]
            for _ in range(rows)
        ])


def relu_matrix(m):
    return Matrix([[max(0, val) for val in row] for row in m.data])


def demo_basic_operations():
    print("=" * 60)
    print("基础矩阵运算（BASIC MATRIX OPERATIONS）")
    print("=" * 60)

    A = Matrix([[1, 2], [3, 4]])
    B = Matrix([[5, 6], [7, 8]])

    print("\nA =")
    print(A)
    print("\nB =")
    print(B)

    print("\nA + B =")
    print(A + B)

    print("\nA - B =")
    print(A - B)

    print("\nA * 3 (标量乘法) =")
    print(A.scalar_multiply(3))

    print("\nA * B (逐元素相乘 Hadamard 积) =")
    print(A.element_wise_multiply(B))

    print("\nA @ B (矩阵乘法) =")
    print(A @ B)

    print("\nA^T (转置) =")
    print(A.T)


def demo_determinant_inverse():
    print("\n" + "=" * 60)
    print("行列式与逆矩阵（DETERMINANT AND INVERSE）")
    print("=" * 60)

    A = Matrix([[4, 7], [2, 6]])
    print("\nA =")
    print(A)
    print(f"\ndet(A) = {A.determinant()}")

    A_inv = A.inverse_2x2()
    print("\nA^-1 (逆矩阵) =")
    print(A_inv)

    print("\nA @ A^-1 (应当等于单位矩阵 I) =")
    print(A @ A_inv)

    I = Matrix.identity(3)
    print("\n3x3 单位矩阵 =")
    print(I)


def demo_broadcasting():
    print("\n" + "=" * 60)
    print("广播机制（BROADCASTING）")
    print("=" * 60)

    output = Matrix([[1, 2, 3], [4, 5, 6]])
    bias = Matrix([[10, 20, 30]])

    print("\nOutput =")
    print(output)
    print("\nBias =")
    print(bias)
    print("\nOutput + Bias (自动广播相加) =")
    print(output + bias)


def demo_neural_network_layer():
    print("\n" + "=" * 60)
    print("神经网络前向传播（NEURAL NETWORK FORWARD PASS）")
    print("=" * 60)

    random.seed(42)

    input_size = 3
    hidden_size = 4
    output_size = 2

    x = Matrix([[0.5], [0.8], [0.2]])
    W1 = Matrix.random(hidden_size, input_size)
    b1 = Matrix([[0.0]] * hidden_size)
    W2 = Matrix.random(output_size, hidden_size)
    b2 = Matrix([[0.0]] * output_size)

    print(f"\n输入 x 形状: {x.shape}")
    print(f"W1 形状: {W1.shape}")
    print(f"W2 形状: {W2.shape}")

    z1 = (W1 @ x) + b1
    h1 = relu_matrix(z1)
    print(f"\n隐藏层激活前 z1 形状: {z1.shape}")
    print(z1)
    print(f"\n隐藏层 ReLU 激活后 h1 形状: {h1.shape}")
    print(h1)

    z2 = (W2 @ h1) + b2
    print(f"\n最终输出 z2 形状: {z2.shape}")
    print(z2)

    print("\n这是一个完整的双层神经网络前向传播：")
    print("第 1 层: (4x3) @ (3x1) + (4x1) -> (4x1) -> ReLU -> (4x1)")
    print("第 2 层: (2x4) @ (4x1) + (2x1) -> (2x1)")


if __name__ == "__main__":
    demo_basic_operations()
    demo_determinant_inverse()
    demo_broadcasting()
    demo_neural_network_layer()
