local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

Configuration = {
	-- colorscheme_plugin = "ellisonleao/gruvbox.nvim",
	-- colorscheme = "gruvbox",
	-- colorscheme_plugin = "bluz71/vim-nightfly-guicolors",
	-- colorscheme = "nightfly",
	colorscheme_plugin = "EdenEast/nightfox.nvim",
	colorscheme = "nightfox",
	diagnostic_flow = false,
}

require("lazy").setup({
	{ import = "kws.plugins" },
	{ import = "kws.plugins.lsp" },
}, {
	install = {
		colorscheme = { Configuration.colorscheme },
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
	dev = {
		path = "~/src",
		fallback = true,
	},
})
