#!/bin/sh

# dotfiles dir
dotfiles_dir=${HOME}/dotfiles
config_dir=${HOME}/.config

# TODO: シンボリックリンク作成を統一

# zsh
ln -s ${dotfiles_dir}/zsh/zshenv.home ${HOME}/.zshenv
ln -s ${dotfiles_dir}/zsh/zshenv ${config_dir}/.zshenv
ln -s ${dotfiles_dir}/zsh/zshrc ${config_dir}/.zshrc
# wezterm
ln -s ${dotfiles_dir}/wezterm ${config_dir}/wezterm
# nvim
ln -s ${dotfiles_dir}/nvim ${config_dir}/nvim
# starship
ln -s ${dotfiles_dir}/starship.toml ${config_dir}/starship.toml
