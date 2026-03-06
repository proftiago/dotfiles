#!/bin/bash

# Requer: pacman-contrib (para o checkupdates)
# Instale com: sudo pacman -S pacman-contrib

COUNT=$(checkupdates 2>/dev/null | wc -l)

if [ "$COUNT" -eq 0 ]; then
    echo '{"text": "", "tooltip": "Sistema atualizado", "class": "updated"}'
else
    echo "{\"text\": \"$COUNT\", \"tooltip\": \"$COUNT update(s) disponível(is)\", \"class\": \"has-updates\"}"
fi
