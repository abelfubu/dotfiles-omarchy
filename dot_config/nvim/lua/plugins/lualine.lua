-- { src = "https://github.com/nvim-lualine/lualine.nvim" },

return {
	"nvim-lualine/lualine.nvim",
	enabled = false,
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local line = require("commands.fubuline")

		return {
			options = {
				globalstatus = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			tabline = {
				lualine_a = { line.buffers },
			},
			sections = {
				lualine_a = { line.mode },
				lualine_b = { { "branch", icon = "󰊢", color = { fg = "#f9e2af", bg = "none" } } },
				lualine_c = { "diagnostics" },
				lualine_x = line.create_lualine_items({ line.recording }),
				lualine_y = line.create_lualine_items({ line.lsp }),
				lualine_z = line.create_lualine_items({ line.cwd }),
			},
		}
	end,
}
