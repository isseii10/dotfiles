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

-- as / aS で送る文章から "Code review comments from my editor (repo: ..., branch: ...):" の見出しを外す
-- 元の実装: herdr-nvim/lua/herdr-nvim/prompt.lua (内部モジュールなのでプラグイン更新で壊れる可能性がある)
local function format_prompt(items)
  local lines = {}
  for i, item in ipairs(items) do
    local c = item.comment
    table.insert(lines, string.format("%d. %s:%d-%d", i, c.file, c.start_line, c.end_line))
    for j = 1, math.min(3, #(item.snippet or {})) do
      table.insert(lines, "   > " .. item.snippet[j])
    end
    table.insert(lines, "   Comment: " .. c.text)
    table.insert(lines, "")
  end
  table.insert(lines, "Please address each comment. Reply with what you changed per item.")
  return table.concat(lines, "\n")
end

function M.config()
  -- キーマップはデフォルトの <leader>a (ac / al / as / aS)
  require("herdr-nvim").setup {}
  require("herdr-nvim.prompt").format = format_prompt
  vim.keymap.set("n", "<leader>af", send_file, { desc = "herdr-nvim: send file to agent" })
end

return M
