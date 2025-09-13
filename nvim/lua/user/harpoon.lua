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
            map({ "n" }, "dd", actions.delete_mark)
            return true
          end,
        }
        return true
      end,
      desc = "Open harpoon window",
    },
    {
      "<leader>hx",
      function()
        harpoon:list():clear()
        -- for barbar rendering
        vim.cmd ":do User"
      end,
      desc = "Delete all bookmarks",
    },
  }

  -- ファイルが保存されたときにHarpoonに追加
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      -- nvim-dbeeでsqlファイルに実行したいクエリを書くため、sqlファイルはharpoonに追加しない
      if vim.bo.filetype == "sql" then
        return
      end
      -- ファイルが変更されている場合のみ処理
      if vim.bo.modified then
        harpoon:list():add()
        vim.cmd ":do User"
      end
    end,
  })
end

return M
