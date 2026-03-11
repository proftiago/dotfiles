#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════╗
# ║       WINDOW STYLE — TIAGO CONFIGURAÇÃO          ║
# ║       Menu Rofi para estilo das janelas          ║
# ╚══════════════════════════════════════════════════╝

ROFI_CMD="rofi -dmenu -i -theme-str"
STATE="$HOME/.config/hypr/.window-style"

# ── Carrega estado atual ───────────────────────────
load_state() {
    BORDER=$(grep "^border=" "$STATE" 2>/dev/null | cut -d= -f2 || echo "2")
    ROUNDING=$(grep "^rounding=" "$STATE" 2>/dev/null | cut -d= -f2 || echo "12")
    OPACITY=$(grep "^opacity=" "$STATE" 2>/dev/null | cut -d= -f2 || echo "0.85")
    GAPS=$(grep "^gaps=" "$STATE" 2>/dev/null | cut -d= -f2 || echo "8")
    SHADOW=$(grep "^shadow=" "$STATE" 2>/dev/null | cut -d= -f2 || echo "normal")
}

# ── Salva estado ──────────────────────────────────
save_state() {
    mkdir -p "$HOME/.config/hypr"
    cat >"$STATE" <<EOF
border=$BORDER
rounding=$ROUNDING
opacity=$OPACITY
gaps=$GAPS
shadow=$SHADOW
EOF
}

# ── Aplica todas as configurações via hyprctl ──────
apply_all() {
    hyprctl keyword decoration:border_size "$BORDER"
    hyprctl keyword decoration:rounding "$ROUNDING"
    hyprctl keyword decoration:inactive_opacity "$OPACITY"
    hyprctl keyword general:gaps_in "$GAPS"
    hyprctl keyword general:gaps_out "$((GAPS * 2))"

    if [[ "$SHADOW" == "off" ]]; then
        hyprctl keyword decoration:drop_shadow false
    elif [[ "$SHADOW" == "normal" ]]; then
        hyprctl keyword decoration:drop_shadow true
        hyprctl keyword decoration:shadow_range 20
        hyprctl keyword decoration:shadow_render_power 2
        hyprctl keyword decoration:shadow_offset "0 4"
        hyprctl keyword "decoration:col.shadow" "rgba(00000066)"
    elif [[ "$SHADOW" == "flutuando" ]]; then
        hyprctl keyword decoration:drop_shadow true
        hyprctl keyword decoration:shadow_range 60
        hyprctl keyword decoration:shadow_render_power 4
        hyprctl keyword decoration:shadow_offset "0 12"
        hyprctl keyword "decoration:col.shadow" "rgba(00000099)"
    fi
}

# ── Rofi helper ───────────────────────────────────
rofi_menu() {
    echo -e "$1" | $ROFI_CMD \
        'window {width: 340px;}' \
        -p "$2" \
        -no-custom
}

# ── Menu principal ────────────────────────────────
main_menu() {
    CHOICE=$(rofi_menu \
        "󰔰  Bordas\n󰏘  Arredondamento\n󰖐  Sombra\n  Opacidade inativa\n  Gaps entre janelas\n  Aplicar tudo e sair" \
        "  Estilo das Janelas")

    case "$CHOICE" in
    *"Bordas"*) menu_border ;;
    *"Arredondamento"*) menu_rounding ;;
    *"Sombra"*) menu_shadow ;;
    *"Opacidade"*) menu_opacity ;;
    *"Gaps"*) menu_gaps ;;
    *"Aplicar"*)
        apply_all
        save_state
        notify-send "Window Style" "✅ Configurações salvas!" --icon=preferences-desktop
        exit 0
        ;;
    esac
}

