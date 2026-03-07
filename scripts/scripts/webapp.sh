#!/bin/bash

# ╔══════════════════════════════════════════════════════════╗
# ║         WEBAPP CREATOR — IrajuArch OS                   ║
# ║         Interface Rofi nativa                           ║
# ╚══════════════════════════════════════════════════════════╝

APPS_DIR="$HOME/.local/share/applications"
ICONS_DIR="$HOME/.local/share/icons/webapps"
RASI="$HOME/.config/rofi/webapp.rasi"
mkdir -p "$APPS_DIR" "$ICONS_DIR"

# ══════════════════════════════════════════════════════════
# BANCO DE DADOS LOCAL
# ══════════════════════════════════════════════════════════
declare -A APP_DB=(
    ["gmail"]="https://mail.google.com"
    ["google drive"]="https://drive.google.com"
    ["google docs"]="https://docs.google.com"
    ["google sheets"]="https://sheets.google.com"
    ["google calendar"]="https://calendar.google.com"
    ["google meet"]="https://meet.google.com"
    ["google maps"]="https://maps.google.com"
    ["notion"]="https://notion.so"
    ["trello"]="https://trello.com"
    ["asana"]="https://app.asana.com"
    ["todoist"]="https://todoist.com"
    ["linear"]="https://linear.app"
    ["clickup"]="https://app.clickup.com"
    ["whatsapp"]="https://web.whatsapp.com"
    ["telegram"]="https://web.telegram.org"
    ["discord"]="https://discord.com/app"
    ["slack"]="https://app.slack.com"
    ["teams"]="https://teams.microsoft.com"
    ["zoom"]="https://zoom.us"
    ["instagram"]="https://instagram.com"
    ["twitter"]="https://twitter.com"
    ["x"]="https://x.com"
    ["facebook"]="https://facebook.com"
    ["linkedin"]="https://linkedin.com"
    ["tiktok"]="https://tiktok.com"
    ["github"]="https://github.com"
    ["gitlab"]="https://gitlab.com"
    ["figma"]="https://figma.com"
    ["vercel"]="https://vercel.com"
    ["netlify"]="https://app.netlify.com"
    ["railway"]="https://railway.app"
    ["supabase"]="https://app.supabase.com"
    ["spotify"]="https://open.spotify.com"
    ["youtube"]="https://youtube.com"
    ["youtube music"]="https://music.youtube.com"
    ["netflix"]="https://netflix.com"
    ["twitch"]="https://twitch.tv"
    ["primevideo"]="https://primevideo.com"
    ["deezer"]="https://deezer.com"
    ["nubank"]="https://app.nubank.com.br"
    ["inter"]="https://internetbanking.bancointer.com.br"
    ["itau"]="https://itau.com.br"
    ["bradesco"]="https://bradesco.com.br"
    ["chatgpt"]="https://chat.openai.com"
    ["claude"]="https://claude.ai"
    ["gemini"]="https://gemini.google.com"
    ["perplexity"]="https://perplexity.ai"
    ["canva"]="https://canva.com"
    ["miro"]="https://miro.com"
    ["dropbox"]="https://dropbox.com"
    ["bitwarden"]="https://vault.bitwarden.com"
    ["protonmail"]="https://mail.proton.me"
)

# ══════════════════════════════════════════════════════════
# FUNÇÕES
# ══════════════════════════════════════════════════════════

rofi_menu() {
    local prompt="$1"
    local mesg="$2"
    shift 2
    printf '%s\n' "$@" | rofi -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -config "$RASI" \
        -no-fixed-num-lines
}

rofi_input() {
    local prompt="$1"
    local mesg="$2"
    local value="$3"
    rofi -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -config "$RASI" \
        -filter "$value" \
        -no-fixed-num-lines \
        </dev/null
}

