-- if true then
--   return {}
-- end
return {
  -- Minimum config required
  -- LazyExtras includes these plus linter; linter makes many docs too busy
  -- https://www.lazyvim.org/extras/lang/markdown
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- vim.list_extend(opts.ensure_installed, { "markdownlint", "marksman" })
      vim.list_extend(opts.ensure_installed, { "marksman" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
  -- headlines in markdown documents
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = true,
    config = true, -- or `opts = {}`
  },
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   build = function()
  --     vim.fn["mkdp#util#install"]()
  --   end,
  --   keys = {
  --     {
  --       "<leader>cp",
  --       ft = "markdown",
  --       "<cmd>MarkdownPreviewToggle<cr>",
  --       desc = "Markdown Preview",
  --     },
  --   },
  --   config = function()
  --     vim.cmd([[do FileType]])
  --   end,
  -- },
  -- TODO: add a toggle to include linter
}