# ── Submenu: Bordas ───────────────────────────────
menu_border() {
    CHOICE=$(rofi_menu \
        "󰅛  Sem bordas  (0px)\n󰅛  Finas        (2px)\n󰅛  Médias       (4px)\n󰅛  Grossas      (6px)" \
        "󰔰  Largura das Bordas")

    case "$CHOICE" in
    *"Sem"*) BORDER=0 ;;
    *"Finas"*) BORDER=2 ;;
    *"Médias"*) BORDER=4 ;;
    *"Grossas"*) BORDER=6 ;;
    *)
        main_menu
        return
        ;;
    esac

    hyprctl keyword decoration:border_size "$BORDER"
    notify-send "Bordas" "Tamanho: ${BORDER}px" --icon=preferences-desktop
    main_menu
}

# ── Submenu: Arredondamento ───────────────────────
menu_rounding() {
    CHOICE=$(rofi_menu \
        "  Sem arredondamento  (0px)\n  Sutil              (6px)\n  Médio             (12px)\n  Arredondado        (18px)\n  Muito arredondado  (24px)" \
        "  Arredondamento")

    case "$CHOICE" in
    *"Sem"*) ROUNDING=0 ;;
    *"Sutil"*) ROUNDING=6 ;;
    *"Médio"*) ROUNDING=12 ;;
    *"Arredondado "*) ROUNDING=18 ;;
    *"Muito"*) ROUNDING=24 ;;
    *)
        main_menu
        return
        ;;
    esac

    hyprctl keyword decoration:rounding "$ROUNDING"
    notify-send "Arredondamento" "Rounding: ${ROUNDING}px" --icon=preferences-desktop
    main_menu
}

# ── Submenu: Sombra ───────────────────────────────
menu_shadow() {
    CHOICE=$(rofi_menu \
        "󰖏  Sem sombra\n󰖐  Normal\n󰖐  Flutuando (intensa)" \
        "󰖐  Sombra das Janelas")

    case "$CHOICE" in
    *"Sem"*) SHADOW="off" ;;
    *"Normal"*) SHADOW="normal" ;;
    *"Flutuando"*) SHADOW="flutuando" ;;
    *)
        main_menu
        return
        ;;
    esac

    apply_all
    notify-send "Sombra" "Modo: $SHADOW" --icon=preferences-desktop
    main_menu
}

# ── Submenu: Opacidade inativa ────────────────────
menu_opacity() {
    CHOICE=$(rofi_menu \
        "  100% — Sem transparência\n  95%\n  90%\n  85%\n  80%\n  75%" \
        "  Opacidade Inativa")

    case "$CHOICE" in
    *"100%"*) OPACITY=1.0 ;;
    *"95%"*) OPACITY=0.95 ;;
    *"90%"*) OPACITY=0.90 ;;
    *"85%"*) OPACITY=0.85 ;;
    *"80%"*) OPACITY=0.80 ;;
    *"75%"*) OPACITY=0.75 ;;
    *)
        main_menu
        return
        ;;
    esac

    hyprctl keyword decoration:inactive_opacity "$OPACITY"
    notify-send "Opacidade" "Janelas inativas: $(echo "$OPACITY * 100" | bc)%" --icon=preferences-desktop
    main_menu
}

# ── Submenu: Gaps ─────────────────────────────────
menu_gaps() {
    CHOICE=$(rofi_menu \
        "  Sem gaps       (0px)\n  Compacto       (4px)\n  Normal         (8px)\n  Espaçado      (12px)\n  Muito espaçado (20px)" \
        "  Gaps entre Janelas")

    case "$CHOICE" in
    *"Sem"*) GAPS=0 ;;
    *"Compacto"*) GAPS=4 ;;
    *"Normal"*) GAPS=8 ;;
    *"Espaçado "*) GAPS=12 ;;
    *"Muito"*) GAPS=20 ;;
    *)
        main_menu
        return
        ;;
    esac

    hyprctl keyword general:gaps_in "$GAPS"
    hyprctl keyword general:gaps_out "$((GAPS * 2))"
    notify-send "Gaps" "Espaçamento: ${GAPS}px" --icon=preferences-desktop
    main_menu
}

# ── Inicializa ────────────────────────────────────
load_state
main_menu
