local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    -- languages
    "leoluz/nvim-dap-go",
  },
  event = "BufRead",
}

function M.config()
  require("dapui").setup()
  require("nvim-dap-virtual-text").setup {}
  require("dap-go").setup {}

  local wk = require "which-key"
  wk.add {
    { "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>", desc = "UI toggle" },
    { "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", desc = "continue" },
    { "<leader>dt", "<cmd>lua require'dap'.terminate()<CR>", desc = "terminate" },
    { "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", desc = "step into" },
    { "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", desc = "step out" },
    { "<leader>dn", "<cmd>lua require'dap'.step_over()<CR>", desc = "step over (goto next line)" },
    { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "toggle breakpoint" },
    {
      "<leader>dl",
      "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Enter log message: '))<CR>",
      desc = "toggle logpoint",
    },
    {
      "<leader>dB",
      "<cmd>lua require'dap'.clear_breakpoints()<CR>",
      desc = "clear all breakpoint",
    },
  }

  local dap = require "dap"
  local dapui = require "dapui"
  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
  end

  vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, bg = "#553b49" })
  vim.api.nvim_set_hl(0, "DapBreakpointSign", { ctermbg = 0, fg = "#553b49" })
  vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, bg = "#324e68" })
  vim.api.nvim_set_hl(0, "DapLogPointSign", { ctermbg = 0, fg = "#324e68" })
  vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, bg = "#354b49" })
  vim.api.nvim_set_hl(0, "DapStoppedSign", { ctermbg = 0, fg = "#354b49" })

  vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpointSign", linehl = "DapBreakpoint" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ", texthl = "DapBreakpointSign", linehl = "DapBreakpoint" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpointSign", linehl = "DapBreakpoint" })
  vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPointSign", linehl = "DapLogPoint" })
  vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStoppedSign", linehl = "DapStopped" })
end

return M
