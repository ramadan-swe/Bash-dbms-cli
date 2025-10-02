#!/bin/bash

DB_ROOT="./databases"
mkdir -p "$DB_ROOT"

# Source modules
source ./lib/utils.sh
source ./lib/db_ops.sh
source ./lib/table_ops.sh

# Main Menu Loop
while true; do
    echo ""
    echo "=============================="
    echo "    Bash DBMS - Main Menu"
    echo "=============================="
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect to Database"
    echo "4. Drop Database"
    echo "5. Exit"
    echo "------------------------------"
    
    read -p "Enter choice: " choice
    
    case $choice in
        1) create_database ;;
        2) list_databases ;;
        3) connect_database ;;
        4) drop_database ;;
        5) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid choice" ;;
    esac
done