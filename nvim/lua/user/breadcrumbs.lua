local M = {
  "LunarVim/breadcrumbs.nvim",
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  require("breadcrumbs").setup()
end

return M
