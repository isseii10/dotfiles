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
  filetypes = { "sql" },
  event = "VeryLazy",
}

function M.config()
  local dbee = require "dbee"
  local s = require "dbee.sources"
  dbee.setup {
    sources = {
      s.EnvSource:new "DBEE_CONNECTIONS",
      s.FileSource:new(vim.fn.stdpath "cache" .. "/dbee/persistence.json"),
    },
    result = {
      page_size = 500,
      focus_result = false,
    },
    window_layout = require("dbee.layouts").Default:new {
      drawer_width = 40, -- default 40
      result_height = 30, -- default 20
      call_log_height = 20, -- default 20
    },
  }
end

-- dbee起動時はbufferlineを非表示にする
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbee",
  callback = function()
    vim.cmd "setlocal showtabline=0" -- タブラインを非表示
  end,
})

return M
