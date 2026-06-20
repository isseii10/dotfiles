#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$DOTFILES_DIR/skills"

# スキルごとにシンボリックリンクを張る汎用関数
link_skills_individually() {
  local name="$1"
  local target_dir="$2"

  if ! command -v "$name" &>/dev/null; then
    echo "[$name] not installed, skipping"
    return
  fi

  mkdir -p "$target_dir"

  for skill in "$SKILLS_SRC"/*/; do
    local skill_name
    skill_name="$(basename "$skill")"
    # .system はツール管理なので除外
    [ "$skill_name" = ".system" ] && continue

    local link="$target_dir/$skill_name"
    if [ -L "$link" ]; then
      echo "[$name] already linked: $skill_name"
    elif [ -e "$link" ]; then
      echo "[$name] real entry exists, skipping: $skill_name"
    else
      ln -s "$skill" "$link"
      echo "[$name] linked: $skill_name"
    fi
  done
}

link_skills_individually "claude" "$HOME/.claude/skills"
link_skills_individually "codex"  "$HOME/.codex/skills"
