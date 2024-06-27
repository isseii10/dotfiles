local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- color scheme
config.color_scheme = 'nord'

-- window
config.window_background_opacity = 0.95
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"


-- font
-- config.font = wezterm.font("")
config.font_size = 12.5

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.6,
}

-- keybinds
config.leader = { key = "m", mods = "CTRL", timeout_milliseconds = 2000 }
config.disable_default_key_bindings = true
local keybind = require 'keybinds'
config.keys = keybind.keys
config.key_tables = keybind.key_tables

return config
