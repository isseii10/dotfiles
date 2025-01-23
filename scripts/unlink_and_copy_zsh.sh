#!/bin/bash

# シンボリックリンクを解除して実体に置き換える
replace_symlink() {
  local file="$1"

  if [ -L "$file" ]; then
    target=$(readlink -f "$file")
    rm "$file"
    cp "$target" "$file"
    echo "Replaced symlink $file with the actual file."
  else
    echo "Error: $file is not a symlink."
    exit 1
  fi
}

# 対象のシンボリックリンクを順次処理
replace_symlink "$HOME/.config/zsh/.zshrc"
replace_symlink "$HOME/.config/zsh/.zshenv"

