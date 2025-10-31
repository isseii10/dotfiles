-- runtimeのftplugin/markdown.vimに上書きされるので、再度ftpluginで上書き
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

vim.opt_local.comments = {
  "nb:>",
  -- チェックボックスパターンを先に（より具体的なパターンを優先）
  "b:- [ ]",
  "b:- [x]",
  "b:+ [ ]",
  "b:+ [x]",
  "b:* [ ]",
  "b:* [x]",
  "b:1. [ ]",
  "b:1. [x]",
  -- 通常の箇条書きパターンを後に
  "b:-",
  "b:+",
  "b:*",
  "b:1.",
}

-- formatoptions settings
vim.opt_local.formatoptions:remove "c" -- Disable auto-wrap for comments
vim.opt_local.formatoptions:append "jro" -- Join comments, auto-wrap on insert, and continue comments
