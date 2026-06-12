.PHONY: help apply delete restow adopt check update diff doctor maintenance

# Configuration
STOW_IGNORE = --ignore="install.sh|Makefile|README.md|LICENSE|AGENTS.md|Brewfile|docs|scripts|setup"
STOW_FLAGS = -v -d $(CURDIR) -t $(HOME)

help: ## Show this help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

apply: ## Apply dotfiles (create symlinks)
	stow $(STOW_FLAGS) $(STOW_IGNORE) .

delete: ## Remove dotfiles (delete symlinks)
	stow -D $(STOW_FLAGS) $(STOW_IGNORE) .

restow: ## Refresh dotfiles (re-link)
	stow -R $(STOW_FLAGS) $(STOW_IGNORE) .

adopt: ## Adopt existing local files into the repository
	stow --adopt $(STOW_FLAGS) $(STOW_IGNORE) .

force: ## Forcefully overwrite local files with repository versions
	@echo "Warning: This will overwrite local files with versions from the repository."
	stow --adopt $(STOW_FLAGS) $(STOW_IGNORE) .
	git checkout .

check: ## Dry-run: show what stow would do
	stow -n $(STOW_FLAGS) $(STOW_IGNORE) .

update: ## Pull latest changes and restow
	git pull
	$(MAKE) restow

diff: ## Show local changes in tracked files
	git diff

doctor: ## Run the dotfiles health check
	~/.local/bin/dot-doctor

maintenance: ## Run automated system maintenance and cleanup
	~/.local/bin/dot-maintenance
