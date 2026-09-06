{ pkgs, ... }:

let
  xterm256colorStrike = pkgs.runCommand "xterm-256color-strikethrough" { } ''
    mkdir -p $out
    ${pkgs.ncurses}/bin/tic -x -o $out ${./xterm-256color.src}
  '';
in
{
  home.file.".terminfo/78/xterm-256color".source = "${xterm256colorStrike}/78/xterm-256color";
}
