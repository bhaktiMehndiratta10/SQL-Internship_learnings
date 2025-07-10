/*
  Best Practices:
  1. Use VARCHAR(MAX) instead of TEXT, and VARBINARY(MAX) instead of IMAGE
  2. BIT is great for boolean logic, defaulting to 0/1
  3. NVARCHAR is required for emojis, multilingual text
  4. Use GUIDs with UNIQUEIDENTIFIER for globally unique keys
  5. Use computed columns (like FullName) for expressions without storage cost
  6. Always define appropriate data types to avoid storage waste or data loss
  7. DATE/TIME types have different precision levels, use DATETIME2 for modern apps
*/

IF OBJECT_ID('dbo.DataTypeDemo', 'U') IS NOT NULL
    DROP TABLE dbo.DataTypeDemo;

CREATE TABLE DataTypeDemo (
    -- Integer Types
    TinyIntCol       TINYINT,                        -- 1 byte, unsigned (0-255)
    SmallIntCol      SMALLINT,                       -- 2 bytes (-32,768 to 32,767)
    IntCol           INT IDENTITY(1,1) PRIMARY KEY,  -- 4 bytes, auto-increment
    BigIntCol        BIGINT,                         -- 8 bytes

    -- Decimal Types (Exact Precision)
    DecimalCol       DECIMAL(10,2),                  -- Precision: 10, Scale: 2 (e.g., 12345678.90)
    NumericCol       NUMERIC(8,3),                   -- Alias for DECIMAL (Max: 99999.999)
    MoneyCol         MONEY,                          -- Fixed currency format, ~4 decimal places
    SmallMoneyCol    SMALLMONEY,                     -- Smaller currency type (±214,748.3647)

    -- Floating Point (Approximate)
    FloatCol         FLOAT(24),                      -- Approx. 7 digits precision
    RealCol          REAL,                           -- Synonym for FLOAT(24)

    -- String Types
    CharCol          CHAR(10) NOT NULL DEFAULT 'N/A',-- Fixed-length, padded with spaces
    VarCharCol       VARCHAR(50) NOT NULL,           -- Variable-length non-Unicode
    NCharCol         NCHAR(10),                      -- Fixed-length Unicode (2 bytes/char)
    NVarCharCol      NVARCHAR(50),                   -- Variable-length Unicode
    LargeTextCol     VARCHAR(MAX),                   -- Modern replacement for TEXT

    -- Date/Time Types
    DateCol          DATE,                           -- Only date (YYYY-MM-DD)
    TimeCol          TIME,                           -- Only time (hh:mm:ss)
    DateTimeCol      DATETIME,                       -- Legacy datetime (accurate to ~3ms)
    SmallDateTimeCol SMALLDATETIME,                  -- Less precise datetime (to the minute)
    DateTime2Col     DATETIME2(3),                   -- Modern datetime with precision to milliseconds

    -- Binary Types
    BinaryCol        BINARY(5),                      -- Fixed-length binary (e.g., byte[5])
    VarBinaryCol     VARBINARY(50),                  -- Variable-length binary
    LargeBinaryCol   VARBINARY(MAX),                 -- Modern replacement for IMAGE

    -- Other Types
    BitCol           BIT DEFAULT 0,                  -- Boolean: 0, 1, or NULL
    UniqueIDCol      UNIQUEIDENTIFIER DEFAULT NEWID(),-- Globally unique identifier (GUID)
    XmlCol           XML,                            -- XML-typed column
    JsonCol          NVARCHAR(MAX),                  -- JSON (no native type, use NVARCHAR)

    -- Computed Column Example
    FullName         AS (CharCol + '-' + VarCharCol) -- Expression-based column (read-only)
);

-- Insert sample data
INSERT INTO DataTypeDemo (
    TinyIntCol, SmallIntCol, BigIntCol,
    DecimalCol, NumericCol, MoneyCol, SmallMoneyCol,
    FloatCol, RealCol,
    CharCol, VarCharCol, NCharCol, NVarCharCol,
    LargeTextCol,
    DateCol, TimeCol, DateTimeCol, SmallDateTimeCol, DateTime2Col,
    BinaryCol, VarBinaryCol, LargeBinaryCol,
    BitCol, UniqueIDCol, XmlCol, JsonCol
)
VALUES (
    200, -30000, 9876543210123,
    12500.75, 5432.123, 9999.99, 250.25,
    123.456, 654.321,
    'FixedChar', 'Variable Text', N'NCharVal', N'NVar💡Text',
    'This is a long VARCHAR(MAX) text.',
    '2025-07-05', '16:45:00', GETDATE(), GETDATE(), SYSDATETIME(),
    0x1122334455, 
    CONVERT(VARBINARY(50), 'SomeBinary'), 
    CONVERT(VARBINARY(MAX), REPLICATE(CAST('A' AS VARCHAR(MAX)), 100)),
    1, NEWID(), 
    '<root><value>Example</value></root>', 
    N'{ "name": "ChatGPT", "version": 4 }'
);


SELECT * FROM DataTypeDemo;
