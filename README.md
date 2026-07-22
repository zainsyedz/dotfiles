# zdotfiles

This repository manages your dotfiles with a single script, `zdotfiles-sync`, to sync between the repo and your home directory.

## Script

Path: `~/zdotfiles/zdotfiles-sync`

- Subcommands:
  - `push`: Copy from repo to home
  - `pull`: Copy from home to repo (depth‑1 gate)
- Flags:
  - `--dry-run`: Show what would change
  - `--no-confirm`: Skip prompts (except with `--delete`)
  - `--only <list>`: Comma-separated or repeated: `config,home,ssh`
  - `--delete`: Delete extra files in destination (always prompts)
  - `--clean-ignored`: After `pull`, remove repo files matched by `.zdotfilesignore`

## Behavior

- Uses `rsync` only; install it if missing.
- No symlinks stored: transfers dereference links (`-L`).
- SSH rules:
  - Excludes private keys (`id_*`, `*.pem`, `*.key`) in both directions; `id_*.pub` allowed
  - Hardens `~/.ssh` after push: dirs `700`; files `600`; `*.pub` `644`
- Push (repo → home): copies all items found under `.config`, `homeDir`, `.ssh` recursively.
- Pull (home → repo): only syncs immediate entries that already exist in repo; for any directory entry, pull recursively to all depths.
- `--delete`: prunes extra files on the destination side for the selected sections/items; always prompts for confirmation.
- `--clean-ignored`: after pull, cleans ignored files from the repo using `.zdotfilesignore` only; it never deletes from home.

## Examples

- Preview pushing only `.config`:
  `~/zdotfiles/zdotfiles-sync push --dry-run --only config`

- Pull everything (will preview then prompt):
  `~/zdotfiles/zdotfiles-sync pull`

- Pull and prune extras in repo to match home (will always prompt):
  `~/zdotfiles/zdotfiles-sync pull --delete`

- Pull, then clean generated files from the repo using `.zdotfilesignore`:
  `~/zdotfiles/zdotfiles-sync pull --clean-ignored`

- Non-interactive push of all sections:
  `~/zdotfiles/zdotfiles-sync push --no-confirm`
