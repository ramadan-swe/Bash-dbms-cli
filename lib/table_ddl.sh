#!/bin/bash

# CREATE TABLE
create_table() {
    local db_name="$1"
    
    read -p "Table name: " table_name
    if ! validate_name "$table_name"; then
        echo "Invalid table name"
        return
    fi
    
    if [ -d "$DB_ROOT/$db_name/$table_name" ]; then
        echo "Table '$table_name' already exists"
        return
    fi
    
    read -p "Number of columns: " col_count
    if ! [[ "$col_count" =~ ^[1-9][0-9]*$ ]]; then
        echo "Invalid number"
        return
    fi
    
    # Collect column definitions
    local cols=()
    local types=()
    
    echo ""
    for ((i=1; i<=col_count; i++)); do
        read -p "Column $i name: " col_name
        if ! validate_name "$col_name"; then
            echo "Invalid column name"
            return
        fi
        
        read -p "Column $i type (int/string): " col_type
        if [[ "$col_type" != "int" && "$col_type" != "string" ]]; then
            echo "Type must be 'int' or 'string'"
            return
        fi
        
        cols+=("$col_name")
        types+=("$col_type")
    done
    
    # Choose primary key
    echo ""
    echo "Available columns: ${cols[*]}"
    read -p "Primary key column: " pk_col
    
    local pk_found=0
    for col in "${cols[@]}"; do
        [ "$col" = "$pk_col" ] && pk_found=1 && break
    done
    
    if [ $pk_found -eq 0 ]; then
        echo "Invalid primary key"
        return
    fi
    
    # Build metadata line: col:type:pk_flag,col:type:,..
    local meta_line=""
    for ((i=0; i<${#cols[@]}; i++)); do
        local pk_flag=""
        [ "${cols[i]}" = "$pk_col" ] && pk_flag="pk"
        
        # Format: col:type:pk_flag (only add :pk if it's the primary key)
        if [ -n "$pk_flag" ]; then
            meta_line+="${cols[i]}:${types[i]}:$pk_flag"
        else
            meta_line+="${cols[i]}:${types[i]}:"
        fi
        
        # Add comma separator (but not after last column)
        [ $i -lt $((${#cols[@]} - 1)) ] && meta_line+=","
    done
    
    # Create table directory and files
    local table_dir="$DB_ROOT/$db_name/$table_name"
    mkdir -p "$table_dir"
    echo "$meta_line" > "$table_dir/meta"
    touch "$table_dir/data"
    
    echo "Table '$table_name' created"
    echo "   Columns: ${cols[*]}"
    echo "   Primary Key: $pk_col"
}

# LIST TABLES
list_tables() {
    local db_name="$1"
    
    echo ""
    echo "Tables in '$db_name':"
    
    local tables=("$DB_ROOT/$db_name"/*)
    if [ ${#tables[@]} -eq 1 ] && [ "${tables[0]}" = "$DB_ROOT/$db_name/*" ]; then
        echo "   (no tables yet)"
        return
    fi
    
    for table in "${tables[@]}"; do
        if [ -d "$table" ]; then
            local tname=$(basename "$table")
            echo "   - $tname"
            
            # Show schema preview if meta exists
            local meta_file="$table/meta"
            if [ -f "$meta_file" ]; then
                parse_metadata "$meta_file" >/dev/null 2>&1
                if [ $? -eq 0 ]; then
                    echo "     (${#COLUMNS[@]} columns, PK: $PK_COL)"
                fi
            fi
        fi
    done
}

# DROP TABLE
drop_table() {
    local db_name="$1"
    
    read -p "Table name to drop: " table_name
    
    if ! [ -d "$DB_ROOT/$db_name/$table_name" ]; then
        echo "Table '$table_name' not found"
        return
    fi
    
    # Show table info before deletion
    local data_file="$DB_ROOT/$db_name/$table_name/data"
    local row_count=0
    if [ -f "$data_file" ]; then
        row_count=$(wc -l < "$data_file")
    fi
    
    echo "Table '$table_name' contains $row_count row(s)"
    read -p "Delete permanently? (y/n): " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$DB_ROOT/$db_name/$table_name"
        echo "Table '$table_name' deleted"
    else
        echo "Cancelled"
    fi
}