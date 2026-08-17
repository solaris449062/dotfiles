-- `init.lua` is Neovim's startup file.
-- Neovim executes this Lua file every time it starts, from top to bottom.
-- Keeping the first version in one file makes the configuration easy to inspect.

-- Import the core editor settings from lua/vim_config.lua.
require("vim_config")

-- Import our general-purpose keymaps from lua/keys.lua.
-- Plugin-specific keymaps remain next to the plugins that provide them.
require("keys")

-- Import the plugin manager setup from lua/plugin.lua.
-- This runs after `vim_config`, so the leader keys are defined before plugins load.
require("plugin")
