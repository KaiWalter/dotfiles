return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- import comment plugin safely
    local comment = require("Comment")
    local ft = require("Comment.ft")

    -- local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    -- enable comment
    comment.setup({
      -- for commenting tsx and jsx files
      -- pre_hook = ts_context_commentstring.create_pre_hook(),
    })

    ft.set("bicep", "//%s", "/*%s*/")
  end,
}
