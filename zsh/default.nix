{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    zsh-autopair
    zsh-fzf-tab
    zsh-completions
    zsh-defer
  ];

  home.file.".zshenv".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/zshenv.home";

  xdg.configFile = {
    "zsh/.zshrc".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/zshrc";
    "zsh/.zshenv".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/zshenv";
    "zsh/.zprofile".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/zprofile";

    # プラグインのsourceパスをNixストアから生成
    # zshrc から最初に読み込む。補完の初期化 (compinit, fzf-tab) は同期で行い、
    # 入力しながら効けばよいプラグインは zsh-defer でプロンプト表示後に回す。
    "zsh/plugins.zsh".text = ''
      source ${pkgs.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh

      # 遅延タスクごとに precmd フックや reset-prompt を走らせない (-a)。stdout だけ捨てる (+1)。
      # フックとプロンプト再描画は zshrc の最後で1回だけ行う。
      # zsh-defer は zle -F を -w なしで登録するので $PENDING が見えず、入力があってもキューを止めない。
      # -t 0.01 で1タスクごとに zle へ戻し、先に打ったコマンドが待たされるのをタスク1つ分までにする。
      _zdefer() { zsh-defer -a +1 -t 0.01 "$@" }

      fpath+=(
        ${pkgs.zsh-completions}/share/zsh/site-functions
        ${pkgs.zsh-fzf-tab}/share/fzf-tab
      )

      # Completion system must be initialized before completion-related plugins.
      # /bin/zsh と nix の zsh で fpath が異なるため、dump をバージョン別に分けて互いに無効化し合わないようにする。
      # compaudit (安全性チェック) が起動時間の大半を占めるので、fpath が前回と同じで dump が24時間以内なら
      # -C で省く。nix の更新で fpath が変わったときと、1日1回はフルで作り直す。
      () {
        local dir="$XDG_CACHE_HOME/zsh"
        local dump="$dir/zcompdump-$ZSH_VERSION" stamp="$dir/zcompdump-$ZSH_VERSION.fpath"
        local cur="''${(j.:.)fpath}"
        local -a fresh=( $dump(N.mh-24) )
        [[ -d $dir ]] || mkdir -p $dir
        autoload -Uz compinit
        if (( $#fresh )) && [[ -f $stamp && "$(<$stamp)" == "$cur" ]]; then
          compinit -C -d $dump
        else
          compinit -d $dump
          # 中身が変わらないと compinit は dump を書き直さないので、mtime を更新して次の24時間は -C にする
          touch $dump
          print -r -- $cur >| $stamp
        fi
      }

      # fzf-tab は compinit の後、ウィジェットを包むプラグインより前に読む。Tab の挙動に直結するので同期。
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      _zdefer source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      _zdefer source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      _zdefer -c "bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down"
      _zdefer source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
      # zsh-syntax-highlighting should be sourced after other widgets are defined.
      _zdefer source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    '';
  };
}
