local M = {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  require("hlchunk").setup {
    chunk = {
      enable = true,
      priority = 15,
      style = {
        { fg = "#c795ba" },
        { fg = "#c21f30" },
      },
      use_treesitter = true,
      chars = {
        horizontal_line = "─",
        vertical_line = "│",
        left_top = "╭",
        left_bottom = "╰",
        right_arrow = ">",
      },
      textobject = "",
      max_file_size = 1024 * 1024,
      error_sign = true,
      -- animation related
      duration = 200,
      delay = 200,
    },
    indent = {
      enable = true,
    },
    line_num = {
      enable = false,
      style = "#c795ba",
      priority = 10,
      use_treesitter = false,
    },
  }
end

return M
