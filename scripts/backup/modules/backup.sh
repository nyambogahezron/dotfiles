#!/bin/bash
# Core backup logic module

# Function to create exclude file
create_exclude_file() {
    log_message "INFO" "Creating exclude file..."
    
    # Clear existing file
    > "$EXCLUDE_FILE"
    
    # Add patterns
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        # Convert glob patterns to rsync/tar compatible patterns
        local converted_pattern="$pattern"
        converted_pattern="${converted_pattern//\*\*/\\*\\*}"
        echo "$converted_pattern" >> "$EXCLUDE_FILE"
    done
    
    # Add specific paths
    for path in "${EXCLUDE_SPECIFIC_PATHS[@]}"; do
        echo "$path" >> "$EXCLUDE_FILE"
    done
    
    log_message "INFO" "Exclude file created at $EXCLUDE_FILE"
}

# Function to create tar backup
create_tar_backup() {
    local source_dir="$1"
    local backup_path="$2"
    
    log_message "INFO" "Creating tar backup of $source_dir..."
    
    # Build tar command
    local tar_cmd="tar"
    local tar_options="--create --preserve-permissions"
    
    # Add compression option
    case "$COMPRESSION" in
        "tar.gz")
            tar_cmd="tar czf"
            ;;
        "tar.bz2")
            tar_cmd="tar cjf"
            ;;
        "tar.xz")
            tar_cmd="tar cJf"
            ;;
        *)
            tar_cmd="tar czf"  # Default to gzip
            ;;
    esac
    
    # Add exclude options
    if [ -f "$EXCLUDE_FILE" ]; then
        tar_options="$tar_options --exclude-from=$EXCLUDE_FILE"
    fi
    
    # Add follow symlinks option
    if [ "$FOLLOW_SYMLINKS" = true ]; then
        tar_options="$tar_options -h"
    fi
    
    # Change to parent directory to get relative paths
    local parent_dir=$(dirname "$source_dir")
    local dir_name=$(basename "$source_dir")
    
    if [ -z "$parent_dir" ]; then
        parent_dir="/"
    fi
    
    # Create backup
    if cd "$parent_dir" && $tar_cmd "$backup_path" $tar_options "$dir_name"; then
        log_message "INFO" "Tar backup created: $backup_path"
        return 0
    else
        log_message "ERROR" "Failed to create tar backup"
        return 1
    fi
}

# Function to create rsync backup
create_rsync_backup() {
    local source_dir="$1"
    local dest_dir="$2"
    
    log_message "INFO" "Creating rsync backup of $source_dir..."
    
    # Create destination directory with timestamp
    local backup_dir="${dest_dir}/backup_${TIMESTAMP}"
    mkdir -p "$backup_dir"
    
    # Build rsync command
    local rsync_cmd="rsync $RSYNC_OPTIONS"
    
    # Add exclude options
    if [ -f "$EXCLUDE_FILE" ]; then
        rsync_cmd="$rsync_cmd --exclude-from=$EXCLUDE_FILE"
    fi
    
    # Add hard links option
    if [ "$RSYNC_HARD_LINKS" = true ]; then
        rsync_cmd="$rsync_cmd --hard-links"
    fi
    
    # Add preserve permissions option
    if [ "$PRESERVE_PERMISSIONS" = true ]; then
        rsync_cmd="$rsync_cmd --perms --owner --group"
    fi
    
    # Execute rsync
    log_message "INFO" "Running command: $rsync_cmd $source_dir/ $backup_dir/"
    
    if $rsync_cmd "$source_dir/" "$backup_dir/"; then
        log_message "INFO" "Rsync backup created in: $backup_dir"
        BACKUP_FILENAME="backup_${TIMESTAMP}"
        return 0
    else
        log_message "ERROR" "Failed to create rsync backup"
        return 1
    fi
}

