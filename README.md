<div align="center">

# 🔁 growloop

### Your AI remembers nothing. growloop fixes that.

*Learns from every session · Builds your personal dev brain · Gets smarter every day*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Works with Claude](https://img.shields.io/badge/Works%20with-Claude%20Code-orange)](https://claude.ai/code)
[![Works with Cursor](https://img.shields.io/badge/Works%20with-Cursor-blue)](https://cursor.sh)
[![Works with Copilot](https://img.shields.io/badge/Works%20with-GitHub%20Copilot-black)](https://github.com/features/copilot)
[![Stars](https://img.shields.io/github/stars/Hippophile/growloop?style=social)](https://github.com/Hippophile/growloop/stargazers)

</div>

---

## 😤 The problem

Every time you open Claude, Cursor, or Copilot — it has **no idea who you are**.

You re-explain your stack. You re-explain your patterns. You get generic answers.  
Other devs waste 10 minutes every session catching their AI up.

**You don't have to.**

---

## ✨ What growloop does

```
Monday                    Every day                 Friday
────────                  ─────────                 ──────
📚 Learning lesson   ←    🧠 Reads your sessions    📊 Dev report
opens in Obsidian         extracts patterns          opens in Obsidian
                          updates your memory
                          suggests new skills ──→ 🔔 Desktop popup
                                                     "Create this skill?"
                                                     [Yes] [Skip]
```

After one week, Claude knows:
- Your stack, your patterns, your naming conventions
- Where you keep getting stuck
- What you've already tried

After one month, it's a **different tool**.

---

## 🚀 Install

```bash
git clone https://github.com/Hippophile/growloop
cd growloop
chmod +x install.sh
./install.sh
```

One script. Asks for your Obsidian vault path. Done.

**Requirements**
| Tool | Required | Install |
|------|----------|---------|
| [Claude Code CLI](https://claude.ai/code) | ✅ | [claude.ai/code](https://claude.ai/code) |
| Python 3 | ✅ | pre-installed on most systems |
| Obsidian + [Dataview plugin](https://github.com/blacksmithgu/obsidian-dataview) | ✅ | [obsidian.md](https://obsidian.md) |
| zenity | ⚪ optional | `sudo apt install zenity` |

---

## 🧠 The 4 skills

### `self-improve` — your daily brain update
Runs every day at 10am. Reads your 15 most recent AI sessions.  
Extracts corrections, preferences, patterns. Updates your memory files.  
If it spots a repeated workflow → **desktop popup appears**:

```
┌─────────────────────────────────────────┐
│  New Skill: docker-local-debug          │
│                                         │
│  WHY: You've hit Docker permission      │
│  errors 3 times this week               │
│                                         │
│  WHAT IT DOES: Diagnose and fix common  │
│  Docker permission issues on Linux      │
│                                         │
│  EXAMPLE: /docker-local-debug           │
│                                         │
│  Add extra notes: [________________]    │
│                                         │
│  [Skip]          [Yes, Create It]       │
└─────────────────────────────────────────┘
```

Click **Yes** → skill created instantly using `skill-writer` rules.

---

### `skill-writer` — write skills that actually work
Loads Anthropic's best practices for writing Claude Code skills.  
Trigger conditions, progressive disclosure, autonomous patterns, checklists.  
Use this whenever you write a new skill manually.

---

### `dev-report` — Friday 4pm, honest weekly review
```markdown
# Dev Report — 2026-06-05

## What you built this week
- Copilot adoption dashboard, SQLite→MSSQL migration
- Microsoft OAuth/SSO config, comparison cards with pie charts

## Bug patterns
- Port conflicts (5000/5001 mismatch)
- State not propagating (snapshot → KPIs don't refresh)

## You're getting better at
- Debugging JS: console logs, curl API validation
- Breaking big changes: reverted MSSQL when RAM-constrained

## Still struggling with
- Full stack visibility: backend clear, frontend state mutations opaque

## One thing to focus on next week
Fix snapshot date reactivity. Map the full data flow before adding features.
```
Saved to Obsidian. Cross-linked to that week's lesson. Builds up over time.

---

### `learning-path` — Monday 10am, one focused lesson
Picks ONE skill gap from your memory. Writes a micro-lesson with:
- Why it matters **to you specifically**
- The one concept, explained simply
- One command to try today
- How you'll know it worked

Saves to Obsidian. Never repeats a topic you've already seen.

---

## 📁 Obsidian structure

```
Obsidian Vault/
└── Claude/
    ├── Dev Reports.md        ← live Dataview index
    ├── Learning Path.md      ← live Dataview index  
    ├── Dev Reports/
    │   ├── report-2026-06-05.md  ──┐
    │   └── report-2026-05-30.md   │  cross-linked
    └── Learning Path/             │  via [[wikilinks]]
        ├── lesson-2026-W22.md  ───┘
        └── lesson-2026-W21.md
```

---

## ⏰ Schedule

| Time | Skill | Output |
|------|-------|--------|
| Daily 10am | `self-improve` | Memory updated silently |
| Monday 10am | `learning-path` | Lesson → Obsidian + popup |
| Friday 4pm | `dev-report` | Review → Obsidian + popup |

> Machine must be on at scheduled times. Missed runs are skipped cleanly.

---

## 💸 Cost

| Setup | Cost |
|-------|------|
| Claude Pro / Max | **$0** — included in your plan |
| API key (pay-as-you-go) | ~$0.03–0.05 per daily run (Haiku model) |

---

## 🤝 Contributing

PRs welcome. This project grows by people sharing what works for them.

### How to contribute

1. **Fork** the repo
2. **Build** your skill in `skills/<your-skill-name>/SKILL.md`
3. **Test** it — run it, make sure it works
4. **PR** with a short description of what it does and why

### Skill PR checklist
- [ ] Follows the `skill-writer` format (frontmatter + trigger description)
- [ ] No hardcoded personal paths — use `__MEMORY_PATH__` and `__VAULT_PATH__` placeholders
- [ ] Tested on at least one machine
- [ ] One clear purpose — not a Swiss army knife

### Good first contributions
- A skill for your tech stack (Rust, Go, Java, mobile, etc.)
- A skill that improves on one of the existing ones
- A new Obsidian template

### Backlog (up for grabs)
| Idea | Description |
|------|-------------|
| `project-context` | Scans codebase, builds per-project memory from code + git history |
| `error-tracker` | Logs repeated errors, suggests permanent fixes after 3 occurrences |
| `spaced-repetition` | Re-surfaces old lessons at 7/30/90 day intervals |
| `weekly-goals` | Sunday prompt + Friday comparison — did you ship what you planned? |
| `code-review-daily` | Haiku reviews what you committed today, flags patterns |
| `windows-support` | Port the shell scripts + crons to work on Windows |
| `mac-support` | Replace `zenity` popups with macOS native notifications |

### Questions or ideas?
Open an issue. Label it `idea` if it's a suggestion, `bug` if something broke.

---

## 📜 License

MIT — use it, fork it, build on it.

---

<div align="center">

**If this helped you, star it ⭐ and share it with a dev friend.**

*Built by [@Hippophile](https://github.com/Hippophile)*

</div>
