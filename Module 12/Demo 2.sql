-- Step 1 - Use the MemDemo database
USE MemDemo

-- Step 2 - Create a native stored proc
CREATE PROCEDURE dbo.InsertData
	WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')
	DECLARE @Memid int = 1
	WHILE @Memid <= 500000
	BEGIN
		INSERT INTO dbo.MemoryTable VALUES (@Memid, GETDATE())
		SET @Memid += 1
	END
END;
GO

-- Step 3 - Use the native stored proc
EC dbo.InsertData;

-- Step 4 - Verify MemoryTable contents
-- Confirm that the table now contains 500,000 rows.
SELECT COUNT(*) FROM dbo.MemoryTable;