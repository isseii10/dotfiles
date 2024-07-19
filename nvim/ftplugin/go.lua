local status_ok, wk = pcall(require, "which-key")
if status_ok then
  wk.add {
    { "<leader>c",  group = "Go" },
    { "<leader>ca", "<cmd>GoAddTest", desc = "add test" },
    { "<leader>cA", "<cmd>GoAddAllTest", desc = "add all tests" },
  }
end
