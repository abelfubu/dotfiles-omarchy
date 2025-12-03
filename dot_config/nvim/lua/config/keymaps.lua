-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("n", "-", "<leader>fm", { remap = true, desc = "Mini files" })
vim.keymap.set("n", "g.", "<leader>ca", { remap = true, desc = "Code actions" })
vim.keymap.set("n", "gt", require("base46").toggle_theme, { remap = true, desc = "Toggle theme" })
vim.keymap.set({ "n", "i" }, "<D-s>", function()
	vim.cmd([[:w]])
end, { desc = "Save file" })
