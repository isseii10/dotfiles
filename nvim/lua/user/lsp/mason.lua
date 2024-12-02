return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require "mason"

    -- import mason-lspconfig
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

    mason_lspconfig.setup {
      -- list of servers for mason to install
      ensure_installed = {
        "lua_ls",
        "gopls",
        "yamlls",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "pyright",
        "marksman",
        "sqlls",
      },
    }

    mason_tool_installer.setup {
      ensure_installed = {
        -- linter
        "pylint",
        "eslint_d",
        "markdownlint",

        -- formatter
        "prettierd", -- prettier formatter
        "stylua",    -- lua formatter
        "isort",     -- python formatter
        "black",     -- python formatter
        "sqlfmt",
      },
    }
  end,
}
