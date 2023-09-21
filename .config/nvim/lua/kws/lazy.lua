local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {

  {
    'folke/tokyonight.nvim',
    name = 'tokionight',
    config = function()
      vim.cmd('colorscheme tokyonight')
    end
  },

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.3',
    dependencies = {
      {
        'nvim-lua/plenary.nvim',
      },
      {
        'nvim-treesitter/nvim-treesitter',
        build = function()
          pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
      },
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      },
    }
  },

  'ThePrimeagen/harpoon',

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',
    }
  },

  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require("lualine").setup({
        options = {
          disabled_filetypes = {
            statusline = { 'NvimTree' },
            winbar = {},
          },
        },
        extensions = { 'nvim-tree', 'nvim-dap-ui' },
      })
    end
  },

  {
    'folke/which-key.nvim',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
    config = function()
      require("nvim-tree").setup()
    end
  },

  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        ignore = '^$',
      })
    end
  },

  'stevearc/dressing.nvim',

  {
    "ziontee113/icon-picker.nvim",
    config = function()
      require("icon-picker").setup({
        disable_legacy_commands = true
      })
    end,
  },

  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup()
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require("telescope").load_extension("lazygit")
      mapn("<leader>gg", ':LazyGit<CR>', "[G]oto Lazy[G]it")
    end,
  },

}

local opts = {}

require("lazy").setup(plugins, opts)
