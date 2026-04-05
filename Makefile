.PHONY: switch darwin home init

# macOS: darwin + home-manager を両方適用
switch: darwin home

# nix-darwin の適用
darwin:
	sudo darwin-rebuild switch --flake ".#default" --impure

# home-manager の適用
home:
	home-manager switch --flake . --impure

# 初回セットアップ（nix-darwin 未インストール時）
init:
	sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake ".#default" --impure
	NIX_CONFIG="extra-experimental-features = nix-command flakes" home-manager switch --flake . --impure
