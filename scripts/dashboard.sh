#!/usr/bin/env bash
# ╔══════════════════════════════════════════╗
# ║         DASHBOARD DE BOAS-VINDAS         ║
# ║         IrajuArch OS · proftiago         ║
# ╚══════════════════════════════════════════╝

# ── Cores ──────────────────────────────────
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

MAUVE="\033[38;2;203;166;247m"
BLUE="\033[38;2;137;180;250m"
GREEN="\033[38;2;166;227;161m"
PEACH="\033[38;2;250;179;135m"
RED="\033[38;2;243;139;168m"
SUBTEXT="\033[38;2;108;112;134m"

# ── Largura fixa ───────────────────────────
W=52

line() { printf "${SUBTEXT}%${W}s${RESET}\n" | tr ' ' '─'; }
center() {
    local text="$1" len="${#1}"
    local pad=$(((W - len) / 2))
    printf "%${pad}s%s\n" "" "$text"
}

clear

# ── Header ─────────────────────────────────
echo
printf "${MAUVE}${BOLD}"
center "󰣇  IrajuArch OS"
printf "${RESET}"
printf "${SUBTEXT}"
center "$(date '+%A, %d de %B de %Y · %H:%M')"
printf "${RESET}"
echo
line

# ── Aulas do dia ───────────────────────────
echo
printf " ${BLUE}${BOLD}󰃭  AULAS DE HOJE${RESET}\n"
echo

AULAS=$(khal list today today 2>/dev/null | grep -v "^No events" | grep -v "^$" | head -10)

if [[ -z "$AULAS" ]]; then
    printf "  ${SUBTEXT}Nenhuma aula agendada para hoje.${RESET}\n"
else
    while IFS= read -r linha; do
        # linha de hora (ex: "10:00-11:00")
        if echo "$linha" | grep -qE "^[0-9]{2}:[0-9]{2}"; then
            hora=$(echo "$linha" | grep -oE "^[0-9]{2}:[0-9]{2}")
            resto=$(echo "$linha" | sed "s/^[0-9:- ]*//")
            printf "  ${GREEN}${BOLD}%s${RESET}  ${BOLD}%s${RESET}\n" "$hora" "$resto"
        else
            printf "  ${SUBTEXT}%s${RESET}\n" "$linha"
        fi
    done <<<"$AULAS"
fi

echo
line

# ── Updates ────────────────────────────────
echo
printf " ${PEACH}${BOLD}󰚰  UPDATES PENDENTES${RESET}\n"
echo

UPDATES=$(checkupdates 2>/dev/null)
COUNT=$(echo "$UPDATES" | grep -c . 2>/dev/null || echo 0)

if [[ -z "$UPDATES" || "$COUNT" -eq 0 ]]; then
    printf "  ${GREEN}Sistema totalmente atualizado.${RESET}\n"
else
    printf "  ${PEACH}${BOLD}%s pacote(s) disponível(is):${RESET}\n\n" "$COUNT"
    echo "$UPDATES" | head -8 | while IFS= read -r pkg; do
        nome=$(echo "$pkg" | awk '{print $1}')
        vers=$(echo "$pkg" | awk '{print $2, $3, $4}')
        printf "  ${BOLD}%-22s${RESET} ${SUBTEXT}%s${RESET}\n" "$nome" "$vers"
    done
    if [[ "$COUNT" -gt 8 ]]; then
        printf "\n  ${SUBTEXT}... e mais %s pacotes${RESET}\n" $((COUNT - 8))
    fi
fi

echo
line

# ── Footer ─────────────────────────────────
echo
printf "${SUBTEXT}"
center "Pressione qualquer tecla para fechar..."
printf "${RESET}\n"

read -n1 -s
