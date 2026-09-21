#!/usr/bin/env python3
from pathlib import Path

cfg = Path("/home/wang/ai-engineering-from-scratch/.venv/pyvenv.cfg")
cfg.write_text(
    cfg.read_text().replace(
        "prompt = ai-engineering-from-scratch",
        "prompt = .venv",
    )
)

act = Path("/home/wang/ai-engineering-from-scratch/.venv/bin/activate")
act.write_text(
    act.read_text().replace(
        'VIRTUAL_ENV_PROMPT="ai-engineering-from-scratch"',
        'VIRTUAL_ENV_PROMPT=".venv"',
    )
)

brc = Path("/home/wang/.bashrc")
b = brc.read_text()
marker = "# short prompt for course terminal"
block = (
    "\n"
    + marker
    + "\n"
    + r"PS1='\[\033[32m\]\u\[\033[00m\]:\[\033[34m\]\W\[\033[00m\]\$ '"
    + "\n"
)
if marker not in b:
    brc.write_text(b + block)

print("done")
