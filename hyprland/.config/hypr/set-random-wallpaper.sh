#!/bin/bash
WALLPAPER_DIR="$HOME/Pictures/wallpaper"
CURRENT_FILE="$HOME/.cache/current_wallpaper"

if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    for i in $(seq 1 10); do
        swww query &>/dev/null && break
    done
fi

CURRENT=$(cat "$CURRENT_FILE" 2>/dev/null)
NEW=""
mapfile -t PAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \))

for i in {1..10}; do
    PICK="${PAPERS[RANDOM % ${#PAPERS[@]}]}"
    [ "$PICK" != "$CURRENT" ] && { NEW="$PICK"; break; }
done
[ -z "$NEW" ] && NEW="${PAPERS[0]}"

# Usa o script principal
~/.config/hypr/scripts/wallpaper.sh "$NEW"
