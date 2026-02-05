local M = {
  "A7Lavinraj/fyler.nvim",
  -- dir = "~/fork/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- dependencies = { "nvim-mini/mini.icons" },
  -- https://github.com/A7Lavinraj/fyler.nvim/pull/25 でsymlink対応されたので、stableに入るまでlatest使う
  -- branch = "stable",
  lazy = false,
}

vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    if vim.bo.filetype ~= "fyler" then
      return
    end
    vim.schedule(function()
      -- Don't close if focus moved to another float (e.g., confirmation)
      local win_config = vim.api.nvim_win_get_config(0)
      if win_config.relative ~= "" then
        return
      end
      require("fyler").close()
    end)
  end,
})

function M.config()
  local fyler = require "fyler"
  local icons = require "user.icons"

  vim.keymap.set("n", "<leader>e", function()
    fyler.toggle()
  end, { noremap = true, silent = true, desc = "Toggle Fyler" })

  fyler.setup {
    hooks = {
      on_highlight = function(highlight_groups, palette)
        highlight_groups.FylerFSDirectoryName = { fg = palette.blue }
        -- Rest of them can change similarly
      end,
    },
    integrations = {
      icon = "nvim_web_devicons",
      -- icon = "mini_icons",
    },
    views = {
      finder = {
        close_on_select = true,
        -- close_on_leave = true,
        confirm_simple = false,
        default_explorer = false,
        delete_to_trash = false,
        git_status = {
          enabled = true,
          -- symbols = {
          --   Untracked = icons.git.FileUntracked,
          --   Added = icons.git.FileUnstaged,
          --   Modified = icons.git.FileModified,
          --   Deleted = icons.git.FileDeleted,
          --   Renamed = icons.git.FileRenamed,
          --   Copied = "~",
          --   Conflict = "!",
          --   Ignored = icons.git.FileIgnored,
          -- },
        },
        icon = {
          directory_collapsed = icons.ui.Folder,
          directory_empty = icons.ui.EmptyFolder,
          directory_expanded = icons.ui.FolderOpen,
        },
        mappings = {
          ["q"] = "CloseView",
          ["<Leader>q"] = "CloseView",
          ["<CR>"] = "Select",
          ["<C-t>"] = "SelectTab",
          ["\\"] = "SelectVSplit",
          ["-"] = "SelectSplit",
          ["^"] = "GotoParent",
          ["="] = "GotoCwd",
          ["."] = "GotoNode",
          ["#"] = "CollapseAll",
          ["<BS>"] = "CollapseNode",
        },
        mappings_opts = {
          nowait = false,
          noremap = true,
          silent = true,
        },
        follow_current_file = true,
        watcher = {
          enabled = false,
        },
        win = {
          border = "rounded",
          buf_opts = {
            filetype = "fyler",
            syntax = "fyler",
            buflisted = false,
            buftype = "acwrite",
            expandtab = true,
            shiftwidth = 2,
          },
          kind = "float",
          kinds = {
            float = {
              height = "70%",
              width = "70%",
              top = "10%",
              left = "15%",
            },
          },
          win_opts = {
            concealcursor = "nvic",
            conceallevel = 3,
            cursorline = false,
            number = false,
            relativenumber = false,
            winhighlight = "Normal:FylerNormal,NormalNC:FylerNormalNC",
            wrap = false,
            signcolumn = "no",
          },
        },
      },
    },
  }
end

return M
