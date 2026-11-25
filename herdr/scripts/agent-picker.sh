#!/usr/bin/env bash
#
# 実行中の agent を fzf で選んで focus する
# 右側に選択中の agent の直近の出力をプレビューする
#
# herdr の popup (prefix+a) から呼ばれる想定

set -euo pipefail

herdr="${HERDR_BIN_PATH:-herdr}"
export PATH="$HOME/.nix-profile/bin:/opt/homebrew/bin:$PATH"

agents_json="$("$herdr" agent list)"
ws_json="$("$herdr" workspace list)"

# 色 (herdr の one-dark テーマに合わせる)
blue=$'\e[38;2;97;175;239m'
green=$'\e[38;2;152;195;121m'
yellow=$'\e[38;2;229;192;123m'
red=$'\e[38;2;224;108;117m'
gray=$'\e[38;2;92;99;112m'
reset=$'\e[0m'

# workspace-picker.sh と同じノーマルモード (j/k で移動、/ で検索)
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
  "--bind=esc:clear-query+transform:[ \"\$FZF_INPUT_STATE\" = enabled ] && echo hide-input || echo abort"
)

# 1列目: pane_id (focus 用、非表示)
# 表示: 状態アイコン  タイトル  workspace  セッション名
# タイトルと workspace は表示幅 (全角は2) で列を揃える。タイトルは title_max を超えたら … で切る
title_max=50
selected="$(
  jq -r \
    --argjson ws "$ws_json" --argjson title_max "$title_max" \
    --arg blue "$blue" --arg green "$green" --arg yellow "$yellow" --arg red "$red" \
    --arg gray "$gray" --arg reset "$reset" '
    def cw: if (. >= 4352 and . <= 4447) or (. >= 11904 and . <= 42191) or (. >= 44032 and . <= 55203)
              or (. >= 63744 and . <= 64255) or (. >= 65072 and . <= 65103) or (. >= 65280 and . <= 65376)
              or (. >= 65504 and . <= 65510) or (. >= 127744 and . <= 129791) or (. >= 131072 and . <= 262141)
            then 2 else 1 end;
    def width: explode | map(cw) | add // 0;
    def truncate($n):
      if width <= $n then .
      else reduce (explode[]) as $c ({s: [], w: 0};
             if .w + ($c | cw) <= $n - 1 then .s += [$c] | .w += ($c | cw) else . end)
           | (.s | implode) + "…" end;
    def pad($n): . + (" " * ([$n - width, 0] | max));

    ($ws.result.workspaces | map({key: .workspace_id, value: .label}) | from_entries) as $labels
    | [.result.agents[]
       | . + {title: ((.terminal_title_stripped // .agent) | truncate($title_max)),
              ws: ($labels[.workspace_id] // .workspace_id)}] as $agents
    | ($agents | map(.title | width) | max) as $tw
    | ($agents | map(.ws | width) | max) as $ww
    | $agents[]
    | (if .agent_status == "working" then "\($yellow)◑"
       elif .agent_status == "blocked" then "\($red)"
       elif .agent_status == "done" then "\($green)✔"
       else "\($gray)○" end) as $icon
    | "\(.pane_id)\t\($icon)\($reset)  \(.title | pad($tw))  \($blue)\(.ws | pad($ww))\($reset)  \($gray)\(.name // "")\($reset)\(if .focused then "  \($green)󰄾 current\($reset)" else "" end)"
  ' <<<"$agents_json" |
    fzf --ansi --delimiter='\t' --with-nth=2 --no-sort --reverse --prompt='agent> ' \
      --no-input --header='j/k: move  enter: focus  /: search  q/esc: quit' \
      --preview="\"$herdr\" agent read {1} --lines 200 --ansi" \
      --preview-window='down,60%,follow' \
      "${normal_mode_binds[@]}"
)" || exit 0

exec "$herdr" agent focus "$(cut -f1 <<<"$selected")"
