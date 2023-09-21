local lsp = require('lsp-zero').preset({})

local servers = {
  'csharp_ls',
  'lua_ls',
  'marksman'
}

local computername = os.getenv('COMPUTERNAME') or os.getenv('HOSTNAME')
if string.sub(computername, 1, 2) == 'ZO' then
  table.insert(servers, 'powershell_es')
  table.insert(servers, 'bicep')
end

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })

  local opts = { buffer = bufnr, desc = '[F]ormat [D]ocument' }
  vim.keymap.set({ 'n', 'x' }, 'fd', function()
    vim.lsp.buf.format({
      async = false,
      timeout_ms = 10000,
    })
  end, opts)
end)

lsp.ensure_installed(servers)

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
require 'lspconfig'.powershell_es.setup {}

local telescope = require('telescope.builtin')

mapn('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
mapn('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

mapn('<leader>gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
mapn('<leader>gr', telescope.lsp_references, '[G]oto [R]eferences')
mapn('<leader>gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

mapn('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
