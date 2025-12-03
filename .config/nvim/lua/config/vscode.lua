-- VSCode mode – Dùng keymap & motion của Vim thật
require("config.options")
require("config.keymaps")

-- Không dùng plugin UI nặng
vim.g.lazyvim_plugin_list = {
  telescope = false,
  treesitter = false,
  cmp = false,
  noice = false,
  dressing = false,
}

-- Gọi lệnh VSCode bằng Neovim keymap
local map = vim.keymap.set
local notify = function(cmd) vim.fn.VSCodeNotify(cmd) end

-- File explorer (giống LazyVim)
map("n", "<leader>e", function() notify("workbench.view.explorer") end)

-- Search giống LazyVim
map("n", "<leader>ff", function() notify("workbench.action.quickOpen") end)

-- Toggle terminal
map("n", "<leader>t", function() notify("workbench.action.terminal.toggleTerminal") end)

-- Format
map("n", "<leader>cf", function() notify("editor.action.formatDocument") end)

-- Comment
map({ "n", "v" }, "gc", function() notify("editor.action.commentLine") end)

