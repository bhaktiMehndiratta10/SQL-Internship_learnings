  /*
  Mathematical functions are built-in scalar functions in SQL Server
  that perform operations on numeric data types and return a single value.
  These are often used for calculations, rounding, absolute value, trigonometry, etc.

  Common Mathematical Functions:
  1. ABS(number)          → Absolute value
  2. CEILING(number)      → Rounds up to nearest integer
  3. FLOOR(number)        → Rounds down to nearest integer
  4. POWER(base, exp)     → Exponentiation (base^exp)
  5. ROUND(number, d)     → Rounds number to d decimal places
  6. SQRT(number)         → Square root
  7. PI()                 → Returns value of π
  8. SQUARE(number)       → Squares the number (x^2)
  9. RAND()               → Random float between 0 and 1
  10. EXP(number)         → Exponential value of e^number
  */


IF OBJECT_ID('dbo.ProductStats', 'U') IS NOT NULL
    DROP TABLE dbo.ProductStats;

CREATE TABLE ProductStats (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10, 2),
    DiscountRate FLOAT   
);


INSERT INTO ProductStats (ProductID, ProductName, Price, DiscountRate)
VALUES 
(1, 'Drill Machine', 2549.75, 10.0),
(2, 'Bulldozer Oil', 449.49, 5.0),
(3, 'Hydraulic Pump', 12299.95, 12.5),
(4, 'Sensor Unit', 3599.99, 0.0),
(5, 'Excavator Bucket', -1899.00, 7.5);    



SELECT 
    ProductID,
    ProductName,
    Price,
    ABS(Price) AS AbsolutePrice,                               --Removes negative sign
    FLOOR(Price) AS PriceRoundedDown,                          --Rounds down
    CEILING(Price) AS PriceRoundedUp,                          --Rounds up
    ROUND(Price, 0) AS PriceRoundedToNearest,                  --Rounds to nearest integer
    SQUARE(DiscountRate) AS DiscountSquare,                    --Square of discount
    POWER(Price, 2) AS PriceSquared,                           --Price^2
    SQRT(ABS(Price)) AS PriceSquareRoot,                       --Square root of price (abs to avoid negative root)
    PI() AS PiValue,                                           --Constant value of π
    RAND(CHECKSUM(NEWID())) AS RandomFactor,                   --Random number (deterministic per row)
    EXP(1) AS ExponentialE,                                    --e^1 (natural exponent)
    ROUND(Price - (Price * DiscountRate / 100.0), 2) AS FinalPriceAfterDiscount   --Final discounted price
FROM 
    ProductStats;
