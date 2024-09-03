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

    -- take from https://github.com/mason-org/mason-registry

    local servers = {
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
      table.insert(servers, "tsserver")
      table.insert(tools, "eslint_d") -- ts/js linter
    end

    if IsNixOS() then
    else
      table.insert(servers, "marksman")
      table.insert(servers, "lua_ls")
      table.insert(tools, "stylua")
    end

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = servers,
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
    })

    mason_tool_installer.setup({
      -- list of formatters & linters for mason to install
      ensure_installed = tools,
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true,
    })
  end,
}
