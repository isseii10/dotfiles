local M = {
  "LunarVim/breadcrumbs.nvim",
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  local breadcrumbs = require "breadcrumbs"
  -- 既定の除外は toggleterm までなので、snacks のターミナル (lazygit も含む) に winbar を出さないようにする
  table.insert(breadcrumbs.winbar_filetype_exclude, "snacks_terminal")
  breadcrumbs.setup()
end

return M
