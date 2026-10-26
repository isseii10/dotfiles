-- NOTE: vscode-neovim から起動された時のみ読み込まれる
local vscode = require "vscode"
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local function action(name)
  return function()
    vscode.action(name)
  end
end

-- 編集系 (VSCode上でも動作する) プラグインのみ読み込む
local specs = require("user.plugin_registry").lazy_specs
local register = require("user.plugin_registry").register

register "user.flash"
register "user.mini-ai"
register "user.mini-surround"
register "user.extras.nvim-spider"

-- VSCodeではBufRead系イベントが当てにならないので読み込みタイミングを上書き
table.insert(specs, { "echasnovski/mini.ai", event = "VeryLazy" })
table.insert(specs, { "echasnovski/mini.surround", event = "VeryLazy" })
table.insert(specs, { "folke/flash.nvim", event = "VeryLazy" })

-- which-key / lsp / telescope 等のキーマップをVSCodeのコマンドに置き換える
keymap("n", "<leader>w", action "workbench.action.files.save", opts)
keymap("n", "<leader>q", action "workbench.action.closeActiveEditor", opts)
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)
keymap({ "n", "x" }, "<leader>/", action "editor.action.commentLine", opts)
keymap("n", "<leader>e", action "workbench.view.explorer", opts)

-- Find
keymap("n", "<leader>ff", action "workbench.action.quickOpen", opts)
keymap("n", "<leader>fg", action "workbench.action.findInFiles", opts)
keymap("n", "<leader>fr", action "workbench.action.openRecent", opts)
keymap("n", "<leader>fc", action "workbench.action.showCommands", opts)
keymap("n", "<leader>fk", action "workbench.action.openGlobalKeybindings", opts)
keymap("n", "<leader>bb", action "workbench.action.showAllEditors", opts)

-- LSP
keymap("n", "gd", action "editor.action.revealDefinition", opts)
keymap("n", "gD", action "editor.action.revealDeclaration", opts)
keymap("n", "gi", action "editor.action.goToImplementation", opts)
keymap("n", "gr", action "editor.action.goToReferences", opts)
keymap("n", "gl", action "editor.action.showHover", opts)
keymap("n", "<leader>k", action "editor.action.showHover", opts)
keymap("n", "<leader>lr", action "editor.action.rename", opts)
keymap("n", "<leader>la", action "editor.action.quickFix", opts)
keymap("n", "<leader>lf", action "editor.action.formatDocument", opts)
keymap("n", "<leader>ls", action "workbench.action.gotoSymbol", opts)
keymap("n", "<leader>xx", action "workbench.actions.view.problems", opts)

-- Git
keymap("n", "<leader>gj", action "workbench.action.editor.nextChange", opts)
keymap("n", "<leader>gk", action "workbench.action.editor.previousChange", opts)
keymap("n", "<leader>gr", action "git.revertSelectedRanges", opts)
keymap("n", "<leader>gs", action "git.stageSelectedRanges", opts)
keymap("n", "<leader>gd", action "git.openChange", opts)

-- Window navigation
keymap("n", "<c-h>", action "workbench.action.navigateLeft", opts)
keymap("n", "<c-j>", action "workbench.action.navigateDown", opts)
keymap("n", "<c-k>", action "workbench.action.navigateUp", opts)
keymap("n", "<c-l>", action "workbench.action.navigateRight", opts)

require "user.lazy"
