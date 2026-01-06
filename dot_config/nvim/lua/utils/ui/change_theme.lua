local M = {}

function M.change_theme()
  local items = {}

  for idx, command in ipairs(require("nvchad.utils").list_themes()) do
    local item = {
      idx = idx,
      name = command,
      text = command,
    }
    table.insert(items, item)
  end

  Snacks.picker {
    title = "  Theme Selector",
    layout = {
      preset = "select",
      preview = false,
      layout = { max_width = 50 },
    },
    items = items,
    format = function(item, _)
      return {
        { item.text, item.text_hl },
      }
    end,
    ---@diagnostic disable-next-line: unused-local
    on_change = function(picker, item)
      if item and type(item.name) == "string" then
        require("nvconfig").base46.theme = item.name
        require("base46").load_all_highlights()
      end
    end,
    confirm = function(picker, item)
      local old_theme = require("chadrc").base46.theme

      if type and type(item.name) == "string" then
        package.loaded.chadrc = nil
        old_theme = '"' .. old_theme .. '"'
        local theme = '"' .. item.name .. '"'

        require("nvchad.utils").replace_word(old_theme, theme)
      else
        require("nvconfig").base46.theme = old_theme
        require("base46").load_all_highlights()
      end

      return picker:norm(function()
        picker:close()
      end)
    end,
  }
end

return M
