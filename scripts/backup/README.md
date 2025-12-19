# BackIt - Linux Backup Tool

![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue.svg)


A comprehensive, modular shell-based backup solution for Linux systems. This tool provides flexible file backup capabilities with configurable exclusion patterns, multiple compression formats, and automated scheduling.

## ✨ Features

- **🔄 Pure Shell Script** - No external dependencies required
- **📦 Modular Architecture** - Well-organized codebase with separate modules
- **🚫 Configurable Exclusions** - Exclude patterns like `snap`, `node_modules`, `vendor` and more
- **📦 Multiple Backup Methods** - Support for tar.gz, tar.bz2, tar.xz, and rsync
- **🗄️ Database Backup** - Optional MySQL and PostgreSQL backup support
- **🔐 Encryption** - GPG encryption for sensitive backups
- **🧹 Backup Rotation** - Automatic cleanup of old backups
- **📧 Email Notifications** - Optional email status reports
- **↩️ Easy Restoration** - Simple restore functionality
- **📝 Logging** - Comprehensive logging with rotation
- **⏰ Scheduling** - Automatic backups via cron or systemd

## 📁 Project Structure

```
backit/
├── README.md
├── install.sh
├── main.sh              # Main entry point
├── config/
│   └── config.sh       # Configuration
└── modules/
    ├── utils.sh               # Utility functions
    ├── backup.sh              # Core backup logic
    ├── restore.sh             # Restore functionality
    ├── verify.sh              # Verification functions
    ├── db.sh                  # Database backup
    ├── encrypt.sh             # Encryption functions
    ├── scheduler.sh           # Cron/scheduling
    ├── notification.sh        # Email/notifications
    └── cleanup.sh             # Cleanup functions
```

## 🚀 Quick Start

### Prerequisites
- Linux Linux
- Root/sudo access
- Mounted backup destination (e.g., `/mnt/harddrive`)

### Installation

```bash
# 1. Download or clone the backit directory

# 2. Make scripts executable
chmod +x main.sh install.sh
chmod +x modules/*.sh

# 3. Run the installer
sudo ./install.sh
```

## First-Time Configuration
Edit the configuration file after installation:

```bash
sudo nano /etc/backit/config.sh
```

Key settings to configure:

- **DESTINATION_DIRECTORY**: Set to your mounted harddrive
- **SOURCE_DIRECTORIES**: Add or remove directories to backup
- **EXCLUDE_PATTERNS**: Add custom exclude patterns
- **MAX_BACKUPS**: Set how many backups to keep

## Run Your First Backup
```bash
sudo backit
```
The backup will be created at `/mnt/harddrive/backups/home_backup_TIMESTAMP.tar.gz`

## 📁 File Structure

### Installed Structure
```text
/etc/backit/
├── config.sh          # Configuration file
└── config.sh.new      # New config template (if exists)

/opt/backit/
├── main.sh                   # Main backup script
├── modules/                  # Module directory
│   ├── utils.sh             # Utility functions
│   ├── backup.sh            # Core backup logic
│   ├── restore.sh           # Restore functionality
│   ├── verify.sh            # Verification functions
│   ├── db.sh                # Database backup
│   ├── encrypt.sh           # Encryption functions
│   ├── scheduler.sh         # Cron/scheduling
│   ├── notification.sh      # Email/notifications
│   └── cleanup.sh           # Cleanup functions
└── uninstall.sh             # Uninstaller

/var/log/backit/
├── backup.log               # Main log file
└── cron.log                # Cron job logs (if enabled)

/usr/local/bin/
└── backit             # Symlink to main script
```

## ⚙️ Configuration Guide

### Backup Settings
```bash
# Basic settings
BACKUP_NAME="home_backup"
SOURCE_DIRECTORIES=("/home")
DESTINATION_DIRECTORY="/mnt/harddrive/backups"

# Retention and compression
MAX_BACKUPS=5
COMPRESSION="tar.gz"  # Options: tar.gz, tar.bz2, tar.xz, rsync

# Optional encryption
ENABLE_ENCRYPTION=false
ENCRYPTION_PASSWORD=""
```

