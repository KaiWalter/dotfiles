return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		local opts = { noremap = true, silent = true }
		local on_attach = function(client, bufnr)
			if Configuration.diagnostic_flow then
				vim.api.nvim_create_autocmd("CursorHold", {
					buffer = bufnr,
					callback = function()
						local opts = {
							focusable = false,
							close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
							border = "rounded",
							source = "always",
							prefix = " ",
							scope = "cursor",
						}
						vim.diagnostic.open_float(nil, opts)
					end,
				})
			end

			opts.buffer = bufnr

			-- set keybinds
			opts.desc = "Show LSP references"
			keymap.set("n", "<leader>gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

			opts.desc = "Go to declaration"
			keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts) -- go to declaration

			opts.desc = "Show LSP definitions"
			keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

			opts.desc = "Show LSP implementations"
			keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

			opts.desc = "Show LSP type definitions"
			keymap.set("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

			opts.desc = "See available code actions"
			keymap.set({ "n", "v" }, "<leader>gca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

			opts.desc = "Smart rename"
			keymap.set("n", "<leader>or", vim.lsp.buf.rename, opts) -- smart rename

			opts.desc = "Show buffer diagnostics/errors"
			keymap.set("n", "<leader>gE", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

			opts.desc = "Show line diagnostics/errors"
			keymap.set("n", "<leader>ge", vim.diagnostic.open_float, opts) -- show diagnostics for line

			opts.desc = "Go to previous diagnostic/error"
			keymap.set("n", "<leader>gne", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

			opts.desc = "Go to next diagnostic/error"
			keymap.set("n", "<leader>gpe", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "<leader>oK", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

			opts.desc = "Restart [L]SP"
			keymap.set("n", "<leader>xl", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- configure typescript server with plugin
		lspconfig["tsserver"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure omnisharp
		local omnisharp_bin = vim.fn.stdpath("data") .. "/mason/bin/omnisharp" .. (IsWindows() and ".cmd" or "")
		local pid = vim.fn.getpid()
		if FileExists(omnisharp_bin) then
			lspconfig["omnisharp"].setup({
				cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						checkThirdParty = false,
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		-- configure markdown server with plugin
		lspconfig["marksman"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure bicep
		local bicep_bin = vim.fn.stdpath("data") .. "/mason/bin/bicep-lsp" .. (IsWindows() and ".cmd" or "")
		if FileExists(bicep_bin) then
			lspconfig["bicep"].setup({
				cmd = { bicep_bin },
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end

		-- configure powershell_es
		local powershell_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/"
		if FolderExists(powershell_path) then
			lspconfig["powershell_es"].setup({
				bundle_path = powershell_path,
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end
	end,
}
