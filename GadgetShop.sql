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
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL
);
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);
CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    QuantityInStock INT NOT NULL CHECK (QuantityInStock >= 0),
    LastStockUpdate DATE NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);
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

INSERT INTO Products (ProductName, Description, Price) VALUES
('Smartphone', 'Latest Android smartphone', 699.99),
('Laptop', '15-inch gaming laptop', 1299.49),
('Tablet', '10-inch display tablet', 399.99),
('Smartwatch', 'Water-resistant smartwatch', 199.99),
('Bluetooth Speaker', 'Portable speaker', 99.99),
('Headphones', 'Noise-cancelling headphones', 149.99),
('Gaming Console', 'Next-gen gaming console', 499.99),
('Wireless Mouse', 'Ergonomic wireless mouse', 29.99),
('Keyboard', 'Mechanical keyboard', 79.99),
('Monitor', '27-inch 4K monitor', 299.99);


INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2024-01-01', 999.99),
(2, '2024-01-05', 699.99),
(3, '2024-02-10', 1299.49),
(4, '2024-02-12', 1499.99),
(5, '2024-04-15', 399.99),
(6, '2025-02-18', 499.99),
(7, '2025-01-20', 799.99),
(8, '2024-05-22', 299.99),
(9, '2024-08-24', 399.99),
(10, '2024-11-26', 599.99);


INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 5),
(4, 4, 1),
(5, 5, 3),
(6, 6, 1),
(7, 7, 7),
(8, 8, 6),
(9, 9, 2),
(10, 10, 8);

INSERT INTO Inventory (ProductID, QuantityInStock, LastStockUpdate) VALUES
(1, 50, '2024-08-30'),
(2, 30, '2024-03-29'),
(3, 40, '2024-01-28'),
(4, 25, '2024-06-27'),
(5, 60, '2025-01-26'),
(6, 35, '2025-02-25'),
(7, 20, '2025-01-24'),
(8, 45, '2024-11-23'),
(9, 55, '2024-09-22'),
(10, 15, '2025-03-21');



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
VALUES (3, '2025-02-12', 499.99);


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
WHERE OrderDate BETWEEN '2024-01-01' AND '2025-03-30';


SELECT c.CustomerID, c.FirstName, c.LastName, c.Email
FROM Customers c
WHERE c.CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

SELECT (SELECT COUNT(*) FROM Products) AS TotalProducts;

SELECT (SELECT SUM(TotalAmount) FROM Orders) AS TotalRevenue;

SELECT AVG(od.Quantity) AS AvgQuantity
FROM OrderDetails od
JOIN (
    SELECT ProductID FROM Products 
    WHERE ProductName LIKE CONCAT('%', 'laptop', '%')
) p ON od.ProductID = p.ProductID;


SELECT (SELECT SUM(TotalAmount) FROM Orders WHERE CustomerID = 3) AS TotalRevenue;



SELECT c.FirstName, c.LastName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
HAVING OrderCount = (
    SELECT MAX(OrderCounts) FROM (
        SELECT COUNT(OrderID) AS OrderCounts FROM Orders GROUP BY CustomerID
    ) AS Sub
);

SELECT ProductName, TotalQuantity
FROM (
    SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantity
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY p.ProductName
) AS sub
ORDER BY TotalQuantity DESC
LIMIT 1;



SELECT c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
HAVING TotalSpent = (
    SELECT MAX(TotalSum) FROM (
        SELECT SUM(TotalAmount) AS TotalSum FROM Orders GROUP BY CustomerID
    ) AS Sub
);

SELECT 
    (SELECT SUM(TotalAmount) FROM Orders) / 
    (SELECT COUNT(*) FROM Orders) AS AvgOrderValue;

SELECT c.FirstName, c.LastName, Sub.OrderCount
FROM Customers c
JOIN (
    SELECT CustomerID, COUNT(OrderID) AS OrderCount
    FROM Orders
    GROUP BY CustomerID
) AS Sub ON c.CustomerID = Sub.CustomerID;


