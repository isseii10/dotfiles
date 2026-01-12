local wezterm = require("wezterm") ---@type Wezterm

---@class WorkspacePickerModule
local M = {}

---@param config Config
function M.apply_to_config(config)
	local workspace_picker = wezterm.plugin.require("https://github.com/isseii10/workspace-picker.wezterm")
	workspace_picker.setup({
		labels = {
			workspace = "󰙅 ", -- nf-md-briefcase
			-- zoxide = "󰋁 ", -- nf-md-rocket_launch
			-- workspace = "󰚝 Workspace", -- nf-md-apps
			zoxide = "󰱼 ", -- nf-md-star_circle
			current = "󰄾 current", -- nf-md-chevron_right
		},
	})

	workspace_picker.apply_to_config(config)
end

return M
