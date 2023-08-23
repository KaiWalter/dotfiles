local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
lsp.default_keymaps({buffer = bufnr})
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
    ['lua_ls'] = {'lua'},
  }
})

lsp.setup()
