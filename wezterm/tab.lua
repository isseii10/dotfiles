local wezterm = require("wezterm")

local M = {}

local function get_current_working_dir(tab)
	local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = "" }
	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

	return current_dir == HOME_DIR and "." or string.gsub(current_dir.file_path, "(.*[/\\])(.*)", "%2")
end

function M.apply_to_config(config)
	-- tab title
	config.hide_tab_bar_if_only_one_tab = false
	config.use_fancy_tab_bar = true
	-- タブバーの透過
	config.window_frame = {
		inactive_titlebar_bg = "none",
		active_titlebar_bg = "none",
	}
	config.show_new_tab_button_in_tab_bar = false
	config.window_background_gradient = {
		colors = { "#000000" },
	}

	wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
		local has_unseen_output = false
		if not tab.is_active then
			for _, pane in ipairs(tab.panes) do
				if pane.has_unseen_output then
					has_unseen_output = true
					break
				end
			end
		end

		local cwd = wezterm.format({
			{ Attribute = { Intensity = "Bold" } },
			{ Text = get_current_working_dir(tab) },
		})

		local title = string.format(" %s: %s", tab.tab_index + 1, cwd)

		if has_unseen_output then
			return {
				{ Text = title },
			}
		end

		return {
			{ Text = title },
		}
	end)
end

return M
