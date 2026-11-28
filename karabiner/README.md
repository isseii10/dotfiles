# Karabiner-Elements

リマップはしない。kanata が使うドライバー (Karabiner-DriverKit-VirtualHIDDevice) を入れて更新するためだけに入れている。キーのリマップは kanata (`kanata/README.md`)。

## 掴ませないキーボード (`ignore`)

Karabiner は初期設定でキーボードを掴むので、kanata と取り合わないよう、キーボードはすべて `karabiner.json` の `devices` で `ignore` にしている。合っていないと Karabiner が先に掴み、kanata にキーが届かない。

`ignore` の条件は、Karabiner が見ている ID (`device_identifiers`) と一致させる。ID は Karabiner-EventViewer の「Devices」か `/Applications/Karabiner-Elements.app/Contents/Helpers/karabiner_cli --list-connected-devices` で見る。別の Mac では一致しているか確かめる。

| 機器 | `device_identifiers` | 備考 |
|---|---|---|
| MacBook 本体のキーボード | `{is_keyboard}` だけ、または `{is_keyboard, 1452, 641}` | Mac によって vendor/product の ID があるものとないものがあるので、両方入れている |
| Neo Ergo | `{is_keyboard, is_pointing_device, 65534, 75}` と `{is_keyboard, 65534, 75}` | 口が2つある |
| ELECOM のマウスのレシーバー | `{is_keyboard, 1390, 4351}` | ボタンに割り当てたキー操作が通る口。マウスの口は Karabiner が初期設定で掴まない |

EventViewer には、`ignore` した機器の信号も表示される (横から見ているだけ)。

## 上げるとき

Homebrew だけで上げる。

```
brew upgrade --cask karabiner-elements
```

- アプリ自身の更新は `karabiner.json` の `global.check_for_updates: false` で止めている。アプリが自分で上がると Homebrew の記録 (`/opt/homebrew/Caskroom/karabiner-elements/<版>`) が古いまま残り、次の `brew upgrade` が記録の版を消す手順を実行して、新しいドライバーのファイル (`/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice`) まで消す。記録がずれていたら、`rm -rf /opt/homebrew/Caskroom/karabiner-elements` で記録だけ消してから `brew install --cask karabiner-elements` で入れ直す。
- この cask は `auto_updates` なので、名前を指定しない `brew upgrade` では上がらない。
- 上げる前に、新しい版のドライバーが kanata と同じ形式で話すか確かめる (Karabiner-Elements のリポジトリの `vendor/Karabiner-DriverKit-VirtualHIDDevice` が指す `version.json` の `client_protocol_version`。kanata v1.13 は 7)。
- 上げるとドライバーが入れ替わり、kanata は一度キーボードを手放して掴み直す。そのとき Karabiner と取り合って Neo Ergo を掴み損ねることがあるので、上げたら Neo Ergo で試し、効かなければ `sudo launchctl kickstart -k system/dev.kanata.kanata`。
