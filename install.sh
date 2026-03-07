#!/bin/bash

# ╔══════════════════════════════════════════════════════════╗
# ║         IrajuArch OS — Installer                        ║
# ║         Arch Linux · Hyprland · Wayland                 ║
# ║         github.com/proftiago/dotfiles                   ║
# ╚══════════════════════════════════════════════════════════╝

# ── Cores ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}  →${NC} $1"; }
success() { echo -e "${GREEN}  ✓${NC} $1"; }
warn()    { echo -e "${YELLOW}  ⚠${NC} $1"; }
error()   { echo -e "${RED}  ✗${NC} $1"; exit 1; }
title()   { echo -e "\n${PURPLE}${BOLD}══ $1 ══${NC}\n"; }
ask()     { echo -e "${CYAN}${BOLD}  ?${NC} $1 ${YELLOW}[s/N]${NC} "; read -r r; [[ "$r" =~ ^[sS]$ ]]; }

AUR_HELPER=""
INSTALL_MODE=""

# ══════════════════════════════════════════════════════════
# BANNER
# ══════════════════════════════════════════════════════════
clear
echo -e "${PURPLE}${BOLD}"
cat << 'EOF'

  ██╗██████╗  █████╗      ██╗██╗   ██╗ █████╗ ██████╗  ██████╗██╗  ██╗
  ██║██╔══██╗██╔══██╗     ██║██║   ██║██╔══██╗██╔══██╗██╔════╝██║  ██║
  ██║██████╔╝███████║     ██║██║   ██║███████║██████╔╝██║     ███████║
  ██║██╔══██╗██╔══██║██   ██║██║   ██║██╔══██║██╔══██╗██║     ██╔══██║
  ██║██║  ██║██║  ██║╚█████╔╝╚██████╔╝██║  ██║██║  ██║╚██████╗██║  ██║
  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝

                     ArchOS  ·  by proftiago

EOF
echo -e "${NC}${CYAN}  github.com/proftiago/dotfiles${NC}\n"

sleep 1

# ══════════════════════════════════════════════════════════
# MENU PRINCIPAL
# ══════════════════════════════════════════════════════════
echo -e "${BOLD}  Escolha o modo de instalação:${NC}\n"
echo -e "  ${YELLOW}1)${NC} ${BOLD}Full Install${NC}    — instala tudo do zero"
echo -e "  ${YELLOW}2)${NC} ${BOLD}Minimal${NC}         — só base + dotfiles + serviços"
echo -e "  ${YELLOW}3)${NC} ${BOLD}Update${NC}          — atualiza dotfiles e reinicia serviços"
echo -e "  ${YELLOW}4)${NC} ${BOLD}Wallpapers${NC}      — só baixa e organiza os wallpapers"
echo -e "  ${YELLOW}5)${NC} ${BOLD}Sair${NC}\n"

read -rp "  Escolha [1-5]: " INSTALL_MODE

case "$INSTALL_MODE" in
  1) echo -e "\n${GREEN}  Modo: Full Install${NC}" ;;
  2) echo -e "\n${GREEN}  Modo: Minimal${NC}" ;;
  3) echo -e "\n${GREEN}  Modo: Update${NC}" ;;
  4) echo -e "\n${GREEN}  Modo: Wallpapers${NC}" ;;
  5) echo -e "\n  Saindo..."; exit 0 ;;
  *) echo -e "\n${RED}  Opção inválida.${NC}"; exit 1 ;;
esac

sleep 1

# ══════════════════════════════════════════════════════════
# MODO: UPDATE
# ══════════════════════════════════════════════════════════
if [ "$INSTALL_MODE" = "3" ]; then
  title "Update — Dotfiles"

  DOTFILES_DIR="$HOME/dotfiles"

  if [ ! -d "$DOTFILES_DIR" ]; then
    info "Clonando dotfiles..."
    git clone https://github.com/proftiago/dotfiles.git "$DOTFILES_DIR"
  else
    info "Atualizando dotfiles..."
    cd "$DOTFILES_DIR" && git pull origin main
  fi

  info "Reaplicando Stow..."
  cd "$DOTFILES_DIR"
  for pkg in hyprland waybar kitty rofi mako nvim fish scripts; do
    stow --adopt "$pkg" 2>/dev/null && success "Stow: $pkg" || warn "Conflito em $pkg"
  done
  git checkout . 2>/dev/null

  info "Reiniciando Waybar..."
  pkill waybar && waybar 2>/dev/null &

  info "Recarregando Hyprland..."
  hyprctl reload 2>/dev/null

  info "Recarregando serviços do usuário..."
  systemctl --user daemon-reload
  systemctl --user restart wallpaper-time.timer 2>/dev/null
  systemctl --user restart dotfiles-backup.timer 2>/dev/null

  echo -e "\n${GREEN}${BOLD}  ✓ Update concluído!${NC}\n"
  exit 0
