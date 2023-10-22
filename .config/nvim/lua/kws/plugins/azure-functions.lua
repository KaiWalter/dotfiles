return {
	"KaiWalter/azure-functions.nvim",
	dev = true,
	config = function()
		require("azure-functions").setup({
			compress_log = true,
		})
	end,
}
