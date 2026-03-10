#!/usr/bin/env bash
# ╔══════════════════════════════════════════╗
# ║         ORGANIZAR HOME · proftiago       ║
# ║         IrajuArch OS · Março 2026        ║
# ╚══════════════════════════════════════════╝

# ── Cores ──────────────────────────────────
BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[38;2;166;227;161m"
BLUE="\033[38;2;137;180;250m"
PEACH="\033[38;2;250;179;135m"
RED="\033[38;2;243;139;168m"
SUBTEXT="\033[38;2;108;112;134m"

ok() { echo -e "  ${GREEN}✓${RESET} $1"; }
info() { echo -e "  ${BLUE}→${RESET} $1"; }
skip() { echo -e "  ${SUBTEXT}○ (já existe) $1${RESET}"; }
warn() { echo -e "  ${PEACH}⚠${RESET} $1"; }

echo
echo -e "${BOLD}󰉋  Organizando ~/  ·  IrajuArch OS${RESET}"
echo -e "${SUBTEXT}  Nenhum arquivo será deletado — apenas movido.${RESET}"
echo

# ══════════════════════════════════════════
# 1. CRIAR ESTRUTURA ~/dev/
# ══════════════════════════════════════════
echo -e "${BLUE}${BOLD}[1/3] Criando ~/dev/${RESET}"
mkdir -p ~/dev/arquivo
ok "~/dev/ criada"
ok "~/dev/arquivo/ criada"
echo

# ══════════════════════════════════════════
# 2. PROJETOS ATIVOS → ~/dev/
# ══════════════════════════════════════════
echo -e "${BLUE}${BOLD}[2/3] Movendo projetos${RESET}"

# apps/ e fasthr/ → ~/dev/ (ativos)
for pasta in apps fasthr; do
    if [[ -d ~/$pasta ]]; then
        if [[ -d ~/dev/$pasta ]]; then
            skip "~/dev/$pasta"
        else
            mv ~/$pasta ~/dev/$pasta
            ok "~/$pasta → ~/dev/$pasta"
        fi
    else
        warn "~/$pasta não encontrada, pulando"
    fi
done

# ReGreet, sddm-chili, yay → ~/dev/arquivo/ (inativos)
for pasta in ReGreet sddm-chili yay; do
    if [[ -d ~/$pasta ]]; then
        if [[ -d ~/dev/arquivo/$pasta ]]; then
            skip "~/dev/arquivo/$pasta"
        else
            mv ~/$pasta ~/dev/arquivo/$pasta
            ok "~/$pasta → ~/dev/arquivo/$pasta"
        fi
    else
        warn "~/$pasta não encontrada, pulando"
    fi
done

# financeiro.py → ~/Projetos/
if [[ -f ~/financeiro.py ]]; then
    if [[ -f ~/Projetos/financeiro.py ]]; then
        skip "~/Projetos/financeiro.py"
    else
        mv ~/financeiro.py ~/Projetos/financeiro.py
        ok "~/financeiro.py → ~/Projetos/financeiro.py"
    fi
else
    warn "~/financeiro.py não encontrada, pulando"
fi
echo

# ══════════════════════════════════════════
# 3. RESULTADO FINAL
# ══════════════════════════════════════════
echo -e "${BLUE}${BOLD}[3/3] Estrutura final${RESET}"
echo
echo -e "${SUBTEXT}  ~/
  ├── dev/
  │   ├── apps/          ← ativo
  │   ├── fasthr/        ← ativo
  │   └── arquivo/
  │       ├── ReGreet/
  │       ├── sddm-chili/
  │       └── yay/
  ├── dotfiles/          ← intocado
  ├── escola/            ← intocado
  ├── scripts/           ← intocado
  ├── Projetos/
  │   └── financeiro.py
  ├── Downloads/         ← intocado
  ├── Pictures/          ← intocado
  ├── Videos/            ← intocado
  ├── Music/             ← intocado
  └── Wallpapers/        ← intocado${RESET}"
echo
echo -e "${GREEN}${BOLD}  ✓ Home organizada com sucesso!${RESET}"
echo -e "${SUBTEXT}  Symlinks na raiz mantidos conforme solicitado.${RESET}"
echo
