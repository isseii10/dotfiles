local M = {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  require("hlchunk").setup {
    chunk = {
      enable=true,
    }
  }
end

return M
