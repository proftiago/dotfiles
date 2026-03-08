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
# ── 11. Atualizar cor das pastas Papirus ───────────
PRIMARY=$(grep -oP '(?<=@define-color primary\s{1,20})#[0-9a-fA-F]{6}' ~/.config/waybar/colors.css)
R=$(printf '%d' 0x${PRIMARY:1:2})
G=$(printf '%d' 0x${PRIMARY:3:2})
B=$(printf '%d' 0x${PRIMARY:5:2})
if ((R < 100 && G < 100 && B > 150)); then
    FOLDER_COLOR="blue"
elif ((R < 130 && G < 100 && B > 130)); then
    FOLDER_COLOR="indigo"
elif ((R > 130 && G < 100 && B > 130)); then
    FOLDER_COLOR="violet"
elif ((R > 180 && G < 100 && B > 100)); then
    FOLDER_COLOR="pink"
elif ((R > 180 && G < 80 && B < 80)); then
    FOLDER_COLOR="red"
elif ((R > 180 && G > 100 && B < 80)); then
    FOLDER_COLOR="orange"
elif ((R > 180 && G > 160 && B < 80)); then
    FOLDER_COLOR="yellow"
elif ((R < 100 && G > 150 && B < 100)); then
    FOLDER_COLOR="green"
elif ((R < 100 && G > 150 && B > 130)); then
    FOLDER_COLOR="teal"
elif ((R < 100 && G > 180 && B > 180)); then
    FOLDER_COLOR="cyan"
else
    FOLDER_COLOR="indigo"
fi
papirus-folders -C "$FOLDER_COLOR" --theme Papirus-Dark 2>/dev/null
echo "🎨 Papirus: $FOLDER_COLOR ($PRIMARY)"
# ── 12. Atualizar tema SwayOSD ────────────────────
SECONDARY=$(grep -oP '(?<=@define-color secondary\s{1,20})#[0-9a-fA-F]{6}' ~/.config/waybar/colors.css)
# Converter PRIMARY hex → rgba para borda
PR=$(printf '%d' 0x${PRIMARY:1:2})
PG=$(printf '%d' 0x${PRIMARY:3:2})
PB=$(printf '%d' 0x${PRIMARY:5:2})
# Converter SECONDARY hex → rgba para gradiente
SR=$(printf '%d' 0x${SECONDARY:1:2})
SG=$(printf '%d' 0x${SECONDARY:3:2})
SB=$(printf '%d' 0x${SECONDARY:5:2})
mkdir -p ~/.config/swayosd
cat >~/.config/swayosd/style.css <<EOF
window { background: transparent; }

box {
    background: rgba(0, 0, 0, 0.15);
    border-radius: 16px;
    border: 1px solid rgba(${PR}, ${PG}, ${PB}, 0.55);
    padding: 16px 24px;
    min-width: 280px;
}

image {
    color: ${PRIMARY};
    margin-right: 12px;
}

progressbar > trough {
    border-radius: 99px;
    background: rgba(255, 255, 255, 0.1);
}

progressbar > trough > progress {
    border-radius: 99px;
    background: linear-gradient(90deg, rgba(${PR},${PG},${PB},1), rgba(${SR},${SG},${SB},1));
    min-height: 6px;
}

label {
    color: #cdd6f4;
    font-family: "JetBrainsMono Nerd Font";
    font-size: 13px;
}
EOF
pkill swayosd-server 2>/dev/null
sleep 0.2
swayosd-server &
disown
echo "🎨 SwayOSD: $PRIMARY → $SECONDARY"
echo "✅ Tema aplicado com sucesso!"
