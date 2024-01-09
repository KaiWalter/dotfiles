return {
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		cond = function()
			return os.getenv("OPENAI_API_KEY")
		end,
		config = function()
			require("chatgpt").setup()
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}
