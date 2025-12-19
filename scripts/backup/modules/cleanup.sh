#!/bin/bash
# Cleanup functions module

# Function to cleanup old backups
cleanup_old_backups() {
    log_message "INFO" "Cleaning up old backups (keeping last $MAX_BACKUPS)..."
    
    local backup_dir="$1"
    local backup_pattern="$2"
    
    if [ ! -d "$backup_dir" ]; then
        return 0
    fi
    
    # Get list of backups sorted by modification time (oldest first)
    local backups=()
    if [ "$COMPRESSION" = "rsync" ]; then
        backups=($(find "$backup_dir" -maxdepth 1 -type d -name "backup_*" | sort))
    else
        backups=($(find "$backup_dir" -maxdepth 1 -type f -name "${BACKUP_NAME}_*" | sort))
    fi
    
    local backup_count=${#backups[@]}
    
    # Remove old backups
    while [ $backup_count -gt $MAX_BACKUPS ]; do
        local oldest_backup="${backups[0]}"
        
        if [ -e "$oldest_backup" ]; then
            log_message "INFO" "Removing old backup: $oldest_backup"
            
            if [ -d "$oldest_backup" ]; then
                rm -rf "$oldest_backup"
            else
                rm -f "$oldest_backup"
            fi
        fi
        
        # Remove from array
        backups=("${backups[@]:1}")
        backup_count=${#backups[@]}
    done
    
    log_message "INFO" "Backup cleanup completed. Current backups: $backup_count"
}

# Function to cleanup old logs
cleanup_old_logs() {
    log_message "INFO" "Cleaning up old log files..."
    
    if [ ! -d "$LOG_DIRECTORY" ]; then
        return 0
    fi
    
    # Keep only the last MAX_LOG_FILES log files
    local log_files=($(ls -t "$LOG_DIRECTORY"/*.log 2>/dev/null))
    local log_count=${#log_files[@]}
    
    while [ $log_count -gt $MAX_LOG_FILES ]; do
        local oldest_log="${log_files[$((log_count-1))]}"
        
        if [ -f "$oldest_log" ]; then
            log_message "INFO" "Removing old log: $oldest_log"
            rm -f "$oldest_log"
        fi
        
        log_count=$((log_count-1))
    done
}
