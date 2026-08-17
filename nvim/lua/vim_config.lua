-- `vim` is Neovim's built-in Lua API.
-- `vim.g` contains global variables that Neovim and plugins can read.
-- `mapleader` defines the key used as the prefix for our personal mappings.
-- Here the leader is one Space key, so `<leader>w` means Space followed by `w`.
vim.g.mapleader = " "

-- `maplocalleader` is a second leader used for filetype- or buffer-specific mappings.
-- We start it with the same Space key so there is only one leader to remember.
vim.g.maplocalleader = " "

-- `vim.opt` is the Lua interface for Neovim's normal `:set` options.
-- Assigning `vim.opt.some_option` is conceptually similar to running `:set some_option`.

-- Show absolute line numbers in the sign column on the left side of the editor.
vim.opt.number = true

-- Show each other line's distance from the cursor instead of its absolute number.
-- With `number` and `relativenumber` together, the current line stays absolute
-- while surrounding lines show relative distances such as 1, 2, and 3.
vim.opt.relativenumber = true

-- Allow mouse input for selecting text, moving between windows, and resizing splits.
vim.opt.mouse = "a"

-- Include the system clipboard in Neovim's unnamed register.
-- On macOS, Neovim uses the built-in `pbcopy` and `pbpaste` programs as its clipboard provider.
-- This makes normal-mode yanks such as `yy` and visual-mode `y` available to other applications.
vim.opt.clipboard = "unnamedplus"

-- Ask the terminal to use its full 24-bit color capability when available.
vim.opt.termguicolors = true

-- Always reserve a column for signs such as diagnostics, breakpoints, and Git markers.
-- Reserving it prevents the text from shifting when a sign appears or disappears.
vim.opt.signcolumn = "yes"

-- Highlight the screen line containing the cursor.
vim.opt.cursorline = true

-- Put a new vertical split to the right of the current window.
vim.opt.splitright = true

-- Put a new horizontal split below the current window.
vim.opt.splitbelow = true

-- Make searches case-insensitive when the search text contains only lowercase letters.
vim.opt.ignorecase = true

-- Keep the cursor away from the top and bottom screen edges.
vim.opt.scrolloff = 16

-- Override `ignorecase` automatically when the search contains an uppercase letter.
-- Together, these two options give convenient case-insensitive searches with an escape hatch.
vim.opt.smartcase = true

-- Insert spaces when the Tab key is pressed instead of inserting literal tab characters.
vim.opt.expandtab = true

-- Display a Tab character as two screen columns.
vim.opt.tabstop = 2

-- Use two spaces when an indentation command adds or removes one indentation level.
vim.opt.shiftwidth = 2

-- Use two spaces while editing indentation with the Tab and Backspace keys.
vim.opt.softtabstop = 2

-- Save undo history between Neovim sessions.
vim.opt.undofile = true

-- `vim.fn` lets Lua call built-in Vimscript functions.
-- `stdpath("state")` returns Neovim's standard per-user state directory.
-- `..` concatenates Lua strings, producing a path ending in `/undo`.
local undo_dir = vim.fn.stdpath("state") .. "/undo"

-- Create the undo directory if it does not exist.
-- The `p` flag means parent directories are created as necessary.
vim.fn.mkdir(undo_dir, "p")

-- Tell Neovim to store persistent undo files in the directory we just prepared.
vim.opt.undodir = undo_dir

-- `vim.api` is Neovim's lower-level API.
-- `nvim_create_autocmd` registers code to run when a Neovim event occurs.
vim.api.nvim_create_autocmd("FileType", {
  -- Run this autocmd only when the detected filetype is one of these four types.
  pattern = { "python", "sh", "bash", "zsh" },

  -- `callback` is a Lua function Neovim calls when the FileType event happens.
  -- `args` is a table containing information about the event, including its buffer ID.
  callback = function(args)
    -- `vim.bo[args.buf]` accesses options local to the buffer that triggered the event.
    -- These files use spaces for indentation even though the global default is already spaces.
    vim.bo[args.buf].expandtab = true

    -- Use four spaces per indentation level in Python and shell files.
    vim.bo[args.buf].shiftwidth = 4

    -- Display and edit a Tab as four columns in Python and shell files.
    vim.bo[args.buf].tabstop = 4
  end,
})
