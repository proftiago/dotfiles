#!/bin/bash

shutdown="󰐥  Desligar"
reboot="󰑓  Reiniciar"
suspend="󰤄  Suspender"
logout="󰍃  Sair"
lock="󰌾  Bloquear"
bios="󰍹  BIOS/UEFI"
cancel="󰅖  Cancelar"

chosen=$(printf "%s\n" "$lock" "$suspend" "$logout" "$reboot" "$bios" "$shutdown" "$cancel" | \
  rofi -dmenu \
       -p "Sistema" \
       -config /home/tiago/.config/rofi/powermenu.rasi \
       -no-custom)

case "$chosen" in
  "$shutdown")  systemctl poweroff ;;
  "$reboot")    systemctl reboot ;;
  "$suspend")   systemctl suspend ;;
  "$logout")    hyprctl dispatch exit ;;
  "$lock")      hyprlock ;;
  "$bios")      systemctl reboot --firmware-setup ;;
  "$cancel")    exit 0 ;;
esac
