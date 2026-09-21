#!/usr/bin/env bash
set -euo pipefail
export HOME=/home/wang
export JULIAUP_SERVER=https://mirrors.tuna.tsinghua.edu.cn/julia-releases
export PATH="$HOME/.juliaup/bin:$HOME/.local/bin:$PATH"
COURSE=/home/wang/ai-engineering-from-scratch

echo "==> juliaup bin"
ls -la "$HOME/.juliaup/bin" || true

if ! command -v juliaup >/dev/null 2>&1; then
  curl -fsSL https://install.julialang.org | sh -s -- --yes
fi
export PATH="$HOME/.juliaup/bin:$PATH"

# persist mirror for future juliaup self-update
grep -Fqs 'JULIAUP_SERVER' "$HOME/.bashrc" || \
  echo 'export JULIAUP_SERVER=https://mirrors.tuna.tsinghua.edu.cn/julia-releases' >> "$HOME/.bashrc"

echo "==> juliaup add release (tuna)"
juliaup self update || true
juliaup add release
juliaup default release
hash -r
julia --version
julia -e 'println("Julia ", VERSION)'

echo "==> python venv packages"
cd "$COURSE"
source "$COURSE/.venv/bin/activate"
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

echo "==> verify.py"
python phases/00-setup-and-tooling/01-dev-environment/code/verify.py --route beginner --show-later
