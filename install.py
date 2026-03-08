#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════╗
# ║      IrajuArch OS — Graphical Installer          ║
# ║      by proftiago · Arch Linux · Hyprland        ║
# ╚══════════════════════════════════════════════════╝

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk, GLib, Pango
import subprocess, threading, os, sys

# ── Language strings ───────────────────────────────
STRINGS = {
    "en": {
        "title": "IrajuArch OS — Installer",
        "subtitle": "Arch Linux · Hyprland · Wayland · by proftiago",
        "mode_label": "INSTALLATION MODE",
        "comp_label": "SELECT COMPONENTS",
        "log_label": "OUTPUT",
        "full": "󰄬  Full Install",
        "modular": "󰗠  Modular",
        "update": "󰚰  Update Dotfiles",
        "wallpapers": "󰋙  Wallpapers",
        "install": "  Install",
        "cancel": "Cancel",
        "sel_all": "Select All",
        "sel_none": "Clear",
        "done": "✅ Done!",
        "toggle": "PT",
        "ready": "Ready to install. Choose a mode above.",
        "cloning": "Cloning dotfiles...",
        "stowing": "Applying dotfiles with stow...",
        "installing_pkg": "Installing packages...",
        "wallpapers_msg": "Installing wallpapers...",
        "update_msg": "Updating dotfiles...",
        "success": "✅ Installation complete!",
        "error": "❌ An error occurred. Check the output above.",
    },
    "pt": {
        "title": "IrajuArch OS — Instalador",
        "subtitle": "Arch Linux · Hyprland · Wayland · by proftiago",
        "mode_label": "MODO DE INSTALAÇÃO",
        "comp_label": "SELECIONAR COMPONENTES",
        "log_label": "SAÍDA",
        "full": "󰄬  Instalação Completa",
        "modular": "󰗠  Modular",
        "update": "󰚰  Atualizar Dotfiles",
        "wallpapers": "󰋙  Wallpapers",
        "install": "  Instalar",
        "cancel": "Cancelar",
        "sel_all": "Selecionar Tudo",
        "sel_none": "Limpar",
        "done": "✅ Concluído!",
        "toggle": "EN",
        "ready": "Pronto para instalar. Escolha um modo acima.",
        "cloning": "Clonando dotfiles...",
        "stowing": "Aplicando dotfiles com stow...",
        "installing_pkg": "Instalando pacotes...",
        "wallpapers_msg": "Instalando wallpapers...",
        "update_msg": "Atualizando dotfiles...",
        "success": "✅ Instalação concluída!",
        "error": "❌ Ocorreu um erro. Veja a saída acima.",
    }
}

COMPONENTS = [
    ("hyprland",  "Hyprland",           "Window manager + swww + matugen + hyprpicker"),
    ("waybar",    "Waybar",             "Status bar com 3 ilhas · 3-island status bar"),
    ("kitty",     "Kitty + Fish",       "Terminal · cores dinâmicas · dynamic colors"),
    ("rofi",      "Rofi",               "Launcher · power menu · keybinds viewer"),
    ("mako",      "Mako",               "Notificações · glass effect · Notifications"),
    ("neovim",    "Neovim + LazyVim",   "Editor · LSP para 5 linguagens · 5 languages"),
    ("sddm",      "SDDM",               "Login manager · tema customizado · custom theme"),
    ("plymouth",  "Plymouth",           "Boot splash animado · animated boot screen"),
    ("hyprlock",  "Hyprlock + Hypridle","Tela de bloqueio · lock screen + idle timeout"),
    ("swayosd",   "SwayOSD",            "OSD de volume e brilho · volume & brightness OSD"),
    ("btop",      "btop",               "Monitor de sistema flutuante · floating system monitor"),
    ("fastfetch", "Fastfetch",          "System info · logo Arch · color palette"),
]

