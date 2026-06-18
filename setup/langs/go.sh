#!/bin/bash


# Go Installation


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

install_go() {
    print_header "INSTALLING GO"

    if command_exists go; then
        print_success "Go already installed ($(go version))"
    else
        print_step "Installing Go..."

        # Try package manager first
        if install_package "golang"; then
            print_success "Go installed via package manager"
        else
            # Fallback: Install latest Go manually
            GO_VERSION="1.21.5"
            print_step "Installing Go ${GO_VERSION} manually..."
            wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
            rm "go${GO_VERSION}.linux-amd64.tar.gz"

            # Add to PATH
            if ! grep -q "/usr/local/go/bin" "$HOME/.bashrc"; then
                echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.bashrc"
            fi
            if [ -f "$HOME/.zshrc" ] && ! grep -q "/usr/local/go/bin" "$HOME/.zshrc"; then
                echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.zshrc"
            fi
        fi
    fi

    # Set GOPATH
    if ! grep -q "GOPATH" "$HOME/.bashrc"; then
        echo 'export GOPATH=$HOME/go' >> "$HOME/.bashrc"
        echo 'export PATH=$PATH:$GOPATH/bin' >> "$HOME/.bashrc"
    fi
    if [ -f "$HOME/.zshrc" ] && ! grep -q "GOPATH" "$HOME/.zshrc"; then
        echo 'export GOPATH=$HOME/go' >> "$HOME/.zshrc"
        echo 'export PATH=$PATH:$GOPATH/bin' >> "$HOME/.zshrc"
    fi

    print_success "Go setup complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_go
fi
