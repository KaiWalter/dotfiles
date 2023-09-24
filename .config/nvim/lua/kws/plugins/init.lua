return {

	{
		"ziontee113/icon-picker.nvim",
		config = function()
			require("icon-picker").setup({
				disable_legacy_commands = true,
			})
		end,
		keys = {
			{ "<leader><leader>i", "<cmd>IconPickerNormal<cr>", desc = "pick [I]con" },
			{ "<C-i>", "<cmd>IconPickerInsert<cr>", desc = "insert [I]con", mode = "i" },
		},
	},

	{
		"rest-nvim/rest.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cond = function()
			return not is_windows()
		end,
		config = function()
			local rest = require("rest-nvim")
			rest.setup()
			mapn("<leader>rr", rest.run, "[R]est [R]un")
			mapn("<leader>rl", rest.last, "[R]est [L]ast run")
		end,
	},

	{
		"kdheepak/lazygit.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").load_extension("lazygit")
		end,
		keys = {
			{ "<leader>gg", ":LazyGit<CR>", desc = "[G]oto Lazy[G]it" },
		},
	},
}
