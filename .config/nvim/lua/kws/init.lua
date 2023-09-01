-- Samples:
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

-- for NevimTree : disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- install Packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

require('kws.utils')
require('kws.packer')

if is_bootstrap then
  require('packer').sync()
  print '==========================='
  print 'Plugins are being installed'
  print '==========================='
  return
end

require('kws.remap')
