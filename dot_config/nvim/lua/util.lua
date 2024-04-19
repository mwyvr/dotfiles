local M = {}

-- attempt to determine the root directory of a project
-- set in personal config vim.g.root_markers = { ".git", "go.mod" }
function M.root()
	if vim.g.root_markers == nil then
		vim.g.root_markers = { ".git", "go.mod" }
	end

	local p = vim.api.nvim_buf_get_name(0)
	if p == "" or p == nil then
		-- when in dashboard or other bufs not associated with files
		p = vim.fn.getcwd()
	end

	root_marker = vim.fs.find(vim.g.root_markers, { path = p, upward = true })[1]
	if not root_marker then
		return p
	end
	path = require("plenary.path"):new(root_marker)
	return path:parent():absolute()
end

-- determine if neotree is open
function M.isExplorerOpen()
	local manager = require("neo-tree.sources.manager")
	local renderer = require("neo-tree.ui.renderer")
	local state = manager.get_state("filesystem")
	return renderer.window_exists(state)
end

M.icons = {
	misc = {
		dots = "󰇘",
	},
	dap = {
		Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
		Breakpoint = " ",
		BreakpointCondition = " ",
		BreakpointRejected = { " ", "DiagnosticError" },
		LogPoint = ".>",
	},
	diagnostics = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},
	git = {
		added = " ",
		modified = " ",
		removed = " ",
	},
	kinds = {
		Array = " ",
		Boolean = "󰨙 ",
		Class = " ",
		Codeium = "󰘦 ",
		Color = " ",
		Control = " ",
		Collapsed = " ",
		Constant = "󰏿 ",
		Constructor = " ",
		Copilot = " ",
		Enum = " ",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = " ",
		Folder = " ",
		Function = "󰊕 ",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = "󰊕 ",
		Module = " ",
		Namespace = "󰦮 ",
		Null = " ",
		Number = "󰎠 ",
		Object = " ",
		Operator = " ",
		Package = " ",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = "󰆼 ",
		TabNine = "󰏚 ",
		Text = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = " ",
		Variable = "󰀫 ",
	},
}

return M
