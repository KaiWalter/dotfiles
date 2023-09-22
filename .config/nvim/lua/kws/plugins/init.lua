return {

  -- {
  --   'nvim-telescope/telescope.nvim',
  --   tag = '0.1.3',
  --   dependencies = {
  --     {
  --       'nvim-lua/plenary.nvim',
  --     },
  --     {
  --       'nvim-treesitter/nvim-treesitter',
  --       build = function()
  --         pcall(require('nvim-treesitter.install').update { with_sync = true })
  --       end,
  --     },
  --     {
  --       'nvim-treesitter/nvim-treesitter-textobjects',
  --     },
  --     {
  --       'nvim-telescope/telescope-fzf-native.nvim',
  --       build = 'make'
  --     },
  --   }
  -- },

  -- 'ThePrimeagen/harpoon',

  -- {
  --   'VonHeikemen/lsp-zero.nvim',
  --   branch = 'v2.x',
  --   dependencies = {
  --     -- LSP Support
  --     { 'neovim/nvim-lspconfig' },
  --     { 'williamboman/mason.nvim' },
  --     { 'williamboman/mason-lspconfig.nvim' },
  --
  --     -- Autocompletion
  --     { 'hrsh7th/nvim-cmp' },
  --     { 'hrsh7th/cmp-buffer' },
  --     { 'hrsh7th/cmp-path' },
  --     { 'saadparwaiz1/cmp_luasnip' },
  --     { 'hrsh7th/cmp-nvim-lsp' },
  --     { 'hrsh7th/cmp-nvim-lua' },
  --
  --     -- Snippets
  --     { 'L3MON4D3/LuaSnip' },
  --     { 'rafamadriz/friendly-snippets' },
  --
  --     -- Useful status updates for LSP
  --     'j-hui/fidget.nvim',
  --   }
  -- },

  {
    'ziontee113/icon-picker.nvim',
    config = function()
      require('icon-picker').setup({
        disable_legacy_commands = true,
      })
    end,
    keys = {
      { '<leader><leader>i', '<cmd>IconPickerNormal<cr>', desc = 'pick [I]con' },
      { '<C-i>',             '<cmd>IconPickerInsert<cr>', desc = 'insert [I]con', mode = 'i' },
    },
  },

  {
    'rest-nvim/rest.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    cond = function()
      return vim.loop.os_uname().sysname ~= 'Windows_NT'
    end,
    config = function()
      local rest = require('rest-nvim')
      rest.setup()
      mapn('<leader>rr', rest.run, '[R]est [R]un')
      mapn('<leader>rl', rest.last, '[R]est [L]ast run')
    end,
  },

  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('telescope').load_extension('lazygit')
    end,
    keys = {
      { '<leader>gg', ':LazyGit<CR>', desc = '[G]oto Lazy[G]it' },
    },
  },

}
