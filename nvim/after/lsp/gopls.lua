return {
  settings = {
    gopls = {
      buildFlags = { "-tags=wireinject" },
      analyses = {
        unusedparams = true,
        unreachable = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}
