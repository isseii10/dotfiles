local _, actions = pcall(require, "telescope.actions")
local _, builtin = pcall(require, "telescope.builtin")

lvim.builtin.telescope.defaults.mappings = {
  i = {
    ["<C-c>"] = actions.close,
    ["<C-j>"] = actions.cycle_history_next,
    ["<C-k>"] = actions.cycle_history_prev,
    ["<S-Up>"] = actions.cycle_previewers_prev,
    ["<S-Down>"] = actions.cycle_previewers_next,
    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
    ["<CR>"] = actions.select_default + actions.center,
    -- ["<C-i>"] = my_cool_custom_action,
  },
  n = {
    ["<C-c>"] = actions.close,
    ["<S-Up>"] = actions.cycle_previewers_prev,
    ["<S-Down>"] = actions.cycle_previewers_next,
    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
    -- ["<C-Space>"] = custom_actions.fuzzy_filter_results,
    -- ["<C-i>"] = my_cool_custom_action,
  },
}
