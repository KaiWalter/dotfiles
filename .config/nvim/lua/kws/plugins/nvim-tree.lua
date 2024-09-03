-- local function my_on_attach(bufnr)
-- 	local api = require("nvim-tree.api")
--
-- 	local function opts(desc)
-- 		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
-- 	end
--
-- 	-- default mappings
-- 	api.config.mappings.default_on_attach(bufnr)
--
-- 	-- custom mappings
-- 	vim.keymap.set("n", "<C-t>", api.tree.change_root_to_node, opts("change root"))
-- 	-- MapN("#", api.tree.change_root, "set root", bufnr)
-- end

local function open_nvim_tree(data)
  ------------------------------------------------------------------------------------------

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- Will automatically open the tree when running setup if startup buffer is a directory,
  -- is empty or is unnamed. nvim-tree window will be focused.
  local open_on_setup = true

  if (directory or no_name) and open_on_setup then
    -- change to the directory
    if directory then
      vim.cmd.cd(data.file)
    end

    -- open the tree
    require("nvim-tree.api").tree.open()
    return
  end

  ------------------------------------------------------------------------------------------

  -- Will automatically open the tree when running setup if startup buffer is a file.
  -- File window will be focused.
  -- File will be found if updateFocusedFile is enabled.
  local open_on_setup_file = false

  -- buffer is a real file on the disk
  local real_file = vim.fn.filereadable(data.file) == 1

  if (real_file or no_name) and open_on_setup_file then
    -- skip ignored filetypes
    local filetype = vim.bo[data.buf].ft
    local ignored_filetypes = {}

    if not vim.tbl_contains(ignored_filetypes, filetype) then
      -- open the tree but don't focus it
      require("nvim-tree.api").tree.toggle({ focus = false })
      return
    end
  end

  ------------------------------------------------------------------------------------------

  -- Will ignore the buffer, when deciding to open the tree on setup.
  local ignore_buffer_on_setup = false
  if ignore_buffer_on_setup then
    require("nvim-tree.api").tree.open()
  end
end

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    local nvimtree = require("nvim-tree")

    nvimtree.setup({
      diagnostics = { enable = true, show_on_dirs = true, show_on_open_dirs = true },
      disable_netrw = true,
      hijack_directories = { auto_open = true },
      reload_on_bufenter = true,
      sync_root_with_cwd = true,
    })

    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      callback = open_nvim_tree,
    })

    -- -- recommended settings from nvim-tree documentation
    -- vim.g.loaded_netrw = 1
    -- vim.g.loaded_netrwPlugin = 1
    --
    -- -- change color for arrows in tree to light blue
    -- vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
    --
    -- -- configure nvim-tree
    -- nvimtree.setup({
    -- 	on_attach = my_on_attach,
    -- 	view = {
    -- 		width = 35,
    -- 		relativenumber = true,
    -- 	},
    -- 	-- change folder arrow icons
    -- 	renderer = {
    -- 		indent_markers = {
    -- 			enable = true,
    -- 		},
    -- 		icons = {
    -- 			glyphs = {
    -- 				folder = {
    -- 					-- arrow_closed = '', -- arrow when folder is closed
    -- 					-- arrow_open = '', -- arrow when folder is open
    -- 				},
    -- 			},
    -- 		},
    -- 	},
    -- 	-- disable window_picker for
    -- 	-- explorer to work well with
    -- 	-- window splits
    -- 	actions = {
    -- 		open_file = {
    -- 			window_picker = {
    -- 				enable = false,
    -- 			},
    -- 		},
    -- 	},
    -- 	filters = {
    -- 		custom = { ".DS_Store" },
    -- 	},
    -- 	git = {
    -- 		ignore = false,
    -- 	},
    -- })

    MapN("<leader>ee", "<cmd>NvimTreeToggle<CR>", "Toggle file explorer") -- toggle file explorer
    MapN("<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", "Toggle file explorer on current file") -- toggle file explorer on current file
    MapN("<leader>ec", "<cmd>NvimTreeCollapse<CR>", "Collapse file explorer") -- collapse file explorer
    MapN("<leader>er", "<cmd>NvimTreeRefresh<CR>", "Refresh file explorer") -- refresh file explorer
  end,
}
