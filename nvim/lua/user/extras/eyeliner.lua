local M = {
  "jinh0/eyeliner.nvim",
  event = { "BufReadPre", "BufNewFile" },
}

vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#ed6d35", bold = true, underline = true })
vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#ffae8a", underline = false })

function M.config()
  require("eyeliner").setup {
    highlight_on_key = true,
    dim = true,
  }
end

return M
