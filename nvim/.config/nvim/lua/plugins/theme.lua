local ok, c = pcall(require, "config.matugen_colors")
if not ok then
  c = {
    primary         = "#cba6f7",
    on_primary      = "#1e1e2e",
    secondary       = "#89b4fa",
    on_secondary    = "#1e1e2e",
    tertiary        = "#94e2d5",
    surface         = "#1e1e2e",
    surface_variant = "#313244",
    on_surface      = "#cdd6f4",
    on_surface_var  = "#bac2de",
    background      = "#181825",
    outline         = "#45475a",
    error           = "#f38ba8",
  }
end

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        transparent    = true,
        terminalColors = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg            = c.surface,
                bg_gutter     = c.surface_variant,
                fg            = c.on_surface,
                special       = c.primary,
                nontext       = c.outline,
                whitespace    = c.outline,
              }
            }
          }
        },
        overrides = function()
          return {
            Normal          = { bg = "none" },
            NormalNC        = { bg = "none" },
            NormalFloat     = { bg = c.surface_variant },
            FloatBorder     = { fg = c.outline, bg = "none" },
            CursorLine      = { bg = c.surface_variant },
            Visual          = { bg = c.surface_variant },
            Search          = { fg = c.on_primary, bg = c.primary },
            IncSearch       = { fg = c.on_primary, bg = c.secondary },
            Comment         = { fg = c.outline, italic = true },
            String          = { fg = c.tertiary },
            Function        = { fg = c.primary, bold = true },
            Keyword         = { fg = c.secondary, italic = true },
            Type            = { fg = c.tertiary },
            Constant        = { fg = c.error },
            -- Dashboard
            DashboardHeader = { fg = c.primary, bold = true },
            DashboardFooter = { fg = c.outline },
            -- Telescope
            TelescopeBorder          = { fg = c.outline, bg = "none" },
            TelescopeNormal          = { bg = "none" },
            TelescopeSelection       = { bg = c.surface_variant },
            TelescopeSelectionCaret  = { fg = c.primary },
          }
        end,
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
