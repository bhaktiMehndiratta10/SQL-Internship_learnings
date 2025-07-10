/*

Normalization is the process of organizing data in a database to:
    - Reduce data redundancy (duplicate data)
    - Ensure data integrity
    - Make data easier to maintain


Normalization proceeds in steps called *Normal Forms*:
    - 1NF (First Normal Form): Remove repeating groups / ensure atomic values
    - 2NF (Second Normal Form): Remove partial dependencies (must first be in 1NF)
    - 3NF (Third Normal Form): Remove transitive dependencies (must first be in 2NF)

  Beyond 3NF there are BCNF, 4NF, etc., but 3NF is most common in practice.

*/



CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1), 
    CustomerName NVARCHAR(100) NOT NULL,
    CustomerAddress NVARCHAR(200)
);


CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);



INSERT INTO Customers (CustomerName, CustomerAddress)
VALUES ('Alice Johnson', '123 Elm Street'),
       ('Bob Smith', '456 Oak Avenue');


INSERT INTO Products (ProductName, UnitPrice)
VALUES ('Laptop', 750.00),
       ('Mouse', 25.00),
       ('Keyboard', 45.00);


INSERT INTO Orders (CustomerID, OrderDate)
VALUES (1, '2025-07-10'),  
       (2, '2025-07-11');  


INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES (1, 1, 1),  
       (1, 2, 2),  
       (2, 3, 1);   


SELECT 
    o.OrderID,
    c.CustomerName,
    c.CustomerAddress,
    p.ProductName,
    p.UnitPrice,
    od.Quantity,
    (p.UnitPrice * od.Quantity) AS TotalPrice,
    o.OrderDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;


