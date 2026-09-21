#!/usr/bin/env bash
set -euo pipefail
export HOME=/home/wang
mkdir -p "$HOME/.local/bin" /tmp
cd /tmp
if [ ! -x "$HOME/.local/julia-1.13.0/bin/julia" ]; then
  curl -L --fail --retry 5 --retry-delay 3 --show-error \
    -o /tmp/julia-1.13.0-linux-x86_64.tar.gz \
    https://github.com/JuliaLang/julia/releases/download/v1.13.0/julia-1.13.0-linux-x86_64.tar.gz
  tar -xzf /tmp/julia-1.13.0-linux-x86_64.tar.gz -C "$HOME/.local"
fi
ln -sfn "$HOME/.local/julia-1.13.0/bin/julia" "$HOME/.local/bin/julia"
export PATH="$HOME/.local/bin:$PATH"
grep -Fqs '.local/bin' "$HOME/.bashrc" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
julia --version
julia -e 'println("Julia ", VERSION)'
