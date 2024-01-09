local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set("n", "<C-t>", api.tree.change_root_to_node, opts("change root"))
	-- MapN("#", api.tree.change_root, "set root", bufnr)
end

return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- change color for arrows in tree to light blue
		vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

		-- configure nvim-tree
		nvimtree.setup({
			on_attach = my_on_attach,
			view = {
				width = 35,
				relativenumber = true,
			},
			-- change folder arrow icons
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							-- arrow_closed = '', -- arrow when folder is closed
							-- arrow_open = '', -- arrow when folder is open
						},
					},
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
		})

		MapN("<leader>ee", "<cmd>NvimTreeToggle<CR>", "Toggle file explorer") -- toggle file explorer
		MapN("<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", "Toggle file explorer on current file") -- toggle file explorer on current file
		MapN("<leader>ec", "<cmd>NvimTreeCollapse<CR>", "Collapse file explorer") -- collapse file explorer
		MapN("<leader>er", "<cmd>NvimTreeRefresh<CR>", "Refresh file explorer") -- refresh file explorer
	end,
}
