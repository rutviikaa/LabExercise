USE AdventureWorks2016;
GO

CREATE VIEW Sales.NewCustomer
AS
SELECT CustomerID, FirstName, LastName FROM Sales.CustomerPII;
GO

SELECT * FROM Sales.NewCustomer 
ORDER BY CustomerID

INSERT INTO Sales.NewCustomer
VALUES
(10001,'Shawn', 'Simmons'),
(10002, 'John', 'Walker');
GO

SELECT * from Sales.CustomerPII ORDER BY CustomerID