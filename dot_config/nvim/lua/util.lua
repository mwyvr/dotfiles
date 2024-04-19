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

return M
