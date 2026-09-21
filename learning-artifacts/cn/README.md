# 中文学习对照（整课镜像）

官方正文在 `phases/<阶段>/<课>/`，英文为准，不要改那边的文件。

这里按**同一课目录结构**放中文对照和学习用副本：

```text
官方:  phases/<阶段>/<课>/docs/en.md
       phases/<阶段>/<课>/code/*
       phases/<阶段>/<课>/quiz.json
       phases/<阶段>/<课>/outputs/*

对照:  learning-artifacts/cn/phases/<阶段>/<课>/docs/cn.md
       learning-artifacts/cn/phases/<阶段>/<课>/code/
       learning-artifacts/cn/phases/<阶段>/<课>/quiz.json
       learning-artifacts/cn/phases/<阶段>/<课>/outputs/
```

| 官方有什么 | 这里怎么放 |
|------------|------------|
| `docs/en.md` | 译为 `docs/cn.md` |
| `code/` | 原样复制；注释/打印说明译成中文；标识符不译 |
| `quiz.json` | 题干、选项、解析译成中文；`correct` 下标不变 |
| `outputs/*.md` | 提示词译成中文 |

额外文件（如 `first_call.py` DeepSeek 版、WSL 安装脚本）会留在同一 `code/` 里，不覆盖官方文件名。

代码、API、论文术语保持英文。进度记在仓库根目录 `LEARNING.md`。
