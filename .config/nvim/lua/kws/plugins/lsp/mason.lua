return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local servers = {
			"tsserver",
			"omnisharp",
			"lua_ls",
			"marksman",
		}

		if IsCorporate() then
			table.insert(servers, "powershell_es")
		end

		local stylers = {
			"prettier", -- ts/js formatter
			"stylua", -- lua formatter
			"eslint_d", -- ts/js linter
			"isort",
			"black",
		}

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = servers,
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		mason_tool_installer.setup({
			-- list of formatters & linters for mason to install
			ensure_installed = stylers,
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true,
		})
	end,
}
