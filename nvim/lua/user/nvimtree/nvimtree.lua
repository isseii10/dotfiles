local M = {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>e" },
  },
}

function M.config()
  local wk = require "which-key"
  wk.add {
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer" },
  }

  local icons = require "user.icons"

  require("nvim-tree").setup {
    hijack_netrw = true,
    disable_netrw = true,
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    filters = {
      dotfiles = false,
      git_ignored = false,
      custom = {
        -- "^\\.git$",
        "^node_modules",
      },
    },
    view = {
      float = {
        enable = true,
        quit_on_focus_loss = true,
        open_win_config = {
          relative = "editor",
          border = "rounded",
          width = 50,
        },
      },
      -- if float.enable = false
      width = 50,
    },
    renderer = {
      root_folder_modifier = ":~",
      highlight_opened_files = "all", -- 開いているファイルを強調表示
      add_trailing = false,
      group_empty = false,
      highlight_git = false,
      full_name = true,
      root_folder_label = ":t",
      indent_width = 1,
      indent_markers = {
        enable = false,
        inline_arrows = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "│",
          none = " ",
        },
      },
      icons = {
        git_placement = "before",
        padding = " ",
        symlink_arrow = " ➛ ",
        glyphs = {
          default = icons.ui.Text,
          symlink = icons.ui.FileSymlink,
          bookmark = icons.ui.BookMark,
          folder = {
            arrow_closed = icons.ui.ChevronRight,
            arrow_open = icons.ui.ChevronShortDown,
            default = icons.ui.Folder,
            open = icons.ui.FolderOpen,
            empty = icons.ui.EmptyFolder,
            empty_open = icons.ui.EmptyFolderOpen,
            symlink = icons.ui.FolderSymlink,
            symlink_open = icons.ui.FolderOpen,
          },
          git = {
            unstaged = icons.git.FileUnstaged,
            staged = icons.git.FileStaged,
            unmerged = icons.git.FileUnmerged,
            renamed = icons.git.FileRenamed,
            untracked = icons.git.FileUntracked,
            deleted = icons.git.FileDeleted,
            ignored = icons.git.FileIgnored,
          },
        },
      },
      special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
      symlink_destination = true,
    },
    update_focused_file = {
      enable = true,
      debounce_delay = 15,
      update_root = {
        enable = false,
      },
      ignore_list = {},
    },

    diagnostics = {
      enable = true,
      show_on_dirs = false,
      show_on_open_dirs = true,
      debounce_delay = 50,
      severity = {
        min = vim.diagnostic.severity.HINT,
        max = vim.diagnostic.severity.ERROR,
      },
      icons = {
        hint = icons.diagnostics.BoldHint,
        info = icons.diagnostics.BoldInformation,
        warning = icons.diagnostics.BoldWarning,
        error = icons.diagnostics.BoldError,
      },
    },
  }
end

return M
