vim.g.mapleader = " "

local keymap = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }
keymap("v", "<leader>c", '"+y', options)
keymap("n", "<leader>v", '"+p', options)
