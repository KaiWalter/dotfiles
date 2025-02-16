-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set

-- buffers
map("n", "<C-PageUp>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<C-PageDown>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

map("n", "<M-j>", "<cmd>cprev<cr>", { desc = "Previous Quickfix" })
map("n", "<M-k>", "<cmd>cnext<cr>", { desc = "Next Quickfix" })
