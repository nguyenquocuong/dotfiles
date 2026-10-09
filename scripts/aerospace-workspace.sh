#!/bin/bash
# Focus or move to workspace <1-10> on the focused monitor.
# Workspaces 1-10 live on the main monitor and 11-20 on the secondary one
# (see workspace-to-monitor-force-assignment in aerospace.toml),
# so add 10 when the focused monitor is not the main one.
# Usage: aerospace-workspace.sh focus|move <1-10>
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
