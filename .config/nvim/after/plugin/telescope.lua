pcall(require('telescope').load_extension, 'fzf')

local builtin = require('telescope.builtin')
mapn('<leader>ff', builtin.find_files, "Find Files")
mapn('<leader>fh', builtin.oldfiles, "Recently Opened Files")
mapn('<leader>fg', builtin.git_files, "Find Files GIT")
mapn('<leader>fs', function()
  builtin.grep_string({ shorten_path = true, search = vim.fn.input("rg> ") });
end, "Find String with Grep (ripgrep must be installed)")
