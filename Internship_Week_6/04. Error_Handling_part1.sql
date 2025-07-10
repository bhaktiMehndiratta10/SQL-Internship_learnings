/*

Technique to detect, respond to, and manage unexpected runtime errors.
Prevents data corruption, incomplete transactions, and confusing outputs.


MAIN TOOLS IN SQL SERVER:
 
 1. @@ERROR: Legacy, statement-level; must check immediately after the statement.
 2. TRY...CATCH: Block-level, cleaner, supports logging & rollback.
 3. ERROR_*() functions: Inside CATCH, get details (number, message, severity, procedure).
 4. THROW: Re-throws error to propagate to caller; keeps original details.
 5. XACT_STATE(): Checks transaction state (commit/rollback) in complex scenarios.

 
 
 TYPICAL PATTERNS:
 1. Validate input → BEGIN TRAN → TRY block → CATCH block → log error + rollback → THROW or handle gracefully.
 2. Store logs in an error table for auditing.

 
BETTER THAN @@ERROR:
1. @@ERROR is limited and can't stop SQL from printing system errors
2. TRY...CATCH is cleaner: it lets us catch errors and handle them


*/

IF OBJECT_ID('DemoProducts', 'U') IS NOT NULL
    DROP TABLE DemoProducts;

CREATE TABLE DemoProducts (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50)
);

-- Inserted first product (expected to succeed)
BEGIN TRY
    INSERT INTO DemoProducts (ProductID, ProductName)
    VALUES (1, 'Laptop');
    PRINT 'Inserted Laptop successfully';
END TRY
BEGIN CATCH
    PRINT 'Error inserting Laptop: ' + ERROR_MESSAGE();
END CATCH

-- Inserted duplicate ProductID (caught cleanly)
BEGIN TRY
    INSERT INTO DemoProducts (ProductID, ProductName)
    VALUES (1, 'Tablet');  -- duplicate key
    PRINT 'Inserted Tablet successfully';
END TRY
BEGIN CATCH
    PRINT 'Duplicate ProductID error while inserting Tablet (caught)';
END CATCH

