#!/bin/bash
# Backup Tool Installer for Ubuntu

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Backup Tool Installation ===${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root${NC}"
    exit 1
fi

# Check for required commands
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${YELLOW}Warning: $1 not found. Installing...${NC}"
        apt-get update
        apt-get install -y "$1"
    fi
}

echo "Checking dependencies..."
check_command tar
check_command rsync
check_command gzip
check_command bzip2
check_command xz-utils

# Optional dependencies
if ! command -v gpg &> /dev/null; then
    echo -e "${YELLOW}GPG not found. Install for encryption support? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        apt-get install -y gnupg
    fi
fi

# Create directories
echo "Creating directories..."
mkdir -p /etc/backup_tool
mkdir -p /var/log/backup_tool
mkdir -p /usr/local/bin
mkdir -p /opt/backup_tool
mkdir -p /opt/backup_tool/modules
mkdir -p /opt/backup_tool/config

# Copy files
echo "Installing files..."

# Main script
cp main.sh /opt/backup_tool/
chmod 755 /opt/backup_tool/main.sh

# Copy all module files
echo "Installing modules..."
cp modules/*.sh /opt/backup_tool/modules/
chmod 755 /opt/backup_tool/modules/*.sh

# Configuration file
if [ ! -f /etc/backup_tool/backup_config.sh ]; then
    cp config/config.sh /etc/backup_tool/backup_config.sh
    chmod 644 /etc/backup_tool/backup_config.sh
else
    echo -e "${YELLOW}Configuration file already exists. Keeping existing config.${NC}"
    echo -e "${YELLOW}New config saved as /etc/backup_tool/backup_config.sh.new${NC}"
    cp config/config.sh /etc/backup_tool/backup_config.sh.new
fi

# Create symlink for easy access
ln -sf /opt/backup_tool/main.sh /usr/local/bin/backit

# Create example backup destination
echo "Setting up backup destination..."
mkdir -p /mnt/harddrive/backups
chmod 755 /mnt/harddrive/backups

# Create log rotation
echo "Setting up log rotation..."
cat > /etc/logrotate.d/backit << 'EOF'
/var/log/backup_tool/*.log {
    weekly
    missingok
    rotate 4
    compress
    delaycompress
    notifempty
    create 640 root adm
}
EOF

# Create systemd service (optional)
echo "Creating systemd service..."
cat > /etc/systemd/system/backit.service << 'EOF'
[Unit]
Description=Backup Tool Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backit
User=root
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/backit.timer << 'EOF'
[Unit]
Description=Run backup tool daily
Requires=backit.service

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Set permissions
echo "Setting permissions..."
chown -R root:root /etc/backup_tool
chown -R root:root /opt/backup_tool
chmod -R 755 /opt/backup_tool

# Create uninstall script
cat > /opt/backup_tool/uninstall.sh << 'EOF'
#!/bin/bash
# Backup Tool Uninstaller

set -e

echo "=== Backup Tool Uninstallation ==="

# Remove symlink
rm -f /usr/local/bin/backit

# Remove systemd files
rm -f /etc/systemd/system/backit.service
rm -f /etc/systemd/system/backit.timer

# Remove cron job
rm -f /etc/cron.d/backit

# Remove log rotation
rm -f /etc/logrotate.d/backit

# Ask about removing config and logs
read -p "Remove configuration files? (y/n): " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf /etc/backup_tool
fi

read -p "Remove log files? (y/n): " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf /var/log/backup_tool
fi

# Remove main script
rm -rf /opt/backup_tool

echo "Backup tool uninstalled successfully!"
EOF

chmod +x /opt/backup_tool/uninstall.sh

echo ""
echo -e "${GREEN}=== Installation Complete ===${NC}"
echo ""
echo "Backup Tool has been installed successfully!"
echo ""
echo "Configuration: /etc/backup_tool/backup_config.sh"
echo "Main Script:   /opt/backup_tool/backup_tool.sh"
echo "Log Directory: /var/log/backup_tool/"
echo "Backup Dest:   /mnt/harddrive/backups/"
echo ""
echo -e "${YELLOW}IMPORTANT: Edit /etc/backup_tool/backup_config.sh to customize:${NC}"
echo "  - Set correct backup destination"
echo "  - Adjust exclude patterns"
echo "  - Configure backup settings"
echo ""
echo "Usage:"
echo "  backit                    # Run backup"
echo "  backit --list             # List available backups"
echo "  backit --restore file.tar.gz --to /path"
echo "  backit --verify file.tar.gz"
echo "  backit --dry-run          # Show what would be backed up"
echo "  backit --setup-cron       # Setup automatic backups"
echo ""
echo "To enable automatic daily backups:"
echo "  backit --setup-cron"
echo ""
echo "Uninstall: /opt/backup_tool/uninstall.sh"
echo ""