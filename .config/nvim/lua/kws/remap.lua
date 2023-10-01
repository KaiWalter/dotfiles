-- leader key general structure
-- level 1
-- b = buffer
-- d = debugging (DAP)
-- e = NvimTree (Explorer)
-- f = find something (with Telescope)
-- g = go somewhere (navigation)
-- h = Harpoon
-- i = Icon picker
-- l = Linting
-- o = object under cursor (Treesitter)
-- r = Rest
-- s = Style / Formatting
-- x = general operations
MapN("<leader>bh", ":nohlsearch<CR>", "clear search [B]uffer [H]ighlighting")
MapN("<leader><leader>b", "<cmd>Telescope buffers<CR>", "[B]uffers")
MapN("<leader>bn", "<cmd>bnext<CR>", "[B]uffer [N]ext")
MapN("<leader>bp", "<cmd>bprev<CR>", "[B]uffer [P]revious")
