#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"

readonly VPN_CONFIG_DIR="/etc/openfortivpn"
readonly VPN_CONFIG_FILE="${VPN_CONFIG_DIR}/config"
readonly SYSTEMD_UNIT_FILE="/etc/systemd/system/openfortivpn.service"
readonly VPN_DEFAULT_PORT="443"
readonly VPN_TRUSTED_CERT="482700c33868b48eebf23bfb23b2e7dea601632d2fdf20e585f8a235f43fc98e"

_require_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This operation requires root privileges."
        print_warning "Re-run with: sudo bash $0 $*"
        exit 1
    fi
}

_resolve_credentials() {
    local arg_host="${1:-}"
    local arg_user="${2:-}"
    local arg_pass="${3:-}"

    VPN_HOST="${arg_host:-${VPN_HOST:-}}"
    VPN_USER="${arg_user:-${VPN_USER:-}}"
    VPN_PASS="${arg_pass:-${VPN_PASS:-}}"
    VPN_PORT="${VPN_PORT:-${VPN_DEFAULT_PORT}}"

    if [[ -z "$VPN_HOST" ]]; then
        read -rp "  VPN host (e.g. vpn.example.com): " VPN_HOST
    fi
    if [[ -z "$VPN_USER" ]]; then
        read -rp "  VPN username: " VPN_USER
    fi
    if [[ -z "$VPN_PASS" ]]; then
        read -rsp "  VPN password: " VPN_PASS
        echo
    fi

    if [[ -z "$VPN_HOST" || -z "$VPN_USER" || -z "$VPN_PASS" ]]; then
        print_error "VPN_HOST, VPN_USER, and VPN_PASS are all required."
        exit 1
    fi
}

_install_openfortivpn() {
    if command_exists openfortivpn; then
        print_success "openfortivpn already installed ($(openfortivpn --version 2>&1 | head -1))"
        return 0
    fi

    print_step "Installing openfortivpn via apt..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq openfortivpn
    print_success "openfortivpn installed"
}

_create_config_dir() {
    if [[ -d "$VPN_CONFIG_DIR" ]]; then
        print_success "Config directory ${VPN_CONFIG_DIR} already exists"
    else
        print_step "Creating ${VPN_CONFIG_DIR}..."
        sudo mkdir -p "$VPN_CONFIG_DIR"
        print_success "Config directory created"
    fi
}

_write_config() {
    print_step "Writing VPN configuration to ${VPN_CONFIG_FILE}..."

    sudo tee "$VPN_CONFIG_FILE" > /dev/null <<EOF
host = ${VPN_HOST}
port = ${VPN_PORT}
username = ${VPN_USER}
password = ${VPN_PASS}
trusted-cert = ${VPN_TRUSTED_CERT}
EOF

    print_success "Configuration file written"
}

_secure_config() {
    print_step "Restricting permissions on ${VPN_CONFIG_FILE} (chmod 600)..."
    sudo chmod 600 "$VPN_CONFIG_FILE"
    print_success "Permissions secured (root read-only)"
}

_write_systemd_unit() {
    local dotfiles_dir
    dotfiles_dir="$(cd "$SCRIPT_DIR/../.." && pwd)"
    local source_unit="${dotfiles_dir}/etc/systemd/system/openfortivpn.service"

    if [[ ! -f "$source_unit" ]]; then
        print_error "Unit file not found in dotfiles repo: ${source_unit}"
        exit 1
    fi

    print_step "Symlinking systemd unit ${source_unit} → ${SYSTEMD_UNIT_FILE}..."
    sudo mkdir -p "$(dirname "$SYSTEMD_UNIT_FILE")"
    sudo ln -sf "$source_unit" "$SYSTEMD_UNIT_FILE"
    print_success "Systemd unit symlinked"
}

_enable_service() {
    print_step "Reloading systemd daemon..."
    sudo systemctl daemon-reload

    print_step "Enabling openfortivpn service (persist across reboots)..."
    sudo systemctl enable openfortivpn

    print_step "Starting openfortivpn service..."
    sudo systemctl start openfortivpn

    sleep 2

    if sudo systemctl is-active --quiet openfortivpn; then
        print_success "openfortivpn service is active and running"
    else
        print_warning "Service started but may still be connecting. Check logs with:"
        echo "    sudo journalctl -u openfortivpn -f"
    fi
}

setup_fortivpn() {
    local arg_host="${1:-}"
    local arg_user="${2:-}"
    local arg_pass="${3:-}"

    print_header "OPENFORTIVPN SERVICE SETUP"

    _require_root "$@"
    _resolve_credentials "$arg_host" "$arg_user" "$arg_pass"

    echo ""
    print_info "  Host     : ${VPN_HOST}:${VPN_PORT}"
    print_info "  Username : ${VPN_USER}"
    print_info "  Cert     : ${VPN_TRUSTED_CERT}"
    echo ""

    _install_openfortivpn
    _create_config_dir
    _write_config
    _secure_config
    _write_systemd_unit
    _enable_service

    print_header "FORTIVPN SETUP COMPLETE"
    print_success "VPN tunnel is running silently via the ppp0 interface."
    echo ""
    echo "  Useful commands:"
    echo "    sudo systemctl status  openfortivpn   # Check service status"
    echo "    sudo systemctl stop    openfortivpn   # Stop the tunnel"
    echo "    sudo systemctl restart openfortivpn   # Restart the tunnel"
    echo "    sudo journalctl -u openfortivpn -f    # Follow live logs"
    echo ""
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_fortivpn "$@"
fi
