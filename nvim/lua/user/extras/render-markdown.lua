local M = {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "Avante" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    bullet = {
      -- right_pad = 1,
    },
    pipe_table = {
      head = "RenderMarkdownTableHead",
      row = "RenderMarkdownTableRow",
      filler = "RenderMarkdownTableRow",
    },
  },
}

return M
