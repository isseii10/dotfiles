local M = {
  "linrongbin16/gitlinker.nvim",
  dependencies = { { "nvim-lua/plenary.nvim" } },
  event = { "BufReadPre", "BufNewFile" },
  cmd = "GitLink",
}

function M.config()
  local wk = require "which-key"
  wk.add {
    { "<leader>gy", "<cmd>GitLink!<cr>", desc = "Git link" },
    { "<leader>gY", "<cmd>GitLink blam<cr>", desc = "Git link blame" },
  }

  require("gitlinker").setup {
    message = true,
    console_log = false,
  }
end

return M
