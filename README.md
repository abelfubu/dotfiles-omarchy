# 🎛️ Abel's Dotfiles (chezmoi) 📦

These configs mirror my macOS/Linux workflow: Zsh + Neovim + tmux + Ghostty + Aerospace/Vicinae + Linux compositor helpers. I keep everything in `chezmoi` so a fresh machine is a single `brew bundle` and `chezmoi apply` away.

## 1. Install Homebrew (macOS / Linux)

- macOS: run `brew`’s installer:
  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
  Follow the post-install notes to add Homebrew to your `PATH`.
- Linux: install prerequisites (example for Debian/Ubuntu) and then reuse the same script:

  ```sh
  sudo apt update && sudo apt install build-essential procps curl file git
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

  Afterward, source `~/.linuxbrew/bin/brew` (or the path printed by the installer).

- Install `chezmoi`:

  ```sh
  brew install chezmoi
  ```

## 2. Configure a fresh machine (macOS & Linux)

1. Supply template data:
   ```sh
   chezmoi data set email you@example.com
   chezmoi data set font "SF Mono"
   ```
   This keeps `ghostty`, `vicinae`, `git/config.tmpl`, and other templates happy.
2. Clone this repo (or point `chezmoi init` to it) and apply (after `chezmoi` is installed):
   ```sh
   chezmoi init https://github.com/abelfubu/dotfiles-omarchy
   ```
3. Install Homebrew dependencies:

   ```sh
   brew bundle --file=$(chezmoi source-path)/Brewfile
   ```

4. Run `chezmoi apply` to render dotfiles.
5. macOS-only: Aerospace + Ghostty + Vicinae configs land automatically; keep the `dot_local/share` themes private.
6. Linux-only: When on Wayland, apply `dot_config/hypr`, `dot_config/waybar`, and `dot_config/zed` after `chezmoi apply` so compositor/keymap files are present.

## 3. Layout overview

| File/Area                        | Purpose                                                                                                                                                                                   |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Brewfile`                       | All Homebrew formulas (`bat`, `chezmoi`, `fzf`, ...), helper taps, and productivity casks (`aerospace`, `raycast`, `zed`, ...). Run `brew bundle --file=$(chezmoi source-path)/Brewfile`. |
| `dot_zshrc`                      | Boots `zoxide`, `mise`, `starship`, `fzf`, and Zplug. History is shared, `eza` replaces `ls`, and git aliases stay handy.                                                                 |
| `dot_config/starship.toml`       | Custom prompt with a two-line header, git state badges, and curated glyphs; extra modules like `memory_usage`/`kubernetes` stay disabled.                                                 |
| `dot_config/git/config.tmpl`     | Git aliases, rebase-on-pull, histogram diffs, rerere, and GitHub credential helpers wired via `gh`.                                                                                       |
| `dot_config/nvim/...`            | Neovim Lua tree plus `FubuType.nvim` (see `lua/commands/fubutype/README.md`) for typing practice with syntax-highlighting reference.                                                      |
| `dot_config/tmux/tmux.conf`      | `M-t` prefix, mouse/true-color support, clean status, dot-style borders.                                                                                                                  |
| `dot_config/aerospace/…`         | macOS tiling layer (gaps, colored borders, workspace bindings, handy shortcuts).                                                                                                          |
| `dot_config/ghostty/config.tmpl` | Ghostty theming, fonts, and cursor tweaks pulled from Omniarchy-managed themes.                                                                                                           |
| `dot_config/vicinae/...`         | Vicinae file manager theme & keybindings; templates reference `dot_local/share/vicinae/themes`.                                                                                           |
| `dot_config/hypr`                | Linux hyprland compositor configs (themes, keybindings, workspace rules).                                                                                                                 |
| `waybar`                         | Linux Wayland stack configs applied when you’re on a Wayland host.                                                                                                                        |
| `zed`                            | Zed editor configuration                                                                                                                                                                  |
| `dot_local`                      | Machine-specific, non-public assets (Vicinea themes, local overrides).                                                                                                                    |

## 4. Day-to-day tweaks

- Shell stays snappy: shared history, deferred Zplug plugins, and aliases that point `ls`/`vim` to their modern counterparts.
- Starship only shows git extras when needed and uses symbols for success/failure states.
- Neovim modules are organized under `lua/` so lazy-loaders can pick them up; the typing practice command is front-and-center via `:FubuType`.
- tmux, Ghostty, Aerospace, and Vicinae share the same color language so muscle memory stays consistent.

## 5. Maintenance notes

- When adding brew dependencies, update `Brewfile` and run `brew bundle --file=$(chezmoi source-path)/Brewfile`; include any generated lockfile.
- Keep `dot_local` minimal—only add host-specific assets or secrets that must stay out of git.
- Refresh template data with `chezmoi data set ...` when your email, font, or other shared metadata changes.

Pull requests and suggestions welcome—thanks for stepping through my rig! ✨
