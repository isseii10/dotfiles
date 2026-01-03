local wezterm = require("wezterm")

local M = {}

-- move and resize split panes in WezTerm (and Neovim)
-- 'smart-split.nvim' is required
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

function M.apply_to_config(config)
	-- move between split panes
	table.insert(config.keys, split_nav("move", "h"))
	table.insert(config.keys, split_nav("move", "j"))
	table.insert(config.keys, split_nav("move", "k"))
	table.insert(config.keys, split_nav("move", "l"))
	-- resize panes
	table.insert(config.keys, split_nav("resize", "h"))
	table.insert(config.keys, split_nav("resize", "j"))
	table.insert(config.keys, split_nav("resize", "k"))
	table.insert(config.keys, split_nav("resize", "l"))
end

return M
