IF OBJECT_ID(N'SalesLT.vw_CustomerOrders', N'V') IS NOT NULL
	DROP VIEW SalesLT.vw_CustomerOrders;
GO
CREATE VIEW SalesLT.vw_CustomerOrders
AS
SELECT C.CustomerID, C.FirstName, C.LastName, O.OrderDate, O.SubTotal, O.TotalDue 
FROM SalesLT.Customer AS C
	INNER JOIN SalesLT.SalesOrderHeader as O
ON C.CustomerID =O.CustomerID;
GO

SELECT * 
	FROM SalesLT.vw_CustomerOrders;
GO

SELECT * 
FROM SalesLT.vw_CustomerOrders
ORDER BY TotalDue Desc;
GO

SELECT OBJECT_DEFINITION(OBJECT_ID(N'SalesLT.vw_CustomerOrders',N'V'));
GO

ALTER VIEW SalesLT.vw_CustomerOrders
WITH ENCRYPTION
AS
	SELECT C.CustomerID, C.FirstName, C.LastName, O.OrderDate, O.SubTotal, O.TotalDue 
FROM SalesLT.Customer AS C
	INNER JOIN SalesLT.SalesOrderHeader as O
ON C.CustomerID =O.CustomerID;
GO

SELECT OBJECT_DEFINITION(OBJECT_ID(N'SalesLT.vw_CustomerOrders',N'V'));
GO

DROP VIEW SalesLT.vw_CustomerOrders;
GO

