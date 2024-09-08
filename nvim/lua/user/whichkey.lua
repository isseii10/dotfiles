local M = {
	"folke/which-key.nvim",
  event = "VeryLazy",
}

function M.config()
	local spec = {
		{ "<leader>q", "<cmd>q!<CR>", desc = "Quit" },
		{ "<leader>w", "<cmd>w!<CR>", desc = "Save" },
		{ "<leader>h", "<cmd>nohlsearch<CR>", desc = "No hlsearch" },
		{ "<leader>\\", "<cmd>vsplit<CR>", desc = "Split Vertical" },
		{ "<leader>-", "<cmd>split<CR>", desc = "Split Horizontal" },
		{ "<leader>b", group = "Buffers" },
		{ "<leader>d", group = "Debug" },
		{ "<leader>f", group = "Find" },
		{ "<leader>g", group = "Git" },
		{ "gs", group = "Surround" },
		{ "<leader>l", group = "LSP" },
		{ "<leader>p", group = "Plugins" },
		{ "<leader>t", group = "Test" },
		{ "<leader>T", group = "Treesitter" },
		{ "<leader>x", group = "Trouble" },
	}

	local which_key = require("which-key")
	which_key.setup({
		defaults = {
			mode = "n", -- NORMAL mode
			prefix = "<leader>",
		},
		spec = spec,
		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				operators = true,
				motions = false,
				text_objects = true,
				windows = false,
				nav = false,
				z = false,
				g = false,
			},
		},
		win = {
			border = "rounded",
			padding = { 2, 2 },
		},
		show_help = false,
		show_keys = false,
		disable = {
			buftypes = {},
			filetypes = { "TelescopePrompt" },
		},
	})
  -- which_key.setup({
  --   defaults = {
  --     preset = "helix",
  --   }
  -- })
end

return M
