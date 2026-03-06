# Zsh設定ファイルの再構成分析

## Zsh初期化ファイルの読み込み順序と用途

1. **zshenv**: すべてのシェル(対話/非対話、ログイン/非ログイン)で読み込まれる
   - 環境変数、PATH設定
   - スクリプトやcronからも参照される設定

2. **zshprofile**: ログインシェルでのみ読み込まれる(zshenvの後)
   - ログイン時に一度だけ実行したい重い初期化処理
   - グラフィカルセッションの起動設定

3. **zshrc**: 対話シェルで読み込まれる(zshprofileの後)
   - エイリアス、関数、キーバインド
   - プロンプト、補完設定
   - 対話シェルのみで必要な設定

## 現在のzshrcの設定分類

### zshenvに移動すべき設定:
- 環境変数: OBSIDIAN_VAULT_PATH, ANDROID_HOME, MANPAGER, FZF_DEFAULT_COMMAND, GITHUB_TOKEN
- PATH設定: cargo, homebrew, make, WezTerm, Android SDK
- LS_COLORS(補完で使用)
- BAT_THEME(既にzshenvにある)

### zshprofileに移動すべき設定:
- 現状は`mise activate --shims`のみで適切

### zshrcに残すべき設定:
- setopt設定(対話シェルの動作)
- エイリアス(vi, vim, ls, catなど)
- キーバインド(bindkey)
- プロンプト初期化: starship
- 対話的ツール: direnv, zoxide, mise activate zsh
- プラグイン: autosuggestions, syntax-highlighting等
- 補完設定(zstyle)
- edit-command-line設定

## 追加の改善点:
- zshenv.homeの`.cargo/env`をzshenvに移動
- GITHUB_TOKENの取得はzshenvで行う(ghコマンドがPATHにある前提)
