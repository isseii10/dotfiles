{ config, pkgs, ... }:

{
  home.packages = [ pkgs.git ];

  xdg.configFile."git/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/git/config";
}
