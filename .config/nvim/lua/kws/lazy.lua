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

Configuration = {
  colorscheme_plugin = "folke/tokyonight.nvim",
  colorscheme = "tokyonight-night",
  diagnostic_flow = false,
}

require("lazy").setup({
  { import = "kws.plugins" },
  { import = "kws.plugins.lsp" },
}, {
  install = {
    colorscheme = { Configuration.colorscheme },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  dev = {
    path = "~/src",
    fallback = true,
  },
})
