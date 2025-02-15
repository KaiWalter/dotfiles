return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "bicep-lsp")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bicep = {},
      },
    },
  },
}
