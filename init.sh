#!/bin/bash
set -e

# Nix インストール
if ! command -v nix &>/dev/null; then
  curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
fi

# Nix デーモンの環境変数を現在のシェルに読み込む
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS: nix-darwin + home-manager
  sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake ".#default" --impure
  NIX_CONFIG="extra-experimental-features = nix-command flakes" home-manager switch --flake . --impure
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux: home-manager のみ
  NIX_CONFIG="extra-experimental-features = nix-command flakes" home-manager switch --flake . --impure
fi
