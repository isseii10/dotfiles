local M = {
  "echasnovski/mini.surround",
  version = false,
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  require("mini.surround").setup {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      add = "sa", -- Add surrounding in Normal and Visual modes
      delete = "sd", -- Delete urrounding
      find = "sf", -- Find surrounding (to the right)
      find_left = "sF", -- Find surrounding (to the left)
      highlight = "sh", -- Highlight surrounding
      replace = "sr", -- Replace surrounding

      suffix_last = "l", -- Suffix to search with "prev" method
      suffix_next = "n", -- Suffix to search with "next" method
    },
    custom_surroundings = {
      ["("] = {
        output = { left = "(", right = ")" },
      },
      ["{"] = {
        output = { left = "{", right = "}" },
      },
      ["["] = {
        output = { left = "[", right = "]" },
      },
    },
  }
end

return M
