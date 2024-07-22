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
  local themes = require("telescope.themes")
  local actions = require("telescope.actions")

  local function toggle_telescope(opts)
    opts = opts or {}
    local file_paths = {}
    for _, item in ipairs(opts.harpoon_files.items) do
      table.insert(file_paths, item.value)
    end
    require("telescope.pickers").new(opts, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      sorter = conf.generic_sorter(opts),
      initial_mode = "normal",
      attach_mappings = function(prompt_bufnr, map)
        map({ "i", "n" }, "<M-d>", actions.delete_buffer)
        return true
        end,
    }):find()
  end

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
        -- toggle_telescope(themes.get_dropdown {harpoon_files = harpoon:list()})
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
