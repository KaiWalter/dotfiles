return {
	"KaiWalter/azure-functions.nvim",
	dev = true,
	enabled = function()
		return not IsCorporate()
	end,
	config = function()
		require("azure-functions").setup({
			compress_log = true,
		})
	end,
}
