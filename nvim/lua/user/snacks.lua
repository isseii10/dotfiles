-- snacks.nvim
-- - image: markdown の画像と mermaid のコードブロックを、バッファ内に画像として表示する
--   mermaid の変換は mmdc、画像の変換は magick を使う (どちらも home.nix で入れている)
-- - terminal / lazygit: float のターミナルと lazygit

-- 埋め込み表示をバッファごとに on / off する。
-- snacks には埋め込みを後から止める API がないので、vim.b.snacks_image_off が立っている間は
-- 埋め込みの描画 (snacks.image.inline の update / conceal) を止める
local function patch_inline()
  local Inline = require "snacks.image.inline"
  for _, name in ipairs { "update", "conceal" } do
    local orig = Inline[name]
    Inline[name] = function(self, ...)
      if vim.b[self.buf].snacks_image_off then
        return
      end
      return orig(self, ...)
    end
  end
end

local function toggle_images()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b[buf].snacks_image_off then
    vim.b[buf].snacks_image_off = nil
    -- 埋め込みの update を走らせ直す (snacks.image.inline が BufWinEnter で update する)
    pcall(vim.api.nvim_exec_autocmds, "BufWinEnter", { group = "snacks.image.inline." .. buf, buffer = buf })
    vim.notify("image: on", vim.log.levels.INFO)
  else
    vim.b[buf].snacks_image_off = true
    Snacks.image.placement.clean(buf)
    vim.notify("image: off", vim.log.levels.INFO)
  end
end

local function toggle_terminal()
  Snacks.terminal.toggle(nil, { win = { position = "float", border = "rounded" } })
end

-- lazygit の float を隠してメインウィンドウにフォーカスを移す。lazygit は裏で動かしたままにする
-- lazygit/config.yml の os.edit から --remote-expr 経由で呼ばれる
function SwitchFromLazygit()
  for _, term in ipairs(Snacks.terminal.list()) do
    local cmd = type(term.cmd) == "table" and term.cmd[1] or term.cmd
    if cmd == "lazygit" then
      term:hide()
    end
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      vim.api.nvim_set_current_win(win)
      break
    end
  end
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    -- snacks はターミナル名で画像に対応しているかを決めるが、herdr は一覧にないので描かない。
    -- herdr は Kitty graphics の unicode placeholder も通すので、ghostty として扱わせてバッファ内に描かせる
    if vim.env.TERM_PROGRAM == "herdr" and not vim.env.SNACKS_GHOSTTY and not vim.env.SNACKS_WEZTERM then
      vim.env.SNACKS_GHOSTTY = "1"
    end
  end,
  ---@type snacks.Config
  opts = {
    image = {
      enabled = true,
      doc = {
        -- ghostty / kitty ではコードブロックの下にそのまま描く。wezterm は unicode placeholder に
        -- 対応していないので、カーソルを合わせたときのフロート表示になる
        inline = true,
        float = true,
        max_width = 80,
        max_height = 40,
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    patch_inline()
  end,
  keys = {
    { "<leader>mi", toggle_images, desc = "Toggle inline images" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "lazygit" },
    { "<C-\\>", toggle_terminal, mode = { "n", "i", "t" }, desc = "Toggle terminal" },
  },
}
