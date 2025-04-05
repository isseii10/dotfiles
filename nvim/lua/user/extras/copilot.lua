return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    {
      "zbirenbaum/copilot-cmp",
      event = { "InsertEnter", "LspAttach" },
      fix_pairs = true,
      config = function()
        require("copilot_cmp").setup()
      end,
    },
  },
  config = function()
    require("copilot").setup {
      panel = { enabled = false },
      suggestion = { enabled = false },
    }
  end,
}
