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
    -- 既定の hide はノーマルモードでフェンスの行ごと隠す (conceal_lines)。
    -- snacks.image は閉じフェンスの行に mermaid の図を付けるので、行が隠れると図も消える
    code = {
      border = "thin",
    },
    pipe_table = {
      head = "RenderMarkdownTableHead",
      row = "RenderMarkdownTableRow",
    },
  },
}

return M
