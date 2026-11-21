{ ... }:

{
  system.stateVersion = 6;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.primaryUser = builtins.getEnv "SUDO_USER";

  # ctrl+cmd を押しながらウィンドウのどこでもドラッグして移動できるようにする
  # (ghostty はタイトルバーを消しているのでマウスで掴む場所がない)。反映にはログインし直しが必要
  system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;

  # /etc/zshrc で compinit / promptinit を実行しない。
  # 補完は plugins.zsh で fpath を整えてから compinit するため、二重実行になると
  # fpath の差で毎回 .zcompdump が再生成され起動が遅くなる。プロンプトは starship を使う。
  programs.zsh.enableCompletion = false;
  programs.zsh.promptInit = "";

  homebrew = {
    enable = true;
    # GUI アプリは brew の cask で入れる (CLI は home.packages)。
    # nixpkgs のバイナリ配布版 (ghostty-bin など) を home-manager に置かせると、Developer ID 署名の
    # アプリは App Management で守られ、権限のないシェル (herdr のペインなど) から適用できなくなる。
    # karabiner はドライバとデーモンを入れるので、もともと brew に任せている
    # (nix-darwin のモジュールは nixpkgs 更新のたびに入力監視の許可を付け直す必要が出やすい)。
    casks = [
      "arc"
      "claude"
      "codex"
      "ghostty"
      "karabiner-elements"
      "obsidian"
      "qmk-toolbox"
      "raycast"
      "scroll-reverser"
      "wezterm"
    ];
  };
}
