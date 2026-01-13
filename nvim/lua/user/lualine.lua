local M = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "AndreM222/copilot-lualine",
  },
  event = "VeryLazy",
}


local function get_attached_clients()
  local buf_clients = vim.lsp.get_clients { bufnr = 0 }
  if #buf_clients == 0 then
    return "LSP Inactive"
  end

  local buf_ft = vim.bo.filetype

  local buf_client_names = {}

  -- add client
  for _, client in pairs(buf_clients) do
    if client.name ~= "copilot" and client.name ~= "null-ls" then
      table.insert(buf_client_names, client.name)
    end
  end

  -- Generally, you should use either null-ls or nvim-lint + formatter.nvim, not both.
  -- Add linters (from nvim-lint)
  local lint_s, lint = pcall(require, "lint")
  if lint_s then
    for ft_k, ft_v in pairs(lint.linters_by_ft) do
      if type(ft_v) == "table" then
        for _, linter in ipairs(ft_v) do
          if buf_ft == ft_k then
            table.insert(buf_client_names, linter)
          end
        end
      elseif type(ft_v) == "string" then
        if buf_ft == ft_k then
          table.insert(buf_client_names, ft_v)
        end
      end
    end
  end

  -- Add formatters (from conform.nvim)
  local conform_s, conform = pcall(require, "conform")
  if conform_s then
    local formatters = conform.list_formatters_for_buffer()
    if formatters and #formatters > 0 then
      for _, formatter in ipairs(formatters) do
        table.insert(buf_client_names, formatter)
      end
    end
  end

  -- This needs to be a string only table so we can use concat below
  local unique_client_names = {}
  for _, client_name_target in ipairs(buf_client_names) do
    local is_duplicate = false
    for _, client_name_compare in ipairs(unique_client_names) do
      if client_name_target == client_name_compare then
        is_duplicate = true
      end
    end
    if not is_duplicate then
      table.insert(unique_client_names, client_name_target)
    end
  end

  local client_names_str = table.concat(unique_client_names, ", ")
  local language_servers = string.format("[%s]", client_names_str)

  return language_servers
end

-- copilot-lualine
local copilot_lualine = {
  "copilot",
  -- Default values
  symbols = {
    status = {
      icons = {
        enabled = " ",
        sleep = " ", -- auto-trigger disabled
        disabled = " ",
        warning = " ",
        unknown = " ",
      },
      hl = {
        enabled = "#50FA7B",
        sleep = "#AEB7D0",
        disabled = "#6272A4",
        warning = "#FFB86C",
        unknown = "#FF5555",
      },
    },
    spinners = "dots", -- has some premade spinners
    spinner_color = "#6272A4",
  },
  show_colors = false,
  show_loading = true,
}

local function rec()
  local r = vim.fn.reg_recording()
  if r ~= "" then
    return "REC @" .. r
  end
  return ""
end

function M.config()
  require("lualine").setup {
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      ignore_focus = { "NvimTree" },
    },
    sections = {
      lualine_a = { "mode", rec },
      lualine_b = {
        "branch",
        "diff",
        {
          function()
            return vim.g.remote_neovim_host and ("Remote: %s"):format(vim.uv.os_gethostname()) or ""
          end,
          padding = { right = 1, left = 1 },
          separator = { left = "", right = "" },
        },
      },
      lualine_c = {
        "diagnostics",
        {
          "filename",
          path = 1,
        },
      },
      lualine_x = {
        copilot_lualine,
        get_attached_clients,
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = {},
    },
    extensions = { "quickfix", "man", "fugitive" },
    tabline = {},
  }
end

return M
