local wezterm = require("wezterm") ---@type Wezterm

---@class TabModule
local M = {}

local function get_current_working_dir(tab)
	local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = "" }
	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

	return current_dir == HOME_DIR and "." or string.gsub(current_dir.file_path, "(.*[/\\])(.*)", "%2")
end

---@param config table
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

	-- タブバーのカラー設定
	if not config.colors then
		config.colors = {}
	end
	config.colors.tab_bar = {
		inactive_tab_edge = "none",
		background = "#000000",
		active_tab = {
			bg_color = "#4a4a4a",
			fg_color = "#ffffff",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#000000",
			fg_color = "#808080",
		},
		inactive_tab_hover = {
			bg_color = "#2a2a2a",
			fg_color = "#a0a0a0",
			italic = true,
		},
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
