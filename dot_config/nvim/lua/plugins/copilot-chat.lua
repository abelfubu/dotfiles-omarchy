-- { src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			model = "gpt-4.1",
			temperature = 0.1,
			window = {
				layout = "vertical",
				width = 0.33,
			},
			auto_insert_mode = true,
		},
	},
}
