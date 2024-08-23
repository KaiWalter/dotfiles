return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			"nvim-telescope/telescope-dap.nvim",
			"nvim-neotest/nvim-nio",
			"mfussenegger/nvim-dap-python",
      {
"kaiwalter/nvim-dap-vscode-js",
        branch = "fix-port-extraction",
      },
		},
		config = function()
			local dap, daputils = require("dap"), require("dap.utils")

			require("dap-python").setup()

			dap.set_log_level("DEBUG")

			-- C# / .NET
			dap.adapters.coreclr = {
				type = "executable",
				-- command = '/usr/local/netcoredbg',
				command = "netcoredbg",
				args = { "--interpreter=vscode" },
			}

			-- js-debug
      require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
   debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug-adapter", -- Path to vscode-js-debug installation.
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

for _, language in ipairs({ "typescript", "javascript" }) do
  require("dap").configurations[language] = {
          {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach",
    processId = require'dap.utils'.pick_process,
    cwd = "${workspaceFolder}",
  }
  }
end

			dap.adapters.jsdebug = {
				type = "executable",
				-- command = '/usr/local/netcoredbg',
				command = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug-adapter",
				args = {},
			}

			-- https://github.com/mfussenegger/nvim-dap/wiki/Cookbook#making-debugging-net-easier
			vim.g.dotnet_build_project = function()
				local default_path = vim.fn.getcwd() .. "/"
				if vim.g["dotnet_last_proj_path"] ~= nil then
					default_path = vim.g["dotnet_last_proj_path"]
				end
				local path = vim.fn.input("Path to your *proj file", default_path, "file")
				vim.g["dotnet_last_proj_path"] = path
				local cmd = "dotnet build -c Debug " .. path .. " > /dev/null"
				print("")
				print("Cmd to execute: " .. cmd)
				local f = os.execute(cmd)
				if f == 0 then
					print("\nBuild: ✔️ ")
				else
					print("\nBuild: ❌ (code: " .. f .. ")")
				end
			end

			vim.g.dotnet_get_dll_path = function()
				local request = function()
					return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
				end

				if vim.g["dotnet_last_dll_path"] == nil then
					vim.g["dotnet_last_dll_path"] = request()
				else
					if
						vim.fn.confirm(
							"Do you want to change the path to dll?\n" .. vim.g["dotnet_last_dll_path"],
							"&yes\n&no",
							2
						) == 1
					then
						vim.g["dotnet_last_dll_path"] = request()
					end
				end

				return vim.g["dotnet_last_dll_path"]
			end

			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Python File",
					program = "${file}",
				},
			}

			dap.configurations.javascript = {
				{
					type = "jsdebug",
					request = "launch",
					name = "JavaScript File",
					program = "${file}",
				},
			}

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch .NET",
					request = "launch",
					program = function()
						if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then
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
				{
					type = "coreclr",
					name = "attach to Azure Function",
					request = "attach",
					processId = function()
						local pid = nil
						while not pid do
							pid = require("azure-functions").get_process_id()
						end
						return pid
					end,
				},
			}

			-- keymappings
			MapN("<F5>", dap.continue, "Debug continue")
			MapN("<leader>dc", dap.continue, "Debug continue")
			MapN("<leader>dx", dap.close, "Debug stop")
			MapN("<F9>", dap.toggle_breakpoint, "Debug set breakpoint")
			MapN("<leader>dt", dap.toggle_breakpoint, "Debug set breakpoint")
			MapN("<F10>", dap.step_over, "Debug step over")
			MapN("<F11>", dap.step_into, "Debug step into")
			MapN("<F12>", dap.step_out, "Debug step out")

			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = " ", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
			)
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		config = function()
			local dapui = require("dapui")
			dapui.setup()

			MapN("<leader>dg", dapui.toggle, "[D]ebug [T]oggle DAP UI")
			MapN("<leader>dee", dapui.eval, "[D]ebug [E]xpression [E]val")
			MapN("<leader>dea", dapui.elements.watches.add, "[D]ebug [E]xpression [A]dd to watch")
		end,
	},
}
