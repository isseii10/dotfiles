local M = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
}

function M.config()
  local null_ls = require "null-ls"

  local formatting = null_ls.builtins.formatting
  local diagnostics =  null_ls.builtins.diagnostics

  null_ls.setup {
    debug = false,
    sources = {
      formatting.stylua,
      formatting.prettierd,
      formatting.gofmt,
      -- formatting.prettier.with {
      --   extra_filetypes = { "toml" },
      --   -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      -- },
      -- formatting.eslint,
      null_ls.builtins.completion.spell,
      
      -- Use require("none-ls.METHOD.TOOL") instead of null_ls.builtins.METHOD.TOOL to use these extras.
      require("none-ls.diagnostics.eslint_d"),

    },
  }
end

return M
