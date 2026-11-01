-- Local fyler.nvim extension keeping the floating finder's title in sync with
-- the current root. `kind_presets.floating.title` only takes a static string,
-- so update it from fyler's (undocumented) `finder_refresh_post` hook instead.
local M = {}

-- Must run before `fyler.setup()`.
function M.register()
  require("fyler.extensions").register {
    name = "title",
    hooks = {
      finder_refresh_post = function(inst)
        if inst.opts.kind ~= "floating" or not (inst.win_id and vim.api.nvim_win_is_valid(inst.win_id)) then
          return
        end
        pcall(vim.api.nvim_win_set_config, inst.win_id, {
          title = " " .. vim.fn.fnamemodify(inst.state.pseudo_root_path, ":~") .. " ",
          title_pos = "left",
        })
      end,
    },
  }
end

return M
