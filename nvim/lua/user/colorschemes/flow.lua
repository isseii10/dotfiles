local M = {
  "0xstepit/flow.nvim",
  lazy = false,
  priority = 1000,
}

function M.config()
  require("flow").setup {
    transparent = true,
    fluo_color = "pink",
    mode = "normal",
    aggressive_spell = false,
  }
  vim.cmd.colorscheme "flow"
end

return M
