{ config, ... }:

# kanata を root の LaunchDaemon として動かす (/Library/LaunchDaemons/dev.kanata.kanata.plist)。
# 設定ファイルのパスは make darwin を実行したユーザー (system.primaryUser) のホームから作るので、
# ユーザー名の違う Mac でもそのまま使える。
# herdr のペインなどから sudo で起動すると、macOS は起動元のアプリで権限を確かめるため、
# kanata 自身にアクセシビリティを許可しても通らない。launchd から起動すれば kanata 自身の許可が使われる。
#
# バイナリは nixpkgs の kanata (1.12.0) が Karabiner 16 のドライバー v8 に対応していないので、
# v1.13.0 のプレリリース版を手で /opt/kanata/bin/kanata に置いている。
# root で動くので、バイナリもフォルダも root:wheel にする (ユーザーが書き込める場所だと、差し替えで root を取られる)。
# 設定を変えたあと: sudo launchctl kickstart -k system/dev.kanata.kanata
# ログ: /var/log/kanata.log
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
