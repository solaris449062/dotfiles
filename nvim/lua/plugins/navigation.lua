-- This file groups plugins related to finding and navigating files.
-- It is imported automatically because plugin.lua imports the `plugins` namespace.

return {
  -- The first item in this list describes Snacks.
  {
    -- The GitHub repository containing snacks.nvim.
    "folke/snacks.nvim",

    -- Load Snacks early because its setup creates shared UI behavior and autocmds.
    priority = 1000,

    -- Load Snacks during startup instead of waiting for a command or event.
    lazy = false,

    -- Enable only the Snacks components we currently want.
    opts = {
      -- Replace Neovim's plain `vim.ui.input()` prompt with a floating input window.
      input = {
        enabled = true,
      },

      -- Display messages sent through `vim.notify()` as floating notifications.
      notifier = {
        enabled = true,
      },

      -- Enable Snacks' picker for files, text, buffers, and other searchable items.
      picker = {
        enabled = true,
      },
    },

    -- These mappings call Snacks after the plugin has been loaded and configured.
    keys = {
      -- `gd` means "go to definition" in Normal mode.
      -- This asks the active language server for definitions and shows the results in a picker.
      -- It will report no results until an LSP client is attached to the current buffer.
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Go to definition",
      },

      -- Space followed by `f` then `f` opens a Snacks file picker.
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find files",
      },

      -- Space followed by `f` then `g` searches text in the project.
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Search text",
      },

      -- Space followed by `f` then `b` searches currently open buffers.
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Find open buffers",
      },
    },

    -- This explicit config function makes plugin initialization visible.
    -- The first argument is the plugin specification; we do not need it here.
    -- The second argument is the `opts` table defined above.
    config = function(_, opts)
      require("snacks").setup(opts)
    end,
  },

  -- The second item describes Oil, our filesystem explorer.
  {
    -- The GitHub repository containing oil.nvim.
    "stevearc/oil.nvim",

    -- Oil recommends starting eagerly because making it lazy-loaded can be tricky.
    lazy = false,

    -- Oil's options control how directory buffers behave.
    opts = {
      -- Open Oil automatically when Neovim is asked to edit a directory, such as `nvim .`.
      default_file_explorer = true,

      -- Control which filesystem entries Oil displays.
      view_options = {
        -- Show dotfiles such as `.gitignore` and `.config` by default.
        show_hidden = true,
      },

      -- Send deleted files to the system Trash instead of permanently deleting them.
      delete_to_trash = true,
    },

    -- Space followed by `e` opens the Oil filesystem explorer.
    keys = {
      {
        "<leader>e",
        "<cmd>Oil<CR>",
        desc = "Open Oil file explorer",
      },
    },

    -- Explicitly call Oil's setup function with the options above.
    config = function(_, opts)
      require("oil").setup(opts)
    end,
  },
}
