return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-telescope/telescope-dap.nvim",
			"nvim-neotest/nvim-nio",
			-- DAP UI
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			-- Python
			{
				"mfussenegger/nvim-dap-python",
				config = function()
					require("dap-python").setup()
					local dap = require("dap")
					dap.configurations.python = {
						{
							type = "python",
							request = "launch",
							name = "Python File",
							program = "${file}",
						},
					}
				end,
			},
			-- JavaScript / TypeScript
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps --ignore-scripts && npx gulp vsDebugServerBundle && mv dist out",
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				config = function()
					require("dap-vscode-js").setup({
						debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
						adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
					})
					local dap = require("dap")
					for _, language in ipairs({ "typescript", "javascript" }) do
						dap.configurations[language] = {
							{
								type = "pwa-node",
								request = "launch",
								name = "Launch (" .. language .. ")",
								program = "${file}",
								cwd = "${workspaceFolder}",
							},
							{
								type = "pwa-node",
								request = "attach",
								name = "Attach (" .. language .. ")",
								processId = require("dap.utils").pick_process,
								cwd = "${workspaceFolder}",
							},
						}
					end
				end,
			},
			-- LUA
			-- https://youtu.be/47UGK4NgvC8
			-- https://github.com/MariaSolOs/dotfiles/blob/1a3cede5848c8158469989e71f5c80e0772ea730/.config/nvim/lua/plugins/dap.lua
			-- https://www.lazyvim.org/extras/dap/core
			{
				"jbyuki/one-small-step-for-vimkind",
				config = function()
					local dap = require("dap")
					dap.adapters.nlua = function(callback, conf)
						local adapter = {
							type = "server",
							host = conf.host or "127.0.0.1",
							port = conf.port or 8086,
						}
						if conf.start_neovim then
							local dap_run = dap.run
							dap.run = function(c)
								adapter.port = c.port
								adapter.host = c.host
							end
							require("osv").run_this()
							dap.run = dap_run
						end
						callback(adapter)
					end
					dap.configurations.lua = {
						{
							type = "nlua",
							request = "attach",
							name = "Run this file",
							start_neovim = {},
						},
						{
							type = "nlua",
							request = "attach",
							name = "Attach to running Neovim instance (port = 8086)",
							port = 8086,
						},
					}
				end,
			},
		},
		config = function()
			local dap, daputils = require("dap"), require("dap.utils")

			dap.set_log_level("TRACE")

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
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			-- Automatically open the UI when a new debug session is created.
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			MapN("<leader>dg", dapui.toggle, "[D]ebug [T]oggle DAP UI")
			MapN("<leader>dee", dapui.eval, "[D]ebug [E]xpression [E]val")
			MapN("<leader>dea", dapui.elements.watches.add, "[D]ebug [E]xpression [A]dd to watch")
		end,
	},
}
