#!/bin/bash

# INSERT ROW
insert_row() {
    local db_name="$1"
    
    read -p "Table name: " table_name
    
    local table_dir="$DB_ROOT/$db_name/$table_name"
    local meta_file="$table_dir/meta"
    local data_file="$table_dir/data"
    
    if ! [ -d "$table_dir" ]; then
        echo "Table '$table_name' not found"
        return
    fi
    
    parse_metadata "$meta_file" || return
    
    echo ""
    echo "Insert into '$table_name':"
    show_schema
    echo ""
    
    local pk_idx=$(get_column_index "$PK_COL")
    local row_values=()
    
    for ((i=0; i<${#COLUMNS[@]}; i++)); do
        local col="${COLUMNS[i]}"
        local type="${TYPES[i]}"
        
        while true; do
            read -p "$col ($type): " value
            
            if ! validate_type "$value" "$type"; then
                continue
            fi
            
            # Check PK uniqueness
            if [ "$col" = "$PK_COL" ]; then
                if awk -F',' -v pk="$value" -v idx="$pk_idx" \
                   '$idx == pk {exit 1}' "$data_file" 2>/dev/null; then
                    :
                else
                    echo "Primary key '$value' already exists"
                    continue
                fi
            fi
            
            break
        done
        
        row_values+=("$value")
    done
    
    # Append row
    (IFS=','; echo "${row_values[*]}") >> "$data_file"
    echo "Row inserted successfully"
}

# SELECT ROWS
select_rows() {
    local db_name="$1"
    
    read -p "Table name: " table_name
    
    local table_dir="$DB_ROOT/$db_name/$table_name"
    local meta_file="$table_dir/meta"
    local data_file="$table_dir/data"
    
    if ! [ -d "$table_dir" ]; then
        echo "Table '$table_name' not found"
        return
    fi
    
    parse_metadata "$meta_file" || return
    
    echo ""
    echo "Select options:"
    echo "1. Show all rows"
    echo "2. Select by primary key"
    read -p "Choice: " choice
    
    echo ""
    echo "Table: $table_name"
    echo "------------------------------"
    
    if [ "$choice" = "1" ]; then
        # Show all rows
        local row_count=$(wc -l < "$data_file" 2>/dev/null || echo 0)
        
        if [ "$row_count" -eq 0 ]; then
            echo "(empty table)"
            return
        fi
        
        {
            IFS=','; echo "${COLUMNS[*]}"
            cat "$data_file"
        } | column -t -s ','
        
        echo "------------------------------"
        echo "Total rows: $row_count"
        
    elif [ "$choice" = "2" ]; then
        # Select by PK
        local pk_idx=$(get_column_index "$PK_COL")
        read -p "Enter $PK_COL value: " pk_value
        
        local result
        result=$(awk -F',' -v pk="$pk_value" -v idx="$pk_idx" \
                     '$idx == pk {print; exit}' "$data_file")
        
        if [ -z "$result" ]; then
            echo "No row found with $PK_COL = $pk_value"
            return
        fi
        
        {
            IFS=','; echo "${COLUMNS[*]}"
            echo "$result"
        } | column -t -s ','
        
    else
        echo "Invalid choice"
    fi
}

# UPDATE ROW
update_row() {
    local db_name="$1"
    
    read -p "Table name: " table_name
    
    local table_dir="$DB_ROOT/$db_name/$table_name"
    local meta_file="$table_dir/meta"
    local data_file="$table_dir/data"
    
    if ! [ -d "$table_dir" ]; then
        echo "Table '$table_name' not found"
        return
    fi
    
    parse_metadata "$meta_file" || return
    
    local pk_idx=$(get_column_index "$PK_COL")
    read -p "Enter $PK_COL value to update: " pk_value
    
    # Find row
    local row
    row=$(awk -F',' -v pk="$pk_value" -v idx="$pk_idx" \
          '$idx == pk {print; exit}' "$data_file")
    
    if [ -z "$row" ]; then
        echo "No row found with $PK_COL = $pk_value"
        return
    fi
    
    echo ""
    echo "Current row: $row"
    show_schema
    echo ""
    
    read -p "Column number to update: " col_num
    
    if ! [[ "$col_num" =~ ^[0-9]+$ ]] || \
       [ "$col_num" -lt 1 ] || [ "$col_num" -gt "${#COLUMNS[@]}" ]; then
        echo "Invalid column"
        return
    fi
    
    local col_name="${COLUMNS[col_num-1]}"
    local col_type="${TYPES[col_num-1]}"
    
    read -p "New value for $col_name ($col_type): " new_value
    
    if ! validate_type "$new_value" "$col_type"; then
        return
    fi
    
    # Check PK uniqueness if updating PK
    if [ "$col_name" = "$PK_COL" ]; then
        if ! awk -F',' -v pk="$new_value" -v idx="$pk_idx" -v old="$pk_value" \
             '($idx == pk) && ($idx != old) {exit 1}' "$data_file"; then
            echo "Primary key '$new_value' already exists"
            return
        fi
    fi
    
    # Update using awk
    awk -F',' -v OFS=',' \
        -v pk="$pk_value" -v pk_idx="$pk_idx" \
        -v col="$col_num" -v val="$new_value" \
        '$pk_idx == pk { $col = val } { print }' "$data_file" > "$data_file.tmp"
    
    mv "$data_file.tmp" "$data_file"
    echo "Row updated successfully"
}

# DELETE ROW
delete_row() {
    local db_name="$1"
    
    read -p "Table name: " table_name
    
    local table_dir="$DB_ROOT/$db_name/$table_name"
    local meta_file="$table_dir/meta"
    local data_file="$table_dir/data"
    
    if ! [ -d "$table_dir" ]; then
        echo "Table '$table_name' not found"
        return
    fi
    
    parse_metadata "$meta_file" || return
    
    local pk_idx=$(get_column_index "$PK_COL")
    read -p "Enter $PK_COL value to delete: " pk_value
    
    # Check if exists and show row
    local row
    row=$(awk -F',' -v pk="$pk_value" -v idx="$pk_idx" \
          '$idx == pk {print; exit}' "$data_file")
    
    if [ -z "$row" ]; then
        echo "No row found with $PK_COL = $pk_value"
        return
    fi
    
    echo "Row to delete: $row"
    read -p "Confirm deletion? (y/n): " confirm
    
    if ! [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo "Cancelled"
        return
    fi
    
    # Delete using awk
    awk -F',' -v pk="$pk_value" -v idx="$pk_idx" \
        '$idx != pk {print}' "$data_file" > "$data_file.tmp"
    
    mv "$data_file.tmp" "$data_file"
    echo "Row deleted successfully"
}