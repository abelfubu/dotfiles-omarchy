-- FubuType.nvim - Buffer-editing Monkeytype-style typing practice for Neovim
-- Author: You
-- Usage: :FubuType

local M = {}

local ns = vim.api.nvim_create_namespace("fubutype")

local state = {
	ref_lines = {},
	ref_hl = {}, -- stores syntax highlight group for each character
	buf = nil,
	win = nil,
	start_time = nil,
	stats = {
		correct = 0,
		incorrect = 0,
		total = 0,
		wpm = 0,
		accuracy = 100,
	},
}

-- Helper: close FubuType window and buffer, print stats
local function close_fubutype()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
	end
	if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
		vim.api.nvim_buf_delete(state.buf, { force = true })
	end
	state.win = nil
	state.buf = nil
	state.ref_lines = {}
	state.start_time = nil
	if state.stats and state.stats.total > 0 then
		vim.schedule(function()
			vim.notify(
				string.format(
					"FubuType session ended! WPM: %.1f | Accuracy: %.1f%% | Correct: %d | Incorrect: %d",
					state.stats.wpm,
					state.stats.accuracy,
					state.stats.correct,
					state.stats.incorrect
				),
				vim.log.levels.INFO
			)
		end)
	end
	state.stats = {
		correct = 0,
		incorrect = 0,
		total = 0,
		wpm = 0,
		accuracy = 100,
	}
end

-- Calculate and update stats
local function update_stats()
	local correct, incorrect, total = 0, 0, 0
	local typed_lines = vim.api.nvim_buf_get_lines(state.buf, 0, -1, false)
	for i, line in ipairs(typed_lines) do
		local ref_line = state.ref_lines[i] or ""
		for j = 1, #line do
			local char = line:sub(j, j)
			local ref_char = ref_line:sub(j, j)
			total = total + 1
			if char == ref_char then
				correct = correct + 1
			else
				incorrect = incorrect + 1
			end
		end
		-- Count missing chars as untouched (not incorrect)
		if #line < #ref_line then
			total = total + (#ref_line - #line)
		end
	end
	if not state.start_time or total == 0 then
		state.stats = { correct = correct, incorrect = incorrect, total = total, wpm = 0, accuracy = 100 }
		return
	end
	local elapsed = (vim.loop.hrtime() - state.start_time) / 1e9 -- seconds
	local minutes = math.max(elapsed / 60, 1 / 60)
	local wpm = correct > 0 and (correct / 5) / minutes or 0
	local accuracy = total > 0 and (correct / total) * 100 or 100
	state.stats = {
		correct = correct,
		incorrect = incorrect,
		total = total,
		wpm = wpm,
		accuracy = accuracy,
	}
end

-- Show reference text as virtual text in dark grey, overlay user input with buffer content and highlights for correct/incorrect

local function highlight_feedback()
	vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)
	local typed_lines = vim.api.nvim_buf_get_lines(state.buf, 0, -1, false)
	for i, ref_line in ipairs(state.ref_lines) do
		local user_line = typed_lines[i] or ""
		local virt_chunks = {}
		for j = 1, #ref_line do
			local ref_char = ref_line:sub(j, j)
			local user_char = user_line:sub(j, j)
			if user_char == "" or user_char == " " then
				-- Untyped: show reference char in dark grey
				table.insert(virt_chunks, { ref_char, "FubuTypeUntouched" })
			elseif user_char == ref_char then
				-- Correct: show user char in green
				table.insert(virt_chunks, { user_char, "FubuTypeCorrect" })
			else
				-- Incorrect: show user char in red
				table.insert(virt_chunks, { user_char, "FubuTypeIncorrect" })
			end
		end
		vim.api.nvim_buf_set_extmark(state.buf, ns, i - 1, 0, {
			virt_text = virt_chunks,
			virt_text_pos = "overlay",
			hl_mode = "combine",
		})
	end

	-- Stats as virtual text at top
	local stats = state.stats
	local virt = string.format(
		"WPM: %.1f | Accuracy: %.1f%% | Correct: %d | Incorrect: %d",
		stats.wpm,
		stats.accuracy,
		stats.correct,
		stats.incorrect
	)
	vim.api.nvim_buf_set_extmark(state.buf, ns, 0, 0, {
		virt_text = { { virt, "Comment" } },
		virt_text_pos = "eol",
		hl_mode = "combine",
	})
end

-- Prevent editing outside allowed region (optional, for Monkeytype feel)
local function enforce_forward_typing()
	-- Optionally, you can implement logic here to prevent moving cursor backward or deleting previous chars.
	-- For now, we allow normal editing.
end

