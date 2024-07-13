return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    local wk = require 'which-key'
    wk.setup()

    -- Document existing key chains
    wk.register({
      f = {
        name = '+Find',
      },
      d = {
        name = '+Debug',
      },
      w = { '<cmd>w<CR>', 'Save' },
      q = { '<cmd>q<CR>', 'Quit' },
      c = { name = '[C]ode', _ = 'which_key_ignore' },
      h = { '<cmd>nohlsearch<CR>', 'nohlsearch' },
    }, { mode = 'n', prefix = '<leader>' })
    -- visual mode
    require('which-key').register({}, { mode = 'v' })
  end,
}
