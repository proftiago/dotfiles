#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════╗
# ║      IrajuArch OS — Welcome Screen               ║
# ║      by proftiago · Arch Linux · Hyprland        ║
# ╚══════════════════════════════════════════════════╝

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk
import os, sys

FLAG = os.path.expanduser("~/.config/irajuarch/.welcomed")

# ── Só roda se não tiver sido dispensado ───────────
if "--force" not in sys.argv and os.path.isfile(FLAG):
    sys.exit(0)

CSS = b"""
* { font-family: 'JetBrains Mono', 'Noto Sans', sans-serif; }
window { background-color: #1e1e2e; color: #cdd6f4; }

.header {
    background-color: #181825;
    border-bottom: 1px solid #313244;
    padding: 18px 24px 14px 24px;
}
.logo     { color: #cba6f7; font-size: 26px; font-weight: bold; }
.title    { color: #cba6f7; font-size: 16px; font-weight: bold; }
.subtitle { color: #6c7086; font-size: 11px; }

.page-title {
    color: #89b4fa;
    font-size: 13px;
    font-weight: bold;
    padding: 6px 0 2px 0;
}

.section-label {
    color: #89b4fa;
    font-size: 10px;
    font-weight: bold;
    letter-spacing: 1px;
}

.card {
    background-color: #181825;
    border: 1px solid #313244;
    border-radius: 10px;
    padding: 12px 16px;
    margin: 3px 0;
}

.keybind-key {
    color: #cba6f7;
    font-weight: bold;
    font-size: 11px;
    font-family: 'JetBrains Mono', monospace;
}
.keybind-desc {
    color: #a6adc8;
    font-size: 11px;
}

.comp-name { color: #cdd6f4; font-weight: bold; font-size: 11px; }
.comp-desc { color: #585b70; font-size: 10px; }

.step-num  { color: #a6e3a1; font-weight: bold; font-size: 13px; }
.step-text { color: #a6adc8; font-size: 11px; }

.nav-btn {
    background-color: #313244;
    color: #cdd6f4;
    border: 1px solid #45475a;
    border-radius: 10px;
    padding: 10px 20px;
    font-size: 12px;
}
.nav-btn:hover { background-color: #45475a; }

.close-btn {
    background: linear-gradient(135deg, #cba6f7, #89b4fa);
    color: #1e1e2e;
    border: none;
    border-radius: 10px;
    padding: 10px 28px;
    font-size: 12px;
    font-weight: bold;
}
.close-btn:hover { opacity: 0.88; }

.lang-btn {
    background-color: #313244;
    color: #89b4fa;
    border: 1px solid #45475a;
    border-radius: 6px;
    padding: 3px 10px;
    font-size: 10px;
}

.dot {
    background-color: #313244;
    border-radius: 99px;
    min-width: 8px;
    min-height: 8px;
    margin: 0 3px;
}
.dot.active {
    background-color: #cba6f7;
    min-width: 20px;
}

checkbutton label { color: #6c7086; font-size: 11px; }
checkbutton:checked label { color: #a6adc8; }
checkbutton check {
    background-color: #313244;
    border: 1px solid #45475a;
    border-radius: 4px;
    min-width: 14px;
    min-height: 14px;
}
checkbutton:checked check {
    background-color: #cba6f7;
    border-color: #cba6f7;
}
"""

STRINGS = {
    "en": {
        "title": "IrajuArch OS — Welcome",
        "subtitle": "Arch Linux · Hyprland · Wayland · by proftiago",
        "prev": "← Back",
        "next": "Next →",
        "close": "  Close",
        "no_show": "Don't show this again",
        "toggle": "PT",
        "pages": ["Welcome", "Keybinds", "Components", "First Steps"],
    },
    "pt": {
        "title": "IrajuArch OS — Boas-vindas",
        "subtitle": "Arch Linux · Hyprland · Wayland · by proftiago",
        "prev": "← Voltar",
        "next": "Próximo →",
        "close": "  Fechar",
        "no_show": "Não mostrar novamente",
        "toggle": "EN",
        "pages": ["Boas-vindas", "Atalhos", "Componentes", "Primeiros Passos"],
    }
}

