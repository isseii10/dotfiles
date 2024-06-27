-- statusline config

local lualine = lvim.builtin.lualine

lualine.style = "lvim"

local components = require("lvim.core.lualine.components")


-- sections
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+
lualine.sections = {
  lualine_a = {
    components.mode,
  },
  lualine_b = {
    components.branch,
  },
  lualine_c = {
    components.diff,
    {
      "filename",
      path = 1,
    },
  },
  lualine_x = {
    components.diagnostics,
    components.lsp,
    components.spaces,
    components.filetype,
  },
  lualine_y = { components.location },
  lualine_z = {
    components.progress,
  },
}
