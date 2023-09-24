return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    MapN('<leader>ff', builtin.find_files, "[F]ind [F]iles")
    MapN('<leader>fh', builtin.oldfiles, "[F]ile [H]istory")
    MapN('<leader>fg', builtin.git_files, "[F]ind Files [G]IT")
    MapN('<leader>fs', builtin.live_grep, "[F]ind [S]tring")
    MapN('<leader>fc', builtin.grep_string, "[F]ind string under [C]ursor")
  end,
}
