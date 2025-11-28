.config\nvim\lua\fubutype\README.md
# FubuType.nvim

FubuType is a minimal Neovim plugin that lets you practice typing the contents of your current file, with syntax highlighting and real-time feedback, inspired by Monkeytype.

## Features

- **Practice typing any file**: Start a typing session with the contents of your current buffer.
- **Syntax highlighting**: Both the reference and typing buffers use the original filetype for highlighting.
- **Real-time feedback**: Incorrect characters are highlighted as you type.
- **Split window layout**: Reference buffer on top, typing buffer below.
- **Easy quit**: Press `q` in normal mode in the typing buffer to exit the session.

## Usage

1. Open any file in Neovim.
2. Run the command:
   ```
   :FubuType
   ```
3. The window will split:
   - The top buffer shows the reference text (read-only).
   - The bottom buffer is where you type.
4. As you type, incorrect characters are highlighted in red.
5. Press `q` in normal mode in the typing buffer to quit FubuType and close the session.

## Installation

Place the `fubutype` directory in your `~/.config/nvim/lua/` directory, or use your favorite plugin manager to load it as a Lua module.

Example with `lazy.nvim`:
```lua
{
  dir = "~/.config/nvim/lua/fubutype",
  name = "fubutype",
  config = function()
    -- No setup required, just use :FubuType
  end,
}
```

## Customization & Roadmap

- **Stats**: WPM and accuracy tracking (planned)
- **Floating window mode** (planned)
- **Configurable keymaps** (planned)
- **Session summary** (planned)

Pull requests and suggestions are welcome!

---

Made with ❤️ for Neovim users who want to improve their typing.
