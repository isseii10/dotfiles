{ config, pkgs, ... }:

{
  home.packages = [ pkgs.starship ];

  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/starship/starship.toml";
}
