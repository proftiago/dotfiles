#!/bin/bash
COLORS="$HOME/.config/hypr/colors.conf"
if [[ -L "$COLORS" ]]; then
    TEMA=$(basename "$(readlink "$COLORS")" .conf)
    case "$TEMA" in
        mocha)  echo "🌙 mocha"  ;;
        frappe) echo "🌿 frappé" ;;
        latte)  echo "☀️ latte"  ;;
    esac
