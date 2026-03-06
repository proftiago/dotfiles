#!/bin/bash
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CURRENT_FILE="$HOME/.cache/current_wallpaper"

TRANSITIONS=("fade 1.2" "outer 1.5" "grow 1.3" "wipe 1.8" "wave 2.0")
RANDOM_TRANS="${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}"
TYPE=$(echo "$RANDOM_TRANS" | cut -d" " -f1)
DUR=$(echo "$RANDOM_TRANS" | cut -d" " -f2)

CURRENT=$(cat "$CURRENT_FILE" 2>/dev/null)
mapfile -t PAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \))

NEW=""
for i in {1..10}; do
    PICK="${PAPERS[RANDOM % ${#PAPERS[@]}]}"
    [ "$PICK" != "$CURRENT" ] && { NEW="$PICK"; break; }
done
[ -z "$NEW" ] && NEW="${PAPERS[0]}"

# Usa o script principal
~/.config/hypr/scripts/wallpaper.sh "$NEW"
