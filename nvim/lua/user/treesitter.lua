local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
}

function M.config()
  require("nvim-treesitter.configs").setup {
    modules = {},
    ensure_installed = {
      "vimdoc",
      "luadoc",
      "vim",
      "lua",
      "go",
      "markdown",
      "markdown_inline",
      "bash",
      "tsx",
      "typescript",
      "python",
      "proto",
      "terraform",
    },
    sync_install = false,
    auto_install = false,
    ignore_install = {},
    highlight = { enable = true },
    indent = { enable = true },
  }
end

return M
