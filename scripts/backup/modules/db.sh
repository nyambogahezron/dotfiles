#!/bin/bash
# Database backup module

# Function to backup MySQL databases
backup_mysql() {
    if [ "$BACKUP_MYSQL" = false ]; then
        return 0
    fi
    
    log_message "INFO" "Starting MySQL backup..."
    
    mkdir -p "$MYSQL_BACKUP_DIR"
    local mysql_timestamp=$(date +"%Y%m%d_%H%M%S")
    
    # Get list of databases
    local databases=()
    if [ ${#MYSQL_DATABASES[@]} -eq 0 ]; then
        # Backup all databases
        databases=($(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW DATABASES;" | grep -v Database))
    else
        databases=("${MYSQL_DATABASES[@]}")
    fi
    
    # Backup each database
    for db in "${databases[@]}"; do
        # Skip system databases
        if [[ "$db" == "information_schema" ]] || [[ "$db" == "performance_schema" ]] || \
           [[ "$db" == "mysql" ]] || [[ "$db" == "sys" ]]; then
            continue
        fi
        
        local backup_file="${MYSQL_BACKUP_DIR}/${db}_${mysql_timestamp}.sql.gz"
        log_message "INFO" "Backing up MySQL database: $db"
        
        if mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --single-transaction "$db" | gzip > "$backup_file"; then
            log_message "INFO" "MySQL database $db backed up to $backup_file"
        else
            log_message "ERROR" "Failed to backup MySQL database: $db"
            return 1
        fi
    done
    
    log_message "INFO" "MySQL backup completed"
    return 0
}

# Function to backup PostgreSQL databases
backup_postgresql() {
    if [ "$BACKUP_POSTGRESQL" = false ]; then
        return 0
    fi
    
    log_message "INFO" "Starting PostgreSQL backup..."
    
    mkdir -p "$POSTGRESQL_BACKUP_DIR"
    local pg_timestamp=$(date +"%Y%m%d_%H%M%S")
    
    # Get list of databases
    local databases=()
    if [ ${#POSTGRESQL_DATABASES[@]} -eq 0 ]; then
        # Backup all databases
        databases=($(sudo -u postgres psql -l -t | cut -d'|' -f1 | tr -d ' ' | grep -v template | grep -v postgres))
    else
        databases=("${POSTGRESQL_DATABASES[@]}")
    fi
    
    # Backup each database
    for db in "${databases[@]}"; do
        local backup_file="${POSTGRESQL_BACKUP_DIR}/${db}_${pg_timestamp}.sql.gz"
        log_message "INFO" "Backing up PostgreSQL database: $db"
        
        if sudo -u postgres pg_dump "$db" | gzip > "$backup_file"; then
            log_message "INFO" "PostgreSQL database $db backed up to $backup_file"
        else
            log_message "ERROR" "Failed to backup PostgreSQL database: $db"
            return 1
        fi
    done
    
    log_message "INFO" "PostgreSQL backup completed"
    return 0
}
