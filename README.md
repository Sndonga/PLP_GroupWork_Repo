# PLP_GroupWork_Repo
The repo for the Assignment due 13/04/2025
Bookstore Database System 📚💻
A MySQL database designed for managing bookstore operations, including books, authors, customers, orders, and shipping. This project demonstrates relational database design, user access control, and query optimization for real-world applications.

📌 Features
✔ Comprehensive Schema: Tables for books, authors, customers, orders, and more
✔ Secure Access Control: Role-based permissions (admin, staff, reporting)
✔ Optimized Queries: Sample queries for sales analysis, inventory alerts, and reporting
✔ Scalable Design: Ready for extensions like reviews, discounts, or multi-store support

🛠️ Database Schema
📚 Core Tables
book: Book details (title, ISBN, price, stock)

author: Author information

book_author: Many-to-many relationship between books and authors

publisher: Publisher records

book_language: Supported languages

👥 Customer & Order Management
customer: Customer profiles

address: Shipping/billing addresses

cust_order: Order records

order_line: Items in each order

shipping_method: Delivery options

🔒 Security Setup
Admin: Full database control (admin_john)

Staff: Inventory & order management (staff_mary)

Reporting: Read-only access (reports_sam)
