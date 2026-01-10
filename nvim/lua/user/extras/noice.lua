local M = {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
  },
}

M.opts = {
  lsp = {
    progress = {
      -- NOTE: 'progress' replace j-hui/fidget.nvim
      enabled = true,
      -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
      -- See the section on formatting for more details on how to customize.
      --- @type NoiceFormat|string
      format = "lsp_progress",
      --- @type NoiceFormat|string
      format_done = "lsp_progress_done",
      throttle = 1000 / 30, -- frequency to update lsp progress message
      view = "mini",
    },
    signature = {
      -- NOTE: 'signature' replace ray-x/lsp_signature.nvim
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
        luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
        throttle = 50, -- Debounce lsp signature help request by 50ms
      },
      view = nil, -- when nil, use defaults from documentation
      ---@type NoiceViewOptions
      opts = {}, -- merged with defaults from documentation
    },
  },
  ---@type NoicePresets
  presets = {
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
  ---@type NoiceConfigViews
  views = {
    cmdline_popup = {
      position = {
        row = "40%",
        col = "50%",
      },
      size = {
        width = 60,
        height = "auto",
      },
    },
  }, ---@see section on views
}

return M
