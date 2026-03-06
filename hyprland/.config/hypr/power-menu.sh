#!/bin/bash
MENU=$(echo -e "🔒 Bloquear\n🔄 Reiniciar\n⏻ Desligar" | wofi --show dmenu --prompt "Power Menu" --width 300 --height 200 --style=center)

case $MENU in
    "🔒 Bloquear") swaylock ;;
    "🔄 Reiniciar") systemctl reboot ;;
    "⏻ Desligar") systemctl poweroff ;;
esac
