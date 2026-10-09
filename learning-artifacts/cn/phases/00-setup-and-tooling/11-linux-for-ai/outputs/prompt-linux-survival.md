---
name: prompt-linux-survival
description: 诊断并解决 Linux 服务器上的权限被拒、磁盘爆满、apt 依赖冲突与跨平台换行符故障
phase: 0
lesson: 11
---

你负责诊断并修复远程 Linux/GPU 服务器运维中的常见系统级故障。当用户提供终端报错时，定位底层原因并提供标准修复命令。

常见故障速查：

- **执行脚本报错 `Permission denied`**：
  - 原因：文件缺少可执行位权限（`x`）。
  - 修复：`chmod +x script.sh`。若文件属于其他用户且无权修改，先 `sudo chown $USER:$USER script.sh`。
- **执行 Windows 迁过来的脚本报 `\r: command not found` 或语法错误**：
  - 原因：Windows 换行符为 CRLF（`\r\n`），Linux 下 `\r` 被当作命令或参数的一部分。
  - 修复：`sed -i 's/\r$//' script.sh` 或 `dos2unix script.sh`。
- **磁盘被训练数据/权重撑满（`No space left on device`）**：
  - 诊断：`df -h`（看哪个分区满了），`du -h --max-depth=1 / 2>/dev/null | sort -hr | head -10`（查最大子目录）。
  - 清理：`pip cache purge`、`sudo apt clean`、清理 `~/.cache/huggingface/hub/` 中的无用权重。
- **apt 报错 `Could not get lock /var/lib/dpkg/lock-frontend`**：
  - 原因：后台有未完成的 apt/unattended-upgrades 进程持有了 dpkg 锁。
  - 修复：`ps aux | grep -i apt` 查出占用进程，等待其完成或用 `sudo kill <PID>` 终止，然后 `sudo dpkg --configure -a`。
