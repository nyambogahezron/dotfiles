# Repository Instructions

This repo is a Chezmoi-managed dotfiles workspace. Prefer editing source templates under `home/`, especially `home/private_dot_config/**`, rather than generated files in the home directory.

Use [README.md](README.md) for setup and usage details, and [.github/workflows/validate.yml](.github/workflows/validate.yml) for the validation contract.

## Working Rules

- Keep changes minimal and template-safe.
- Link to existing docs instead of copying them into instructions.
- Respect the naming conventions used in `home/`:
  - `dot_*` for dotfiles
  - `private_*` for sensitive config
  - `.tmpl` for Chezmoi templates
  - `run_once_*` for one-time setup scripts
- Prefer the existing modular shell layout in `home/private_dot_config/shell/` when changing shell behavior.
- If setup scripts need to run again, reset Chezmoi script state instead of working around it.

## Validation

- Run `bash -n` on real shell scripts and `zsh` files.
- Run `shellcheck` only on non-template scripts.
- Verify Chezmoi templates with `chezmoi execute-template` before relying on rendered output.
- Follow the same checks used by CI in [.github/workflows/validate.yml](.github/workflows/validate.yml).
