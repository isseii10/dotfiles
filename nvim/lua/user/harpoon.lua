local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
}

function M.config()
  local harpoon = require "harpoon"
  -- REQUIRED
  harpoon:setup()
  -- REQUIRED

  local wk = require "which-key"
  wk.add {
    { "<leader>h", group = "Harpoon" },
    {
      "<leader>hb",
      function()
        harpoon:list():add()
        -- for barbar rendering
        vim.cmd ":do User"
      end,
      desc = "bookmark",
    },
    {
      "<leader>hh",
      function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "open window",
    },
    {
      "<leader>ha",
      function()
        harpoon:list():select(1)
      end,
      desc = "goto a",
    },
    {
      "<leader>hs",
      function()
        harpoon:list():select(2)
      end,
      desc = "goto s",
    },
    {
      "<leader>hq",
      function()
        harpoon:list():select(3)
      end,
      desc = "goto q",
    },
    {
      "<leader>hw",
      function()
        harpoon:list():select(4)
      end,
      desc = "goto w",
    },
  }
end

return M
