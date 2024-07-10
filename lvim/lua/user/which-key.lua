local which_key = lvim.builtin.which_key

-- replace <leader>f
which_key.mappings["f"] = {
  name = "+Find",
  b = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Current buffer fuzzy-find" },
  f = {
    function()
      require("lvim.core.telescope.custom-finders").find_project_files { previewer = false }
    end,
    "Find Git Files",
  },
  F = { "<cmd>Telescope find_files<CR>", "Find files" },
  g = { "<cmd>Telescope live_grep<CR>", "Live grep" },
  h = { "<cmd>Telescope help_tags<CR>", "help tags" },
  m = { "<cmd>Telescope marks<CR>", "Marks" },
  r = { "<cmd>Telescope oldfiles<CR>", "Find recent files" },
}
