local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  event = "VeryLazy",
}


function M.config()
  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }

  local servers = {
    "lua_ls",
    "cssls",
    "html",
    "ts_ls",
    "pyright",
    "jsonls",
    "yamlls",
    "gopls",
  }


  require("mason-lspconfig").setup {
    ensure_installed = servers,
  }
end

return M
