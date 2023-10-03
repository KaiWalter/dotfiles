return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"<leader>dx",
			function()
				require("trouble").open()
			end,
			desc = "open diagnostics",
		},
		{
			"<leader>dw",
			function()
				require("trouble").open("workspace_diagnostics")
			end,
			desc = "open workspace diagnostics",
		},
		{
			"<leader>dd",
			function()
				require("trouble").open("document_diagnostics")
			end,
			desc = "open document diagnostics",
		},
		{
			"<leader>dq",
			function()
				require("trouble").open("quickfix")
			end,
			desc = "open quickfix list",
		},
		{
			"<leader>dl",
			function()
				require("trouble").open("loclist")
			end,
			desc = "open location list",
		},
	},
}
