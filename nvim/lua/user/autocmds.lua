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
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":close<CR>", { noremap = true, silent = true })
    vim.bo.buflisted = false
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
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
  callback = function()
    vim.opt_local.wrap = true
    -- vim.opt_local.spell = true
    -- vim.opt_local.spelllang = {"en", "cjk"}
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
      "Float",
      "FloatBorder",
      "SignColumn",
      "EndOfBuffer",
      "MsgArea",
      "WinBar",
      "WinBarNC",
      "Pmenu",
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

-- nvim-treeでルートディレクトリをバーチャルテキストで表示する
vim.api.nvim_create_autocmd("WinScrolled", {
  pattern = "*",
  callback = function()
    require("user.nvimtree.user-functions").display_dir_name()
  end,
})
