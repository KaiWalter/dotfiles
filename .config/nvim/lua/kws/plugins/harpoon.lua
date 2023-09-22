return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    mapn("<leader>ha", mark.add_file, "add file to worklist")
    mapn("<leader>hr", mark.rm_file, "remove file from worklist")
    mapn("<leader>ht", ui.toggle_quick_menu, "show worklist")

    for i = 1, 9 do
      keysetting = "<leader>h" .. i
      description = "switch to workspace " .. i
      mapn(keysetting, function() ui.nav_file(i) end, description)
    end
  end,
}
