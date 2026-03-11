#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════╗
# ║         THEME TOGGLE — TIAGO CONFIGURAÇÃO        ║
# ║         Alterna dark/light sem mudar wallpaper   ║
# ╚══════════════════════════════════════════════════╝

STATE_FILE="$HOME/.config/matugen/.mode"
WALLPAPER=$(cat "$HOME/.config/matugen/.wallpaper" 2>/dev/null)

# Fallback: pega wallpaper atual do swww
if [[ -z "$WALLPAPER" ]]; then
    WALLPAPER=$(swww query | awk -F'image: ' '{print $2}' | head -1)
fi

if [[ ! -f "$WALLPAPER" ]]; then
    echo "❌ Wallpaper não encontrado: $WALLPAPER"
    exit 1
fi

# ── Lê modo atual e inverte ────────────────────────
CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")
if [[ "$CURRENT" == "dark" ]]; then
    MODE="light"
else
    MODE="dark"
fi
echo "$MODE" >"$STATE_FILE"
echo "🎨 Alternando para: $MODE"

# ── 1. Gerar paleta de cores com matugen ──────────
matugen image "$WALLPAPER" -m "$MODE" --source-color-index 0

# ── 2. Aguardar matugen terminar ───────────────────
sleep 0.5

# ── 3. Recarregar terminais ────────────────────────
pkill -USR1 kitty 2>/dev/null

# ── 4. Recarregar Waybar ───────────────────────────
pkill waybar
sleep 0.3
waybar &
disown

# ── 5. Recarregar Hyprland (bordas e cores) ────────
hyprctl reload

# ── 6. Atualizar tema GTK ─────────────────────────
if [[ "$MODE" == "dark" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
fi

# ── 7. Recarregar Mako ────────────────────────────
makoctl reload

# ── 8. Recarregar Neovim ──────────────────────────
for server in $(nvim --server-list 2>/dev/null); do
    nvim --server "$server" --remote-send ":colorscheme kanagawa<CR>" 2>/dev/null
done

# ── 9. Atualizar cor das pastas Papirus ───────────
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

# ── 10. Atualizar tema SwayOSD ────────────────────
SECONDARY=$(grep -oP '(?<=@define-color secondary\s{1,20})#[0-9a-fA-F]{6}' ~/.config/waybar/colors.css)
PR=$(printf '%d' 0x${PRIMARY:1:2})
PG=$(printf '%d' 0x${PRIMARY:3:2})
PB=$(printf '%d' 0x${PRIMARY:5:2})
SR=$(printf '%d' 0x${SECONDARY:1:2})
SG=$(printf '%d' 0x${SECONDARY:3:2})
SB=$(printf '%d' 0x${SECONDARY:5:2})
mkdir -p ~/.config/swayosd
cat >~/.config/swayosd/style.css <<EOF
window { background: transparent; }

box {
    background: #000000;
    border-radius: 16px;
    border: none;
    padding: 16px 24px;
    min-width: 280px;
}

image {
    color: #ffffff;
    margin-right: 12px;
}

progressbar > trough {
    border-radius: 99px;
    background: rgba(255, 255, 255, 0.08);
}

progressbar > trough > progress {
    border-radius: 99px;
    background: linear-gradient(90deg, rgba(${PR},${PG},${PB},1), rgba(${SR},${SG},${SB},1));
    min-height: 6px;
}

label {
    color: #ffffff;
    font-family: "JetBrainsMono Nerd Font";
    font-size: 13px;
}
EOF
pkill swayosd-server 2>/dev/null
sleep 0.2
swayosd-server &
disown
echo "🎨 SwayOSD: $PRIMARY → $SECONDARY"

# ── Notificação ───────────────────────────────────
notify-send "Theme Toggle" "Modo $MODE ativado" --icon=preferences-desktop-theme
echo "✅ Tema $MODE aplicado com sucesso!"
