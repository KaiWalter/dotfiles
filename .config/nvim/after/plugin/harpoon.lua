-- https://github.com/ThePrimeagen/harpoon

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

mapn("<C-h>a", mark.add_file, "add file to worklist")
mapn("<C-h>r", mark.rm_file, "remove file from worklist")
mapn("<C-h>t", ui.toggle_quick_menu, "show worklist")

for i = 1, 9 do
  keysetting = "<C-h>" .. i
  description = "switch to workspace " .. i
  mapn(keysetting, function() ui.nav_file(i) end, description)
end
