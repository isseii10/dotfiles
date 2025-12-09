local M = {
  "SmiteshP/nvim-navic",
  event = "BufReadPre",
}

function M.config()
  local icons = require "user.icons"
  require("nvim-navic").setup {
    icons = icons.kind,
    highlight = true,
    lsp = {
      auto_attach = true,
      preference = {
        ["obsidian-ls"] = 10, -- obsidian-lsはObsidianVault配下でのみattachされる。その状況下では優先する
        ["markdown_oxide"] = 1,
      },
    },
    click = true,
    separator = " " .. icons.ui.ChevronRight .. " ",
    depth_limit = 0,
    depth_limit_indicator = "..",
  }
end

return M
