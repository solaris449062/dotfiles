-- This file installs and configures lazy.nvim, the plugin manager.
-- It is not LazyVim: LazyVim is a complete preconfigured distribution.
-- We are using only lazy.nvim while keeping all editor decisions in our own files.

-- `vim.fn.stdpath("data")` returns Neovim's standard data directory.
-- lazy.nvim will be installed below that directory in a folder named `lazy/lazy.nvim`.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- `vim.uv` is Neovim's libuv interface. Older Neovim versions exposed the same
-- interface as `vim.loop`, so the fallback keeps this bootstrap broadly compatible.
-- `fs_stat` checks whether the lazy.nvim directory already exists.
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- This is the official lazy.nvim Git repository.
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"

  -- Clone lazy.nvim only when it is missing.
  -- The table form passes each item as a separate argument to the `git` process.
  -- `--filter=blob:none` avoids downloading unnecessary Git objects.
  -- `--branch=stable` keeps the manager on its stable branch.
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })

  -- `vim.v.shell_error` contains the exit code of the most recent shell command.
  -- A non-zero value means the clone failed.
  if vim.v.shell_error ~= 0 then
    -- Show the failure inside Neovim using highlighted message groups.
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "WarningMsg" },
    }, true, {})

    -- Pause so the error remains visible instead of disappearing immediately.
    vim.fn.getchar()

    -- Stop startup because the plugin manager is required for the rest of this setup.
    os.exit(1)
  end
end

-- `vim.opt.rtp` is Neovim's runtime path option.
-- Prepending lazy.nvim makes its Lua modules available to `require("lazy")`.
vim.opt.rtp:prepend(lazypath)

-- Ask lazy.nvim to load plugin specifications from every Lua file in lua/plugins/.
-- Each plugin file returns a table describing one or more plugins.
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },

  -- Use Neovim's built-in `habamax` colorscheme while plugins are being installed.
  -- We are not installing a colorscheme plugin yet.
  install = {
    colorscheme = { "habamax" },
  },

  -- Check for available plugin updates in the background.
  -- This does not update plugins automatically; it only reports updates.
  checker = {
    enabled = true,
  },
})
