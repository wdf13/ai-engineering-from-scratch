#!/usr/bin/env bash
#
# Linux 权限与磁盘空间检测演练脚本
# 用于直观演示八进制权限位转换、属主查询及安全磁盘检测
#

set -e

echo "=== 1. Linux 权限掩码与位运算演练 ==="
TEST_FILE="/tmp/aifs_perm_test.txt"
echo "hello linux permissions" > "$TEST_FILE"

echo "[初始状态] 创建普通文件后的默认权限:"
ls -l "$TEST_FILE"

echo -e "\n[执行 chmod 644] 所有者 rw-(6), 组和其他人 r--(4):"
chmod 644 "$TEST_FILE"
ls -l "$TEST_FILE"

echo -e "\n[执行 chmod 755] 为所有者添加可执行位 rwx(7), 组和其他人 r-x(5):"
chmod 755 "$TEST_FILE"
ls -l "$TEST_FILE"

rm -f "$TEST_FILE"
echo -e "\n=== 2. 当前用户与主目录路径 ==="
echo "当前用户 (whoami): $(whoami)"
echo "当前主目录 (~): $HOME"

echo -e "\n=== 3. 根目录第一级空间大户排查 (Top 5) ==="
du -h --max-depth=1 / 2>/dev/null | sort -hr | head -5 || true
