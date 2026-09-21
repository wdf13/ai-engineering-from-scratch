#!/usr/bin/env bash
set -euo pipefail
export HOME=/home/wang
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

WIN_KEY="/mnt/c/Users/33887/.ssh/remote_gpu_mcp_ed25519"
WSL_KEY="$HOME/.ssh/remote_gpu_mcp_ed25519"
if [ ! -f "$WIN_KEY" ]; then
  echo "missing Windows key: $WIN_KEY" >&2
  exit 1
fi
cp "$WIN_KEY" "$WSL_KEY"
chmod 600 "$WSL_KEY"
if [ -f "${WIN_KEY}.pub" ]; then
  cp "${WIN_KEY}.pub" "${WSL_KEY}.pub"
  chmod 644 "${WSL_KEY}.pub"
fi

HOST="10611hl485bu9.vicp.fun"
PORT="34188"
KH="$HOME/.ssh/known_hosts"
touch "$KH"
chmod 600 "$KH"
# drop old lines for this host:port then append
grep -v "\\[${HOST}\\]:${PORT}" "$KH" > "${KH}.tmp" || true
cat >> "${KH}.tmp" <<'EOF'
[10611hl485bu9.vicp.fun]:34188 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMsUwn8rRYePHJtW4Qjc+BHDRPecP7gPd9/yJubeiM+L
[10611hl485bu9.vicp.fun]:34188 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFrCR6u2oJdC51EidIzJKTOx+X+DI92HPN6COCc626C1JQomCOG+V5rUTwF5ybW4339BZA90XNVA1vgr1a2Oh5A=
EOF
mv "${KH}.tmp" "$KH"
chmod 600 "$KH"

CFG="$HOME/.ssh/config"
touch "$CFG"
chmod 600 "$CFG"
# remove previous gpu block if re-run
python3 - <<'PY'
from pathlib import Path
p = Path("/home/wang/.ssh/config")
text = p.read_text() if p.exists() else ""
lines = text.splitlines(True)
out = []
skip = False
for line in lines:
    if not skip and line.startswith("Host ") and any(h in line.split()[1:] for h in ("gpu", "gpu3", "remote-gpu")):
        skip = True
        continue
    if skip:
        if line.startswith("Host ") and not line.startswith("HostName"):
            skip = False
            out.append(line)
        continue
    out.append(line)
block = """Host gpu gpu3 remote-gpu
    HostName 10611hl485bu9.vicp.fun
    User wzh
    Port 34188
    IdentityFile ~/.ssh/remote_gpu_mcp_ed25519
    IdentitiesOnly yes
    ForwardAgent yes
    ProxyCommand nc -X 5 -x 127.0.0.1:7892 %h %p
    ServerAliveInterval 30
    ServerAliveCountMax 3
"""
p.write_text("".join(out).rstrip() + "\n\n" + block)
print("wrote", p)
PY

echo "==> key perms"
ls -l "$WSL_KEY"
echo "==> ssh config"
grep -A20 '^Host gpu' "$CFG"
echo "==> test"
ssh -o BatchMode=yes -o ConnectTimeout=20 gpu 'hostname; whoami; echo HOME=$HOME; nvidia-smi -L | head -n 4'
