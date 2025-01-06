local wezterm = require("wezterm")
local act = wezterm.action

return {
	keys = {
		-- エスケープシーケンス
		{
			key = "K", -- ctrl shift kをzshで使えるようにエスケープシーケンスを送信する
			mods = "CTRL|SHIFT",
			action = wezterm.action.SendString("\x1b[1;6K"),
		},
		-- split panes
		{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		-- close tab/pain
		{ key = "q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
		{ key = "q", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) },

		-- workspace
		{
			-- Create new workspace
			mods = "LEADER",
			key = "S",
			action = act.PromptInputLine({
				description = "(wezterm) Create new workspace: ['ESC': cancel]",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:perform_action(
							act.SwitchToWorkspace({
								name = line,
							}),
							pane
						)
					end
				end),
			}),
		},
		{
			-- Select workspace
			mods = "LEADER",
			key = "s",
			action = wezterm.action_callback(function(win, pane)
				-- workspace のリストを作成
				local current = wezterm.mux.get_active_workspace()
				local workspaces = {}
				for _, name in ipairs(wezterm.mux.get_workspace_names()) do
					if current == name then
						table.insert(workspaces, {
							id = name,
							label = string.format("%s <- current", name),
						})
					else
						table.insert(workspaces, {
							id = name,
							label = string.format("%s", name),
						})
					end
				end
				-- 選択メニューを起動
				win:perform_action(
					act.InputSelector({
						action = wezterm.action_callback(function(_, _, id, label)
							if not id and not label then
								wezterm.log_info("Workspace selection canceled") -- 入力が空ならキャンセル
							else
								win:perform_action(act.SwitchToWorkspace({ name = id }), pane) -- workspace を移動
							end
						end),
						title = "(wezterm) Select workspace",
						choices = workspaces,
						-- fuzzy = true,
						description = "(wezterm) Select workspace: ['/': fuzzy, 'ESC': cancel]",
						fuzzy_description = "(wezterm) Select workspace: ['ESC': cancel]", -- requires nightly build
					}),
					pane
				)
			end),
		},
		{
			-- Rename workspace
			mods = "LEADER",
			key = "r",
			action = act.PromptInputLine({
				description = string.format(
					"(wezterm) Rename workspace title <%s> to:",
					wezterm.mux.get_active_workspace()
				),
				action = wezterm.action_callback(function(win, pane, line)
					if line then
						wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
					end
				end),
			}),
		},
		-- manage font size
		{ key = "+", mods = "SUPER", action = act.IncreaseFontSize },
		{ key = "-", mods = "SUPER", action = act.DecreaseFontSize },
		{ key = "0", mods = "SUPER", action = act.ResetFontSize },
		-- spawn tab
		{ key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
		-- move tab relative
		{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "]", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(1) },
		{ key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
		{ key = "[", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(-1) },
		-- move tab
		{ key = "1", mods = "SUPER", action = act.ActivateTab(0) },
		{ key = "2", mods = "SUPER", action = act.ActivateTab(1) },
		{ key = "3", mods = "SUPER", action = act.ActivateTab(2) },
		{ key = "4", mods = "SUPER", action = act.ActivateTab(3) },
		{ key = "5", mods = "SUPER", action = act.ActivateTab(4) },
		{ key = "6", mods = "SUPER", action = act.ActivateTab(5) },
		{ key = "7", mods = "SUPER", action = act.ActivateTab(6) },
		{ key = "8", mods = "SUPER", action = act.ActivateTab(7) },
		{ key = "9", mods = "SUPER", action = act.ActivateTab(8) },

		-- copy and paste (non copy mode)
		{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
		{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
		-- copy mode
		{ key = "X", mods = "SUPER|SHIFT", action = act.ActivateCopyMode },

		{ key = "z", mods = "SHIFT|CTRL", action = act.TogglePaneZoomState },
		{ key = "f", mods = "SUPER", action = act.Search("CurrentSelectionOrEmptyString") },
		{ key = "n", mods = "SUPER", action = act.SpawnWindow },
		{ key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
		{ key = "r", mods = "SUPER", action = act.ReloadConfiguration },
		{ key = "phys:Space", mods = "SHIFT|CTRL", action = act.QuickSelect },
		-- {
		-- 	key = "U",
		-- 	mods = "CTRL",
		-- 	action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
		-- },
		-- {
		-- 	key = "U",
		-- 	mods = "SHIFT|CTRL",
		-- 	action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
		-- },
	},

	key_tables = {
		copy_mode = {
			{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
			{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },

			{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
			{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
			{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },

			{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
			{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },

			{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
			{ key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
			{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
			{ key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
			{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
			{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },

			{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
			{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
			{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },

			{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
			{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },

			{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
			{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
			{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
			{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },

			{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
			{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
			{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },

			{
				key = "y",
				mods = "NONE",
				action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
			},

			{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
			{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
			{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		},

		search_mode = {
			{ key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
			{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
			{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
			{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
			{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
			{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
			{ key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
			{ key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
			{ key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
			{ key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
		},
	},
}
