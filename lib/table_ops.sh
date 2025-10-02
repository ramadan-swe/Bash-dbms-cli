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
            1) create_table "$dbname_arg" ;;
            2) list_tables "$dbname_arg" ;;
            3) drop_table "$dbname_arg" ;;
            4) insert_into_table "$dbname_arg" ;;
            5) delete_from_table "$dbname_arg" ;;
            6) update_table "$dbname_arg" ;;
            7) echo "Backing to main menu "; break ;;
            8) echo "Exiting..."; exit 0 ;;
            *) echo "Invalid option";;
        esac
    done    

}

create_table() {
    local dbname="$1"
    if [ -z "$dbname" ]; then
        echo "No database connected. Please connect to a database first."
        return
    fi

    read -p "Enter table name: " table_name
    # Validate table name
    if [[ ! $table_name =~ ^[A-Za-z0-9_]+$ ]]; then
        echo "Invalid table name. Only alphanumeric characters and underscores allowed."
        return
    fi

    local table_dir="$DB_ROOT/$dbname/$table_name"
    if [ -d "$table_dir" ]; then
        echo "Table '$table_name' already exists in database '$dbname'."
        return
    fi

    read -p "Enter number of columns: " column_count
    if ! [[ $column_count =~ ^[1-9][0-9]*$ ]]; then
        echo "Invalid number of columns. Must be a positive integer."
        return
    fi

    declare -a columns
    declare -a datatypes

    for ((i=1; i<=column_count; i++)); do
        read -p "Enter name for column $i: " col_name
        if [[ ! $col_name =~ ^[A-Za-z0-9_]+$ ]]; then
            echo "Invalid column name. Only alphanumeric characters and underscores allowed."
            return
        fi

        read -p "Enter datatype for column $i (int/string): " col_type
        if [[ "$col_type" != "int" && "$col_type" != "string" ]]; then
            echo "Invalid datatype. Allowed types are 'int' and 'string'."
            return
        fi

        columns+=("$col_name")
        datatypes+=("$col_type")
    done

    echo "Columns defined: ${columns[*]}"

    # Ask for primary key
    while true; do
        read -p "Specify the primary key column (column name): " pk_col
        found_pk=0
        for col in "${columns[@]}"; do
            if [[ "$col" == "$pk_col" ]]; then
                found_pk=1
                break
            fi
        done
        if [[ $found_pk -eq 1 ]]; then
            break
        else
            echo "Invalid primary key column name. Please enter one of: ${columns[*]}"
        fi
    done

    # Compose header row: col_name:datatype:pk_flag
    header=""
    for ((i=0; i<${#columns[@]}; i++)); do
        pk_flag=0
        if [[ "${columns[i]}" == "$pk_col" ]]; then
            pk_flag=1
        fi
        header+="${columns[i]}:${datatypes[i]}:${pk_flag}"
        if [[ $i -lt $((${#columns[@]} - 1)) ]]; then
            header+=","
        fi
    done

    # Create the table directory
    mkdir -p "$table_dir"
    # Create metadata file
    echo "$header" > "$table_dir/metadata"
    # Create empty data file
    touch "$table_dir/data"

    echo "Table '$table_name' created successfully in database '$dbname'."
}

list_tables() {
    local dbname="$1"
    if [ -z "$dbname" ]; then
        echo "No database connected. Please connect to a database first."
        return
    fi

    local db_path="$DB_ROOT/$dbname"
    if [ ! -d "$db_path" ]; then
        echo "Database '$dbname' does not exist."
        return
    fi

    local table_dirs=("$db_path"/*)
    # Check if directory is empty
    if [ ${#table_dirs[@]} -eq 1 ] && [ "${table_dirs[0]}" == "$db_path/*" ]; then
        echo "No tables found in database '$dbname'."
        return
    fi

    echo "Tables in database '$dbname':"
    for td in "${table_dirs[@]}"; do
        if [ -d "$td" ]; then
            echo "- $(basename "$td")"
        fi
    done
}

drop_table() {
    local dbname="$1"
    if [ -z "$dbname" ]; then
        echo "No database connected. Please connect to a database first."
        return
    fi

    read -p "Enter table name to drop: " table_name

    local table_dir="$DB_ROOT/$dbname/$table_name"

    if [ ! -d "$table_dir" ]; then
        echo "Table '$table_name' does not exist in database '$dbname'."
        return
    fi

    read -p "Are you sure you want to delete table '$table_name'? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm -r "$table_dir"
        echo "Table '$table_name' deleted from database '$dbname'."
    else
        echo "Table deletion cancelled."
    fi
}

insert_into_table() { echo "Insert Into Table - not implemented yet."; }
select_from_table() { echo "Select From Table - not implemented yet."; }
delete_from_table() { echo "Delete From Table - not implemented yet."; }
update_table() { echo "Update Table - not implemented yet."; }