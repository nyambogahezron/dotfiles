# Repository Instructions

This repo is a Stow-managed dotfiles workspace. Dotfiles are maintained in the repository root and symlinked to the home directory using GNU Stow.

Use [README.md](README.md) for setup and usage details, and [.github/workflows/validate.yml](.github/workflows/validate.yml) for the validation contract.

## Working Rules

- Keep changes minimal and modular.
- Link to existing docs instead of copying them into instructions.
- Respect the naming conventions:
  - `.*` for dotfiles in the root.
- Prefer the existing modular shell layout in `.config/shell/` when changing shell behavior.

## Validation

- Run `bash -n` on shell scripts and `zsh` files.
- Run `shellcheck` on non-template scripts.
- Follow the same checks used by CI in [.github/workflows/validate.yml](.github/workflows/validate.yml).
