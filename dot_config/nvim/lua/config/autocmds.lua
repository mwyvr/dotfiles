local function augroup(name)
	return vim.api.nvim_create_augroup("nvcfg" .. name, { clear = true })
end

-- default for other types is 4
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("luatab"),
	pattern = { "lua" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

-- run `chezmoi apply` on save
vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup("chezmoi"),
	pattern = { "~/.local/share/chezmoi/*" },
	command = 'chezmoi apply --source-path "%"',
})

-- ensure Neotree buffer not saved in sessions
vim.api.nvim_create_autocmd("QuitPre", {
	group = augroup("neotreeclose"),
  callback = function()
    vim.cmd("Neotree close")
    vim.cmd("qa")
  end
})

-- format on save only for certain filetypes
-- /gf will apply LSP formatting to the current buffer for others
vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup("formatonsave"),
  -- see config/options.lua
	pattern = vim.g.format_on_save,
	callback = function()
	vim.lsp.buf.format({})
	end
})

-- restore cursor at last location
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_location"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
			return
		end
		vim.b[buf].last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
