-- Samples:
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

-- for NevimTree : disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.autoindent = true
vim.o.smartindent = true
vim.wo.relativenumber = true
vim.wo.number = true

require('kws.utils')
require('kws.lazy')
require('kws.remap')
