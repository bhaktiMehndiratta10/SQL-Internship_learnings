/*

The Star Schema is a type of data warehouse schema that is the simplest style of data mart schema.
It consists of one central fact table (big, transactional, quantitative data) and multiple surrounding dimension tables (descriptive, textual data).
The design is called "star" because the diagram looks like a star: the fact table in the center and dimension tables radiating outward.
It is optimized for querying and reporting.


Core Components:
1. Fact Table       → Stores measurements, metrics, and facts about a business process.
2. Dimension Table  → Stores descriptive attributes related to dimensions of the facts.

*/


IF OBJECT_ID('dbo.FactSales', 'U') IS NOT NULL DROP TABLE dbo.FactSales;
IF OBJECT_ID('dbo.DimDate', 'U') IS NOT NULL DROP TABLE dbo.DimDate;
IF OBJECT_ID('dbo.DimProduct', 'U') IS NOT NULL DROP TABLE dbo.DimProduct;
IF OBJECT_ID('dbo.DimCustomer', 'U') IS NOT NULL DROP TABLE dbo.DimCustomer;
IF OBJECT_ID('dbo.DimStore', 'U') IS NOT NULL DROP TABLE dbo.DimStore;


-- Date Dimension: Describes the date of each sale
CREATE TABLE dbo.DimDate (
    DateKey INT PRIMARY KEY,           
    FullDate DATE,
    DayName NVARCHAR(20),
    MonthName NVARCHAR(20),
    Quarter INT,
    Year INT
);

-- Product Dimension: Describes products
CREATE TABLE dbo.DimProduct (
    ProductKey INT PRIMARY KEY,         
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Brand NVARCHAR(50)
);

-- Customer Dimension: Describes customers
CREATE TABLE dbo.DimCustomer (
    CustomerKey INT PRIMARY KEY,        
    CustomerName NVARCHAR(100),
    Gender CHAR(1),
    City NVARCHAR(50)
);

-- Store Dimension: Describes store locations
CREATE TABLE dbo.DimStore (
    StoreKey INT PRIMARY KEY,           
    StoreName NVARCHAR(100),
    Region NVARCHAR(50)
);

-- Sales Fact Table: Stores measures (Quantity & Amount) and foreign keys to dimension tables
CREATE TABLE dbo.FactSales (
    SalesKey INT PRIMARY KEY IDENTITY(1,1),
    DateKey INT FOREIGN KEY REFERENCES dbo.DimDate(DateKey),
    ProductKey INT FOREIGN KEY REFERENCES dbo.DimProduct(ProductKey),
    CustomerKey INT FOREIGN KEY REFERENCES dbo.DimCustomer(CustomerKey),
    StoreKey INT FOREIGN KEY REFERENCES dbo.DimStore(StoreKey),
    QuantitySold INT,
    SalesAmount DECIMAL(10,2)
);


INSERT INTO dbo.DimDate VALUES (20250101, '2025-01-01', 'Wednesday', 'January', 1, 2025);
INSERT INTO dbo.DimDate VALUES (20250102, '2025-01-02', 'Thursday',  'January', 1, 2025);


INSERT INTO dbo.DimProduct VALUES (1, 'Cotton T-Shirt', 'Apparel', 'BrandX');
INSERT INTO dbo.DimProduct VALUES (2, 'Running Shoes', 'Footwear', 'BrandY');


INSERT INTO dbo.DimCustomer VALUES (101, 'Alice Smith', 'F', 'New York');
INSERT INTO dbo.DimCustomer VALUES (102, 'Bob Lee', 'M', 'Chicago');


INSERT INTO dbo.DimStore VALUES (201, 'Downtown Store', 'East');
INSERT INTO dbo.DimStore VALUES (202, 'Mall Outlet', 'West');


INSERT INTO dbo.FactSales (DateKey, ProductKey, CustomerKey, StoreKey, QuantitySold, SalesAmount)
VALUES 
(20250101, 1, 101, 201, 2, 39.98),
(20250102, 2, 102, 202, 1, 59.99);


SELECT 
    d.MonthName,
    p.Category,
    SUM(f.SalesAmount) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimDate d       ON f.DateKey = d.DateKey
JOIN dbo.DimProduct p    ON f.ProductKey = p.ProductKey
GROUP BY d.MonthName, p.Category
ORDER BY d.MonthName, p.Category;
