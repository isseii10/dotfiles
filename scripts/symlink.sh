#!/bin/bash

# dotfiles dir
dotfiles_dir=${HOME}/dotfiles
config_dir=${HOME}/.config
# なかったら作成

create_symlink() {
  local target="$1" # リンク元
  local link="$2"   # リンク先

  if [ -L "$link" ]; then
    echo "Link already exists: $link -> $(readlink "$link")"
  elif [ -e "$link" ]; then
    echo "File already exists and is not a symlink: $link"
  else
    ln -s "$target" "$link"
    echo "Created symlink: $link -> $target"
  fi
}

# zsh
create_symlink ${dotfiles_dir}/zsh/zshenv.home ${HOME}/.zshenv
create_symlink ${dotfiles_dir}/zsh/zshenv ${config_dir}/zsh/.zshenv
create_symlink ${dotfiles_dir}/zsh/zshrc ${config_dir}/zsh/.zshrc
# wezterm
create_symlink ${dotfiles_dir}/wezterm ${config_dir}/wezterm
# nvim
create_symlink ${dotfiles_dir}/nvim ${config_dir}/nvim
# starship
create_symlink ${dotfiles_dir}/starship.toml ${config_dir}/starship.toml
# karabiner
create_symlink ${dotfiles_dir}/karabiner ${config_dir}/karabiner
# lazygit
create_symlink ${dotfiles_dir}/lazygit ${config_dir}/lazygit
