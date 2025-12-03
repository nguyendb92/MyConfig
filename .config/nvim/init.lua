if vim.g.vscode then
  require("config.vscode")
  -- You might need to load lazy here if you want plugins in VS Code
  require("config.lazy")
else
  require("config.lazy")
end
