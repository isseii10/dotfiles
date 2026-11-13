{
  description = "Home Manager configuration of isseiterada";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
      home-manager,
      nix-darwin,
      ...
    }:
    let
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";
      system = builtins.currentSystem;
      pkgs = import nixpkgs {
        inherit system;
        # unfree は明示したものだけ許可する
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "obsidian"
          ];
      };
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit username homeDirectory; };
      };

      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/darwin
          { nixpkgs.hostPlatform = "aarch64-darwin"; }
        ];
      };
    };
}
