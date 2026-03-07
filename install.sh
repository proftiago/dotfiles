#!/bin/bash

# ╔══════════════════════════════════════════════════════════╗
# ║         DOTFILES INSTALLER — Tiago (proftiago)          ║
# ║         IrajuArch OS · Arch Linux · Hyprland            ║
# ╚══════════════════════════════════════════════════════════╝

set -e

# ── Cores ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── Helpers ────────────────────────────────────────────────
info() { echo -e "${BLUE}  →${NC} $1"; }
success() { echo -e "${GREEN}  ✓${NC} $1"; }
warn() { echo -e "${YELLOW}  ⚠${NC} $1"; }
error() { echo -e "${RED}  ✗${NC} $1"; }
title() { echo -e "\n${PURPLE}${BOLD}══ $1 ══${NC}\n"; }

ask() {
    echo -e "${CYAN}${BOLD}  ?${NC} $1 ${YELLOW}[s/N]${NC} "
    read -r response
    [[ "$response" =~ ^[sS]$ ]]
}

# ── Banner ─────────────────────────────────────────────────
clear
echo -e "${PURPLE}${BOLD}"
cat <<'EOF'

  ██╗██████╗  █████╗      ██╗██╗   ██╗ █████╗ ██████╗  ██████╗██╗  ██╗
  ██║██╔══██╗██╔══██╗     ██║██║   ██║██╔══██╗██╔══██╗██╔════╝██║  ██║
  ██║██████╔╝███████║     ██║██║   ██║███████║██████╔╝██║     ███████║
  ██║██╔══██╗██╔══██║██   ██║██║   ██║██╔══██║██╔══██╗██║     ██╔══██║
  ██║██║  ██║██║  ██║╚█████╔╝╚██████╔╝██║  ██║██║  ██║╚██████╗██║  ██║
  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝

                        ArchOS  ·  by proftiago
EOF
echo -e "${NC}"
echo -e "${CYAN}  github.com/proftiago/dotfiles${NC}"
echo -e "${YELLOW}  Cada etapa pergunta antes de executar.\n${NC}"

sleep 1

# ══════════════════════════════════════════════════════════
# ETAPA 1 — AUR HELPER
# ══════════════════════════════════════════════════════════
title "1. AUR Helper"

AUR_HELPER=""

if command -v yay &>/dev/null; then
    AUR_HELPER="yay"
    success "yay já instalado — usando yay"
elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
    success "paru já instalado — usando paru"
else
    echo -e "${CYAN}${BOLD}  ?${NC} Qual AUR helper instalar?"
    echo -e "    ${YELLOW}1)${NC} yay"
    echo -e "    ${YELLOW}2)${NC} paru"
    read -rp "  Escolha [1/2]: " choice

    case "$choice" in
    1)
        info "Instalando yay..."
        sudo pacman -S --needed git base-devel --noconfirm
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay && makepkg -si --noconfirm
        cd ~ && rm -rf /tmp/yay
        AUR_HELPER="yay"
        success "yay instalado"
        ;;
    2)
        info "Instalando paru..."
        sudo pacman -S --needed git base-devel --noconfirm
        git clone https://aur.archlinux.org/paru.git /tmp/paru
        cd /tmp/paru && makepkg -si --noconfirm
        cd ~ && rm -rf /tmp/paru
        AUR_HELPER="paru"
        success "paru instalado"
        ;;
    *)
        error "Opção inválida. Usando yay como padrão."
        AUR_HELPER="yay"
        ;;
    esac
fi

echo -e "\n${GREEN}  AUR helper selecionado: ${BOLD}$AUR_HELPER${NC}"

# ══════════════════════════════════════════════════════════
# ETAPA 2 — PACOTES DO SISTEMA
# ══════════════════════════════════════════════════════════
title "2. Pacotes do Sistema"

PACMAN_PKGS=(
    # Base
    base base-devel linux linux-firmware linux-headers intel-ucode
    efibootmgr sof-firmware zram-generator

    # Wayland / Hyprland
    hyprland hyprlock hyprpaper xdg-desktop-portal xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland xorg-xwayland

    # Áudio
    pipewire pipewire-alsa pipewire-jack pipewire-pulse pipewire-libcamera
    wireplumber libpulse gst-plugin-pipewire

    # Vídeo / Gráficos
    vulkan-intel libcamera libcamera-ipa v4l2loopback-dkms

    # Waybar e utils
    waybar mako rofi swww grim wl-clipboard

    # Terminal e shell
    kitty fish starship nano vim neovim

    # Fontes
    ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols-mono noto-fonts-emoji

    # Apps
    firefox thunar-archive-plugin nautilus libreoffice-fresh
    telegram-desktop pavucontrol blueman bluez bluez-utils

    # Dev
    git github-cli go npm python-pip ripgrep fd lazygit imagemagick bc fastfetch

    # Calendário
    khal vdirsyncer

    # Mídia
    ffmpegthumbnailer tumbler ueberzugpp guvcview

    # Sistema
    networkmanager network-manager-applet cups cups-pdf system-config-printer
    ghostscript nss-mdns libnotify brightnessctl pacman-contrib stow

    # Qt / GTK
    adw-gtk-theme gnome-themes-extra breeze qt5-graphicaleffects qt6-5compat
    papirus-icon-theme

    # Boot
    plymouth
)

AUR_PKGS=(
    yay-debug
    swayosd-git
    matugen
    gradience
    gcalcli
    wleave wofi
    foot cage
    greetd greetd-regreet-git
    sddm sddm-sugar-candy-git simple-sddm-theme-2-git where-is-my-sddm-theme-git
    plymouth-theme-archlinux hitech-arch-animation
    papirus-folders-catppuccin-git
    google-chrome
    youtubemusic
    zapzap
    yazi
)

