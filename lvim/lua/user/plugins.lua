lvim.plugins = {
  -- colorschemes
  { "shaunsingh/nord.nvim" },
  { "rmehri01/onenord.nvim" },

  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup({})
    end,
  },
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
  },
  { "olexsmir/gopher.nvim" },
  { "leoluz/nvim-dap-go" },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  {
    "folke/trouble.nvim",
    cmd = require("user.trouble").cmd,
    keys = require("user.trouble").keys,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup(
            {
              relculright = true,
              segments = {
                { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
                { text = { "%s" },                  click = "v:lua.ScSa" },
                { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" }
              }
            }
          )
        end
      }
    },
    config = function()
      require("ufo").setup(
        {
          provider_selector = function(bufnr, filetype, buftype)
            return { "treesitter", "indent" }
          end
        }
      )
    end,
    event = "BufReadPost",
    init = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99 -- デフォルトで全ての折りたたみを開く
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>",  mode = { "n", "v" }, desc = "Yank git link" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
    },
  },
}
