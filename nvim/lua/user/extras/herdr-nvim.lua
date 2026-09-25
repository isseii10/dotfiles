-- herdr の nvim サイドバーからコードにコメントを付けてエージェントに送る
-- herdr 側のプラグイン (サイドバー / ピッカー) は herdr plugin install ChmaraX/herdr-nvim で入れる
local M = {
  "ChmaraX/herdr-nvim",
  event = "VeryLazy",
}

function M.config()
  require("herdr-nvim").setup {
    -- <leader>a は sidekick.nvim が使っているので <leader>H にする
    prefix = "<leader>H",
  }
end

return M
