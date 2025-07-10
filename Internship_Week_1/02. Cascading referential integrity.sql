/*
USE CASE: Construction Fleet Management System

  REFERENTIAL INTEGRITY ensures that a foreign key value in a child table
  must always refer to an existing primary key in a parent table.
  For example: If Equipment.CustomerID = 2, then Customers.CustomerID = 2 must exist.

  CASCADING REFERENTIAL INTEGRITY  automatically updates or deletes related rows in a child table when changes occur in the parent table.

  SYNTAX:
  FOREIGN KEY (column) REFERENCES parent_table(primary_key)
      ON DELETE CASCADE
      ON UPDATE CASCADE

  1.  ON DELETE CASCADE:
      If a row in the parent table is deleted, the related rows in the child
      table are automatically deleted. No error is thrown. (Think: "Take the kids down with the parent.")

  2.  ON UPDATE CASCADE:
      If the primary key value in the parent table is updated,
      then all foreign key references in the child table are updated automatically.

  BENEFIT : 
      - Ensures data consistency
      - Prevents "orphaned rows" (child records without a parent)
      - Reduces manual work writing triggers or separate queries
*/


DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += 'ALTER TABLE [' + OBJECT_NAME(f.parent_object_id) + '] DROP CONSTRAINT [' + f.name + '];' + CHAR(13)
FROM sys.foreign_keys f
WHERE f.referenced_object_id = OBJECT_ID('dbo.Customers');

 --Execute all ALTER TABLE DROP CONSTRAINT commands
EXEC sp_executesql @sql;


IF OBJECT_ID('dbo.Equipment', 'U') IS NOT NULL
    DROP TABLE dbo.Equipment;

IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL
    DROP TABLE dbo.Customers;


CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Country VARCHAR(50)
);

CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY,
    EquipmentName VARCHAR(100),
    PurchaseDate DATE,
    CustomerID INT,

    CONSTRAINT FK_Equipment_Customers FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);



INSERT INTO Customers VALUES (1, 'ABC Construction', 'India');
INSERT INTO Customers VALUES (2, 'MegaBuild Corp', 'USA');

INSERT INTO Equipment VALUES 
(101, 'Excavator', '2023-01-10', 1),
(102, 'Crane', '2023-03-15', 2);


 --ON UPDATE CASCADE
UPDATE Customers
SET CustomerID = 10
WHERE CustomerID = 1;

 --ON DELETE CASCADE
DELETE FROM Customers WHERE CustomerID = 2;

SELECT * FROM Equipment;
