-- DISABLED as nvim-tree.lua is kicking in on VimEnter
return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	enabled = false,
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			" ██╗  ██╗██╗    ██╗███████╗ ",
			" ██║ ██╔╝██║    ██║██╔════╝ ",
			" █████╔╝ ██║ █╗ ██║███████╗ ",
			" ██╔═██╗ ██║███╗██║╚════██║ ",
			" ██║  ██╗╚███╔███╔╝███████║ ",
			" ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝ ",
		}
		dashboard.section.footer.val = {
			"  1985-2024 Kai Walter Software",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  ... New File", "<cmd>ene<CR>"),
			dashboard.button("SPC fb", "󱁴  ... Browse Files", "<cmd>Telescope file_browser<CR>"),
			dashboard.button("SPC ff", "󰱼  ... Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", "  ... Find String", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("q", "  ... Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
