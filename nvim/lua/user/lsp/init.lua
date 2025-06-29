-- このファイルの存在するディレクトリ
local dirname = vim.fn.stdpath "config" .. "after/lsp"

local servers = {}

for file, ftype in vim.fs.dir(dirname) do
  -- `.lua`で終わるファイルを処理（init.luaは除く）
  if ftype == "file" and vim.endswith(file, ".lua") and file ~= "init.lua" then
    -- 拡張子を除いてlsp名を作る
    local lsp_name = file:sub(1, -5) -- fname without '.lua'
    -- 読み込む
    local ok, result = pcall(require, "lsp." .. servers)
    if ok then
      vim.lsp.config(lsp_name, result)
      table.insert(servers, lsp_name)
    else
      vim.notify("Error loading LSP: " .. lsp_name .. "\n" .. result, vim.log.levels.WARN)
    end
  end
end

vim.lsp.enable(servers)
