local M = {
  "rmagatti/auto-session",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Only needed if you want to use sesssion lens
  },
}

function M.config()
  require("auto-session").setup {
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_session_root_dir = vim.fn.stdpath "data" .. "/sessions/",
    auto_session_enable_last_session = false,
    auto_session_enabled = true,
    auto_session_create_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_use_git_branch = true,
    -- the configs below are lua only
    bypass_session_save_file_types = nil,
  }
end

return M
