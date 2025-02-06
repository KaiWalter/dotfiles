local slow_format_filetypes = {}
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        nix = { "nixfmt" },
        python = { "autopep8" },
      },
      format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        if not slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end

        return { lsp_fallback = true }
      end,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        if slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end

        local function on_format(err)
          if err and err:match("timeout$") then
            slow_format_filetypes[vim.bo[bufnr].filetype] = true
          end
        end

        return { timeout_ms = 200, lsp_fallback = true }, on_format
      end,
    })

    -- vim.keymap.set({ "n", "v" }, "<leader>s", function()
    -- 	conform.format({
    -- 		lsp_fallback = true,
    -- 		async = false,
    -- 		timeout_ms = 1000,
    -- 	})
    -- end, { desc = "[S]tyle/Format file or range (in visual mode)" })
  end,
}
