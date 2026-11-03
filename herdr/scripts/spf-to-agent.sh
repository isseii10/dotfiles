#!/usr/bin/env bash
#
# superfile で選んだファイルを、エージェント (Claude Code など) の入力欄に `@path ` として入れる
#
# herdr の popup (prefix+f) から呼ばれる想定
#   1. superfile を --chooser-file 付きで開く (ファイル上で enter/l/e を押すとパスを書き出して終了)
#   2. 送り先のエージェントを決める
#        - 呼び出し元のペイン ($HERDR_ACTIVE_PANE_ID。popup には HERDR_PANE_ID が渡されない) がエージェントならそれ
#        - なければフォーカス中のエージェント
#        - なければフォーカス中のペインと同じタブにいるエージェント
#   3. send-text で入力する (Enter は送らないので、続けて指示を書ける)
#        - 画像: Finder からのドラッグと同じく bracketed paste で貼り付け、画像として添付させる
#        - それ以外: `@path ` (cwd 配下なら相対パス、それ以外は絶対パス。空白を含むなら引用符で囲む)

set -euo pipefail

herdr="${HERDR_BIN_PATH:-herdr}"
export PATH="$HOME/.nix-profile/bin:/opt/homebrew/bin:$PATH"

notify() {
  "$herdr" notification show "spf → agent" --body "$1" >/dev/null 2>&1 || true
}

chooser="$(mktemp -t spf-to-agent)"
trap 'rm -f "$chooser"' EXIT

superfile --chooser-file "$chooser" || true

file="$(head -n1 "$chooser")"
if [ -z "$file" ]; then
  # ファイルを選ばずに閉じた
  exit 0
fi

agents="$("$herdr" agent list)"

target="$(jq -r --arg pane "${HERDR_ACTIVE_PANE_ID:-}" '
  .result.agents | (map(select(.pane_id == $pane)) + map(select(.focused)))[0].pane_id // empty
' <<<"$agents")"

if [ -z "$target" ]; then
  tab="$("$herdr" pane list | jq -r '.result.panes[] | select(.focused) | .tab_id' | head -n1)"
  target="$(jq -r --arg tab "$tab" '
    [.result.agents[] | select(.tab_id == $tab)][0].pane_id // empty
  ' <<<"$agents")"
fi

if [ -z "$target" ]; then
  notify "送り先のエージェントが見つかりません: $file"
  exit 1
fi

cwd="$(jq -r --arg pane "$target" '
  .result.agents[] | select(.pane_id == $pane) | (.foreground_cwd // .cwd // "")
' <<<"$agents")"

path="$file"
if [ -n "$cwd" ] && [[ "$file" == "$cwd"/* ]]; then
  path="${file#"$cwd"/}"
fi

# 画像は Finder からドラッグしたときと同じ形 (バックスラッシュでエスケープした絶対パスを
# bracketed paste で囲む) で送る。Claude Code は貼り付けられた画像パスを画像として添付する
ext="$(tr '[:upper:]' '[:lower:]' <<<"${file##*.}")"
case "$ext" in
  png | jpg | jpeg | gif | webp)
    escaped="$(sed 's/[][ ()&;!$`"'"'"'\\]/\\&/g' <<<"$file")"
    "$herdr" pane send-text "$target" $'\e[200~'"$escaped"$'\e[201~'
    exit 0
    ;;
esac

# 空白を含むパスは @ 参照が途中で切れるので引用符で囲む
if [[ "$path" == *[[:space:]]* ]]; then
  path="\"$path\""
fi

"$herdr" pane send-text "$target" "@$path "
