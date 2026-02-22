local M = {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  event = "VimEnter", -- VimEnterより遅いとmason_tool_installerのensure_installedが機能しない(https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39)
}

function M.config()
  local mason = require "mason"
  local mason_lspconfig = require "mason-lspconfig"
  local mason_tool_installer = require "mason-tool-installer"

  -- enable mason and configure icons
  mason.setup {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
      border = "rounded",
    },
  }

  -- language servers
  mason_lspconfig.setup {
    ensure_installed = {
      "lua_ls",
      "gopls",
      "ts_ls",
      "jsonls",
      "yamlls",
      "html",
      "cssls",
      "tailwindcss",
      "pyright",
      "markdown_oxide", -- markdown
      "bashls",
      "prismals",
      -- "rust_analyzer", -- rustupで管理する
      "buf_ls",
      "tombi", -- toml
    },
    automatic_enable = true,
  }

  -- linters and formatters and etc.
  mason_tool_installer.setup {
    ensure_installed = {
      -- lua
      "stylua", -- lua formatter

      -- go
      "golangci-lint", -- linter
      "goimports", -- formatter
      "gofumpt", -- formatter
      "gomodifytags", -- go tags
      "delve", -- debugger

      -- rust
      -- "rustfmt", -- rustupでインストールするので不要

      -- typescript
      "eslint_d",
      "prettierd", -- formatter

      -- python
      -- "pylint", -- miseで入れたpythonに合わせる
      "isort", -- python formatter
      "black", -- python formatter

      "shfmt",
      "markdownlint", -- markdown
      "yamlfmt", --yaml
    },
    run_on_start = true,
  }
end

return M
