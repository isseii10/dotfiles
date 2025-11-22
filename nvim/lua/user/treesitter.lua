local M = {
  "nvim-treesitter/nvim-treesitter",
  -- event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  branch = "main",
  lazy = false,
}

function M.config()
  local parsers = {
    "lua",
    "luadoc",
    "vim",
    "vimdoc",
    "query",
    "go",
    "gomod",
    "gosum",
    "markdown",
    "markdown_inline",
    "bash",
    "javascript",
    "typescript",
    "tsx",
    "python",
    "proto",
    "terraform",
    "sql",
    "yaml",
    "rust",
    "make",
  }
  require("nvim-treesitter").install(parsers)

  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
      "lua",
      "vim",
      "go",
      "gomod",
      "gosum",
      "markdown",
      "sh",
      "javascript",
      "typescript",
      "typescriptreact",
      "python",
      "proto",
      "terraform",
      "sql",
      "yaml",
      "rust",
      "make",
    },
    callback = function()
      -- syntax highlighting, provided by Neovim
      vim.treesitter.start()
      -- folds, provided by Neovim
      -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      -- indentation, provided by nvim-treesitter
      -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end

return M
