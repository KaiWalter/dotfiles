-- Samples:
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

-- for NevimTree : disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('kws.utils')
require('kws.packer')
require('kws.remap')
