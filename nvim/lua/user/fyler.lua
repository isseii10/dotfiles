local M = {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  branch = "stable",
  lazy = false,
}
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
    },
    views = {
      finder = {
        close_on_select = true,
        confirm_simple = false,
        default_explorer = false,
        delete_to_trash = false,
        git_status = {
          enabled = true,
          symbols = {
            Untracked = icons.git.FileUntracked,
            Added = icons.git.FileUnstaged,
            Modified = icons.git.FileModified,
            Deleted = icons.git.FileDeleted,
            Renamed = icons.git.FileRenamed,
            Copied = "~",
            Conflict = "!",
            Ignored = icons.git.FileIgnored,
          },
        },
        icon = {
          directory_collapsed = icons.ui.Folder,
          directory_empty = icons.ui.EmptyFolder,
          directory_expanded = icons.ui.FolderOpen,
        },
        indentscope = {
          enabled = true,
          group = "FylerIndentMarker",
          marker = "│",
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
