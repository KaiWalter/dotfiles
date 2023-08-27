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

local telescope = require('telescope.builtin')

mapn('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
mapn('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

mapn('<leader>gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
mapn('<leader>gr', telescope.lsp_references, '[G]oto [R]eferences')
mapn('<leader>gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

mapn('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
