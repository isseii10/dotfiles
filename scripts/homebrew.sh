#!/bin/bash

# Homebrewがなければインストール
if ! command -v brew &>/dev/null; then
  echo "Homebrew is not installed. Installing now..."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  echo "Homebrew installation complete."
else
  echo "Homebrew is already installed. Nothing to do."
fi

# Brewfileからインストール
if [[ -f "~/dotfiles/scripts/Brewfile" ]]; then
  echo "Brewfile found. Installing packages..."

  brew bundle --file="$HOME/dotfiles/scripts/Brewfile" --cleanup

  echo "Packages from Brewfile installed."
else
  echo "Brewfile not found. Skipping package installation."
fi
