#!/usr/bin/env bash
input=$(cat)

esc=$'\033'

user=$(whoami)
host=$(hostname -s)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
[ -z "$cwd" ] && cwd=$(pwd)
dir=$(basename "$cwd")

model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
used_tokens=$(echo "$input" | jq -r '(.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0)')
window_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Git branch + dirty flag for the session's working directory.
git_info=""
if branch=$(git -C "$cwd" symbolic-ref --short -q HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null); then
  [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ] && branch="$branch*"
  git_info="${esc}[36m${branch}${esc}[0m"
fi

# Format a token count as a compact human-readable string (e.g. 45000 -> 45k).
fmt_tokens() {
  awk -v n="$1" 'BEGIN {
    if (n >= 1000000) printf "%.1fM", n / 1000000;
    else if (n >= 1000) printf "%.0fk", n / 1000;
    else printf "%d", n;
  }'
}

# Pick an ANSI color for context usage: greener = more headroom (efficient),
# redder = context filling up.
ctx_color() {
  awk -v p="$1" 'BEGIN {
    if (p < 50)      printf "32";  # green
    else if (p < 75) printf "33";  # yellow
    else if (p < 90) printf "35";  # magenta
    else             printf "31";  # red
  }'
}

status_left="[$user@$host $dir]"
[ -n "$git_info" ] && status_left="$status_left  $git_info"

status_right=""
[ -n "$model" ] && status_right="$model"
if [ -n "$window_size" ] && [ "$window_size" -gt 0 ] 2>/dev/null; then
  ctx="ctx: $(fmt_tokens "$used_tokens")/$(fmt_tokens "$window_size")"
  if [ -n "$used_pct" ]; then
    color=$(ctx_color "$used_pct")
    ctx="$ctx (${esc}[${color}m$(printf '%.0f' "$used_pct")%${esc}[0m)"
  fi
  status_right="$status_right | $ctx"
fi
[ -n "$cost" ] && status_right="$status_right | \$$(printf '%.2f' "$cost")"

if [ -n "$status_right" ]; then
  printf "%s  %s" "$status_left" "$status_right"
else
  printf "%s" "$status_left"
fi
