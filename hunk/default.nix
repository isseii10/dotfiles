{ config, ... }:

let
  hunkDir = "${config.home.homeDirectory}/dotfiles/hunk";
in
{
  # ~/.config/hunk には state.json も置かれるのでファイル単位でリンクする
  xdg.configFile."hunk/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${hunkDir}/config.toml";
}
