local M = {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  -- stylua: ignore
  keys = {
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump {} end,             desc = "Flash" },
    { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  },
}

function M.config()
  require("flash").setup {
    modes = {
      char = { enabled = false },
    },
  }
  vim.api.nvim_set_hl(0, "Flashlabel", { fg = "#ed6d35", bold = true, underline = true })
  vim.api.nvim_set_hl(0, "FlashMatch", { fg = "#ffae8a", underline = false })
end

return M
