---
name: self-improve
description: User says "self-improve", "learn from my convos", "update yourself", or wants Claude to extract patterns from past sessions and update memory/skills.
---
# Self-Improve: Extract Patterns, Update Memory & Skills

## What this does
1. Reads recent `~/.claude/transcripts/ses_*.jsonl` sessions
2. Extracts: corrections, preferences, personality, repeated tasks
3. Updates memory files in `__MEMORY_PATH__`
4. Optionally creates new skills for repeated workflows

---

## Step 1 — Gather recent transcripts

```bash
ls -t ~/.claude/transcripts/ses_*.jsonl | head -20
```

---

## Step 2 — Analyze with Haiku

Run the extraction inline, pipe straight to Haiku:

```bash
python3 << 'PYEOF' | claude --model claude-haiku-4-5 --print \
'Analyze these Claude Code conversation excerpts. The user is a developer.
Be RUTHLESS. Only include something if it would genuinely change how Claude responds.
SKIP: obvious things, generic advice, quiet sessions with nothing notable.
KEEP: explicit corrections, non-obvious preferences, repeated friction, surprises.
Empty arrays are fine — better empty than padded with low-value entries.

Return ONLY valid JSON (no markdown):
{
  "corrections": ["only explicit corrections — user said no/wrong/stop/dont"],
  "preferences": ["only non-obvious style or workflow preferences"],
  "personality": "only what changes how Claude communicates — omit if nothing new",
  "common_tasks": ["only workflows that appeared multiple times"],
  "skill_gaps": ["only things user had to re-explain more than once"],
  "suggested_skills": [{"name": "...", "description": "...", "reason": "..."}]
}
If unsure whether something belongs: leave it out.'
import json, glob
from pathlib import Path
paths = sorted(glob.glob(str(Path.home()/'.claude/transcripts/ses_*.jsonl')),
               key=lambda p: Path(p).stat().st_mtime, reverse=True)[:15]
messages = []
for path in paths:
    with open(path) as f:
        for line in f:
            try:
                obj = json.loads(line)
                role = obj.get('type','')
                if role not in ('user','assistant'): continue
                content = obj.get('content','')
                if isinstance(content, list):
                    text = ' '.join(b.get('text','') for b in content
                                    if isinstance(b,dict) and b.get('type')=='text')
                else:
                    text = str(content)
                text = text.strip()
                if text and len(text) > 10 and '[search-mode]' not in text and '[analyze-mode]' not in text:
                    messages.append(f"[{role}]: {text[:400]}")
            except: pass
print('\n'.join(messages[:150]))
PYEOF
```

---

## Step 3 — Update memory files

Memory lives at: `__MEMORY_PATH__`

**IMPORTANT — always overwrite, never append.** Files must stay lean:
- Max 30 lines per memory file
- Max 15 entries in MEMORY.md (system truncates at 200 lines)
- Merge/deduplicate before writing
- If a file exists, read first, merge new insights, rewrite whole file

For each insight from Step 2:
- **Corrections** → overwrite `feedback_patterns.md`
- **Preferences/personality** → overwrite `user_profile.md`
- **Common tasks** → overwrite `project_workflows.md`
- **Friction** → update `friction_log.md`: track repeated topics, increment count. If any topic hits 3+ occurrences, trigger a zenity popup: "You've hit [topic] 3 times — want a skill for it?"

Always rewrite `MEMORY.md` index after updating. Keep index entries to 1 line each.

---

## Step 4 — Auto-compact memory files

After updating, check each file. If any exceeds 40 lines, feed to Haiku to compress:

