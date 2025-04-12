USE bookstore_db;
-- Book Language
CREATE TABLE book_language (
    language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_code CHAR(2) NOT NULL,
    language_name VARCHAR(50) NOT NULL,
    UNIQUE KEY (language_code)
);

-- Publisher
CREATE TABLE publisher (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(100) NOT NULL,
    UNIQUE KEY (publisher_name)
);

-- Author
CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(100) NOT NULL,
    UNIQUE KEY (author_name)
);

-- Book
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publisher_id INT NOT NULL,
    language_id INT NOT NULL,
    num_pages INT,
    publication_date DATE,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    INDEX (title),
    INDEX (price)
);

-- Book-Author Relationship (Many-to-Many)
CREATE TABLE book_author (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE
);
-- Country
CREATE TABLE country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(50) NOT NULL,
    UNIQUE KEY (country_name)
);

-- Address Status
CREATE TABLE address_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_value VARCHAR(20) NOT NULL,
    UNIQUE KEY (status_value)
);

-- Address
CREATE TABLE address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    street_number VARCHAR(10) NOT NULL,
    street_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country_id INT NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id),
    INDEX (city),
    INDEX (postal_code)
);

-- Customer
CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX (last_name, first_name),
    INDEX (email)
);

-- Customer Address
CREATE TABLE customer_address (
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    status_id INT NOT NULL,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (address_id) REFERENCES address(address_id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);
-- Order Status
CREATE TABLE order_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_value VARCHAR(20) NOT NULL,
    UNIQUE KEY (status_value)
);

-- Shipping Method
CREATE TABLE shipping_method (
    method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(50) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    UNIQUE KEY (method_name)
);

-- Customer Order
CREATE TABLE cust_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    customer_id INT NOT NULL,
    shipping_address_id INT NOT NULL,
    method_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id),
    FOREIGN KEY (method_id) REFERENCES shipping_method(method_id),
    INDEX (order_date)
);

-- Order Line
CREATE TABLE order_line (
    line_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    INDEX (order_id)
);

-- Order History
CREATE TABLE order_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES order_status(status_id),
    INDEX (order_id, status_date)
);
-- Insert sample languages
INSERT INTO book_language (language_code, language_name) VALUES 
('EN', 'English'), ('FR', 'French'), ('DE', 'German'), ('ES', 'Spanish');

-- Insert sample publishers
INSERT INTO publisher (publisher_name) VALUES 
('Penguin Random House'), ('HarperCollins'), ('Simon & Schuster');

-- Insert sample authors
INSERT INTO author (author_name) VALUES 
('J.K. Rowling'), ('George R.R. Martin'), ('Stephen King');

-- Insert sample books
INSERT INTO book (title, isbn, publisher_id, language_id, num_pages, publication_date, price, stock_quantity) VALUES
('Harry Potter and the Philosopher''s Stone', '9780747532743', 1, 1, 223, '1997-06-26', 12.99, 50),
('A Game of Thrones', '9780553103540', 2, 1, 694, '1996-08-01', 15.99, 30),
('The Shining', '9780307743657', 3, 1, 447, '1977-01-28', 9.99, 25);

-- Link books to authors
INSERT INTO book_author (book_id, author_id) VALUES 
(1, 1), (2, 2), (3, 3);

-- Admin_privileges
CREATE USER 'admin_john'@'localhost' IDENTIFIED BY 'AdminP@ss123';
GRANT ALL ON bookstore_db.* TO 'admin_john'@'localhost';

-- Staff (Inventory + Orders)
CREATE USER 'staff_mary'@'localhost' IDENTIFIED BY 'StaffP@ss123';
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore_db.* TO 'staff_mary'@'localhost';

-- Reporting (Read-Only)
CREATE USER 'reports_sam'@'localhost' IDENTIFIED BY 'ReportP@ss123';
GRANT SELECT ON bookstore_db.* TO 'reports_sam'@'localhost';

-- Optional: Web App User (Limited Write)
CREATE USER 'webapp'@'%' IDENTIFIED BY 'WebAppP@ss123';  -- '%' allows remote connections
GRANT SELECT, INSERT, UPDATE ON bookstoredb.book TO 'webapp'@'%';
GRANT SELECT, INSERT ON bookstoredb.cust_order TO 'webapp'@'%';
GRANT SELECT ON bookstoredb.* TO 'webapp'@'%';
-- 6. Finalize
FLUSH PRIVILEGES;
