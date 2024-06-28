lvim.plugins = {
  -- colorschemes
  { "shaunsingh/nord.nvim" },
  { "rmehri01/onenord.nvim" },
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require 'nordic'.load()
    end
  },
  --
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup({})
    end,
  },
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
  },
  -- {
  --   "okuuva/auto-save.nvim",
  --   cmd = "ASToggle",          -- optional for lazy loading on command
  --   event = { "InsertLeave" }, -- optional for lazy loading on trigger events
  --   opts = {},
  -- },
  { "olexsmir/gopher.nvim" },
  { "leoluz/nvim-dap-go" },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
}
