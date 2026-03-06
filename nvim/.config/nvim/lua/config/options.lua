-- Mouse completo
vim.opt.mouse          = "a"
vim.opt.mousemoveevent = true

-- Visual
vim.opt.termguicolors  = true
vim.opt.cursorline     = true
vim.opt.signcolumn     = "yes"
vim.opt.numberwidth    = 3
vim.opt.scrolloff      = 8
vim.opt.sidescrolloff  = 8

-- Transparência (usa o blur do Hyprland)
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Indentação
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.expandtab   = true
vim.opt.smartindent = true
vim.opt.clipboard   = "unnamedplus"