rofi_confirm() {
    local prompt="$1"
    local mesg="$2"
    local choice
    choice=$(rofi_menu "$prompt" "$mesg" "  Sim" "  Não")
    [[ "$choice" == *"Sim"* ]]
}

notify() {
    notify-send "WebApp Creator" "$1" \
        --icon="$HOME/.local/share/icons/irajuarch-webapp.svg" \
        --app-name="IrajuArch OS" 2>/dev/null
}

lookup_url() {
    local query="${1,,}"

    # Banco local — exato
    [ -n "${APP_DB[$query]}" ] && echo "${APP_DB[$query]}" && return

    # Banco local — parcial
    for key in "${!APP_DB[@]}"; do
        if [[ "$key" == *"$query"* ]] || [[ "$query" == *"$key"* ]]; then
            echo "${APP_DB[$key]}"
            return
        fi
    done

    # DuckDuckGo
    local result
    result=$(curl -sf --max-time 6 \
        "https://api.duckduckgo.com/?q=${query}+official+site&format=json&no_html=1&skip_disambig=1" \
        2>/dev/null | python3 -c "
import sys,json
try:
  d=json.load(sys.stdin)
  u=d.get('AbstractURL','') or d.get('Redirect','')
  print(u) if u else None
except: pass
" 2>/dev/null)
    [ -n "$result" ] && echo "$result" && return

    # Fallback
    local slug
    slug=$(echo "$query" | tr ' ' '' | tr -cd '[:alnum:]')
    echo "https://www.${slug}.com"
}

download_icon() {
    local domain="$1" icon_file="$2"
    local sources=(
        "https://www.google.com/s2/favicons?domain=${domain}&sz=256"
        "https://icon.horse/icon/${domain}"
        "https://${domain}/apple-touch-icon.png"
        "https://${domain}/favicon.ico"
    )
    for url in "${sources[@]}"; do
        local code
        code=$(curl -sL -o "$icon_file" -w "%{http_code}" --max-time 8 "$url" 2>/dev/null)
        if [ "$code" = "200" ] && [ -s "$icon_file" ]; then
            file "$icon_file" 2>/dev/null | grep -qiE 'image|PNG|JPEG|ICO|GIF|WebP' || continue
            command -v convert &>/dev/null && convert "$icon_file" -resize 256x256 "$icon_file" 2>/dev/null
            return 0
        fi
    done
    return 1
}

# ══════════════════════════════════════════════════════════
# MENU PRINCIPAL
# ══════════════════════════════════════════════════════════
ACTION=$(rofi_menu \
    "󰖟  IrajuArch" \
    "WebApp Creator — escolha uma ação" \
    "󰐕  Criar novo webapp" \
    "󰋙  Listar webapps" \
    "󰩺  Remover webapp" \
    "󰩻  Sair")

[ -z "$ACTION" ] && exit 0

# ══════════════════════════════════════════════════════════
# SAIR
# ══════════════════════════════════════════════════════════
[[ "$ACTION" == *"Sair"* ]] && exit 0

# ══════════════════════════════════════════════════════════
# LISTAR
# ══════════════════════════════════════════════════════════
if [[ "$ACTION" == *"Listar"* ]]; then
    APPS=$(find "$APPS_DIR" -name "webapp-*.desktop" 2>/dev/null)
    if [ -z "$APPS" ]; then
        rofi_menu "󰋙  Webapps" "Nenhum webapp instalado ainda." "  Fechar"
        exit 0
    fi

    ITEMS=()
    while IFS= read -r f; do
        NAME=$(grep "^Name=" "$f" | cut -d= -f2)
        URL=$(grep "^Exec=" "$f" | grep -o 'app=.*' | sed 's/app=//' | awk '{print $1}')
        ITEMS+=("$(printf "%-22s  %s" "$NAME" "$URL")")
    done <<<"$APPS"

    rofi_menu "󰋙  Webapps instalados" "$(echo "${#ITEMS[@]}") apps encontrados" "${ITEMS[@]}" >/dev/null
    exit 0
fi

# ══════════════════════════════════════════════════════════
# REMOVER
# ══════════════════════════════════════════════════════════
if [[ "$ACTION" == *"Remover"* ]]; then
    APPS=$(find "$APPS_DIR" -name "webapp-*.desktop" 2>/dev/null)
    if [ -z "$APPS" ]; then
        rofi_menu "󰩺  Remover" "Nenhum webapp instalado ainda." "  Fechar" >/dev/null
        exit 0
    fi

    declare -a NAMES FILES
    while IFS= read -r f; do
        NAMES+=("$(grep "^Name=" "$f" | cut -d= -f2)")
        FILES+=("$f")
    done <<<"$APPS"

    SELECTED=$(rofi_menu "󰩺  Remover" "Escolha qual webapp remover" "${NAMES[@]}")
    [ -z "$SELECTED" ] && exit 0

    for i in "${!NAMES[@]}"; do
        if [ "${NAMES[$i]}" = "$SELECTED" ]; then
            TARGET="${FILES[$i]}"
            ICON=$(grep "^Icon=" "$TARGET" | cut -d= -f2)
            break
        fi
    done

    if rofi_confirm "󰩺  Confirmar" "Remover '$SELECTED' permanentemente?"; then
        rm -f "$TARGET" "$ICON"
        update-desktop-database "$APPS_DIR" 2>/dev/null
        notify "✓ '$SELECTED' removido com sucesso!"
    fi
    exit 0
fi

# ══════════════════════════════════════════════════════════
# CRIAR
# ══════════════════════════════════════════════════════════
if [[ "$ACTION" == *"Criar"* ]]; then

    # Nome
    APP_NAME=$(rofi_input "󰐕  Nome" "Digite o nome do app (ex: Gmail, Spotify, Notion...)" "")
    [ -z "$APP_NAME" ] && exit 0

    # Busca URL automaticamente
    FOUND_URL=$(lookup_url "$APP_NAME")

    # URL — pré-preenchida, editável
    APP_URL=$(rofi_input "󰖟  URL" "URL encontrada para '$APP_NAME' — confirme ou edite" "$FOUND_URL")
    [ -z "$APP_URL" ] && exit 0
    [[ "$APP_URL" != http* ]] && APP_URL="https://$APP_URL"

    # IDs e paths
    APP_ID=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    DESKTOP_FILE="$APPS_DIR/webapp-${APP_ID}.desktop"
    ICON_FILE="$ICONS_DIR/${APP_ID}.png"
    DOMAIN=$(echo "$APP_URL" | sed 's|https\?://||' | sed 's|/.*||')

    # Download ícone em background com notificação
    notify "⏳ Baixando ícone de $APP_NAME..."
    download_icon "$DOMAIN" "$ICON_FILE"
    ICON_PATH="$ICON_FILE"
    [ ! -s "$ICON_FILE" ] && ICON_PATH="web-browser"

    # Cria .desktop
    printf '[Desktop Entry]\nVersion=1.0\nName=%s\nComment=WebApp — %s\nExec=google-chrome-stable --app=%s --class=webapp-%s\nIcon=%s\nTerminal=false\nType=Application\nCategories=Network;WebApp;\nStartupWMClass=webapp-%s\n' \
        "$APP_NAME" "$APP_URL" "$APP_URL" "$APP_ID" "$ICON_PATH" "$APP_ID" >"$DESKTOP_FILE"

    chmod +x "$DESKTOP_FILE"
    update-desktop-database "$APPS_DIR" 2>/dev/null

    notify "✓ '$APP_NAME' criado! Já aparece no Rofi."

    # Abrir agora?
    if rofi_confirm "󰐕  Abrir agora?" "Deseja abrir '$APP_NAME' agora?"; then
        google-chrome-stable --app="$APP_URL" --class="webapp-${APP_ID}" &
        disown
    fi
fi
