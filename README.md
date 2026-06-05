<div align="center">

# 🔁 growloop

### Your AI remembers nothing. growloop fixes that.

*Learns from every session · Builds your personal dev brain · Gets smarter every day*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Works with Claude](https://img.shields.io/badge/Works%20with-Claude%20Code-orange)](https://claude.ai/code)
[![Works with Cursor](https://img.shields.io/badge/Works%20with-Cursor-blue)](https://cursor.sh)
[![Works with Copilot](https://img.shields.io/badge/Works%20with-Copilot-black)](https://github.com/features/copilot)
[![Stars](https://img.shields.io/github/stars/Hippophile/growloop?style=social)](https://github.com/Hippophile/growloop/stargazers)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

<br/>

```
Every dev using AI starts every session from zero.
You don't have to.
```

</div>

---

## 😤 The problem every AI dev has

You open Claude. It asks what your stack is. Again.  
You explain your patterns. Again.  
You get generic answers. Again.

Meanwhile your AI has processed **millions of tokens of your work** and remembers none of it.

**growloop fixes this permanently.**

---

## 🧠 How it works — 3-tier memory architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     TIER 1 — CAPTURE                        │
│  git post-commit hook fires on every commit                  │
│  → archives decisions, file changes, messages               │
│  → ~/.growloop/archive/YYYY-MM-DD.jsonl                     │
└────────────────────┬────────────────────────────────────────┘
                     │ daily at 10am
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    TIER 2 — CURATION                        │
│  Haiku reads transcripts + archive                          │
│  → extracts corrections, preferences, skill gaps            │
│  → updates memory files (lean, deduplicated)                │
│  → rebuilds SQLite FTS5 search index                        │
│  → suggests new skills via desktop popup                    │
└────────────────────┬────────────────────────────────────────┘
                     │ after curation
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  TIER 3 — ACTIVE CONTEXT                    │
│  Auto-generates ~/.claude/CLAUDE.md from memory             │
│  → Claude loads it at the start of EVERY session            │
│  → No manual steps. Always fresh. Always you.               │
└─────────────────────────────────────────────────────────────┘
```

---

## ✨ What you get

### Every day at 10am — silently running
- Reads your 15 most recent AI sessions
- Extracts only what changes Claude's behavior (corrections, preferences, gaps)
- Updates your personal memory files
- Rebuilds search index
- Regenerates `~/.claude/CLAUDE.md` — so every new session already knows you

### When a repeated pattern is detected — popup on your screen
```
┌─────────────────────────────────────────┐
│  New Skill: docker-local-debug          │
│                                         │
│  WHY: You've hit this 3 times           │
│  this week                              │
│                                         │
│  WHAT IT DOES: Fix Docker permission    │
│  errors on Linux in one command         │
│                                         │
│  Add extra notes: [________________]    │
│                                         │
│  [Skip]        [Yes, Create It]         │
└─────────────────────────────────────────┘
```
Click **Yes** → skill auto-written and installed instantly.

### Every Monday 10am — this week's lesson
One focused micro-lesson based on your **actual** skill gaps.  
Not a random tutorial. The thing *you* specifically keep struggling with.  
Saved to Obsidian. Never repeats.

### Every Friday 4pm — honest weekly review
```markdown
## What you built this week
- Copilot dashboard, SQLite→MSSQL migration, OAuth/SSO config

## Bug patterns
- Port conflicts, state not propagating, API returning stale data

## You're getting better at
- Debugging JS, Docker recovery, breaking big changes safely

## Still struggling with
- Full stack visibility: backend clear, frontend state mutations opaque

## One thing to focus on next week
Fix snapshot date reactivity. Map the full data flow first.
```
Saved to Obsidian. Cross-linked to that week's lesson.

---

## 🚀 Install

```bash
git clone https://github.com/Hippophile/growloop
cd growloop
chmod +x install.sh
./install.sh
```

**That's it.** One script. Asks for your Obsidian vault path. Everything else is automatic.

### Requirements

| Tool | Required | Install |
|------|----------|---------|
| [Claude Code CLI](https://claude.ai/code) | ✅ | [claude.ai/code](https://claude.ai/code) |
| Python 3 | ✅ | pre-installed on most systems |
| Obsidian + [Dataview plugin](https://github.com/blacksmithgu/obsidian-dataview) | ✅ | [obsidian.md](https://obsidian.md) |
| zenity (desktop popups) | ⚪ optional | `sudo apt install zenity` |

> **macOS:** Replace `zenity` calls with `osascript`. Windows support coming — PRs welcome.

---

## 📁 What gets installed

```
~/.claude/
├── CLAUDE.md                    ← auto-generated, loaded every session
└── skills/
    ├── self-improve/            ← daily brain update
    ├── skill-writer/            ← write skills with best practices
    ├── dev-report/              ← weekly honest review
    └── learning-path/           ← weekly focused lesson

~/.growloop/
├── hooks/
│   └── post-commit              ← fires on every git commit (globally)
├── archive/
│   └── YYYY-MM-DD.jsonl         ← commit history, decisions
└── scripts/
    ├── build-index.py           ← FTS5 SQLite search index
    └── inject-context.py        ← generates CLAUDE.md from memory

~/[your-obsidian-vault]/Claude/
├── Dev Reports/                 ← weekly reports
├── Learning Path/               ← weekly lessons
├── Dev Reports.md               ← Dataview index
└── Learning Path.md             ← Dataview index
```

---

## ⏰ Schedule

| Time | What happens |
|------|-------------|
| Every git commit | Commit archived to `~/.growloop/archive/` |
| Daily 10am | Memory updated, CLAUDE.md regenerated, FTS5 rebuilt |
| Monday 10am | Learning lesson → Obsidian + desktop popup |
| Friday 4pm | Dev report → Obsidian + desktop popup |

> Machine must be on at scheduled times. Missed runs skip cleanly — nothing breaks.

---

## 🔍 Search your memory

```bash
# Search memory files
python3 ~/.growloop/scripts/build-index.py search "docker volumes"

# Search git archive
python3 ~/.growloop/scripts/build-index.py search "auth fix"
```

---

## 🆚 Why not Hermes or Memarch?

Good question. Here's the honest answer:

**Hermes** is a full agent framework — powerful, but heavyweight:
- ~500MB RAM idle as a background daemon
- Has its own skill system, memory, and scheduler that **conflict** with Claude Code
- You'd maintain two parallel systems
- Designed to replace your workflow, not enhance it

**Memarch / vector DBs** give you semantic search — but at a cost:
- Requires 2–4GB RAM for the vector database + embedding model
- On an 8GB laptop already running dotnet + VS Code + Docker = **you'll throttle**
- Same RAM pressure that killed your MSSQL experiment

**growloop is designed for real machines:**
- Runs on 8GB RAM — zero background daemon, zero vector DB
- SQLite FTS5 search is fast enough for personal memory (hundreds, not millions of docs)
- Haiku runs on-demand only (10am daily), not always-on
- Everything is plain files — readable, portable, yours

> If you upgrade to 16GB+ RAM or move to a VM, adding Mem0 + FAISS on top of growloop takes 10 minutes. The architecture is designed for it.

---

## 💸 Cost

| Setup | Cost per day |
|-------|-------------|
| Claude Pro / Max | **$0** — included in plan |
| API key (pay-as-you-go) | ~$0.03–0.05 (Haiku model) |

---

## 🤝 Contributing

PRs welcome. This project grows by people sharing what works for them.

### How to contribute

1. **Fork** the repo
2. **Build** your skill in `skills/<your-skill-name>/SKILL.md`
3. **Test** it — run it, make sure it works
4. **PR** with a short description of what it does and why

### Skill PR checklist
- [ ] Follows `skill-writer` format (frontmatter + trigger description)
- [ ] No hardcoded personal paths — use `__MEMORY_PATH__` and `__VAULT_PATH__`
- [ ] Tested on at least one machine
- [ ] One clear purpose

### Backlog (open issues — pick one up)

| Idea | Description |
|------|-------------|
| `project-context` | Scans codebase, builds per-project memory from code + git history |
| `error-tracker` | Logs repeated errors, suggests fix after 3 occurrences |
| `spaced-repetition` | Re-surfaces lessons at 7/30/90 day intervals |
| `weekly-goals` | Sunday prompt + Friday comparison |
| `code-review-daily` | Haiku reviews today's commits, flags patterns |
| `mac-support` | Replace `zenity` with macOS native notifications |
| `windows-support` | Port shell scripts + crons to Windows |

### Questions or ideas?
Open an issue. Label it `idea` for suggestions, `bug` for problems.

---

## 📜 License

MIT — use it, fork it, build on it.

---

<div align="center">

**If this helped you, star it ⭐ — it helps other devs find it.**

*Built by [@Hippophile](https://github.com/Hippophile)*

</div>
