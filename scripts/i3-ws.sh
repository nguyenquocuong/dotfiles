#!/bin/sh
# 1-10 are pinned to the primary output and 11-20 to the second one (see i3 config)

set -eu

primary=$1
verb=$2
n=$3

focused=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused) | .output')

case $verb in
    go|move)             on_primary=$([ "$focused" = "$primary" ] && echo 1 || echo 0) ;;
    go-other|move-other) on_primary=$([ "$focused" = "$primary" ] && echo 0 || echo 1) ;;
    *) echo "unknown verb: $verb" >&2; exit 1 ;;
esac

if [ "$on_primary" = 1 ]; then
    ws=$n
else
    ws=$((n + 10))
fi

case $verb in
    go*)   i3-msg "workspace $ws" ;;
    # Two calls on purpose: chained "move ...; workspace ..." does not
    # switch focus when the target workspace is on another output.
    move*) i3-msg "move container to workspace $ws" && i3-msg "workspace $ws" ;;
esac
