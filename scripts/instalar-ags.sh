#!/usr/bin/env bash
# ╔══════════════════════════════════════════╗
# ║       INSTALAR AGS DASHBOARD             ║
# ║       IrajuArch OS · proftiago           ║
# ╚══════════════════════════════════════════╝

GREEN="\033[38;2;166;227;161m"
BLUE="\033[38;2;137;180;250m"
PEACH="\033[38;2;250;179;135m"
BOLD="\033[1m"
RESET="\033[0m"
ok() { echo -e "  ${GREEN}✓${RESET} $1"; }
info() { echo -e "  ${BLUE}→${RESET} $1"; }

echo -e "\n${BOLD}󰣇  AGS Dashboard · IrajuArch OS${RESET}\n"

# ── 1. Instalar AGS ────────────────────────
info "Instalando AGS..."
yay -S --needed ags
ok "AGS instalado"

# ── 2. Criar estrutura ─────────────────────
mkdir -p ~/.config/ags/widgets
mkdir -p ~/.config/matugen/templates
ok "Diretórios criados"

# ══════════════════════════════════════════
# 3. TEMPLATE MATUGEN → cores do AGS
# ══════════════════════════════════════════
cat >~/.config/matugen/templates/ags-colors.css <<'MATUGEN_EOF'
/* Gerado pelo matugen — não editar manualmente */
@define-color primary #{{colors.primary.default.hex}};
@define-color on_primary #{{colors.on_primary.default.hex}};
@define-color primary_container #{{colors.primary_container.default.hex}};
@define-color secondary #{{colors.secondary.default.hex}};
@define-color on_secondary #{{colors.on_secondary.default.hex}};
@define-color surface #{{colors.surface.default.hex}};
@define-color surface_container #{{colors.surface_container.default.hex}};
@define-color surface_container_high #{{colors.surface_container_high.default.hex}};
@define-color on_surface #{{colors.on_surface.default.hex}};
@define-color on_surface_variant #{{colors.on_surface_variant.default.hex}};
@define-color outline #{{colors.outline.default.hex}};
@define-color outline_variant #{{colors.outline_variant.default.hex}};
MATUGEN_EOF
ok "Template matugen criado"

# Adicionar ao config.toml do matugen
if ! grep -q "\[templates.ags-colors\]" ~/.config/matugen/config.toml 2>/dev/null; then
    cat >>~/.config/matugen/config.toml <<'TOML_EOF'

[templates.ags-colors]
input_path = '~/.config/matugen/templates/ags-colors.css'
output_path = '~/.config/ags/colors.css'
TOML_EOF
    ok "Adicionado ao matugen config.toml"
else
    ok "Matugen config.toml já configurado"
fi

# ══════════════════════════════════════════
# 4. APP.JS — entry point
# ══════════════════════════════════════════
cat >~/.config/ags/app.js <<'APP_EOF'
import App from 'resource:///com/github/Aylur/ags/app.js'
import Dashboard from './widgets/Dashboard.js'

App.config({
    style: App.configDir + '/style.css',
    windows: [Dashboard()],
    closeWindowDelay: { 'dashboard': 150 },
})

export default App
APP_EOF
ok "app.js criado"

# ══════════════════════════════════════════
# 5. DASHBOARD.JS — widgets
# ══════════════════════════════════════════
cat >~/.config/ags/widgets/Dashboard.js <<'DASH_EOF'
import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Variable from 'resource:///com/github/Aylur/ags/variable.js'

// ── Variáveis dinâmicas ─────────────────────
const clock   = Variable('', { poll: [1000,    'date "+%H:%M"'] })
const dateStr = Variable('', { poll: [60000,   'date "+%A, %d de %B de %Y"'] })
const weather = Variable('...', {
    poll: [1800000, 'curl -sf "wttr.in/Rio+de+Janeiro?format=%c+%t"'],
})

const parseKhal = out => {
    if (!out || out.includes('No events')) return []
    return out.split('\n')
        .filter(l => /^\d{2}:\d{2}/.test(l))
        .map(l => ({
            time:  l.match(/^(\d{2}:\d{2})/)?.[1] || '',
            title: l.replace(/^\d{2}:\d{2}(-\d{2}:\d{2})?\s*/, '').trim(),
        }))
}

const agenda = Variable([], {
    poll: [60000, 'khal list today today 2>/dev/null', parseKhal],
})

// ── Relógio ─────────────────────────────────
const ClockWidget = () => Widget.Box({
    class_name: 'clock-box',
    vertical: true,
    hpack: 'center',
    children: [
        Widget.Label({ class_name: 'clock-time', label: clock.bind() }),
        Widget.Label({ class_name: 'clock-date', label: dateStr.bind() }),
    ],
})

// ── Clima ────────────────────────────────────
const WeatherWidget = () => Widget.Box({
    class_name: 'weather-box',
    hpack: 'center',
    children: [
        Widget.Label({ class_name: 'weather-label', label: weather.bind() }),
    ],
})

// ── Item de agenda ───────────────────────────
const AgendaItem = ({ time, title }) => Widget.Box({
    class_name: 'agenda-item',
    spacing: 12,
    children: [
        Widget.Label({ class_name: 'agenda-time', label: time }),
        Widget.Label({
            class_name: 'agenda-title',
            label: title,
            xalign: 0,
            truncate: 'end',
            max_width_chars: 22,
        }),
    ],
})

