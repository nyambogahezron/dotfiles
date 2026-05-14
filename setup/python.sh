#!/bin/bash

# Python Installation & Dev Tooling

source "$(dirname "$0")/utils.sh"

install_python() {
    print_header "INSTALLING PYTHON"

    if command_exists python3; then
        print_warning "Python already installed ($(python3 --version))"
        if ! confirm "Reinstall / upgrade Python packages?"; then
            _install_python_tools
            return
        fi
    else
        print_step "Installing Python..."
        case $OS in
            ubuntu|debian|linuxmint|pop)
                install_package "python3"
                install_package "python3-pip"
                install_package "python3-venv"
                install_package "python3-dev"
                install_package "python3-setuptools"
                install_package "python3-wheel"
                ;;
            fedora)
                sudo dnf install -y python3 python3-pip python3-devel
                ;;
            arch|manjaro)
                sudo pacman -S --noconfirm python python-pip
                ;;
            macos)
                brew install python
                ;;
        esac
    fi

    # Upgrade pip
    print_step "Upgrading pip..."
    python3 -m pip install --user --upgrade pip setuptools wheel

    # Install tools
    _install_python_tools

    print_success "Python setup complete: $(python3 --version)"
}

_install_python_tools() {
    print_header "INSTALLING PYTHON DEV TOOLS"

    # ── uv — ultra-fast Python package manager (replaces pip/pipenv/poetry for most use)
    if ! command_exists uv; then
        print_step "Installing uv (fast Python package manager)..."
        curl -LsSf https://astral.sh/uv/install.sh | sh

        _add_to_shell "$HOME/.bashrc" 'export PATH="$HOME/.cargo/bin:$PATH"'
        _add_to_shell "$HOME/.zshrc"  'export PATH="$HOME/.cargo/bin:$PATH"'
    else
        print_warning "uv already installed ($(uv --version))"
    fi

    # ── pipx — install Python CLI tools in isolated environments
    if ! command_exists pipx; then
        print_step "Installing pipx..."
        python3 -m pip install --user pipx
        python3 -m pipx ensurepath
    fi

    # ── Poetry — dependency management & packaging
    if ! command_exists poetry && confirm "Install Poetry (dependency management)?"; then
        print_step "Installing Poetry..."
        curl -sSL https://install.python-poetry.org | python3 -

        _add_to_shell "$HOME/.bashrc" 'export PATH="$HOME/.local/bin:$PATH"'
        _add_to_shell "$HOME/.zshrc"  'export PATH="$HOME/.local/bin:$PATH"'
    fi

    # ── Global dev packages via pip
    print_step "Installing Python development packages..."
    python3 -m pip install --user \
        virtualenv \
        ruff \
        black \
        isort \
        mypy \
        pylint \
        flake8 \
        autopep8 \
        pytest \
        pytest-cov \
        ipython \
        httpie \
        rich \
        typer \
        pydantic \
        python-dotenv \
        requests \
        fastapi \
        uvicorn

    print_success "Python tools installed"
}

_add_to_shell() {
    local rc_file="$1"
    local line="$2"
    [ ! -f "$rc_file" ] && return
    grep -qF "$line" "$rc_file" || echo "$line" >> "$rc_file"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_python
fi
