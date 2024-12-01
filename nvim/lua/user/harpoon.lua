local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "mike-jl/harpoonEx", opts = { reload_on_dir_change = true } },
    { "nvim-telescope/telescope.nvim" },
  },
}

function M.config()
  local harpoon = require "harpoon"
  local harpoonEx = require "harpoonEx"

  -- REQUIRED
  harpoon:setup()
  -- REQUIRED

  -- load extension
  harpoon:extend(harpoonEx.extend())

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
        require("telescope").extensions.harpoonEx.harpoonEx {
          -- Optional: modify mappings, default mappings:
          attach_mappings = function(_, map)
            local actions = require("telescope").extensions.harpoonEx.actions
            map({ "i", "n" }, "<C-d>", actions.delete_mark)
            map({ "n" }, "dd", actions.delete_mark)
            return true
          end,
        }
        return true
      end,
      desc = "Open harpoon window",
    },
    {
      "[h",
      function()
        harpoon:list():prev()
      end,
      desc = "prev harpoon",
    },
    {
      "]h",
      function()
        harpoon:list():next()
      end,
      desc = "next harpoon",
    },
  }
end

return M
