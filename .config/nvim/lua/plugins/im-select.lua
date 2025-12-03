return {
  "keaising/im-select.nvim",
  config = function()
    require("im_select").setup({
      -- IM will be set to `default_im_select` in `normal` mode
      -- For macOS, usually "com.apple.keylayout.ABC"
      default_im_select = "com.apple.keylayout.ABC",

      -- Can be binary path or command name
      default_command = "macism",

      -- Restore the previous used input method when entering `insert` mode
      set_previous_events = { "InsertEnter" },

      -- Set to `default_im_select` when entering `normal` mode
      set_default_events = { "InsertLeave" },
    })
  end,
}
