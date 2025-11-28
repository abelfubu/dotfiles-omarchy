-- { src = "https://github.com/saghen/blink.cmp" },

return {
	"saghen/blink.cmp",
	opts = {
		fuzzy = { implementation = "lua" },
		keymap = {
			preset = "enter",
			["<C-e>"] = { "show" },
		},
	},
}
