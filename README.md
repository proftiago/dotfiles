# 󰣇 IrajuArch OS — Dotfiles

> Arch Linux · Hyprland · Wayland · by proftiago

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=wayland&logoColor=black)
![CachyOS](https://img.shields.io/badge/CachyOS-compatible-blue?style=for-the-badge)
![EndeavourOS](https://img.shields.io/badge/EndeavourOS-compatible-purple?style=for-the-badge)

---

## ✨ Sobre

IrajuArch é um desktop **macOS-inspired** construído sobre Arch Linux com Hyprland e Wayland.  
Temas dinâmicos gerados automaticamente a partir do wallpaper via **Matugen**, visual coeso em todo o sistema.

Compatível com:
- 🟣 **EndeavourOS**
- ⚡ **CachyOS**
- 󰣇 **Arch Linux** (instalação manual)

---

## 🚀 Instalação — Um comando

Abra um terminal após fazer login no desktop e rode:

```bash
curl -fsSL https://raw.githubusercontent.com/proftiago/dotfiles/main/bootstrap.sh | bash
```

Isso irá:
1. Verificar compatibilidade do sistema
2. Instalar `git`, `python`, `gtk3`, `stow` e `yay`
3. Clonar este repositório
4. Abrir o **instalador gráfico GTK**

> ⚠️ Execute após estar logado no desktop gráfico (não funciona no TTY puro).

---

## 🖥️ Instalador Gráfico

O instalador permite escolher:

| Modo | Descrição |
|------|-----------|
| **Instalação Completa** | Instala todos os componentes |
| **Modular** | Escolha componente por componente |
| **Atualizar Dotfiles** | Só atualiza configs existentes |
| **Wallpapers** | Instala a coleção de wallpapers |

---

## 🧩 Componentes

| Componente | Descrição |
|------------|-----------|
| Hyprland | Window manager · blur · animações · bordas dinâmicas |
| Waybar | Barra com 3 ilhas · música · clima · hardware |
| Kitty + Fish | Terminal com cores dinâmicas |
| Rofi | Launcher · power menu · keybinds viewer |
| Mako | Notificações com glass effect |
| Neovim + LazyVim | Editor com LSP para 5 linguagens |
| SDDM | Login manager com tema customizado |
| Plymouth | Boot splash animado com logo Arch |
| Hyprlock + Hypridle | Tela de bloqueio + idle timeout |
| SwayOSD | OSD de volume e brilho temático |
| btop | Monitor de sistema flutuante |
| Fastfetch | System info com logo Arch |
| Matugen v4 | Cores dinâmicas para todo o sistema |

---

## ⌨️ Atalhos principais

| Atalho | Ação |
|--------|------|
| `SUPER + Enter` | Terminal (Kitty) |
| `SUPER + Space` | App Launcher (Rofi) |
| `SUPER + W` | Trocar wallpaper |
| `SUPER + K` | Ver todos os atalhos |
| `SUPER + T` | Monitor do sistema (btop) |
| `SUPER + P` | Color Picker |
| `SUPER + Y` | Clipboard (histórico) |
| `SUPER + Escape` | Power Menu |
| `Print` | Screenshot completa |
| `SHIFT + Print` | Screenshot de área |

---

## 📁 Estrutura

```
dotfiles/
├── bootstrap.sh       ← Instalar do zero (curl | bash)
├── install.py         ← Instalador gráfico GTK
├── welcome.py         ← App de boas-vindas (primeira vez)
├── stow/
│   ├── hypr/
│   ├── waybar/
│   ├── kitty/
│   ├── rofi/
│   ├── mako/
│   ├── nvim/
│   └── scripts/
└── docs/
    └── sudoers-wallpaper.txt
```

---

## 🔄 Atualizar dotfiles manualmente

```bash
cd ~/dotfiles
git pull
stow -v --restow stow/*
```

---

## 👤 Autor

**proftiago** — Professor de idiomas e entusiasta Arch Linux do Rio de Janeiro 🇧🇷

---
