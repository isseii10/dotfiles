local M = {
  "MeanderingProgrammer/render-markdown.nvim",
  -- don't use latest version until this issue is resolved
  -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/351
  commit = "595ac4f7e7c0eaba7bf1d8fd6ec0f6ac91c7e33b",
  ft = { "markdown", "Avante" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    bullet = {
      right_pad = 1,
    },
  },
}

return M
