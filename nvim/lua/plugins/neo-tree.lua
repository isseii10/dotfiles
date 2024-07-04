return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>e', ':Neotree toggle<CR>', { desc = 'NeoTree toggle' } },
  },
  opts = {
    close_if_last_window = true, -- 最後のウィンドウが閉じるときにNeo-treeを閉じる
    popup_border_style = 'rounded', -- ポップアップの境界スタイル
    enable_git_status = true, -- Gitステータスを表示
    enable_diagnostics = true, -- 診断情報を表示
    filesystem = {
      filtered_items = {
        hide_dotfiles = false, -- ドットファイルを隠すか
        hide_gitignored = false, -- gitignoredなファイルを隠すか
      },
    },
  },
}
