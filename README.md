# Dan's Dotfiles

## How I use this

To just copy a folder to home, from the root of ".dotfiles", run `stow {project_name}`, e.g. `stow nvim`.

To create a version of a project with `$foo`/`${foo}` substitutions, run the `deploy` script with arguments `project` and `profile`:

`./deploy nvim home`

or

`./deploy nvim [work,home]`

Then `stow nvim_work`.
