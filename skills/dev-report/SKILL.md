---
name: dev-report
description: User wants their weekly dev report, or it's Friday and the report should auto-generate.
---
# Weekly Dev Report

Reads the last 10 days of transcripts and generates an honest personal report saved to Obsidian.

## Generate report

```bash
python3 << 'PYEOF'
import subprocess, json, os
from pathlib import Path
from datetime import datetime, timedelta

env = os.environ.copy()
env.setdefault('DISPLAY', ':0')
try:
    dbus = subprocess.check_output(
        ['bash','-c','cat /proc/$(pgrep -u $USER gnome-session | head -1)/environ 2>/dev/null | tr "\\0" "\\n" | grep DBUS_SESSION_BUS_ADDRESS | cut -d= -f2-'],
        text=True).strip()
    if dbus: env['DBUS_SESSION_BUS_ADDRESS'] = dbus
except: pass

cutoff = (datetime.now() - timedelta(days=10)).timestamp()
all_paths = sorted(Path.home().glob('.claude/transcripts/ses_*.jsonl'),
                   key=lambda p: p.stat().st_mtime, reverse=True)
paths = [p for p in all_paths if p.stat().st_mtime >= cutoff] or all_paths[:20]

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
                if text and len(text) > 10 and '[search-mode]' not in text:
                    messages.append(f"[{role}]: {text[:400]}")
            except: pass

if not messages:
    print("No sessions found.")
    exit()

week = datetime.now().strftime('%Y-%m-%d')
week_num = datetime.now().strftime('%Y-W%W')
transcript = '\n'.join(messages[:200])

prompt = f"""Analyze this developer's week. Be honest, specific, encouraging. Not generic.

Return an Obsidian markdown note:

---
date: {week}
tags: [dev-report, weekly]
week: {week_num}
related: "[[lesson-{week_num}]]"
---

# Dev Report — {week}

## What you built this week
## Bug patterns
## You're getting better at
## Still struggling with
## One thing to focus on next week

## Connected notes
- [[lesson-{week_num}]] — This week's learning focus
- [[Dev Reports]] — All reports

---
*Generated from Claude sessions — {week}*

TRANSCRIPTS:
{transcript}"""

result = subprocess.run(
    ['claude', '--model', 'claude-haiku-4-5', '--print', prompt],
    capture_output=True, text=True, env=env
)

if result.returncode == 0:
    vault = Path("__VAULT_PATH__")
    report_dir = vault / 'Claude/Dev Reports'
    report_dir.mkdir(parents=True, exist_ok=True)
    report_path = report_dir / f'report-{week}.md'
    report_path.write_text(result.stdout.strip() + '\n')
    print(result.stdout.strip())

    vault_name = vault.name
    subprocess.run([
        'zenity', '--info', '--title', f'Weekly Dev Report — {week}',
        '--text', f'Report ready!\n\nOpening in Obsidian...',
        '--ok-label', 'Open', '--width', '400'
    ], env=env)
    subprocess.run(['obsidian',
        f'obsidian://open?vault={vault_name.replace(" ", "%20")}&file=Claude/Dev%20Reports/report-{week}'],
        env=env)
PYEOF
```
