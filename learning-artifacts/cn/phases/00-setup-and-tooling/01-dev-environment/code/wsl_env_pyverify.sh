#!/usr/bin/env bash
set -euo pipefail
export HOME=/home/wang
export PATH="$HOME/.local/bin:$HOME/.local/share/fnm:$HOME/.juliaup/bin:$HOME/.cargo/bin:$PATH"
COURSE=/home/wang/ai-engineering-from-scratch
source "$COURSE/.venv/bin/activate"
cd "$COURSE"
uv pip install numpy matplotlib jupyter --index-url https://pypi.tuna.tsinghua.edu.cn/simple
python - <<'PY'
import sys, numpy, matplotlib, torch
print("python", sys.version.split()[0], sys.executable)
print("numpy", numpy.__version__)
print("matplotlib", matplotlib.__version__)
print("torch", torch.__version__, "cuda", torch.cuda.is_available())
import jupyter
print("jupyter ok")
PY
python phases/00-setup-and-tooling/01-dev-environment/code/verify.py --route beginner --show-later
echo "--- bins ---"
export PATH="$HOME/.local/bin:$HOME/.local/share/fnm:$HOME/.juliaup/bin:$HOME/.cargo/bin:$PATH"
eval "$(fnm env --use-on-cd)"
source "$HOME/.cargo/env"
for c in python git uv fnm node pnpm rustc cargo julia; do
  if command -v "$c" >/dev/null; then
    printf "OK   %-8s %s\n" "$c" "$("$c" --version 2>/dev/null | head -n1)"
  else
    printf "NEED %-8s\n" "$c"
  fi
done
which node
which python
