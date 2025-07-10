/*
   1. DDL – DATA DEFINITION LANGUAGE

   Used to define the structure of the database (tables, columns, indexes).
   Common commands: CREATE, ALTER, DROP, TRUNCATE.
   Constraints (CHECK, DEFAULT, NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, etc.)
   are defined using DDL and enforced during DML operations.
*/

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    CONSTRAINT CK_Customers_Email CHECK (Email LIKE '%@%.%')
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1000,1),
    CustomerID INT NOT NULL,
    OrderAmount DECIMAL(10,2) CHECK (OrderAmount >= 0),
    OrderDate DATE DEFAULT CAST(GETDATE() AS DATE),
    Status VARCHAR(20) DEFAULT 'PENDING',
    CONSTRAINT CK_Status CHECK (Status IN ('PENDING', 'SHIPPED', 'CANCELLED')),
    CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


/*
   2. DML – DATA MANIPULATION LANGUAGE

   Used to manipulate data in tables (INSERT, UPDATE, DELETE, MERGE).
   Changes the actual data stored in the database.
*/
INSERT INTO Customers (CustomerName, Email)
VALUES
    ('Alice Johnson', 'alice@example.com'),
    ('Bob Smith', 'bob@example.com');

-- Insert orders
INSERT INTO Orders (CustomerID, OrderAmount, Status)
VALUES
    (1, 2500.00, 'PENDING'),
    (2, 1800.50, 'SHIPPED');

-- Update a record
UPDATE Customers
SET IsActive = 0
WHERE CustomerID = 2;

-- Delete orders (none deleted here)
DELETE FROM Orders
WHERE Status = 'CANCELLED';

-- MERGE (upsert) - add/update Charlie Rose
MERGE INTO Customers AS Target
USING (SELECT 'Charlie Rose' AS CustomerName, 'charlie@example.com' AS Email) AS Source
ON Target.Email = Source.Email
WHEN MATCHED THEN
    UPDATE SET CustomerName = Source.CustomerName
WHEN NOT MATCHED THEN
    INSERT (CustomerName, Email)
    VALUES (Source.CustomerName, Source.Email);


/*
   3. DQL – DATA QUERY LANGUAGE

   Used to retrieve data from the database (SELECT).
   Doesn't modify data — just reads it.
*/

SELECT 
    C.CustomerName,
    O.OrderID,
    O.OrderAmount,
    O.OrderDate,
    O.Status
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
ORDER BY O.OrderDate DESC;

-- Aggregation: total spent per customer
SELECT
    C.CustomerName,
    COUNT(O.OrderID) AS NumOrders,
    SUM(O.OrderAmount) AS TotalSpent
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerName
HAVING SUM(O.OrderAmount) > 1000;

/*
   4. DCL – DATA CONTROL LANGUAGE

   Used to control access and permissions to database objects.
   Common commands: GRANT, REVOKE.
   Require elevated privileges and are typically executed by DBAs.
*/

-- Note: Ensure [SomeUser] exists before executing or replace with a real username
-- GRANT SELECT ON Customers TO SomeUser;		   -- Gives read access
-- REVOKE SELECT ON Customers FROM SomeUser;     -- Takes away read access


/*
   5. TCL – TRANSACTION CONTROL LANGUAGE

   Used to manage transactions (BEGIN TRAN, COMMIT, ROLLBACK, SAVEPOINT).
   Ensures ACID properties: Atomicity, Consistency, Isolation, Durability.
*/

BEGIN TRY
    BEGIN TRAN;

    -- This will fail due to CHECK constraint (negative amount)
    INSERT INTO Orders (CustomerID, OrderAmount, Status)
    VALUES (1, -500.00, 'PENDING');

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Transaction failed: ' + ERROR_MESSAGE();
END CATCH;

SELECT * FROM Customers;
SELECT * FROM Orders;
