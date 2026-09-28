{ ... }:

{
  system.stateVersion = 6;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.primaryUser = builtins.getEnv "SUDO_USER";

  # ctrl+cmd を押しながらウィンドウのどこでもドラッグして移動できるようにする
  # (ghostty はタイトルバーを消しているのでマウスで掴む場所がない)。反映にはログインし直しが必要
  system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;

  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "karabiner-elements"
      "wezterm"
    ];
  };
}
