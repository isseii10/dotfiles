-- Tracks fyler.nvim's latest commit (no `commit` pin) to try out upstream
-- changes before bumping the pinned version in user.fyler. The repo moved
-- to FylerOrg/fyler.nvim and its config schema was rewritten wholesale
-- (kind/kind_presets/extensions/mappings), so this is not a copy of the
-- pinned config — see https://github.com/FylerOrg/fyler.nvim for the
-- current README/config.lua before touching this again.
-- Disable user.fyler in init.lua while this is active to avoid duplicate
-- <leader>e keymaps from two specs pointing at the same plugin.
local M = {
  "FylerOrg/fyler.nvim",
  name = "fyler-latest.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = { "<leader>e" },
}

function M.config()
  local fyler = require "fyler"
  local icons = require "user.icons"

  vim.keymap.set("n", "<leader>e", function()
    fyler.toggle()
  end, { noremap = true, silent = true, desc = "Toggle Fyler" })

  fyler.setup {
    -- Always open as a floating window instead of the new default (replace).
    kind = "floating",
    kind_presets = {
      floating = {
        border = "rounded",
        width = "70%",
        height = "70%",
        row = "center",
        col = "center",
      },
    },
    integrations = {
      icon = "nvim_web_devicons",
    },
    extensions = {
      git = {
        enabled = true,
        -- Default icons are plain ASCII (*, +, ?, -) which look out of
        -- place next to the nerd-font icons used everywhere else (see
        -- gitsigns/icons.lua). Reuse the same icon set here, keyed by
        -- git porcelain status codes (see `git status --porcelain`).
        icons = {
          [" M"] = { icon = icons.git.FileModified, hl = "FylerGitModified" },
          ["M "] = { icon = icons.git.FileModified, hl = "FylerGitStaged" },
          ["MM"] = { icon = icons.git.FileModified, hl = "FylerGitStaged" },
          ["??"] = { icon = icons.git.FileUntracked, hl = "FylerGitUntracked" },
          [" D"] = { icon = icons.git.FileDeleted, hl = "FylerGitDeleted" },
          ["D "] = { icon = icons.git.FileDeleted, hl = "FylerGitStaged" },
          ["R "] = { icon = icons.git.FileRenamed, hl = "FylerGitRenamed" },
          ["UU"] = { icon = icons.git.FileUnmerged, hl = "FylerGitConflict" },
          -- NOTE: this never fires. The extension runs `git status
          -- --porcelain -z` without `--ignored`, so git never emits `!!`
          -- entries — intentional upstream perf tradeoff, not something
          -- fixable from config. See
          -- https://github.com/FylerOrg/fyler.nvim/issues/351
          ["!!"] = { icon = icons.git.FileIgnored, hl = "FylerGitIgnored" },
        },
      },
    },
    hooks = {
      on_highlight = function(highlight_groups, palette)
        highlight_groups.FylerDirectoryName = { fg = palette.blue }
        highlight_groups.FylerDirectoryIcon = { fg = palette.blue }

        -- fyler's built-in FylerGit* defaults are hardcoded Onedark-ish
        -- hex values that clash with the active colorscheme. Link them to
        -- standard highlight groups instead so they follow the theme like
        -- everything else. Setting these here (before the git extension's
        -- own `default`-flagged highlights run) wins, since `default = true`
        -- highlights don't override groups that are already defined.
        highlight_groups.FylerGitConflict = { link = "DiagnosticError" }
        highlight_groups.FylerGitDeleted = { link = "DiagnosticError" }
        highlight_groups.FylerGitIgnored = { link = "Comment" }
        highlight_groups.FylerGitModified = { link = "DiagnosticWarn" }
        highlight_groups.FylerGitRenamed = { fg = palette.blue }
        highlight_groups.FylerGitStaged = { link = "DiagnosticOk" }
        highlight_groups.FylerGitUntracked = { link = "Operator" }
      end,
    },
    -- Don't hijack netrw / directory buffers; open explicitly via <leader>e.
    use_as_default_explorer = false,
    follow_current_file = true,
    ui = {
      -- The "dotfiles" switch is enabled by default, hiding dotfiles.
      -- Clearing it shows hidden files from the start (toggle with `g.`).
      hidden_items = { switches = {} },
    },
  }
end

return M
