local M = {
  "goolord/alpha-nvim",
  config = function()
    require("alpha").setup(require("alpha.themes.dashboard").config)
  end,
}

function M.config()
  local alpha = require "alpha"
  local dashboard = require "alpha.themes.dashboard"
  dashboard.section.header.val = {
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
  }
  dashboard.section.buttons.val = {
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("<space>ff", "  Find file", "<cmd>Telescope find_files<CR>"),
    dashboard.button("<space>fr", "  Recently opend files", "<cmd>Telescope oldfiles<CR>"),
    dashboard.button("<ctrl>p", "  Recent projects", ":lua require('telescope').extensions.projects.projects()<CR>"),

    dashboard.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
  }
  local handle = io.popen "fortune"
  local fortune = handle:read "*a"
  handle:close()
  dashboard.section.footer.val = fortune

  dashboard.config.opts.noautocmd = true

  vim.cmd [[autocmd User AlphaReady echo 'ready']]

  alpha.setup(dashboard.config)
end

return M