### Default Exclusions
The tool automatically excludes common unnecessary directories:

```bash
EXCLUDE_PATTERNS=(
    "**/snap/**"              # Snap packages
    "**/node_modules/**"      # Node.js modules  
    "**/vendor/**"            # PHP vendor directories
    "**/.cache/**"            # Cache directories
    "**/.npm/**"              # npm cache
    "**/.local/share/Trash/**" # Trash folders
    "**/.git/**"              # Git repositories
    "**/lost+found/**"        # Filesystem directories
    "**/*.tmp"                # Temporary files
    "**/*.log"                # Log files
    "**/*.swp"                # Vim swap files
    "**/*~"                   # Backup files
)
```

### Add Custom Exclusions
```bash
# Add to EXCLUDE_PATTERNS array
EXCLUDE_PATTERNS+=(
    "**/docker/volumes/**"
    "**/virtual_machines/**"
    "**/downloads/**"
)

# Add specific paths
EXCLUDE_SPECIFIC_PATHS+=(
    "/home/user/large_media_folder"
    "/home/*/VirtualBox VMs"
    "/home/*/.local/share/Steam"
)
```

### Database Backup (Optional)
```bash
# MySQL Backup
BACKUP_MYSQL=false
MYSQL_USER="root"
MYSQL_PASSWORD="your_password"
MYSQL_DATABASES=()  # Empty array = all databases

# PostgreSQL Backup  
BACKUP_POSTGRESQL=false
POSTGRESQL_USER="postgres"
POSTGRESQL_DATABASES=()  # Empty array = all databases
```

### Notification Settings
```bash
# Email notifications
ENABLE_EMAIL_NOTIFICATIONS=false
EMAIL_ADDRESS="admin@example.com"
EMAIL_SUBJECT="Backup Status Report"

# Log settings
LOG_DIRECTORY="/var/log/backit"
MAX_LOG_FILES=10
```

## 🛠️ Usage

### Basic Commands

| Command | Description |
|---------|-------------|
| `sudo backit` | Run backup with default config |
| `sudo backit --list` | List available backups |
| `sudo backit --dry-run` | Show what would be backed up |
| `sudo backit --verify file.tar.gz` | Verify backup integrity |
| `sudo backit --summary` | Show last backup summary |
| `sudo backit --help` | Show help message |

### Restore from Backup
```bash
# Restore to specific directory
sudo backit --restore /mnt/harddrive/backups/backup.tar.gz --to /path/to/restore

# Restore to auto-generated directory  
sudo backit --restore /mnt/harddrive/backups/backup.tar.gz
# Creates: ./restored_YYYYMMDD_HHMMSS/
```

### Using Custom Configuration
```bash
# Use alternate config file
sudo backit --config /path/to/custom_config.sh
```

## 🔄 Automated Backups

### Option 1: Cron (Recommended)
```bash
# Setup automatic backups via cron
sudo backit --setup-cron
```

This creates a cron job based on your config's `BACKUP_TIME` and `BACKUP_FREQUENCY`.

View the cron schedule:
```bash
sudo cat /etc/cron.d/backit
```

Remove cron job:
```bash
sudo backit --remove-cron
```

### Option 2: Systemd Timer
```bash
# Enable systemd timer
sudo systemctl enable backit.timer
sudo systemctl start backit.timer

# Check status
sudo systemctl status backit.timer

# View next run time
sudo systemctl list-timers backit.timer
```

### Manual Cron Setup
```bash
# Add to crontab for daily backup at 2 AM
sudo crontab -e

# Add this line:
0 2 * * * /usr/local/bin/backit >> /var/log/backit/cron.log 2>&1
```

## 📊 Backup Management

### View Available Backups
```bash
sudo backit --list
```

Example output:
```text
Available Backups in: /mnt/harddrive/backups
==========================================
home_backup_20231215_143000.tar.gz     1.2GB   2023-12-15 14:30:00
home_backup_20231214_143000.tar.gz     1.1GB   2023-12-14 14:30:00
home_backup_20231213_143000.tar.gz     1.2GB   2023-12-13 14:30:00
```

