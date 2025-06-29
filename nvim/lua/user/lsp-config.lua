local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/neodev.nvim",
    },
  },
}

local opts = { noremap = true, silent = true }
local function add_desc(opts, desc)
  opts.desc = desc
  return opts
end
local keymap = vim.keymap.set
keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", add_desc(opts, "go to declaration"))
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", add_desc(opts, "go to definition"))
keymap("n", "<leader>k", "<cmd>lua vim.lsp.buf.hover()<CR>", add_desc(opts, "hover symbol"))
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", add_desc(opts, "go to inplementation"))
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", add_desc(opts, "go to references"))
keymap("n", "gl", vim.diagnostic.open_float, add_desc(opts, "open float diagnostic"))
keymap("n", "lr", vim.lsp.buf.rename, add_desc(opts, "rename symbol"))
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

local icons = require "user.icons"

local default_diagnostic_config = {
  signs = {
    active = true,
    values = {
      { name = "DiagnosticSignError", text = icons.diagnostics.Error },
      { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
      { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
      { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
    },
  },
  virtual_text = false,
  update_in_insert = false,
  underline = true,
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
for _, sign in ipairs(default_diagnostic_config.signs.values) do
  vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.name, numhl = "" })
end

return M
