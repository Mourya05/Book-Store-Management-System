CREATE DATABASE IF NOT EXISTS bookstore;
USE bookstore;

-- Tables
CREATE TABLE IF NOT EXISTS categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS publishers (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    category_id INT,
    publisher_id INT,
    isbn VARCHAR(13),
    publication_year INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

CREATE TABLE IF NOT EXISTS sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    quantity_sold INT NOT NULL,
    sale_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- Triggers
DELIMITER //

CREATE TRIGGER after_sale_insert
AFTER INSERT ON sales
FOR EACH ROW
BEGIN
    UPDATE books 
    SET quantity = quantity - NEW.quantity_sold
    WHERE id = NEW.book_id;
END//

CREATE TRIGGER before_sale_insert
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    DECLARE book_price DECIMAL(10,2);
    
    SELECT price INTO book_price
    FROM books
    WHERE id = NEW.book_id;
    
    SET NEW.total_amount = NEW.quantity_sold * book_price;
END//

-- Stored Procedures
CREATE PROCEDURE GetLowStockBooks(IN threshold INT)
BEGIN
    SELECT b.id, b.title, b.quantity, c.category_name, p.publisher_name
    FROM books b
    LEFT JOIN categories c ON b.category_id = c.category_id
    LEFT JOIN publishers p ON b.publisher_id = p.publisher_id
    WHERE b.quantity <= threshold
    ORDER BY b.quantity ASC;
END//

CREATE PROCEDURE GenerateSalesReport(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT 
        b.title,
        c.category_name,
        SUM(s.quantity_sold) as total_quantity,
        SUM(s.total_amount) as total_revenue
    FROM sales s
    JOIN books b ON s.book_id = b.id
    LEFT JOIN categories c ON b.category_id = c.category_id
    WHERE DATE(s.sale_date) BETWEEN start_date AND end_date
    GROUP BY b.id, c.category_id
    ORDER BY total_revenue DESC;
END//

DELIMITER ;

-- Insert some sample data
INSERT INTO categories (category_name, description) VALUES
('Fiction', 'Fictional literature including novels and short stories'),
('Non-Fiction', 'Educational and informative books'),
('Science', 'Scientific books and publications'),
('Technology', 'Books about computers and technology');

INSERT INTO publishers (publisher_name, contact_person, phone, email) VALUES
('Tech Books Inc', 'John Smith', '555-0101', 'john@techbooks.com'),
('Academic Press', 'Sarah Johnson', '555-0102', 'sarah@academicpress.com'),
('Global Publishing', 'Mike Brown', '555-0103', 'mike@globalpub.com');

-- Insert additional categories
INSERT INTO categories (category_name, description) VALUES
('Classic Literature', 'Timeless literary works that have stood the test of time'),
('Gothic Fiction', 'Dark, mysterious, and supernatural literary works'),
('Dystopian', 'Fiction set in undesirable futuristic societies'),
('Historical Fiction', 'Fictional stories set in the past');

-- Insert additional publishers
INSERT INTO publishers (publisher_name, contact_person, phone, email) VALUES
('Penguin Classics', 'Emma Wilson', '555-0104', 'emma@penguin.com'),
('Vintage Books', 'David Clark', '555-0105', 'david@vintage.com'),
('HarperCollins', 'Lisa Anderson', '555-0106', 'lisa@harpercollins.com');

-- Insert the classic books
INSERT INTO books (title, author, price, quantity, category_id, publisher_id, isbn, publication_year) VALUES
('The Kite Runner', 'Khaled Hosseini', 14.99, 25, 
    (SELECT category_id FROM categories WHERE category_name = 'Classic Literature'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9781594631931', 2003),
    
('Little Women', 'Louisa May Alcott', 12.99, 30,
    (SELECT category_id FROM categories WHERE category_name = 'Classic Literature'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Vintage Books'),
    '9780147514011', 1868),
    
('Fahrenheit 451', 'Ray Bradbury', 11.99, 20,
    (SELECT category_id FROM categories WHERE category_name = 'Dystopian'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins'),
    '9781451673319', 1953),
    
('Jane Eyre', 'Charlotte Bronte', 13.99, 15,
    (SELECT category_id FROM categories WHERE category_name = 'Gothic Fiction'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9780141441146', 1847),
    
('Wuthering Heights', 'Emily Bronte', 12.99, 18,
    (SELECT category_id FROM categories WHERE category_name = 'Gothic Fiction'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9780141439556', 1847),
    
('Animal Farm', 'George Orwell', 10.99, 35,
    (SELECT category_id FROM categories WHERE category_name = 'Classic Literature'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9780451526342', 1945),
    
('The Hobbit', 'J.R.R. Tolkien', 15.99, 40,
    (SELECT category_id FROM categories WHERE category_name = 'Classic Literature'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'HarperCollins'),
    '9780547928227', 1937),
    
('Brave New World', 'Aldous Huxley', 13.99, 22,
    (SELECT category_id FROM categories WHERE category_name = 'Dystopian'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Vintage Books'),
    '9780060850524', 1932),
    
('Crime and Punishment', 'Fyodor Dostoevsky', 16.99, 15,
    (SELECT category_id FROM categories WHERE category_name = 'Classic Literature'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9780143058142', 1866),
    
('War and Peace', 'Leo Tolstoy', 19.99, 12,
    (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Vintage Books'),
    '9781400079988', 1869),
    
('The Picture of Dorian Gray', 'Oscar Wilde', 11.99, 20,
    (SELECT category_id FROM categories WHERE category_name = 'Gothic Fiction'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9780141439570', 1890),
    
('One Hundred Years of Solitude', 'Gabriel García Márquez', 14.99, 18,
    (SELECT category_id FROM categories WHERE category_name = 'Classic Literature'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Vintage Books'),
    '9780060883287', 1967),
    
('The Handmaid''s Tale', 'Margaret Atwood', 13.99, 25,
    (SELECT category_id FROM categories WHERE category_name = 'Dystopian'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Vintage Books'),
    '9780385490818', 1985),
    
('A Tale of Two Cities', 'Charles Dickens', 12.99, 20,
    (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9780141439600', 1859),
    
('The Count of Monte Cristo', 'Alexandre Dumas', 17.99, 15,
    (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9780140449266', 1844),
    
('Frankenstein', 'Mary Shelley', 11.99, 22,
    (SELECT category_id FROM categories WHERE category_name = 'Gothic Fiction'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9780141439471', 1818),
    
('Les Misérables', 'Victor Hugo', 18.99, 14,
    (SELECT category_id FROM categories WHERE category_name = 'Historical Fiction'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9780140444308', 1862),
    
('Dracula', 'Bram Stoker', 12.99, 25,
    (SELECT category_id FROM categories WHERE category_name = 'Gothic Fiction'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9780141439846', 1897),
    
('Slaughterhouse-Five', 'Kurt Vonnegut', 13.99, 20,
    (SELECT category_id FROM categories WHERE category_name = 'Classic Literature'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Vintage Books'),
    '9780385333849', 1969),
    
('Don Quixote', 'Miguel de Cervantes', 16.99, 15,
    (SELECT category_id FROM categories WHERE category_name = 'Classic Literature'),
    (SELECT publisher_id FROM publishers WHERE publisher_name = 'Penguin Classics'),
    '9780142437230', 1605);
