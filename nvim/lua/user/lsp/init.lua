-- NOTE: lsp関連の設定をここで行う

-- lspキーマップの設定
local function add_desc(opts, desc)
  opts.desc = desc
  return opts
end
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
keymap("n", "gD", vim.lsp.buf.declaration, add_desc(opts, "go to declaration"))
keymap("n", "gd", vim.lsp.buf.definition, add_desc(opts, "go to definition"))
keymap("n", "<leader>k", vim.lsp.buf.hover, add_desc(opts, "hover symbol"))
keymap("n", "gi", vim.lsp.buf.implementation, add_desc(opts, "go to inplementation"))
keymap("n", "gr", vim.lsp.buf.references, add_desc(opts, "go to references"))
keymap("n", "gl", vim.diagnostic.open_float, add_desc(opts, "open float diagnostic"))
keymap("n", "lr", vim.lsp.buf.rename, add_desc(opts, "rename symbol"))

-- diagnosticの設定
local icons = require "user.icons"
local default_diagnostic_config = {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticError",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    },
  },
  virtual_text = false,
  update_in_insert = false,
  underline = true,
  virtual_lines = {
    severity = {},
    format = nil,
  },
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}
vim.diagnostic.config(default_diagnostic_config)

-- afterディレクトリのlsp設定を読み込む
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
