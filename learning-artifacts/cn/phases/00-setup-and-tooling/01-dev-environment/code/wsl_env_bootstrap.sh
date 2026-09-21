#!/usr/bin/env bash
# Phase 0 lesson 01: install missing WSL tools. Non-interactive.
set -euo pipefail
export HOME=/home/wang
cd "$HOME"

append_once() {
  local file="$1"
  local line="$2"
  grep -Fqs "$line" "$file" 2>/dev/null || echo "$line" >> "$file"
}

have() { command -v "$1" >/dev/null 2>&1; }

export PATH="$HOME/.local/bin:$HOME/.juliaup/bin:$HOME/.cargo/bin:$PATH"
if [ -s "$HOME/.bashrc" ]; then
  # shellcheck disable=SC1090
  source "$HOME/.bashrc" >/dev/null 2>&1 || true
fi
if have fnm; then
  eval "$(fnm env --use-on-cd)" >/dev/null 2>&1 || true
fi
if [ -f "$HOME/.cargo/env" ]; then
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
fi

echo "==> inventory before"
for c in python3 git curl wget unzip uv fnm node npm pnpm rustc cargo julia; do
  if have "$c"; then
    printf "OK   %-10s %s\n" "$c" "$("$c" --version 2>/dev/null | head -n1)"
  else
    printf "NEED %-10s\n" "$c"
  fi
done

echo "==> uv"
if ! have uv; then
  mkdir -p /tmp/uv-extract "$HOME/.local/bin"
  curl -L --fail --show-error -o /tmp/uv.tar.gz \
    https://github.com/astral-sh/uv/releases/download/0.12.17/uv-x86_64-unknown-linux-gnu.tar.gz
  tar -xzf /tmp/uv.tar.gz -C /tmp/uv-extract
  install -m 755 /tmp/uv-extract/*/uv /tmp/uv-extract/*/uvx "$HOME/.local/bin/"
  append_once "$HOME/.bashrc" 'export PATH="$HOME/.local/bin:$PATH"'
  export PATH="$HOME/.local/bin:$PATH"
fi
uv --version

echo "==> python 3.12 + venv in course repo"
COURSE=/home/wang/ai-engineering-from-scratch
cd "$COURSE"
if [ ! -x "$COURSE/.venv/bin/python" ]; then
  uv python install 3.12 || true
  uv venv --python 3.12
fi
# shellcheck disable=SC1091
source "$COURSE/.venv/bin/activate"
uv pip install numpy matplotlib jupyter torch --index-url https://pypi.tuna.tsinghua.edu.cn/simple

echo "==> node/fnm/pnpm"
if ! have fnm; then
  curl -fsSL https://fnm.vercel.app/install | bash
  export PATH="$HOME/.local/share/fnm:$PATH"
fi
eval "$(fnm env --use-on-cd)"
fnm install 22
fnm use 22
append_once "$HOME/.bashrc" 'eval "$(fnm env --use-on-cd)"'
if ! have pnpm; then
  npm install -g pnpm
fi
node -v
pnpm -v

echo "==> rustup"
if ! have rustc || ! have cargo; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
fi
rustc --version
cargo --version

echo "==> juliaup"
if ! have julia; then
  curl -fsSL https://install.julialang.org | sh -s -- --yes
  export PATH="$HOME/.juliaup/bin:$PATH"
fi
julia --version

echo "==> python packages in venv"
python - <<'PY'
import sys
print("python", sys.version.replace("\n"," "))
print("exe", sys.executable)
for m in ("numpy", "matplotlib", "jupyter", "torch"):
    x = __import__(m)
    extra = ""
    if m == "torch":
        extra = f" cuda={x.cuda.is_available()} version={x.__version__}"
    print(m, getattr(x, "__version__", "ok"), extra)
PY

echo "==> verify.py beginner --show-later"
cd "$COURSE"
python phases/00-setup-and-tooling/01-dev-environment/code/verify.py --route beginner --show-later || true

echo "==> done"