KEYBINDS = [
    ("SUPER + Enter",    "Terminal (Kitty)"),
    ("SUPER + Space",    "App Launcher (Rofi)"),
    ("SUPER + E",        "Google Chrome"),
    ("SUPER + A",        "File Manager (Yazi)"),
    ("SUPER + W",        "Trocar wallpaper · Change wallpaper"),
    ("SUPER + Escape",   "Power Menu"),
    ("SUPER + K",        "Ver atalhos · All keybinds"),
    ("SUPER + T",        "Monitor do sistema · System monitor (btop)"),
    ("SUPER + P",        "Color Picker (hyprpicker)"),
    ("SUPER + Y",        "Clipboard (histórico · history)"),
    ("SUPER + Q",        "Fechar janela · Close window"),
    ("SUPER + F",        "Fullscreen"),
    ("SUPER + 1~5",      "Trocar workspace · Switch workspace"),
    ("Print",            "Screenshot completa · Full screenshot"),
    ("SHIFT + Print",    "Screenshot de área · Area screenshot"),
    ("CTRL + Print",     "Screenshot → Clipboard"),
]

COMPONENTS = [
    ("󰋙", "Hyprland",           "Window manager · animações · blur · bordas dinâmicas"),
    ("", "Waybar",             "Barra com 3 ilhas · música · clima · hardware"),
    ("󰆍", "Kitty + Fish",       "Terminal · JetBrainsMono · cores dinâmicas"),
    ("", "Rofi",               "Launcher · power menu · keybinds · configs viewer"),
    ("󰵙", "Mako",               "Notificações com glass effect"),
    ("", "Neovim + LazyVim",  "Editor · LSP para 5 linguagens"),
    ("󰒔", "SDDM + Plymouth",    "Login manager + boot splash animado"),
    ("󰚥", "Hyprlock + Hypridle","Tela de bloqueio + idle timeout"),
    ("󰄀", "SwayOSD",            "OSD de volume e brilho temático"),
    ("󰓅", "btop",               "Monitor de sistema flutuante (SUPER+T)"),
    ("󰟒", "Matugen v4",         "Cores dinâmicas para todo o sistema"),
    ("󰊢", "Dotfiles",           "GNU Stow + GitHub · backup diário"),
]

STEPS = [
    ("1", "SUPER + W",     "Trocar wallpaper e aplicar o tema · Change wallpaper & apply theme"),
    ("2", "SUPER + Space", "Testar o launcher · Test the app launcher"),
    ("3", "SUPER + K",     "Ver todos os atalhos · See all keybinds"),
    ("4", "~/Pictures/wallpapers/", "Adicionar seus wallpapers · Add your wallpapers here"),
    ("5", "~/.config/hypr/colors.conf", "Cores geradas pelo Matugen · Colors generated by Matugen"),
    ("6", "cd ~/dotfiles && git pull && stow -v stow/*", "Atualizar dotfiles · Update dotfiles"),
]


