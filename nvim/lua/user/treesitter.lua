local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
}

function M.config()
  require("nvim-treesitter.configs").setup {
    modules = {},
    ensure_installed = {
      "lua",
      "luadoc",
      "vim",
      "vimdoc",
      "query",
      "go",
      "markdown",
      "markdown_inline",
      "bash",
      "typescript",
      "python",
      "proto",
      "terraform",
      "sql",
    },
    sync_install = false,
    auto_install = false,
    ignore_install = {},
    highlight = { enable = true },
    indent = { enable = true },
  }
end

return M
