-- ╔══════════════════════════════════════════════════╗
-- ║         KEYMAPS ESTILO WORD/EDITOR MODERNO       ║
-- ╚══════════════════════════════════════════════════╝

local map = vim.keymap.set

-- ── Clipboard ─────────────────────────────────────
map({ "n", "v" }, "<C-c>", '"+y', { desc = "Copiar" })
map({ "n", "v" }, "<C-x>", '"+d', { desc = "Recortar" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Colar" })
map("i", "<C-v>", "<C-r>+", { desc = "Colar (insert)" })

-- ── Selecionar tudo ───────────────────────────────
map({ "n", "i" }, "<C-a>", "<Esc>ggVG", { desc = "Selecionar tudo" })

-- ── Desfazer / Refazer ────────────────────────────
map({ "n", "i" }, "<C-z>", "<Esc>u", { desc = "Desfazer" })
map({ "n", "i" }, "<C-y>", "<Esc><C-r>", { desc = "Refazer" })

-- ── Salvar ────────────────────────────────────────
map({ "n", "i" }, "<C-s>", "<Esc>:w<CR>", { desc = "Salvar" })

-- ── Fechar ────────────────────────────────────────
map("n", "<C-w>", ":bd<CR>", { desc = "Fechar buffer" })
map("n", "<C-q>", ":q<CR>", { desc = "Fechar janela" })

-- ── Buscar ────────────────────────────────────────
map({ "n", "i" }, "<C-f>", "<Esc>/", { desc = "Buscar" })
map({ "n", "i" }, "<C-h>", "<Esc>:%s/", { desc = "Buscar e substituir" })

-- ── Mover linhas (Alt+seta) ───────────────────────
map("n", "<A-down>", ":m .+1<CR>==", { desc = "Mover linha abaixo" })
map("n", "<A-up>", ":m .-2<CR>==", { desc = "Mover linha acima" })
map("v", "<A-down>", ":m '>+1<CR>gv=gv", { desc = "Mover seleção abaixo" })
map("v", "<A-up>", ":m '<-2<CR>gv=gv", { desc = "Mover seleção a:cima" })

-- ── Duplicar linha (Ctrl+D estilo VSCode) ─────────
map({ "n", "i" }, "<C-d>", "<Esc>yyp", { desc = "Duplicar linha" })

-- ── Início / Fim de linha ─────────────────────────
map({ "n", "v", "i" }, "<Home>", "^", { desc = "Início da linha" })
map({ "n", "v", "i" }, "<End>", "$", { desc = "Fim da linha" })

-- ── Nova linha abaixo sem entrar em insert ────────
map("n", "<CR>", "o<Esc>", { desc = "Nova linha abaixo" })
