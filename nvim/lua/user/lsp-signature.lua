local M = {
  "ray-x/lsp_signature.nvim",
  event = "InsertEnter",
}

M.opts = {
  floating_window = false,
  toggle_key = "<M-x>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
  toggle_key_flip_floatwin_setting = true, -- true: toggle floating_windows: true|false setting after toggle key pressed
  -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
  -- may not popup when typing depends on floating_window setting
}

function M.config(_, opts)
  require("lsp_signature").setup(opts)
end

return M
