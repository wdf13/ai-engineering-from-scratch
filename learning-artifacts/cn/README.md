# 中文学习对照：完整课程镜像

**每次开始新课前，先读 [AGENTS.md](AGENTS.md) 的长期规则。不能只导入中文讲义。** 官方正文、代码、原始测验、所有输出与附加文件，必须按实际目录逐项完整镜像，完成路径和 SHA 校验后再教学。

## 文件对应关系

```text
官方:  phases/<阶段>/<课>/docs/*
       phases/<阶段>/<课>/code/*
       phases/<阶段>/<课>/quiz.json
       phases/<阶段>/<课>/outputs/*
       以及该课所有实际存在的其他文件

镜像:  learning-artifacts/cn/phases/<阶段>/<课>/docs/*
       learning-artifacts/cn/phases/<阶段>/<课>/code/*
       learning-artifacts/cn/phases/<阶段>/<课>/quiz.json
       learning-artifacts/cn/phases/<阶段>/<课>/outputs/*
       以及对应的其他文件，原版内容不修改
```

中文额外材料（独立于原版）：`docs/zh.md`（标注翻译来源及质量）、`quiz.zh.json`（与官方测验答案下标一致）、`outputs/*.zh.md`（中文说明）。个人作答追加在 `code/learn.ipynb`，绝不覆盖。

官方 `phases/` 是权威版本。学完所有练习和 post-quiz 后，将完成情况写入仓库根目录 `LEARNING.md`。
