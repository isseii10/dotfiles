-- NOTE: このファイルでLSPのセットアップを一元管理する

local function obsidian_workspace_roots()
  local roots = vim.g.obsidian_workspace_roots
  if type(roots) == "table" and not vim.tbl_isempty(roots) then
    return roots
  end
  return { vim.fs.normalize(vim.fn.expand "~/obsidian") }
end

local function is_obsidian_file(path)
  if not path or path == "" then
    return false
  end
  local normalized_path = vim.fs.normalize(path)
  for _, root in ipairs(obsidian_workspace_roots()) do
    if type(root) == "string" and root ~= "" then
      local normalized_root = vim.fs.normalize(root)
      if normalized_path == normalized_root or vim.startswith(normalized_path, normalized_root .. "/") then
        return true
      end
    end
  end
  return false
end

-- lspキーマップの設定
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    if client.name == "markdown_oxide" and is_obsidian_file(vim.api.nvim_buf_get_name(bufnr)) then
      vim.schedule(function()
        vim.lsp.stop_client(client.id)
      end)
      return
    end
    -- All the keymaps
    local keymap = vim.keymap.set
    local lsp = vim.lsp
    local function add_desc(opts, desc)
      opts.desc = desc
      return opts
    end
    local opts = { noremap = true, silent = true, buffer = bufnr }
    keymap("n", "gD", vim.lsp.buf.declaration, add_desc(opts, "go to declaration"))
    keymap("n", "gd", vim.lsp.buf.definition, add_desc(opts, "go to definition"))
    keymap("n", "<leader>k", vim.lsp.buf.hover, add_desc(opts, "hover symbol"))
    keymap("n", "gi", vim.lsp.buf.implementation, add_desc(opts, "go to inplementation"))
    keymap("n", "gr", vim.lsp.buf.references, add_desc(opts, "go to references"))
    keymap("n", "gl", vim.diagnostic.open_float, add_desc(opts, "open float diagnostic"))
    keymap("n", "<leader>lr", vim.lsp.buf.rename, add_desc(opts, "rename symbol"))
    keymap("n", "<Leader>lh", function()
      lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled {})
    end, add_desc(opts, "Toggle Inlayhints"))
    keymap("n", "<Leader>li", vim.cmd.LspInfo, add_desc(opts, "LspInfo"))
    keymap("n", "<Leader>ll", lsp.codelens.run, add_desc(opts, "Run CodeLens"))
    keymap("n", "<Leader>ls", lsp.buf.document_symbol, add_desc(opts, "Doument Symbols"))
  end,
})

-- afterディレクトリのlsp設定を読み込む
-- NOTE: nvim-lspconfigのデフォルトのlsp設定をカスタムしたい場合はafterディレクトリに設定ファイルを置く
local dirname = vim.fn.stdpath "config" .. "/after/lsp"

local servers = {}

for file, ftype in vim.fs.dir(dirname) do
  -- `.lua`で終わるファイルを処理（init.luaは除く）
  if ftype == "file" and vim.endswith(file, ".lua") and file ~= "init.lua" then
    -- 拡張子を除いてlsp名を作る
    local lsp_name = file:sub(1, -5) -- fname without '.lua'
    -- 読み込む
    local ok, result = pcall(dofile, dirname .. "/" .. file)
    if ok then
      vim.lsp.config(lsp_name, result)
      table.insert(servers, lsp_name)
    else
      vim.notify("Error loading LSP: " .. lsp_name .. "\n" .. result, vim.log.levels.WARN)
    end
  end
end

vim.lsp.enable(servers)

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
  virtual_lines = false,
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
