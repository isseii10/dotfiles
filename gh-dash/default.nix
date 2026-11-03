{ config, ... }:

{
  xdg.configFile."gh-dash/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/gh-dash/config.yml";
}
