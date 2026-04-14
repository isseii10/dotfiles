.PHONY: darwin linux home

# macOS: darwin-rebuild + home-manager
darwin:
	sudo darwin-rebuild switch --flake ".#default" --impure
	home-manager switch --flake . --impure

# Linux(not NixOS): home-manager のみ
linux: home

# home-manager の適用（共通）
home:
	home-manager switch --flake . --impure
