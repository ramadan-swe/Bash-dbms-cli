#!/bin/bash

DB_ROOT="./DBMS"

while true
do
    echo "Menu:"
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect to Database"
    echo "4. Drop Database"
    echo "5. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) 
            read -p "Enter database name: " dbname
            if [[ "$dbname" =~ ^[A-Za-z0-9_]+$ ]]; then
                mkdir "$DB_ROOT/$dbname"
                echo "Database '$dbname' created."
            else
                echo "Invalid name. Only letters, numbers, and underscores allowed."  
            fi
            ;;
        2) 
            echo "Existing Databases:"
            ls "$DB_ROOT"
            ;;
        3) 
            read -p "Enter database name: " dbname
            if [ -d "$DB_ROOT/$dbname" ]; then
                echo "Connected to '$dbname'."
                cd "$DB_ROOT/$dbname"
            else
                echo "Database '$dbname' does not exist."
            fi
            ;;
        4) 
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
            ;;
        5) echo "Exiting..." 
            break 
            ;;
        *) echo "Invalid option" ;;
    esac
done
