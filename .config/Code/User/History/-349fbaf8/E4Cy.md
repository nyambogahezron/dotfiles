# 📦 Packages Version Aligner 

A comprehensive, interactive tool for managing packages across your monorepo workspaces. This tool allows you to easily add, update, remove, and sync packages across all your apps and packages with a beautiful CLI interface.

## ✨ Features

### 🚀 Core Functionality

- **Add/Update Packages**: Install or update packages across multiple workspaces
- **Remove Packages**: Clean removal of packages from selected workspaces
- **Version Sync**: Sync package versions across all workspaces
- **Package Overview**: List all packages and their versions across workspaces
- **⚠️ Conflict Detection**: Find and resolve packages with multiple versions
- **📦 Package Installation**: Automatically install packages after updates

### 🎯 Advanced Features

- **Interactive CLI**: Beautiful, user-friendly command-line interface
- **Selective Updates**: Choose specific workspaces or update by type (apps/packages)
- **Dependency Type Selection**: Support for dependencies, devDependencies, and peerDependencies
- **Dry Run Mode**: Preview changes before applying them
- **Workspace Detection**: Automatically discovers all package.json files in your monorepo
- **Smart Conflict Resolution**: Multiple strategies for resolving version conflicts
- **Automatic Installation**: Detects package manager and installs packages after updates

### 🏗️ Workspace Support

- **Root Workspace**: Main package.json in the repository root
- **Apps**: All applications in the `apps/` directory
- **Packages**: All packages in the `packages/` directory

## 🚀 Quick Start

### TypeScript Version (Recommended)

Run the interactive TypeScript version with beautiful UI:

```bash
# Using bun (recommended)
bun run align-versions

# Using npm
npm run align-versions

# Using yarn
yarn update-packages
```

### Shell Script Version

Run the bash script version (requires `jq`):

```bash
# Using npm script
npm run align-versions-sh

# Direct execution
./scripts/update-packages.sh
```

## 📖 Usage Examples

### Example 1: Adding TypeScript 5.6.0 to All Workspaces

1. Run `bun run align-versions`
2. Select "➕ Add/Update a package"
3. Enter package name: `typescript`
4. Enter version: `^5.6.0`
5. Select dependency type: `🔧 devDependencies`
6. Choose scope: `🌍 All workspaces`
7. Enable dry run to preview changes
8. Apply changes if satisfied

### Example 2: Updating React Only in Apps

1. Run `bun run align-versions`
2. Select "➕ Add/Update a package"
3. Enter package name: `react`
4. Enter version: `^18.3.0`
5. Select dependency type: `📦 dependencies`
6. Choose scope: `🎯 By workspace type (apps/packages)`
7. Select: `📱 Apps`
8. Apply changes

### Example 3: Syncing Package Versions

1. Run `bun run align-versions`
2. Select "🔄 Sync package versions across workspaces"
3. Enter package name: `typescript`
4. Select the target version from available options
5. Preview and apply changes

### Example 4: Finding and Resolving Version Conflicts

1. Run `bun run align-versions`
2. Select "⚠️ Find and resolve version conflicts"
3. Review the detected conflicts (packages with multiple versions)
4. Choose resolution strategy:
   - **🔄 Resolve all conflicts interactively**: Go through each package one by one
   - **🎯 Choose specific packages to resolve**: Select only certain packages
   - **⚡ Auto-resolve to most common versions**: Automatically pick the most used version
   - **🚀 Auto-resolve all to latest versions**: Update everything to latest
5. For interactive resolution, choose target version or enter custom version
6. Preview and apply changes

### Example 6: Installing Packages

1. Run `bun run align-versions`
2. Select "📦 Install packages in workspaces"
3. Choose installation scope:
   - **🌍 All workspaces**: Install in all workspaces
   - **🎯 By workspace type**: Install in specific types (apps/packages)
   - **✨ Custom selection**: Choose specific workspaces
4. Confirm installation with detected package manager
5. Packages will be installed automatically

### Automatic Installation After Updates

After any package modification (add, remove, sync, or conflict resolution), you'll be prompted:

- **"Install packages now?"** - Automatically runs the appropriate package manager
- **Package Manager Detection**: Automatically detects bun, yarn, pnpm, or npm
- **Monorepo Support**: Installs from root for monorepos or individually for standalone projects
- **Manual Instructions**: If installation fails, shows manual commands to run

### Example 7: Excluding Specific Workspaces

1. Run `bun run align-versions`
2. Select "➕ Add/Update a package"
3. Enter package details
4. Choose scope: `✨ Custom selection`
5. Select only the workspaces you want to update
6. Apply changes

## 🛠️ Installation Requirements

### TypeScript Version

- **Bun**: Primary runtime (recommended)
- **Dependencies**: `@clack/prompts`, `picocolors` (already included in your project)

### Shell Script Version

