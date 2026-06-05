---
name: skill-writer
description: User wants to create, write, or improve a Claude Code skill file (SKILL.md).
---
# How to Write Claude Code Skills

## File structure
Global skills: `~/.claude/skills/<name>/SKILL.md`
Project skills: `.claude/skills/<name>/SKILL.md`

## Required format
```yaml
---
name: slug-kebab-case        # matches folder name exactly
description: <trigger condition in ≤ 15 words>
---
# Instructions
...
```

## The description field — critical
Always loaded in context. Claude reads it to decide whether to load the full skill.
Write it as a trigger condition, not a summary.

| Bad | Good |
|-----|------|
| "A Python skill" | "User is writing, debugging, or refactoring Python code" |
| "Helps with UI" | "User is building a web UI or HTML/CSS component" |

## Instruction body rules
- Loaded on demand only (can be long — up to ~50K tokens)
- Put most critical rule FIRST
- Use `##` headers for sections
- List exact bash commands Claude should run
- Specify output format expected
- For autonomous skills: specify `claude-haiku-4-5` (cheapest: $1/$5 per 1M tokens)

## Progressive disclosure pattern (recommended)
```
description: [trigger condition]           ← always in context, short
# Instructions
## Core rules (3-5 bullets)               ← quick reference
## Detailed reference                     ← loaded when needed
## Examples                               ← optional
```

## Skill types
| Type | Purpose |
|------|---------|
| Persona | Changes communication style globally |
| Tool | Teaches a bash workflow or command sequence |
| Domain | Adds knowledge for a tech stack |
| Autonomous | Runs on schedule, updates files without user |

## Autonomous skill pattern
1. Body instructs Claude to use `CronCreate` for scheduling
2. Specifies: `claude-haiku-4-5` model (cheap), frequency, files to read/write
3. Outputs to `~/.claude/projects/*/memory/` or creates other skill files

## Checklist before saving
- [ ] `name` slug matches directory name
- [ ] `description` ≤ 15 words, is a trigger condition
- [ ] First instruction is the most important rule
- [ ] No references to tools/files that don't exist
- [ ] If autonomous: Haiku model + cron schedule specified
