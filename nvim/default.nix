{ config, pkgs, ... }:

{
  home.packages = [ pkgs.neovim ];

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
}
