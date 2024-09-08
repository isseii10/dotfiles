local M = {
  "echasnovski/mini.surround",
  version = false,
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  require("mini.surround").setup {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      add = "gsa",            -- Add surrounding in Normal and Vsual modes
      delete = "gsd",         -- Delete surroundng
      find = "gsf",           -- Find surrounding (to the right)
      find_left = "gsF",      -- Find surrounding (to the left)
      highlight = "gsh",      -- Highlight surrounding
      replace = "gsr",        -- Replace surrounding
      update_n_lines = "gsn", -- Update `n_lines`

      suffix_last = "l",      -- Suffix to search with "prev" method
      suffix_next = "n",      -- Suffix to search with "next" method
    },
  }
end

return M
