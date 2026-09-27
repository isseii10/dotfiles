#!/usr/bin/env python3
"""
指定日の AI agent（Claude Code / Codex）のセッション記録を集めて、まとめの材料を出力する。
ファイルは一切変更しない。

Usage:
    python3 collect.py [YYYY-MM-DD] [--daily-note PATH]

--daily-note を渡すと、そのノート内の `<!-- agent-log: {session_id}@{ISO時刻} -->` を読み、
記録済みの時刻以前のやり取りを除外する（同じセッションを二重に追記しないため）。
"""

import json
import re
import sys
from collections import defaultdict
from datetime import date, datetime
from pathlib import Path

HOME = Path.home()
CLAUDE_DIR = HOME / ".claude" / "projects"
CODEX_DIR = HOME / ".codex" / "sessions"

PROMPT_MAX = 400
REPLY_MAX = 600

args = [a for a in sys.argv[1:] if not a.startswith("--")]
TARGET = date.fromisoformat(args[0]) if args else date.today()
DAILY_NOTE = None
if "--daily-note" in sys.argv:
    DAILY_NOTE = Path(sys.argv[sys.argv.index("--daily-note") + 1])


def parse_ts(s):
    return datetime.fromisoformat(s.replace("Z", "+00:00")).astimezone()


def clip(text, n):
    text = re.sub(r"\s+", " ", text).strip()
    return text if len(text) <= n else text[:n] + "…"


def load_logged():
    """daily note に記録済みの {session_id: 最終時刻}"""
    if not DAILY_NOTE or not DAILY_NOTE.exists():
        return {}
    logged = {}
    for sid, ts in re.findall(r"<!-- agent-log: (\S+)@(\S+) -->", DAILY_NOTE.read_text(encoding="utf-8")):
        t = parse_ts(ts)
        if sid not in logged or t > logged[sid]:
            logged[sid] = t
    return logged


def text_of(content):
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        return "\n".join(c.get("text", "") for c in content if isinstance(c, dict) and c.get("type") == "text")
    return ""


def commit_subject(cmd):
    """git commit コマンドからコミットメッセージの1行目を取り出す（-m と heredoc に対応）"""
    m = re.search(r"<<-?\s*['\"]?(\w+)['\"]?\s*\n(.*?)\n", cmd)
    if m:
        return m.group(2).strip()
    m = re.search(r"-m\s+[\"']([^\"'\n]+)", cmd)
    return m.group(1).strip() if m else None


def new_session(agent, sid, cwd):
    return {"agent": agent, "id": sid, "cwd": cwd, "title": None, "start": None, "end": None,
            "turns": [], "files": set(), "commits": []}


def touch(s, t):
    s["start"] = t if s["start"] is None or t < s["start"] else s["start"]
    s["end"] = t if s["end"] is None or t > s["end"] else s["end"]


