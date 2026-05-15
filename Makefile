.PHONY: help apply apply-config update install-tools diff doctor maintenance

help: ## Show this help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

apply: ## Apply all dotfiles and scripts via chezmoi
	chezmoi apply

apply-config: ## Apply ONLY configurations (skips app/tool installation scripts)
	chezmoi apply --exclude scripts

update: ## Pull the latest changes from git and apply them
	chezmoi update --apply

install-tools: ## Force re-run of all setup scripts (packages, tools, etc.)
	chezmoi state delete-bucket --bucket=scriptState
	chezmoi apply

diff: ## Show pending changes between the repository and your home directory
	chezmoi diff

doctor: ## Run the dotfiles health check
	~/.local/bin/dot-doctor

maintenance: ## Run automated system maintenance and cleanup
	~/.local/bin/dot-maintenance
