-- https://aaronbos.dev/posts/debugging-csharp-neovim-nvim-dap
local dap, dapui = require("dap"), require("dapui")

dap.adapters.coreclr = {
  type = 'executable',
  command = '/usr/local/netcoredbg',
  args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}

dapui.setup()
require("nvim-dap-virtual-text").setup()

mapn("<F5>", dap.continue, "Debug continue")
mapn("<F9>", dap.toggle_breakpoint, "Debug set breakpoint")
mapn("<F10>", dap.step_over, "Debug step over")
mapn("<F11>", dap.step_into, "Debug step into")
mapn("<F12>", dap.step_out, "Debug step out")
mapn("<leader>dg", dapui.toggle, "Toggle DAP UI")
mapn("<leader>dee", dapui.eval, "Debug eval")
mapn("<leader>dea", dapui.elements.watches.add, "Debug add expression to watch")