def collect_claude(logged):
    sessions = {}
    for path in CLAUDE_DIR.glob("*/*.jsonl"):
        if datetime.fromtimestamp(path.stat().st_mtime).date() < TARGET:
            continue
        s = None
        title = None
        last_reply = None
        for line in path.open(encoding="utf-8"):
            try:
                d = json.loads(line)
            except json.JSONDecodeError:
                continue
            sid = d.get("sessionId")
            if d.get("type") == "ai-title":
                title = d.get("aiTitle") or title
            if d.get("isSidechain") or d.get("isMeta") or "timestamp" not in d or d.get("type") not in ("user", "assistant"):
                continue
            t = parse_ts(d["timestamp"])
            if t.date() != TARGET or (sid in logged and t <= logged[sid]):
                continue
            if s is None:
                s = sessions.setdefault(sid, new_session("Claude Code", sid, d.get("cwd", "")))
            msg = d.get("message", {})
            if d["type"] == "user":
                origin = d.get("origin")
                if origin is not None and origin.get("kind") != "human":
                    continue
                if origin is None and not isinstance(msg.get("content"), str):  # 古い形式: tool_result を除く
                    continue
                text = text_of(msg.get("content"))
                if not text or text.startswith("<"):  # スラッシュコマンドの展開やシステム通知
                    m = re.search(r"<command-name>(.*?)</command-name>", text or "")
                    if not m:
                        continue
                    text = m.group(1)
                touch(s, t)
                last_reply = {"time": t.strftime("%H:%M"), "prompt": clip(text, PROMPT_MAX), "reply": ""}
                s["turns"].append(last_reply)
            else:
                touch(s, t)
                for c in msg.get("content") or []:
                    if not isinstance(c, dict):
                        continue
                    if c.get("type") == "text" and last_reply is not None:
                        last_reply["reply"] = clip(c.get("text", ""), REPLY_MAX)  # そのターンの最後の返答を残す
                    elif c.get("type") == "tool_use":
                        inp = c.get("input") or {}
                        fp = inp.get("file_path", "")
                        if c.get("name") in ("Edit", "Write", "NotebookEdit") and fp and not fp.startswith(("/tmp/", "/private/tmp/")):
                            s["files"].add(fp)
                        cmd = inp.get("command", "")
                        if c.get("name") == "Bash" and "git commit" in cmd:
                            msg_line = commit_subject(cmd)
                            if msg_line and msg_line not in s["commits"]:
                                s["commits"].append(msg_line)
        if s is not None and title:
            s["title"] = title
    return sessions


def collect_codex(logged):
    sessions = {}
    if not CODEX_DIR.exists():
        return sessions
    day_dir = CODEX_DIR / f"{TARGET:%Y}" / f"{TARGET:%m}" / f"{TARGET:%d}"
    for path in day_dir.glob("*.jsonl") if day_dir.exists() else []:
        s = None
        last = None
        for line in path.open(encoding="utf-8"):
            try:
                d = json.loads(line)
            except json.JSONDecodeError:
                continue
            p = d.get("payload") or {}
            if d.get("type") == "session_meta":
                s = new_session("Codex", p.get("id", path.stem), p.get("cwd", ""))
                sessions[s["id"]] = s
                continue
            if s is None or "timestamp" not in d:
                continue
            t = parse_ts(d["timestamp"])
            if s["id"] in logged and t <= logged[s["id"]]:
                continue
            if d.get("type") == "event_msg" and p.get("type") == "user_message":
                if not p.get("message", "").strip():
                    continue
                touch(s, t)
                last = {"time": t.strftime("%H:%M"), "prompt": clip(p.get("message", ""), PROMPT_MAX), "reply": ""}
                s["turns"].append(last)
            elif d.get("type") == "event_msg" and p.get("type") == "agent_message" and last is not None:
                touch(s, t)
                last["reply"] = clip(p.get("message", ""), REPLY_MAX)
    return sessions


def project_name(cwd):
    return Path(cwd).name or cwd if cwd else "(unknown)"


def main():
    logged = load_logged()
    sessions = {**collect_claude(logged), **collect_codex(logged)}
    sessions = [s for s in sessions.values() if s["turns"]]
    sessions.sort(key=lambda s: s["start"])

    print(f"# AI agent セッション記録 {TARGET}（{len(sessions)}件）\n")
    if not sessions:
        print("対象のセッションはありません（記録済みのものは除外しています）。")
        return
    for s in sessions:
        print(f"## {s['agent']} / {project_name(s['cwd'])} / {s['start']:%H:%M}〜{s['end']:%H:%M}")
        print(f"- session: {s['id']}")
        print(f"- marker: <!-- agent-log: {s['id']}@{s['end'].isoformat(timespec='seconds')} -->")
        print(f"- cwd: {s['cwd']}")
        if s["title"]:
            print(f"- title: {s['title']}")
        if s["files"]:
            print(f"- 変更したファイル: {', '.join(sorted(s['files']))}")
        if s["commits"]:
            print(f"- コミット: {' / '.join(s['commits'])}")
        print("\n### やり取り")
        for turn in s["turns"]:
            print(f"- [{turn['time']}] 依頼: {turn['prompt']}")
            if turn["reply"]:
                print(f"  - 返答: {turn['reply']}")
        print()


if __name__ == "__main__":
    main()
