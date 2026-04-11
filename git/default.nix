{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.git ];

  # テンプレートを初回のみコピー（既存ファイルは上書きしない）
  home.activation.copyGitConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "${config.home.homeDirectory}/.config/git/config" ]; then
      $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/git"
      $DRY_RUN_CMD cp "${config.home.homeDirectory}/dotfiles/git/config" \
        "${config.home.homeDirectory}/.config/git/config"
    fi
  '';
}
