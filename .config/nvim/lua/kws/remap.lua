vim.g.mapleader = " "
vim.wo.relativenumber = true
vim.wo.number = true

local keymap = vim.api.nvim_set_keymap
local options = {noremap=true, silent=true}
keymap("v","<leader>c", '"+y', options)
keymap("n","<leader>v", '"+p', options)
keymap("n","<leader>u", "<ESC>:PackerSync<CR>", options)
keymap("n","<leader>f", "<ESC>:LspZeroFormat<CR>", options)

-- for NevimTree : disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local ft = require('Comment.ft')
ft({'bicep'}, '//%s')

