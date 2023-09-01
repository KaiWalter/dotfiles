-- https://aaronbos.dev/posts/debugging-csharp-neovim-nvim-dap
local dap, dapui, daputils = require("dap"), require("dapui"), require("dap.utils")

-- dap.set_log_level('DEBUG')

dap.adapters.coreclr = {
  type = 'executable',
  command = '/usr/local/netcoredbg',
  args = { '--interpreter=vscode' },
}

-- https://github.com/mfussenegger/nvim-dap/wiki/Cookbook#making-debugging-net-easier
vim.g.dotnet_build_project = function()
  local default_path = vim.fn.getcwd() .. '/'
  if vim.g['dotnet_last_proj_path'] ~= nil then
    default_path = vim.g['dotnet_last_proj_path']
  end
  local path = vim.fn.input('Path to your *proj file', default_path, 'file')
  vim.g['dotnet_last_proj_path'] = path
  local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
  print('')
  print('Cmd to execute: ' .. cmd)
  local f = os.execute(cmd)
  if f == 0 then
    print('\nBuild: ✔️ ')
  else
    print('\nBuild: ❌ (code: ' .. f .. ')')
  end
end

vim.g.dotnet_get_dll_path = function()
  local request = function()
    return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
  end

  if vim.g['dotnet_last_dll_path'] == nil then
    vim.g['dotnet_last_dll_path'] = request()
  else
    if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
      vim.g['dotnet_last_dll_path'] = request()
    end
  end

  return vim.g['dotnet_last_dll_path']
end

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch .NET",
    request = "launch",
    -- program = function()
    --   return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    -- end,
    program = function()
      if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
        vim.g.dotnet_build_project()
      end
      return vim.g.dotnet_get_dll_path()
    end,
  },
  {
    type = "coreclr",
    name = "attach .NET",
    request = "attach",
    processId = daputils.pick_process,
  },
}

dapui.setup()
-- require("nvim-dap-virtual-text").setup()

mapn("<F5>", dap.continue, "Debug continue")
mapn("<F9>", dap.toggle_breakpoint, "Debug set breakpoint")
mapn("<F10>", dap.step_over, "Debug step over")
mapn("<F11>", dap.step_into, "Debug step into")
mapn("<F12>", dap.step_out, "Debug step out")
mapn("<leader>dg", dapui.toggle, "Toggle DAP UI")
mapn("<leader>dee", dapui.eval, "Debug eval")
mapn("<leader>dea", dapui.elements.watches.add, "Debug add expression to watch")

vim.fn.sign_define('DapBreakpoint',
  { text = ' ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
