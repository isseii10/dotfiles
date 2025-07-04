return {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      validate = { enable = false },
      format = { enable = true },
      -- schemas = require("user.schemastore").yaml.schemas {
      --   replace = {
      --     ["openapi.json"] = {
      --       name = "openapi.json",
      --       description = "openapi.json overridden",
      --       fileMatch = { "openapi.json", "openapi.yml", "openapi.yaml" },
      --       url = "https://spec.openapis.org/oas/3.0/schema/2021-09-28",
      --     },
      --   },
      -- },
      disableAdditionalProperties = true,
    },
  },
}
