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
  }
  dashboard.section.buttons.val = {
    dashboard.button(
      "f",
      icons.ui.FindFile .. "  Find files",
      "<cmd>Telescope smart_open cwd_only=true theme=dropdown prompt_title=Find\\ Files<cr>"
    ),
    dashboard.button("r", icons.ui.History .. " Recently opened files", "<cmd>Telescope oldfiles<CR>"),
    dashboard.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
  }
  local handle = io.popen "fortune"
  local fortune = handle:read "*a"
  handle:close()
  dashboard.section.footer.val = fortune

  dashboard.config.layout = {
    { type = "padding", val = 2 },
    dashboard.section.header,
    { type = "padding", val = 2 },
    dashboard.section.buttons,
    { type = "padding", val = 1 },
    dashboard.section.footer,
  }

  dashboard.config.opts.noautocmd = true

  alpha.setup(dashboard.config)
end

return M
