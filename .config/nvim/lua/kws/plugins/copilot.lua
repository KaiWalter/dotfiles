return {
	{
		"github/copilot.vim",
		config = function()
			vim.g.copilot_filetypes = {
				["*"] = false,
				csharp = true,
				go = true,
				javascript = true,
				javascriptreact = true,
				python = true,
				rust = true,
				typescript = true,
				typescriptreact = true,
			}
			vim.cmd([[ highlight CopilotSuggestion guifg=#FFFFFF guibg=#555555 ctermfg=8 ]])
		end,
	},
}
