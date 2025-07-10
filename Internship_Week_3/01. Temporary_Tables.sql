/*
  Temporary tables in SQL Server are like normal tables but exist temporarily during a session or connection.
  They are often used to hold intermediate results or staging data in stored procedures or batch scripts.
  Two types:
     1. Local Temporary Table: Prefix with #, exists only for the session that created it.
     2. Global Temporary Table: Prefix with ##, visible to all sessions, drops when last session ends.


  SYNTAX ::
  CREATE TABLE #TempTableName (columns...)
  INSERT INTO #TempTableName VALUES (...)
  SELECT * FROM #TempTableName
  DROP TABLE #TempTableName

  ==============================================
  EXAMPLE: Suppose we have a company with Employees and Projects.
  We want to find the average salary of employees working on each project.
  We'll use a temporary table to stage joined data before aggregating.
  ==============================================
*/


-- (1) Local temp table: only visible in current session (window)
CREATE TABLE #LocalTempTable (
    ID INT,
    Name NVARCHAR(50)
);


INSERT INTO #LocalTempTable (ID, Name)
VALUES (1, 'Alice'), (2, 'Bob');


SELECT * FROM #LocalTempTable;

 --if open a new query window and run: SELECT * FROM #LocalTempTable
--will get an error: because it's *local*, only visible in current session

DROP TABLE #LocalTempTable;


--(2) Global temp table: visible to *all* sessions until the creating session ends *and* no other session is using it
CREATE TABLE ##GlobalTempTable (
    ID INT,
    Product NVARCHAR(50)
);


INSERT INTO ##GlobalTempTable (ID, Product)
VALUES (101, 'Laptop'), (102, 'Mouse');


SELECT * FROM ##GlobalTempTable;

 --if open a new window and run: SELECT * FROM ##GlobalTempTable
 --This will work — because it's a *global* temp table.

 --Drop the global temp table manually (won’t auto-drop until all sessions are done with it)
DROP TABLE ##GlobalTempTable;


