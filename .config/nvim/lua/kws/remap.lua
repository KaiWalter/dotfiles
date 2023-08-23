-- TODO: checkout https://dev.to/vonheikemen/make-lsp-zeronvim-coexists-with-other-plugins-instead-of-controlling-them-2i80

vim.g.mapleader = " "

local keymap = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }
keymap("v", "<leader>c", '"+y', options)
keymap("n", "<leader>v", '"+p', options)
keymap("n", "<leader>u", "<ESC>:PackerSync<CR>", options)
keymap("n", "<leader>fd", "<ESC>:LspZeroFormat<CR>", options)
