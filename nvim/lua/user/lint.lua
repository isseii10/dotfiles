return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require "lint"

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      -- markdown = { "markdownlint" },
      python = { "pylint" }, -- pylintはmasonじゃなくてmiseで入れたpythonのpipで入れる
      go = { "golangcilint" },
      proto = { "protolint" },
      yaml = { "yamllint" },
    }

    lint.linters.golangcilint = {
      cmd = "golangci-lint",
      args = { "run", "--out-format", "line-number" },
      stdin = false,
      ignore_exitcode = true,
      stream = "stdout",
      parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
        source = "golangci-lint",
        severity = vim.diagnostic.severity.WARN,
      }),
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
