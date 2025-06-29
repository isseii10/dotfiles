local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  cmd = "Gitsigns",
}
M.config = function()
  local icons = require "user.icons"

  local wk = require "which-key"
  wk.add {
    { "<leader>gj", require("gitsigns").next_hunk, desc = "Next Hunk" },
    { "<leader>gk", require("gitsigns").prev_hunk, desc = "Prev Hunk" },
    { "<leader>gp", require("gitsigns").preview_hunk, desc = "Preview Hunk" },
    { "<leader>gr", require("gitsigns").reset_hunk, desc = "Reset Hunk" },
    { "<leader>gl", require("gitsigns").blame_line, desc = "Blame" },
    { "<leader>gR", require("gitsigns").reset_buffer, desc = "Reset Buffer" },
    { "<leader>gs", require("gitsigns").stage_hunk, desc = "Stage Hunk" },
    { "<leader>gu", require("gitsigns").undo_stage_hunk, desc = "Undo Stage Hunk" },
    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff" },
  }

  require("gitsigns").setup {
    signs = {
      add = {
        text = icons.ui.BoldLineMiddle,
      },
      change = {
        text = icons.ui.BoldLineDashedMiddle,
      },
      delete = {
        text = icons.ui.TriangleShortArrowRight,
      },
      topdelete = {
        text = icons.ui.TriangleShortArrowRight,
      },
      changedelete = {
        text = icons.ui.BoldLineMiddle,
      },
    },
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    update_debounce = 200,
    max_file_length = 40000,
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  }
end

return M
