local INSTANCES = 4

-- Resolves the real executable behind `name`, skipping mise shims: a mise
-- shim dispatches by its own basename, so a symlink pointing at the shim
-- under a different name (e.g. claude1) fails with "not a valid shim".
-- Walking $PATH and following each candidate to its final realpath finds
-- the actual binary mise would have execed.
local function resolve_real_exe(name)
  for dir in vim.gsplit(vim.env.PATH or "", ":", { plain = true }) do
    if dir ~= "" then
      local candidate = vim.fs.joinpath(dir, name)
      if vim.fn.executable(candidate) == 1 then
        local real = vim.uv.fs_realpath(candidate) or candidate
        if vim.fs.basename(real) ~= "mise" then
          return real
        end
      end
    end
  end
  return vim.fn.exepath(name)
end

-- Registers <base>1..<base>N as distinct sidekick tools so multiple sessions
-- of the same CLI can run concurrently for the same cwd. sidekick keys
-- sessions by `tool.name + cwd`, and its tmux discovery matches running
-- panes by `is_proc` against the process name — sharing one binary across
-- entries would make discovery ambiguous. Symlinking a uniquely named binary
-- per slot (~/.local/bin/claude1, claude2, ...) gives each instance its own
-- process name, so is_proc pattern matching stays unambiguous.
-- https://github.com/folke/sidekick.nvim/discussions/208
local function register_tool_instances(tools, base_name, count)
  local base = require("sidekick.config").get_tool(base_name).config
  local base_exe = base.cmd and base.cmd[1]
  local base_exepath = base_exe and resolve_real_exe(base_exe) or ""
  if base_exepath == "" then
    return
  end

  local bin_dir = vim.fn.expand "~/.local/bin"
  for i = 1, count do
    local name = base_name .. i
    local dest = vim.fs.joinpath(bin_dir, name)
    if vim.uv.fs_readlink(dest) ~= base_exepath then
      vim.uv.fs_unlink(dest)
      vim.uv.fs_symlink(base_exepath, dest)
    end

    local tool = vim.deepcopy(base)
    tool.cmd = { name }
    tool.is_proc = "\\<" .. name .. "\\>"
    tools[name] = tool
  end
end

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
          width = 0.4, -- set to 0 for default split width
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
  },
  config = function(_, opts)
    opts.cli = opts.cli or {}
    opts.cli.tools = opts.cli.tools or {}
    register_tool_instances(opts.cli.tools, "claude", INSTANCES)
    register_tool_instances(opts.cli.tools, "codex", INSTANCES)
    require("sidekick").setup(opts)

    -- sidekick ships defaults for many CLI tools (aider, copilot, gemini, ...)
    -- and setup() deep-merges rather than replaces, so they'd still show up
    -- in pickers/discovery even though we never asked for them. Prune down
    -- to just Claude and Codex (base + numbered instances).
    local Config = require "sidekick.config"
    for name in pairs(Config.cli.tools) do
      if not name:match "^claude%d*$" and not name:match "^codex%d*$" then
        Config.cli.tools[name] = nil
      end
    end
  end,
}
