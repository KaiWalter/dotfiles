return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    focus = true,
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>ddx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "open diagnostics",
    },
    {
      "<leader>ddw",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "open workspace diagnostics",
    },
    {
      "<leader>dds",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "open symbols list",
    },
    {
      "<leader>ddq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "open quickfix list",
    },
    {
      "<leader>ddl",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "open location list",
    },
  },
}
