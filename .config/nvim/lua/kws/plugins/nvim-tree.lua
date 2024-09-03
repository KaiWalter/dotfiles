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
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    {
      "ahmedkhalf/project.nvim",
      opts = {
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "Makefile", "package.json", ".stylua.toml" },
        silent_chdir = false,
      },
    },
  },
  config = function()
    local nvimtree = require("nvim-tree")

    nvimtree.setup({
      view = {
        width = 35,
        relativenumber = true,
      },
      disable_netrw = true,

      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
    })

    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      callback = open_nvim_tree,
    })

    MapN("<leader>ee", "<cmd>NvimTreeToggle<CR>", "Toggle file explorer") -- toggle file explorer
    MapN("<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", "Toggle file explorer on current file") -- toggle file explorer on current file
    MapN("<leader>ec", "<cmd>NvimTreeCollapse<CR>", "Collapse file explorer") -- collapse file explorer
    MapN("<leader>er", "<cmd>NvimTreeRefresh<CR>", "Refresh file explorer") -- refresh file explorer
  end,
}
