local M = {
  "shortcuts/no-neck-pain.nvim",
  version = "*",
  event = "VeryLazy",
}

function M.config()
  require("no-neck-pain").setup {
    width = 120,
  }
  vim.api.nvim_set_keymap("n", "<leader>c", "<cmd>NoNeckPain<CR>", {desc="centralize"})
end

return M
