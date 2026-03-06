#!/bin/bash
STATUS=$(playerctl status 2>/dev/null)
[ -z "$STATUS" ] || [ "$STATUS" = "Stopped" ] && echo "" && exit

TITLE=$(playerctl metadata --format '{{title}}' 2>/dev/null)
ARTIST=$(playerctl metadata --format '{{artist}}' 2>/dev/null)
[ -n "$ARTIST" ] && echo "$ARTIST — $TITLE" || echo "$TITLE"
