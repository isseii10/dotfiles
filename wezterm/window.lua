local wezterm = require("wezterm") ---@type Wezterm

---@class WindowModule
local M = {}

---@param config table
function M.apply_to_config(config)
	-- window
	config.window_background_opacity = 0.90
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

	-- position and size
	local mux = wezterm.mux
	wezterm.on("gui-startup", function(cmd)
		local tab, pane, window = mux.spawn_window(cmd or { width = 204, height = 180 })
	end)

	-- pane
	config.inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.6,
	}
end

return M
