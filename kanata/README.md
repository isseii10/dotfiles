# キーリマップ (kanata・VIA・Karabiner)

## 分担

キーボードごとに、どこで何を決めるかを分けている。

| どこで | 何を | ファイル |
|---|---|---|
| VIA (キーボード本体) | **配置**: 1キーに1キーコード。Mac 向けの修飾キーの並び、Caps の位置、右 space を `KC_F24` にするなど。Bluetooth・RGB の Fn レイヤーもここ | `via/<キーボード>/layout.json` |
| kanata | **押し方**で変わるもの: tap/hold、記号レイヤー、`'`↔`"`・`;`↔`:`、⌘ 単体で英数・かな、⌘+hjkl、Caps→Control | `kanata/kanata.kbd` |
| Karabiner | MacBook 本体のキーボードとマウス | `karabiner/karabiner.json` (Neo Ergo は `ignore`) |

VIA を配置だけにしておくと、kanata のない環境でも Mac 向けの並びのまま打てる。押し方の判定は kanata に一本化しているので、VIA の LT・MT の代わりに kanata の tap-hold を使う。

左 space は普通の space (Neovim の leader と文章用)。記号レイヤーは右 space (VIA で `KC_F24`)。leader と記号は同じ「space↓ キー↓ space↑」の重ね打ちになり、kanata には区別できないので、親指を分けた。

## キーボードを増やすとき

kanata は1つのプロセスが1つの設定ファイルを読む。`kanata.kbd` は Neo Ergo 専用の作り (右 space の F24 など) で、`macos-dev-names-include` で Neo Ergo だけを掴んでいる。

- **同じ配列で使うキーボード**: `kanata.kbd` の `macos-dev-names-include` に名前を足す (名前は `sudo /opt/kanata/bin/kanata --list`)。
- **配列が違うキーボード**: キーボードごとの設定ファイル (`kanata/<キーボード>.kbd`、`via/<キーボード>/` と同じ名前) と LaunchDaemon (`kanata/darwin.nix`) を1つずつ足す。そのときに `kanata.kbd` も `kanata/neo_ergo.kbd` に改名し、LaunchDaemon の名前も揃える。

## 入れ方 (macOS)

1. Karabiner-Elements を入れる (`make darwin` の cask)。kanata は Karabiner のドライバーを借りるので、ドライバーの版に合う kanata を使う。Karabiner 16 のドライバー v8 には kanata v1.13.0 以降が要る。nixpkgs と Homebrew は 1.12.0 なので、[リリースページ](https://github.com/jtroo/kanata/releases) のバイナリを使う。
2. zip のチェックサムを確かめ、`kanata_macos_arm64` を root だけが書き込める場所に置く。
   ```
   sudo mkdir -p /opt/kanata/bin
   sudo install -o root -g wheel -m 755 kanata_macos_arm64 /opt/kanata/bin/kanata
   ```
3. `sudo /opt/kanata/bin/kanata --macos-request-permissions` を実行し、システム設定の「入力監視」と「アクセシビリティ」で kanata をオンにする (一覧になければ「＋」で `/opt/kanata/bin/kanata` を追加)。
4. `make darwin` で LaunchDaemon (`dev.kanata.kanata`、`kanata/darwin.nix`) が入る。`/var/log/kanata.log` に `keyboard grabbed` が出れば動いている。

VIA がキーボードを認識しないときは、メーカーの定義ファイル (JSON) を VIA の「Design」タブで読み込んでから、「Configure」の「Load Saved Layout」で `layout.json` を書き込む (Neo Ergo は https://qwertykeys.com/pages/fw の tri-mode 用)。

## 権限とセキュリティ

kanata は root で動き、キー入力をすべて読める。そのため次の形を保つ。

- **バイナリは `/opt/kanata/bin/kanata` に root:wheel で置く。** ユーザーが書き込める場所 (`/usr/local/bin` など) だと、差し替えで root を取られる。
- **使うのは `cmd` 無効版の `kanata_macos_arm64`。** 起動ログに `compiled to never allow cmd` と出る。zip に同梱の `cmd_allowed` 版は設定からシェルを実行できる。
- **起動引数は `-c` と `--no-wait` だけ。** TCP サーバー (`-p`) は外から操作する口になり、デバッグログ (`-d`・`-t`) は押したキーを記録しうる。
- **起動は launchd から。** herdr のペインから sudo で起動すると、macOS は起動元の herdr の権限で判定するので、アクセシビリティが通らない。
- **バイナリを置き換えたら、アクセシビリティと入力監視の kanata を削除して追加し直す。** 仮の署名なので、macOS はファイルの中身で許可を覚えている。

## 設定を変えたら

```
/opt/kanata/bin/kanata --check -c ~/dotfiles/kanata/kanata.kbd
sudo launchctl kickstart -k system/dev.kanata.kanata
```

ログは `/var/log/kanata.log`。

kanata が動いているのにリマップが効かないときは、ログに `keyboard grabbed` が出ているかを見る。`macos-continue-if-no-devs-found` で、`macos-dev-names-include` に合うキーボードが見つかるまでエラーを出さずに待つので、名前が合っていないと待ち続けるだけになる。名前は `sudo /opt/kanata/bin/kanata --list` で確かめる。
