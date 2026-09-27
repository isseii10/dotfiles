---
name: agent-log
description: AI agent（Claude Code / Codex）との作業で考えたこと・やったことを、Obsidian vaultのdaily note（~/obsidian/daily_notes/YYYY-MM-DD.md）にまとめて追記する。今の会話だけでなく、会話記録からその日のセッションをすべて集めてまとめることもできる。「/agent-log」「daily noteに書いて」「今日のAI作業をまとめて」「質問したことをまとめて」などで使用する。引数: なし（今のセッション）/ 今日 / YYYY-MM-DD。
---

# agent-log

AI agentとの作業を、あとで見返せる形でdaily noteに残す。
質問と回答だけでなく、**何のために・何を考えて・何をしたか・何を学んだか・何が残っているか**を書く。

## モード

| 引数 | 対象 |
|---|---|
| なし / 「このセッション」 | 今の会話 |
| `今日` / 「今日のAI作業をまとめて」 | 今日のすべてのセッション（Claude Code・Codex） |
| `YYYY-MM-DD` | その日のすべてのセッション |

## Step 1: 材料を集める

```bash
python3 ~/.claude/skills/agent-log/scripts/collect.py {YYYY-MM-DD} --daily-note ~/obsidian/daily_notes/{YYYY-MM-DD}.md
```

- 会話記録（`~/.claude/projects/*/*.jsonl`、`~/.codex/sessions/`）から、その日のセッションごとに依頼・最後の返答・変更したファイル・コミット・`marker` を出力する。ファイルは変更しない
- `--daily-note` を渡すと、既に追記済みのやり取りは除外される（二重追記の防止）
- **今のセッションだけのモード**: 出力のうち、`cwd` が今の作業ディレクトリで、時刻が最も新しいセッションを使う。内容は出力より自分の会話の記憶を優先し、`marker` だけ出力から取る
- 対象がなければ、その旨を伝えて終わる

## Step 2: まとめる

セッションごとに書く。1つのセッションで複数のテーマを扱っていたら、テーマごとに `###` を分ける。

```markdown
---
**Claude Code / obsidian / 16:42〜17:17**
<!-- agent-log: {session_id}@{最終時刻} -->

### Zettelkasten系スキルの見直し
- **目的**: 公開されているzettelkasten skillと比べて、手元のnote-*スキルを改善したい
- **考えたこと**: fleeting_notesは書く時点で行き先を判断させるので続かない → daily_notes＋`#zk`＋週1回の棚卸しに一本化した
- **やったこと**: note-lint / note-triage を新規作成、literature_notesをfrontmatter管理に移行（コミット: 「zettelkasten系スキルを改善し…」ほか）
- **学んだこと**: Quartzの ExplicitPublish は `publish: true` のノートだけを公開する #zk
- **残り**: 最短経路の3ノートは本文が空
```

- 見出し行は `**{agent} / {プロジェクト名} / {開始}〜{終了}**`。その直下に Step 1 の `marker` をそのまま書く（次回の二重追記防止に使う）
- **目的**: ユーザーが何をしたかったか。依頼の文面ではなく意図を書く
- **考えたこと**: 判断とその理由、比べた選択肢、方針の転換。ここが一番大事
- **やったこと**: 変更したもの・作ったもの・コミット。ファイルの羅列ではなく、何を変えたかを書く
- **学んだこと**: 技術的に分かったこと、ハマって解決した原因。**あとでノートにできそうなものには `#zk` を付ける**（`/note-triage` の候補になる）
- **残り**: やり残し・未確認・次にやること
- 該当がない項目は書かない。「コミットして」だけのような小さいセッションは、見出し行と `- **やったこと**:` の1行でよい
- 返答の本文やコードを長く貼らない。コードは要点になる数行だけ
- トークン・パスワード・APIキー・個人情報は書かない
- 日本語で書く

## Step 3: daily noteに追記する

- パス: `~/obsidian/daily_notes/{YYYY-MM-DD}.md`（まとめる日の日付）
- ファイルの末尾に追記する。既存の内容は書き換えない
- ファイルがなければ、既存のdaily noteと同じfrontmatterで作る:

```markdown
---
id: YYYY-MM-DD
aliases:
  - YYYY-MM-DD
tags: []
publish: false
title: YYYY-MM-DD
---

```

- Obsidianアプリが起動していなくても書けるよう、ファイルを直接編集する（Obsidian CLI / MCPは使わない）

## Step 4: 報告

- 追記したセッション数と、各セッションの見出し
- `#zk` を付けた項目
- 除外したセッション（記録済み・やり取りなし）があればその件数
