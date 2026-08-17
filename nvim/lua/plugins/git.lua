-- This file describes the plugins that integrate Neovim with Git.
-- It is imported automatically because plugin.lua imports the `plugins` namespace.

return {
  -- Fugitive provides Git commands and Git-aware buffers inside Neovim.
  {
    -- The GitHub repository containing Fugitive.
    "tpope/vim-fugitive",

    -- Load Fugitive when one of its Git commands is used.
    -- This keeps it out of startup until Git functionality is needed.
    cmd = {
      "Git",
      "Gdiffsplit",
      "Gvdiffsplit",
      "Gread",
      "Gwrite",
      "Gblame",
      "Gedit",
      "Ggrep",
      "Gclog",
      "GBrowse",
    },

  },

  -- Gitsigns shows Git changes directly beside the code in the sign column.
  {
    -- The GitHub repository containing Gitsigns.
    "lewis6991/gitsigns.nvim",

    -- Load Gitsigns when a file is opened or created.
    -- This lets it attach to buffers without loading it during the earliest startup phase.
    event = { "BufReadPre", "BufNewFile" },

    -- An empty options table means we are using Gitsigns' default signs and behavior.
    opts = {},

    -- These mappings are available after Gitsigns has loaded.
    keys = {
      -- Move to the next changed hunk in the current buffer.
      {
        "]c",
        function()
          require("gitsigns").nav_hunk("next")
        end,
        desc = "Next Git hunk",
      },

      -- Move to the previous changed hunk in the current buffer.
      {
        "[c",
        function()
          require("gitsigns").nav_hunk("prev")
        end,
        desc = "Previous Git hunk",
      },

      -- Space followed by `h` then `p` previews the current hunk in a popup.
      {
        "<leader>hp",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Preview Git hunk",
      },

      -- Space followed by `h` then `b` shows who last changed the current line.
      {
        "<leader>hb",
        function()
          require("gitsigns").blame_line({ full = true })
        end,
        desc = "Blame current line",
      },
    },

    -- Call Gitsigns' setup function when the plugin is loaded.
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
}
