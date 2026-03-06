return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls        = {},  -- Lua
        pyright       = {},  -- Python
        ts_ls         = {},  -- TypeScript/JavaScript
        html          = {},  -- HTML
        cssls         = {},  -- CSS
        bashls        = {},  -- Bash/Shell
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "pyright",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "bash-language-server",
        "prettier",
        "stylua",
        "black",
        "shfmt",
      },
    },
  },
}
