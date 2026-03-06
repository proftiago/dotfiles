#!/bin/bash
REPO="$HOME/dotfiles" # ← ajuste para o caminho do seu repo
LOG="$HOME/.local/share/dotfiles-backup.log"

declare -A CONFIGS=(
    ["$HOME/.config/hypr"]="config/hypr"
    ["$HOME/.config/waybar"]="config/waybar"
    ["$HOME/.config/rofi"]="config/rofi"
    ["$HOME/.config/kitty"]="config/kitty"
    ["$HOME/.config/mako"]="config/mako"
    ["$HOME/.config/nvim"]="config/nvim"
    ["$HOME/.config/starship.toml"]="config/starship.toml"
    ["$HOME/.config/fish"]="config/fish"
    ["$HOME/scripts"]="scripts"
)

echo "[$(date '+%Y-%m-%d %H:%M')] Iniciando backup..." >>"$LOG"

for SRC in "${!CONFIGS[@]}"; do
    DEST="$REPO/${CONFIGS[$SRC]}"
    mkdir -p "$(dirname "$DEST")"
    cp -r "$SRC" "$(dirname "$DEST")/" 2>>"$LOG"
done

cd "$REPO" || {
    echo "Repo não encontrado: $REPO" >>"$LOG"
    exit 1
}

git add -A
CHANGES=$(git diff --cached --name-only | wc -l)

if [ "$CHANGES" -gt 0 ]; then
    git commit -m "backup: $(date '+%Y-%m-%d %H:%M') — $CHANGES arquivo(s)" >>"$LOG" 2>&1
    git push >>"$LOG" 2>&1
    echo "[$(date '+%Y-%m-%d %H:%M')] ✓ Push feito ($CHANGES arquivos)." >>"$LOG"
else
    echo "[$(date '+%Y-%m-%d %H:%M')] Nenhuma mudança detectada." >>"$LOG"
fi
