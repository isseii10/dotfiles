local wezterm = require("wezterm") ---@type Wezterm

---@class SmartSplitModule
local M = {}

---@param config Config
function M.apply_to_config(config)
	local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
	smart_splits.apply_to_config(config, {
		direction_keys = {
			move = { "h", "j", "k", "l" },
			resize = { "h", "j", "k", "l" },
		},
		modifiers = {
			move = "CTRL", -- CTRL+h/j/k/l で移動
			resize = "META", -- META(Option)+h/j/k/l でリサイズ
		},
	})
end

return M
