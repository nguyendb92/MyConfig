-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.g.mapleader = " "

local map = vim.keymap.set

-- Di chuyển nâng cao
map("n", "H", "^")
map("n", "L", "$")
map("n", "J", "5j")
map("n", "K", "5k")
-- map("n", "o", "o<Esc>")
map("n", "O", "O<Esc>")

-- Tăng tốc delete/change
map("n", "x", '"_x')
map("n", "c", '"_c')

-- Lưu file
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
map("t", "<Esc>", "<C-\\><C-n>")

