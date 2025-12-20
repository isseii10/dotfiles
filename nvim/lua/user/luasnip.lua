return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  event = "InsertEnter",
  config = function()
    -- 共通スニペット
    require("luasnip.loaders.from_vscode").lazy_load() -- load from frendly-snippets
    require("luasnip.loaders.from_lua").lazy_load {
      paths = vim.fn.stdpath "config" .. "/lua/user/snippets",
    }

    -- プロジェクト固有スニペット(vscode形式)
    local function load_project_snippets()
      local project_snippets = vim.fn.getcwd() .. "/snippets"
      -- print(project_snippets)
      if vim.fn.isdirectory(project_snippets) == 1 then
        require("luasnip.loaders.from_vscode").lazy_load {
          paths = { project_snippets },
        }
      end
    end

    -- 起動時とディレクトリ変更時にプロジェクト固有スニペットをロード
    load_project_snippets()
    vim.api.nvim_create_autocmd("DirChanged", { callback = load_project_snippets })
  end,
}
