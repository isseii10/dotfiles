local M = {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    -- general tests
    "vim-test/vim-test",
    "nvim-neotest/neotest-vim-test",
    -- language specific tests
    "nvim-neotest/neotest-go",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "rouge8/neotest-rust",
    "lawrence-laz/neotest-zig",
    "rcasia/neotest-bash",
  },
  event = "VeryLazy",
}

function M.config()
  local wk = require "which-key"
  wk.add {
    { "<leader>td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Test" },
    { "<leader>tt", "<cmd>lua require'neotest'.run.run()<cr>", desc = "Test Nearest" },
    { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Test File" },
    { "<leader>ts", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Test Stop" },
    { "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach Test" },
    { "<leader>to", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Toggle Test Output" },
    { "<leader>tc", "<cmd>lua require('neotest').output_panel.close()<cr>", desc = "Clear Test Output" },
  }

  ---@diagnostic disable: missing-fields
  require("neotest").setup {
    adapters = {
      require "neotest-python" {
        dap = { justMyCode = false },
      },
      require "neotest-vitest",
      require "neotest-zig",
      require "neotest-go",
      require "neotest-vim-test" {
        ignore_file_types = { "python", "vim", "lua", "javascript", "typescript" },
      },
    },
  }
end

return M
