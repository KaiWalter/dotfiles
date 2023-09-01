pcall(require('telescope').load_extension, 'fzf')

local telescope = require('telescope.builtin')
mapn('<leader>ff', telescope.find_files, "[F]ind [F]iles")
mapn('<leader>fh', telescope.oldfiles, "[F]ile [H]istory")
mapn('<leader>fg', telescope.git_files, "[F]ind Files [G]IT")
mapn('<leader>fs', function()
  telescope.grep_string({ shorten_path = true, search = vim.fn.input("rg> ") });
end, "[F]ind [S]tring with Grep")
