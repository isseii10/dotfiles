local M = {
  "goolord/alpha-nvim",
  config = function()
    require("alpha").setup(require("alpha.themes.dashboard").config)
  end,
}

function M.config()
  local alpha = require "alpha"
  local dashboard = require "alpha.themes.dashboard"
  local icons = require "user.icons"
  dashboard.section.header.val = {
    [[                                             ]],
    [[                                             ]],
    [[                                             ]],
    [[                                             ]],
    [[                                             ]],
    [[                                             ]],
    [[                                             ]],
    [[                                             ]],
    [[                                             ]],
    [[                                             ]],
    [[ ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄ ▄▄   ▄▄ ]],
    [[█  █  █ █       █       █  █ █  █   █  █▄█  █]],
    [[█   █▄█ █    ▄▄▄█   ▄   █  █▄█  █   █       █]],
    [[█       █   █▄▄▄█  █ █  █       █   █       █]],
    [[█  ▄    █    ▄▄▄█  █▄█  █       █   █       █]],
    [[█ █ █   █   █▄▄▄█       ██     ██   █ ██▄██ █]],
    [[█▄█  █▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄▄█▄█   █▄█]],
    [[                                             ]],
    [[                                             ]],
    [[                                             ]],
    [[                                             ]],
    [[                                             ]],
  }
  dashboard.section.buttons.val = {
    dashboard.button("f", icons.ui.FindFile .. " Find file", "<cmd>Telescope find_files<CR>"),
    dashboard.button("r", icons.ui.History .. " Recently opend files", "<cmd>Telescope oldfiles<CR>"),
    dashboard.button(
      "p",
      icons.ui.Project .. " Recent projects",
      ":lua require('telescope').extensions.projects.projects()<CR>"
    ),

    dashboard.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
  }
  local handle = io.popen "fortune"
  local fortune = handle:read "*a"
  handle:close()
  dashboard.section.footer.val = fortune

  dashboard.config.opts.noautocmd = true

  alpha.setup(dashboard.config)
end

return M
