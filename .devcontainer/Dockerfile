FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    stow \
    fzf \
    ripgrep \
    fd-find \
    bat \
    eza \
    tmux \
    tree \
    jq \
    httm \
    zoxide \
    age \
    git-crypt \
    && rm -rf /var/lib/apt/lists/*

# Install starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# Install atuin
RUN curl -sS https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh | bash
