# dotfiles — Tiago

Arch Linux + Hyprland setup gerenciado com [GNU Stow](https://www.gnu.org/software/stow/).

## Componentes
- **Hyprland** — compositor Wayland
- **Waybar** — barra com música, clima, hardware
- **Kitty** — terminal com Fish shell
- **Rofi** — launcher e menus
- **Mako** — notificações
- **Neovim** — editor com LazyVim
- **Fish** — shell com Starship prompt
- **Scripts** — wallpaper, clima, backup, calendário

## Instalação
```bash
git clone https://github.com/proftiago/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow hyprland waybar kitty rofi mako nvim fish scripts
```

## Estrutura
Cada pasta é um pacote Stow — ao rodar `stow <pasta>` ele cria symlinks automáticos em `~/.config/`.
