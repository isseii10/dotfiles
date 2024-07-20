local M = {
  "j-hui/fidget.nvim",
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  require("fidget").setup {
    -- options related to lsp progress subsystem
    progress = {
      poll_rate = 0,                -- how and when to poll for progress messages
      suppress_on_insert = false,   -- suppress new messages while in insert mode
      ignore_done_already = false,  -- ignore new tasks that are already complete
      ignore_empty_message = false, -- ignore new tasks that don't contain a message
      -- clear notification group when lsp server detaches
      clear_on_detach = function(client_id)
        local client = vim.lsp.get_client_by_id(client_id)
        return client and client.name or nil
      end,
      -- how to get a progress message's notification group key
      notification_group = function(msg)
        return msg.lsp_client.name
      end,
      ignore = {}, -- list of lsp servers to ignore

      -- options related to how lsp progress messages are displayed as notifications
      display = {
        render_limit = 16, -- how many lsp messages to show at once
        done_ttl = 3, -- how long a message should persist after completion
        done_icon = "✔", -- icon shown when all lsp progress tasks are complete
        done_style = "constant", -- highlight group for completed lsp tasks
        progress_ttl = math.huge, -- how long a message should persist when in progress
        -- icon shown when lsp progress tasks are in progress
        progress_icon = { pattern = "dots", period = 1 },
        -- highlight group for in-progress lsp tasks
        progress_style = "warningmsg",
        group_style = "title",   -- highlight group for group name (lsp server name)
        icon_style = "question", -- highlight group for group icons
        priority = 30,           -- ordering priority for lsp notification group
        skip_history = true,     -- whether progress notifications should be omitted from history
        -- how to format a progress message
        format_message = require("fidget.progress.display").default_format_message,
        -- how to format a progress annotation
        format_annote = function(msg)
          return msg.title
        end,
        -- how to format a progress notification group's name
        format_group_name = function(group)
          return tostring(group)
        end,
        overrides = { -- override options from the default notification config
          rust_analyzer = { name = "rust-analyzer" },
        },
      },

      -- options related to neovim's built-in lsp client
      lsp = {
        progress_ringbuf_size = 0, -- configure the nvim's lsp progress ring buffer size
        log_handler = false,       -- log `$/progress` handler invocations (for debugging)
      },
    },
    -- Options related to notification subsystem
    notification = {
      poll_rate = 10,               -- How frequently to update and render notifications
      filter = vim.log.levels.INFO, -- Minimum notifications level
      history_size = 128,           -- Number of removed messages to retain in history
      override_vim_notify = false,  -- Automatically override vim.notify() with Fidget
      -- How to configure notification groups when instantiated
      configs = { default = require("fidget.notification").default_config },
      -- Conditionally redirect notifications to another backend
      redirect = function(msg, level, opts)
        if opts and opts.on_open then
          return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
        end
      end,

      -- Options related to how notifications are rendered as text
      view = {
        stack_upwards = true,    -- Display notification items from bottom to top
        icon_separator = " ",    -- Separator between group name and icon
        group_separator = "---", -- Separator between notification groups
        -- Highlight group used for group separator
        group_separator_hl = "Comment",
        -- How to render notification messages
        render_message = function(msg, cnt)
          return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
        end,
      },

      -- Options related to the notification window and buffer
      window = {
        normal_hl = "Comment", -- Base highlight group in the notification window
        winblend = 0,        -- Background color opacity in the notification window
        border = "none",       -- Border around the notification window
        zindex = 45,           -- Stacking priority of the notification window
        max_width = 0,         -- Maximum width of the notification window
        max_height = 0,        -- Maximum height of the notification window
        x_padding = 1,         -- Padding from right edge of window boundary
        y_padding = 0,         -- Padding from bottom edge of window boundary
        align = "bottom",      -- How to align the notification window
        relative = "editor",   -- What the notification window position is relative to
      },
    },
  }
end

return M
