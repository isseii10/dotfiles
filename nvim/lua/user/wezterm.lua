local M = {
  "willothy/wezterm.nvim",
}

function M.config()
  local function move_win(direction)
    local wezterm = require "wezterm"
    local d = {
      Left = "h",
      Right = "l",
      Up = "k",
      Down = "j",
    }

    return function()
      local current_win_id = vim.api.nvim_get_current_win()

      -- ウィンドウを移動
      vim.cmd.wincmd(d[direction])

      -- 移動後のウィンドウIDを取得して確認
      if vim.api.nvim_get_current_win() == current_win_id then
        print("Cannot move to the " .. direction .. " window")
        wezterm.switch_pane.direction(direction)
      else
        print("Moved to the " .. direction .. " window")
      end
    end
  end

  vim.keymap.set("n", "<c-h>", move_win "Left")
  vim.keymap.set("n", "<c-l>", move_win "Right")
  vim.keymap.set("n", "<c-k>", move_win "Up")
  vim.keymap.set("n", "<c-j>", move_win "Down")
end

return M
