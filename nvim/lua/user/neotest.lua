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
    {
      "fredrikaverpil/neotest-golang",
      dependencies = {
        "leoluz/nvim-dap-go",
      },
    },
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
    {
      "<leader>td",
      function()
        require("neotest").run.run { suite = false, strategy = "dap" }
      end,
      desc = "Debug nearest Test",
    },
    {
      "<leader>tt",
      function()
        require("neotest").run.run()
      end,
      desc = "Test Nearest",
    },
    {
      "<leader>tf",
      function()
        require("neotest").run.run(vim.fn.expand "%")
      end,
      desc = "Test File",
    },
    {
      "<leader>ts",
      function()
        require("neotest").run.stop()
      end,
      desc = "Test Stop",
    },
    {
      "<leader>ta",
      function()
        require("neotest").run.attach()
      end,
      desc = "Attach Test",
    },
    {
      "<leader>to",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle Test Output",
    },
    {
      "<leader>tc",
      function()
        require("neotest").output_panel.clear()
      end,
      desc = "Clear Test Output",
    },
  }

  ---@diagnostic disable: missing-fields
  require("neotest").setup {
    adapters = {
      require "neotest-python" {
        dap = { justMyCode = false },
      },
      require "neotest-vitest",
      require "neotest-zig",
      require "neotest-golang",
      require "neotest-vim-test" {
        ignore_file_types = { "python", "vim", "lua", "javascript", "typescript" },
      },
      discovery = {
        -- Drastically improve performance in ginormous projects by
        -- only AST-parsing the currently opened buffer.
        enabled = true,
        -- Number of workers to parse files concurrently.
        -- A value of 0 automatically assigns number based on CPU.
        -- Set to 1 if experiencing lag.
        concurrent = 0,
      },
      running = {
        -- Run tests concurrently when an adapter provides multiple commands to run.
        concurrent = true,
      },
      summary = {
        -- Enable/disable animation of icons.
        animated = true,
      },
    },
  }
end

return M
