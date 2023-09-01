vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.autoindent = true
vim.o.smartindent = true
vim.wo.relativenumber = true
vim.wo.number = true

if vim.fn.executable("wl-copy") == 1 then
  vim.g.clipboard = {
    name = "wl-clipboard (wsl)",
    copy = {
      ["+"] = 'wl-copy --foreground --type text/plain',
      ["*"] = 'wl-copy --foreground --primary --type text/plain',
    },
    paste = {
      ["+"] = (function()
        return vim.fn.systemlist('wl-paste --no-newline|sed -e "s/\r$//"', { '' }, 1) -- '1' keeps empty lines
      end),
      ["*"] = (function()
        return vim.fn.systemlist('wl-paste --primary --no-newline|sed -e "s/\r$//"', { '' }, 1)
      end),
    },
    cache_enabled = true
  }
end

local ft = require('Comment.ft')
ft({ 'bicep' }, '//%s')
