return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			"nvim-telescope/telescope-dap.nvim",
			-- "mxsdev/nvim-dap-vscode-js",
			-- {
			-- 	"microsoft/vscode-js-debug",
			-- 	build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
			-- },
		},
		config = function()
			local dap, daputils = require("dap"), require("dap.utils")

			-- dap.set_log_level("DEBUG")

			-- C# / .NET
			dap.adapters.coreclr = {
				type = "executable",
				-- command = '/usr/local/netcoredbg',
				command = "netcoredbg",
				args = { "--interpreter=vscode" },
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

			-- -- Node.js
			-- require("dap-vscode-js").setup({
			-- 	-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
			-- 	-- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
			-- 	debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
			-- 	-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
			-- 	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
			-- 	-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
			-- 	-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
			-- 	-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
			-- })
			-- for _, language in ipairs({ "typescript", "javascript" }) do
			-- 	require("dap").configurations[language] = {
			-- 		{
			-- 			type = "pwa-node",
			-- 			request = "launch",
			-- 			name = "Launch file",
			-- 			program = "${file}",
			-- 			cwd = "${workspaceFolder}",
			-- 		},
			-- 		{
			-- 			type = "pwa-node",
			-- 			request = "attach",
			-- 			name = "Attach",
			-- 			processId = daputils.pick_process,
			-- 			cwd = "${workspaceFolder}",
			-- 		},
			-- 	}
			-- end
			-- dap.adapters.node = {
			-- 	type = "server",
			-- 	host = "localhost",
			-- 	port = "${port}",
			-- 	executable = {
			-- 		command = "node",
			-- 		args = { os.getenv("HOME") .. "/.local/bin/js-debug/src/dapDebugServer.js", "${port}" },
			-- 	},
			-- }
			-- dap.adapters.node = {
			-- 	type = "executable",
			-- 	command = "node",
			-- 	args = { vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/src/dapDebugServer.ts" },
			-- 	-- args = { os.getenv("HOME") .. "/.local/bin/js-debug/src/dapDebugServer.js" },
			-- }
			--
			-- local exts = {
			-- 	"javascript",
			-- 	"typescript",
			-- 	"javascriptreact",
			-- 	"typescriptreact",
			-- }
			--
			-- for _, ext in ipairs(exts) do
			-- 	dap.configurations[ext] = {
			-- 		{
			-- 			type = "node",
			-- 			request = "launch",
			-- 			name = "Launch file " .. ext,
			-- 			program = "${file}",
			-- 			cwd = "${workspaceFolder}",
			-- 		},
			-- 		{
			-- 			type = "node",
			-- 			request = "attach",
			-- 			name = "Attach to Node.js " .. ext,
			-- 			processId = daputils.pick_process,
			-- 			sourceMaps = true,
			-- 			trace = true,
			-- 			port = 9222,
			-- 			cwd = "${workspaceFolder}",
			-- 		},
			-- 	}
			-- end

			-- keymappings
			MapN("<F5>", dap.continue, "Debug continue")
			MapN("<F9>", dap.toggle_breakpoint, "Debug set breakpoint")
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
