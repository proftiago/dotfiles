#!/bin/bash

# Mostra todos os keybinds do hyprland.conf em uma janela Rofi
# Uso: ~/scripts/keybinds.sh

CONF="$HOME/.config/hypr/hyprland.conf"

keybinds=$(grep -E "^bind" "$CONF" | sed '
    # Remove prefixos bind/bindle/bindm
    s/^bindle\s*=\s*//
    s/^bindm\s*=\s*//
    s/^bind\s*=\s*//

    # Formata: "SUPER, Q, killactive" → "SUPER + Q  →  killactive"
    s/,\s*/  +  /
    s/  +  \(\S*\),\s*/  →  /
' | sed '
    # Nomes amigáveis para teclas especiais
    s/Return/Enter/g
    s/XF86AudioRaiseVolume/Volume ↑/g
    s/XF86AudioLowerVolume/Volume ↓/g
    s/XF86AudioMute/Mute/g
    s/XF86MonBrightnessUp/Brilho ↑/g
    s/XF86MonBrightnessDown/Brilho ↓/g
    s/mouse:272/Click Esquerdo/g
    s/mouse:273/Click Direito/g

    # Comandos legíveis
    s|exec,\s*||g
    s|killactive|Fechar janela|g
    s|togglefloating|Flutuar janela|g
    s|fullscreen|Tela cheia|g
    s|exit|Sair do Hyprland|g
    s|movefocus, l|Foco  ←|g
    s|movefocus, r|Foco  →|g
    s|movefocus, u|Foco  ↑|g
    s|movefocus, d|Foco  ↓|g
    s|workspace, \([0-9]*\)|Workspace \1|g
    s|movetoworkspace, \([0-9]*\)|Mover para Workspace \1|g
    s|movewindow|Mover janela|g
    s|resizewindow|Redimensionar janela|g
    s|\$terminal|Terminal (kitty)|g
    s|\$menu|Launcher (Rofi)|g
    s|\$browser|Navegador (Chrome)|g
    s|~/scripts/powermenu.sh|Power Menu|g
    s|~/scripts/wallpaper.sh|Wallpaper aleatório|g
    s|blueman-manager|Bluetooth|g
    s|swayosd-client --output-volume raise|Volume +|g
    s|swayosd-client --output-volume lower|Volume -|g
    s|swayosd-client --output-volume mute-toggle|Mute toggle|g
    s|swayosd-client --brightness +5|Brilho +|g
    s|swayosd-client --brightness -5|Brilho -|g
' | column -t -s'→' | awk '{print "  " $0}'
)

echo "$keybinds" | rofi \
    -dmenu \
    -i \
    -p "  Keybinds" \
    -config ~/.config/rofi/compact.rasi \
    -no-fixed-num-lines \
    -theme-str 'window { width: 700px; } listview { lines: 20; }'
