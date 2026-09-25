-- herdr の nvim サイドバーからコードにコメントを付けてエージェントに送る
-- herdr 側のプラグイン (サイドバー / ピッカー) は herdr plugin install ChmaraX/herdr-nvim で入れる
local M = {
  "ChmaraX/herdr-nvim",
  event = "VeryLazy",
}

function M.config()
  -- キーマップはデフォルトの <leader>a (ac / al / as / aS)
  require("herdr-nvim").setup {}
end

return M
