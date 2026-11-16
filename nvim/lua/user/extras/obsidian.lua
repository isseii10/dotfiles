local workspaces = {
  {
    name = "obsidian",
    path = "~/obsidian/",
  },
}

local workspace_roots = vim.tbl_map(function(workspace)
  return vim.fs.normalize(vim.fn.expand(workspace.path))
end, workspaces)

local function in_vault(path)
  path = vim.fs.normalize(path)
  for _, root in ipairs(workspace_roots) do
    if path == root or vim.startswith(path, root .. "/") then
      return true
    end
  end
  return false
end

-- vault 配下の markdown を開いたときだけ読み込む
local events = {}
for _, root in ipairs(workspace_roots) do
  table.insert(events, { event = { "BufReadPre", "BufNewFile" }, pattern = root .. "/*.md" })
end

local M = {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  event = events,
  cmd = {
    "Obsidian",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
}

function M.init()
  -- vault をカレントディレクトリにして起動したときも読み込む (ファイル未指定でも <leader>o を使えるように)
  vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
    group = vim.api.nvim_create_augroup("user_obsidian_lazy", { clear = true }),
    callback = function()
      if in_vault(vim.fn.getcwd()) then
        require("lazy").load { plugins = { "obsidian.nvim" } }
        return true
      end
    end,
  })
end

function M.config()
  vim.g.obsidian_workspace_roots = workspace_roots

  require("obsidian").setup {
    legacy_commands = false,
    -- A list of workspace names, paths, and configuration overrides.
    -- If you use the Obsidian app, the 'path' of a workspace should generally be
    -- your vault root (where the `.obsidian` folder is located).
    -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
    -- the workspace to the first workspace in the list whose `path` is a parent of the
    -- current markdown file being edited.
    workspaces = workspaces,
    -- Obsidianアプリのコアテンプレートと同じフォルダ・ファイルを使う
    templates = {
      folder = "extras/templates",
    },
    attachments = {
      folder = "extras/attachments",
    },
    daily_notes = {
      folder = "calendar/daily",
      default_tags = {},
      template = "daily.md",
    },

    checkbox = {
      -- 見た目は render-markdown.lua の checkbox.custom で付ける
      order = {
        " ", -- 未着手
        "~", -- 進行中
        "x", -- 完了
        "-", -- 中止
      },
    },
    -- Optional, alternatively you can customize the frontmatter data.
    ---@return table
    frontmatter = {
      -- literature の出典用項目も含めて並び順を固定する（該当キーがないノートには影響しない）
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

        -- atlas/literature だけ出典用の項目を足す（既にある値は上書きしない）
        if note.path and tostring(note.path):find("/atlas/literature/", 1, true) then
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