- **jq**: JSON processor

  ```bash
  # Ubuntu/Debian
  sudo apt install jq

  # macOS
  brew install jq

  # CentOS/RHEL
  sudo yum install jq
  ```

## 📁 File Structure

```
scripts/
├── update-packages.ts     # TypeScript version (feature-rich)
└── update-packages.sh     # Shell script version (lightweight)
```

## 🎨 Features Breakdown

### Interactive Menu System

- **Beautiful CLI**: Powered by `@clack/prompts` with colorful, intuitive interface
- **Multi-select Options**: Choose multiple workspaces or dependency types
- **Progress Indicators**: Spinners and status messages for long operations
- **Error Handling**: Graceful error handling with helpful messages

### Workspace Management

- **Auto-discovery**: Automatically finds all package.json files
- **Type Classification**: Categorizes workspaces as root, apps, or packages
- **Path Display**: Shows relative paths for easy identification

### Dependency Management

- **Version Flexibility**: Support for exact versions, ranges, or "latest"
- **Dependency Types**: Handle dependencies, devDependencies, and peerDependencies
- **Conflict Resolution**: Tools to sync versions across workspaces

### Safety Features

- **Dry Run Mode**: Preview all changes before applying
- **Backup Awareness**: Always preview changes in dry run first
- **Validation**: Input validation and error checking
- **Cancellation**: Ability to cancel operations at any time

## 🔧 Advanced Usage

### Custom Version Patterns

The tool supports various version patterns:

- `latest` - Latest available version
- `^5.6.0` - Compatible version (recommended)
- `~5.6.0` - Patch-level changes
- `5.6.0` - Exact version
- `>=5.6.0 <6.0.0` - Range specification

### Batch Operations

For scripted usage, you can create your own scripts that call the package updater:

```typescript
// custom-update.ts
import { PackageUpdater } from './scripts/update-packages';

const updater = new PackageUpdater();
// Custom automation logic here
```

### Integration with CI/CD

The package updater can be integrated into your CI/CD pipeline:

```yaml
# .github/workflows/sync-deps.yml
name: Sync Dependencies
on:
  schedule:
    - cron: '0 0 * * 1' # Weekly on Monday

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: oven-sh/setup-bun@v1
      - run: bun install
      - run: bun run align-versions
        # Add automation logic for non-interactive usage
```

## 🐛 Troubleshooting

### Common Issues

1. **"Command not found"**

   - Ensure bun is installed: `curl -fsSL https://bun.sh/install | bash`
   - Or use npm/yarn alternatives

2. **"jq not found" (Shell version)**

   - Install jq: `sudo apt install jq` (Ubuntu) or `brew install jq` (macOS)

3. **Permission denied**

   - Make script executable: `chmod +x scripts/update-packages.sh`

4. **Package.json not found**
   - Ensure you're running from the repository root
   - Check that workspaces have valid package.json files

### Debug Mode

For TypeScript version, you can add debug logging by modifying the script:

```typescript
// Add this to enable verbose logging
const DEBUG = process.env.DEBUG === 'true';
```

Run with debug mode:

```bash
DEBUG=true bun run align-versions
```

## 🤝 Contributing

Feel free to enhance the package updater:

1. **Add Features**: New functionality like dependency analysis, security updates
2. **Improve UI**: Better visual design or additional interactive elements
3. **Performance**: Optimization for large monorepos
4. **Platform Support**: Windows batch script version


**Happy Package Managing! 📦✨**

### Version Conflict Resolution Strategies

The tool provides multiple strategies for resolving version conflicts:

#### 1. **Interactive Resolution** 🔄

- Go through each conflicted package individually
- Choose from existing versions or enter a custom version
- Full control over each resolution decision
- Perfect for careful, selective updates

#### 2. **Selective Resolution** 🎯

- Choose specific packages to resolve from the conflict list
- Skip packages you don't want to change
- Ideal when you only want to fix certain conflicts

#### 3. **Auto-resolve to Most Common** ⚡

- Automatically picks the version used by the most workspaces
- Minimizes the number of changes needed
- Good for quick standardization with minimal impact

#### 4. **Auto-resolve to Latest** 🚀

- Updates all conflicted packages to "latest" version
- Ensures you're using the newest available versions
- Use with caution as it may introduce breaking changes

#### Example Conflict Scenarios:

**TypeScript versions across workspaces:**

- Root: `5.8.3`
- Apps: `^5.3.3`, `^5.5.3`
- Packages: `5.8.2`, `^5.8.2`

**Resolution options:**

- Pick `5.8.3` (most recent)
- Pick `^5.3.3` (most compatible)
- Enter custom like `^5.8.0` (your preference)
- Choose "latest" (future-proof)

## Build and Publish

1. Install dependencies:
   ```sh
   npm install
   ```
2. Build the project:
   ```sh
   npm run build
   ```
3. Test the CLI locally:
   ```sh
   npm link
   align-versions --help
   ```
4. Publish to npm:
   ```sh
   npm publish
   ```
