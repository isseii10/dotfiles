local M = {
  "echasnovski/mini.ai",
  version = false,
  event = "BufRead",
}

function M.config()
  require("mini.ai").setup()
end

return M
