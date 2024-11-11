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
-- config.color_scheme = 'OneDark (base16)'
-- config.color_scheme = "OneHalfDark"
-- config.color_scheme = 'One Half Black (Gogh)'
-- config.color_scheme = 'darkmoss (base16)'
-- config.color_scheme = 'duckbones'
-- config.color_scheme = 'Ef-Deuteranopia-Dark'
-- config.color_scheme = 'zenbones_dark'
-- config.color_scheme = 'X::DotShare (terminal.sexy)'
-- config.color_scheme = 'Tartan (terminal.sexy)'
config.color_scheme = 'terafox'


-- window
config.window_background_opacity = 0.95
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- font
-- wezterm ls-fonts --list-systemで出力できる
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

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

-- move between split panes
table.insert(config.keys, split_nav("move", "h"))
table.insert(config.keys, split_nav("move", "j"))
table.insert(config.keys, split_nav("move", "k"))
table.insert(config.keys, split_nav("move", "l"))
-- resize panes
table.insert(config.keys, split_nav("resize", "h"))
table.insert(config.keys, split_nav("resize", "j"))
table.insert(config.keys, split_nav("resize", "k"))
table.insert(config.keys, split_nav("resize", "l"))

return config
