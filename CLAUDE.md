# Dotfiles Repo

## Overview

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) and a custom deploy script for profile-based templating.

## Structure

Each top-level directory is a **stow package** — its contents mirror the home directory layout and get symlinked into `~` when stowed.

| Directory | Contents |
|-----------|----------|
| `nvim/` | Neovim config (`~/.config/nvim/`) — lazy.nvim plugin manager, Lua-based config |
| `nvim_home_new/` | Deployed variant of `nvim/` for the `home_new` profile |
| `zsh/` | Zsh config (`.zshrc`, `fzf-git.sh`) |
| `zsh_home_new/` | Deployed variant of `zsh/` for the `home_new` profile |
| `tmux/` | tmux config (`.tmux.conf`) |
| `bat/` | bat config and Wombat color theme |
| `p10k/` | Powerlevel10k prompt config (`.p10k.zsh`) |
| `oh-my-zsh/` | Custom oh-my-zsh theme (`uncommon.zsh-theme`) |

## Deploying

### Simple stow (no templating)
```bash
stow nvim        # symlinks nvim/ contents into ~
stow tmux
stow bat
```

### Profile-based deploy (with variable substitution)
Some files use `$variable` / `${variable}` placeholders (e.g., `$home_dir`, `$zsh_path`). The `deploy.py` script renders these for a given profile, creating a new directory you can then stow.

```bash
# Render a single project for one profile
./deploy.py nvim home_new

# Render for multiple profiles at once
./deploy.py nvim [home,home_new]

# Then stow the rendered output
stow nvim_home_new
```

`deploy.py` is a [uv script](https://docs.astral.sh/uv/guides/scripts/) — run directly with `uv run deploy.py` or via the shebang (`./deploy.py`). It requires only `fire` (declared inline).

## Profiles (`config.toml`)

Profiles are defined in `config.toml` under `[profile.<name>]`. Each profile sets variables like `home_dir`, `zsh_path`, and Python binary paths. Profiles fall back to `[profile]` defaults for any unset keys.

Current profiles: `home`, `home_new`, `hinge`, `hinge_new`.

The files that receive substitution are listed under `[settings].files`:
- `zsh`: `.zshrc`, `fzf-git.sh`
- `nvim`: `.config/nvim/lua/settings.lua`

## Neovim Config

- Entry point: `nvim/.config/nvim/init.lua`
- Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim)
- Plugins defined in: `lua/plugins.lua`
- Key mappings: `lua/mappings.lua`
- LSP setup: `lua/lsp.lua`
- Completion: `lua/completion.lua`
- Colorscheme: `colors/vombato.vim` (Wombat-based)
- Snippets: `UltiSnips/` (tex, python)
