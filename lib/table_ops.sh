#!/bin/bash

# Source DDL and DML operations
source ./lib/table_ddl.sh
source ./lib/table_dml.sh

table_menu() {
    local db_name="$1"
    
    while true; do
        echo ""
        echo "=============================="
        echo "  Database: $db_name"
        echo "=============================="
        echo "Table Structure (DDL):"
        echo "  1. Create Table"
        echo "  2. List Tables"
        echo "  3. Drop Table"
        echo ""
        echo "Table Data (DML):"
        echo "  4. Insert Row"
        echo "  5. Select Rows"
        echo "  6. Update Row"
        echo "  7. Delete Row"
        echo ""
        echo "  8. Back to Main Menu"
        echo "------------------------------"
        
        read -p "Enter choice: " choice
        
        case $choice in
            1) create_table "$db_name" ;;
            2) list_tables "$db_name" ;;
            3) drop_table "$db_name" ;;
            4) insert_row "$db_name" ;;
            5) select_rows "$db_name" ;;
            6) update_row "$db_name" ;;
            7) delete_row "$db_name" ;;
            8) return ;;
            *) echo "Invalid choice" ;;
        esac
    done
}