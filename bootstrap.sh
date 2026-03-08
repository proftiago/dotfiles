#!/bin/bash
# ╔══════════════════════════════════════════════════╗
# ║      IrajuArch OS — Bootstrap Installer          ║
# ║      by proftiago · Arch Linux · Hyprland        ║
# ║      Uso: curl -fsSL <url> | bash                ║
# ╚══════════════════════════════════════════════════╝

set -e

REPO="https://github.com/proftiago/dotfiles"
RAW="https://raw.githubusercontent.com/proftiago/dotfiles/main"
DOTFILES_DIR="$HOME/dotfiles"

# ── Cores ──────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
RESET='\033[0m'
BOLD='\033[1m'

log() { echo -e "${CYAN}→ $1${RESET}"; }
success() { echo -e "${GREEN}✅ $1${RESET}"; }
error() {
    echo -e "${RED}❌ $1${RESET}"
    exit 1
}
title() { echo -e "\n${PURPLE}${BOLD}$1${RESET}\n"; }

# ── Banner ─────────────────────────────────────────
clear
echo -e "${PURPLE}${BOLD}"
cat <<'EOF'
  ██╗██████╗  █████╗      ██╗██╗   ██╗ █████╗ ██████╗  ██████╗██╗  ██╗
  ██║██╔══██╗██╔══██╗     ██║██║   ██║██╔══██╗██╔══██╗██╔════╝██║  ██║
  ██║██████╔╝███████║     ██║██║   ██║███████║██████╔╝██║     ███████║
  ██║██╔══██╗██╔══██║██   ██║██║   ██║██╔══██║██╔══██╗██║     ██╔══██║
  ██║██║  ██║██║  ██║╚█████╔╝╚██████╔╝██║  ██║██║  ██║╚██████╗██║  ██║
  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
EOF
echo -e "${RESET}"
echo -e "  ${CYAN}Arch Linux · Hyprland · Wayland · by proftiago${RESET}"
echo -e "  ${CYAN}CachyOS · EndeavourOS · Arch Linux${RESET}\n"
echo -e "  ${BOLD}Este script irá:${RESET}"
echo -e "  1. Instalar dependências básicas"
echo -e "  2. Clonar o repositório de dotfiles"
echo -e "  3. Abrir o instalador gráfico GTK\n"
echo -e "  ${RED}⚠️  Requer internet e um sistema Arch-based${RESET}\n"

echo -e "  Iniciando em 3 segundos... (CTRL+C para cancelar)\n"
sleep 3

# ── 1. Verificar sistema ───────────────────────────
title "󰣇 Verificando sistema..."

if ! command -v pacman &>/dev/null; then
    error "pacman não encontrado. Este script requer um sistema Arch-based (CachyOS, EndeavourOS, Arch)."
fi

if ! ping -c 1 github.com &>/dev/null; then
    error "Sem conexão com a internet."
fi

success "Sistema compatível"

# ── 2. Instalar dependências básicas ──────────────
title "📦 Instalando dependências básicas..."

sudo pacman -S --needed --noconfirm \
    git \
    python \
    python-gobject \
    gtk3 \
    stow \
    curl \
    wget || error "Falha ao instalar dependências"

success "Dependências instaladas"

# ── 3. Instalar yay (AUR) ─────────────────────────
title "󰮯 Verificando AUR helper..."

if ! command -v yay &>/dev/null && ! command -v paru &>/dev/null; then
    log "Instalando yay..."
    sudo pacman -S --needed --noconfirm base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay-bootstrap
    cd /tmp/yay-bootstrap && makepkg -si --noconfirm
    cd ~ && rm -rf /tmp/yay-bootstrap
    success "yay instalado"
else
    success "AUR helper já disponível"
fi

# ── 4. Clonar dotfiles ────────────────────────────
title "󰊢 Clonando dotfiles..."

if [[ -d "$DOTFILES_DIR" ]]; then
    log "Repositório já existe, atualizando..."
    git -C "$DOTFILES_DIR" pull
else
    git clone "$REPO" "$DOTFILES_DIR"
fi

success "Dotfiles prontos em $DOTFILES_DIR"

# ── 5. Baixar install.py se não existir ───────────
if [[ ! -f "$DOTFILES_DIR/install.py" ]]; then
    log "Baixando instalador gráfico..."
    curl -fsSL "$RAW/install.py" -o "$DOTFILES_DIR/install.py"
fi

chmod +x "$DOTFILES_DIR/install.py"

# ── 6. Abrir instalador gráfico ───────────────────
title "󰏗 Abrindo instalador gráfico..."

if [[ -z "$DISPLAY" ]] && [[ -z "$WAYLAND_DISPLAY" ]]; then
    error "Nenhum display gráfico detectado. Execute após fazer login no desktop."
fi

success "Iniciando IrajuArch Installer...\n"
python "$DOTFILES_DIR/install.py"
