#!/bin/bash
CACHE="/tmp/waybar-weather.txt"
MAX_AGE=1800

if [ -f "$CACHE" ]; then
    AGE=$(($(date +%s) - $(stat -c %Y "$CACHE")))
    [ "$AGE" -lt "$MAX_AGE" ] && cat "$CACHE" && exit
fi

WEATHER=$(curl -sf --max-time 5 "wttr.in/Rio+de+Janeiro?format=%c+%t" 2>/dev/null)
if [ -n "$WEATHER" ]; then
    echo "$WEATHER" | tee "$CACHE"
else
    cat "$CACHE" 2>/dev/null || echo "󰖔 --"
fi
