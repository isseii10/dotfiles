return {
  "folke/sidekick.nvim",
  opts = {
    -- add any options here
    cli = {
      win = {
        --- This is run when a new terminal is created, before starting it.
        --- Here you can change window options `terminal.opts`.
        ---@param terminal sidekick.cli.Terminal
        config = function(terminal) end,
        wo = {}, ---@type vim.wo
        bo = {}, ---@type vim.bo
        layout = "right", ---@type "float"|"left"|"bottom"|"top"|"right"
        --- Options used when layout is "float"
        ---@type vim.api.keyset.win_config
        float = {
          width = 0.9,
          height = 0.9,
        },
        -- Options used when layout is "left"|"bottom"|"top"|"right"
        ---@type vim.api.keyset.win_config
        split = {
          width = 0.3, -- set to 0 for default split width
          height = 0, -- set to 0 for default split height
        },
        --- CLI Tool Keymaps (default mode is `t`)
        ---@type table<string, sidekick.cli.Keymap|false>
        keys = {
          buffers = { "<c-b>", "buffers", mode = "nt", desc = "open buffer picker" },
          files = { "<c-f>", "files", mode = "nt", desc = "open file picker" },
          hide_n = { "q", "hide", mode = "n", desc = "hide the terminal window" },
          hide_ctrl_q = { "<c-q>", "hide", mode = "n", desc = "hide the terminal window" },
          hide_ctrl_dot = { "<c-.>", "hide", mode = "nt", desc = "hide the terminal window" },
          hide_ctrl_z = { "<c-z>", "hide", mode = "nt", desc = "hide the terminal window" },
          prompt = { "<c-p>", "prompt", mode = "t", desc = "insert prompt or context" },
          stopinsert = { "<c-q>", "stopinsert", mode = "t", desc = "enter normal mode" },
          -- Navigate windows in terminal mode. Only active when:
          -- * layout is not "float"
          -- * there is another window in the direction
          -- With the default layout of "right", only `<c-h>` will be mapped
          nav_left = { "<c-h>", "nav_left", expr = true, desc = "navigate to the left window" },
          nav_down = { "<c-j>", "nav_down", expr = true, desc = "navigate to the below window" },
          nav_up = { "<c-k>", "nav_up", expr = true, desc = "navigate to the above window" },
          nav_right = { "<c-l>", "nav_right", expr = true, desc = "navigate to the right window" },
        },
        ---@type fun(dir:"h"|"j"|"k"|"l")?
        --- Function that handles navigation between windows.
        --- Defaults to `vim.cmd.wincmd`. Used by the `nav_*` keymaps.
        nav = nil,
      },
      mux = {
        backend = "tmux",
        enabled = true,
      },
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send { msg = "{this}" }
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send { msg = "{file}" }
      end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send { msg = "{selection}" }
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    -- Example of a keybinding to open Claude directly
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle { name = "claude", focus = true }
      end,
      desc = "Sidekick Toggle Claude",
    },
  },
}
