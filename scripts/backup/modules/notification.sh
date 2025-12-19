#!/bin/bash
# Email notifications module

# Function to send email
send_email() {
    if [ "$ENABLE_EMAIL_NOTIFICATIONS" = true ] && [ -n "$EMAIL_ADDRESS" ]; then
        local subject="$1"
        local body="$2"
        
        if command -v mail &> /dev/null; then
            echo "$body" | mail -s "$subject" "$EMAIL_ADDRESS"
            log_message "INFO" "Email notification sent to $EMAIL_ADDRESS"
        else
            log_message "WARNING" "mail command not found. Email notification skipped."
        fi
    fi
}

# Function to create backup summary
create_backup_summary() {
    local backup_path="$1"
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local duration_str=$(printf "%02d:%02d:%02d" $((duration/3600)) $(((duration/60)%60)) $((duration%60)))
    
    local backup_size="0"
    if [ -e "$backup_path" ]; then
        if [ -f "$backup_path" ]; then
            backup_size=$(du -h "$backup_path" | cut -f1)
        elif [ -d "$backup_path" ]; then
            backup_size=$(du -sh "$backup_path" | cut -f1)
        fi
    fi
    
    EMAIL_BODY="=== BACKUP SUMMARY ===
Backup Tool: $SCRIPT_NAME
Status: $BACKUP_STATUS
Timestamp: $(date '+%Y-%m-%d %H:%M:%S')
Duration: $duration_str
Backup File: $(basename "$backup_path")
Backup Size: $backup_size
Destination: $(dirname "$backup_path")
Source Directories: ${SOURCE_DIRECTORIES[*]}
Compression: $COMPRESSION
Encryption: $([ "$ENABLE_ENCRYPTION" = true ] && echo "Enabled" || echo "Disabled")
Verification: $([ "$VERIFY_BACKUP" = true ] && echo "Passed" || echo "Skipped/Failed")

=== LOG SUMMARY ===
$(tail -20 "$LOG_FILE" 2>/dev/null || echo "Log file not available")

=== DISK USAGE ===
$(df -h "$DESTINATION_DIRECTORY" 2>/dev/null || echo "Disk usage information not available")
"
    
    # Print summary to console
    echo ""
    echo "========================================="
    echo "           BACKUP COMPLETED             "
    echo "========================================="
    echo "Status:        $BACKUP_STATUS"
    echo "Duration:      $duration_str"
    echo "Backup File:   $(basename "$backup_path")"
    echo "Backup Size:   $backup_size"
    echo "Destination:   $(dirname "$backup_path")"
    echo "Log File:      $LOG_FILE"
    echo "========================================="
    echo ""
}
