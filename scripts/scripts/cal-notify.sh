#!/bin/bash
# ╔══════════════════════════════════════════════════╗
# ║     NOTIFICAÇÕES DE CALENDÁRIO — 15 min antes    ║
# ╚══════════════════════════════════════════════════╝

NOTIFY_BEFORE=15
TARGET=$(date -d "+${NOTIFY_BEFORE} minutes" +%H:%M)

python3 <<EOF
import subprocess, re

target = "$TARGET"

result = subprocess.run(
    ["khal", "list", "--format", "{start-time}SPLIT{title}", "today", "1d"],
    capture_output=True, text=True
)

for line in result.stdout.splitlines():
    if "SPLIT" not in line:
        continue
    parts = line.split("SPLIT")
    if len(parts) < 2:
        continue
    time  = parts[0].strip()
    title = parts[1].strip()
    if not time or not title:
        continue
    if time != target:
        continue

    # Busca link do Meet na descrição completa
    desc_result = subprocess.run(
        ["khal", "list", "--format", "{start-time}SPLIT{title}SPLIT{description}",
         "today", "1d"],
        capture_output=True, text=True
    )
    meet_link = ""
    full_text = desc_result.stdout
    match = re.search(r'https://meet\.google\.com/[a-z-]+', full_text)
    if match:
        meet_link = match.group(0)

    body = f"🕐 Começa às {time}"
    if meet_link:
        body += f"\n🔗 {meet_link}"

    subprocess.run([
        "notify-send",
        "--urgency=normal",
        "--icon=calendar",
        "--app-name=Calendário",
        "--expire-time=10000",
        f"󰃭  {title}",
        body
    ])
EOF