if ask "Instalar pacotes do pacman? (${#PACMAN_PKGS[@]} pacotes)"; then
    info "Atualizando sistema..."
    sudo pacman -Syu --noconfirm
    info "Instalando pacotes..."
    sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
    success "Pacotes pacman instalados"
fi

if ask "Instalar pacotes do AUR com $AUR_HELPER? (${#AUR_PKGS[@]} pacotes)"; then
    info "Instalando pacotes AUR..."
    $AUR_HELPER -S --needed --noconfirm "${AUR_PKGS[@]}"
    success "Pacotes AUR instalados"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 3 — DOTFILES COM STOW
# ══════════════════════════════════════════════════════════
title "3. Dotfiles (Stow)"

DOTFILES_DIR="$HOME/dotfiles"

if ask "Clonar e aplicar dotfiles com Stow?"; then
    if [ ! -d "$DOTFILES_DIR" ]; then
        info "Clonando dotfiles..."
        git clone https://github.com/proftiago/dotfiles.git "$DOTFILES_DIR"
    else
        info "Repo já existe, atualizando..."
        cd "$DOTFILES_DIR" && git pull origin main
    fi

    info "Aplicando com Stow..."
    cd "$DOTFILES_DIR"

    STOW_PKGS=(hyprland waybar kitty rofi mako nvim fish scripts)

    for pkg in "${STOW_PKGS[@]}"; do
        stow --adopt "$pkg" 2>/dev/null || warn "Conflito em $pkg — verifique manualmente"
        success "Stow: $pkg"
    done

    git checkout . 2>/dev/null
    success "Dotfiles aplicados via Stow"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 4 — SERVIÇOS SYSTEMD
# ══════════════════════════════════════════════════════════
title "4. Serviços Systemd"

if ask "Ativar serviços do sistema?"; then
    info "NetworkManager..."
    sudo systemctl enable --now NetworkManager

    info "Bluetooth..."
    sudo systemctl enable --now bluetooth

    info "Impressão (CUPS)..."
    sudo systemctl enable --now cups

    success "Serviços do sistema ativados"
fi

if ask "Ativar serviços do usuário (wallpaper-time, dotfiles-backup)?"; then
    mkdir -p ~/.config/systemd/user

    cat >~/.config/systemd/user/wallpaper-time.service <<'EOF'
[Unit]
Description=Troca wallpaper por horário

[Service]
Type=oneshot
ExecStart=%h/scripts/wallpaper-time.sh
EOF

    cat >~/.config/systemd/user/wallpaper-time.timer <<'EOF'
[Unit]
Description=Timer de wallpaper por horário

[Timer]
OnCalendar=*-*-* 06:00:00
OnCalendar=*-*-* 12:00:00
OnCalendar=*-*-* 18:00:00
OnCalendar=*-*-* 22:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

    cat >~/.config/systemd/user/dotfiles-backup.service <<'EOF'
[Unit]
Description=Backup dos dotfiles no GitHub

[Service]
Type=oneshot
ExecStart=%h/scripts/dotfiles-backup.sh
EOF

    cat >~/.config/systemd/user/dotfiles-backup.timer <<'EOF'
[Unit]
Description=Timer diário de backup dos dotfiles

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable --now wallpaper-time.timer
    systemctl --user enable --now dotfiles-backup.timer
    success "Serviços do usuário ativados"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 5 — FONTES
# ══════════════════════════════════════════════════════════
title "5. Fontes"

if ask "Atualizar cache de fontes?"; then
    fc-cache -fv &>/dev/null
    success "Cache de fontes atualizado"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 6 — SHELL PADRÃO
# ══════════════════════════════════════════════════════════
title "6. Shell"

if ask "Definir Fish como shell padrão?"; then
    FISH_PATH=$(which fish)
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$FISH_PATH"
    success "Fish definido como shell padrão"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 7 — GIT
# ══════════════════════════════════════════════════════════
title "7. Configuração do Git"

if ask "Configurar Git (nome e email)?"; then
    echo -e "${CYAN}  Nome:${NC} "
    read -r GIT_NAME
    echo -e "${CYAN}  Email:${NC} "
    read -r GIT_EMAIL
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    git config --global init.defaultBranch main
    success "Git configurado"
fi

# ══════════════════════════════════════════════════════════
# FINALIZAÇÃO
# ══════════════════════════════════════════════════════════
echo -e "\n${PURPLE}${BOLD}"
cat <<'EOF'
  ██╗ ██████╗  █████╗ ██╗
  ██║██╔════╝ ██╔══██╗██║
  ██║██║  ███╗███████║██║
  ██║██║   ██║██╔══██║██║
  ██║╚██████╔╝██║  ██║███████╗
  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
EOF
echo -e "${NC}"
echo -e "${GREEN}${BOLD}  ✓ IrajuArch OS instalado com sucesso!${NC}\n"
echo -e "${YELLOW}  Próximos passos:${NC}"
echo -e "  1. Reinicie o sistema:       ${CYAN}reboot${NC}"
echo -e "  2. Adicione wallpapers em:   ${CYAN}~/Wallpapers/{manha,tarde,noite,madrugada}${NC}"
echo -e "  3. Google Calendar:          ${CYAN}vdirsyncer discover && vdirsyncer sync${NC}"
echo -e "  4. GitHub CLI:               ${CYAN}gh auth login${NC}\n"