### Check Backup Contents
```bash
# For tar.gz backups
tar -tzf /mnt/harddrive/backups/backup.tar.gz | head -20

# For encrypted backups
echo "password" | gpg --decrypt backup.tar.gz.gpg | tar -tz | head -20
```

### Monitor Logs
```bash
# View recent logs
sudo tail -f /var/log/backit/backup.log

# Search for errors
sudo grep -i error /var/log/backit/backup.log

# View cron logs
sudo tail -f /var/log/backit/cron.log
```

## 🗑️ Uninstallation
```bash
sudo /opt/backit/uninstall.sh
```

The uninstaller will prompt you about removing:
- Configuration files
- Log files
- Backup data (only configuration, not actual backups)

## 🔧 Troubleshooting

### Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Permission Denied | `sudo chmod 755 /opt/backit/main.sh` |
| Destination Not Mounted | Check `mount \| grep /mnt/harddrive` |
| Insufficient Disk Space | Reduce MAX_BACKUPS or increase destination storage |
| Backup Too Slow | Change COMPRESSION to "tar" or use rsync mode |
| MySQL Backup Fails | Verify database credentials and permissions |

### Debug Mode
```bash
# Run with detailed output
sudo bash -x /opt/backit/backit.sh

# Run with trace and dry run
sudo bash -vx /opt/backit/main.sh --dry-run
```

### Check Service Status
```bash
# Cron service status
sudo systemctl status cron

# Check active cron jobs
sudo crontab -l | grep backit || echo "No cron job found"

# Check script executable
ls -la /usr/local/bin/backit
```

## 📝 Examples

### Example 1: Home Directory Backup
```bash
# /etc/backit/config.sh
SOURCE_DIRECTORIES=("/home")
EXCLUDE_PATTERNS+=(
    "**/Downloads/**"
    "**/Videos/**"
    "**/.local/share/Trash/**"
)
COMPRESSION="tar.gz"
MAX_BACKUPS=7  # Keep a week of daily backups
```

### Example 2: Web Server Backup
```bash
# Backup web server and databases
SOURCE_DIRECTORIES=("/var/www" "/etc" "/home")
BACKUP_MYSQL=true
MYSQL_USER="backup_user"
MYSQL_PASSWORD="secure_password"
MYSQL_DATABASES=("website_db" "app_db")
COMPRESSION="tar.xz"  # Better compression for text
MAX_BACKUPS=30  # Keep a month of backups
ENABLE_EMAIL_NOTIFICATIONS=true
EMAIL_ADDRESS="admin@example.com"
```

### Example 3: Development Environment
```bash
# Exclude development artifacts
EXCLUDE_PATTERNS+=(
    "**/node_modules/**"
    "**/vendor/**"
    "**/.env"
    "**/dist/**"
    "**/build/**"
    "**/__pycache__/**"
    "**/*.pyc"
    "**/.venv/**"
    "**/target/**"      # Rust
    "**/.gradle/**"     # Gradle
    "**/.idea/**"       # IDE
    "**/.vscode/**"     # VS Code
)
COMPRESSION="rsync"  # Fast incremental backups
RSYNC_INCREMENTAL=true
```

## 🔒 Security Considerations

**Enable Encryption** for sensitive data:
```bash
ENABLE_ENCRYPTION=true
ENCRYPTION_PASSWORD="$(cat /etc/backit/.backup_password)"
```

**Secure Password Storage:**
```bash
sudo echo "your_password" > /etc/backit/.backup_password
sudo chmod 600 /etc/backit/.backup_password
```

**Proper Permissions:**
```bash
sudo chmod 700 /mnt/harddrive/backups
sudo chown root:root /etc/backit/config.sh
```

**Regular Testing** - Always verify backups work:
```bash
# Quarterly backup fire drill
sudo backit --restore latest_backup.tar.gz --to /tmp/test_restore
```

## 📈 Monitoring

