#!/bin/bash


# Python Installation


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_python() {
    print_header "INSTALLING PYTHON"

    if command_exists python3; then
        print_success "Python already installed ($(python3 --version))"
    else
        print_step "Installing Python..."
        install_packages "python3" "python3-pip" "python3-venv"
    fi

    # Upgrade pip
    print_step "Upgrading pip..."
    python3 -m pip install --user --upgrade pip

    # Install useful Python packages
    install_python_user_packages \
        pipenv \
        virtualenv \
        black \
        flake8 \
        pylint \
        autopep8 \
        pytest \
        ipython \
        jupyter \
        numpy \
        pandas \
        requests

    print_success "Python setup complete: $(python3 --version)"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_python
fi
