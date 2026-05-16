.PHONY: help apply apply-config update install-tools diff doctor maintenance

help: ## Show this help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

STOW_IGNORE = --ignore="install.sh|Makefile|README.md|LICENSE|AGENTS.md|Brewfile|docs|scripts|setup|dotfiles-legacy|task.md|walkthrough.md|implementation_plan.md"

apply: ## Apply all dotfiles via stow
	stow -v -d $(PWD) -t $(HOME) $(STOW_IGNORE) .

apply-config: ## Apply dotfiles (alias for apply)
	$(MAKE) apply

update: ## Pull the latest changes from git and apply them
	git pull
	stow -v -R -d $(PWD) -t $(HOME) $(STOW_IGNORE) .

install-tools: ## Installation logic should be handled by install.sh or package manager
	@echo "Please use install.sh to install tools."

diff: ## Show pending changes (not directly supported by stow, using git diff)
	git diff

doctor: ## Run the dotfiles health check
	~/.local/bin/dot-doctor

maintenance: ## Run automated system maintenance and cleanup
	~/.local/bin/dot-maintenance
