#!/bin/bash

DB_ROOT="./databases"

# Source helper functions
source ./lib/utils.sh
source ./lib/db_ops.sh

# Ensure DB_ROOT exists
mkdir -p "$DB_ROOT"

# Main loop
while true; do
    print_main_menu
    choice=$(read_choice "Enter your choice: ")

    case $choice in
        1) create_db ;;
        2) list_dbs ;;
        3) connect_db ;;
        4) drop_db ;;
        5) echo "Exiting..."; break ;;
        *) echo "Invalid option";;
    esac
done
