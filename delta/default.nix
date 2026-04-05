{ config, pkgs, ... }:

{
  home.packages = [ pkgs.delta ];

  xdg.configFile."delta".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/delta";
}
