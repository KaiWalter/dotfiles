vim.g.mapleader = " "

mapv("<leader>c", '"+y', "yank to system clipboard")
mapn("<leader>v", '"+p', "paste from system clipboard")
