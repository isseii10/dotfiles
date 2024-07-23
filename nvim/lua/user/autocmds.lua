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

-- vim.api.nvim_create_autocmd({ "CursorHold" }, {
--   callback = function()
--     local status_ok, luasnip = pcall(require, "luasnip")
--     if not status_ok then
--       return
--     end
--     if luasnip.expand_or_jumpable() then
--       -- ask maintainer for option to make this silent
--       -- luasnip.unlink_current()
--       vim.cmd [[silent! lua require("luasnip").unlink_current()]]
--     end
--   end,
-- })

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#ed6d35", bold = true, underline = true })
    vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#ffae8a", underline = true })
    local hl_groups = {
      "Normal",
      "SignColumn",
      "NormalNC",
      "TelescopeBorder",
      "NvimTreeNormal",
      "NvimTreeNormalNC",
      "NeoTreeNormal",
      "NeoTreeNormalNC",
      "EndOfBuffer",
      "MsgArea",
      "Winbar",
      -- "BufferOffset", -- barbar
    }
    for _, name in ipairs(hl_groups) do
      vim.cmd(string.format("highlight %s ctermbg=none guibg=none", name))
    end
  end,
})
