local M = {
  "echasnovski/mini.ai",
  version = false,
  event = "BufRead",
}

-- b: brackets
-- q: quotes
-- a: arguments

function M.config()
  require("mini.ai").setup()
end

return M
