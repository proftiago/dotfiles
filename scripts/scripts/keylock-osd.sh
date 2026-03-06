#!/bin/bash
# Monitora Caps Lock e Num Lock e exibe notificação

prev_caps=""
prev_num=""

while true; do
    caps=$(cat /sys/class/leds/input*::capslock/brightness 2>/dev/null | head -1)
    num=$(cat /sys/class/leds/input*::numlock/brightness 2>/dev/null | head -1)

    if [[ "$caps" != "$prev_caps" ]]; then
        if [[ "$caps" == "1" ]]; then
            notify-send -t 2000 -h string:x-canonical-private-synchronous:keylock "⇪ Caps Lock" "Ativado" -i input-keyboard
        else
            notify-send -t 2000 -h string:x-canonical-private-synchronous:keylock "⇪ Caps Lock" "Desativado" -i input-keyboard
        fi
        prev_caps="$caps"
    fi

    if [[ "$num" != "$prev_num" ]]; then
        if [[ "$num" == "1" ]]; then
            notify-send -t 2000 -h string:x-canonical-private-synchronous:keylock "⇭ Num Lock" "Ativado" -i input-keyboard
        else
            notify-send -t 2000 -h string:x-canonical-private-synchronous:keylock "⇭ Num Lock" "Desativado" -i input-keyboard
        fi
        prev_num="$num"
    fi

    sleep 0.3
done
