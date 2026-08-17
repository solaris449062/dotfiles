-- This file describes plugins that improve Neovim's user interface.
-- It is imported automatically because plugin.lua imports the `plugins` namespace.

return {
  -- Which-key displays available keybindings in a popup while you type them.
  {
    -- The GitHub repository containing which-key.nvim.
    "folke/which-key.nvim",

    -- Load WhichKey after startup, once the basic editor and plugin mappings exist.
    event = "VeryLazy",

    -- An empty options table uses WhichKey's default popup behavior.
    -- WhichKey reads descriptions from the `desc` fields of our existing mappings.
    -- This does not create any new aliases or keybindings.
    opts = {},

    -- Make plugin initialization explicit: pass the options table to WhichKey's setup function.
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },
}
