return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-telescope/telescope-project.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-frecency.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")

    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function()
        trouble.toggle("quickfix")
      end,
    })

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-t>"] = trouble_telescope.open,
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("projects")
    telescope.load_extension("file_browser")
    telescope.load_extension("frecency")
    MapN("<leader>ff", builtin.find_files, "[F]ind [F]iles")
    MapN("<leader>fh", builtin.help_tags, "[F]ile [H]elp Tags")
    MapN("<leader>fg", builtin.git_files, "[F]ind Files [G]IT")
    MapN("<leader>fs", builtin.live_grep, "[F]ind [S]tring")
    MapN("<leader>fc", builtin.grep_string, "[F]ind string under [C]ursor")
    MapN("<leader>fnc", function()
      require("telescope.builtin").find_files({
        cwd = vim.fn.stdpath("config"),
      })
    end, "[F]ind [N]eoVim [C]onfig")
    MapN("<leader>fnl", function()
      require("telescope.builtin").find_files({
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
      })
    end, "[F]ind [N]eoVim [L]azy config")
    MapN("<leader>fr", "<cmd>Telescope frecency workspace=CWD<CR>", "Frequent")
    MapN("<leader>fp", "<cmd>Telescope projects<CR>", "[P]rojects")
    MapN("<leader>fb", "<cmd>Telescope file_browser<CR>", "[F]ile [B]rowser")
    MapN("<leader>ft", "<cmd>Telescope TodoTelescope<CR>", "[F]ile [B]rowser")
  end,
}
