vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

-- qで閉じられるようにする
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "netrw",
    "Jaq",
    "qf",
    "git",
    "help",
    "man",
    "lspinfo",
    "oil",
    "spectre_panel",
    "lir",
    "DressingSelect",
    "tsplayground",
    "",
  },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})

-- :qや:<c-f>でCmdWindowが開いたらすぐ閉じる
vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
  callback = function()
    vim.cmd "quit"
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd "checktime"
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 40 }
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    local hl_groups = {
      -- nvim
      "Normal",
      "NormalNC",
      "NormalFloat",
      "FloatBorder",
      "SignColumn",
      "EndOfBuffer",
      "MsgArea",
      "WinBar",
      "WinBarNC",
      -- explorer
      "NvimTreeNormal",
      "NvimTreeNormalNC",
      "NeoTreeNormal",
      "NeoTreeNormalNC",
      -- navic
      "NavicIconsFile",
      "NavicIconsModule",
      "NavicIconsNamespace",
      "NavicIconsPackage",
      "NavicIconsClass",
      "NavicIconsMethod",
      "NavicIconsProperty",
      "NavicIconsField",
      "NavicIconsConstructor",
      "NavicIconsEnum",
      "NavicIconsInterface",
      "NavicIconsFunction",
      "NavicIconsVariable",
      "NavicIconsConstant",
      "NavicIconsString",
      "NavicIconsNumber",
      "NavicIconsBoolean",
      "NavicIconsArray",
      "NavicIconsObject",
      "NavicIconsKey",
      "NavicIconsNull",
      "NavicIconsEnumMember",
      "NavicIconsStruct",
      "NavicIconsEvent",
      "NavicIconsOperator",
      "NavicIconsTypeParameter",
      "NavicText",
      "NavicSeparator",
    }
    for _, name in ipairs(hl_groups) do
      vim.cmd(string.format("highlight %s ctermbg=none guibg=none", name))
    end
  end,
})
