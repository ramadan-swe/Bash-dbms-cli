#!/bin/bash

create_database() {
    read -p "Enter database name: " db_name
    
    if ! validate_name "$db_name"; then
        echo "Invalid name. Use letters, numbers, underscore (start with letter)"
        return
    fi
    
    if [ -d "$DB_ROOT/$db_name" ]; then
        echo "Database '$db_name' already exists"
        return
    fi
    
    mkdir -p "$DB_ROOT/$db_name"
    echo "Database '$db_name' created"
}

list_databases() {
    echo ""
    echo "Existing Databases:"
    
    if [ -z "$(ls -A "$DB_ROOT" 2>/dev/null)" ]; then
        echo "   (no databases yet)"
        return
    fi
    
    for db in "$DB_ROOT"/*; do
        [ -d "$db" ] && echo "   - $(basename "$db")"
    done
}

connect_database() {
    read -p "Enter database name: " db_name
    
    if ! [ -d "$DB_ROOT/$db_name" ]; then
        echo "Database '$db_name' does not exist"
        return
    fi
    
    echo "Connected to '$db_name'"
    table_menu "$db_name"
}

drop_database() {
    read -p "Enter database name: " db_name
    
    if ! [ -d "$DB_ROOT/$db_name" ]; then
        echo "Database '$db_name' does not exist"
        return
    fi
    
    read -p "Delete '$db_name' permanently? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$DB_ROOT/$db_name"
        echo "Database '$db_name' deleted"
    else
        echo "Cancelled"
    fi
}