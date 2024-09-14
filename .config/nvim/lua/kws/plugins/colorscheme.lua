return {
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    lazy = false,
    config = function()
      require("tokyonight").setup({
        style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        transparent = true, -- Enable this to disable setting the background color
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = false, -- dims inactive windows
        lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
      vim.cmd([[
        augroup user_colors
          autocmd!
          autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
        augroup END
        colorscheme tokyonight
      ]])
    end,
  },
}
