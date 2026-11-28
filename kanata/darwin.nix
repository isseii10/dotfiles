{ config, pkgs, ... }:

# kanata の LaunchDaemon (dev.kanata.kanata)。入れ方と権限は kanata/README.md。
# 設定ファイルのパスは make darwin を実行したユーザー (system.primaryUser) のホームから作るので、
# ユーザー名の違う Mac でもそのまま使える。
let
  # kanata は起動時につながっていたキーボードしか登録しない (抜き差しなら掴み直す)。
  # 起動時になかった Neo Ergo を後から掴ませるため、つながった瞬間に kanata を起動し直す。
  rescan = pkgs.writeShellScript "kanata-rescan" ''
    state=/var/run/dev.kanata.rescan.present
    # hidutil はつながっている HID デバイスだけを一覧にする。ioreg で全プロパティを出すより十数倍軽い
    if /usr/bin/hidutil list | /usr/bin/grep -q ' Neo Ergo '; then
      now=1
    else
      now=0
    fi
    prev=$(/bin/cat "$state" 2>/dev/null || echo 0)
    echo "$now" > "$state"
    if [ "$now" = 1 ] && [ "$prev" = 0 ]; then
      echo "$(/bin/date '+%H:%M:%S') Neo Ergo connected, restarting kanata"
      /bin/launchctl kickstart -k system/dev.kanata.kanata
    fi
  '';
in
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

  launchd.daemons.kanata-rescan.serviceConfig = {
    Label = "dev.kanata.rescan";
    ProgramArguments = [ "${rescan}" ];
    StartInterval = 10;
    StandardOutPath = "/var/log/kanata.log";
    StandardErrorPath = "/var/log/kanata.log";
  };
}
