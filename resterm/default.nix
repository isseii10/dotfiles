{ config, pkgs, ... }:

{
  home.packages = [ pkgs.resterm ];

  xdg.configFile."resterm".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/resterm";
}
