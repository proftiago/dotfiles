#!/bin/bash

# Lista configs e abre no Neovim via Rofi
# Adicione novos arquivos na lista abaixo

declare -A CONFIGS=(
    # ── Hyprland ──────────────────────────────────────
    ["󰋙  Hyprland — Principal"]="$HOME/.config/hypr/hyprland.conf"
    ["󰋙  Hyprland — Cores"]="$HOME/.config/hypr/colors.conf"
    ["󰋙  Hyprland — Lock"]="$HOME/.config/hypr/hyprlock.conf"

    # ── Waybar ────────────────────────────────────────
    ["  Waybar — Config"]="$HOME/.config/waybar/config.jsonc"
    ["  Waybar — Style"]="$HOME/.config/waybar/style.css"
    ["  Waybar — Cores"]="$HOME/.config/waybar/colors.css"

    # ── Terminal ──────────────────────────────────────
    ["  Kitty — Config"]="$HOME/.config/kitty/kitty.conf"
    ["  Kitty — Cores"]="$HOME/.config/kitty/colors.conf"

    # ── Shell ─────────────────────────────────────────
    ["  Fish — Config"]="$HOME/.config/fish/config.fish"
    ["  Starship — Config"]="$HOME/.config/starship.toml"

    # ── Rofi ──────────────────────────────────────────
    ["  Rofi — Config"]="$HOME/.config/rofi/config.rasi"
    ["  Rofi — Compact"]="$HOME/.config/rofi/compact.rasi"
    ["  Rofi — Powermenu"]="$HOME/.config/rofi/powermenu.rasi"
    ["  Rofi — Cores"]="$HOME/.config/rofi/colors.rasi"

    # ── Neovim ────────────────────────────────────────
    ["  Neovim — Options"]="$HOME/.config/nvim/lua/config/options.lua"
    ["  Neovim — Keymaps"]="$HOME/.config/nvim/lua/config/keymaps.lua"
    ["  Neovim — Tema"]="$HOME/.config/nvim/lua/plugins/theme.lua"
    ["  Neovim — LSP"]="$HOME/.config/nvim/lua/plugins/lsp.lua"

    # ── Matugen ───────────────────────────────────────
    ["  Matugen — Config"]="$HOME/.config/matugen/config.toml"
    ["  Matugen — Hyprland"]="$HOME/.config/matugen/templates/hypr-colors.conf"
    ["  Matugen — Waybar"]="$HOME/.config/matugen/templates/waybar-colors.css"
    ["  Matugen — Rofi"]="$HOME/.config/matugen/templates/rofi-colors.rasi"
    ["  Matugen — Kitty"]="$HOME/.config/matugen/templates/kitty-colors.conf"
    ["  Matugen — Mako"]="$HOME/.config/matugen/templates/mako.config"

    # ── Mako ──────────────────────────────────────────
    ["󰵙  Mako — Config"]="$HOME/.config/mako/config"

    # ── Scripts ───────────────────────────────────────
    ["  Script — Wallpaper"]="$HOME/scripts/wallpaper.sh"
    ["  Script — Powermenu"]="$HOME/scripts/powermenu.sh"
    ["  Script — Keybinds"]="$HOME/scripts/keybinds.sh"
    ["  Script — Check Updates"]="$HOME/scripts/check-updates.sh"
    ["  Script — Configs"]="$HOME/scripts/configs.sh"
)

# Monta a lista filtrando apenas arquivos que existem
list=""
for label in "${!CONFIGS[@]}"; do
    file="${CONFIGS[$label]}"
    if [[ -f "$file" ]]; then
        list+="$label\n"
    fi
done

# Exibe no Rofi
chosen=$(echo -e "$list" | sort | rofi \
    -dmenu \
    -i \
    -p "  Configs" \
    -config ~/.config/rofi/compact.rasi \
    -no-fixed-num-lines \
    -theme-str 'window { width: 680px; } listview { lines: 18; }')

[[ -z "$chosen" ]] && exit 0

# Abre o arquivo escolhido no Neovim dentro do Kitty
file="${CONFIGS[$chosen]}"
kitty --title "Config Editor" nvim "$file"