// ── Agenda ───────────────────────────────────
const AgendaWidget = () => Widget.Box({
    class_name: 'section-box',
    vertical: true,
    spacing: 6,
    children: [
        Widget.Label({ class_name: 'section-title', label: '󰃭  AULAS DE HOJE', xalign: 0 }),
        Widget.Box({
            vertical: true, spacing: 4,
            children: agenda.bind().as(items =>
                items.length === 0
                    ? [Widget.Label({ class_name: 'empty-label', label: 'Nenhuma aula agendada', xalign: 0 })]
                    : items.map(AgendaItem)
            ),
        }),
    ],
})

// ── Alunos ───────────────────────────────────
const StudentsWidget = () => Widget.Box({
    class_name: 'section-box',
    vertical: true,
    spacing: 6,
    children: [
        Widget.Label({ class_name: 'section-title', label: '󰋋  ALUNOS DE HOJE', xalign: 0 }),
        Widget.Box({
            vertical: true, spacing: 4,
            children: agenda.bind().as(items => {
                const names = [...new Set(items.map(i => i.title))]
                return names.length === 0
                    ? [Widget.Label({ class_name: 'empty-label', label: 'Nenhum aluno hoje', xalign: 0 })]
                    : names.map(n => Widget.Label({
                        class_name: 'student-item',
                        label: `  ${n}`,
                        xalign: 0,
                    }))
            }),
        }),
    ],
})

// ── Janela principal ─────────────────────────
export default () => Widget.Window({
    name: 'dashboard',
    class_name: 'dashboard',
    anchor: ['top', 'right'],
    margins: [56, 12, 0, 0],
    exclusivity: 'ignore',
    visible: false,
    layer: 'overlay',
    child: Widget.Box({
        class_name: 'dashboard-container',
        vertical: true,
        spacing: 14,
        children: [
            ClockWidget(),
            WeatherWidget(),
            Widget.Separator({ class_name: 'dash-sep' }),
            AgendaWidget(),
            Widget.Separator({ class_name: 'dash-sep' }),
            StudentsWidget(),
        ],
    }),
})
DASH_EOF
ok "Dashboard.js criado"

# ══════════════════════════════════════════
# 6. STYLE.CSS — tema dinâmico matugen
# ══════════════════════════════════════════
cat >~/.config/ags/style.css <<'CSS_EOF'
@import 'colors.css';

* {
    font-family: 'JetBrainsMono Nerd Font', monospace;
    font-size: 13px;
    color: @on_surface;
}

.dashboard { background: transparent; }

.dashboard-container {
    background: alpha(@surface_container, 0.88);
    border: 1px solid alpha(@outline_variant, 0.4);
    border-radius: 16px;
    padding: 22px 20px;
    min-width: 295px;
}

/* ── Relógio ── */
.clock-time {
    font-size: 54px;
    font-weight: bold;
    color: @primary;
    letter-spacing: -2px;
}
.clock-date {
    font-size: 12px;
    color: @on_surface_variant;
    margin-top: -4px;
}

/* ── Clima ── */
.weather-label {
    font-size: 14px;
    color: @secondary;
    margin-top: 2px;
}

/* ── Separador ── */
.dash-sep {
    background: alpha(@outline_variant, 0.3);
    min-height: 1px;
    margin: 2px 0;
}

/* ── Títulos de seção ── */
.section-title {
    font-size: 10px;
    font-weight: bold;
    color: @primary;
    letter-spacing: 1px;
    margin-bottom: 2px;
}

/* ── Agenda ── */
.agenda-time {
    font-size: 12px;
    font-weight: bold;
    color: @primary;
    min-width: 44px;
}
.agenda-title {
    font-size: 13px;
    color: @on_surface;
}

/* ── Alunos ── */
.student-item {
    font-size: 13px;
    color: @on_surface_variant;
}

/* ── Vazio ── */
.empty-label {
    font-size: 12px;
    color: alpha(@on_surface, 0.4);
    font-style: italic;
}
CSS_EOF
ok "style.css criado"

# ══════════════════════════════════════════
# 7. GERAR CORES INICIAIS
# ══════════════════════════════════════════
info "Gerando colors.css via matugen..."
WALL=$(cat ~/.current_wallpaper 2>/dev/null)
if [[ -n "$WALL" && -f "$WALL" ]]; then
    matugen image "$WALL" 2>/dev/null && ok "colors.css gerado"
else
    echo -e "  ${PEACH}⚠ Wallpaper não encontrado — rode matugen manualmente depois${RESET}"
fi

# ══════════════════════════════════════════
# 8. RESUMO — passos manuais
# ══════════════════════════════════════════
echo
echo -e "${BOLD}${BLUE}  Passos manuais restantes:${RESET}"
echo
echo -e "  ${BOLD}1. ~/.config/hypr/hyprland.conf${RESET}"
echo "     exec-once = ags"
echo "     bind = SUPER, W, exec, ags -t dashboard"
echo "     layerrule = blur, gtk-layer-shell"
echo "     layerrule = ignorezero, gtk-layer-shell"
echo
echo -e "  ${BOLD}2. ~/scripts/wallpaper.sh${RESET} — adicionar após matugen:"
echo "     ags --run-js 'App.resetCss(); App.applyCss(App.configDir + \"/style.css\")' 2>/dev/null || true"
echo
echo -e "  ${BOLD}3. Testar:${RESET}"
echo "     ags"
echo
echo -e "${GREEN}${BOLD}  ✓ AGS instalado com sucesso!${RESET}"
echo -e "  Use ${BOLD}SUPER+W${RESET} para abrir/fechar o dashboard.\n"
