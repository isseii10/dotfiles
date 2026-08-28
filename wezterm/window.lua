local wezterm = require "wezterm" ---@type Wezterm

---@class WindowModule
local M = {}

-- 画面幅の90% x 画面高さいっぱい、かつ中央配置のジオメトリを算出する
---@return { width: number, height: number, x: number, y: number, screen: table }
local function centered_geometry()
  local screen = wezterm.gui.screens().active
  local width = screen.width * 0.9
  local height = screen.height
  return {
    width = width,
    height = height,
    -- アクティブスクリーン内での相対座標
    x = (screen.width - width) / 2,
    y = (screen.height - height) / 2,
    screen = screen,
  }
end

---@param config Config
function M.apply_to_config(config)
  -- window
  config.window_background_opacity = 0.80
  ---@diagnostic disable-next-line: assign-type-mismatch
  config.window_decorations = "RESIZE"

  -- center window on startup
  wezterm.on("gui-startup", function(cmd)
    local geo = centered_geometry()
    local tab, pane, window = wezterm.mux.spawn_window {
      position = {
        x = geo.x,
        y = geo.y,
        origin = "ActiveScreen",
      },
    }
    window:gui_window():set_inner_size(geo.width, geo.height)
  end)

  -- キーマップから起動時と同じサイズ・位置に戻す
  wezterm.on("center-window", function(window)
    local geo = centered_geometry()
    window:set_inner_size(geo.width, geo.height)
    -- set_position は仮想スクリーン全体の座標系なのでスクリーン原点を足す
    window:set_position(geo.screen.x + geo.x, geo.screen.y + geo.y)
  end)

  -- pane
  config.inactive_pane_hsb = {
    saturation = 1,
    brightness = 1,
  }
end

return M