PACKAGES = {
    "hyprland":  ["hyprland", "swww", "matugen", "hyprpicker", "wl-clipboard", "cliphist", "swayosd"],
    "waybar":    ["waybar", "python-requests"],
    "kitty":     ["kitty", "fish", "starship"],
    "rofi":      ["rofi-wayland"],
    "mako":      ["mako", "libnotify"],
    "neovim":    ["neovim", "ripgrep", "fd"],
    "sddm":      ["sddm", "qt6-svg"],
    "plymouth":  ["plymouth"],
    "hyprlock":  ["hyprlock", "hypridle"],
    "swayosd":   ["swayosd"],
    "btop":      ["btop"],
    "fastfetch": ["fastfetch"],
}

DOTFILES_REPO = "https://github.com/proftiago/dotfiles"
DOTFILES_DIR  = os.path.expanduser("~/dotfiles")
WALLPAPERS_REPO = "https://github.com/mylinuxforwork/wallpaper.git"
WALLPAPERS_DIR  = os.path.expanduser("~/Pictures/wallpapers")

CSS = b"""
* { font-family: 'JetBrains Mono', 'Noto Sans', sans-serif; }
window { background-color: #1e1e2e; color: #cdd6f4; }

.header {
    background-color: #181825;
    border-bottom: 1px solid #313244;
    padding: 18px 24px 14px 24px;
}
.logo    { color: #cba6f7; font-size: 26px; font-weight: bold; }
.title   { color: #cba6f7; font-size: 16px; font-weight: bold; }
.subtitle{ color: #6c7086; font-size: 11px; }

.section-label {
    color: #89b4fa;
    font-size: 10px;
    font-weight: bold;
    letter-spacing: 1px;
}

.mode-btn {
    background-color: #181825;
    color: #a6adc8;
    border: 1px solid #313244;
    border-radius: 10px;
    padding: 10px 18px;
    font-size: 12px;
    transition: all 200ms;
}
.mode-btn:hover   { background-color: #313244; color: #cdd6f4; }
.mode-btn.active  {
    background-color: rgba(203,166,247,0.18);
    border-color: #cba6f7;
    color: #cba6f7;
    font-weight: bold;
}

.comp-box {
    background-color: #181825;
    border: 1px solid #313244;
    border-radius: 8px;
    padding: 8px 12px;
    margin: 2px 0;
}
.comp-box:hover { border-color: #45475a; }
.comp-name { color: #cdd6f4; font-weight: bold; font-size: 12px; }
.comp-desc { color: #585b70; font-size: 10px; }

.install-btn {
    background: linear-gradient(135deg, #cba6f7, #89b4fa);
    color: #1e1e2e;
    border: none;
    border-radius: 10px;
    padding: 11px 36px;
    font-size: 13px;
    font-weight: bold;
}
.install-btn:hover    { opacity: 0.88; }
.install-btn:disabled { opacity: 0.35; }

.cancel-btn {
    background-color: #313244;
    color: #cdd6f4;
    border: 1px solid #45475a;
    border-radius: 10px;
    padding: 11px 20px;
    font-size: 12px;
}
.cancel-btn:hover { background-color: #45475a; }

.sel-btn {
    background-color: transparent;
    color: #6c7086;
    border: 1px solid #313244;
    border-radius: 6px;
    padding: 3px 10px;
    font-size: 10px;
}
.sel-btn:hover { color: #cdd6f4; border-color: #45475a; }

.lang-btn {
    background-color: #313244;
    color: #89b4fa;
    border: 1px solid #45475a;
    border-radius: 6px;
    padding: 3px 10px;
    font-size: 10px;
}

.log-view {
    background-color: #11111b;
    color: #a6e3a1;
    font-family: 'JetBrains Mono', monospace;
    font-size: 10px;
    padding: 8px;
}

checkbutton check {
    background-color: #313244;
    border: 1px solid #45475a;
    border-radius: 4px;
    min-width: 16px;
    min-height: 16px;
}
checkbutton:checked check {
    background-color: #cba6f7;
    border-color: #cba6f7;
}
checkbutton label { color: #cdd6f4; }

scrolledwindow { border-radius: 8px; }
"""


