<div align="center">

# 󰣇 IrajubArch/OS

**Arch Linux · Hyprland · Wayland**

*A clean, dynamic and modern desktop environment built for productivity and aesthetics.*

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=hyprland&logoColor=black)](https://hyprland.org)
[![License](https://img.shields.io/badge/License-MIT-a6e3a1?style=for-the-badge)](LICENSE)

</div>

---

## ✨ Destaques

- 🎨 **Cores dinâmicas** — o sistema inteiro muda de cor com o wallpaper via Matugen
- 🕐 **Wallpaper por horário** — troca automático às 6h, 12h, 18h e 22h
- 🎵 **Widget de música** — controles prev/play/next diretamente na barra
- 🌤 **Widget de clima** — temperatura do Rio de Janeiro em tempo real
- 📅 **Google Calendar integrado** — notificações de aulas 15min antes com link do Meet
- 💾 **Backup automático** — dotfiles sincronizados no GitHub todo dia
- ⚡ **Boot animado** — Plymouth com tema Arch

---

## 🧩 Componentes

| Componente | Descrição |
|---|---|
| **Hyprland** | Compositor Wayland com animações, blur e bordas dinâmicas |
| **Waybar** | Barra em 3 ilhas — workspaces · música+relógio+clima · hardware |
| **Kitty** | Terminal com transparência, JetBrainsMono e Fish shell |
| **Rofi** | Launcher, power menu, keybinds viewer e configs viewer |
| **Mako** | Notificações com glass effect e cores dinâmicas |
| **Neovim** | Editor com LazyVim, LSP para 5 linguagens e tema dinâmico |
| **Fish** | Shell com Starship prompt — ícone Arch, git status, horário |
| **Matugen** | Gerador de paleta de cores a partir do wallpaper (Material You) |
| **swww** | Troca de wallpaper com animações suaves |
| **Scripts** | wallpaper-time, weather, dotfiles-backup, calendar, powermenu |

---

## 🚀 Instalação

### Pré-requisitos

- Arch Linux instalado (base system)
- Conexão com internet
- Conta no GitHub

### Instalação completa (recomendado)

```bash
git clone https://github.com/proftiago/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

O `install.sh` é **interativo** — pergunta antes de cada etapa e instala tudo automaticamente:

- ✅ Pacotes via pacman e AUR (yay)
- ✅ Dotfiles aplicados com GNU Stow
- ✅ Serviços systemd ativados
- ✅ Fish definido como shell padrão
- ✅ Fontes e cache atualizados
- ✅ Git configurado

### Instalação manual (só dotfiles)

```bash
git clone https://github.com/proftiago/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow hyprland waybar kitty rofi mako nvim fish scripts
```

---

## 📁 Estrutura do Repositório

```
dotfiles/
├── hyprland/         # ~/.config/hypr/
├── waybar/           # ~/.config/waybar/
├── kitty/            # ~/.config/kitty/
├── rofi/             # ~/.config/rofi/
├── mako/             # ~/.config/mako/
├── nvim/             # ~/.config/nvim/
├── fish/             # ~/.config/fish/
├── scripts/          # ~/scripts/
├── install.sh        # Script de instalação interativo
└── README.md
```

Cada pasta é um pacote [GNU Stow](https://www.gnu.org/software/stow/) — ao rodar `stow <pasta>` ele cria symlinks automáticos em `~/.config/`, mantendo os arquivos reais sempre dentro do repo.

---

## ⌨️ Atalhos principais

| Tecla | Ação |
|---|---|
| `SUPER + Enter` | Abre o terminal (Kitty) |
| `SUPER + Space` | Launcher (Rofi) |
| `SUPER + E` | Browser (Chrome) |
| `SUPER + A` | File manager (Yazi) |
| `SUPER + W` | Troca wallpaper aleatório |
| `SUPER + B` | Gerenciador Bluetooth |
| `SUPER + Q` | Fecha a janela |
| `SUPER + F` | Fullscreen |
| `SUPER + V` | Floating toggle |
| `SUPER + Escape` | Power menu |
| `SUPER + /` | Ver todos os keybinds |
| `SUPER + 1-5` | Muda de workspace |

---

## 📅 Pós-instalação

Após rodar o `install.sh`, configure:

```bash
# 1. Google Calendar
vdirsyncer discover
vdirsyncer sync

# 2. GitHub CLI
gh auth login

# 3. Adicione wallpapers por período
mkdir -p ~/Wallpapers/{manha,tarde,noite,madrugada}
# Coloque suas imagens em cada pasta

# 4. Reinicie
reboot
```

---

<div align="center">

Feito com ♥ no Rio de Janeiro 🇧🇷

</div>
