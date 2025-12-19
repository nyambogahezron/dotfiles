#!/bin/bash
# Complete Backup Tool for Ubuntu - Shell Script Version
# Version: 2.0 - Modular Edition

set -euo pipefail
IFS=$'\n\t'

# Determine script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default configuration path
CONFIG_FILE="/etc/backup_tool/backup_config.sh"

# Load configuration
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found at $CONFIG_FILE"
    echo "Please create a configuration file first."
    exit 1
fi

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Global variables
SCRIPT_NAME=$(basename "$0")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
START_TIME=$(date +%s)
BACKUP_FILENAME="${BACKUP_NAME}_${TIMESTAMP}.${COMPRESSION}"
EXCLUDE_FILE="/tmp/backup_exclude_${TIMESTAMP}.txt"
BACKUP_STATUS="failed"
EMAIL_BODY=""

# Source all modules
source "${SCRIPT_DIR}/modules/utils.sh"
source "${SCRIPT_DIR}/modules/backup.sh"
source "${SCRIPT_DIR}/modules/restore.sh"
source "${SCRIPT_DIR}/modules/verify.sh"
source "${SCRIPT_DIR}/modules/db.sh"
source "${SCRIPT_DIR}/modules/encrypt.sh"
source "${SCRIPT_DIR}/modules/scheduler.sh"
source "${SCRIPT_DIR}/modules/notification.sh"
source "${SCRIPT_DIR}/modules/cleanup.sh"

# Main execution
main() {
    # Parse command line arguments
    local action="backup"
    local config_file="$CONFIG_FILE"
    local restore_file=""
    local restore_to=""
    local verify_file=""
    local dry_run=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -c|--config)
                config_file="$2"
                shift 2
                ;;
            -l|--list)
                action="list"
                shift
                ;;
            -r|--restore)
                action="restore"
                restore_file="$2"
                shift 2
                ;;
            --to)
                restore_to="$2"
                shift 2
                ;;
            -v|--verify)
                action="verify"
                verify_file="$2"
                shift 2
                ;;
            -d|--dry-run)
                dry_run=true
                shift
                ;;
            -s|--summary)
                action="summary"
                shift
                ;;
            --setup-cron)
                action="setup_cron"
                shift
                ;;
            --remove-cron)
                action="remove_cron"
                shift
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Load configuration
    if [ -f "$config_file" ]; then
        source "$config_file"
    else
        echo "Error: Configuration file not found: $config_file"
        exit 1
    fi
    
    # Ensure log directory exists
    mkdir -p "$LOG_DIRECTORY"
    
    # Perform requested action
    case "$action" in
        "backup")
            if [ "$dry_run" = true ]; then
                log_message "INFO" "DRY RUN MODE - No backups will be created"
                log_message "INFO" "Source directories: ${SOURCE_DIRECTORIES[*]}"
                log_message "INFO" "Custom paths: ${CUSTOM_BACKUP_PATHS[*]}"
                log_message "INFO" "Exclude patterns: ${EXCLUDE_PATTERNS[*]}"
                log_message "INFO" "Destination: $DESTINATION_DIRECTORY"
                log_message "INFO" "Compression: $COMPRESSION"
                log_message "INFO" "Max backups to keep: $MAX_BACKUPS"
                exit 0
            else
                perform_backup
                exit $?
            fi
            ;;
        "list")
            list_backups
            ;;
        "restore")
            if [ -z "$restore_file" ]; then
                echo "Error: Restore requires a backup file"
                show_help
                exit 1
            fi
            
            if [ -z "$restore_to" ]; then
                restore_to="./restored_$(date +%Y%m%d_%H%M%S)"
                log_message "INFO" "No restore directory specified, using: $restore_to"
            fi
            
            restore_backup "$restore_file" "$restore_to"
            exit $?
            ;;
        "verify")
            if [ -z "$verify_file" ]; then
                echo "Error: Verify requires a backup file"
                show_help
                exit 1
            fi
            
            if verify_backup "$verify_file"; then
                echo "✓ Backup verification passed"
                exit 0
            else
                echo "✗ Backup verification failed"
                exit 1
            fi
            ;;
        "summary")
            if [ -f "${DESTINATION_DIRECTORY}/backup.info" ]; then
                echo "=== Last Backup Summary ==="
                cat "${DESTINATION_DIRECTORY}/backup.info"
            else
                echo "No backup summary found"
            fi
            ;;
        "setup_cron")
            setup_cron
            ;;
        "remove_cron")
            remove_cron
            ;;
    esac
}

# Run main function
main "$@"