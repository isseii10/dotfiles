local M = {
  "smart-splits-nvim/smart-splits.nvim",
  event = "VeryLazy",
  dependencies = {
    -- v3 moved multiplexer support out of core. Each backend also needs its
    -- multiplexer-side plugin (herdr/config.toml, wezterm/smart-split.lua).
    { "adriankarlen/smart-splits-backend-herdr", main = "smart-splits-backend-herdr", opts = {} },
    { "smart-splits-nvim/backend-wezterm", main = "smart-splits-backend-wezterm", opts = {} },
  },
}

function M.config()
  -- Everything else is left at v3's defaults (resize.amount = 3,
  -- move.at_edge = "wrap", move.float = "previous", ...), see
  -- :h smart-splits-configuration.
  require("smart-splits").setup {
    -- herdr first: it's the inner multiplexer when running inside WezTerm.
    mux = { backend = { "smart-splits-backend-herdr", "smart-splits-backend-wezterm" } },
  }

  -- herdr-nvim のサイドバーは、裏で動き続けるデーモン nvim に `--remote-ui` で
  -- 画面だけつなぐ作り。デーモンの $HERDR_PANE_ID は最初にサイドバーを開いたときの
  -- ペインのままなので、サイドバーを開き直す (ペイン ID が変わる) と smart-splits が
  -- 消えたペインを基準に移動しようとして、右の herdr ペインへ抜けられなくなる。
  -- UI がつながるたびに、今のタブの "nvim sidebar" ペインの ID に差し替える
  -- (backend は呼ばれるたびに vim.env.HERDR_PANE_ID を読み直す)。
  if vim.env.HERDR_PLUGIN_ID == "chmarax.herdr-nvim" and vim.env.HERDR_TAB_ID then
    -- vim.system のコールバックは fast event なので vim.env を読めない。先に読んでおく
    local tab_id = vim.env.HERDR_TAB_ID
    local herdr = vim.env.HERDR_BIN_PATH or "herdr"
    local function refresh_herdr_pane_id()
      vim.system({ herdr, "pane", "list" }, { text = true }, function(res)
        if res.code ~= 0 then
          return
        end
        local ok, decoded = pcall(vim.json.decode, res.stdout)
        if not ok or type(decoded) ~= "table" or not decoded.result then
          return
        end
        for _, pane in ipairs(decoded.result.panes or {}) do
          if pane.tab_id == tab_id and pane.label == "nvim sidebar" then
            vim.schedule(function()
              vim.env.HERDR_PANE_ID = pane.pane_id
              -- prefix+o (pick-file) から起動したデーモンは、起動時に HERDR_PANE_ID が
              -- なく backend の検出に失敗する。smart-splits は検出結果を最初の1回で
              -- キャッシュするので、herdr を掴めていなければ ID を入れた後でやり直させる
              local backend = require "smart-splits.backend"
              if not backend.resolve() then
                backend.reset()
                backend.resolve()
              end
            end)
            return
          end
        end
      end)
    end
    vim.api.nvim_create_autocmd("UIEnter", { callback = refresh_herdr_pane_id })
    refresh_herdr_pane_id()
  end

  local function is_floating()
    return vim.api.nvim_win_get_config(0).relative ~= ""
  end

  -- recommended mappings
  -- resizing splits
  -- these keymaps will also accept a range,
  -- for example `10<A-h>` will `resize_left` by `(10 * resize.amount)`
  vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
  vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
  vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
  vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
  -- moving between splits
  vim.keymap.set("n", "<C-h>", function()
    if is_floating() then
      vim.cmd "wincmd h"
    else
      require("smart-splits").move_cursor_left()
    end
  end)
  vim.keymap.set("n", "<C-j>", function()
    if is_floating() then
      vim.cmd "wincmd j"
    else
      require("smart-splits").move_cursor_down()
    end
  end)
  vim.keymap.set("n", "<C-k>", function()
    if is_floating() then
      vim.cmd "wincmd k"
    else
      require("smart-splits").move_cursor_up()
    end
  end)
  vim.keymap.set("n", "<C-l>", function()
    if is_floating() then
      vim.cmd "wincmd l"
    else
      require("smart-splits").move_cursor_right()
    end
  end)
  -- vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
  -- swapping buffers between windows
  vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
  vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
  vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
  vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
end

return M
