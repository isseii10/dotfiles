#!/bin/sh


# dotfiles dir

dotfiles_dir=$(pwd)



# TODO: シンボリックリンク作成を統一
# wezterm
ln -s ${dotfiles_dir}/wezterm ${HOME}/.config
# lvim
ln -s ${dotfiles_dir}/lvim ${HOME}/.config
# nvim
# ln -s ${dotfiles_dir}/nvim ${HOME}/.config
# starship
ln -s ${dotfiles_dir}/starship.toml ${HOME}/.config/starship.toml
