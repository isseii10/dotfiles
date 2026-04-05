#!/bin/bash

# dotfiles dir
dotfiles_dir=${HOME}/dotfiles
config_dir=${HOME}/.config

# 必要なディレクトリを作成
mkdir -p ${config_dir}/zsh

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

# zsh (managed by Home Manager)
# create_symlink ${dotfiles_dir}/zsh/zprofile ${config_dir}/zsh/.zprofile
# create_symlink ${dotfiles_dir}/zsh/zshenv.home ${HOME}/.zshenv
# create_symlink ${dotfiles_dir}/zsh/zshenv ${config_dir}/zsh/.zshenv
# create_symlink ${dotfiles_dir}/zsh/zshrc ${config_dir}/zsh/.zshrc
# wezterm (managed by Home Manager)
# create_symlink ${dotfiles_dir}/wezterm ${config_dir}/wezterm
# nvim (managed by Home Manager)
# create_symlink ${dotfiles_dir}/nvim ${config_dir}/nvim
# starship (managed by Home Manager)
# create_symlink ${dotfiles_dir}/starship.toml ${config_dir}/starship.toml
# karabiner (managed by Home Manager)
# create_symlink ${dotfiles_dir}/karabiner ${config_dir}/karabiner
# git (managed by Home Manager)
# create_symlink ${dotfiles_dir}/git/config ${config_dir}/git/config
# lazygit (managed by Home Manager)
# create_symlink ${dotfiles_dir}/lazygit ${config_dir}/lazygit
# delta (managed by Home Manager)
# create_symlink ${dotfiles_dir}/delta ${config_dir}/delta
# yazi file brawser
create_symlink ${dotfiles_dir}/yazi ${config_dir}/yazi
# resterm (postman alternative)
create_symlink ${dotfiles_dir}/resterm ${config_dir}/resterm
