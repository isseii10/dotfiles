-- herdr の nvim サイドバーからコードにコメントを付けてエージェントに送る
-- herdr 側のプラグイン (サイドバー / ピッカー) は herdr plugin install ChmaraX/herdr-nvim で入れる
local M = {
  "ChmaraX/herdr-nvim",
  event = "VeryLazy",
}

-- 今のファイルを @path でエージェントの入力欄に貼る (sidekick の {file} 相当)
-- herdr-nvim の内部モジュールを使っているので、プラグイン更新で壊れる可能性がある
local function send_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("herdr-nvim: no file in current buffer", vim.log.levels.WARN)
    return
  end
  local agents = require "herdr-nvim.agents"
  local list, err = agents.list()
  if not list then
    vim.notify("herdr-nvim: " .. err, vim.log.levels.ERROR)
    return
  end

  local function deliver(agent)
    -- エージェントの cwd 配下なら相対パス、それ以外は絶対パス
    local path = vim.fn.fnamemodify(file, ":p")
    local cwd = agent.cwd ~= "" and vim.fn.fnamemodify(agent.cwd, ":p") or nil
    if cwd and vim.startswith(path, cwd) then
      path = path:sub(#cwd + 1)
    end
    local ok, derr = require("herdr-nvim.dispatch").send(agent.pane_id, "@" .. path .. " ")
    if not ok then
      vim.notify("herdr-nvim: " .. derr, vim.log.levels.ERROR)
      return
    end
    vim.notify("herdr-nvim: sent @" .. path .. " to " .. agent.title)
  end

  local agent = agents.resolve(list)
  if agent then
    deliver(agent)
  else
    require("herdr-nvim.ui").pick_agent(list, deliver)
  end
end

function M.config()
  -- キーマップはデフォルトの <leader>a (ac / al / as / aS)
  require("herdr-nvim").setup {}
  vim.keymap.set("n", "<leader>af", send_file, { desc = "herdr-nvim: send file to agent" })
end

return M
