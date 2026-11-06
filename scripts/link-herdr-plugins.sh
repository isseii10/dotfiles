#!/bin/bash
set -e

# herdr/config.toml の plugin_action が使うプラグインを herdr に登録する。
# 登録済みのものはスキップするので、何度実行してもよい。

if ! command -v herdr &>/dev/null; then
  echo "[herdr] not installed, skipping"
  exit 0
fi

installed="$(herdr plugin list 2>/dev/null)"

is_installed() {
  grep -q "^- $1 " <<<"$installed"
}

# smart-splits.nvim v3 で herdr 連携が別リポジトリに分かれた。古い登録が残っていると
# manifest が見つからない警告が出るだけなので外す
if is_installed "smart-splits.nvim"; then
  herdr plugin unlink smart-splits.nvim >/dev/null
  echo "[herdr] unlinked: smart-splits.nvim (replaced by smart-splits-backend-herdr)"
fi

# ctrl+h/j/k/l: nvim の分割と herdr のペインを移動。lazy.nvim が clone したものをリンクする
smart_splits_dir="$HOME/.local/share/nvim/lazy/smart-splits-backend-herdr"
if is_installed "smart-splits-backend-herdr"; then
  echo "[herdr] already linked: smart-splits-backend-herdr"
elif [ -d "$smart_splits_dir" ]; then
  herdr plugin link "$smart_splits_dir" >/dev/null
  echo "[herdr] linked: smart-splits-backend-herdr"
else
  echo "[herdr] not found, skipping: $smart_splits_dir (先に nvim を起動してプラグインを入れる)"
fi

# prefix+e / prefix+o: herdr-nvim のサイドバーとファイルピッカー
if is_installed "chmarax.herdr-nvim"; then
  echo "[herdr] already installed: chmarax.herdr-nvim"
else
  herdr plugin install ChmaraX/herdr-nvim
  echo "[herdr] installed: chmarax.herdr-nvim"
fi
