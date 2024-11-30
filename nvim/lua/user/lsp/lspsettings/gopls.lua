return {
  cmd = {'gopls'},
  filetypes = {'go', 'gomod'},
  root_dir = require('lspconfig.util').root_pattern('go.mod', '.git'),
  settings = {
    gopls = {
      buildFlags = {"-tags=wireinject"},
      analyses = {
        unusedparams = true,
        unreachable = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}
