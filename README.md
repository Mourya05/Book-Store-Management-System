# Book Store Management System

A Java Swing application for managing a book store's inventory.

## Prerequisites

1. Java Development Kit (JDK) 8 or higher
2. MySQL Server
3. MySQL Connector/J (JDBC driver)

## Setup Instructions

1. Install MySQL Server if not already installed
2. Run the database setup script:
   - Open MySQL command line or workbench
   - Execute the contents of `database/setup.sql`

3. Configure Database Connection:
   - Open `src/database/DBConnection.java`
   - Update the following if needed:
     - URL (default: "jdbc:mysql://localhost:3306/bookstore")
     - USERNAME (default: "root")
     - PASSWORD (default: "")

4. Compile and Run:
   - Compile all Java files
   - Run the main class: `gui.BookStoreGUI`

## Features

- Add new books to inventory
- Update existing book details
- Delete books from inventory
- View all books in a table format
- Clear input fields

## Project Structure

- `src/database/` - Database connection utilities
- `src/models/` - Data models
- `src/gui/` - User interface components
- `database/` - SQL scripts

## Usage

1. Launch the application
2. Use the input fields to enter book details
3. Click appropriate buttons to perform operations:
   - Add Book: Add a new book to inventory
   - Update Book: Update selected book's details
   - Delete Book: Remove selected book from inventory
   - Clear Fields: Reset input fields

<!-- copilot-tick 2026-01-17T04:54:09.897Z -->
