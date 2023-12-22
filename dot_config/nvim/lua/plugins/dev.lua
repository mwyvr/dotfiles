return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "goimports", "gofumpt" })
      vim.list_extend(opts.ensure_installed, { "gomodifytags", "impl", "json-lsp" })
      vim.list_extend(opts.ensure_installed, { "delve" })
    end,
  },
  -- {
  --   "nvimtools/none-ls.nvim",
  --   optional = false,
  --   dependencies = {
  --     {
  --       "williamboman/mason.nvim",
  --       opts = function(_, opts)
  --         opts.ensure_installed = opts.ensure_installed or {}
  --         vim.list_extend(opts.ensure_installed, { "gomodifytags", "impl" })
  --       end,
  --     },
  --   },
  --   opts = function(_, opts)
  --     local nls = require("null-ls")
  --     opts.sources = vim.list_extend(opts.sources or {}, {
  --       nls.builtins.code_actions.gomodifytags,
  --       nls.builtins.code_actions.impl,
  --       nls.builtins.formatting.goimports,
  --       nls.builtins.formatting.gofumpt,
  --     })
  --   end,
  -- },
  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {
  --       go = { "goimports", "gofumpt" },
  --     },
  --   },
  -- },
}
-- return {
--   {
--     "williamboman/mason.nvim",
--     opts = {
--       ensure_installed = {
--         "biome",
--         "css-lsp",
--         "emmet-ls",
--         "gofumpt",
--         "goimports",
--         "golangci-lint",
--
--         "gopls",
--         "html-lsp",
--         "json-lsp",
--         "lua-language-server",
--         "marksman",
--         "python-lsp-server",
--         "pyright",
--         "shellcheck",
--         "shfmt",
--         "stylua",
--         "sql-formatter",
--         "sqlls",
--         -- "tailwindcss-language-server", rarely needed
--       },
--     },
--   },
-- }
