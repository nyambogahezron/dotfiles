#!/bin/bash
# Utility functions module for backup tool

# Function to print colored output
print_status() {
    local color="$1"
    local message="$2"
    echo -e "${color}[$(date '+%Y-%m-%d %H:%M:%S')] ${message}${NC}"
}

# Function to log messages
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Print to console
    case "$level" in
        "INFO")
            print_status "$GREEN" "[INFO] $message"
            ;;
        "WARNING")
            print_status "$YELLOW" "[WARNING] $message"
            ;;
        "ERROR")
            print_status "$RED" "[ERROR] $message"
            ;;
        *)
            print_status "$BLUE" "[$level] $message"
            ;;
    esac
    
    # Log to file
    mkdir -p "$LOG_DIRECTORY"
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

# Function to check disk space
check_disk_space() {
    if [ "$CHECK_DISK_SPACE" = true ]; then
        local destination="$1"
        local available_gb
        
        # Check if destination exists
        if [ ! -d "$destination" ]; then
            mkdir -p "$destination"
        fi
        
        # Get available space in GB
        available_gb=$(df -BG "$destination" | awk 'NR==2 {print $4}' | sed 's/G//')
        
        if [ "$available_gb" -lt "$MIN_DISK_SPACE_GB" ]; then
            log_message "ERROR" "Insufficient disk space on $destination. Available: ${available_gb}GB, Required: ${MIN_DISK_SPACE_GB}GB"
            return 1
        fi
        
        log_message "INFO" "Disk space check passed. Available: ${available_gb}GB"
        return 0
    fi
    return 0
}

# Function to execute pre-backup commands
execute_pre_backup_commands() {
    if [ ${#PRE_BACKUP_COMMANDS[@]} -eq 0 ]; then
        return 0
    fi
    
    log_message "INFO" "Executing pre-backup commands..."
    
    for cmd in "${PRE_BACKUP_COMMANDS[@]}"; do
        if [ -n "$cmd" ]; then
            log_message "INFO" "Running: $cmd"
            
            if eval "$cmd"; then
                log_message "INFO" "Pre-backup command succeeded"
            else
                log_message "WARNING" "Pre-backup command failed: $cmd"
            fi
        fi
    done
}

# Function to execute post-backup commands
execute_post_backup_commands() {
    if [ ${#POST_BACKUP_COMMANDS[@]} -eq 0 ]; then
        return 0
    fi
    
    log_message "INFO" "Executing post-backup commands..."
    
    for cmd in "${POST_BACKUP_COMMANDS[@]}"; do
        if [ -n "$cmd" ]; then
            log_message "INFO" "Running: $cmd"
            
            if eval "$cmd"; then
                log_message "INFO" "Post-backup command succeeded"
            else
                log_message "WARNING" "Post-backup command failed: $cmd"
            fi
        fi
    done
}

# Function to show help
show_help() {
    echo "Usage: $SCRIPT_NAME [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -c, --config FILE   Use alternate configuration file"
    echo "  -l, --list          List available backups"
    echo "  -r, --restore FILE  Restore from backup file"
    echo "      --to DIR        Destination directory for restore (with --restore)"
    echo "  -v, --verify FILE   Verify backup file"
    echo "  -d, --dry-run       Show what would be backed up"
    echo "  -s, --summary       Show last backup summary"
    echo "  --setup-cron        Setup automatic backups via cron"
    echo "  --remove-cron       Remove cron job"
    echo ""
    echo "Examples:"
    echo "  $SCRIPT_NAME                    # Run backup with default config"
    echo "  $SCRIPT_NAME --list             # List available backups"
    echo "  $SCRIPT_NAME --restore backup.tar.gz --to /restore/location"
    echo "  $SCRIPT_NAME --config /path/to/config.sh"
}
