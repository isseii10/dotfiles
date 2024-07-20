local M = {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.bufremove" },
  event = { "BufReadPre", "BufNewFile" },
}

M.config = function()
  local wk = require "which-key"
  wk.add {
    { "<leader>bo", "<cmd>BufferLinePick<cr>",       desc = "Select a buffer to open" },
    { "<leader>bc", "<cmd>BufferLinePickClose<cr>",  desc = "Select a buffer to close" },
    { "[b",         "<cmd>BufferLineCyclePrev<cr>",  desc = "Previous buffer" },
    { "]b",         "<cmd>BufferLineCycleNext<cr>",  desc = "Next buffer" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>",  desc = "Close buffers to the left" },
    { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
  }
  require("bufferline").setup {
    options = {
      offsets = {
        {
          filetype = "NvimTree",
          text = "Nvim Tree",
          separator = true,
          text_align = "left",
        },
        diagnostics = "nvim_lsp",
      },
    },
  }
end

return M
