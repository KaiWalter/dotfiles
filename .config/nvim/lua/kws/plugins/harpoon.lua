return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		MapN("<leader>ha", mark.add_file, "add file to worklist")
		MapN("<leader>hr", mark.rm_file, "remove file from worklist")
		MapN("<leader>ht", ui.toggle_quick_menu, "show worklist")

		for i = 1, 9 do
			local keysetting = "<leader>h" .. i
			local description = "switch to workspace " .. i
			MapN(keysetting, function()
				ui.nav_file(i)
			end, description)
		end
	end,
}
