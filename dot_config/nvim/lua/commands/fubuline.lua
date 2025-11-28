local M = {}

M.setup = function(opts)
	M.opts = opts or {}
end

M.lsp_map = {
	["GitHub Copilot"] = "",
	angularls = "󰚿",
	copilot = "",
	cssls = "",
	emmet_ls = "󰟛",
	eslint = "",
	gopls = "",
	html = "",
	jsonls = "",
	lua_ls = "󰢱",
	marksman = "󰽛",
	omnisharp = "",
	rustls = "󱘗",
	tsserver = "",
	tailwindcss = "",
	vstls = "",
	vtsls = "",
	yamlls = "",
}

M.get_icon_by_lsp = function(client_name)
	return M.lsp_map[client_name] or ""
end

M.mode = {
	"mode",
	color = { bg = "none", fg = "#ef7e7e", gui = "bold" },
	fmt = function(str)
		local modeMap = {
			NORMAL = " ",
			INSERT = " ",
			VISUAL = "󰕢 ",
			REPLACE = "󰛔 ",
			COMMAND = " ",
			TERMINAL = " ",
			["V-LINE"] = "󰒉 ",
			["V-BLOCK"] = "󰩭 ",
		}

		return (modeMap[str] or "")
	end,
}

M.empty = {
	"mode",
	color = { fg = "none", bg = "none" },
	fmt = function()
		return " "
	end,
}

M.buffers = {
	"buffers",
	padding = 1,
	icon = "󰈙 ",
	buffers_color = {
		active = { fg = "#ffffff", bg = "none", gui = "bold" },
		inactive = { fg = "#aaaaaa", bg = "None" },
	},
	symbols = {
		modified = " ",
		alternate_file = "", -- 󰎩
		directory = "",
	},
	fmt = function(bname)
		if bname == "[No Name]" then
			return " "
		end

		return bname
	end,
}

M.cwd = {
	color = "#a6e3a1",
	icon = "󰴊",
	value = function()
		return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	end,
}

M.recording = {
	icon = "󰄀",
	color = "#f9e2af",
	value = function()
		local rec = vim.fn.reg_recording()
		if rec ~= "" then
			return "@" .. rec
		end
		return ""
	end,
	cond = function()
		return vim.fn.reg_recording() ~= ""
	end,
}

M.lsp = {
	color = "#B8D2B3",
	icon = "󰗊",
	value = function()
		local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })

		if #clients == 0 then
			return " "
		end

		local names = vim.tbl_map(function(client)
			return M.get_icon_by_lsp(client.name)
		end, clients)

		return table.concat(names, " ") .. " "
	end,
}

---@class FubulineItem
---@field color function|string
---@field value function|string
---@field icon string
---@field cond? function
---@field format? function

---Creates a lua line item
---@param items FubulineItem[]
M.create_lualine_items = function(items)
	local result = {}

	for _, item in ipairs(items) do
		table.insert(result, {
			function()
				return " "
				-- return ""
			end,
			padding = { left = 1, right = 0 },
			separator = { left = "", right = "" },
			color = { fg = "#cccccc", bg = "None" },
			cond = item.cond or function()
				return true
			end,
		})
		table.insert(result, {
			item.value,
			icon = { item.icon .. "->" },
			separator = "",
			padding = 0,
			color = function()
				local fg = type(item.color) == "function" and item.color() or item.color
				return { fg = fg, bg = "none" }
			end,
			cond = item.cond or function()
				return true
			end,
		})
		table.insert(result, {
			function()
				return ""
				-- return ""
			end,
			padding = { left = 0, right = 1 },
			separator = "",
			color = { fg = "#cccccc", bg = "none" },
			cond = item.cond or function()
				return true
			end,
		})
	end

	return result
end

return M
