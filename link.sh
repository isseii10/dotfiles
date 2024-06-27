#!/bin/sh


# dotfiles dir

dotfiles_dir=$(pwd)



# TODO: シンボリックリンク作成を統一
# wezterm
for file in wezterm/*; do
echo $file
ln -s ${dotfiles_dir}/${file} ${HOME}/.config/${file}
done

