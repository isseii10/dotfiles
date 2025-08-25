# AGENTS.md - 開発者ハンドオーバードキュメント

## プロジェクト概要

このリポジトリは個人用のdotfiles設定管理システムです。主にmacOS環境でのターミナル、エディタ、キーボードカスタマイズなどの開発環境を統一的に管理しています。

### 主要コンポーネント
- **Neovim**: 高度にカスタマイズされたエディタ設定（Lazy.nvim使用）
- **WezTerm**: ターミナルエミュレータ設定
- **Zsh**: シェル環境設定とプラグイン管理
- **Karabiner Elements**: キーボードカスタマイズ
- **Starship**: プロンプトテーマ設定
- **Raycast**: ランチャー設定

## セットアップと初期化

### 初回セットアップ
```bash
# リポジトリをクローン
git clone git@github.com:isseii10/dotfiles ~/.config/isseii10/dotfiles

# 初期セットアップスクリプト実行
cd ~/.config/isseii10/dotfiles
./init.sh
```

### セットアップスクリプトの動作
1. **Homebrew インストール**: `scripts/homebrew.sh`
   - Homebrewが未インストールの場合は自動インストール
   - `scripts/Brewfile`から必要なパッケージを一括インストール

2. **シンボリックリンク作成**: `scripts/symlink.sh`
   - 各設定ファイルを適切な場所にリンク

### 重要なシンボリックリンクマッピング
```
nvim/          → ~/.config/nvim
wezterm/       → ~/.config/wezterm
karabiner/     → ~/.config/karabiner
zsh/zshenv.home → ~/.zshenv
zsh/zshrc      → ~/.config/zsh/.zshrc
starship.toml  → ~/.config/starship.toml
```

## Neovim設定アーキテクチャ

### プラグイン管理システム
- **プラグインマネージャー**: Lazy.nvim
- **ローディング方式**: イベントベースの遅延ローディング
- **設定構造**: `nvim/lua/user/` 内のモジュラー構成

### 核心システム
1. **LAZY_PLUGIN_SPEC**: `nvim/lua/user/launch.lua`
   - グローバルプラグイン仕様テーブル
   - `spec()` 関数でプラグインを登録

2. **プラグイン構成**: `nvim/init.lua`
   - 各プラグインは `spec "user.plugin_name"` 形式で読み込み
   - カテゴリ別に整理（core, extras）

### 主要プラグインカテゴリ
- **LSP関連**: nvim-lspconfig, mason.nvim, conform.nvim
- **補完**: nvim-cmp, copilot.lua
- **ファイラー**: nvim-tree.lua, telescope.nvim
- **Git統合**: gitsigns.nvim, git-conflict.nvim
- **Go開発**: go.nvim（専用サポート）
- **デバッグ**: nvim-dap, neotest

### LSP設定
対応言語サーバー:
- Go (gopls)
- TypeScript/JavaScript
- Python (pyright)
- Lua (lua_ls)
- Terraform (terraformls)
- その他13言語

## ターミナル環境

### WezTerm設定
- **テーマ**: Tokyo Night
- **透明度**: 90%
- **フォント**: JetBrains Mono + Hiragino Sans
- **統合機能**: Neovimとのペイン移動/リサイズ連携（smart-splits.nvim）

### Zsh設定
- **プロンプト**: Starship
- **プラグイン**: 
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-history-substring-search
  - zsh-autopair

### ツールバージョン管理
- **mise**: Node.js v20固定（`mise.toml`）
- **PATH設定**: Homebrew、Android SDK、cargo等

## キーボードカスタマイズ

### Karabiner Elements設定
1. **修飾キー変更**:
   - Caps Lock → Left Control (基本)
   - マウス中ボタン → Mission Control

2. **記号キー交換**:
   - セミコロン ↔ コロン
   - シングルクォート ↔ ダブルクォート

3. **Vim風ナビゲーション**:
   - Cmd+hjkl → 矢印キー

