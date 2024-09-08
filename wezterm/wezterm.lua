local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- color scheme
-- config.color_scheme = 'nord'
-- config.color_scheme = 'Nord (Gogh)'
-- config.color_scheme = 'Nord (base16)'
-- config.color_scheme = 'OneDark (Gogh)'
config.color_scheme = "OneHalfDark"

-- window
config.window_background_opacity = 0.96
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- font
-- wezterm ls-fonts --list-systemで出力できる
-- config.font = wezterm.font("HackGen35 Console NF", { weight = "Regular", stretch = "Normal", style = "Normal" })
-- config.font = wezterm.font("JetBrains Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
-- config.font = wezterm.font("Cica", { weight = "Regular", stretch = "Normal", style = "Normal" })

-- font なかったら順次探しに行く設定
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "ヒラギノ角ゴシック",
  "Symbols Nerd Font",
  "Apple Color Emoji",
})

config.font_size = 13

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.6,
}

-- keybinds
config.leader = { key = "m", mods = "CTRL", timeout_milliseconds = 2000 }
config.disable_default_key_bindings = true
local keybind = require("keybinds")
config.keys = keybind.keys
config.key_tables = keybind.key_tables

return config
