return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():append()
    end)
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set("n", "<C-h>", function()
      harpoon:list():select(1)
    end)
    vim.keymap.set("n", "<C-t>", function()
      harpoon:list():select(2)
    end)
    vim.keymap.set("n", "<C-n>", function()
      harpoon:list():select(3)
    end)
    vim.keymap.set("n", "<C-s>", function()
      harpoon:list():select(4)
    end)

    MapN("<leader>ha", function()
      harpoon:list():append()
    end, "add file to worklist")
    MapN("<leader>hr", function()
      harpoon:list():remove()
    end, "remove file from worklist")
    MapN("<leader>ht", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, "show worklist")

    for i = 1, 9 do
      local keysetting = "<leader>h" .. i
      local description = "switch to workspace " .. i
      MapN(keysetting, function()
        harpoon:list():select(i)
      end, description)
    end
  end,
}
