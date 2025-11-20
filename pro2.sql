-- DATA TRANSFORMER

-- DROP DATABASE
drop database d;

-- CREATE DATABASE
create database d;

-- USE OF DATABASE
use d;

-- CREATE TABLES
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    RegistrationDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);

-- INSERT RECORDS 
INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2022-03-15'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02');

INSERT INTO Orders VALUES
(101, 1, '2023-07-01', 150.50),
(102, 2, '2023-07-03', 200.75);

INSERT INTO Employees VALUES
(1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000.00),
(2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000.00);

-- INNER JOIN: RETRIEVE ALL ORDERS AND CUSTOMER DETAILS WHERE ORDERS EXIST.
SELECT o.*, c.FirstName, c.LastName, c.Email
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

-- LEFT JOIN: RETRIEVE ALL CUSTOMERS AND THEIR CORRESPONDING ORDERS.
SELECT c.*, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- RIGHT JOIN: RETRIEVE ALL ORDERS AND THEIR CORRESPONDING CUSTOMERS.
SELECT o.*, c.FirstName, c.LastName, c.Email
FROM Orders o
RIGHT JOIN Customers c ON o.CustomerID = c.CustomerID;

-- FULL OUTER JOIN: RETRIEVE ALL CUSTOMERS AND ALL ORDERS,REGARDLESS OF MATCHING.
SELECT c.*, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT c.*, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- SUBQUERY TO FIND CUSTOMERS WHO HAVE PLACED ORDERS WORTH MORE THAN THE AVERAGE AMOUNT.
SELECT *
FROM Orders
WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);

-- SUBQUERY TO FIND EMPLOYEES WITH SALARIES ABOVE THE AVERAGE SALARY.
SELECT *
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- EXTRACT THE YEAR AND MONTH FROM THE ORDERDATE.
SELECT 
    OrderID,
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth
FROM Orders;

-- CALCULATE DIFFERENCE BETWEEN TWO DATES.
SELECT 
    OrderID,
    DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedDate
FROM Orders;

-- FORMAT THE ORDERDATE TO A MORE READABLE FORMAT('DD-MM-YYYY').
SELECT 
    OrderID,
    DATEDIFF(CURDATE(), OrderDate) AS DaysDifference
FROM Orders;

-- CONCATENATE FIRSTNAME AND LASTNAME TO FORM A FULL NAME.
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;

-- REPLACE PART OF A STRING
SELECT 
    REPLACE(FirstName, 'John', 'Jonathan') AS UpdatedName
FROM Customers;

-- CONVERT FIRSTNAME TO UPPERCASE AND LASTNAME TO LOWERCASE.
SELECT 
    UPPER(FirstName) AS FirstNameUpper,
    LOWER(LastName) AS LastNameLower
FROM Customers;

-- TRIM EXTRA SPACES FROM THE EMAIL FIELD.
SELECT 
    TRIM(Email) AS CleanEmail
FROM Customers;

-- CALCULATE THE RUNNING TOTAL OF TOTALAMOUNT FOR EACH OTHER.
SELECT 
    OrderID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount) OVER (ORDER BY OrderDate) AS RunningTotal
FROM Orders;

-- RANK ORDERS BASED ON TOTALAMOUNT USING THE RANK() .
SELECT 
    OrderID,
    TotalAmount,
    RANK() OVER (ORDER BY TotalAmount DESC) AS AmountRank
FROM Orders;

-- ASSIGN A DISCOUNT BASED ON TOTALAMOUNT IN ORDERS (E.G. 1000:10% OFF , 500:5% OFF).
SELECT 
    OrderID,
    TotalAmount,
    CASE
        WHEN TotalAmount >= 1000 THEN '10% Discount'
        WHEN TotalAmount >= 500 THEN '5% Discount'
        ELSE 'No Discount'
    END AS Discount
FROM Orders;


SELECT 
    EmployeeID,
    Salary,
    CASE
        WHEN Salary >= 60000 THEN 'High'
        WHEN Salary >= 40000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees;
