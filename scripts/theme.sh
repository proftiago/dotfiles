#!/bin/bash
# ╔══════════════════════════════════════════════════╗
# ║  IrajuArch OS — Seletor de Tema Catppuccin       ║
# ║  ~/scripts/theme.sh                              ║
# ║  Uso: theme.sh          → menu Rofi              ║
# ║       theme.sh mocha    → direto pelo terminal   ║
# ╚══════════════════════════════════════════════════╝

HYPR_THEMES="$HOME/.config/hypr/themes"
WAYBAR_THEMES="$HOME/.config/waybar/themes"
HYPR_COLORS="$HOME/.config/hypr/colors.conf"
WAYBAR_COLORS="$HOME/.config/waybar/colors.css"

# ── Escolher tema ────────────────────────────────────
if [[ -n "$1" ]]; then
    CHOICE="$1"
else
    CHOICE=$(printf "🌙 mocha\n🌿 frappe\n☀️  latte" | \
        rofi -dmenu \
             -p "Tema" \
             -config ~/.config/rofi/compact.rasi | \
        awk '{print $2}')
fi

# ── Validar ──────────────────────────────────────────
if [[ ! -f "$HYPR_THEMES/${CHOICE}.conf" ]]; then
    notify-send "Theme" "Tema '$CHOICE' não encontrado." -i dialog-error
    exit 1
fi

# ── Aplicar symlinks ─────────────────────────────────
ln -sf "$HYPR_THEMES/${CHOICE}.conf" "$HYPR_COLORS"
ln -sf "$WAYBAR_THEMES/${CHOICE}.css" "$WAYBAR_COLORS"

# ── Recarregar Hyprland ──────────────────────────────
hyprctl reload

# ── Recarregar Waybar ────────────────────────────────
pkill waybar; sleep 0.3; waybar &disown

# ── Recarregar Mako ──────────────────────────────────
pkill mako; sleep 0.2; mako &disown

# ── Notificação ──────────────────────────────────────
case "$CHOICE" in
    mocha)  ICON="🌙" ;;
    frappe) ICON="🌿" ;;
    latte)  ICON="☀️"  ;;
esac

notify-send "IrajuArch OS" "$ICON Tema aplicado: ${CHOICE^}" -t 2000
