-- leader key general structure
-- level 1
-- b = buffer
-- de = debugging (DAP)
-- dd = diagnostics
-- e = NvimTree (Explorer)
-- f = find something (with Telescope)
-- g = go somewhere (navigation)
-- h = Harpoon
-- i = Icon picker
-- l = Linting
-- o = object under cursor (Treesitter)
-- r = Rest
-- s = Window/Split operations
-- t = Tab operations
-- x = general operations

---@class vim.g
vim.g.mapleader = " "

-- miscellaneous
MapN("<leader><leader>x", "<cmd>source %<CR>", "source current file")
MapN("<leader>x", ":.lua<CR>")
MapV("<leader>x", ":lua<CR>")
MapN("<M-j>", "<cmd>cnext<CR>")
MapN("<M-k>", "<cmd>cprev<CR>")

-- clipboard
MapV("p", '"_dP', "") -- Paste over currently selected text without yanking it
MapN("<leader>p", '"+p')
MapV("<leader>y", '"+y')

-- b = buffer
MapN("<leader>bh", "<cmd>nohlsearch<CR>", "clear search [B]uffer [H]ighlighting")
MapN("<leader><leader>b", "<cmd>Telescope buffers<CR>", "[B]uffers")
MapN("<leader>bn", "<cmd>bnext<CR>", "[B]uffer [N]ext")
MapN("<leader>bd", "<cmd>bdelete<CR>", "[B]uffer [D]elete")
MapN("<C-PageDown>", "<cmd>bnext<CR>", "[B]uffer [N]ext")
MapN("<leader>bp", "<cmd>bprev<CR>", "[B]uffer [P]revious")
MapN("<C-PageUp>", "<cmd>bprev<CR>", "[B]uffer [P]revious")

-- t = Tab operations
MapN("<leader>to", "<cmd>tabnew<CR>", "Open new tab") -- open new tab
MapN("<leader>tx", "<cmd>tabclose<CR>", "Close current tab") -- close current tab
MapN("<leader>tn", "<cmd>tabn<CR>", "Go to next tab") --  go to next tab
MapN("<leader>tp", "<cmd>tabp<CR>", "Go to previous tab") --  go to previous tab
MapN("<leader>tf", "<cmd>tabnew %<CR>", "Open current buffer in new tab") --  move current buffer to new tab

-- window management
MapN("<leader>sv", "<C-w>v", "Split window vertically") -- split window vertically
MapN("<leader>sh", "<C-w>s", "Split window horizontally") -- split window horizontally
MapN("<leader>se", "<C-w>=", "Make splits equal size") -- make split windows equal width & height
MapN("<leader>sx", "<cmd>close<CR>", "Close current split") -- close current split window

-- Terminal
MapT("<esc><esc>", "<c-\\><c-n>", "exit terminal mode")
