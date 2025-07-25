local M = {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require "conform"

    conform.setup {
      formatters_by_ft = {
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        json = { "jq" },
        graphql = { "prettierd", "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        go = { "goimports", "gofmt" },
        -- proto = { "buf" },
        sh = { "shfmt" },
        yaml = { "ymlfmt" },
        -- rust = { "rustfmt" },
      },
      -- formatters = {
      --   prettier = {
      --     command = "prettier",
      --     args = { "--stdin-filepath", "$FILENAME" },
      --     stdin = true,
      --     env = {
      --       LANG = "en_US.UTF-8",
      --     },
      --   },
      --   prettierd = {
      --     command = "prettierd",
      --     args = { "$FILENAME" },
      --     env = {
      --       LANG = "en_US.UTF-8",
      --     },
      --   },
      -- },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    }
  end,
}

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

return M
