return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			open_mapping = [[<c-#>]],
		})
		MapV("<leader>s", function()
			local trim_spaces = true
			require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
		end, "send to termimal")
	end,
}
