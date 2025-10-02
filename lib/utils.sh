#!/bin/bash

print_main_menu() {
    echo "=============================="
    echo "       Bash DBMS - Main       "
    echo "=============================="
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect to Database"
    echo "4. Drop Database"
    echo "5. Exit"
    echo "------------------------------"
}

read_choice() {
    local prompt="$1"
    read -p "$prompt" choice
    echo "$choice"
}
