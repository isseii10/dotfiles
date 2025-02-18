-- runtimeのftplugin/markdown.vimに上書きされるので、再度ftpluginで上書き
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

vim.opt_local.comments = {
  "b:*",
  "b:-",
  "b:+",
  "b:1.",
  "nb:>",
  "b:* [ ]",
  "b:* [x]",
  "b:*",
  "b:+ [ ]",
  "b:+ [x]",
  "b:+",
  "b:- [ ]",
  "b:- [x]",
  "b:-",
  "b:1. [ ]",
  "b:1. [x]",
  "b:1.",
}

-- formatoptions settings
vim.opt_local.formatoptions:remove "c" -- Disable auto-wrap for comments
vim.opt_local.formatoptions:append "jro" -- Join comments, auto-wrap on insert, and continue comments
