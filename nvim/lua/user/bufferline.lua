local M = {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.bufremove", "ThePrimeagen/harpoon" },
  event = { "BufReadPre", "BufNewFile", "BufDelete" },
}

M.config = function()
  local wk = require "which-key"
  wk.add {
    { "<leader>bo", "<cmd>BufferLinePick<cr>", desc = "Select a buffer to open" },
    { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Select a buffer to close" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to the left" },
    { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
  }

  vim.api.nvim_set_hl(0, "MyBufferSelected", { fg = "#ffffff", bold = true })
  vim.api.nvim_set_hl(0, "MyHarpoonSelected", { fg = "#ffffff", bold = true })

  require("bufferline").setup {
    options = {
      custom_areas = {
        left = function()
          local result = {}
          local items = require("harpoon"):list().items
          local icons = require "user.icons"
          for i = 1, #items do
            local fname = items[i].value
            local fullpath = vim.fn.fnamemodify(fname, ":p")
            local name = " " .. icons.ui.BookMark .. i .. " " .. vim.fn.fnamemodify(fname, ":t") .. " "
            local activename = " " .. icons.ui.BookMarkFill .. i .. " " .. vim.fn.fnamemodify(fname, ":t") .. " "
            if fullpath == vim.fn.expand "%:p" then
              table.insert(result, { text = icons.ui.BoldLineMiddle, link = 'BufferLineIndicatorSelected' })
              -- table.insert(result, { text = name, link = 'MyHarpoonSelected' })
              table.insert(result, { text = activename, link = "MyHarpoonSelected" })
            else
              -- print('inactive: ' .. name)
              table.insert(result, { text = icons.ui.LineMiddle })
              table.insert(result, { text = name, link = "BufferLineBufferVisible" })
            end
          end
          return result
        end,
      },
      offsets = {
        {
          filetype = "NvimTree",
          text = "Nvim Tree",
          separator = true,
          text_align = "left",
        },
      },
      diagnostics = "nvim_lsp",

      -- options = {
      --   offsets = {
      --     {
      --       filetype = "NvimTree",
      --       text = "Nvim Tree",
      --       separator = true,
      --       text_align = "left",
      --     },
      --     diagnostics = "nvim_lsp",
      --   },
      -- },
    },
  }
end

return M
