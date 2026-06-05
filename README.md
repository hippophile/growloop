# growloop

**Your AI remembers nothing. growloop fixes that — it learns from every session, builds your personal dev brain, and gets smarter every day.**

Works with Claude Code, Cursor, Copilot, or any AI agent that uses conversation history.

---

## What it does

| Skill | When | What |
|-------|------|------|
| `self-improve` | Daily 10am (auto) | Reads your AI sessions, extracts patterns, updates your personal memory |
| `skill-writer` | On demand | Writes new skills following Anthropic best practices |
| `dev-report` | Every Friday 4pm (auto) | Honest weekly review → saved to Obsidian |
| `learning-path` | Every Monday 10am (auto) | One focused lesson based on your real skill gaps → saved to Obsidian |

**The loop:**
1. You code and use AI all week
2. growloop reads your sessions daily
3. Builds memory: who you are, how you work, where you struggle
4. Coaches you back: weekly report + weekly lesson
5. Suggests new skills when it notices repeated patterns
6. You click Yes → skill auto-created
7. Repeat. Claude gets smarter about you every day.

---

## Install

```bash
git clone https://github.com/Hippophile/growloop
cd growloop
chmod +x install.sh
./install.sh
```

You'll be asked for your Obsidian vault path. That's it.

**Requirements:**
- [Claude Code CLI](https://claude.ai/code)
- Python 3
- Obsidian (with [Dataview plugin](https://github.com/blacksmithgu/obsidian-dataview))
- `zenity` for desktop popups: `sudo apt install zenity` (Linux) — optional

---

## How it learns

growloop reads `~/.claude/transcripts/*.jsonl` — the session files Claude Code writes locally after every conversation. It uses `claude-haiku-4-5` (cheapest model) to extract:

- **Corrections** — places you said "no", "wrong", "stop"
- **Preferences** — non-obvious style and workflow choices
- **Skill gaps** — things you kept having to re-explain
- **Repeated patterns** — workflows worth turning into skills

All of this goes into memory files that Claude loads at the start of every session. Over time Claude stops asking basic questions about your stack and starts knowing you.

---

## Obsidian setup

After install, your vault gets a `Claude/` folder:

```
Obsidian Vault/
└── Claude/
    ├── Dev Reports.md        ← Dataview index of all reports
    ├── Learning Path.md      ← Dataview index of all lessons
    ├── Dev Reports/
    │   └── report-2026-06-05.md
    └── Learning Path/
        └── lesson-2026-W22.md
```

Reports and lessons cross-link via `[[wikilinks]]`. Install the [Dataview plugin](https://github.com/blacksmithgu/obsidian-dataview) to get live tables in the index notes.

---

## Skills

### `/self-improve`
Run manually anytime, or let the daily cron handle it. Extracts patterns from your 15 most recent sessions, updates memory, suggests new skills via desktop popup.

### `/skill-writer`
Load this when writing a new skill. Gives Claude the format rules, trigger condition patterns, and checklist so every skill you write is high quality.

### `/dev-report`
Runs every Friday. Honest, specific review of what you built, your bug patterns, what you're improving at, and one thing to focus on next week.

### `/learning-path`
Runs every Monday. Picks ONE skill gap from your memory, writes a practical micro-lesson with a single command to try today.

---

## Customizing

**Change schedule:** Edit your crontab: `crontab -e`

**Change model:** Replace `claude-haiku-4-5` with any model in the skill files. Haiku is used by default for cost — it's $0 on Pro/Max plans.

**Add your own skills:** Use `/skill-writer` to write new ones. They live in `~/.claude/skills/`.

**Memory location:** Auto-detected from your working directory at install time. To change, re-run `install.sh` from your project root.

---

## Cost

**Claude Pro/Max subscription:** $0 — all usage included in your plan.

**API key (pay-as-you-go):** Haiku is $1/$5 per 1M tokens. Full daily run costs ~$0.03–0.05.

---

## Contributing

PRs welcome. If you build a great skill, open a PR and add it to `skills/`.

---

*Built by [@Hippophile](https://github.com/Hippophile)*
