---
name: summarize-to-daily-note
description: 会話中に「質問したことをまとめて」「daily noteに書いて」などと言ったら、その会話でユーザーが質問したトピックをまとめ、見出し付き・詳細形式でObsidian vaultのdaily noteに追記する。
---

# summarize-to-daily-note

## 手順

1. 会話履歴を振り返り、ユーザーが質問したトピックを洗い出す
2. トピックごとに見出し付き・詳細形式でまとめ文を作成する
3. `obsidian:obsidian-cli` を使って今日の日付のdaily noteに追記する

## まとめ文のフォーマット

```markdown
---
**Claude Code / [リポジトリ名] / HH:MM**

### [トピック名]
[質問の背景・内容と回答の要点を詳細に記述。コードブロックや箇条書きも活用する]

### [トピック名]
...
```

- 区切り線（`---`）+ bold でヘッダを表現
- リポジトリ名は `git remote get-url origin` またはカレントディレクトリ名から取得する
- H3見出し：トピック名（質問の核心を一言で）
- 本文：回答の要点を詳細に。コードや具体例も含める

## Obsidian操作

- daily noteのパス：`daily_notes/YYYY-MM-DD.md`（今日の日付で生成）
- `obsidian:obsidian-cli` の append コマンドでファイル末尾に追記する
- ファイルが存在しない場合は作成する
