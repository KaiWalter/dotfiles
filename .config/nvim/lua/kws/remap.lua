vim.g.mapleader = " "
vim.g.maplocalleader = " "

mapv("<leader>y", '"+y', "[Y]ank to system clipboard")
mapn("<leader>p", '"+p', "[P]aste from system clipboard")
mapn("<leader>h", ':nohlsearch<CR>', "clear search [H]ighlighting")
