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
			{ "<leader><leader>y", "<cmd>IconPickerYank<cr>", desc = "[Y]ank icon" },
			{ "<C-i>", "<cmd>IconPickerInsert<cr>", desc = "insert [I]con", mode = "i" },
		},
	},

	-- {
	-- 	"vhyrro/luarocks.nvim",
	-- 	priority = 1000,
	-- 	config = true,
	-- },
	-- {
	-- 	"rest-nvim/rest.nvim",
	-- 	dependencies = {
	-- 		"luarocks.nvim",
	-- 	},
	-- 	ft = "http",
	-- 	cond = function()
	-- 		return not IsWindows()
	-- 	end,
	-- 	config = function()
	-- 		local rest = require("rest-nvim")
	-- 		rest.setup()
	-- 		MapN("<leader>rr", rest.run, "[R]est [R]un")
	-- 		MapN("<leader>rl", rest.last, "[R]est [L]ast run")
	-- 	end,
	-- },

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
			{ "<leader>xg", ":LazyGit<CR>", desc = "Lazy[G]it" },
		},
	},
}
