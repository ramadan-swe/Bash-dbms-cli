# Bash DBMS CLI (Database Management System)

A simple **Database Management System (DBMS)** implemented in **Bash shell scripting**.  
The project provides a **CLI menu-based application** that allows users to create, manage, and interact with databases and tables directly from the terminal.  

---

## 🚀 Features

### Main Menu
- Create Database
- List Databases
- Connect to Database
- Drop Database

### Table Menu (Inside a Database)
- Create Table
- List Tables
- Drop Table
- Insert into Table
- Select From Table
- Delete From Table
- Update Table

### 🔧 Additional Notes
- Databases are stored as **directories**.
- Tables are stored as **files** with schema + data.
- Supports **datatypes validation** (`int`, `string`).
- Enforces **Primary Key uniqueness**.
- Displays results in a **formatted table**.

---

## 📂 Project Structure

---

## ⚡ Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/ramadan-swe/bash-dbms-cli.git
   cd bash-dbms

2. Make scripts executable:

chmod +x main.sh


3. Run the application:

./main.sh




---

✅ Example Run

===== Bash DBMS =====
1) Create Database
2) List Databases
3) Connect to Database
4) Drop Database
5) Exit
Choose option: 1

Enter database name: school
Database 'school' created successfully!


---

🧪 Testing

Test with different inputs (valid and invalid).

Check datatype validation on insert/update.

Ensure primary key rules are enforced.



---

🎯 Bonus Features (Optional)

Accept SQL-like commands (e.g., SELECT * FROM students;). And GUI menu.

---

📜 License

This project is for educational purposes only.
