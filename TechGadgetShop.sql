CREATE DATABASE TechGadgetShop;
USE TechGadgetShop;
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Address TEXT NOT NULL
);
Select * from customers;
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL
);
Select * from Products;

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);
Select * from Orders;

CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);
Select * from OrderDetails;

CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    QuantityInStock INT NOT NULL CHECK (QuantityInStock >= 0),
    LastStockUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);
Select * from inventory;

INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES
('Steve', 'John', 'steve.john@email.com', '9876543210', '123 Main St, NY'),
('Mark', 'Smith', 'mark.smith@email.com', '9876543211', '456 Last St, LA'),
('Kelly', 'Brown', 'kelly.brown@email.com', '9876543212', '789 Pine St, SF'),
('Mohamad', 'Sherif', 'sherif.m345@email.com', '9876543213', '101 Broadway St, TX'),
('David', 'Raj', 'david.rr45@email.com', '9876543214', '202 Paris St, FL'),
('David', 'Wilson', 'david.wilson@email.com', '9876543215', '303 Birch St, NV'),
('Emma', 'Watson', 'emma.wat6070@email.com', '9876543216', '404 Cedar St, IL'),
('Joseph', 'Vijay', 'jos.vj123@email.com', '9876543217', '505 Panayur St, CH'),
('Joyshy', 'Grace', 'grace.Joy@email.com', '9876543218', '606 New St, WA'),
('Mark', 'Henry', 'henry.walker@email.com', '9876543219', '707 Apple St, CO');
Select * from customers;

INSERT INTO Products (ProductName, Description, Price) VALUES
('Smartphone', 'Latest 5G smartphone', 699.99),
('Laptop', '15-inch gaming laptop', 1299.99),
('Tablet', '10-inch Android tablet', 399.99),
('Smartwatch', 'Fitness tracking smartwatch', 199.99),
('Headphones', 'Noise-canceling headphones', 149.99),
('Gaming Console', 'Next-gen gaming console', 499.99),
('Bluetooth Speaker', 'Portable Bluetooth speaker', 89.99),
('Camera', '4K digital camera', 799.99),
('Hard Disk', '2TB external HDD', 99.99),
('Monitor', '27-inch 4K monitor', 349.99);
Select * from Products;

INSERT INTO Orders (CustomerID, TotalAmount) VALUES
(1, 699.99),
(2, 1299.99),
(3, 399.99),
(4, 199.99),
(5, 149.99),
(6, 499.99),
(7, 89.99),
(8, 799.99),
(9, 99.99),
(10, 349.99);
Select * from Orders;

INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 2),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 2),
(10, 10, 1);
Select * from OrderDetails;

INSERT INTO Inventory (ProductID, QuantityInStock) VALUES
(1, 50),
(2, 30),
(3, 40),
(4, 20),
(5, 25),
(6, 15),
(7, 35),
(8, 10),
(9, 60),
(10, 28);
Select * from inventory;

SELECT FirstName, LastName, Email FROM Customers;

SELECT Orders.OrderID, Orders.OrderDate, Customers.FirstName, Customers.LastName 
FROM Orders 
JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) 
VALUES ('Sunil', 'Roa', 'sunil.roa@email.com', '9876543220', '1725 5th Ave, London');

ALTER TABLE Products MODIFY COLUMN Price DECIMAL(10,2);

SET SQL_SAFE_UPDATES = 0;

UPDATE Products 
SET Price = ROUND(Price * 1.10, 2)
WHERE EXISTS (SELECT 1 FROM (SELECT ProductID FROM Products) AS tmp WHERE tmp.ProductID = Products.ProductID);

DELETE FROM OrderDetails WHERE OrderID = 5;
DELETE FROM Orders WHERE OrderID = 5;

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) 
VALUES (3, NOW(), 499.99);

UPDATE Customers 
SET Email = 'henry.mark@gmail.com', Address = '706 kads St, NY'
WHERE CustomerID = 10;

UPDATE Orders o
SET o.TotalAmount = (
    SELECT IFNULL(SUM(od.Quantity * p.Price), 0)
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    WHERE od.OrderID = o.OrderID
);

DELETE FROM OrderDetails WHERE OrderID IN (SELECT OrderID FROM Orders WHERE CustomerID = 10);
DELETE FROM Orders WHERE CustomerID = 10;

INSERT INTO Products (ProductName, Description, Price) 
VALUES ('Power Bank', '20,000 mah Battery', 738.99);

ALTER TABLE Orders ADD COLUMN Status VARCHAR(20) DEFAULT 'Pending';  

UPDATE Orders 
SET Status = 'Shipped'
WHERE OrderID = 9;

ALTER TABLE Customers ADD COLUMN OrderCount INT DEFAULT 0; 

UPDATE Customers c
SET OrderCount = (
    SELECT COUNT(*) 
    FROM Orders o 
    WHERE o.CustomerID = c.CustomerID
);

SELECT CustomerID, CONCAT(FirstName, ' ', LastName) AS CustomerName, OrderCount FROM Customers;

USE TechShop;

SELECT o.OrderID, o.OrderDate, c.FirstName, c.LastName, c.Email, c.Phone 
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

SELECT p.ProductName, SUM(od.Quantity * p.Price) AS TotalRevenue 
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName;

SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName, c.Email, c.Phone, c.Address
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantityOrdered
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalQuantityOrdered DESC
LIMIT 1;

SELECT ProductName, Description FROM Products;

SELECT c.CustomerID, c.FirstName, c.LastName, AVG(o.TotalAmount) AS AvgOrderValue
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;

SELECT o.OrderID, c.FirstName, c.LastName, c.Email, o.TotalAmount 
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.TotalAmount DESC
LIMIT 1;

SELECT p.ProductName, COUNT(od.OrderDetailID) AS TimesOrdered
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TimesOrdered DESC;

SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName, c.Email, c.Phone 
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Laptop';

SELECT SUM(TotalAmount) AS TotalRevenue 
FROM Orders 
WHERE OrderDate BETWEEN '2025-03-01' AND '2025-09-30';

USE TechShop;

SELECT c.CustomerID, c.FirstName, c.LastName, c.Email
FROM Customers c
WHERE c.CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

SELECT COUNT(*) AS TotalProduct FROM Products;

SELECT SUM(TotalAmount) AS TotalRevenue FROM Orders;

SELECT AVG(od.Quantity) AS AvgQuantityOrdered
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.Productname = 'Laptop';

SELECT SUM(o.TotalAmount) AS TotalRevenue
FROM Orders o
WHERE o.CustomerID = 3;

USE TechShop;

SELECT c.CustomerID, c.FirstName, c.Lastname, COUNT(o.OrderID) AS TotalOders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalOders DESC
LIMIT 1;

SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantityOrdered
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalQuantityOrdered DESC
LIMIT 3;

SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSpent DESC
LIMIT 1;

SELECT AVG(TotalAmount) AS AvgOrderValue FROM Orders;

SELECT c.CustomerID, c.FirstName, c.LastName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY OrderCount DESC;

