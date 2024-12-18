return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
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

    -- take from https://github.com/mason-org/mason-registry

    local servers = {
      "bashls",
      "omnisharp",
      "pyright",
    }

    local tools = {
      "prettier",
    }

    if IsCorporate() then
      table.insert(servers, "bicep")
      table.insert(servers, "powershell_es")
    else
      table.insert(servers, "rust_analyzer")
      table.insert(servers, "ts_ls")
      table.insert(tools, "eslint_d") -- ts/js linter
    end

    if IsNixOS() then
    else
      table.insert(servers, "marksman")
      table.insert(servers, "lua_ls")
      table.insert(tools, "stylua")
    end

    mason_lspconfig.setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = tools,
      automatic_installation = true,
    })
  end,
}
