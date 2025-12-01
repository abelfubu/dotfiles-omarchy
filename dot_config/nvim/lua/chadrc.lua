local M = {}

M.base46 = {
	theme = "onedark",
	transparency = true,
	theme_toggle = { "onedark", "one_light" },
}

M.ui = {
	statusline = {
		theme = "default",
		separator_style = "round",
	},
	lsp = { signature = false },
}

-- Set Undercurl Highlighting
-- Enable undercurl for diagnostics
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#ff5370" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#ffcb6b" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#82aaff" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#c3e88d" })

-- Generic underline undercurl
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "Red" })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "Blue" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "Cyan" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "Magenta" })

return M
