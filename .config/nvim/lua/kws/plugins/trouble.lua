return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    focus = true,
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>dx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "open diagnostics",
    },
    {
      "<leader>dw",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "open workspace diagnostics",
    },
    {
      "<leader>ds",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "open symbols list",
    },
    {
      "<leader>dq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "open quickfix list",
    },
    {
      "<leader>dl",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "open location list",
    },
  },
}
