local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Basic appearance
config.font = wezterm.font 'Menlo'
config.font_size = 14.0
config.color_scheme = 'Catppuccin Mocha'
config.window_padding = {
  left = 10,
  right = 10,
  top = 8,
  bottom = 8,
}

-- Hide the tab bar and native title bar.
config.enable_tab_bar = false
config.window_decorations = 'RESIZE'

return config
