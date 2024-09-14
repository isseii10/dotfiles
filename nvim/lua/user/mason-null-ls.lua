local M = {
  "jay-babu/mason-null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
}

function M.config()
  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }

  require("mason-null-ls").setup {
    ensure_installed = {
      -- Opt to list sources here, when available in mason.
      "gofumt",
      "stylua",
      "prettierd",
      "eslint_d",
    },
    automatic_installation = false,
    handlers = {},
  }
  local null_ls = require "null-ls"
  null_ls.setup {
    sources = {
      -- Anything not supported by mason.
      -- null_ls.builtins.completion.spell,
    },
  }
end

return M
