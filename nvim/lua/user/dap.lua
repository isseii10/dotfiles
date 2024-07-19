local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    -- languages
    "leoluz/nvim-dap-go",
  },
}

function M.config()
  require("dapui").setup()
  require("nvim-dap-virtual-text").setup {}
  require("dap-go").setup {}

  local wk = require "which-key"
  wk.add {
    { "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>",          desc = "UI toggle" },
    { "<leader>dc", "<cmd>lua require'dap'.continue()<CR>",          desc = "continue" },
    { "<leader>dt", "<cmd>lua require'dap'.terminate()<CR>",         desc = "terminate" },
    { "<leader>di", "<cmd>lua require'dap'.step_into()<CR>",         desc = "step into" },
    { "<leader>do", "<cmd>lua require'dap'.step_out()<CR>",          desc = "step out" },
    { "<leader>dn", "<cmd>lua require'dap'.step_over()<CR>",         desc = "step over (goto next line)" },
    { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "toggle breakpoint" },
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
end

return M