# Main backup function
perform_backup() {
    log_message "INFO" "Starting backup process..."
    log_message "INFO" "Source: ${SOURCE_DIRECTORIES[*]}"
    log_message "INFO" "Destination: $DESTINATION_DIRECTORY"
    log_message "INFO" "Compression: $COMPRESSION"
    
    # Execute pre-backup commands
    execute_pre_backup_commands
    
    # Check disk space
    if ! check_disk_space "$DESTINATION_DIRECTORY"; then
        return 1
    fi
    
    # Create destination directory
    mkdir -p "$DESTINATION_DIRECTORY"
    
    # Create exclude file
    create_exclude_file
    
    # Backup databases if enabled
    if [ "$BACKUP_MYSQL" = true ]; then
        backup_mysql || log_message "WARNING" "MySQL backup failed, continuing with file backup"
    fi
    
    if [ "$BACKUP_POSTGRESQL" = true ]; then
        backup_postgresql || log_message "WARNING" "PostgreSQL backup failed, continuing with file backup"
    fi
    
    # Combine source directories with custom paths
    local all_sources=("${SOURCE_DIRECTORIES[@]}" "${CUSTOM_BACKUP_PATHS[@]}")
    
    # Perform backup based on compression type
    local backup_path="${DESTINATION_DIRECTORY}/${BACKUP_FILENAME}"
    
    if [ "$COMPRESSION" = "rsync" ]; then
        # For rsync, we can only handle one source directory
        local source_dir="${all_sources[0]}"
        
        if [ ! -d "$source_dir" ]; then
            log_message "ERROR" "Source directory not found: $source_dir"
            return 1
        fi
        
        if ! create_rsync_backup "$source_dir" "$DESTINATION_DIRECTORY"; then
            return 1
        fi
        
        backup_path="${DESTINATION_DIRECTORY}/backup_${TIMESTAMP}"
        
    else
        # For tar backups, handle multiple directories
        if [ ${#all_sources[@]} -eq 1 ]; then
            # Single directory
            if ! create_tar_backup "${all_sources[0]}" "$backup_path"; then
                return 1
            fi
        else
            # Multiple directories - create a temporary directory and combine
            log_message "INFO" "Creating combined backup of multiple directories..."
            
            local temp_dir="/tmp/backup_combined_${TIMESTAMP}"
            mkdir -p "$temp_dir"
            
            for source_dir in "${all_sources[@]}"; do
                if [ -d "$source_dir" ]; then
                    local dir_name=$(basename "$source_dir")
                    local dest_dir="$temp_dir/$dir_name"
                    mkdir -p "$(dirname "$dest_dir")"
                    
                    log_message "INFO" "Adding directory to combined backup: $source_dir"
                    
                    # Use rsync to copy with exclusions
                    if [ -f "$EXCLUDE_FILE" ]; then
                        rsync -a --exclude-from="$EXCLUDE_FILE" "$source_dir/" "$dest_dir/"
                    else
                        rsync -a "$source_dir/" "$dest_dir/"
                    fi
                fi
            done
            
            # Create tar from combined directory
            if ! create_tar_backup "$temp_dir" "$backup_path"; then
                rm -rf "$temp_dir"
                return 1
            fi
            
            # Cleanup temp directory
            rm -rf "$temp_dir"
        fi
    fi
    
    # Encrypt backup if enabled
    if [ "$ENABLE_ENCRYPTION" = true ]; then
        encrypt_backup "$backup_path" || return 1
        if [[ "$backup_path" != *.gpg ]]; then
            backup_path="${backup_path}.gpg"
        fi
    fi
    
    # Verify backup
    if [ "$VERIFY_BACKUP" = true ]; then
        if verify_backup "$backup_path"; then
            log_message "INFO" "Backup verification successful"
        else
            log_message "ERROR" "Backup verification failed"
            return 1
        fi
    fi
    
    # Execute post-backup commands
    execute_post_backup_commands
    
    # Cleanup old backups
    if [ "$COMPRESSION" = "rsync" ]; then
        cleanup_old_backups "$DESTINATION_DIRECTORY" "backup_*"
    else
        cleanup_old_backups "$DESTINATION_DIRECTORY" "${BACKUP_NAME}_*"
    fi
    
    # Cleanup old logs
    cleanup_old_logs
    
    # Create backup info file
    local info_file="${DESTINATION_DIRECTORY}/backup.info"
    echo "Backup created: $(date)" > "$info_file"
    echo "Backup file: $(basename "$backup_path")" >> "$info_file"
    echo "Backup size: $(du -h "$backup_path" 2>/dev/null | cut -f1)" >> "$info_file"
    echo "Source: ${all_sources[*]}" >> "$info_file"
    
    BACKUP_STATUS="success"
    log_message "INFO" "Backup process completed successfully"
    
    # Create and display summary
    create_backup_summary "$backup_path"
    
    # Send email if enabled
    if [ "$SEND_SUMMARY" = true ]; then
        local email_subject="${EMAIL_SUBJECT} - $BACKUP_STATUS"
        send_email "$email_subject" "$EMAIL_BODY"
    fi
    
    return 0
}
