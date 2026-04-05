{
  description = "Home Manager configuration of isseiterada";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # neovim を v0.11.2 に固定（v0.12.0 対応後に削除して pkgs.neovim に戻す）
    nixpkgs-neovim.url = "github:nixos/nixpkgs/e6f23dc08d3624daab7094b701aa3954923c6bbb";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-neovim,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-neovim = nixpkgs-neovim.legacyPackages.${system};
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];

        extraSpecialArgs = { inherit username homeDirectory pkgs-neovim; };
      };

      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/darwin
          { nixpkgs.hostPlatform = "aarch64-darwin"; }
        ];
      };
    };
}
