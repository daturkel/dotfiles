# Dan's Dotfiles

Each top-level directory is a [GNU Stow](https://www.gnu.org/software/stow/) package. From the root of `.dotfiles`, run `stow {package}`, e.g. `stow nvim`.

Per-machine settings (exports, extra aliases, work-only config) go in `~/.zshrc.local`, which `.zshrc` sources if present and is not tracked.