### Create Health Check Script
```bash
#!/bin/bash
# Save as /usr/local/bin/check-backup-health
LOG="/var/log/backit/backup.log"

if [ ! -f "$LOG" ]; then
    echo "ERROR: No backup logs found"
    exit 1
fi

LAST_BACKUP=$(grep "Backup completed" "$LOG" | tail -1)
if [ -z "$LAST_BACKUP" ]; then
    echo "WARNING: No successful backups found"
    exit 1
fi

# Check if backup was within last 24 hours
BACKUP_TIME=$(echo "$LAST_BACKUP" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
if [ "$(date -d "$BACKUP_TIME" +%s)" -lt "$(date -d '24 hours ago' +%s)" ]; then
    echo "WARNING: Last backup was more than 24 hours ago"
    exit 1
fi

echo "OK: Last backup $LAST_BACKUP"
exit 0
```

### Integration with Monitoring Tools

For Nagios/Icinga/Zabbix:
```bash
# Simple check script
if sudo backit --summary | grep -q "Backup created"; then
    echo "OK: Backup system functional"
    exit 0
else
    echo "CRITICAL: Backup system issues"
    exit 2
fi
```

## 🎯 Best Practices

### 3-2-1 Backup Rule
- **3** copies of your data
- **2** different storage types (local HDD + external)
- **1** copy offsite (cloud or remote location)

### Regular Maintenance Schedule

| Frequency | Task |
|-----------|------|
| Daily | Check backup logs |
| Weekly | Verify backup integrity |
| Monthly | Test restore procedure |
| Quarterly | Review and update exclusions |
| Annually | Full disaster recovery test |

### Backup Testing Script
```bash
#!/bin/bash
# Save as /usr/local/bin/test-backup-restore.sh
BACKUP_DIR="/mnt/harddrive/backups"
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/home_backup_*.tar.gz 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "No backups found"
    exit 1
fi

TEST_DIR="/tmp/backup_test_$(date +%Y%m%d_%H%M%S)"
echo "Testing restore of: $LATEST_BACKUP"
echo "To directory: $TEST_DIR"

mkdir -p "$TEST_DIR"
if sudo backit --restore "$LATEST_BACKUP" --to "$TEST_DIR"; then
    echo "✅ Restore test successful"
    echo "Files restored: $(find "$TEST_DIR" -type f | wc -l)"
    rm -rf "$TEST_DIR"
else
    echo "❌ Restore test failed"
    exit 1
fi
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License
This tool is provided as-is for personal and commercial use. Always test backups before relying on them for critical data.

## ⚠️ Disclaimer

The authors are not responsible for data loss. Always:
- Test backup restoration regularly
- Maintain multiple backup copies
- Follow the 3-2-1 backup rule
- Monitor backup success

## 📦 Module Documentation

The backup tool is organized into specialized modules for better maintainability:

- **utils.sh** - Core utilities (logging, disk space checking, command execution)
- **backup.sh** - Main backup orchestration and tar/rsync backup creation
- **restore.sh** - Backup restoration and listing functionality
- **verify.sh** - Backup integrity verification
- **db.sh** - MySQL and PostgreSQL database backup support
- **encrypt.sh** - GPG encryption for sensitive data
- **scheduler.sh** - Cron job setup and management
- **notification.sh** - Email notifications and backup summaries
- **cleanup.sh** - Old backup and log file cleanup

Each module is independent and can be modified without affecting others.

## 🆘 Need Help?

- Check logs first: `/var/log/backit/backup.log`
- Dry run: `sudo backit --dry-run`
- Verify configuration: Check `/etc/backit/config.sh`
- Test manually: Run commands from the script step by step

## 📚 Additional Resources

- [Linux Backup Guide](https://help.linux.com/community/BackupYourSystem)
- [rsync Documentation](https://rsync.samba.org/documentation.html)
- [tar Manual](https://www.gnu.org/software/tar/manual/)
- [GPG Encryption Guide](https://gnupg.org/documentation/)

**Pro Tip:** Schedule a quarterly "backup fire drill" where you restore from backup to ensure everything works when you really need it!

---

⭐ If this tool helped you, consider giving it a star! ⭐