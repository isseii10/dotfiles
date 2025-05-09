local M = {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

function M.config()
  require("obsidian").setup {
    -- A list of workspace names, paths, and configuration overrides.
    -- If you use the Obsidian app, the 'path' of a workspace should generally be
    -- your vault root (where the `.obsidian` folder is located).
    -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
    -- the workspace to the first workspace in the list whose `path` is a parent of the
    -- current markdown file being edited.
    workspaces = {
      {
        name = "obsidian",
        path = "~/obsidian/",
      },
    },
    daily_notes = {
      folder = "daily_notes",
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },
    ui = {
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        -- [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        -- ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        -- ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },
    },
  }

  require("which-key").add {
    {
      "<leader>o",
      group = "Obsidian",
    },
    {
      "<leader>oo",
      "<cmd>ObsidianOpen<cr>",
      desc = "open obsidian",
    },
    {
      "<leader>on",
      "<cmd>ObsidianNew<cr>",
      desc = "new note",
    },
    {
      "<leader>ot",
      "<cmd>ObsidianTags<cr>",
      desc = "tags",
    },
    {
      "<leader>ob",
      "<cmd>ObsidianBacklinks<CR>",
      desc = "backlinks",
    },
    {
      "<leader>od",
      "<cmd>ObsidianToday<cr>",
      desc = "today's daily notes",
    },
    {
      "<leader>op",
      "<cmd>ObsidianPasteImg<cr>",
      desc = "past image from clipboard",
    },
  }
end

return M