class WelcomeApp(Gtk.Window):
    def __init__(self):
        super().__init__(title="IrajuArch Welcome")
        self.lang = "pt"
        self.page = 0
        self.n_pages = 4

        self.set_default_size(700, 580)
        self.set_resizable(False)
        self.set_position(Gtk.WindowPosition.CENTER)

        prov = Gtk.CssProvider()
        prov.load_from_data(CSS)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(), prov,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        self._build_ui()
        self._update_page()
        self.show_all()

    def s(self, key):
        return STRINGS[self.lang][key]

    def _build_ui(self):
        root = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        self.add(root)
        root.pack_start(self._build_header(), False, False, 0)

        # Page stack
        self.stack = Gtk.Stack()
        self.stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT)
        self.stack.set_transition_duration(250)
        self.stack.set_margin_start(20)
        self.stack.set_margin_end(20)
        self.stack.set_margin_top(12)
        self.stack.add_named(self._build_page_welcome(),    "0")
        self.stack.add_named(self._build_page_keybinds(),   "1")
        self.stack.add_named(self._build_page_components(), "2")
        self.stack.add_named(self._build_page_steps(),      "3")
        root.pack_start(self.stack, True, True, 0)

        root.pack_start(self._build_footer(), False, False, 0)

    def _build_header(self):
        hdr = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
        hdr.get_style_context().add_class("header")

        logo = Gtk.Label(label="󰣇")
        logo.get_style_context().add_class("logo")
        hdr.pack_start(logo, False, False, 0)

        txt = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
        self.lbl_title = Gtk.Label(xalign=0)
        self.lbl_title.get_style_context().add_class("title")
        self.lbl_subtitle = Gtk.Label(xalign=0)
        self.lbl_subtitle.get_style_context().add_class("subtitle")
        txt.pack_start(self.lbl_title, False, False, 0)
        txt.pack_start(self.lbl_subtitle, False, False, 0)
        hdr.pack_start(txt, True, True, 0)

        self.btn_lang = Gtk.Button()
        self.btn_lang.get_style_context().add_class("lang-btn")
        self.btn_lang.connect("clicked", self._toggle_lang)
        hdr.pack_end(self.btn_lang, False, False, 0)
        return hdr

    def _build_footer(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        box.set_margin_start(20)
        box.set_margin_end(20)
        box.set_margin_top(8)
        box.set_margin_bottom(16)

        # Dots indicator
        self.dots_box = Gtk.Box(spacing=0, halign=Gtk.Align.CENTER)
        self.dots = []
        for _ in range(self.n_pages):
            d = Gtk.Label(label=" ")
            d.get_style_context().add_class("dot")
            self.dots.append(d)
            self.dots_box.pack_start(d, False, False, 0)
        box.pack_start(self.dots_box, False, False, 0)

        # Buttons row
        btn_row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)

        # Don't show again checkbox
        self.chk_noshow = Gtk.CheckButton()
        self.chk_noshow.get_style_context().add_class("no-show")
        btn_row.pack_start(self.chk_noshow, False, False, 0)

        btn_row.pack_start(Gtk.Box(), True, True, 0)  # spacer

        self.btn_prev = Gtk.Button()
        self.btn_prev.get_style_context().add_class("nav-btn")
        self.btn_prev.connect("clicked", self._on_prev)
        btn_row.pack_start(self.btn_prev, False, False, 0)

        self.btn_next = Gtk.Button()
        self.btn_next.connect("clicked", self._on_next)
        btn_row.pack_start(self.btn_next, False, False, 0)

        box.pack_start(btn_row, False, False, 0)
        return box

    # ── Pages ──────────────────────────────────────
    def _build_page_welcome(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)

        welcome_card = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        welcome_card.get_style_context().add_class("card")

        lines = [
            ("󰣇  Bem-vindo ao IrajuArch OS!", "#cba6f7", True),
            ("Welcome to IrajuArch OS!", "#cba6f7", True),
            ("", "#6c7086", False),
            ("Um desktop Arch Linux estilo macOS com Hyprland.", "#a6adc8", False),
            ("A macOS-inspired Arch Linux desktop with Hyprland.", "#a6adc8", False),
            ("", "#6c7086", False),
            ("Este guia vai te mostrar os atalhos, componentes", "#6c7086", False),
            ("e primeiros passos para aproveitar o sistema.", "#6c7086", False),
            ("This guide shows you the keybinds, components,", "#6c7086", False),
            ("and first steps to get the most out of it.", "#6c7086", False),
        ]
        for text, color, bold in lines:
            lbl = Gtk.Label(label=text, xalign=0)
            lbl.set_markup(f'<span foreground="{color}"{"  weight=\"bold\"" if bold else ""}>{GLib_escape(text)}</span>')
            welcome_card.pack_start(lbl, False, False, 0)

        box.pack_start(welcome_card, False, False, 0)

        # Quick stats
        stats = Gtk.Box(spacing=10)
        for icon, val, desc in [("󰏗", "27", "componentes"), ("󰌠", "∞", "temas"), ("󰃨", "4x", "wallpapers/dia")]:
            c = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4, halign=Gtk.Align.CENTER)
            c.get_style_context().add_class("card")
            i = Gtk.Label(label=f"{icon}  {val}")
            i.set_markup(f'<span foreground="#cba6f7" font="16" weight="bold">{icon}  {val}</span>')
            d = Gtk.Label(label=desc)
            d.set_markup(f'<span foreground="#6c7086" font="10">{desc}</span>')
            c.pack_start(i, False, False, 0)
            c.pack_start(d, False, False, 0)
            stats.pack_start(c, True, True, 0)
        box.pack_start(stats, False, False, 0)

        return box

    def _build_page_keybinds(self):
        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
        box.set_margin_bottom(8)

        for key, desc in KEYBINDS:
            row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
            row.get_style_context().add_class("card")

            k = Gtk.Label(label=key, xalign=0, width_chars=22)
            k.get_style_context().add_class("keybind-key")
            d = Gtk.Label(label=desc, xalign=0)
            d.get_style_context().add_class("keybind-desc")
            d.set_line_wrap(True)

            row.pack_start(k, False, False, 0)
            row.pack_start(d, True, True, 0)
            box.pack_start(row, False, False, 0)

        scroll.add(box)
        return scroll

    def _build_page_components(self):
        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
        box.set_margin_bottom(8)

        for icon, name, desc in COMPONENTS:
            row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
            row.get_style_context().add_class("card")

            ico = Gtk.Label(label=icon)
            ico.set_markup(f'<span foreground="#cba6f7" font="16">{icon}</span>')

            info = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
            n = Gtk.Label(label=name, xalign=0)
            n.get_style_context().add_class("comp-name")
            d = Gtk.Label(label=desc, xalign=0)
            d.get_style_context().add_class("comp-desc")
            d.set_line_wrap(True)
            info.pack_start(n, False, False, 0)
            info.pack_start(d, False, False, 0)

            row.pack_start(ico, False, False, 0)
            row.pack_start(info, True, True, 0)
            box.pack_start(row, False, False, 0)

        scroll.add(box)
        return scroll

    def _build_page_steps(self):
        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
        box.set_margin_bottom(8)

        for num, cmd, desc in STEPS:
            row = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
            row.get_style_context().add_class("card")

            top = Gtk.Box(spacing=10)
            n = Gtk.Label(label=num)
            n.set_markup(f'<span foreground="#a6e3a1" font="14" weight="bold">{num}</span>')
            d = Gtk.Label(label=desc, xalign=0)
            d.set_markup(f'<span foreground="#a6adc8" font="11">{desc}</span>')
            d.set_line_wrap(True)
            top.pack_start(n, False, False, 0)
            top.pack_start(d, True, True, 0)

            c = Gtk.Label(label=cmd, xalign=0)
            c.set_markup(f'<span foreground="#cba6f7" font="10" font_family="monospace">{cmd}</span>')

            row.pack_start(top, False, False, 0)
            row.pack_start(c, False, False, 0)
            box.pack_start(row, False, False, 0)

        scroll.add(box)
        return scroll

    # ── Navigation ─────────────────────────────────
    def _on_prev(self, _):
        if self.page > 0:
            self.page -= 1
            self.stack.set_transition_type(Gtk.StackTransitionType.SLIDE_RIGHT)
            self._update_page()

    def _on_next(self, _):
        if self.page < self.n_pages - 1:
            self.page += 1
            self.stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT)
            self._update_page()
        else:
            self._close()

    def _close(self):
        if self.chk_noshow.get_active():
            os.makedirs(os.path.dirname(FLAG), exist_ok=True)
            open(FLAG, "w").close()
        self.destroy()
        Gtk.main_quit()

    def _update_page(self):
        self.stack.set_visible_child_name(str(self.page))
        last = self.page == self.n_pages - 1

        self.btn_prev.set_sensitive(self.page > 0)
        self.btn_prev.set_label(self.s("prev"))

        if last:
            self.btn_next.get_style_context().add_class("close-btn")
            self.btn_next.get_style_context().remove_class("nav-btn")
            self.btn_next.set_label(self.s("close"))
        else:
            self.btn_next.get_style_context().add_class("nav-btn")
            self.btn_next.get_style_context().remove_class("close-btn")
            self.btn_next.set_label(self.s("next"))

        for i, d in enumerate(self.dots):
            ctx = d.get_style_context()
            if i == self.page:
                ctx.add_class("active")
            else:
                ctx.remove_class("active")

        self.lbl_title.set_text(self.s("title"))
        self.lbl_subtitle.set_text(self.s("subtitle"))
        self.btn_lang.set_label(self.s("toggle"))
        self.chk_noshow.set_label(self.s("no_show"))

    def _toggle_lang(self, _):
        self.lang = "en" if self.lang == "pt" else "pt"
        self._update_page()


def GLib_escape(text):
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


if __name__ == "__main__":
    app = WelcomeApp()
    app.connect("destroy", Gtk.main_quit)
    Gtk.main()
