local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.leader = { key = "m", mods = "CTRL", timeout_milliseconds = 2000 }
config.disable_default_key_bindings = true
config.use_ime = true

-- apply modular configurations
require("colors").apply_to_config(config)
require("keybinds").apply_to_config(config)
require("window").apply_to_config(config)
require("font").apply_to_config(config)
require("tab").apply_to_config(config)

-- plugins
wezterm.plugin.update_all()
require("smart-split").apply_to_config(config)
require("workspace-picker").apply_to_config(config)

return config
