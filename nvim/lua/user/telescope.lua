local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make",                        lazy = true },
    { "mike-jl/harpoonEx",                        opts = { reload_on_dir_change = true } },
  },
  event = "VeryLazy",
}

function M.config()
  vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })

  local wk = require "which-key"
  wk.add {
    { "<leader>bb", "<cmd>Telescope buffers previewer=false<cr>",   desc = "Find buffers" },
    { "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "current buffer" },
    { "<leader>fc", "<cmd>Telescope colorscheme<cr>",               desc = "Colorscheme" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Live grep" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Help" },
    { "<leader>fl", "<cmd>Telescope resume<cr>",                    desc = "Last Search" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent File" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>",                   desc = "Key Maps" },
  }
  local icons = require "user.icons"
  local actions = require "telescope.actions"

  require("telescope").setup {
    defaults = {
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = icons.ui.Forward .. " ",
      entry_prefix = "   ",
      initial_mode = "insert",
      selection_strategy = "reset",
      path_display = { "smart" },
      color_devicons = true,
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },

      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,

          ["<C-s>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
        },
        n = {
          ["<esc>"] = actions.close,
          ["q"] = actions.close,

          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,

          ["\\"] = actions.select_vertical,
          ["-"] = actions.select_horizontal,
        },
      },
    },
    pickers = {
      live_grep = {
        theme = "dropdown",
      },

      grep_string = {
        theme = "dropdown",
      },

      find_files = {
        theme = "dropdown",
        previewer = false,
      },

      current_buffer_fuzzy_find = {
        theme = "dropdown",
      },

      buffers = {
        theme = "dropdown",
        previewer = false,
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },

      planets = {
        show_pluto = true,
        show_moon = true,
      },

      colorscheme = {
        enable_preview = true,
      },

      lsp_references = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_definitions = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_declarations = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_implementations = {
        theme = "dropdown",
        initial_mode = "normal",
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      },
      harpoonEx = {
        theme = "dropdown",
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,

            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            ["<C-s>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
          },
          n = {
            ["<esc>"] = actions.close,
            ["q"] = actions.close,

            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,

            ["\\"] = actions.select_vertical,
            ["-"] = actions.select_horizontal,
          },
        },
      },
      project = {
        hidden_files = false, -- default: false
        theme = "dropdown",
        order_by = "asc",
        search_by = "title",
        sync_with_nvim_tree = true, -- default false
        -- default for on_project_selected = find project files
        on_project_selected = function(prompt_bufnr)
          -- Do anything you want in here. For example:
        end,
      },
    },
  }
end

return M
