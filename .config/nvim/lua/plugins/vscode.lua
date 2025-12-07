if not vim.g.vscode then
  return {}
end

return {
  { "nvim-treesitter/nvim-treesitter", enabled = false },
  { "folke/noice.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false },
  { "stevearc/dressing.nvim", enabled = false },
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
  { "nvim-lualine/lualine.nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },
  { "ason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "neovim/nvim-lspconfig", enabled = false },
  { "hrsh7th/nvim-cmp", enabled = false },
  { "lewis6991/gitsigns.nvim", enabled = false },
  { "folke/which-key.nvim", enabled = true },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "nvim-mini/mini.surround", enabled = true },
}
