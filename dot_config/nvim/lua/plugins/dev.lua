return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- golang
      vim.list_extend(opts.ensure_installed, { "goimports", "gofumpt" })
      vim.list_extend(opts.ensure_installed, { "gomodifytags", "impl" })
      vim.list_extend(opts.ensure_installed, { "delve" })
    end,
  },
}
