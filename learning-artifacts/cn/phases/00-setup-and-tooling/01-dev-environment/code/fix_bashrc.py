#!/usr/bin/env python3
from pathlib import Path

bashrc = Path("/home/wang/.bashrc")
text = bashrc.read_text(encoding="utf-8")
marker = '\n. "$HOME/.local/bin/env"'
idx = text.find(marker)
if idx == -1:
    idx = text.find("# fnm")
    head = text if idx == -1 else text[:idx]
else:
    head = text[:idx]

tail = r'''
. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/fnm:$PATH"

# fnm (once)
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell bash --use-on-cd)"
fi
'''
bashrc.write_text(head.rstrip() + "\n" + tail, encoding="utf-8")
print("patched", bashrc)
print("--- tail ---")
print(bashrc.read_text(encoding="utf-8")[-800:])
