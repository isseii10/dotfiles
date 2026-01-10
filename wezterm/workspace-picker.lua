local wezterm = require("wezterm")

local M = {}

function M.apply_to_config(config)
	-- 開発中はローカルパスから読み込み
	local workspace_picker = wezterm.plugin.require("file:///Users/isseiterada/repo/workspace-picker.wezterm")
	-- リリース後はGitHubから読み込み
	-- local workspace_picker = wezterm.plugin.require("https://github.com/isseii10/workspace-picker.wezterm")
	workspace_picker.apply_to_config(config)
end

return M
