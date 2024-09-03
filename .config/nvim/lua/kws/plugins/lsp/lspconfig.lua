return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {
      library = { plugins = { "nvim-dap-ui" }, types = true },
    } },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- local on_attach = function(client, bufnr)
    --   if Configuration.diagnostic_flow then
    --     vim.api.nvim_create_autocmd("CursorHold", {
    --       buffer = bufnr,
    --       callback = function()
    --         local opts = {
    --           focusable = false,
    --           close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    --           border = "rounded",
    --           source = "always",
    --           prefix = " ",
    --           scope = "cursor",
    --         }
    --         vim.diagnostic.open_float(nil, opts)
    --       end,
    --     })
    --   end
    -- end

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- LSP server configurations: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      -- setup other handlers only if server is installed
      ["omnisharp"] = function()
        -- configure omnisharp
        local omnisharp_bin = vim.fn.stdpath("data") .. "/mason/bin/omnisharp" .. (IsWindows() and ".cmd" or "")
        local pid = vim.fn.getpid()
        if FileExists(omnisharp_bin) then
          lspconfig["omnisharp"].setup({
            cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
            capabilities = capabilities,
          })
        end
      end,
      ["rust_analyzer"] = function()
        -- configure rust server with plugin
        local rustanalyzer_bin = vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" .. (IsWindows() and ".cmd" or "")
        if FileExists(rustanalyzer_bin) then
          lspconfig["rust_analyzer"].setup({
            capabilities = capabilities,
          })
        end
      end,
      ["bicep"] = function()
        -- configure bicep
        local bicep_bin = vim.fn.stdpath("data") .. "/mason/bin/bicep-lsp" .. (IsWindows() and ".cmd" or "")
        if FileExists(bicep_bin) then
          lspconfig["bicep"].setup({
            cmd = { bicep_bin },
            capabilities = capabilities,
          })
        end
      end,
      ["powershell_es"] = function()
        -- configure powershell_es
        local powershell_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/"
        if FolderExists(powershell_path) then
          lspconfig["powershell_es"].setup({
            bundle_path = powershell_path,
            capabilities = capabilities,
          })
        end
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files and plugins
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,
    })
  end,
}
