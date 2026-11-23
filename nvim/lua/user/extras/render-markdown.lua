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
  config = function(_, opts)
    require("render-markdown").setup(opts)

    -- Obsidian のブロック参照の目印（行末の " ^abcd"）を conceal で隠す。
    -- render-markdown には目印を扱う機能がないため、ウィンドウごとに matchadd する。
    -- conceallevel は render-markdown が描画中だけ上げるので、挿入モードでは見える
    -- match はウィンドウに付くので、同じウィンドウで markdown 以外を開いたら外す
    local function update()
      local id = vim.w.user_block_id_match
      if vim.bo.filetype == "markdown" then
        if not id then
          vim.w.user_block_id_match = vim.fn.matchadd("Conceal", [[\s\^[A-Za-z0-9-]\+$]], 10, -1, { conceal = "" })
        end
      elseif id then
        pcall(vim.fn.matchdelete, id)
        vim.w.user_block_id_match = nil
      end
    end
    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
      group = vim.api.nvim_create_augroup("user_markdown_block_id", { clear = true }),
      callback = update,
    })
    update()
  end,
}

return M
