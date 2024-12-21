local M = {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  config = function()
    local dbee = require "dbee"
    local s = require "dbee.sources"
    dbee.setup {
      sources = {
        s.MemorySource:new {
          {
            name = "demo",
            url = "user:user@tcp(127.0.0.1:3306)/demo",
            type = "mysql",
          },
        },
      },
    }
  end,
}

-- dbee起動時はbufferlineを非表示にする
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbee",
  callback = function()
    vim.cmd "setlocal showtabline=0" -- タブラインを非表示
  end,
})

return M
