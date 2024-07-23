local M = {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
  cmd = "Neotree",
  keys = {
    { "<leader>e", ":Neotree toggle<CR>", { desc = "NeoTree toggle" } },
  },
}

function M.config()
  require("neo-tree").setup {
    hijack_netrw_behavior = "open_current",
    close_if_last_window = true,    -- 最後のウィンドウが閉じるときにNeo-treeを閉じる
    popup_border_style = "rounded", -- ポップアップの境界スタイル
    enable_git_status = true,       -- Gitステータスを表示
    enable_diagnostics = true,      -- 診断情報を表示
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,   -- ドットファイルを隠すか
        hide_gitignored = false, -- gitignoredなファイルを隠すか
      },
      follow_current_file = {
        enabled = true,          -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
    },
  }
end

return M
