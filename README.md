# Dan's Dotfiles

## How I use this

To just copy a folder to home, from the root of ".dotfiles", run `stow {project_name}`, e.g. `stow nvim`.

To create a profile-specific version of a project with `$foo`/`${foo}` substitutions, run `deploy.py` with a profile and optional packages:

`./deploy.py home_new zsh`

Then `stow zsh_home_new`. Non-templated files in the output are symlinks back to the source.
