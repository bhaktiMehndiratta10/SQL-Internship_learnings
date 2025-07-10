/*
  CAST() and CONVERT() Functions 

  These functions are used for **data type conversion** in SQL.
  Both are part of the **Data Type Conversion** category of functions.
  CAST() is ANSI-SQL standard compliant.
  CONVERT() is SQL Server-specific and allows more formatting styles.
  */


IF OBJECT_ID('dbo.Transactions', 'U') IS NOT NULL
    DROP TABLE dbo.Transactions;

CREATE TABLE dbo.Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    TransactionAmount VARCHAR(50),     --stored as VARCHAR (not ideal)
    TransactionDate DATETIME
);


INSERT INTO dbo.Transactions (CustomerName, TransactionAmount, TransactionDate)
VALUES
('Amit Sharma', '1500.75', '2025-07-07 10:30:00'),
('Priya Desai', '3200.00', '2025-06-25 09:00:00'),
('Rahul Nair',  '875.5',   '2025-05-15 14:45:00');



  -- Using CAST() and CONVERT()
  -- Convert VARCHAR to DECIMAL using CAST
SELECT 
    CustomerName,
    TransactionAmount AS OriginalAmount,
    CAST(TransactionAmount AS DECIMAL(10,2)) AS Amount_Cast,
    TransactionDate
FROM dbo.Transactions;

  
  
  --Convert VARCHAR to DECIMAL using CONVERT
SELECT 
    CustomerName,
    TransactionAmount AS OriginalAmount,
    CONVERT(DECIMAL(10,2), TransactionAmount) AS Amount_Convert,
    TransactionDate
FROM dbo.Transactions;

  
  --Convert DATETIME to VARCHAR using CAST
SELECT 
    TransactionID,
    CAST(TransactionDate AS VARCHAR(20)) AS Cast_Date
FROM dbo.Transactions;

  
  
  --Convert DATETIME to VARCHAR using CONVERT (with style code)
SELECT 
    TransactionID,
    CONVERT(VARCHAR(20), TransactionDate, 103) AS Convert_Date_DDMMYYYY,   --Style 103 = dd/mm/yyyy
    CONVERT(VARCHAR(20), TransactionDate, 120) AS Convert_Date_ISO8601     --Style 120 = yyyy-mm-dd hh:mi:ss
FROM dbo.Transactions;


 DROP TABLE dbo.Transactions;
