local wezterm = require "wezterm" ---@type Wezterm

---@class SmartSplitModule
local M = {}

---@param config Config
function M.apply_to_config(config)
  -- smart-splits.nvim v3 moved the WezTerm side into its backend repo.
  local smart_splits = wezterm.plugin.require "https://github.com/smart-splits-nvim/backend-wezterm"
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
