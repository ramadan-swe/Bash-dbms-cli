#!/bin/bash

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
        1) ls ;;
        2) ls -a ;;
        3) ;;
        4) ;;
        5) echo "Exiting..."; break ;;
        *) echo "Invalid option" ;;
    esac
done
