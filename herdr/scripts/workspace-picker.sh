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

# アイコンの色 (herdr の one-dark テーマに合わせる)
blue=$'\e[38;2;97;175;239m'   # workspace
green=$'\e[38;2;152;195;121m' # current
yellow=$'\e[38;2;229;192;123m' # directory
gray=$'\e[38;2;92;99;112m'
reset=$'\e[0m'

# 最初はノーマルモード (入力欄を隠して j/k で移動)、/ で入力欄を出して fuzzy search
# 入力欄が出ている間は j/k/q なども普通に文字として入力し、esc でノーマルモードに戻る
normal_key() { # <key> <ノーマルモードでの action>
  printf -- "--bind=%s:transform:[ \"\$FZF_INPUT_STATE\" = enabled ] && echo 'put(%s)' || echo '%s'" "$1" "$1" "$2"
}
normal_mode_binds=(
  "$(normal_key j down)"
  "$(normal_key k up)"
  "$(normal_key g first)"
  "$(normal_key G last)"
  "$(normal_key q abort)"
  "$(normal_key / show-input)"
  # clear-query は transform の出力に含めると効かないので外に出す (ノーマルモードでは空なので無害)
  "--bind=esc:clear-query+transform:[ \"\$FZF_INPUT_STATE\" = enabled ] && echo hide-input || echo abort"
)

selected="$(
  {
    jq -r --arg blue "$blue" --arg green "$green" --arg reset "$reset" \
      '.result.workspaces[] | "ws\t\(.workspace_id)\t\($blue)󰙅\($reset)  \(.label)\(if .focused then "  \($green)󰄾 current\($reset)" else "" end)"' <<<"$ws_json"
    zoxide query -l | awk -v home="$HOME" -v yellow="$yellow" -v gray="$gray" -v reset="$reset" \
      '{ d = $0; sub("^" home, "~", d); n = split(d, p, "/"); parent = substr(d, 1, length(d) - length(p[n]));
         printf "dir\t%s\t%s󰱼%s  %s%s%s%s\n", $0, yellow, reset, gray, parent, reset, p[n] }'
  } | fzf --ansi --delimiter='\t' --with-nth=3 --no-sort --reverse --prompt='workspace> ' \
    --no-input --header='j/k: move  enter: select  /: search  q/esc: quit' \
    "${normal_mode_binds[@]}"
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
