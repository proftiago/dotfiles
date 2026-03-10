#!/usr/bin/env bash
# ╔══════════════════════════════════════════╗
# ║         ROLLBACK HOME · proftiago        ║
# ╚══════════════════════════════════════════╝

BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[38;2;166;227;161m"
BLUE="\033[38;2;137;180;250m"
PEACH="\033[38;2;250;179;135m"
SUBTEXT="\033[38;2;108;112;134m"

ok() { echo -e "  ${GREEN}✓${RESET} $1"; }
warn() { echo -e "  ${PEACH}⚠${RESET} $1"; }

echo
echo -e "${BOLD}󰦛  Revertendo home para o estado original${RESET}"
echo

# projetos ativos ← ~/dev/
for pasta in apps fasthr; do
    if [[ -d ~/dev/$pasta ]]; then
        mv ~/dev/$pasta ~/$pasta
        ok "~/dev/$pasta → ~/$pasta"
    else
        warn "~/dev/$pasta não encontrada, pulando"
    fi
done

# projetos inativos ← ~/dev/arquivo/
for pasta in ReGreet sddm-chili yay; do
    if [[ -d ~/dev/arquivo/$pasta ]]; then
        mv ~/dev/arquivo/$pasta ~/$pasta
        ok "~/dev/arquivo/$pasta → ~/$pasta"
    else
        warn "~/dev/arquivo/$pasta não encontrada, pulando"
    fi
done

# financeiro.py ← ~/Projetos/
if [[ -f ~/Projetos/financeiro.py ]]; then
    mv ~/Projetos/financeiro.py ~/financeiro.py
    ok "~/Projetos/financeiro.py → ~/financeiro.py"
else
    warn "~/Projetos/financeiro.py não encontrada, pulando"
fi

# remover ~/dev/ se estiver vazia
if [[ -d ~/dev/arquivo ]] && [[ -z "$(ls -A ~/dev/arquivo)" ]]; then
    rmdir ~/dev/arquivo
fi
if [[ -d ~/dev ]] && [[ -z "$(ls -A ~/dev)" ]]; then
    rmdir ~/dev
    ok "~/dev/ removida (estava vazia)"
fi

echo
echo -e "${GREEN}${BOLD}  ✓ Home revertida com sucesso!${RESET}"
echo
