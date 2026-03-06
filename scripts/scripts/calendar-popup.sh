#!/bin/bash

# ── Calendário ────────────────────────────────────
CAL=$(
    python3 - <<'EOF'
import calendar, datetime

today = datetime.date.today()
cal = calendar.Calendar(firstweekday=0)
weeks = cal.monthdayscalendar(today.year, today.month)
month_name = today.strftime("%B %Y")

lines = []
lines.append(f"          {month_name.upper()}")
lines.append("   W   Mo  Tu  We  Th  Fr  Sa  Su")
lines.append("  " + "─" * 32)

for week in weeks:
    first = next((d for d in week if d != 0), None)
    wnum = datetime.date(today.year, today.month, first).isocalendar()[1] if first else "  "
    row = f"  {wnum:>2}  "
    for day in week:
        if day == 0:
            row += "    "
        elif day == today.day:
            row += f"[{day:>2}]"
        else:
            row += f" {day:>2} "
    lines.append(row)

print('\n'.join(lines))
EOF
)

# ── Eventos do dia ────────────────────────────────
EVENTOS=$(khal list --format "{start-time}::{title}" today 1d 2>/dev/null |
    grep -v "http\|Entrar\|disque\|Saiba\|~:~\|PIN\|edite\|meet" |
    awk -F'::' '{
        time=$1; title=$2
        if (time == "") printf "  ●  %s\n", title
        else printf "  %s   %s\n", time, title
    }')

[[ -z "$EVENTOS" ]] && EVENTOS="  Nenhum evento hoje"

# ── Montar conteúdo ───────────────────────────────
CONTENT="$CAL


  HOJE
  ────────────────────────────────
$EVENTOS"

# ── Exibir no Rofi ────────────────────────────────
echo "$CONTENT" | rofi \
    -dmenu \
    -p "" \
    -config ~/.config/rofi/compact.rasi \
    -no-fixed-num-lines \
    -theme-str '
        window {
            width: 400px;
            location: north;
            anchor: north;
            y-offset: 42px;
            border-radius: 16px;
        }
        listview {
            lines: 20;
            scrollbar: false;
        }
        inputbar { enabled: false; }
        element { padding: 2px 16px; }
        element-text { font: "JetBrainsMono Nerd Font 12"; }
    '