-- Setup keymaps for quitting
local function setup_keymaps()
	vim.api.nvim_buf_set_keymap(state.buf, "n", "q", "", {
		noremap = true,
		silent = true,
		callback = close_fubutype,
		desc = "Quit FubuType",
	})

	-- Overwrite typing: map all printable keys in insert mode to replace-under-cursor
	local function overwrite_char(char)
		local pos = vim.api.nvim_win_get_cursor(state.win)
		local row, col = pos[1], pos[2]
		local line = vim.api.nvim_buf_get_lines(state.buf, row - 1, row, false)[1] or ""
		-- Only allow typing within the reference length
		local ref_line = state.ref_lines[row] or ""
		if col < #ref_line then
			line = line:sub(1, col) .. char .. line:sub(col + 2)
			vim.api.nvim_buf_set_lines(state.buf, row - 1, row, false, { line })
			vim.api.nvim_win_set_cursor(state.win, { row, col + 1 })
			update_stats()
			highlight_feedback()
		end
	end

	-- Map all printable ASCII characters to overwrite_char
	for i = 32, 126 do
		local c = string.char(i)
		vim.api.nvim_buf_set_keymap(
			state.buf,
			"i",
			c,
			("<Cmd>lua require'commands.fubutype'._overwrite_char(\"%s\")<CR>"):format(c:gsub('"', '\\"')),
			{ noremap = true, silent = true }
		)
	end
	-- Enter key: move to next line
	vim.api.nvim_buf_set_keymap(
		state.buf,
		"i",
		"<CR>",
		"<Cmd>lua require'commands.fubutype'._overwrite_enter()<CR>",
		{ noremap = true, silent = true }
	)
	-- Monkeytype-style backspace: custom handler
	vim.api.nvim_buf_set_keymap(
		state.buf,
		"i",
		"<BS>",
		"<Cmd>lua require'commands.fubutype'._overwrite_backspace()<CR>",
		{ noremap = true, silent = true }
	)
	-- Still prevent left arrow for now
	vim.api.nvim_buf_set_keymap(state.buf, "i", "<Left>", "<Nop>", { noremap = true, silent = true })
end

-- Public for keymaps
function M._overwrite_char(char)
	local pos = vim.api.nvim_win_get_cursor(state.win)
	local row, col = pos[1], pos[2]
	local line = vim.api.nvim_buf_get_lines(state.buf, row - 1, row, false)[1] or ""
	local ref_line = state.ref_lines[row] or ""
	if col < #ref_line then
		-- Start timer on first keystroke
		if not state.start_time then
			state.start_time = vim.loop.hrtime()
		end
		line = line:sub(1, col) .. char .. line:sub(col + 2)
		vim.api.nvim_buf_set_lines(state.buf, row - 1, row, false, { line })
		vim.api.nvim_win_set_cursor(state.win, { row, col + 1 })
		update_stats()
		highlight_feedback()
	end
end

function M._overwrite_backspace()
	local pos = vim.api.nvim_win_get_cursor(state.win)
	local row, col = pos[1], pos[2]
	if col == 0 then
		return
	end
	local line = vim.api.nvim_buf_get_lines(state.buf, row - 1, row, false)[1] or ""
	local ref_line = state.ref_lines[row] or ""
	-- Restore space at previous position (untyped)
	local new_line = line:sub(1, col - 1) .. " " .. line:sub(col + 1)
	vim.api.nvim_buf_set_lines(state.buf, row - 1, row, false, { new_line })
	vim.api.nvim_win_set_cursor(state.win, { row, col - 1 })
	update_stats()
	highlight_feedback()
end

function M._overwrite_enter()
	local pos = vim.api.nvim_win_get_cursor(state.win)
	local row = pos[1]
	if row < #state.ref_lines then
		vim.api.nvim_win_set_cursor(state.win, { row + 1, 0 })
	end
end

-- Setup highlight groups
local function setup_highlights()
	-- Lighter grey for untouched (to type), green for correct, red for incorrect
	vim.cmd("highlight default FubuTypeUntouched guifg=#888888 ctermfg=7")
	vim.cmd("highlight default FubuTypeCorrect guifg=#00ff00 ctermfg=2")
	vim.cmd("highlight default link FubuTypeIncorrect Error")
end

function M.start()
	setup_highlights()
	-- Save current buffer and lines as reference

	local cur_buf = vim.api.nvim_get_current_buf()

	state.ref_lines = vim.api.nvim_buf_get_lines(cur_buf, 0, -1, false)

	-- No hybrid: do not record syntax highlight group for each character in reference

	-- Create a new buffer for typing
	state.buf = vim.api.nvim_create_buf(false, true)
	-- Set buffer options
	vim.api.nvim_buf_set_option(state.buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(state.buf, "modifiable", true)
	vim.api.nvim_buf_set_option(state.buf, "swapfile", false)
	local filetype = vim.api.nvim_buf_get_option(cur_buf, "filetype")
	vim.api.nvim_buf_set_option(state.buf, "filetype", filetype)
	vim.api.nvim_buf_call(state.buf, function()
		vim.cmd("syntax enable")
	end)
	local ok, ts = pcall(require, "nvim-treesitter")
	if ok and ts.highlighter then
		pcall(function()
			vim.treesitter.start(state.buf, filetype)
		end)
	end

	-- Fill buffer with empty lines matching reference length (for overlay)
	local empty_lines = {}
	for i, ref in ipairs(state.ref_lines) do
		empty_lines[i] = string.rep(" ", #ref)
	end
	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, empty_lines)
	-- Disable Copilot for this buffer if available
	pcall(function()
		vim.b.copilot_enabled = false
	end)

	-- Open in a floating window
	local width = math.max(60, math.floor(vim.o.columns * 0.7))
	local height = math.max(10, math.floor(vim.o.lines * 0.7))
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)
	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
	})
	vim.api.nvim_win_set_option(state.win, "cursorline", true)
	vim.api.nvim_win_set_option(state.win, "wrap", false)
	vim.api.nvim_set_current_win(state.win)
	vim.api.nvim_win_set_cursor(state.win, { 1, 0 })
	-- Disable Copilot in this buffer if available
	pcall(function()
		vim.cmd("Copilot disable")
	end)

	setup_keymaps()
	-- state.start_time will be set on first keystroke
	update_stats()
	highlight_feedback()

	-- Autocmd for feedback on every change
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		buffer = state.buf,
		callback = function()
			update_stats()
			highlight_feedback()
			enforce_forward_typing()
		end,
		desc = "FubuType: Real-time feedback",
	})
end

vim.api.nvim_create_user_command("FubuType", function()
	M.start()
end, { desc = "Start FubuType typing practice" })

return M
