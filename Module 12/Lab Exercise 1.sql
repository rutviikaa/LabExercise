USE [master]
GO
ALTER DATABASE [InternetSales] ADD FILEGROUP [FG] CONTAINS MEMORY_OPTIMIZED_DATA 
GO
ALTER DATABASE [InternetSales] ADD FILE ( NAME = N'InternetSalesData', FILENAME = N'F:\SQL\Setupfiles\InternetSalesData' ) TO FILEGROUP [FG]
GO

USE [InternetSales]
GO

CREATE TABLE dbo.ShoppingCart
(
SessionID INT NOT NULL,
TimeAdded DATETIME NOT NULL,
CustomerKey INT NOT NULL,
ProductKey INT NOT NULL,
Quantity INT NOT NULL
PRIMARY KEY NONCLUSTERED (SessionID,ProductKey)) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA)

INSERT INTO dbo.ShoppingCart (SessionID,TimeAdded,CustomerKey,ProductKey,Quantity) VALUES (1,GETDATE(),2,3,1),(1,GETDATE(),2,4,1)

SELECT * FROM dbo.ShoppingCart
