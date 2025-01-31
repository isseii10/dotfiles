local M = {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    "zbirenbaum/copilot-cmp",
    event = { "InsertEnter", "LspAttach" },
    fix_pairs = true,
    config = function()
      require("copilot_cmp").setup()
    end
  },
}

function M.config()
  require("copilot").setup {
    panel = {
      enabled = false,
      -- keymap = {
      --   jump_next = "<c-j>",
      --   jump_prev = "<c-k>",
      --   accept = "<c-l>",
      --   refresh = "r",
      --   open = "<M-CR>",
      -- },
    },
    suggestion = {
      enabled = false,
      -- auto_trigger = true,
      -- keymap = {
      --   accept = "<c-l>",
      --   next = "<c-j>",
      --   prev = "<c-k>",
      --   dismiss = "<c-h>",
      -- },
    },
    filetypes = {
      markdown = true,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
    },
    copilot_node_command = "node",
  }
end

return M
