-- filepath: /Users/nguyennc/.config/nvim/init.lua
require("config.lazy")

if vim.g.vscode then
  require("config.vscode")
end
