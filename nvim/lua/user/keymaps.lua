local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better escape
keymap("i", "jj", "<ESC>", opts)
keymap("i", "jk", "<ESC>", opts)

-- Better window navigation
keymap("n", "<c-h>", "<C-w>h", opts)
keymap("n", "<c-j>", "<C-w>j", opts)
keymap("n", "<c-k>", "<C-w>k", opts)
keymap("n", "<c-l>", "<C-w>l", opts)

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("x", "p", [["_dP]])

-- more good
keymap({ "n", "o", "x" }, "<s-h>", "^", opts)
keymap({ "n", "o", "x" }, "<s-l>", "g_", opts)
keymap({ "n", "o", "x" }, "<s-j>", "10j", opts)
keymap({ "n", "o", "x" }, "<s-k>", "10k", opts)

-- tailwind bearable to work with
keymap({ "n", "x" }, "j", "gj", opts)
keymap({ "n", "x" }, "k", "gk", opts)

keymap({ "o", "x" }, "i<Space>", "iW", opts)

keymap("n", "i", function()
  if vim.fn.empty(vim.fn.getline ".") == 1 then
    return '"_cc'
  else
    return "i"
  end
end, { expr = true, silent = true, noremap = true })

keymap("n", "A", function()
  if vim.fn.empty(vim.fn.getline ".") == 1 then
    return '"_cc'
  else
    return "A"
  end
end, { expr = true, silent = true, noremap = true })

-- Terminal mode keymaps
vim.api.nvim_set_keymap("t", "<C-;>", "<C-\\><C-n>", opts)
vim.api.nvim_set_keymap("t", "<c-h>", "<C-\\><C-n><C-W>h", opts)
vim.api.nvim_set_keymap("t", "<c-j>", "<C-\\><C-n><C-W>j", opts)
vim.api.nvim_set_keymap("t", "<c-k>", "<C-\\><C-n><C-W>k", opts)
vim.api.nvim_set_keymap("t", "<c-l>", "<C-\\><C-n><C-W>l", opts)
