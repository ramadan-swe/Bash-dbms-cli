# Simplified Bash DBMS

A beginner-friendly Database Management System simulation built in Bash for educational purposes.

## Project Structure

```
bash-dbms/
├── dbms.sh              # Main entry point
├── lib/
│   ├── utils.sh         # Utility functions (validation, metadata parsing)
│   ├── db_ops.sh        # Database operations (CREATE, DROP, LIST, CONNECT)
│   ├── table_menu.sh    # Table menu controller
│   ├── table_ddl.sh     # Table structure operations (CREATE, DROP, LIST)
│   └── table_dml.sh     # Table data operations (INSERT, SELECT, UPDATE, DELETE)
└── DBMS/                # Storage directory (auto-created)
    └── [databases]/
        └── [tables]/
            ├── meta     # Schema definition
            └── data     # CSV rows
```

## Quick Start

### 1. Setup

```bash
# Create project structure
mkdir -p bash-dbms/lib
cd bash-dbms

# Create the files (copy the artifacts)
# - dbms.sh
# - lib/utils.sh
# - lib/db_ops.sh
# - lib/table_menu.sh
# - lib/table_ddl.sh
# - lib/table_dml.sh

# Make main script executable
chmod +x dbms.sh
```

### 2. Run

```bash
./dbms.sh
```

## Features

### Database Operations

- ✅ **Create Database** - Create a new database
- ✅ **List Databases** - View all existing databases
- ✅ **Connect to Database** - Enter table management mode
- ✅ **Drop Database** - Delete a database permanently

### Table Operations (when connected)

- ✅ **Create Table** - Define schema with columns and primary key
- ✅ **List Tables** - View all tables in current database
- ✅ **Insert Row** - Add new records with validation
- ✅ **Select Rows** - View all rows or search by primary key
- ✅ **Update Row** - Modify existing records
- ✅ **Delete Row** - Remove records by primary key
- ✅ **Drop Table** - Delete a table permanently

## Example Workflow

```bash
# Start the system
./dbms.sh

# Create a database
1 → students

# Connect to it
3 → students

# Create a table
1 → users
   Columns: 3
   Col 1: id, int
   Col 2: name, string
   Col 3: age, int
   Primary Key: id

# Insert a row
3 → users
   id: 1
   name: Ahmed
   age: 20

# Select rows
4 → users → 1 (show all)

# Update a row
5 → users → 1 → 2 → Sarah

# Delete a row
6 → users → 1
```

## Technical Details

### Metadata Format

Each table has a `meta` file storing schema:

```
id:int:pk,name:string:,age:int:
```

### Data Format

The `data` file stores CSV rows:

```
1,Ahmed,20
2,Salma,22
```

### Key Technologies Used

- **awk** - CSV parsing, filtering, updating
- **sed** - (can be added for additional operations)
- **Bash arrays** - Metadata storage
- **File system** - Database/table simulation

## Features Highlights

### Validation

- ✅ Name validation (alphanumeric + underscore)
- ✅ Type checking (int/string)
- ✅ Primary key uniqueness enforcement
- ✅ No commas in values (CSV safety)

### User Experience

- ✅ Clear menu navigation
- ✅ Confirmation for destructive operations
- ✅ Formatted table display using `column`

## Code Organization

### `utils.sh` - Helper Functions

- `validate_name()` - Name validation
- `parse_metadata()` - Schema parsing
- `validate_type()` - Type checking
- `get_column_index()` - Column lookup

### `db_ops.sh` - Database Management

- `create_database()` - DB creation
- `list_databases()` - DB listing
- `connect_database()` - DB connection
- `drop_database()` - DB deletion

### `table_menu.sh` - Navigation Controller

- `table_menu()` - Display menu and route operations

### `table_ddl.sh` - Table Structure (DDL)

- `create_table()` - Define table schema
- `list_tables()` - Show all tables with info
- `drop_table()` - Delete table with confirmation

### `table_dml.sh` - Table Data (DML)

- `insert_row()` - Add new records
- `select_rows()` - Query data (all or by PK)
- `update_row()` - Modify existing records
- `delete_row()` - Remove records by PK

## Learning Objectives

This project demonstrates:

1. **File-based storage** simulation
2. **CSV data manipulation** with awk
3. **Metadata-driven operations**
4. **Bash scripting** best practices
5. **Modular code organization**
6. **Input validation** and error handling
7. **CRUD operations** implementation

## Limitations (By Design)

This is a **simulation** for learning:

- No transactions or ACID properties
- Single-user only (no concurrency)
- Limited query capabilities (no joins, WHERE clause)
- No indexing or optimization
- Simple data types only (int/string)

## Future Enhancements (Optional)

1. Add WHERE clause for SELECT/DELETE
2. Support more data types (date, float)
3. Implement basic JOIN operations
4. Add data export/import (backup)
5. Create a simple query language parser

## License

Educational project - free to use and modify!

---

**Perfect for:** Bash scripting course, database concepts introduction, team projects

**Team Size:** 2 students recommended

**Difficulty:** Beginner to Intermediate
