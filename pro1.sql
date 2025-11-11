-- drop database
DROP DATABASE demo;

-- create database
CREATE DATABASE DEMO;
USE DEMO;

-- create table: customers 
CREATE TABLE customers(
customer_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(100),
address VARCHAR(150));

-- create table :orders
CREATE TABLE orders(
order_id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT NOT NULL,
orderdate DATE NOT NULL,
totalamount DECIMAL(12,2) NOT NULL,
FOREIGN KEY(customer_id)REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- create table :products
CREATE TABLE products(
product_id INT AUTO_INCREMENT PRIMARY KEY,
productname VARCHAR(150) NOT NULL,
price DECIMAL(10,2) NOT NULL,
stock INT NOT NULL DEFAULT 0);

-- create table :orderdetails
CREATE TABLE orderDetails(
orderdetail_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
subtotal DECIMAL(12,2)NOT NULL,
FOREIGN KEY(order_id) REFERENCES orders (order_id)ON DELETE CASCADE,
FOREIGN KEY(product_id) REFERENCES products (product_id)
);


-- insert 5 record in customers table
INSERT into customers (name,email,address)
VALUES('khushi','khushi012@gmail.com','rajkot'),
('niji','niji123@gmail.com','surat'),
('drashti','drashti111@gmail.com','gondal'),
('rinkal','rinkal999@gmail.com','baroda'),
('jency','jency222@gmail.com','vapi');


-- insert 5 record in products table
INSERT into products(productname,price,stock)VALUES
('gaming keyboard',599.00,20),
('wireless earbuds',1399.00,50),
('smart watch',999.00,60),
('portable charger',449.00,10),
('headphone',1299.00,25);

-- insert 5 record in orders table
INSERT into orders(customer_id,orderdate,totalamount)VALUES
(1,CURDATE()-INTERVAL 4 DAY,1198.00),
(2,CURDATE()-INTERVAL 35 DAY,1399.00),
(3,CURDATE()-INTERVAL 10 DAY,1998.00),
(4,CURDATE()-INTERVAL 8 DAY,1347.00),
(5,CURDATE()-INTERVAL 20 DAY,1299.00);

-- insert 5 record in orderdetails table
INSERT into orderDetails(order_id,product_id,quantity,subtotal)VALUES
(1,1,1,599.00),
(1,2,1,1399.00),
(2,3,2,1998.00),
(3,4,2,1347.00),
(4,1,2,1198.00),
(5,3,1,999.00);

-- all customers queries
-- read all records 
SELECT *FROM customers;

-- update record
UPDATE customers
set address='jamnagar'
WHERE customer_id=3;

-- delete specific record
DELETE from customers WHERE customer_id=4;

-- specific whose name is khushi
SELECT *FROM customers WHERE name='khushi';

-- all the order query
-- read all records
SELECT *FROM orders;

-- retrive specific number
SELECT *FROM orders WHERE customer_id=1;

-- update total amount
UPDATE orders
SET totalamount=(SELECT IFNULL(SUM(SubTotal),0) FROM orderDetails WHERE orderDetails.order_id=orders.order_id)
WHERE order_id=4;

-- delete orderid
DELETE FROM orders WHERE order_id=3;

-- retrive order placed in last 30 days
SELECT *FROM orders
WHERE orderdate>=CURDATE()-INTERVAL 30 DAY;

-- highest,lowest and average order
SELECT 
	MAX(totalamount) AS highestorder,
    MIN(totalamount) AS lowestorder,
    AVG(totalamount) AS averageorder
FROM orders;

-- all queries of product table
-- sorted price in descending order
SELECT *FROM products ORDER BY price DESC;

-- update the specific price of product 
UPDATE products SET price=549.00 WHERE product_id=4;

-- delete product if out of stock
DELETE FROM products WHERE product_id=3 AND stock=0;

-- retrive product whose price is in between 600 and 1500
SELECT *FROM products WHERE price BETWEEN 600 AND 1500;

-- cheapest price
SELECT productname,price FROM products WHERE price=(SELECT MIN(price) FROM products);

-- most expensive price
SELECT productname,price FROM products WHERE price=(SELECT MAX(price) FROM products);

-- all queries  are orderdetails
-- specific order
SELECT od.*,p.productname,p.price
FROM orderDetails od
LEFT JOIN products p ON od.product_id=p.product_id
WHERE od.order_id=1;

-- use of sum
SELECT SUM(SubTotal) AS TotalRevenue FROM orderDetails;

-- retrive top most 3 product
SELECT od.product_id,p.productname,SUM(od.quantity) AS totalquantitySold
FROM orderDetails od
JOIN products p ON od.product_id=p.product_id
GROUP BY totalquantitySold DESC
LIMIT 2;


-- using count()
SELECT COUNT(*) AS TimesAppearedInOrderDetails
FROM orderDetails
WHERE product_id=3;

-- if total units sold(sum of quantities) use SUM()
SELECT SUM(quantity) AS TotalUnitsSold FROM orderDetails WHERE product_id=1;



