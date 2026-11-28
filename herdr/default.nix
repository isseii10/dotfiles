{ config, lib, ... }:

let
  herdrDir = "${config.home.homeDirectory}/dotfiles/herdr";

  # herdr に登録するプラグイン。switch のたびに、まだ登録されていないものだけ入れる。
  # id は `herdr plugin list` に出る名前、install は `herdr plugin install` の引数
  plugins = [
    # prefix+e / prefix+o: herdr-nvim のサイドバーとファイルピッカー
    { id = "chmarax.herdr-nvim"; install = "ChmaraX/herdr-nvim"; }
    # prefix+s / prefix+a: workspace と agent の picker (自作。開発中は herdr plugin link ~/dev/herdr-pickers)
    { id = "isseii10.herdr-vipicker"; install = "isseii10/herdr-vipicker"; }
  ];

  # lazy.nvim が clone したものをリンクするプラグイン。nvim を一度起動するまではディレクトリがない
  linkedPlugins = [
    # ctrl+h/j/k/l: nvim の分割と herdr のペインを移動
    { id = "smart-splits-backend-herdr"; dir = "${config.home.homeDirectory}/.local/share/nvim/lazy/smart-splits-backend-herdr"; }
  ];

  # 置き換わったり名前が変わったりして、もう使わない登録
  removedPlugins = [
    "smart-splits.nvim" # smart-splits.nvim v3 で smart-splits-backend-herdr に分かれた
    "isseii10.herdr-pickers" # herdr-vipicker に名前が変わった
    "herdr.auto-title" # 使わなくなった
  ];

  installCmd = p: ''
    if ! is_installed ${p.id}; then
      if herdr plugin install ${p.install} --yes >/dev/null; then
        echo "[herdr] installed: ${p.id}"
        ${lib.optionalString (p ? restart) "herdr plugin action invoke ${p.restart} >/dev/null 2>&1 || true"}
      fi
    fi
  '';
  linkCmd = p: ''
    if ! is_installed ${p.id}; then
      if [ -d "${p.dir}" ]; then
        herdr plugin link "${p.dir}" >/dev/null && echo "[herdr] linked: ${p.id}"
      else
        echo "[herdr] not found, skipping: ${p.dir} (先に nvim を起動してプラグインを入れる)"
      fi
    fi
  '';
  removeCmd = id: ''
    if is_installed ${id}; then
      { herdr plugin uninstall ${id} || herdr plugin unlink ${id}; } >/dev/null 2>&1 && echo "[herdr] removed: ${id}"
    fi
  '';
in
{
  # ~/.config/herdr にはソケットやログ、session.json も置かれるのでディレクトリごとではなくファイル単位でリンクする
  xdg.configFile."herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${herdrDir}/config.toml";
  xdg.configFile."herdr/scripts".source =
    config.lib.file.mkOutOfStoreSymlink "${herdrDir}/scripts";
  xdg.configFile."herdr-nvim/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${herdrDir}/herdr-nvim.toml";

  # 上のプラグインを herdr に登録する。activation の PATH は最小限で /usr/bin もないので、
  # herdr や git のある profile の bin と、ビルドが使う curl などのある /usr/bin を足す。
  # オフラインなどで失敗しても switch は止めない
  home.activation.herdrPlugins = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ -z "''${DRY_RUN:-}" ]; then
      (
        PATH="${config.home.profileDirectory}/bin:/usr/bin:/bin:$PATH"
        command -v herdr >/dev/null || exit 0
        installed="$(herdr plugin list 2>/dev/null)"
        is_installed() { grep -q "^- $1 " <<<"$installed"; }
        ${lib.concatMapStrings removeCmd removedPlugins}
        ${lib.concatMapStrings linkCmd linkedPlugins}
        ${lib.concatMapStrings installCmd plugins}
      ) || echo "[herdr] plugin setup failed" >&2
    fi
  '';
}
