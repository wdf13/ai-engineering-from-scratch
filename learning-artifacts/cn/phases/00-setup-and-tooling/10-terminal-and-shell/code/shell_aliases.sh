#!/usr/bin/env bash
#
# AI 开发与深度学习专用 Shell 别名与实用辅助函数
# 可以在 ~/.bashrc 或 ~/.zshrc 中引入此文件：
#   source ~/ai-engineering-from-scratch/learning-artifacts/cn/phases/00-setup-and-tooling/10-terminal-and-shell/code/shell_aliases.sh
#

# --- 1. GPU 显存与硬件状态监控 ---

# 快速单行紧凑查询 GPU 型号、利用率、已用显存、总显存、核心温度
alias gpu='nvidia-smi --query-gpu=index,name,utilization.gpu,memory.used,memory.total,temperature.gpu --format=csv,noheader'

# 实时每秒刷新 nvidia-smi 监控界面
alias gpuwatch='watch -n1 nvidia-smi'

# 只输出显存占用情况（已用 / 总量）
alias gpumem='nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader'

# 查询当前正在占用显存的计算进程 PID、进程名及显存开销（排查 OOM 显存泄露核心）
alias gpuprocs='nvidia-smi --query-compute-apps=pid,name,used_memory --format=csv'


# --- 2. 训练进程管控 ---

# 一键强制终止所有命令包含 python.*train 的训练脚本
alias killtraining='pkill -f "python.*train"'

# 智能终止函数：无参数时默认杀掉 python.*train，带参数时杀死匹配 $1 的进程
killtrain() {
    if [ -z "$1" ]; then
        pkill -f "python.*train"
        echo "[INFO] 已终止所有 Python 训练进程"
    else
        pkill -f "$1"
        echo "[INFO] 已终止匹配目标的所有进程: $1"
    fi
}


# --- 3. Python 虚拟环境极速切换 ---

# 快速激活当前目录下的 .venv 虚拟环境
alias ae='source .venv/bin/activate'

# 退出当前激活的虚拟环境
alias de='deactivate'

# 原生快速创建并自动激活 .venv
alias mkvenv='python -m venv .venv && source .venv/bin/activate'

# 使用 uv 超高速创建并激活 .venv
alias uvvenv='uv venv && source .venv/bin/activate'


# --- 4. 实时训练日志跟踪与行缓冲过滤 ---

# 实时追踪日志，并强制行缓冲过滤 loss 字段（无缓冲延迟）
alias watchloss='tail -f logs/*.log | grep --line-buffered "loss"'

# 实时过滤 accuracy / acc 准确率字段
alias watchacc='tail -f logs/*.log | grep --line-buffered "accuracy\|acc"'

# 实时监控日志中的异常与错误堆栈
alias watcherr='tail -f logs/*.log | grep --line-buffered "ERROR\|error\|Exception"'

# 动态指定过滤关键字查看日志流，默认过滤 loss
taillog() {
    local pattern="${1:-loss}"
    tail -f logs/*.log 2>/dev/null | grep --line-buffered "$pattern"
}


# --- 5. 磁盘开销分析（防训练数据把磁盘撑满）---

# 查看当前所在挂载分区的剩余磁盘空间
alias diskuse='df -h .'

# 列出当前目录下体积大于 100M 的文件（取前 20 大）
alias bigfiles='find . -type f -size +100M | xargs du -h 2>/dev/null | sort -rh | head -20'

# 专门检索各类模型权重与 Checkpoint 文件（pt, safetensors, ckpt, bin）并排序
alias bigmodels='find . \( -name "*.pt" -o -name "*.pth" -o -name "*.safetensors" -o -name "*.ckpt" -o -name "*.bin" \) | xargs du -h 2>/dev/null | sort -rh | head -20'


# --- 6. 环境与硬件自检 ---

# 使用 PyTorch 快速测试 CUDA 是否可用以及主卡型号
alias checkgpu='python -c "import torch; print(f\"CUDA: {torch.cuda.is_available()}\"); print(f\"Device: {torch.cuda.get_device_name(0)}\") if torch.cuda.is_available() else None"'

# 检查当前 Shell 导出的所有 CUDA 相关环境变量
alias checkcuda='env | grep -i cuda'

# 综合自检 Python、pip、PyTorch 与 CUDA 状态
alias checkenv='python --version && pip --version && python -c "import torch; print(f\"PyTorch {torch.__version__}, CUDA {torch.cuda.is_available()}\")" 2>/dev/null'


# --- 7. tmux 快捷会话流 ---

alias ta='tmux attach -t'
alias tls='tmux ls'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'

# 一键启动经典的 AI 训练三窗格布局环境（左边训练，右上 GPU，右下 htop）
trainenv() {
    local name="${1:-train}"
    tmux new-session -d -s "$name"
    tmux split-window -h -t "$name"
    tmux split-window -v -t "$name"
    tmux send-keys -t "$name:0.1" 'watch -n1 nvidia-smi' C-m
    tmux send-keys -t "$name:0.2" 'htop' C-m
    tmux select-pane -t "$name:0.0"
    tmux attach -t "$name"
}


# --- 8. 远程服务器 rsync 数据同步辅助 ---

# 本地同步至远端：syncto <host> <remote_path> [local_path]
syncto() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "用法: syncto <主机别名> <远端路径> [本地路径，默认当前目录]"
        echo "示例: syncto gpu3 ~/data ./data"
        return 1
    fi
    local host="$1"
    local remote="$2"
    local local_path="${3:-.}"
    rsync -avzP "$local_path" "${host}:${remote}"
}

# 远端同步回本地：syncfrom <host> <remote_path> [local_path]
syncfrom() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "用法: syncfrom <主机别名> <远端路径> [本地路径，默认当前目录]"
        echo "示例: syncfrom gpu3 ~/results ./results"
        return 1
    fi
    local host="$1"
    local remote="$2"
    local local_path="${3:-.}"
    rsync -avzP "${host}:${remote}" "$local_path"
}


# --- 9. 实验目录自动化管理 ---

# 快速创建带时间戳的规范化实验目录（含 logs, checkpoints, configs）
newexp() {
    local name="${1:-experiment}"
    local dir="experiments/${name}_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$dir/logs" "$dir/checkpoints" "$dir/configs"
    echo "[OK] 已建立实验专属目录结构: $dir"
    echo "$dir"
}

# 快速定位最近一次修改的实验目录
lastexp() {
    ls -dt experiments/*/ 2>/dev/null | head -1
}


# --- 10. 进程检索与内存大户查找 ---

# 找出占用物理内存最多的前 10 个进程
memhogs() {
    ps aux --sort=-%mem 2>/dev/null | head -11 || ps aux -m | head -11
}

# 忽略 grep 自身并按关键词检索进程
psg() {
    ps aux | grep -v grep | grep -i "$1"
}
