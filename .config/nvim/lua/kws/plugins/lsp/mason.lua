return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"jayp0521/mason-null-ls.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		-- import mason-null-ls
		local mason_null_ls = require("mason-null-ls")

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
			"csharp_ls",
			"lua_ls",
			"marksman",
		}

		local stylers = {
			"stylua", -- lua formatter
		}

		local computername = os.getenv("COMPUTERNAME") or os.getenv("HOSTNAME")
		if computername and string.sub(computername, 1, 2) == "ZO" then
			table.insert(servers, "powershell_es")
			table.insert(servers, "bicep")
		end

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = servers,
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		mason_null_ls.setup({
			-- list of formatters & linters for mason to install
			ensure_installed = stylers,
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true,
		})
	end,
}
