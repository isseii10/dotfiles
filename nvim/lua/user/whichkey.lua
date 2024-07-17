local M = {
	"folke/which-key.nvim",
}

function M.config()
	local spec = {
		{ "<leader>q", "<cmd>confirm q<CR>", desc = "Quit" },
		{ "<leader>w", "<cmd>w!<CR>", desc = "Save" },
		{ "<leader>h", "<cmd>nohlsearch<CR>", desc = "NOHL" },
		{ "<leader>;", "<cmd>tabnew | terminal<CR>", desc = "Term" },
		{ "<leader>v", "<cmd>vsplit<CR>", desc = "Split" },
		{ "<leader>b", group = "Buffers" },
		{ "<leader>d", group = "Debug" },
		{ "<leader>f", group = "Find" },
		{ "<leader>g", group = "Git" },
		{ "<leader>l", group = "LSP" },
		{ "<leader>p", group = "Plugins" },
		{ "<leader>t", group = "Test" },
		{ "<leader>T", group = "Treesitter" },
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
