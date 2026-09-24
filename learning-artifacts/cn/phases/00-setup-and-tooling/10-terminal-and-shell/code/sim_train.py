#!/usr/bin/env python3
"""
模拟模型训练过程并生成标准输出与标准错误流的测试脚本
用于验证 Linux 终端的重定向（>、2>、2>&1）与管道（|）过滤
"""
import sys
import time

def simulate_training(total_steps=10):
    print(f"[INFO] 开始模拟训练，总步数: {total_steps} ...")
    for step in range(1, total_steps + 1):
        # 模拟第 4 步抛出一个非致命或致命错误到 stderr
        if step == 4:
            sys.stderr.write(f"[ERROR] Step {step}: CUDA out of memory on GPU 0\n")
            sys.stderr.flush()
        
        # 正常的训练过程输出（Epoch, Step, Loss, Acc）
        loss = 1.0 / step
        acc = 0.60 + step * 0.03
        print(f"Epoch 1 | Step {step:02d}/{total_steps} | Loss: {loss:.4f} | Acc: {acc:.2f}")
        sys.stdout.flush()
        time.sleep(0.05)
    print("[INFO] 模拟训练结束。")

if __name__ == "__main__":
    simulate_training()
