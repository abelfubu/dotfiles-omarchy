local M = {}

local function normalize_path(path)
	return path:gsub("\\", "/")
end

function M.run()
	local filepath = vim.api.nvim_buf_get_name(0)
	local normalized_filepath = normalize_path(filepath)
	local filename = vim.fn.fnamemodify(normalized_filepath, ":t")

	local jest_command = string.format([[npx jest "%s"]], filename)

	vim.fn.setreg("+", jest_command)
	vim.fn.setreg("*", jest_command)

	vim.cmd("belowright new")
	vim.fn.termopen(jest_command)

	vim.api.nvim_buf_set_keymap(0, "n", "q", ":bdelete<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_option_value("number", false, { scope = "local" })
	vim.api.nvim_set_option_value("relativenumber", false, { scope = "local" })
end

function M.run_with_coverage()
	local filepath = vim.api.nvim_buf_get_name(0)
	local normalized_filepath = normalize_path(filepath)
	local filename = vim.fn.fnamemodify(normalized_filepath, ":t")

	local jest_command =
		string.format([[npx jest "%s" --coverage --collectCoverageFrom "**/%s"]], filename, filename:gsub("spec.", ""))

	vim.fn.setreg("+", jest_command)
	vim.fn.setreg("*", jest_command)

	vim.cmd("belowright new")
	vim.fn.termopen(jest_command)

	vim.api.nvim_buf_set_keymap(0, "n", "q", ":bdelete<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_option_value("number", false, { scope = "local" })
	vim.api.nvim_set_option_value("relativenumber", false, { scope = "local" })
end

function M.setup()
	vim.api.nvim_create_user_command("JestCoverageCommand", M.run_with_coverage, {})
	vim.api.nvim_create_user_command("JestRunCommand", M.run_with_coverage, {})
	vim.keymap.set("n", "<leader>tc", "<cmd>JestCoverageCommand<CR>", { desc = "Run Jest Coverage" })
	vim.keymap.set("n", "<leader>tt", "<cmd>JestRunCommand<CR>", { desc = "Run Jest Coverage" })
end

return M
