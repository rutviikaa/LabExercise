Create FUNCTION dbo.JoinNames
( @FirstName nvarchar(20), @MiddleName nvarchar(20), @LastName nvarchar(20))
RETURNS @Outputtable TABLE (FullName nvarchar(max))
AS BEGIN
	INSERT INTO @OutputTable (FullName)
	SELECT CONCAT(@FirstName , ' ' , @MiddleName , ' ' , @Lastname) AS FullName ;
	RETURN;
END;
GO

SELECT * FROM dbo.JoinNames('Alpha','Beta','Gamma')
SELECT * FROM dbo.JoinNames('Alpha','','Gamma')
SELECT * FROM dbo.JoinNames('Alpha',1,'Gamma')