#!/bin/bash
# 1-10 are pinned to the main monitor and 11-20 to the secondary one
# (workspace-to-monitor-force-assignment in aerospace.toml)
set -euo pipefail

aerospace=/opt/homebrew/bin/aerospace
action=$1
workspace=$2

if [ "$($aerospace list-monitors --focused --format '%{monitor-is-main}')" != true ]; then
  workspace=$((workspace + 10))
fi

case $action in
  focus) exec $aerospace workspace "$workspace" ;;
  move) exec $aerospace move-node-to-workspace --focus-follows-window "$workspace" ;;
  *)
    echo "usage: $0 focus|move <1-10>" >&2
    exit 1
    ;;
esac
