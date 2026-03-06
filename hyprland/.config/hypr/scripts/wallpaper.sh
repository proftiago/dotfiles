#!/bin/bash

WALLPAPER="$1"

# Salva wallpaper atual
echo "$WALLPAPER" > ~/.cache/current_wallpaper

# Aplica wallpaper
swww img "$WALLPAPER" \
  --transition-type wipe \
  --transition-angle 30 \
  --transition-duration 1.5

# Gera cores com matugen
matugen image "$WALLPAPER" --mode dark --source-color-index 0

# Aplica tema GTK via matugen
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


# Recarrega tudo
hyprctl reload
pkill waybar && waybar 2>/dev/null &
pkill dunst && dunst &
