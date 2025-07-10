/*
  A CHECK constraint ensures that the value in a column meets a specific condition.
  It prevents invalid data from being inserted into the table.
  Syntax:
      CONSTRAINT constraint_name CHECK (condition)

  Multiple CHECK constraints can exist on the same table.
  They only restrict DML (INSERT, UPDATE), not SELECT.
*/
IF OBJECT_ID('dbo.EquipmentLogs', 'U') IS NULL
BEGIN
    CREATE TABLE EquipmentLogs (
        LogID INT IDENTITY PRIMARY KEY,
        MachineID INT NOT NULL, 
        FuelLevelPercent INT CHECK (FuelLevelPercent BETWEEN 0 AND 100), 
        
        EngineTemp DECIMAL(5,2), 
        CONSTRAINT chk_EngineTemp CHECK (EngineTemp >= -40 AND EngineTemp <= 150),
        
        OperatorRating INT,
        CONSTRAINT chk_OperatorRating CHECK (OperatorRating IN (1, 2, 3, 4, 5)),
        
        OperationMode VARCHAR(20),
        CONSTRAINT chk_OperationMode CHECK (OperationMode IN ('AUTO', 'MANUAL', 'REMOTE')),
        
        CONSTRAINT chk_RemoteRating CHECK (
            OperationMode <> 'REMOTE' OR (OperatorRating >= 3)
        )
    );
END;

 --Valid insert
INSERT INTO EquipmentLogs (MachineID, FuelLevelPercent, EngineTemp, OperatorRating, OperationMode)
VALUES (101, 75, 88.5, 4, 'AUTO');

  -- Invalid insert: FuelLevelPercent > 100 (violates CHECK)
  --INSERT INTO EquipmentLogs (MachineID, FuelLevelPercent, EngineTemp, OperatorRating, OperationMode)
  --VALUES (102, 110, 90.0, 3, 'MANUAL');

 -- Valid insert: REMOTE mode with good rating
INSERT INTO EquipmentLogs (MachineID, FuelLevelPercent, EngineTemp, OperatorRating, OperationMode)
VALUES (106, 80, 90.0, 5, 'REMOTE');


SELECT * FROM EquipmentLogs;
