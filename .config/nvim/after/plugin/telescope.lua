local builtin = require('telescope.builtin')
mapn('<leader>ff', builtin.find_files, "Find Files")
mapn('<leader>fg', builtin.git_files, "Find Files GIT")
mapn('<leader>fs', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, "Find String with Grep (ripgrep must be installed)")
