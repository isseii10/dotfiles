local i = lvim.keys.insert_mode
local n = lvim.keys.normal_mode
local t = lvim.keys.term_mode
local v = lvim.keys.visual_mode
local vb = lvim.keys.visual_block_mode
local c = lvim.keys.command_mode

n["<leader>-"] = "<CMD>split<CR>"
n["<leader>¥"] = "<CMD>vsplit<CR>"
