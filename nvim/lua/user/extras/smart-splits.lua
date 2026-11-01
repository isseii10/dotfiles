local M = {
  "smart-splits-nvim/smart-splits.nvim",
  event = "VeryLazy",
  dependencies = {
    -- v3 moved multiplexer support out of core. Each backend also needs its
    -- multiplexer-side plugin (herdr/config.toml, wezterm/smart-split.lua).
    { "adriankarlen/smart-splits-backend-herdr", main = "smart-splits-backend-herdr", opts = {} },
    { "smart-splits-nvim/backend-wezterm", main = "smart-splits-backend-wezterm", opts = {} },
  },
}

function M.config()
  -- Everything else is left at v3's defaults (resize.amount = 3,
  -- move.at_edge = "wrap", move.float = "previous", ...), see
  -- :h smart-splits-configuration.
  require("smart-splits").setup {
    -- herdr first: it's the inner multiplexer when running inside WezTerm.
    mux = { backend = { "smart-splits-backend-herdr", "smart-splits-backend-wezterm" } },
  }

  local function is_floating()
    return vim.api.nvim_win_get_config(0).relative ~= ""
  end

  -- recommended mappings
  -- resizing splits
  -- these keymaps will also accept a range,
  -- for example `10<A-h>` will `resize_left` by `(10 * resize.amount)`
  vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
  vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
  vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
  vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
  -- moving between splits
  vim.keymap.set("n", "<C-h>", function()
    if is_floating() then
      vim.cmd "wincmd h"
    else
      require("smart-splits").move_cursor_left()
    end
  end)
  vim.keymap.set("n", "<C-j>", function()
    if is_floating() then
      vim.cmd "wincmd j"
    else
      require("smart-splits").move_cursor_down()
    end
  end)
  vim.keymap.set("n", "<C-k>", function()
    if is_floating() then
      vim.cmd "wincmd k"
    else
      require("smart-splits").move_cursor_up()
    end
  end)
  vim.keymap.set("n", "<C-l>", function()
    if is_floating() then
      vim.cmd "wincmd l"
    else
      require("smart-splits").move_cursor_right()
    end
  end)
  -- vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
  -- swapping buffers between windows
  vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
  vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
  vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
  vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
end

return M
