local status_ok, wk = pcall(require, "which-key")
if status_ok then
  wk.add {
    { "<leader>c", group = "Go" },
    { "<leader>ca", "<cmd>GoAddTest<cr>", desc = "Add test" },
    { "<leader>cA", "<cmd>GoAddAllTest<cr>", desc = "Add all tests" },
    { "<leader>ct", "<cmd>GoModTidy<cr>", desc = "go mod tidy" },
    { "<leader>cf", "<cmd>GoFillStruct<cr>", desc = "Fill struct" },
  }
end

-- Run gofmt + goimports on save

-- conformでやる
-- local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.go",
--   callback = function()
--     require("go.format").goimports()
--   end,
--   group = format_sync_grp,
-- })
