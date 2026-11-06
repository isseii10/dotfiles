# dotfiles

日本語で会話する。

## 反映の仕組み (Nix)

- nix-darwin + home-manager の flake で管理している。適用は `make darwin` (macOS) / `make home` (Linux)。`builtins.getEnv` を使うので `--impure` が要る。検証は `nix flake check --impure`。
- ツールごとのディレクトリに `default.nix` を置き、`home.nix` の `imports` に足す。
- 設定ファイルは `mkOutOfStoreSymlink` で `~/dotfiles/...` を直接指す。中身の編集はその場で反映され、再適用が要るのはパッケージやリンクを増減したときだけ。リポジトリの場所は `~/dotfiles` 固定。
- ツールが設定ディレクトリに状態を書き込むもの (herdr のソケットやログ、superfile の `theme/`) は、ディレクトリではなくファイル単位でリンクする。
- リンク先に実ファイルが既にあると switch が止まる。`.bak` に退避してから適用する。
- `git/config` だけは初回にコピーするテンプレート。編集しても `~/.config/git/config` には届かない。
- GUI アプリ (ghostty, karabiner-elements, wezterm) は `hosts/darwin` の homebrew casks で入れる。

## skills

- `skills/` の自作 skill は Nix ではなく `scripts/link-skills.sh` で `~/.claude/skills` と `~/.codex/skills` にリンクする。skill を足したら実行する。
- 他人の skill はコピーせずプラグインで入れる (Claude Code / Codex とも `mattpocock-skills`)。

## herdr

- config.toml の `plugin_action` が使うプラグインは `scripts/link-herdr-plugins.sh` で登録する。プラグインを足したらスクリプトにも足す。
- 設定を変えたら `herdr config check` してから `herdr server reload-config`。
- popup のコマンドには `HERDR_PANE_ID` が渡らない。呼び出し元のペインは `HERDR_ACTIVE_PANE_ID` で取る。PATH も最小なので `$HOME/.nix-profile/bin` を先頭に足す。
- herdr-nvim のサイドバーは、常駐するデーモン nvim に `--remote-ui` でつないでいるだけ。デーモンの環境変数は最初に起動したときのままなので、`HERDR_PANE_ID` は `nvim/lua/user/extras/smart-splits.lua` で追従させている。デーモンを作り直すときはサイドバーで `:qa` してから開き直す。

## Neovim

- プラグインは `nvim/lua/user/` (補助的なものは `extras/`) に lazy.nvim の spec を1ファイルずつ書き、`nvim/init.lua` で `register "user.<name>"` / `register "user.extras.<name>"` する。

## コミット

- Conventional Commits で、scope はツール名にする (`feat(nvim): ...`、`fix(herdr): ...`)。
