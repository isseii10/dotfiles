local M = {}

M.lazy_specs = {}

function M.register(item)
  table.insert(M.lazy_specs, { import = item })
end

return M
