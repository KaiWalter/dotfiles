-- https://github.com/ThePrimeagen/harpoon

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<C-h>a", mark.add_file, { desc = "add file to worklist" })
vim.keymap.set("n", "<C-h>r", mark.rm_file, { desc = "remove file from worklist" })
vim.keymap.set("n", "<C-h>t", ui.toggle_quick_menu, { desc = "show worklist" })

for i=1,9 do
  keysetting = "<C-h>" .. i
  description = "switch to workspace " .. i
  vim.keymap.set("n", keysetting, function() ui.nav_file(i) end, { desc = description } )
end
