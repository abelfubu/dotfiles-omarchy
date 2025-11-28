if vim.g.vscode then
	require("config.vscode-keymaps")
	return
end

vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

require("config.lazy")
require("config.autocmd")
require("config.keymaps")
require("commands.jest-coverage").setup()
require("commands.quicktype").setup()

require("commands.fubutype")
require("config.lsp")
-- vim.cmd.colorscheme("catppuccin")

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end
