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
      "<SPC>ff",
      icons.ui.FindFile .. "  Find files",
      "<cmd>Telescope smart_open cwd_only=true theme=dropdown prompt_title=Find\\ Files<cr>"
    ),
    dashboard.button("<SPC>fr", icons.ui.History .. " Recently opened files", "<cmd>Telescope oldfiles<CR>"),
    dashboard.button("<SPC>q", "󰅚  Quit NVIM", ":qa<CR>"),
  }
  local lazy_ok, lazy = pcall(require, "lazy")
  if lazy_ok then
    local stats = lazy.stats()
    dashboard.section.footer.val = {
      string.format("plugins: loaded %d total %d", stats.loaded, stats.count),
    }
  end

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
