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
    -- 常に絶対パスで送る
    local path = vim.fn.fnamemodify(file, ":p")
    local ok, derr = require("herdr-nvim.dispatch").send(agent.pane_id, "@" .. path .. " ")
    if not ok then
      vim.notify("herdr-nvim: " .. derr, vim.log.levels.ERROR)
      return
    end
    vim.notify("herdr-nvim: sent @" .. path .. " to " .. (agent.title_stripped or agent.title))
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

-- 送信に成功したら送り先のエージェントにフォーカスを移す (as / aS / ai / af すべて dispatch.send を通る)
-- herdr-nvim の内部モジュールを使っているので、プラグイン更新で壊れる可能性がある
local function focus_after_send()
  local dispatch = require "herdr-nvim.dispatch"
  local send = dispatch.send
  dispatch.send = function(pane_id, ...)
    local ok, err = send(pane_id, ...)
    if ok then
      vim.system { "herdr", "agent", "focus", pane_id }
    end
    return ok, err
  end
end

-- 送り先を選ぶポップアップの表示を herdr のサイドバーに揃える
-- 元の表示は "claude · working · dotfiles" (種別・状態・cwd 末尾) で、同じ repo の claude が並ぶと区別がつかない。
-- サイドバーと同じ作業タイトル (terminal_title_stripped) とタブ番号を出し、並びもタブ順にする
-- (元はアイコン付きのタイトル順で、状態が変わるたびに並びが入れ替わる)。
-- herdr-nvim の内部モジュールを使っているので、プラグイン更新で壊れる可能性がある
local function sidebar_like_picker()
  local agents = require "herdr-nvim.agents"
  local list = agents.list

  local function herdr_json(args)
    local r = vim.system(vim.list_extend({ vim.env.HERDR_BIN_PATH or "herdr" }, args), { text = true }):wait()
    if r.code ~= 0 then
      return nil
    end
    local ok, decoded = pcall(vim.json.decode, r.stdout)
    return ok and type(decoded) == "table" and decoded.result or nil
  end

  agents.list = function(...)
    local out, err = list(...)
    if not out or require("herdr-nvim.exec").is_app() then
      return out, err
    end
    local raw, tabs = {}, {}
    for _, a in ipairs((herdr_json { "agent", "list" } or {}).agents or {}) do
      raw[a.pane_id] = a
    end
    for _, t in ipairs((herdr_json { "tab", "list" } or {}).tabs or {}) do
      tabs[t.tab_id] = t
    end
    for _, a in ipairs(out) do
      local r, t = raw[a.pane_id] or {}, tabs[a.tab_id] or {}
      a.title_stripped = r.terminal_title_stripped or r.name or a.kind
      a.tab_label = t.label
      a.tab_number = t.number or math.huge
    end
    table.sort(out, function(x, y)
      if x.tab_number ~= y.tab_number then
        return x.tab_number < y.tab_number
      end
      return x.pane_id < y.pane_id
    end)
    return out
  end

  local display = agents.display
  agents.display = function(agent)
    if not agent.title_stripped then
      return display(agent)
    end
    local here = agent.tab_id == vim.env.HERDR_TAB_ID and " (this tab)" or ""
    return string.format("%s · %s · tab %s%s", agent.title_stripped, agent.status, agent.tab_label or "?", here)
  end
end

function M.config()
  -- キーマップはデフォルトの <leader>a (ac / al / as / aS / ai)
  require("herdr-nvim").setup {}
  require("herdr-nvim.prompt").format = format_prompt
  focus_after_send()
  sidebar_like_picker()
  vim.keymap.set("n", "<leader>af", send_file, { desc = "herdr-nvim: send file to agent" })
end

return M
