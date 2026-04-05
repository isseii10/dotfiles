{ config, pkgs-neovim, ... }:

{
  home.packages = [ pkgs-neovim.neovim ];

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
}
