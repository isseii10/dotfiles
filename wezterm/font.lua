local wezterm = require("wezterm")

local M = {}

function M.apply_to_config(config)
	-- font
	-- wezterm ls-fonts --list-systemで出力できる
	-- font なかったら順次探しに行く設定
	config.font = wezterm.font_with_fallback({
		"JetBrainsMono Nerd Font",
		"Hiragino Sans",
		"Symbols Nerd Font",
		"Apple Color Emoji",
	})

	-- コメントアウト外したらリガチャOFFにできる
	-- config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

	config.font_size = 12
end

return M
