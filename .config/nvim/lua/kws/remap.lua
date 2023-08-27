vim.g.mapleader = " "
vim.g.maplocalleader = " "

mapv("<leader>c", '"+y', "yank to system clipboard")
mapn("<leader>v", '"+p', "paste from system clipboard")
mapn("<leader>uk", "<ESC>:Telescope keymaps<CR>", "Telescope keymaps")
