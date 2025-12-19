#!/bin/bash
# Verification functions module

# Function to verify backup
verify_backup() {
    if [ "$VERIFY_BACKUP" = false ]; then
        return 0
    fi
    
    local backup_path="$1"
    log_message "INFO" "Verifying backup..."
    
    if [ "$ENABLE_ENCRYPTION" = true ] && [[ "$backup_path" == *.gpg ]]; then
        # Verify encrypted backup
        if echo "$ENCRYPTION_PASSWORD" | gpg --batch --yes --passphrase-fd 0 \
            --decrypt --quiet "$backup_path" | tar tz > /dev/null 2>&1; then
            log_message "INFO" "Encrypted backup verification passed"
            return 0
        else
            log_message "ERROR" "Encrypted backup verification failed"
            return 1
        fi
    elif [[ "$backup_path" == *.tar.gz ]] || [[ "$backup_path" == *.tgz ]]; then
        # Verify tar.gz
        if tar tzf "$backup_path" > /dev/null 2>&1; then
            log_message "INFO" "Tar.gz backup verification passed"
            return 0
        else
            log_message "ERROR" "Tar.gz backup verification failed"
            return 1
        fi
    elif [[ "$backup_path" == *.tar.bz2 ]]; then
        # Verify tar.bz2
        if tar tjf "$backup_path" > /dev/null 2>&1; then
            log_message "INFO" "Tar.bz2 backup verification passed"
            return 0
        else
            log_message "ERROR" "Tar.bz2 backup verification failed"
            return 1
        fi
    elif [[ "$backup_path" == *.tar.xz ]]; then
        # Verify tar.xz
        if tar tJf "$backup_path" > /dev/null 2>&1; then
            log_message "INFO" "Tar.xz backup verification passed"
            return 0
        else
            log_message "ERROR" "Tar.xz backup verification failed"
            return 1
        fi
    elif [ -d "$backup_path" ]; then
        # Verify directory backup (rsync)
        if [ -f "$backup_path/backup.info" ] || [ "$(ls -A "$backup_path" 2>/dev/null)" ]; then
            log_message "INFO" "Directory backup verification passed"
            return 0
        else
            log_message "ERROR" "Directory backup verification failed"
            return 1
        fi
    fi
    
    return 0
}