fi

# ══════════════════════════════════════════════════════════
# MODO: WALLPAPERS ONLY
# ══════════════════════════════════════════════════════════
if [ "$INSTALL_MODE" = "4" ]; then
  title "Wallpapers — ML4W"

  mkdir -p ~/Wallpapers/{manha,tarde,noite}

  info "Clonando wallpapers do ML4W..."
  TMPDIR=$(mktemp -d)
  git clone --depth=1 https://github.com/mylinuxforwork/wallpaper.git "$TMPDIR/ml4w-wallpapers"

  WALLPAPERS=("$TMPDIR/ml4w-wallpapers"/*.{jpg,png,jpeg} 2>/dev/null)
  TOTAL=${#WALLPAPERS[@]}
  PER_FOLDER=$(( TOTAL / 3 ))

  info "Distribuindo $TOTAL wallpapers em 3 pastas..."

  i=0
  for f in "${WALLPAPERS[@]}"; do
    [ -f "$f" ] || continue
    if   [ $i -lt $PER_FOLDER ]; then             cp "$f" ~/Wallpapers/manha/
    elif [ $i -lt $(( PER_FOLDER * 2 )) ]; then   cp "$f" ~/Wallpapers/tarde/
    else                                           cp "$f" ~/Wallpapers/noite/
    fi
    (( i++ ))
  done

  rm -rf "$TMPDIR"

  echo ""
  success "manha: $(ls ~/Wallpapers/manha/ | wc -l) wallpapers"
  success "tarde: $(ls ~/Wallpapers/tarde/ | wc -l) wallpapers"
  success "noite: $(ls ~/Wallpapers/noite/ | wc -l) wallpapers"
  echo -e "\n${GREEN}${BOLD}  ✓ Wallpapers instalados!${NC}\n"
  exit 0
fi

# ══════════════════════════════════════════════════════════
# VERIFICAÇÃO DE RAM (Full e Minimal)
# ══════════════════════════════════════════════════════════
title "0. Verificação de Sistema"

TOTAL_RAM=$(free -m | awk '/^Mem:/{print $2}')
TOTAL_SWAP=$(free -m | awk '/^Swap:/{print $2}')
TOTAL_MEM=$(( TOTAL_RAM + TOTAL_SWAP ))

info "RAM: ${TOTAL_RAM}MB | Swap: ${TOTAL_SWAP}MB | Total: ${TOTAL_MEM}MB"

if [ "$TOTAL_MEM" -lt 3072 ]; then
  warn "Memória insuficiente para compilar pacotes Rust (mínimo 3GB)."
  if ask "Criar swapfile de 3GB automaticamente?"; then
    if [ ! -f /swapfile ]; then
      info "Criando swapfile..."
      sudo fallocate -l 3G /swapfile
      sudo chmod 600 /swapfile
      sudo mkswap /swapfile
      sudo swapon /swapfile
      echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
      success "Swapfile criado e ativado"
    else
      warn "Swapfile já existe, pulando."
    fi
  fi
else
  success "Memória suficiente"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 1 — AUR HELPER
# ══════════════════════════════════════════════════════════
title "1. AUR Helper"

if command -v yay &>/dev/null; then
  AUR_HELPER="yay"; success "yay detectado"
elif command -v paru &>/dev/null; then
  AUR_HELPER="paru"; success "paru detectado"
else
  echo -e "  ${YELLOW}1)${NC} yay   ${YELLOW}2)${NC} paru"
  read -rp "  Escolha [1/2]: " choice
  case "$choice" in
    1)
      sudo pacman -S --needed git base-devel --noconfirm
      git clone https://aur.archlinux.org/yay.git /tmp/yay
      cd /tmp/yay && makepkg -si --noconfirm && cd ~ && rm -rf /tmp/yay
      AUR_HELPER="yay" ;;
    2)
      sudo pacman -S --needed git base-devel --noconfirm
      git clone https://aur.archlinux.org/paru.git /tmp/paru
      cd /tmp/paru && makepkg -si --noconfirm && cd ~ && rm -rf /tmp/paru
      AUR_HELPER="paru" ;;
    *) AUR_HELPER="yay"; warn "Usando yay como padrão" ;;
  esac
  success "$AUR_HELPER instalado"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 2 — PACOTES
# ══════════════════════════════════════════════════════════
title "2. Pacotes do Sistema"

PACMAN_PKGS=(
  base base-devel linux linux-firmware linux-headers intel-ucode
  efibootmgr sof-firmware zram-generator
  hyprland hyprlock hypridle hyprpaper
  xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xorg-xwayland
  pipewire pipewire-alsa pipewire-jack pipewire-pulse pipewire-libcamera
  wireplumber libpulse gst-plugin-pipewire
  vulkan-intel libcamera libcamera-ipa v4l2loopback-dkms
  waybar mako rofi swww grim wl-clipboard
  kitty fish starship nano vim neovim
  ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols-mono noto-fonts-emoji
  firefox thunar-archive-plugin nautilus libreoffice-fresh
  telegram-desktop pavucontrol blueman bluez bluez-utils
  git github-cli go npm python-pip ripgrep fd lazygit imagemagick bc fastfetch
  khal vdirsyncer
  ffmpegthumbnailer tumbler ueberzugpp guvcview
  networkmanager network-manager-applet cups cups-pdf system-config-printer
  ghostscript nss-mdns libnotify brightnessctl pacman-contrib stow
  adw-gtk-theme gnome-themes-extra breeze qt5-graphicaleffects qt6-5compat papirus-icon-theme
  sddm plymouth
)

AUR_PKGS=(
  swayosd-git matugen gradience gcalcli
  wleave wofi foot cage
  greetd greetd-regreet-git
  sddm-sugar-candy-git simple-sddm-theme-2-git where-is-my-sddm-theme-git
  plymouth-theme-archlinux hitech-arch-animation
  papirus-folders-catppuccin-git
  google-chrome youtubemusic zapzap yazi
  yay-debug
)

if [ "$INSTALL_MODE" = "1" ]; then
  if ask "Instalar pacotes pacman? (${#PACMAN_PKGS[@]} pacotes)"; then
    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
    success "Pacotes pacman instalados"
  fi
  if ask "Instalar pacotes AUR com $AUR_HELPER? (${#AUR_PKGS[@]} pacotes)"; then
    $AUR_HELPER -S --needed --noconfirm "${AUR_PKGS[@]}"
    success "Pacotes AUR instalados"
  fi
elif [ "$INSTALL_MODE" = "2" ]; then
  MINIMAL_PKGS=(hyprland waybar kitty fish starship rofi mako swww
    pipewire pipewire-pulse wireplumber networkmanager git stow
    ttf-jetbrains-mono-nerd noto-fonts-emoji)
  if ask "Instalar pacotes mínimos? (${#MINIMAL_PKGS[@]} pacotes)"; then
    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed --noconfirm "${MINIMAL_PKGS[@]}"
    success "Pacotes mínimos instalados"
  fi
fi

# ══════════════════════════════════════════════════════════
# ETAPA 3 — DOTFILES COM STOW
# ══════════════════════════════════════════════════════════
title "3. Dotfiles (Stow)"

if ask "Clonar e aplicar dotfiles?"; then
  DOTFILES_DIR="$HOME/dotfiles"
  if [ ! -d "$DOTFILES_DIR" ]; then
    git clone https://github.com/proftiago/dotfiles.git "$DOTFILES_DIR"
  else
    cd "$DOTFILES_DIR" && git pull origin main
  fi
  cd "$DOTFILES_DIR"
  for pkg in hyprland waybar kitty rofi mako nvim fish scripts; do
    stow --adopt "$pkg" 2>/dev/null && success "Stow: $pkg" || warn "Conflito em $pkg"
  done
  git checkout . 2>/dev/null
  success "Dotfiles aplicados"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 4 — SDDM
# ══════════════════════════════════════════════════════════
title "4. SDDM — Login Manager"

if [ "$INSTALL_MODE" = "1" ] && ask "Configurar SDDM com seu tema?"; then
  sudo systemctl enable sddm

  # Copia tema dos dotfiles se existir
  if [ -d "$HOME/dotfiles/sddm" ]; then
    sudo cp -r "$HOME/dotfiles/sddm/." /usr/share/sddm/themes/
    success "Tema SDDM copiado dos dotfiles"
  fi

  # Config do SDDM
  sudo mkdir -p /etc/sddm.conf.d
  cat << 'EOF' | sudo tee /etc/sddm.conf.d/theme.conf
[Theme]
Current=sddm-sugar-candy
EOF
  success "SDDM configurado"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 5 — HYPRLOCK + HYPRIDLE
# ══════════════════════════════════════════════════════════
title "5. Hyprlock + Hypridle"

if [ "$INSTALL_MODE" = "1" ] && ask "Configurar hyprlock e hypridle?"; then

  # hypridle — entra em lock após 5min, suspende após 10min
  mkdir -p ~/.config/hypr
  cat > ~/.config/hypr/hypridle.conf << 'EOF'
general {
    lock_cmd = pidof hyprlock || hyprlock
    before_sleep_cmd = loginctl lock-session
    after_sleep_cmd = hyprctl dispatch dpms on
}

listener {
    timeout = 300
    on-timeout = loginctl lock-session
}

listener {
    timeout = 600
    on-timeout = systemctl suspend
}

listener {
    timeout = 30
    on-timeout = hyprctl dispatch dpms off
    on-resume  = hyprctl dispatch dpms on
}
EOF
  success "hypridle.conf criado"

  # Ativa hypridle no autostart do Hyprland se não estiver
  if ! grep -q "hypridle" ~/.config/hypr/hyprland.conf 2>/dev/null; then
    echo -e "\nexec-once = hypridle" >> ~/.config/hypr/hyprland.conf
    success "hypridle adicionado ao autostart"
  fi

  success "Hyprlock + Hypridle configurados"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 6 — PLYMOUTH
# ══════════════════════════════════════════════════════════
title "6. Plymouth (Boot Splash)"

if [ "$INSTALL_MODE" = "1" ] && ask "Configurar Plymouth com tema Arch?"; then

  # Instala tema se não tiver
  if ! plymouth-set-default-theme --list 2>/dev/null | grep -q "archlinux"; then
    $AUR_HELPER -S --noconfirm plymouth-theme-archlinux 2>/dev/null
  fi

  sudo plymouth-set-default-theme -R archlinux

  # Adiciona plymouth ao mkinitcpio
  if ! grep -q "plymouth" /etc/mkinitcpio.conf; then
    sudo sed -i 's/^HOOKS=(\(.*\)udev\(.*\))/HOOKS=(\1udev plymouth\2)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
    success "Plymouth adicionado ao initramfs"
  fi

  # Adiciona quiet splash ao bootloader
  if [ -f /boot/loader/entries/*.conf ]; then
    sudo sed -i 's/^options.*/& quiet splash/' /boot/loader/entries/*.conf 2>/dev/null
  fi

  success "Plymouth configurado com tema Arch"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 7 — WALLPAPERS (ML4W)
# ══════════════════════════════════════════════════════════
title "7. Wallpapers — ML4W"

if ask "Baixar e organizar wallpapers do ML4W?"; then
  mkdir -p ~/Wallpapers/{manha,tarde,noite}

  info "Clonando wallpapers..."
  TMPDIR=$(mktemp -d)
  git clone --depth=1 https://github.com/mylinuxforwork/wallpaper.git "$TMPDIR/ml4w-wallpapers"

  mapfile -t WALLPAPERS < <(find "$TMPDIR/ml4w-wallpapers" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \))
  TOTAL=${#WALLPAPERS[@]}
  PER=$(( TOTAL / 3 ))

  info "Distribuindo $TOTAL wallpapers..."
  for (( i=0; i<TOTAL; i++ )); do
    f="${WALLPAPERS[$i]}"
    if   [ $i -lt $PER ]; then             cp "$f" ~/Wallpapers/manha/
    elif [ $i -lt $(( PER * 2 )) ]; then   cp "$f" ~/Wallpapers/tarde/
    else                                   cp "$f" ~/Wallpapers/noite/
    fi
  done

  rm -rf "$TMPDIR"
  success "manha: $(ls ~/Wallpapers/manha/ | wc -l) | tarde: $(ls ~/Wallpapers/tarde/ | wc -l) | noite: $(ls ~/Wallpapers/noite/ | wc -l)"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 8 — SERVIÇOS SYSTEMD
# ══════════════════════════════════════════════════════════
title "8. Serviços Systemd"

if ask "Ativar serviços do sistema?"; then
  sudo systemctl enable --now NetworkManager
  sudo systemctl enable --now bluetooth
  sudo systemctl enable --now cups
  success "Serviços do sistema ativados"
fi

if ask "Ativar timers do usuário (wallpaper-time, dotfiles-backup)?"; then
  mkdir -p ~/.config/systemd/user

  cat > ~/.config/systemd/user/wallpaper-time.service << 'EOF'
[Unit]
Description=Troca wallpaper por horário
[Service]
Type=oneshot
ExecStart=%h/scripts/wallpaper-time.sh
EOF

  cat > ~/.config/systemd/user/wallpaper-time.timer << 'EOF'
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

  cat > ~/.config/systemd/user/dotfiles-backup.service << 'EOF'
[Unit]
Description=Backup dos dotfiles no GitHub
[Service]
Type=oneshot
ExecStart=%h/scripts/dotfiles-backup.sh
EOF

  cat > ~/.config/systemd/user/dotfiles-backup.timer << 'EOF'
[Unit]
Description=Timer diário de backup
[Timer]
OnCalendar=daily
Persistent=true
[Install]
WantedBy=timers.target
EOF

  systemctl --user daemon-reload
  systemctl --user enable --now wallpaper-time.timer
  systemctl --user enable --now dotfiles-backup.timer
  success "Timers ativados"
fi

# ══════════════════════════════════════════════════════════
# ETAPA 9 — FONTES + SHELL + GIT
# ══════════════════════════════════════════════════════════
title "9. Fontes, Shell e Git"

if ask "Atualizar cache de fontes?"; then
  fc-cache -fv &>/dev/null
  success "Cache de fontes atualizado"
fi

if ask "Definir Fish como shell padrão?"; then
  FISH_PATH=$(which fish)
  grep -q "$FISH_PATH" /etc/shells || echo "$FISH_PATH" | sudo tee -a /etc/shells
  chsh -s "$FISH_PATH"
  success "Fish definido como shell padrão"
fi

if ask "Configurar Git?"; then
  read -rp "  Nome: " GIT_NAME
  read -rp "  Email: " GIT_EMAIL
  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
  git config --global init.defaultBranch main
  success "Git configurado"
fi

# ══════════════════════════════════════════════════════════
# FINALIZAÇÃO
# ══════════════════════════════════════════════════════════
echo -e "\n${PURPLE}${BOLD}"
cat << 'EOF'
  ██╗ ██████╗  █████╗ ██╗
  ██║██╔════╝ ██╔══██╗██║
  ██║██║  ███╗███████║██║
  ██║██║   ██║██╔══██║██║
  ██║╚██████╔╝██║  ██║███████╗
  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
EOF
echo -e "${NC}${GREEN}${BOLD}  ✓ IrajuArch OS instalado com sucesso!${NC}\n"
echo -e "${YELLOW}  Próximos passos:${NC}"
echo -e "  1. Reinicie:             ${CYAN}reboot${NC}"
echo -e "  2. Google Calendar:      ${CYAN}vdirsyncer discover && vdirsyncer sync${NC}"
echo -e "  3. GitHub CLI:           ${CYAN}gh auth login${NC}"
echo -e "  4. Webapp creator:       ${CYAN}~/scripts/webapp.sh${NC}\n"
