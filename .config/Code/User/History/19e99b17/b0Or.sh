#!/bin/bash

# Script to fix EMFILE: too many open files error
# This script increases the file descriptor limits system-wide

echo "Fixing file descriptor limits for development..."

# Check current limits
echo "Current limits:"
echo "Soft limit: $(ulimit -Sn)"
echo "Hard limit: $(ulimit -Hn)"

# Create limits configuration
LIMITS_CONF="/etc/security/limits.conf"
USER=$(whoami)

echo "Adding configuration to $LIMITS_CONF..."
echo "This requires sudo privileges."

# Backup original file
sudo cp $LIMITS_CONF $LIMITS_CONF.backup

# Add limits for the current user
sudo tee -a $LIMITS_CONF > /dev/null <<EOF

# Increased file descriptor limits for development
$USER soft nofile 1048576
$USER hard nofile 1048576
EOF

echo "Configuration added. Please log out and log back in for changes to take effect."
echo "Alternatively, you can run: newgrp $USER"

# Also set system-wide limits
SYSTEMD_CONF="/etc/systemd/system.conf"
echo "Adding systemd configuration..."
sudo tee -a $SYSTEMD_CONF > /dev/null <<EOF

# Increased file descriptor limits
DefaultLimitNOFILE=1048576:1048576
EOF

echo "Systemd configuration added. Restart required for system-wide changes."
echo ""
echo "For immediate effect in current session, run:"
echo "ulimit -n 65536"
