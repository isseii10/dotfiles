local wezterm = require("wezterm") ---@type Wezterm

---@type Config
local config = wezterm.config_builder and wezterm.config_builder() or {}

config.leader = { key = "m", mods = "CTRL", timeout_milliseconds = 2000 }
config.disable_default_key_bindings = true
config.use_ime = true

-- apply modular configurations
---@type ColorsModule
local colors = require("colors")
---@type KeybindsModule
local keybinds = require("keybinds")
---@type WindowModule
local window = require("window")
---@type FontModule
local font = require("font")
---@type TabModule
local tab = require("tab")

colors.apply_to_config(config)
keybinds.apply_to_config(config)
window.apply_to_config(config)
font.apply_to_config(config)
tab.apply_to_config(config)

-- plugins
-- wezterm.plugin.update_all() -- plugin更新したい時
---@type SmartSplitModule
local smart_split = require("smart-split")
---@type WorkspacePickerModule
local workspace_picker = require("workspace-picker")

smart_split.apply_to_config(config)
workspace_picker.apply_to_config(config)

-- テーマ試したい時
-- cmd shift n: 次
-- cmd shift p: 前
-- cmd shift d: 設定してるテーマに戻る
-- cmd shift r: ランダム
-- wezterm.plugin.require("https://github.com/koh-sh/wezterm-theme-rotator").apply_to_config(config)

return config
