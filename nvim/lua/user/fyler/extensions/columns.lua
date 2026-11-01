-- Local fyler.nvim extension restoring the columns the upstream rewrite
-- dropped: symlink target / diagnostic / permission / size. Built on fyler's
-- (undocumented) extension hook API, so re-check `finder_refresh_post` if
-- upstream moves.
local icons = require "user.icons"

local M = {}

-- Gaps (in cells) between name -> link column -> info columns. The name gap
-- also leaves room for the git extension's inline icon.
local NAME_GAP = 4
local LINK_GAP = 4
local INFO_GAP = 6

local TYPE_CHARS = { dir = "d", link = "l" }

local DIAGNOSTIC_SIGNS = {
  [vim.diagnostic.severity.ERROR] = { icons.diagnostics.Error, "DiagnosticError" },
  [vim.diagnostic.severity.WARN] = { icons.diagnostics.Warning, "DiagnosticWarn" },
  [vim.diagnostic.severity.INFO] = { icons.diagnostics.Information, "DiagnosticInfo" },
  [vim.diagnostic.severity.HINT] = { icons.diagnostics.Hint, "DiagnosticHint" },
}

local H = {}

function H.format_size(size)
  local units = { "B", "K", "M", "G", "T" }
  local i = 1
  while size >= 1024 and i < #units do
    size = size / 1024
    i = i + 1
  end
  return i == 1 and ("%d%s"):format(size, units[i]) or ("%.1f%s"):format(size, units[i])
end

function H.pad(text, width)
  return text .. (" "):rep(width - vim.fn.strdisplaywidth(text))
end

function H.set_virt_text(inst, hl_ns, row, col, virt_text)
  pcall(vim.api.nvim_buf_set_extmark, inst.buf_id, hl_ns, row, 0, {
    virt_text = virt_text,
    virt_text_win_col = col,
    hl_mode = "combine",
  })
end

function H.max_name_width(lines)
  local width = 0
  for _, line in ipairs(lines) do
    -- Skip the concealed `/<id> ` node marker when measuring.
    width = math.max(width, vim.fn.strdisplaywidth((line:gsub("/%d+ ", "", 1))))
  end
  return width
end

-- fyler's state doesn't keep the scanned `link` field on nodes, so resolve
-- symlinks here. Returns `{ [row] = "-> target" }`.
function H.collect_links(visible)
  local links = {}
  for i, item in ipairs(visible) do
    local target = item._name_col and vim.fn.getftype(item.path) == "link" and vim.uv.fs_readlink(item.path)
    if target then
      links[i] = "-> " .. vim.fn.fnamemodify(target, ":~")
    end
  end
  return links
end

-- Worst diagnostic severity per file, bubbled up to every parent dir under
-- `root` so collapsed directories still show that something inside is off.
function H.collect_severities(root)
  root = vim.fs.normalize(root)
  local severities = {}
  for _, d in ipairs(vim.diagnostic.get()) do
    local path = vim.fs.normalize(vim.api.nvim_buf_get_name(d.bufnr))
    while path ~= "" and vim.startswith(path, root) do
      if severities[path] and severities[path] <= d.severity then
        break
      end
      severities[path] = d.severity
      path = vim.fs.dirname(path)
    end
  end
  return severities
end

-- getfperm()/getfsize() follow symlinks, so links show the target's
-- permission/size behind an `ls -l` style type char.
function H.info_chunks(path, severities)
  local perm = vim.fn.getfperm(path)
  if perm == "" then
    return nil
  end
  local diag = DIAGNOSTIC_SIGNS[severities[vim.fs.normalize(path)]] or { "", "Normal" }
  local size = vim.fn.isdirectory(path) == 0 and H.format_size(vim.fn.getfsize(path)) or "-"
  return {
    { H.pad(diag[1], 3), diag[2] },
    { (TYPE_CHARS[vim.fn.getftype(path)] or "-") .. perm, "FylerColumnPermission" },
    { ("     %6s"):format(size), "FylerColumnSize" },
  }
end

function H.render(inst, visible, hl_ns, lines)
  -- Align columns just past the longest name instead of the right edge.
  local link_col = H.max_name_width(lines) + NAME_GAP
  local info_col = link_col + INFO_GAP

  local links = H.collect_links(visible)
  for row, text in pairs(links) do
    H.set_virt_text(inst, hl_ns, row - 1, link_col, { { text, "FylerColumnLink" } })
    info_col = math.max(info_col, link_col + vim.fn.strdisplaywidth(text) + LINK_GAP)
  end

  local severities = H.collect_severities(inst.state.pseudo_root_path)
  for i, item in ipairs(visible) do
    local chunks = item._name_col and H.info_chunks(item.path, severities)
    if chunks then
      H.set_virt_text(inst, hl_ns, i - 1, info_col, chunks)
    end
  end
end

-- Diagnostics change without touching the filesystem, so re-render the open
-- finder ourselves (debounced, LSPs fire this on every keystroke).
function H.watch_diagnostics(get_inst)
  local timer = assert(vim.uv.new_timer())
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = vim.api.nvim_create_augroup("user_fyler_columns", { clear = true }),
    callback = function()
      timer:start(
        300,
        0,
        vim.schedule_wrap(function()
          local inst = get_inst()
          if inst and inst.win_id and vim.api.nvim_win_is_valid(inst.win_id) then
            pcall(inst.refresh, inst)
          end
        end)
      )
    end,
  })
end

-- Must run before `fyler.setup()`.
function M.register()
  local last_inst
  H.watch_diagnostics(function()
    return last_inst
  end)

  require("fyler.extensions").register {
    name = "columns",
    hooks = {
      finder_refresh_post = function(inst, visible, hl_ns, lines)
        last_inst = inst
        H.render(inst, visible, hl_ns, lines)
      end,
    },
  }
end

function M.set_highlights(highlight_groups)
  highlight_groups.FylerColumnLink = { link = "Comment" }
  highlight_groups.FylerColumnPermission = { link = "Comment" }
  highlight_groups.FylerColumnSize = { link = "Number" }
end

return M
