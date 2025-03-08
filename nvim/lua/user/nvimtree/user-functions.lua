local M = {}

local ns_id = vim.api.nvim_create_namespace "nvim_tree_virtual_text"

function M.clear_dir_name()
  if vim.bo.filetype ~= "NvimTree" then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
end

function M.display_dir_name()
  if vim.bo.filetype ~= "NvimTree" then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local current_node = require("nvim-tree.api").tree.get_node_under_cursor()
  local parent_dir = current_node and current_node.parent and current_node.parent.absolute_path or "N/A"

  -- cwd以下の相対パスを取得
  local cwd = vim.loop.cwd()
  local relative_path = parent_dir
  local root_path = cwd:match ".*/(.*)$"

  if parent_dir:sub(1, #cwd) == cwd then
    relative_path = parent_dir:sub(#cwd + 2)
  end

  -- project を含む相対パスを取得
  if relative_path == "N/A" then
    relative_path = root_path
  else
    relative_path = root_path .. "/" .. relative_path
  end
  -- テキストの長さを制限
  local max_length = 50 -- 仮想テキストの最大長さ
  if #relative_path > max_length then
    relative_path = relative_path:sub(1, max_length) .. "..." -- トリミングして末尾に"..."を追加
  else
    -- 空白でパディングして指定した長さに合わせる
    local padding_num = max_length - #relative_path
    relative_path = relative_path .. string.rep(" ", padding_num)
  end
  -- 表示する行番号を取得
  local first_visible_line = vim.fn.line "w0" - 1

  vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
  vim.api.nvim_buf_set_extmark(buf, ns_id, first_visible_line, 0, {
    virt_text = { { relative_path, "NvimTreeRootFolder" } },
    virt_text_pos = "overlay",
  })
end

return M
