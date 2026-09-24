#!/usr/bin/env bash
#
# workspace-picker.wezterm の herdr 版
# 既存 workspace と zoxide のディレクトリを fzf で選び、
#   - workspace を選んだら focus
#   - ディレクトリを選んだら同名 (basename) の workspace があれば focus、なければ作成
#
# herdr の popup (prefix+s) から呼ばれる想定

set -euo pipefail

herdr="${HERDR_BIN_PATH:-herdr}"
export PATH="$HOME/.nix-profile/bin:/opt/homebrew/bin:$PATH"

ws_json="$("$herdr" workspace list)"

selected="$(
  {
    jq -r '.result.workspaces[] | "ws\t\(.workspace_id)\t󰙅  \(.label)\(if .focused then "  󰄾 current" else "" end)"' <<<"$ws_json"
    zoxide query -l | awk -v home="$HOME" '{ d = $0; sub("^" home, "~", d); printf "dir\t%s\t󰱼  %s\n", $0, d }'
  } | fzf --delimiter='\t' --with-nth=3 --no-sort --reverse --prompt='workspace> '
)" || exit 0

kind="$(cut -f1 <<<"$selected")"
value="$(cut -f2 <<<"$selected")"

if [ "$kind" = "ws" ]; then
  exec "$herdr" workspace focus "$value"
fi

label="$(basename "$value")"
existing="$(jq -r --arg label "$label" '.result.workspaces[] | select(.label == $label) | .workspace_id' <<<"$ws_json" | head -n1)"
if [ -n "$existing" ]; then
  exec "$herdr" workspace focus "$existing"
fi
exec "$herdr" workspace create --cwd "$value" --label "$label" --focus
