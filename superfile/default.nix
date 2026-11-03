{ config, pkgs, ... }:

let
  dir = "${config.home.homeDirectory}/dotfiles/superfile";
in
{
  # nixpkgs のバイナリ名は superfile なので、公式の短縮名 spf も用意する
  home.packages = [
    pkgs.superfile
    (pkgs.writeShellScriptBin "spf" ''exec ${pkgs.superfile}/bin/superfile "$@"'')
  ];

  # theme/ は superfile が起動時に既定テーマを書き出すので管理しない。
  # 設定ファイルだけをファイル単位でリンクする。
  xdg.configFile."superfile/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/config.toml";
  xdg.configFile."superfile/hotkeys.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/hotkeys.toml";
}
