{ ... }:

{
  system.stateVersion = 6;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.primaryUser = builtins.getEnv "SUDO_USER";

  homebrew = {
    enable = true;
    casks = [
      "wezterm"
    ];
  };
}
