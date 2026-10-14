---
name: skill-probability-reasoning
description: 给一个机器学习问题选择合适的概率分布
version: 1.0.0
phase: 1
lesson: 6
tags: [probability, distributions, modeling]
---

# 怎样选分布

给数据建模、设计损失函数或设定先验时，按下面选分布。

## 检查单

1. 结果是离散的（类别、计数）还是连续的（测量、分数）？
2. 结果有界（例如 [0, 1]）还是无界？
3. 可能的结果有多少个？两个？k 个？无穷个？
4. 数据对称，还是一边拖着长尾？
5. 事件互相独立，还是相关？
6. 你在建模的是速率、计数、比例，还是一次测量？

## 决策

离散：

- 只有两个结果：Bernoulli，参数 p
- 一次试验、k 个结果：Categorical，参数 p1…pk
- n 次试验、k 个结果：Multinomial
- n 次试验里成功的次数：Binomial
- 一段区间里事件发生的次数：Poisson，参数 lambda
- 直到第一次成功要多少次试验：Geometric
- 直到第 r 次成功要多少次试验：Negative Binomial

连续：

- 对称、钟形：Normal，参数 mu、sigma
- 只取正数、右偏：Log-normal 或 Exponential
- 限制在 [0, 1]：Beta
- 只取正数、形状要灵活：Gamma
- 两次事件之间的时间：Exponential
- 需要更厚的尾：Student's t 或 Cauchy
- 多维、钟形：Multivariate Normal
- 落在单纯形上（加起来等于 1）：Dirichlet

## 机器学习里常见的对应

| 场景 | 分布 | 参数 |
|------|------|------|
| 二分类输出 | Bernoulli | p = sigmoid(logit) |
| 多分类输出 | Categorical | p = softmax(logits) |
| 语言模型预测下一个词 | 词表上的 Categorical | softmax 给出的 p |
| 归一化后的像素 | Beta 或 [0, 1] 上的 Uniform | 看图像统计 |
| 文档里的词数 | Poisson | lambda = 平均词数 |
| 两次用户请求之间的时间 | Exponential | lambda = 请求速率 |
| 测量误差 | Normal | mu = 0，sigma 从数据来 |
| 权重初始化 | Normal 或 Uniform | Kaiming / Xavier |
| VAE 隐空间的先验 | 标准正态 | mu = 0，sigma = 1 |
| 比例上的贝叶斯先验 | Beta | alpha、beta 来自信念 |
| 类别权重上的贝叶斯先验 | Dirichlet | alpha 向量 |
| 回归目标上的噪声 | Normal | mu = 0，sigma 要估计 |
| 不怕离群点的回归 | Student's t | 自由度较低 |
