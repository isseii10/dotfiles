local wezterm = require "wezterm" ---@type Wezterm

---@class WindowModule
local M = {}

---@param config Config
function M.apply_to_config(config)
  -- window
  config.window_background_opacity = 0.90
  ---@diagnostic disable-next-line: assign-type-mismatch
  config.window_decorations = "RESIZE"

  -- center window on startup
  wezterm.on("gui-startup", function(cmd)
    local screen = wezterm.gui.screens().active
    local width = screen.width * 0.75
    local height = screen.height
    local tab, pane, window = wezterm.mux.spawn_window {
      position = {
        x = (screen.width - width) / 2,
        y = (screen.height - height) / 2,
        origin = "ActiveScreen",
      },
    }
    window:gui_window():set_inner_size(width, height)
  end)

  -- pane
  config.inactive_pane_hsb = {
    saturation = 1,
    brightness = 1,
  }
end

return M
