/*
  STORED PROCEDURE WITH ERROR HANDLING + TRANSACTION


   Goal: Safely update customer's city based on customer name
           Return a success/failure message and old city name
           All inside a TRY...CATCH block with TRANSACTION control


   KEY CONCEPTS:
  1. TRY...CATCH: To handle runtime errors gracefully.
  2. OUTPUT Params: To return values back to caller.
  3. TRANSACTION: Ensures UPDATE is committed only if no error.
  4. ROLLBACK: Prevents partial changes in case of error.
*/



DROP TABLE IF EXISTS Accounts;
DROP PROCEDURE IF EXISTS TransferAmount;
GO


CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    AccountName NVARCHAR(100),
    Balance DECIMAL(10, 2)
);
GO


INSERT INTO Accounts VALUES (1, 'Alice', 5000.00);
INSERT INTO Accounts VALUES (2, 'Bob', 3000.00);
GO



 -- This procedure transfers amount from one account to another.
 -- Includes transaction and error handling.

CREATE PROCEDURE TransferAmount
    @FromAccountID INT,
    @ToAccountID INT,
    @Amount DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRY
         -- Start the transaction
        BEGIN TRANSACTION;

         -- Deduct from sender
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccountID;

         -- Add to receiver
        UPDATE Accounts
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccountID;

         -- Commit if everything is okay
        COMMIT;
        PRINT 'Transaction Successful!';
    END TRY
    BEGIN CATCH
         -- Rollback if there's any error
        ROLLBACK;

        --  Print error message
        PRINT 'Error occurred during transfer.';
        PRINT ERROR_MESSAGE();  --  Shows the exact error
    END CATCH
END;
GO


 -- Example: Transfer ₹1000 from Alice (1) to Bob (2)

EXEC TransferAmount @FromAccountID = 1, @ToAccountID = 2, @Amount = 1000.00;


SELECT * FROM Accounts;
