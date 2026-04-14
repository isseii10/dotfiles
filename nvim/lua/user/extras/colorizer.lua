local M = {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
}

function M.config()
  require("colorizer").setup {
    filetypes = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
      "css",
      "scss",
      "html",
      "astro",
      "lua",
      "toml",
    },
    user_default_options = {
      names = false,
      rgb_fn = true,
      hsl_fn = true,
      -- NOTE: nvim-colorizer's tailwind LSP path currently breaks on Neovim 0.12
      -- because it calls vim.lsp.document_color.enable() with the old signature.
      -- Keep Tailwind name-based highlighting enabled and disable the LSP path.
      tailwind = "normal",
    },
    buftypes = {},
  }
end

return M
