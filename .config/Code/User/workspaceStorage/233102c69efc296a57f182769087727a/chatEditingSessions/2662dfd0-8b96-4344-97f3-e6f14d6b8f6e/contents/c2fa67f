# Husky Git Hooks Setup

This project uses Husky to ensure code quality before commits and pushes.

## What's Configured

### Pre-commit Hook

Runs on every commit attempt:

- **Lint-staged**: Automatically formats and lints only staged files
- **Type checking**: Ensures TypeScript types are valid
- **Fast execution**: Only checks changed files

### Pre-push Hook

Runs before pushing to remote:

- **Full linting**: Checks all files for linting issues
- **Test suite**: Runs complete test suite
- **Build verification**: Ensures the project builds successfully

### Commit Message Hook

Validates commit messages follow conventional commits format:

- `feat(scope): description` - new features
- `fix(scope): description` - bug fixes
- `docs(scope): description` - documentation changes
- `refactor(scope): description` - code refactoring
- And more...

## Manual Testing

You can manually test the hooks without making commits:

```bash
# Test pre-commit checks
bun run pre-commit

# Test pre-push checks
bun run pre-push

# Test individual components
bun run lint
bun run format
bun run check-types
bun run test
bun run build
```

## Lint-staged Configuration

The following file patterns are automatically processed:

- **JS/TS files**: ESLint fix + Prettier format
- **JSON/MD/YAML**: Prettier format only

## Bypassing Hooks (Not Recommended)

In emergency situations only:

```bash
# Skip pre-commit
git commit --no-verify -m "emergency fix"

# Skip pre-push
git push --no-verify
```

## Troubleshooting

If hooks fail:

1. Fix the reported issues
2. Stage your changes again
3. Retry the commit/push

The hooks help maintain code quality and prevent broken code from entering the repository.
