local status_ok, wk = pcall(require, "which-key")
if status_ok then
  wk.add {
    { "<leader>c",  group = "Go" },
    { "<leader>ca", "<cmd>GoAddTest<cr>", desc = "add test" },
    { "<leader>cA", "<cmd>GoAddAllTest<cr>", desc = "add all tests" },
    { "<leader>ct", "<cmd>GoModTidy<cr>", desc = "go mod tidy" },
    { "<leader>ce", "<cmd>GoIfErr<cr>", desc = "if err" },
  }
end
