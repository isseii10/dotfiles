-- nvim-lspconfigにあるlspのdefault設定を読み込むプラグイン
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
}
