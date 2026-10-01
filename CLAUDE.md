# Dotfiles Repo

## Overview

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) and a custom deploy script for profile-based templating.

## Structure

Each top-level directory is a **stow package** — its contents mirror the home directory layout and get symlinked into `~` when stowed.

| Directory | Contents |
|-----------|----------|
| `nvim/` | Neovim config (`~/.config/nvim/`) — built-in `vim.pack` plugin manager, Lua-based config |
| `zsh/` | Zsh config (`.zshrc`, `fzf-git.sh`) |
| `zsh_<profile>/` | Generated (gitignored) variant of `zsh/` for a profile; `p10k_<profile>/` likewise |
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
Some files use `$variable` / `${variable}` placeholders (e.g., `$zsh_path`, `$aliases`). `deploy.py` builds `<package>_<profile>/` for each package: files listed in `[settings].files` are rendered with the profile's variables, and every other file is a relative symlink back to the source (so edits are live). Only profile variables are substituted; other `$names` (shell vars) are left alone. nvim is not templated — stow it directly.

```bash
./deploy.py home_new            # all packages in config.toml
./deploy.py home_new zsh        # one package

# Then stow the rendered output
stow zsh_home_new
```

`deploy.py` is a stdlib-only [uv script](https://docs.astral.sh/uv/guides/scripts/) — run via the shebang or `uv run deploy.py`. Tests: `uv run --with pytest pytest tests`.

## Profiles (`config.toml`)

Profiles are defined in `config.toml` under `[profile.<name>]`. Each profile sets variables like `home_dir`, `zsh_path`, and `aliases`. Profiles fall back to `[profile]` defaults for any unset keys.

Current profiles: `home`, `home_new`, `hinge`, `hinge_new`.

The files that receive substitution are listed under `[settings].files`:
- `zsh`: `.zshrc`

## Neovim Config

- Entry point: `nvim/.config/nvim/init.lua`
- Plugin manager: built-in `vim.pack` (nvim 0.12+). Revisions are pinned in `nvim-pack-lock.json`; stow `nvim/` directly so the lockfile is written into the repo
- Plugins defined in: `lua/plugins.lua`
- Key mappings: `lua/mappings.lua`
- LSP setup: `lua/lsp.lua`
- Completion: `lua/completion.lua`
- Colorscheme: `colors/vombato.vim` (Wombat-based)