# dotfiles

macOS と Linux の開発環境の設定。nix-darwin と home-manager の flake で管理している。

## セットアップ

リポジトリは `~/dotfiles` に置く (場所は固定)。

```sh
git clone https://github.com/isseii10/dotfiles ~/dotfiles
cd ~/dotfiles
./init.sh
```

`init.sh` は Nix が無ければ入れ、macOS では nix-darwin と home-manager、Linux では home-manager を適用する。

## 反映

2回目からは `make` で適用する。

| コマンド | 内容 |
|---|---|
| `make darwin` | macOS。`darwin-rebuild switch` のあと `home-manager switch` |
| `make home` | Linux (NixOS ではない)。`home-manager switch` のみ |
| `nix flake check --impure` | 検証 |

`flake.nix` が `builtins.getEnv` でユーザー名とホームディレクトリを読むので、どれも `--impure` が要る。

- 設定ファイルは `~/dotfiles/...` を直接指すシンボリックリンクにしている。中身を編集すればその場で反映され、再適用が要るのはパッケージやリンクを増減したときだけ。
- リンク先に実ファイルが既にあると適用が止まる。`.bak` に退避してから適用し直す。
- `git/config` は初回にコピーするだけのテンプレート。編集しても `~/.config/git/config` には届かない。
- CLI は `home.nix` の `home.packages`、GUI アプリは `hosts/darwin` の homebrew casks で入れる。

## 構成

| パス | 内容 |
|---|---|
| `flake.nix` / `home.nix` | flake の入口と home-manager の設定。ツールごとのディレクトリを `home.nix` の `imports` で読み込む |
| `hosts/darwin` / `hosts/linux` | OS ごとの設定。macOS の GUI アプリ (homebrew casks) もここ |
| [`nvim`](nvim/README.md) | Neovim。プラグインの一覧はリンク先 |
| `zsh` / `starship` | シェルとプロンプト |
| `ghostty` / `wezterm` / `terminfo` | ターミナル |
| `herdr` | コーディングエージェント向けのターミナルマルチプレクサ |
| `git` / `delta` / `lazygit` / `gh-dash` / `hunk` | Git まわり |
| `superfile` | ファイルマネージャ |
| `resterm` | HTTP クライアント |
| `kanata` | Neo Ergo のリマップ (tap/hold、space レイヤー、英数・かな)。LaunchDaemon の plist も置く |
| `via` | Neo Ergo の VIA のキーマップ (キーの配置だけ。押し方で変わるものは kanata) |
| `karabiner` | 本体キーボードとマウスのリマップ |
| `raycast` | Raycast の設定のエクスポート |
| `skills` | Claude Code / Codex の自作 skill |
| `scripts` | Nix の外でリンクするためのスクリプト |

## Nix の外で入れるもの

- `skills/` の skill は `scripts/link-skills.sh` で `~/.claude/skills` と `~/.codex/skills` にリンクする。skill を足したら実行する。
- herdr の `plugin_action` が使うプラグインは `scripts/link-herdr-plugins.sh` で登録する。
- kanata は v1.13.0 のプレリリース版のバイナリを `/usr/local/bin/kanata` に置き、`kanata/dev.kanata.kanata.plist` を `/Library/LaunchDaemons/` にコピーして起動する (手順は plist の先頭)。nixpkgs と Homebrew の 1.12.0 は Karabiner 16 のドライバー v8 に対応していない。
- `via/neo_ergo.layout.json` は VIA の「Load Saved Layout」で書き込む。
