USE AdventureWorks
GO

CREATE TABLE Production.ProductAudit
(
	ProductID	int NOT NULL,
	UpdateTime	datetime2 NOT NULL,
	ModifyingUser	nvarchar(100) NOT NULL,
	OriginalListPrice	Money NULL,
	NewListPrice	Money NULL

)

CREATE TRIGGER Production.TR_ListPrice_Update
ON Production.Product
AFTER UPDATE AS BEGIN
  SET NOCOUNT ON;
	INSERT Production.ProductAudit (ProductID, UpdateTime, ModifyingUser, OriginalListPrice, NewListPrice)
	SELECT inserted.ProductID,SYSDATETIME(), ORIGINAL_LOGIN(), deleted.ListPrice, inserted.ListPrice FROM deleted 
	INNER JOIN inserted ON deleted.ProductID=inserted.ProductID WHERE deleted.ListPrice>1000 OR inserted.ListPrice>1000;
END;
GO

SELECT * FROM Production.Product WHERE ListPrice>1000 

UPDATE Production.Product SET ListPrice = 1500.00 WHERE ProductID=680

SELECT * FROM Production.Product WHERE ListPrice>1000 AND ProductID=680

SELECT * FROM Production.ProductAudit
