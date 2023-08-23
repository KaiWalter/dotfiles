local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end)

lsp.ensure_installed({
  'csharp_ls',
  'bicep',
  'lua_ls'
})

lsp.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['lua_ls'] = { 'lua' },
  }
})

lsp.setup()

local keymap = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }
keymap("n", "<leader>fd", "<ESC>:LspZeroFormat<CR>", options)
