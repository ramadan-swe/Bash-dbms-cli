#!/bin/bash

# Source table operations dispatcher
source ./lib/table_ops.sh

create_db() {
    read -p "Enter database name: " dbname
    if [[ "$dbname" =~ ^[A-Za-z0-9_]+$ ]]; then
        if [ -d "$DB_ROOT/$dbname" ]; then
            echo "Database '$dbname' already exists."
        else
            mkdir "$DB_ROOT/$dbname"
            echo "Database '$dbname' created."
        fi
    else
        echo "Invalid name. Only letters, numbers, and underscores allowed."
    fi
}

list_dbs() {
    echo "Existing Databases:"
    if [ -z "$(ls -A "$DB_ROOT")" ]; then
        echo "   (no databases found)"
    else
        ls "$DB_ROOT"
    fi
}

connect_db() {
    read -p "Enter database name: " dbname
    if [ -d "$DB_ROOT/$dbname" ]; then
        echo "Connected to '$dbname'."
        table_menu "$dbname"
    else
        echo "Database '$dbname' does not exist."
    fi
}

drop_db() {
    read -p "Enter database name to drop: " dbname
    if [ -d "$DB_ROOT/$dbname" ]; then
        read -p "Are you sure you want to delete '$dbname'? (y/n): " confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            rm -r "$DB_ROOT/$dbname"
            echo "Database '$dbname' deleted."
        else
            echo "Drop cancelled."
        fi
    else
        echo "Database '$dbname' does not exist."
    fi
}
