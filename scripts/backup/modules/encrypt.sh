#!/bin/bash
# Encryption functions module

# Function to encrypt backup
encrypt_backup() {
    if [ "$ENABLE_ENCRYPTION" = true ] && [ -n "$ENCRYPTION_PASSWORD" ]; then
        local input_file="$1"
        local output_file="${input_file}.gpg"
        
        log_message "INFO" "Encrypting backup..."
        
        if echo "$ENCRYPTION_PASSWORD" | gpg --batch --yes --passphrase-fd 0 \
            --symmetric --cipher-algo AES256 -o "$output_file" "$input_file"; then
            log_message "INFO" "Backup encrypted: $output_file"
            # Remove unencrypted backup
            rm "$input_file"
            BACKUP_FILENAME="${BACKUP_FILENAME}.gpg"
            return 0
        else
            log_message "ERROR" "Failed to encrypt backup"
            return 1
        fi
    fi
    return 0
}
