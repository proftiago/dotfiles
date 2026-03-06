#!/bin/bash
# ╔══════════════════════════════════════════════════╗
# ║         WALLPAPER — TIAGO CONFIGURAÇÃO           ║
# ║         Uso: wallpaper.sh [imagem]               ║
# ║         Sem argumento = aleatório                ║
# ╚══════════════════════════════════════════════════╝

WALL_DIR="$HOME/Pictures/wallpapers"

# ── Selecionar wallpaper ───────────────────────────
if [[ -n "$1" ]]; then
    WALLPAPER="$1"
else
    WALLPAPER=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | shuf -n1)
fi

if [[ ! -f "$WALLPAPER" ]]; then
    echo "❌ Arquivo não encontrado: $WALLPAPER"
    exit 1
fi

echo "🖼️  Wallpaper: $WALLPAPER"

# ── 1. Trocar wallpaper com transição suave ────────
swww img "$WALLPAPER" \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-duration 1.2 \
    --transition-fps 60

# ── 2. Salvar wallpaper atual ──────────────────────
echo "$WALLPAPER" >~/.current_wallpaper

# ── 3. Gerar paleta de cores com matugen ──────────
matugen image "$WALLPAPER" -m dark --source-color-index 0

# ── 4. Aguardar matugen terminar ───────────────────
sleep 0.5

# ── 5. Recarregar terminais ────────────────────────
pkill -USR1 kitty 2>/dev/null

# ── 6. Recarregar Waybar ───────────────────────────
pkill waybar
sleep 0.3
waybar &
disown

# ── 7. Recarregar Hyprland (bordas e cores) ────────
hyprctl reload

# ── 8. Atualizar tema GTK ─────────────────────────
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'

# ── 9. Atualizar wallpaper do SDDM ────────────────
sudo convert "$WALLPAPER" /usr/share/sddm/themes/Apple.Tahoe/background.webp 2>/dev/null
sudo cp "$WALLPAPER" /usr/share/backgrounds/background.jpg 2>/dev/null

# ── 10. Recarregar Neovim ─────────────────────────
for server in $(nvim --server-list 2>/dev/null); do
    nvim --server "$server" --remote-send ":colorscheme kanagawa<CR>" 2>/dev/null
done

echo "✅ Tema aplicado com sucesso!"
