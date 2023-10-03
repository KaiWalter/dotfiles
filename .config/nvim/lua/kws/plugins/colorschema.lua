return {
	{
		-- "bluz71/vim-nightfly-guicolors",
		-- "ellisonleao/gruvbox.nvim",
		"EdenEast/nightfox.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			-- vim.cmd([[colorscheme nightfly]])
			-- vim.cmd([[colorscheme gruvbox]])
			vim.cmd([[colorscheme nordfox]])
		end,
	},
}
