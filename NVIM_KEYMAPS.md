# Neovim keymaps

Leader is `<Space>`, localleader is `,`. Sources: `lua/mappings.lua`, `lua/lsp.lua`, `lua/telescope-settings.lua`, `lua/completion.lua`, `lua/plugins.lua`, `lua/settings.lua`.

## Editing

| Key | Mode | Action | Notes |
|---|---|---|---|
| `m` / `mm` / `M` | n (`m` also x) | Cut (`d` / `dd` / `D`) | vim-cutlass makes `d`/`c`/`x` skip the yank register; `m` is non-recursive so it still yanks. Replaces marks. |
| `Q` | n, v, o | Format (`gq`) | Replaces macro replay. |
| `j` / `k` | n | Move by visual line | |
| `<CR>` | n | Clear search highlight | Unmapped in quickfix. |
| `<C-i>` | n | Toggle indent guides | Replaces jump-forward. |
| `<C-p>` | n | Jump forward | Stands in for the old `<C-i>`. |
| `-` | n (markdown) | Cycle checkbox `[ ]` → `[.]` → `[x]` | Shadows "previous line". |
| `<Esc>` | t | Leave terminal mode | |

## Windows

| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Move to the split in that direction, or create one if there isn't one (`WinMove`) |

## Find (Telescope, `,` prefix)

| Key | Action |
|---|---|
| `,f` | Files |
| `,g` | Git files |
| `,l` | Lines in buffer |
| `,m` | Buffers |
| `,r` | Live grep |
| `,h` | Recent files |
| `,t` | Telescope builtins |
| `,d` | Diagnostics |
| `,s` | Document symbols |
| `,S` | Workspace symbols |

## LSP

| Key | Action | Source |
|---|---|---|
| `gd` / `gD` | Definition / declaration | Custom (Neovim has no LSP default) |
| `K` | Hover | Built-in |
| `grr` | References (Telescope) | Custom override of the 0.11 default |
| `gri` / `grt` | Implementation / type definition | Built-in (0.11) |
| `grn` | Rename | Built-in (0.11) |
| `gra` | Code action | Built-in (0.11) |
| `gO` | Document symbols | Built-in (0.11) |
| `<C-s>` (insert) | Signature help | Built-in (0.11) |
| `[d` / `]d` | Previous / next diagnostic | Built-in (0.11) |
| `<C-w>d` | Diagnostic float | Built-in |
| `<leader>e` | Diagnostic float | Custom (kept: easier to reach than `<C-w>d`) |
| `,b` (python, go) | Format buffer (conform) | Custom; format-on-save is also on |

## Completion (nvim-cmp)

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / previous item, or trigger completion |
| `<CR>` | Confirm |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort |
| `<C-b>` / `<C-f>` | Scroll docs |

## Other

| Key | Action |
|---|---|
| `,p` (markdown) | Toggle Markview |

---

## Duplicates and conflicts

Resolved:

1. **`<C-h/j/k/l>` was mapped twice.** Deleted the plain `<C-W>` set, so only `WinMove` remains.
2. **`<leader>r`, `<leader>ca`, `<leader>o` duplicated built-ins.** Deleted them. Use `grn`, `gra` and `gO`.
3. **`<leader>o` and `,s` both opened document symbols.** `<leader>o` is gone (see 2), so `,s` (Telescope) and `gO` (built-in) remain.
4. **`<leader>e` vs `<C-w>d`.** Kept `<leader>e`.

5. **`,b` vs format-on-save.** Kept both. `,b` formats without saving.
6. **`grr`** is remapped to Telescope references (the built-in opens the quickfix list).

Not a duplicate:

7. **`gd` / `gD`** aren't duplicates. The built-in `gd` is Vim's local-declaration search. These are LSP.

### Overridden built-ins (worth knowing, not necessarily wrong)

| Key | Built-in behavior you lose |
|---|---|
| `m` | Set mark (you don't use marks) |
| `M` | Jump to middle of screen |
| `Q` | Replay macro |
| `<C-i>` | Jump forward (moved to `<C-p>`) |
| `<C-p>` | Move up a line |
| `<CR>` | Move down a line |
| `-` (markdown) | Previous line, first non-blank |
| `<C-h/j/k/l>` | Backspace, down, up, redraw |
| `,` | Repeat `f`/`t` backwards (now a prefix, so a bare `,` waits for `timeoutlen`) |

### Unconventional but harmless

- Telescope under `,` rather than `<leader>f*` (the common convention) or `<leader>s*` (kickstart).
- `<CR>` clears highlights, where `<Esc>` is more common. It needs a quickfix exception because of this.
