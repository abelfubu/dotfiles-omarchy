local M = {}

local function get_language(filetype)
	print(filetype)
	local map = {
		typescript = "typescript",
		javascript = "typescript",
		python = "python",
		go = "go",
		rust = "rust",
		json = "typescript",
		cs = "csharp",
	}
	return map[filetype] or "typescript"
end

local function get_clipboard()
	return vim.fn.getreg("+")
end

local function run_quicktype(json, lang)
	local tmpfile = os.tmpname() .. ".json"
	local outfile = os.tmpname() .. ".txt"
	local f = io.open(tmpfile, "w")

	if f == nil then
		error("Could not open temporary file for writing")
		return
	end

	f:write(json)
	f:close()
	local just_types = lang == "csharp" and "--features=just-types" or "--just-types"
	local cmd =
		string.format('quicktype -l %s -o "%s" "%s" --alphabetize-properties %s', lang, outfile, tmpfile, just_types)

	local success, msg = os.execute(cmd)

	if success ~= 0 then
		error("quicktype command failed" .. (msg and ": " .. msg or ""))
		return
	end

	local out = io.open(outfile, "r")

	if out == nil then
		error("Could not open temporary file for writing")
		return
	end

	local result = out:read("*a")

	out:close()
	os.remove(tmpfile)
	os.remove(outfile)

	return result
end

function M.run()
	local json = get_clipboard()
	local ok, _ = pcall(vim.fn.json_decode, json)

	if not ok then
		vim.notify("Clipboard does not contain valid JSON", vim.log.levels.ERROR)
		return
	end

	local lang = get_language(vim.bo.filetype)
	local type_def = run_quicktype(json, lang)

	if type_def == nil or type_def == "" then
		vim.notify("Failed to generate type definitions", vim.log.levels.ERROR)
		return
	end

	vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(type_def, "\n"))
	vim.notify("Type definition inserted at end of buffer", vim.log.levels.INFO)
end

M.setup = function()
	vim.api.nvim_create_user_command("QuicktypeFromClipboard", M.run, {})
	vim.keymap.set(
		"n",
		"<leader>qt",
		"<cmd>QuicktypeFromClipboard<CR>",
		{ desc = "Generate Types from JSON in Clipboard" }
	)
end

return M
