return {
  cmd = {'gopls'}, -- gopls のパス
  filetypes = {'go', 'gomod'},
  root_dir = require('lspconfig.util').root_pattern('go.mod', '.git'),
  settings = {
    gopls = {
      experimentalWorkspaceModule = true,
      analyses = {
        unusedparams = true,
        unreachable = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}
