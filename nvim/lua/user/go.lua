local M = {
  "ray-x/go.nvim",
  dependencies = { -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
}

M.config = function()
  require("go").setup {
    diagnostic = false,
    lsp_cfg = false, -- false: do nothing
    lsp_on_attach = nil, -- nil: do nothing
  }
end
return M
