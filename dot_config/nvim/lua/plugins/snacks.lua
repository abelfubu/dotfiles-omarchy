-- { src = "https://github.com/folke/snacks.nvim" },

return {
	"folke/snacks.nvim",
	opts = {
		explorer = {
			replace_netrw = true,
		},
		picker = {
			ui_select = true,
			formatters = {
				file = {
					filename_first = true,
				},
			},
			sources = {
				explorer = {
					layout = {
						preset = "vscode",
						cycle = false,
						layout = { position = "right", width = 0.33 },
					},
				},
			},
		},
	},
}
