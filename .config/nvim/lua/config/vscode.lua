-- VSCode mode – Dùng keymap & motion của Vim thật

local vscode = require('vscode')

-- Remap movement keys giống LazyVim
vim.keymap.set("n", "<leader>e", function()
  vscode.action("workbench.view.explorer")
end)

vim.keymap.set("n", "<leader>f", function()
  vscode.action("workbench.action.quickOpen")
end)

vim.keymap.set("n", "<leader>g", function()
  vscode.action("git.openChange")
end)

vim.keymap.set("n", "<leader>q", function()
  vscode.action("workbench.action.closeActiveEditor")
end)

-- Search giống LazyVim
vim.keymap.set("n", "<leader>ss", function()
  vscode.action("workbench.action.findInFiles")
end)

-- Format
vim.keymap.set("n", "<leader>ff", function()
  vscode.action("editor.action.formatDocument")
end)

-- Comment
vim.keymap.set({"n", "x"}, "<leader>/", function()
  vscode.action("editor.action.commentLine")
end)


