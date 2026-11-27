{ config, ... }:

# kanata の LaunchDaemon (dev.kanata.kanata)。入れ方と権限は kanata/README.md。
# 設定ファイルのパスは make darwin を実行したユーザー (system.primaryUser) のホームから作るので、
# ユーザー名の違う Mac でもそのまま使える。
{
  launchd.daemons.kanata.serviceConfig = {
    Label = "dev.kanata.kanata";
    ProgramArguments = [
      "/opt/kanata/bin/kanata"
      "-c"
      "/Users/${config.system.primaryUser}/dotfiles/kanata/kanata.kbd"
      # エラー時に Enter 待ちで止まらず終了し、KeepAlive で起動し直させる
      "--no-wait"
    ];
    RunAtLoad = true;
    KeepAlive.SuccessfulExit = false;
    StandardOutPath = "/var/log/kanata.log";
    StandardErrorPath = "/var/log/kanata.log";
  };
}
