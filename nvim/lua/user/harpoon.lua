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

  -- basic telescope configuration
  local conf = require("telescope.config").values
  local themes = require "telescope.themes"
  local actions = require "telescope.actions"

  local marks = require "user.telescope_extentions.harpoon"

  local wk = require "which-key"
  wk.add {
    { "<leader>h", group = "Harpoon" },
    {
      "<leader>ha",
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
        -- if marks were seemed to be bloken, use default
        -- harpoon.ui:toggle_quick_menu(harpoon:list())
        marks(themes.get_dropdown { initial_mode = "normal" })
      end,
      desc = "open window",
    },
    {
      "[h",
      function()
        harpoon:list():prev()
      end,
      desc = "prev",
    },
    {
      "]h",
      function()
        harpoon:list():next()
      end,
      desc = "next",
    },
  }
end

return M
