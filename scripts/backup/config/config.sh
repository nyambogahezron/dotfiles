#!/bin/bash
# Backup Configuration File

# Backup settings
BACKUP_NAME="home_backup"
SOURCE_DIRECTORIES=("/home")
DESTINATION_DIRECTORY="/mnt/harddrive/backups"
MAX_BACKUPS=5
COMPRESSION="tar.gz"  # Options: tar.gz, tar.bz2, tar.xz, or rsync
ENABLE_ENCRYPTION=false
ENCRYPTION_PASSWORD=""  # Only used if ENABLE_ENCRYPTION=true

# Exclusion settings
EXCLUDE_PATTERNS=(
    "**/snap/**"
    "**/node_modules/**"
    "**/vendor/**"
    "**/.cache/**"
    "**/.npm/**"
    "**/.local/share/Trash/**"
    "**/.git/**"
    "**/lost+found/**"
    "**/*.tmp"
    "**/*.log"
    "**/*.swp"
    "**/*.swp"
    "**/tmp/**"
    "**/*~"
)

EXCLUDE_SPECIFIC_PATHS=(
    "/home/*/.cache"
    "/home/*/.npm"
    "/home/*/.local/share/Trash"
    "/home/*/.mozilla/firefox/*/Cache"
    "/home/*/.cache/chromium"
    "/home/*/.thumbnails"
)

# Notification settings
ENABLE_EMAIL_NOTIFICATIONS=false
EMAIL_ADDRESS=""
EMAIL_SUBJECT="Backup Status Report"

# Logging settings
LOG_DIRECTORY="/var/log/backup_tool"
LOG_FILE="${LOG_DIRECTORY}/backup.log"
MAX_LOG_FILES=10

# Schedule settings (for cron/systemd)
ENABLE_AUTO_BACKUP=false
BACKUP_TIME="02:00"  # 24-hour format
BACKUP_FREQUENCY="daily"  # daily, weekly, monthly

# Advanced settings
PRESERVE_PERMISSIONS=true
FOLLOW_SYMLINKS=false
CHECK_DISK_SPACE=true
MIN_DISK_SPACE_GB=10  # Minimum GB required on destination
VERIFY_BACKUP=true
SEND_SUMMARY=true

# Rsync specific settings (if COMPRESSION="rsync")
RSYNC_OPTIONS="-av --delete"
RSYNC_INCREMENTAL=true
RSYNC_HARD_LINKS=false

# Post-backup commands (optional)
POST_BACKUP_COMMANDS=(
    # Example: "echo 'Backup completed' | mail -s 'Backup Done' admin@example.com"
    # Example: "/path/to/another/script.sh"
)

# Pre-backup commands (optional)
PRE_BACKUP_COMMANDS=(
    # Example: "echo 'Starting backup at $(date)'"
    # Example: "/path/to/pre_backup.sh"
)

# Custom backup paths (add additional paths here)
CUSTOM_BACKUP_PATHS=(
    # Example: "/etc"
    # Example: "/var/www"
    # Example: "/opt"
)

# MySQL/MariaDB backup (optional)
BACKUP_MYSQL=false
MYSQL_USER=""
MYSQL_PASSWORD=""
MYSQL_DATABASES=()  # Empty array means all databases
MYSQL_BACKUP_DIR="${DESTINATION_DIRECTORY}/mysql"

# PostgreSQL backup (optional)
BACKUP_POSTGRESQL=false
POSTGRESQL_USER="postgres"
POSTGRESQL_DATABASES=()  # Empty array means all databases
POSTGRESQL_BACKUP_DIR="${DESTINATION_DIRECTORY}/postgresql"