local M = {
  "isseii10/nvim-dbee",
  branch = "fix/mysql_adapter_get_helpers",
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
        s.EnvSource:new "DBEE_CONNECTIONS",
        s.FileSource:new(vim.fn.stdpath "cache" .. "/dbee/persistence.json"),
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
