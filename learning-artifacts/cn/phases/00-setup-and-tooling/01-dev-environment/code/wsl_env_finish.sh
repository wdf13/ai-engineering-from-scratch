#!/usr/bin/env bash
set -euo pipefail
export HOME=/home/wang
COURSE=/home/wang/ai-engineering-from-scratch
export PATH="$HOME/.local/bin:$HOME/.local/share/fnm:$HOME/.juliaup/bin:$HOME/.cargo/bin:$PATH"
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi
if [ -x "$COURSE/.venv/bin/activate" ]; then
  source "$COURSE/.venv/bin/activate"
fi

echo "==> finish julia"
# leftover from a cancelled/partial install blocks --yes
rm -f "$HOME/.julia/juliaup/juliaup.json"
if ! command -v julia >/dev/null 2>&1; then
  curl -fsSL https://install.julialang.org | sh -s -- --yes
fi
export PATH="$HOME/.juliaup/bin:$PATH"
command -v julia
julia --version
julia -e 'println("Julia ", VERSION)'

echo "==> ensure numpy matplotlib jupyter in venv"
cd "$COURSE"
uv pip install numpy matplotlib jupyter --index-url https://pypi.tuna.tsinghua.edu.cn/simple
python - <<'PY'
import sys
print("python", sys.version.split()[0], sys.executable)
import torch
print("torch", torch.__version__, "cuda", torch.cuda.is_available())
import numpy, matplotlib
print("numpy", numpy.__version__, "matplotlib", matplotlib.__version__)
import jupyter
print("jupyter ok")
PY

echo "==> verify.py"
python phases/00-setup-and-tooling/01-dev-environment/code/verify.py --route beginner --show-later

echo "==> summary"
for c in python3 git uv node pnpm rustc cargo julia; do
  printf "%-8s %s\n" "$c" "$("$c" --version 2>/dev/null | head -n1)"
done
echo "which node: $(command -v node)"
echo "which julia: $(command -v julia)"
echo "venv python: $(command -v python)"
