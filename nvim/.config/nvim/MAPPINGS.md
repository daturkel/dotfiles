# Neovim Mappings Reference

Leader: `Space` | LocalLeader: `,`

## Core Mappings

| Key | Mode | Action |
|-----|------|--------|
| `j` / `k` | n | Move by visual lines (wraps) |
| `m` | n/x | Cut (delete to register) |
| `mm` | n | Cut line |
| `M` | n | Cut to end of line |
| `<CR>` | n | Clear search highlight |
| `<C-P>` | n | Go to next jump location (replaces `<C-I>`) |

## Window Management

| Key | Mode | Action |
|-----|------|--------|
| `<C-h/j/k/l>` | n | Move to split, or create one if none exists |

## LSP (`on_attach`)

| Key | Mode | Action |
|-----|------|--------|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gr` | n | References |
| `gi` | n | Go to implementation |
| `K` | n | Hover docs (press twice to enter/scroll) |
| `<leader>r` | n | Rename symbol |
| `<leader>ca` | n | Code action |
| `<leader>o` | n | Document symbols (Telescope) |
| `<leader>e` | n | Show diagnostic float (full message with source) — cursor over diagnostic range shows message instantly in command line |
| `[g` / `]g` | n | Previous / next diagnostic |
| `<C-s>` | i | Toggle signature help (lsp_signature) |

## Telescope (`<localleader>` = `,`)

| Key | Action |
|-----|--------|
| `,f` | Find files |
| `,g` | Git files |
| `,l` | Fuzzy find in current buffer |
| `,m` | Open buffers |
| `,r` | Live grep |
| `,h` | Recent files |
| `,t` | Telescope picker list |
| `,d` | Diagnostics |
| `,s` | LSP document symbols |
| `,S` | LSP workspace symbols |
| `<C-p>` | Toggle preview (inside Telescope) |
| `<Esc>` | Close Telescope |

## conform.nvim (Python & Go buffers)

| Key | Action |
|-----|--------|
| `,b` | Format buffer |

## Markdown buffers

| Key | Action |
|-----|--------|
| `,p` | Toggle markview preview |
| `-` | Cycle checkbox state (`[ ]` → `[.]` → `[x]` → `[ ]`) |

## indent-blankline

| Key | Action |
|-----|--------|
| `<C-i>` | Toggle indent guides |