class IrajuInstaller(Gtk.Window):
    def __init__(self):
        super().__init__(title="IrajuArch Installer")
        self.lang = "pt"
        self.mode = None
        self.checks = {}
        self.installing = False

        self.set_default_size(780, 680)
        self.set_resizable(True)
        self.set_position(Gtk.WindowPosition.CENTER)

        # Apply CSS
        prov = Gtk.CssProvider()
        prov.load_from_data(CSS)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(), prov,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        self._build_ui()
        self._update_lang()
        self.show_all()
        self.comp_scroll.hide()

    def s(self, key):
        return STRINGS[self.lang][key]

    # ── UI Builder ─────────────────────────────────
    def _build_ui(self):
        root = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        self.add(root)

        root.pack_start(self._build_header(), False, False, 0)

        content = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        content.set_margin_start(20)
        content.set_margin_end(20)
        content.set_margin_top(16)
        content.set_margin_bottom(16)
        root.pack_start(content, True, True, 0)

        content.pack_start(self._build_modes(), False, False, 0)
        content.pack_start(self._build_components(), True, True, 12)
        content.pack_start(self._build_log(), True, True, 0)
        content.pack_start(self._build_buttons(), False, False, 12)

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

    def _build_modes(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)

        self.lbl_mode = Gtk.Label(xalign=0)
        self.lbl_mode.get_style_context().add_class("section-label")
        box.pack_start(self.lbl_mode, False, False, 0)

        btns = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        self.mode_btns = {}
        for key in ("full", "modular", "update", "wallpapers"):
            b = Gtk.Button()
            b.get_style_context().add_class("mode-btn")
            b.connect("clicked", self._on_mode, key)
            self.mode_btns[key] = b
            btns.pack_start(b, True, True, 0)

        box.pack_start(btns, False, False, 0)
        return box

    def _build_components(self):
        outer = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)

        hdr = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=0)
        self.lbl_comp = Gtk.Label(xalign=0)
        self.lbl_comp.get_style_context().add_class("section-label")
        hdr.pack_start(self.lbl_comp, True, True, 0)

        sel_box = Gtk.Box(spacing=6)
        self.btn_all  = Gtk.Button()
        self.btn_none = Gtk.Button()
        self.btn_all.get_style_context().add_class("sel-btn")
        self.btn_none.get_style_context().add_class("sel-btn")
        self.btn_all.connect("clicked",  lambda _: self._set_all(True))
        self.btn_none.connect("clicked", lambda _: self._set_all(False))
        sel_box.pack_start(self.btn_all,  False, False, 0)
        sel_box.pack_start(self.btn_none, False, False, 0)
        hdr.pack_end(sel_box, False, False, 0)
        outer.pack_start(hdr, False, False, 0)

        self.comp_scroll = Gtk.ScrolledWindow()
        self.comp_scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        self.comp_scroll.set_min_content_height(220)

        grid = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        for key, name, desc in COMPONENTS:
            row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
            row.get_style_context().add_class("comp-box")

            chk = Gtk.CheckButton()
            chk.set_active(True)
            self.checks[key] = chk
            row.pack_start(chk, False, False, 0)

            info = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=1)
            lbl_n = Gtk.Label(label=name, xalign=0)
            lbl_n.get_style_context().add_class("comp-name")
            lbl_d = Gtk.Label(label=desc, xalign=0)
            lbl_d.get_style_context().add_class("comp-desc")
            lbl_d.set_line_wrap(True)
            info.pack_start(lbl_n, False, False, 0)
            info.pack_start(lbl_d, False, False, 0)
            row.pack_start(info, True, True, 0)

            grid.pack_start(row, False, False, 2)

        self.comp_scroll.add(grid)
        outer.pack_start(self.comp_scroll, True, True, 0)
        return outer

    def _build_log(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.lbl_log = Gtk.Label(xalign=0)
        self.lbl_log.get_style_context().add_class("section-label")
        box.pack_start(self.lbl_log, False, False, 0)

        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scroll.set_min_content_height(120)

        self.log_buf = Gtk.TextBuffer()
        tv = Gtk.TextView(buffer=self.log_buf)
        tv.set_editable(False)
        tv.set_wrap_mode(Gtk.WrapMode.WORD_CHAR)
        tv.get_style_context().add_class("log-view")
        self.log_view = tv
        scroll.add(tv)
        box.pack_start(scroll, True, True, 0)
        return box

    def _build_buttons(self):
        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        box.set_halign(Gtk.Align.END)

        self.btn_cancel = Gtk.Button()
        self.btn_cancel.get_style_context().add_class("cancel-btn")
        self.btn_cancel.connect("clicked", lambda _: self.destroy())
        box.pack_start(self.btn_cancel, False, False, 0)

        self.btn_install = Gtk.Button()
        self.btn_install.get_style_context().add_class("install-btn")
        self.btn_install.set_sensitive(False)
        self.btn_install.connect("clicked", self._on_install)
        box.pack_start(self.btn_install, False, False, 0)

        return box

    # ── Language ───────────────────────────────────
    def _toggle_lang(self, _):
        self.lang = "en" if self.lang == "pt" else "pt"
        self._update_lang()

    def _update_lang(self):
        s = self.s
        self.lbl_title.set_text(s("title"))
        self.lbl_subtitle.set_text(s("subtitle"))
        self.lbl_mode.set_text(s("mode_label"))
        self.lbl_comp.set_text(s("comp_label"))
        self.lbl_log.set_text(s("log_label"))
        self.btn_lang.set_label(s("toggle"))
        self.btn_install.set_label(s("install"))
        self.btn_cancel.set_label(s("cancel"))
        self.btn_all.set_label(s("sel_all"))
        self.btn_none.set_label(s("sel_none"))
        for key in ("full", "modular", "update", "wallpapers"):
            self.mode_btns[key].set_label(s(key))
        self._log(s("ready"))

    # ── Mode selection ─────────────────────────────
    def _on_mode(self, _, key):
        self.mode = key
        for k, b in self.mode_btns.items():
            ctx = b.get_style_context()
            if k == key:
                ctx.add_class("active")
            else:
                ctx.remove_class("active")

        if key == "modular":
            self.comp_scroll.show()
        else:
            self.comp_scroll.hide()

        self.btn_install.set_sensitive(True)

    def _set_all(self, state):
        for chk in self.checks.values():
            chk.set_active(state)

    # ── Logging ────────────────────────────────────
    def _log(self, msg):
        def _do():
            end = self.log_buf.get_end_iter()
            self.log_buf.insert(end, msg + "\n")
            self.log_view.scroll_to_iter(self.log_buf.get_end_iter(), 0, False, 0, 0)
        GLib.idle_add(_do)

    # ── Install ────────────────────────────────────
    def _on_install(self, _):
        if self.installing:
            return
        self.installing = True
        self.btn_install.set_sensitive(False)
        self.log_buf.set_text("")
        threading.Thread(target=self._run_install, daemon=True).start()

    def _run_install(self):
        try:
            if self.mode == "update":
                self._do_update()
            elif self.mode == "wallpapers":
                self._do_wallpapers()
            elif self.mode == "full":
                self._do_install([k for k, _, _ in COMPONENTS])
            elif self.mode == "modular":
                selected = [k for k, chk in self.checks.items() if chk.get_active()]
                self._do_install(selected)
            GLib.idle_add(lambda: self.btn_install.set_label(self.s("done")))
            self._log(self.s("success"))
            # Create welcome flag
            os.makedirs(os.path.expanduser("~/.config/irajuarch"), exist_ok=True)
            open(os.path.expanduser("~/.config/irajuarch/.installed"), "w").close()
        except Exception as e:
            self._log(f"❌ Error: {e}")
        finally:
            self.installing = False
            GLib.idle_add(lambda: self.btn_install.set_sensitive(True))

    def _run(self, cmd, label=None):
        if label:
            self._log(f"→ {label}")
        proc = subprocess.Popen(
            cmd, shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        )
        for line in proc.stdout:
            self._log(line.rstrip())
        proc.wait()
        if proc.returncode != 0:
            raise RuntimeError(f"Command failed: {cmd}")

    def _ensure_dotfiles(self):
        env = "GIT_TERMINAL_PROMPT=0"
        if not os.path.isdir(DOTFILES_DIR):
            self._run(f"{env} git clone {DOTFILES_REPO} {DOTFILES_DIR}", self.s("cloning"))
        else:
            self._run(f"{env} git -C {DOTFILES_DIR} pull || true", "Updating dotfiles repo...")

    def _ensure_yay(self):
        if subprocess.run("command -v yay", shell=True, capture_output=True).returncode != 0:
            self._log("→ Installing yay (AUR helper)...")
            self._run("sudo pacman -S --needed base-devel git --noconfirm")
            self._run("git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si --noconfirm")

    def _ensure_sudo(self):
        self._log("→ Solicitando permissão sudo uma vez...")
        subprocess.run("sudo -v", shell=True)
        # Mantém sudo ativo em background
        subprocess.Popen("while true; do sudo -n true; sleep 50; done 2>/dev/null &", shell=True)

    def _do_install(self, components):
        self._ensure_sudo()
        self._ensure_yay()
        self._ensure_dotfiles()

        pkgs = []
        for comp in components:
            pkgs.extend(PACKAGES.get(comp, []))

        if pkgs:
            self._run(
                f"yay -S --needed --noconfirm {' '.join(set(pkgs))}",
                self.s("installing_pkg")
            )

        self._run(
            f"cd {DOTFILES_DIR} && stow -v -t $HOME hyprland kitty rofi mako waybar fish nvim config 2>/dev/null || true",
            self.s("stowing")
        )
        self._run(
            f"cd {DOTFILES_DIR}/stow && stow -v -t $HOME scripts swayosd 2>/dev/null || true",
            "Applying stow extras..."
        )

        # Post-install steps
        if "sddm" in components:
            self._run("sudo systemctl disable --now plasmalogin gdm lightdm lxdm 2>/dev/null || true", "Disabling existing display manager...")
            self._run("sudo systemctl enable --force sddm", "Enabling SDDM...")
        if "plymouth" in components:
            self._run("sudo mkinitcpio -P", "Rebuilding initramfs...")
        if "hyprlock" in components:
            self._run("sudo systemctl enable hypridle --user 2>/dev/null || true")

        self._do_wallpapers()

        # Launch welcome on first run
        self._run(f"python {DOTFILES_DIR}/welcome.py &", "Launching welcome screen...")

    def _do_update(self):
        self._ensure_sudo()
        self._ensure_dotfiles()
        self._run(
            f"cd {DOTFILES_DIR} && stow -v --restow -t $HOME hyprland kitty rofi mako waybar fish nvim config 2>/dev/null || true",
            self.s("update_msg")
        )
        self._run(
            f"cd {DOTFILES_DIR}/stow && stow -v --restow -t $HOME scripts swayosd 2>/dev/null || true",
            "Restowing extras..."
        )

    def _do_wallpapers(self):
        self._log(self.s("wallpapers_msg"))
        env = "GIT_TERMINAL_PROMPT=0"
        os.makedirs(WALLPAPERS_DIR, exist_ok=True)
        if not os.path.isdir(os.path.join(WALLPAPERS_DIR, ".git")):
            self._run(f"{env} git clone {WALLPAPERS_REPO} {WALLPAPERS_DIR} || true")
        else:
            self._run(f"{env} git -C {WALLPAPERS_DIR} pull || true")


if __name__ == "__main__":
    app = IrajuInstaller()
    app.connect("destroy", Gtk.main_quit)
    Gtk.main()
