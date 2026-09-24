{ config, ... }:

let
  herdrDir = "${config.home.homeDirectory}/dotfiles/herdr";
in
{
  # ~/.config/herdr にはソケットやログ、session.json も置かれるのでディレクトリごとではなくファイル単位でリンクする
  xdg.configFile."herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${herdrDir}/config.toml";
  xdg.configFile."herdr/scripts".source =
    config.lib.file.mkOutOfStoreSymlink "${herdrDir}/scripts";
}
