# Dotfiles Repo

## Overview

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). No templating or deploy step: every package is stowed directly.

## Structure

Each top-level directory is a **stow package** — its contents mirror the home directory layout and get symlinked into `~` when stowed.

| Directory | Contents |
|-----------|----------|
| `nvim/` | Neovim config (`~/.config/nvim/`) — built-in `vim.pack` plugin manager, Lua-based config |
| `zsh/` | Zsh config (`.zshrc`, `fzf-git.sh`) |
| `tmux/` | tmux config (`.tmux.conf`) |
| `bat/` | bat config and Wombat color theme |
| `p10k/` | Powerlevel10k prompt config (`.p10k.zsh`) |

## Deploying

```bash
stow nvim zsh p10k tmux bat
```

Per-machine zsh settings live in an untracked `~/.zshrc.local`, sourced by `.zshrc`.

## Neovim Config

- Entry point: `nvim/.config/nvim/init.lua`
- Plugin manager: built-in `vim.pack` (nvim 0.12+). Revisions are pinned in `nvim-pack-lock.json`; stow `nvim/` directly so the lockfile is written into the repo
- Plugins defined in: `lua/plugins.lua`
- Key mappings: `lua/mappings.lua`
- LSP setup: `lua/lsp.lua`
- Completion: `lua/completion.lua`
- Colorscheme: `colors/vombato.vim` (Wombat-based)