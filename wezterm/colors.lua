local M = {}

-- ビルトインのカラースキームを使う場合は文字列を設定する
local color_scheme = nil -- 例: "tokyonight"

local colors = {
	-- 基本色
	background = "#000000",
	foreground = "#c8d0e0",

	-- カーソル関連
	-- cursor_bg = "#52ad70",
	-- cursor_fg = "black",
	-- cursor_border = "#52ad70",

	-- 選択範囲
	selection_fg = "black",
	selection_bg = "#fffacd",

	-- UI要素
	-- scrollbar_thumb = "#222222",
	split = "#444444",

	-- 入力コンポジション
	-- compose_cursor = "orange",

	-- ANSIカラーパレット (0-7)
	-- ansi = {
	-- 	"black",
	-- 	"maroon",
	-- 	"green",
	-- 	"olive",
	-- 	"navy",
	-- 	"purple",
	-- 	"teal",
	-- 	"silver",
	-- },

	-- Brightカラーパレット (8-15)
	-- brights = {
	-- 	"grey",
	-- 	"red",
	-- 	"lime",
	-- 	"yellow",
	-- 	"blue",
	-- 	"fuchsia",
	-- 	"aqua",
	-- 	"white",
	-- },

	-- インデックス色 (16-255)
	-- indexed = {
	-- 	[136] = "#af8700",
	-- },

	-- タブバー
	-- tab_bar = {
	-- background = "#0b0022",
	-- 	active_tab = {
	-- 		bg_color = "#2b2042",
	-- 		fg_color = "#c0c0c0",
	-- 		intensity = "Normal",
	-- 		underline = "None",
	-- 		italic = false,
	-- 		strikethrough = false,
	-- 	},
	-- inactive_tab = {
	-- 	bg_color = "#1b1032",
	-- 	fg_color = "#808080",
	-- },
	-- 	inactive_tab_hover = {
	-- 		bg_color = "#3b3052",
	-- 		fg_color = "#909090",
	-- 		italic = true,
	-- 	},
	-- 	new_tab = {
	-- 		bg_color = "#1b1032",
	-- 		fg_color = "#808080",
	-- 	},
	-- 	new_tab_hover = {
	-- 		bg_color = "#3b3052",
	-- 		fg_color = "#909090",
	-- 		italic = true,
	-- 	},
	-- },

	-- コピーモード・クイック選択
	-- copy_mode_active_highlight_bg = { Color = "#000000" },
	-- copy_mode_active_highlight_fg = { AnsiColor = "Black" },
	-- copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
	-- copy_mode_inactive_highlight_fg = { AnsiColor = "White" },
	-- quick_select_label_bg = { Color = "peru" },
	-- quick_select_label_fg = { Color = "#ffffff" },
	-- quick_select_match_bg = { AnsiColor = "Navy" },
	-- quick_select_match_fg = { Color = "#ffffff" },
}

function M.apply_to_config(config)
	-- ビルトインのカラースキームが指定されている場合はそちらを優先
	if color_scheme then
		config.color_scheme = color_scheme
	else
		config.colors = colors
	end
end

return M
