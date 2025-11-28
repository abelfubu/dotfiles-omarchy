-- { src = "https://github.com/mason-org/mason.nvim" }
-- { src = "https://github.com/mason-org/mason-lspconfig.nvim" }
-- { src = "https://github.com/neovim/nvim-lspconfig.nvim" }

return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		automatic_enable = true,
		ensure_installed = {
			"lua_ls",
			"emmet_language_server",
			"vtsls",
			"angularls",
			"eslint",
			"tailwindcss",
			"gopls",
			"jsonls",
			"yamlls",
			"html",
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
