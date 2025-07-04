local M = {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
}

function M.config()
  local icons = require "user.icons"
  require("ibl").setup {
    indent = {
      char = icons.ui.LineMiddle,
      -- char = icons.ui.LineLeft,
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
      show_exact_scope = true,
    },
    exclude = {
      buftypes = { "terminal", "nofile" },
      filetypes = {
        "help",
        "startify",
        "dashboard",
        "lazy",
        "neogitstatus",
        "NvimTree",
        "Trouble",
        "text",
      },
    },
  }
end

return M
