local M = {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    bullet = {
      right_pad = 1,
    },
    -- 状態の種類は obsidian.lua の checkbox.order と合わせる
    checkbox = {
      custom = {
        -- 既定の todo ([-]) を中止に置き換える
        todo = {
          raw = "[-]",
          rendered = "󰜺 ",
          highlight = "Comment",
          scope_highlight = "@markup.strikethrough",
        },
        progress = {
          raw = "[~]",
          rendered = "󰔟 ",
          highlight = "RenderMarkdownWarn",
        },
      },
    },
    pipe_table = {
      head = "RenderMarkdownTableHead",
      row = "RenderMarkdownTableRow",
      filler = "RenderMarkdownTableRow",
    },
  },
}

return M
