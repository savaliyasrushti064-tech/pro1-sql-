DROP DATABASE smart_library;

CREATE DATABASE smart_library;
USE smart_library;

-- 1. Authors Table
CREATE TABLE Authors (
    author_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- 2. Books Table
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(150),
    author_id INT,
    category VARCHAR(50),
    isbn VARCHAR(20),
    published_date DATE,
    price DECIMAL(10,2),
    available_copies INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- 3. Members Table
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(15),
    membership_date DATE
);

-- 4. Transactions Table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    fine_amount DECIMAL(10,2),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

INSERT INTO Authors VALUES
(1,'APJ Abdul Kalam','apj@gmail.com'),
(2,'Chetan Bhagat','chetan@gmail.com'),
(3,'Yuval Noah Harari','yuval@gmail.com');

INSERT INTO Books VALUES
(101,'Ignited Minds',1,'Science','ISBN001','2010-04-12',350,5),
(102,'Half Girlfriend',2,'Fiction','ISBN002','2014-09-15',450,3),
(103,'Sapiens',3,'History','ISBN003','2011-02-20',550,2),
(104,'Future of Humanity',1,'Science','ISBN004','2018-06-22',499,4),
(105,'2 States',2,'Romance','ISBN005','2010-01-10',300,1);

INSERT INTO Members VALUES
(1,'Snehil','snehil@mail.com','9876543210','2021-05-10'),
(2,'Riya','riya@mail.com','9876512345','2023-09-12'),
(3,'Mihir','mihir@mail.com','9638527410','2020-12-01');

INSERT INTO Transactions VALUES
(1001,1,101,'2023-01-05','2023-01-15',0),
(1002,1,103,'2023-02-10','2023-02-28',20),
(1003,2,102,'2024-03-01',NULL,0),
(1004,3,105,'2022-11-15','2022-11-20',0);

INSERT INTO Books VALUES (106,'India 2020',1,'Science','ISBN006','2012-01-01',400,6);

UPDATE Books
SET available_copies = available_copies - 1
WHERE book_id = 102;

DELETE FROM Members
WHERE member_id NOT IN (
    SELECT DISTINCT member_id
    FROM Transactions
    WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

SELECT * FROM Books
WHERE available_copies > 0;

SELECT * FROM Books
WHERE published_date > '2015-01-01';

SELECT * FROM Books
ORDER BY price DESC
LIMIT 5;

SELECT * FROM Members
WHERE membership_date < '2022-01-01';

SELECT * FROM Books
WHERE category='Science' AND price < 500;

SELECT * FROM Books
WHERE available_copies = 0;

SELECT M.*
FROM Members M
LEFT JOIN Transactions T ON M.member_id=T.member_id
GROUP BY M.member_id
HAVING membership_date > '2020-01-01' OR COUNT(T.transaction_id) > 3;

SELECT * FROM Books ORDER BY title ASC;

SELECT member_id, COUNT(*) AS total_borrowed
FROM Transactions
GROUP BY member_id;

SELECT category, COUNT(*) AS total_books
FROM Books
GROUP BY category;

SELECT category, COUNT(*) FROM Books GROUP BY category;

SELECT AVG(price) AS average_price FROM Books;

SELECT book_id, COUNT(*) AS times_borrowed
FROM Transactions
GROUP BY book_id
ORDER BY times_borrowed DESC
LIMIT 1;

SELECT SUM(fine_amount) AS total_fines FROM Transactions;

SELECT B.title, A.name
FROM Books B
INNER JOIN Authors A ON B.author_id=A.author_id;

SELECT M.name, T.book_id
FROM Members M
LEFT JOIN Transactions T ON M.member_id=T.member_id;

SELECT B.*
FROM Transactions T
RIGHT JOIN Books B ON T.book_id=B.book_id
WHERE T.book_id IS NULL;

SELECT M.*
FROM Members M
LEFT JOIN Transactions T ON M.member_id=T.member_id
WHERE T.member_id IS NULL;

SELECT *
FROM Books
WHERE book_id IN (
    SELECT book_id FROM Transactions
    WHERE member_id IN (
        SELECT member_id FROM Members
        WHERE membership_date > '2022-01-01'
    )
);

SELECT * FROM Books
WHERE book_id = (
    SELECT book_id 
    FROM Transactions
    GROUP BY book_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

SELECT * FROM Members
WHERE member_id NOT IN (SELECT DISTINCT member_id FROM Transactions);

SELECT YEAR(published_date) AS publish_year, COUNT(*)
FROM Books
GROUP BY YEAR(published_date);

SELECT transaction_id,
DATEDIFF(return_date, borrow_date) AS days_diff
FROM Transactions;

SELECT DATE_FORMAT(borrow_date,'%d-%m-%Y') AS formatted_date
FROM Transactions;

SELECT UPPER(title) FROM Books;

SELECT TRIM(name) FROM Authors;

SELECT IFNULL(email, 'Not Provided') FROM Members;

SELECT book_id,
       COUNT(*) AS borrow_count,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking
FROM Transactions
GROUP BY book_id;

SELECT member_id,
       COUNT(*) OVER (PARTITION BY member_id ORDER BY borrow_date) AS cumulative_borrowed
FROM Transactions;

SELECT member_id, borrow_date,
       COUNT(*) OVER (PARTITION BY member_id ORDER BY borrow_date 
       ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM Transactions;

SELECT member_id, name,
CASE
    WHEN member_id IN (
        SELECT member_id FROM Transactions
        WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    ) THEN 'Active'
    ELSE 'Inactive'
END AS Membership_Status
FROM Members;

SELECT title,
CASE
    WHEN published_date > '2020-01-01' THEN 'New Arrival'
    WHEN published_date < '2000-01-01' THEN 'Classic'
    ELSE 'Regular'
END AS Category_Type
FROM Books;

