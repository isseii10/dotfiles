local workspaces = {
  {
    name = "obsidian",
    path = "~/obsidian/",
  },
}

local M = {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
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
  vim.g.obsidian_workspace_roots = vim.tbl_map(function(workspace)
    return vim.fs.normalize(vim.fn.expand(workspace.path))
  end, workspaces)

  require("obsidian").setup {
    legacy_commands = false,
    -- A list of workspace names, paths, and configuration overrides.
    -- If you use the Obsidian app, the 'path' of a workspace should generally be
    -- your vault root (where the `.obsidian` folder is located).
    -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
    -- the workspace to the first workspace in the list whose `path` is a parent of the
    -- current markdown file being edited.
    workspaces = workspaces,
    daily_notes = {
      folder = "daily_notes",
      default_tags = {},
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
    frontmatter = {
      -- literature_notes の出典用項目も含めて並び順を固定する（該当キーがないノートには影響しない）
      sort = { "id", "aliases", "type", "source", "author", "status", "date", "tags" },
      func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = {
          id = note.id,
          title = note.title,
          aliases = note.aliases,
          tags = note.tags,
          publish = false,
        }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        -- literature_notes だけ出典用の項目を足す（既にある値は上書きしない）
        if note.path and tostring(note.path):find("/literature_notes/", 1, true) then
          for _, k in ipairs { "type", "source", "author", "status" } do
            if out[k] == nil then
              out[k] = vim.NIL -- 空の値として `key:` で出力される
            end
          end
          out.date = out.date or os.date "%Y-%m-%d"
        end

        return out
      end,
    },
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
