-- https://luals.github.io/wiki/settings/
return {
  settings = {
    Lua = {
      format = {
        enable = true,
      },
      diagnostics = {
        globals = { "vim", "spec" },
        unusedLocalExclude = { "_*" },
      },
      runtime = {
        version = "LuaJIT",
        special = {
          spec = "require",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
      hint = {
        enable = false,
        arrayIndex = "Disable", -- "Enable" | "Auto" | "Disable"
        await = true,
        paramName = "All", -- "All" | "Literal" | "Disable"
        paramType = true,
        semicolon = "All", -- "All" | "SameLine" | "Disable"
        setType = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath "config"
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
          "${3rd}/luv/library",
          "${3rd}/busted/library",
        }),
      },
    })
  end,
}
