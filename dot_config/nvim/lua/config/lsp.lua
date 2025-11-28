vim.diagnostic.config({
	-- virtual_lines = { current_line = true },
	virtual_text = true,
	float = { border = "rounded", focusable = true, auto = true },
	severity_sort = true,
	underline = { severity = { min = vim.diagnostic.severity.HINT } },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "", -- 
			[vim.diagnostic.severity.WARN] = "", -- 
			[vim.diagnostic.severity.HINT] = "󱐌", -- 
			[vim.diagnostic.severity.INFO] = "󰙎", -- 
		},
	},
})
