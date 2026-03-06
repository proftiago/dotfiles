#!/bin/bash
WALLPAPER_DIR="$HOME/Wallpapers"
HOUR=$(date +%H)

if [ "$HOUR" -ge 6 ] && [ "$HOUR" -lt 12 ]; then
    FOLDER="manha"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 18 ]; then
    FOLDER="tarde"
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 22 ]; then
    FOLDER="noite"
else
    FOLDER="madrugada"
fi

FOLDER_PATH="$WALLPAPER_DIR/$FOLDER"

if [ ! -d "$FOLDER_PATH" ] || [ -z "$(ls -A "$FOLDER_PATH" 2>/dev/null)" ]; then
    echo "Pasta '$FOLDER_PATH' vazia ou inexistente." >&2
    exit 1
fi

WALLPAPER=$(find "$FOLDER_PATH" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)
~/scripts/wallpaper.sh "$WALLPAPER"