```bash
python3 << 'PYEOF'
import subprocess
from pathlib import Path

MEMORY_DIR = Path("__MEMORY_PATH__")
MAX_LINES = 40
MAX_INDEX = 15

for f in MEMORY_DIR.glob('*.md'):
    if f.name == 'MEMORY.md':
        continue
    lines = f.read_text().splitlines()
    if len(lines) <= MAX_LINES:
        continue
    content = f.read_text()
    prompt = f"""Compact this memory file. Keep ALL useful information but make it denser.
Remove redundancy, merge similar points, shorten prose. Preserve frontmatter exactly.
Output ONLY the compacted file content, nothing else.\n\n{content}"""
    result = subprocess.run(['claude','--model','claude-haiku-4-5','--print',prompt],
                            capture_output=True, text=True)
    if result.returncode == 0 and result.stdout.strip():
        f.write_text(result.stdout.strip() + '\n')
        print(f"Compacted {f.name}: {len(lines)} → {len(result.stdout.splitlines())} lines")

index = MEMORY_DIR / 'MEMORY.md'
lines = index.read_text().splitlines()
entries = [l for l in lines if l.startswith('-')]
if len(entries) > MAX_INDEX:
    content = index.read_text()
    prompt = f"""Compact this memory index. Keep only most useful entries (max {MAX_INDEX}).
Preserve the # header. Output ONLY the compacted file.\n\n{content}"""
    result = subprocess.run(['claude','--model','claude-haiku-4-5','--print',prompt],
                            capture_output=True, text=True)
    if result.returncode == 0 and result.stdout.strip():
        index.write_text(result.stdout.strip() + '\n')
        print(f"Compacted MEMORY.md to {MAX_INDEX} entries")
PYEOF
```

---

## Step 5 — Notify + create new skills

For each skill in `suggested_skills`, show a desktop popup. If user clicks Yes, auto-create it.

```bash
python3 << 'PYEOF'
import subprocess, json, os, sys
from pathlib import Path

suggestions = json.loads(sys.argv[1]) if len(sys.argv) > 1 else []

env = os.environ.copy()
env.setdefault('DISPLAY', ':0')
try:
    dbus = subprocess.check_output(
        ['bash','-c','cat /proc/$(pgrep -u $USER gnome-session | head -1)/environ 2>/dev/null | tr "\\0" "\\n" | grep DBUS_SESSION_BUS_ADDRESS | cut -d= -f2-'],
        text=True).strip()
    if dbus: env['DBUS_SESSION_BUS_ADDRESS'] = dbus
except: pass

for skill in suggestions:
    name = skill.get('name','').lower().replace(' ','-')
    description = skill.get('description','')
    reason = skill.get('reason','')

    msg = f"New skill detected: <b>{name}</b>\n\n<b>WHY:</b> {reason}\n\n<b>WHAT IT DOES:</b> {description}\n\n<b>EXAMPLE:</b> /{name}"
    result = subprocess.run(['zenity','--question','--title',f'New Skill: {name}',
        '--text',msg,'--ok-label','Yes Create It','--cancel-label','Skip','--width','500'], env=env)

    if result.returncode != 0:
        print(f"Skipped: {name}")
        continue

    extra = subprocess.run(['zenity','--entry','--title',f'Add notes: {name}',
        '--text','Add anything extra (or leave blank):','--entry-text','','--width','500'],
        capture_output=True, text=True, env=env)
    user_notes = extra.stdout.strip() if extra.returncode == 0 else ''

    skill_writer_rules = (Path.home()/'.claude/skills/skill-writer/SKILL.md').read_text()
    extra_section = f"\nExtra from user: {user_notes}" if user_notes else ""
    prompt = f"""Follow these skill rules:\n{skill_writer_rules}\n\nWrite SKILL.md for "{name}".\nPurpose: {reason}\nDoes: {description}{extra_section}\nOutput ONLY SKILL.md, no fences."""

    sc = subprocess.run(['claude','--model','claude-haiku-4-5','--print',prompt],
                        capture_output=True, text=True, env=env)
    if sc.returncode == 0 and sc.stdout.strip():
        content = sc.stdout.strip()
        lines = content.splitlines()
        if lines[0].startswith('```'): lines = lines[1:]
        if lines and lines[-1].strip()=='```': lines = lines[:-1]
        sd = Path.home()/f'.claude/skills/{name}'
        sd.mkdir(parents=True, exist_ok=True)
        (sd/'SKILL.md').write_text('\n'.join(lines)+'\n')
        subprocess.run(['zenity','--info','--title','Skill Created',
            '--text',f'✓ Skill "{name}" created!','--width','380'], env=env)
        print(f"Created: {name}")
PYEOF
```

---

## Cost
Claude Pro/Max: $0.00 per run — included in plan.
API key: Haiku $1/1M input → ~$0.03–0.05 per run.
