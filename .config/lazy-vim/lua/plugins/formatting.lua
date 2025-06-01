return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      csharpier = {
        command = "csharpier",
        args = { "format", "." }, -- ✅ required command and path
        cwd = require("conform.util").root_file({
          ".csharpier.json",
          ".git",
        }),
        stdin = false,
      },
    },
    formatters_by_ft = {
      cs = { "csharpier" },
      nix = { "alejandra" },
      bicep = { "bicep-lsp" },
    },
  },
}
