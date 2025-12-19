#!/bin/bash
# Restore functionality module

# Function to list available backups
list_backups() {
    local backup_dir="$DESTINATION_DIRECTORY"
    
    if [ ! -d "$backup_dir" ]; then
        echo "No backup directory found at $backup_dir"
        return 1
    fi
    
    echo ""
    echo "Available Backups in: $backup_dir"
    echo "========================================="
    
    if [ "$COMPRESSION" = "rsync" ]; then
        # List directory backups
        find "$backup_dir" -maxdepth 1 -type d -name "backup_*" | sort -r | while read -r dir; do
            if [ -d "$dir" ]; then
                local size=$(du -sh "$dir" 2>/dev/null | cut -f1)
                local mtime=$(stat -c "%y" "$dir" 2>/dev/null | cut -d'.' -f1)
                local dirname=$(basename "$dir")
                printf "%-30s %-10s %s\n" "$dirname" "$size" "$mtime"
            fi
        done
    else
        # List file backups
        find "$backup_dir" -maxdepth 1 -type f -name "${BACKUP_NAME}_*" | sort -r | while read -r file; do
            if [ -f "$file" ]; then
                local size=$(du -h "$file" 2>/dev/null | cut -f1)
                local mtime=$(stat -c "%y" "$file" 2>/dev/null | cut -d'.' -f1)
                local filename=$(basename "$file")
                printf "%-40s %-10s %s\n" "$filename" "$size" "$mtime"
            fi
        done
    fi
    
    echo "========================================="
    
    # Show disk usage
    echo ""
    echo "Disk Usage:"
    df -h "$backup_dir" 2>/dev/null || echo "Cannot determine disk usage"
}

# Function to restore from backup
restore_backup() {
    local backup_file="$1"
    local restore_dir="$2"
    
    if [ ! -e "$backup_file" ]; then
        log_message "ERROR" "Backup file not found: $backup_file"
        return 1
    fi
    
    log_message "INFO" "Starting restore from: $backup_file"
    log_message "INFO" "Restoring to: $restore_dir"
    
    mkdir -p "$restore_dir"
    
    # Determine backup type and restore accordingly
    if [[ "$backup_file" == *.gpg ]]; then
        # Encrypted backup
        if [ -z "$ENCRYPTION_PASSWORD" ]; then
            log_message "ERROR" "Encryption password not set for restore"
            return 1
        fi
        
        log_message "INFO" "Decrypting and extracting backup..."
        if echo "$ENCRYPTION_PASSWORD" | gpg --batch --yes --passphrase-fd 0 \
            --decrypt "$backup_file" | tar xz -C "$restore_dir"; then
            log_message "INFO" "Restore completed successfully"
            return 0
        else
            log_message "ERROR" "Restore failed"
            return 1
        fi
        
    elif [[ "$backup_file" == *.tar.gz ]] || [[ "$backup_file" == *.tgz ]]; then
        # tar.gz backup
        log_message "INFO" "Extracting tar.gz backup..."
        if tar xzf "$backup_file" -C "$restore_dir"; then
            log_message "INFO" "Restore completed successfully"
            return 0
        else
            log_message "ERROR" "Restore failed"
            return 1
        fi
        
    elif [[ "$backup_file" == *.tar.bz2 ]]; then
        # tar.bz2 backup
        log_message "INFO" "Extracting tar.bz2 backup..."
        if tar xjf "$backup_file" -C "$restore_dir"; then
            log_message "INFO" "Restore completed successfully"
            return 0
        else
            log_message "ERROR" "Restore failed"
            return 1
        fi
        
    elif [[ "$backup_file" == *.tar.xz ]]; then
        # tar.xz backup
        log_message "INFO" "Extracting tar.xz backup..."
        if tar xJf "$backup_file" -C "$restore_dir"; then
            log_message "INFO" "Restore completed successfully"
            return 0
        else
            log_message "ERROR" "Restore failed"
            return 1
        fi
        
    elif [ -d "$backup_file" ]; then
        # Directory backup (rsync)
        log_message "INFO" "Copying directory backup..."
        if cp -r "$backup_file"/* "$restore_dir"/ 2>/dev/null; then
            log_message "INFO" "Restore completed successfully"
            return 0
        else
            log_message "ERROR" "Restore failed"
            return 1
        fi
    fi
    
    log_message "ERROR" "Unknown backup format"
    return 1
}
