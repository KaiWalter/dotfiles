return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function()
    local dotnet = require("easy-dotnet")
    dotnet.setup()
    if dotnet.is_dotnet_project() then
      MapN("<C-F5>", dotnet.run, "run .NET project")
    end
  end,
}
