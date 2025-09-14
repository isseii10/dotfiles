local M = {
  "obsidian-nvim/obsidian.nvim",
  -- version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  cmd = {
    "Obsidian",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
}

function M.config()
  require("obsidian").setup {
    legacy_commands = false,
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
      default_tags = {},
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },
    checkbox = {
      order = {
        " ",
        "x",
        -- ">",
        -- "~",
        -- "!",
      },
    },
    -- Optional, alternatively you can customize the frontmatter data.
    ---@return table
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end

      local out = {
        id = note.id,
        aliases = note.aliases,
        tags = note.tags,
      }

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,
  }

  require("which-key").add {
    {
      "<leader>o",
      group = "Obsidian",
    },
    {
      "<leader>oo",
      "<cmd>Obsidian open<cr>",
      desc = "open obsidian",
    },
    {
      "<leader>on",
      "<cmd>Obsidian new<cr>",
      desc = "new note",
    },
    {
      "<leader>ot",
      "<cmd>Obsidian tags<cr>",
      desc = "tags",
    },
    {
      "<leader>ob",
      "<cmd>Obsidian backlinks<CR>",
      desc = "backlinks",
    },
    {
      "<leader>od",
      "<cmd>Obsidian today<cr>",
      desc = "today's daily notes",
    },
    {
      "<leader>op",
      "<cmd>Obsidian paste_img<cr>",
      desc = "past image from clipboard",
    },
  }
end

return M
