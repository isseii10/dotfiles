local M = {
  "akinsho/git-conflict.nvim",
  version = "*",
  config = true,
}

vim.keymap.set("n", "<leader>gco", "<Plug>(git-conflict-ours)")
vim.keymap.set("n", "<leader>gct", "<Plug>(git-conflict-theirs)")
vim.keymap.set("n", "<leader>gcb", "<Plug>(git-conflict-both)")
vim.keymap.set("n", "<leader>gc0", "<Plug>(git-conflict-none)")
vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)", { desc = "prev conflict" })
vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)", { desc = "next conflict" })

return M
