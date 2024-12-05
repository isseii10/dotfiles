return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require "conform"

    conform.setup {
      formatters_by_ft = {
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "markdownlint" },
        graphql = { "prettierd" },
        -- lua = { "stylua" },
        python = { "isort", "black" },
        go = { "goimports", "gofmt" },
        proto = { "buf" },
        sql = { "sqlfmt" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 3000,
      },
      vim.keymap.set({ "n", "v" }, "<leader>lf", function()
        conform.format {
          lsp_fallback = true,
          async = false,
          timeout_ms = 3000,
        }
      end, { desc = "Format file or range (in visual mode)" }),
    }
  end,
}
