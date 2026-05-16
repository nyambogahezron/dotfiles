#!/bin/bash


# Python Installation


source "$(dirname "$0")/../utils.sh"

install_python() {
    print_header "INSTALLING PYTHON"
    
    if command_exists python3; then
        print_warning "Python already installed ($(python3 --version))"
        if ! confirm "Reinstall Python packages?"; then
            return
        fi
    else
        print_step "Installing Python..."
        install_package "python3"
        install_package "python3-pip"
        install_package "python3-venv"
    fi
    
    # Upgrade pip
    print_step "Upgrading pip..."
    python3 -m pip install --user --upgrade pip
    
    # Install useful Python packages
    print_step "Installing Python development packages..."
    python3 -m pip install --user \
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
