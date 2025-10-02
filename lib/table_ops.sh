#!/bin/bash

print_table_menu(){
    echo "=============================="
    echo "       Tables Menu            "
    echo "=============================="
    echo "1. Create table"
    echo "2. List tables"
    echo "3. drop tables"
    echo "4. Insert into Table"
    echo "5. Delete From Table"
    echo "6. Update Table"
    echo "7. Back to Main Menu"
    echo "8. Exit"
    echo "------------------------------"
}


table_menu(){
    local dbname_arg="$1"

    
    while true;do
    
    print_table_menu

    read -p "Enter your choice: " choice

        case $choice in
            1) create_table ;;
            2) list_tables ;;
            3) drop_table ;;
            4) insert_into_table ;;
            5) delete_from_table ;;
            6) update_table ;;
            7) echo "Backing to main menu "; break ;;
            8) echo "Exiting..."; exit 0 ;;
            *) echo "Invalid option";;
        esac
    done    

}

create_table() { echo "Create Table - not implemented yet."; }
list_tables() { echo "List Tables - not implemented yet."; }
drop_table() { echo "Drop Table - not implemented yet."; }
insert_into_table() { echo "Insert Into Table - not implemented yet."; }
select_from_table() { echo "Select From Table - not implemented yet."; }
delete_from_table() { echo "Delete From Table - not implemented yet."; }
update_table() { echo "Update Table - not implemented yet."; }