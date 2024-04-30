return {
  -- disable indent scope line *animation*
  { "echasnovski/mini.indentscope", enabled = false },
  -- headlines in markdown documents; available in markdown extras but I don't like the linter
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true, -- or `opts = {}`
  },
}