4. **言語切り替え**:
   - 左Cmd単体 → 英数
   - 右Cmd単体 → かな

## 重要な運用ルール

### パッケージ管理
```bash
# 新しいパッケージ追加
brew bundle dump --file=scripts/Brewfile --force

# パッケージ更新
brew bundle --file=scripts/Brewfile
```

### 設定変更時の注意点
1. **シンボリックリンク**: `scripts/symlink.sh`で管理されているため、直接編集可能
2. **バックアップ**: 既存ファイルがある場合はスクリプトが警告表示
3. **プラグイン追加**: Neovimプラグインは`nvim/lua/user/`に新ファイル作成後、`init.lua`で`spec`呼び出し

### トラブルシューティング

#### よくある問題
1. **Homebrewパス問題**: 
   - Intel Mac: `/usr/local/bin/brew`
   - Apple Silicon: `/opt/homebrew/bin/brew`

2. **シンボリックリンクエラー**:
   ```bash
   # 既存ファイル確認
   ls -la ~/.config/nvim
   # 手動削除後に再実行
   rm ~/.config/nvim && ./scripts/symlink.sh
   ```

3. **Neovimプラグインエラー**:
   ```bash
   # キャッシュクリア
   rm -rf ~/.local/share/nvim
   # 再起動してプラグイン再インストール
   ```

### 開発言語別設定

#### Go開発
- **プラグイン**: go.nvim（フル機能）
- **LSP**: gopls
- **テスト**: neotest-golang
- **デバッグ**: nvim-dap設定済み

#### その他言語
- **TypeScript/JavaScript**: 完全LSP対応
- **Python**: pyright + 自動フォーマット
- **Terraform**: 構文ハイライト + LSP

## メンテナンス指針

### 定期的な更新作業
1. **月次**:
   - `brew update && brew upgrade`
   - Neovimプラグイン更新（Lazy.nvim UI）

2. **四半期**:
   - 不要なパッケージ削除
   - `lazy-lock.json`のコミット

3. **年次**:
   - macOSアップデート対応
   - 新しいツール評価と導入

### 設定ファイルの優先順位
1. **Neovim**: 最も重要、Go開発の核心
2. **ターミナル(WezTerm + Zsh)**: 日常的な使用頻度が高い
3. **キーボード(Karabiner)**: 生産性に直結
4. **その他**: 補助的だが環境統一に必要

## セキュリティ考慮事項

### 機密情報管理
- **GitHub Token**: `gh auth token`で動的取得
- **秘密鍵**: dotfilesに含めない
- **個人情報**: コミット前の確認必須

### 権限管理
- **実行権限**: スクリプトファイルのみ
- **シンボリックリンク**: 既存ファイル保護機能あり

## 新規開発者向けクイックスタート

### 1日目: 基本環境構築
```bash
# 1. リポジトリクローン
git clone [repository-url] ~/dotfiles
cd ~/dotfiles

# 2. セットアップ実行
./init.sh

# 3. 動作確認
nvim --version
wezterm --version
```

### 2日目: カスタマイズ理解
- Neovim設定の構造理解（`nvim/lua/user/`）
- キーバインド確認（`<Space>`キー中心）
- ターミナル機能テスト

### 3日目: 実開発開始
- Go開発環境テスト
- デバッグ機能確認
- Git連携動作確認

## 連絡先・リソース

### 重要リンク
- [Dotfyle設定詳細](https://dotfyle.com/isseii10/dotfiles-nvim)
- Lazy.nvim公式ドキュメント
- WezTerm設定リファレンス

### カスタマイズ時の参考
- Neovimプラグイン: awesome-neovim
- Zshプラグイン: ohmyzsh
- ターミナルテーマ: tokyo-night系

---

**最終更新**: 2025年1月
**対象環境**: macOS (Apple Silicon推奨)
**メンテナー**: isseii10

このドキュメントは開発環境の完全な理解と迅速な立ち上げを目的としています。質問や改善提案があれば、GitHubのIssueで報告してください。

