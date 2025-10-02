#!/bin/bash

# Validate name (alphanumeric + underscore only)
validate_name() {
    local name="$1"
    [[ "$name" =~ ^[A-Za-z][A-Za-z0-9_]*$ ]]
}

# Check if database exists
db_exists() {
    local db="$1"
    [ -d "$DB_ROOT/$db" ]
}

# Check if table exists
table_exists() {
    local db="$1"
    local table="$2"
    [ -d "$DB_ROOT/$db/$table" ]
}

# Read and parse metadata file
# Sets global arrays: COLUMNS, TYPES, PK_COL
parse_metadata() {
    local meta_file="$1"
    
    if [ ! -f "$meta_file" ]; then
        echo "Metadata file not found"
        return 1
    fi
    
    # Read metadata (format: col1:type1:pk_flag,col2:type2:,...)
    local meta_line
    meta_line=$(cat "$meta_file")
    
    COLUMNS=()
    TYPES=()
    PK_COL=""
    
    # Parse using awk - split by comma, then by colon
    while IFS=':' read -r col type pk_flag; do
        # Skip empty entries
        if [ -n "$col" ] && [ -n "$type" ]; then
            COLUMNS+=("$col")
            TYPES+=("$type")
            if [ "$pk_flag" = "pk" ]; then
                PK_COL="$col"
            fi
        fi
    done < <(awk 'BEGIN{RS=","} NF>0 {print}' <<< "$meta_line")
    
    if [ -z "$PK_COL" ]; then
        echo "No primary key defined"
        return 1
    fi
    
    return 0
}

# Get column index (1-based) for a column name
get_column_index() {
    local col_name="$1"
    for ((i=0; i<${#COLUMNS[@]}; i++)); do
        if [ "${COLUMNS[i]}" = "$col_name" ]; then
            echo $((i + 1))
            return 0
        fi
    done
    return 1
}

# Validate value against type
validate_type() {
    local value="$1"
    local type="$2"
    
    # No commas allowed (CSV safety)
    if [[ "$value" == *","* ]]; then
        echo "Commas not allowed in values"
        return 1
    fi
    
    # Type validation
    if [ "$type" = "int" ]; then
        if ! [[ "$value" =~ ^-?[0-9]+$ ]]; then
            echo "Must be an integer"
            return 1
        fi
    fi
    
    return 0
}

# Display table schema
show_schema() {
    echo ""
    echo "Columns:"
    for ((i=0; i<${#COLUMNS[@]}; i++)); do
        local marker=""
        [ "${COLUMNS[i]}" = "$PK_COL" ] && marker=" [PRIMARY KEY]"
        echo "  $((i+1)). ${COLUMNS[i]} (${TYPES[i]})$marker"
    done
}