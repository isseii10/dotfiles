local M = {
  "echasnovski/mini.ai",
  version = false,
  event = "BufRead",
}

-- b: brackets
-- q: quotes
-- a: arguments

function M.config()
  require("mini.ai").setup {
    -- an/in is left to Neovim's native treesitter node selection
    -- (v_an / v_in), which mini.ai's default mappings would otherwise
    -- shadow.
    mappings = {
      around_next = "",
      inside_next = "",
    },
  }
end

return M
