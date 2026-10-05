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
    casks = [
      "ghostty"
      "karabiner-elements"
      "wezterm"
    ];
  };
}
