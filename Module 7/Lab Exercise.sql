--Exercise 1

SET STATISTICS TIME OFF
GO
USE AdventureWorksDW
GO

sp_spaceused 'dbo.FactProductInventory';
GO

SET STATISTICS TIME ON
GO

SELECT p.EnglishProductName
		,d.WeekNumberOfYear
		,d.CalendarYear
		,AVG(fpi.UnitCost) AvgCost
		,SUM(fpi.UnitsOut) TotalUnits
		,MAX(fpi.UnitCost) HighestPrice
FROM dbo.FactProductInventory as fpi
INNER JOIN dbo.DimProduct as p ON fpi.ProductKey = p.ProductKey
INNER JOIN dbo.DimDate as d ON fpi.DateKey = d.DateKey
GROUP BY p.EnglishProductName,
		d.WeekNumberOfYear,
		d.CalendarYear
ORDER BY p.EnglishProductName,
		d.CalendarYear,
		d.WeekNumberOfYear;
GO
CREATE NONCLUSTERED COLUMNSTORE INDEX NCC_FactProductInventory ON FactProductInventory (ProductKey,DateKey,UnitCost,UnitsOut)
CREATE NONCLUSTERED COLUMNSTORE INDEX NCC_DimProduct ON DimProduct (  EnglishProductName); 
CREATE NONCLUSTERED COLUMNSTORE INDEX NCC_DimDate ON DimDate (  WeekNumberOfYear  ,CalendarYear );

--END

--Exercise 2

SET STATISTICS TIME OFF
GO
USE [AdventureWorksDW]
GO

sp_spaceused 'dbo.FactInternetSales'
GO

SET STATISTICS TIME ON
GO

SELECT SalesTerritoryRegion
		,p.EnglishProductName
		,d.WeekNumberOfYear
		,d.CalendarYear
		,SUM(fi.SalesAmount) Revenue
		,AVG(OrderQuantity) AverageQuantity
		,STDEV(UnitPrice) PriceStandardDeviation
		,SUM(TaxAmt) TotalTaxPayable
FROM dbo.FactInternetSales as fi
INNER JOIN dbo.DimProduct as p ON fi.ProductKey = p.ProductKey
INNER JOIN dbo.DimDate as d ON fi.OrderDate = d.FullDateAlternateKey
INNER JOIN dbo.DimSalesTerritory as st on fi.SalesTerritoryKey = st.SalesTerritoryKey
	AND fi.OrderDate BETWEEN '1/1/2007' AND '12/31/2007'
GROUP BY SalesTerritoryRegion, d.CalendarYear, d.WeekNumberOfYear, p.EnglishProductName
ORDER BY SalesTerritoryRegion, SUM(fi.SalesAmount) desc;

DROP INDEX [IX_FactIneternetSales_ShipDateKey] ON [dbo].[FactInternetSales];
DROP INDEX [IX_FactInternetSales_CurrencyKey] ON [dbo].[FactInternetSales];
DROP INDEX [IX_FactInternetSales_CustomerKey] ON [dbo].[FactInternetSales];
DROP INDEX [IX_FactInternetSales_DueDateKey] ON [dbo].[FactInternetSales];
DROP INDEX [IX_FactInternetSales_OrderDateKey] ON [dbo].[FactInternetSales];
DROP INDEX [IX_FactInternetSales_ProductKey] ON [dbo].[FactInternetSales];
DROP INDEX [IX_FactInternetSales_PromotionKey] ON [dbo].[FactInternetSales];

ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimCustomer];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimCurrency];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate1];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate2];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimProduct];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimPromotion];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimSalesTerritory];
ALTER TABLE [dbo].[FactInternetSalesReason] DROP CONSTRAINT [FK_FactInternetSalesReason_FactInternetSales]
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber]

CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactInternetSales ON FactInternetSales 

CREATE NONCLUSTERED INDEX NCI_FactInternetSales_PromotionKey ON FactInternetSales (PromotionKey )
CREATE NONCLUSTERED INDEX NCI_FactInternetSales_ShipDateKey ON FactInternetSales (ShipDateKey)
CREATE NONCLUSTERED INDEX NCI_FactInternetSales_CurrencyKey ON FactInternetSales (CurrencyKey)
CREATE NONCLUSTERED INDEX NCI_FactInternetSales_CustomerKey ON FactInternetSales (CustomerKey)
CREATE NONCLUSTERED INDEX NCI_FactInternetSales_DueDateKey ON FactInternetSales (DueDateKey)
CREATE NONCLUSTERED INDEX NCI_FactInternetSales_OrderDateKey ON FactInternetSales (OrderDateKey)
CREATE NONCLUSTERED INDEX NCI_FactInternetSales_ProductKey ON FactInternetSales (ProductKey)

CREATE UNIQUE NONCLUSTERED INDEX PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber ON FactInternetSales (SalesOrderNumber,SalesOrderLineNumber)

ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimCustomer] FOREIGN KEY([CustomerKey])
REFERENCES [dbo].[DimCustomer] ([CustomerKey])
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimCustomer]

ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimCurrency] FOREIGN KEY([CurrencyKey])
REFERENCES [dbo].[DimCurrency] ([CurrencyKey])
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimCurrency]

ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimDate] FOREIGN KEY([OrderDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate]

ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimDate1] FOREIGN KEY([DueDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate1]

ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimDate2] FOREIGN KEY([ShipDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate2]

ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimProduct] FOREIGN KEY([ProductKey])
REFERENCES [dbo].[DimProduct] ([ProductKey])
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimProduct]

ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimPromotion] FOREIGN KEY([PromotionKey])
REFERENCES [dbo].[DimPromotion] ([PromotionKey])
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimPromotion]

ALTER TABLE [dbo].[FactInternetSales]  WITH CHECK ADD  CONSTRAINT [FK_FactInternetSales_DimSalesTerritory] FOREIGN KEY([SalesTerritoryKey])
REFERENCES [dbo].[DimSalesTerritory] ([SalesTerritoryKey])
ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimSalesTerritory]

CREATE NONCLUSTERED COLUMNSTORE INDEX NCC_DimDate_FullDateAlternateKey ON DimDate (FullDateAlternateKey);
CREATE NONCLUSTERED COLUMNSTORE INDEX NCC_DimSalesTerritory ON DimSalesTerritory (  SalesTerritoryKey  ,SalesTerritoryRegion );


--END

--Exercise 3

CREATE TABLE [dbo].[CopyFactInternetSales]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20)  NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float](53) NOT NULL,
	[DiscountAmount] [float](53) NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25)  NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL
)

DROP INDEX CCI_FactInternetSales ON FactInternetSales; 
DROP INDEX [NCI_FactIneternetSales_ShipDateKey] ON [dbo].[FactInternetSales];
DROP INDEX [NCI_FactInternetSales_CurrencyKey] ON [dbo].[FactInternetSales];
DROP INDEX [NCI_FactInternetSales_CustomerKey] ON [dbo].[FactInternetSales];
DROP INDEX [NCI_FactInternetSales_DueDateKey] ON [dbo].[FactInternetSales];
DROP INDEX [NCI_FactInternetSales_OrderDateKey] ON [dbo].[FactInternetSales];
DROP INDEX [NCI_FactInternetSales_ProductKey] ON [dbo].[FactInternetSales];
DROP INDEX [NCI_FactInternetSales_PromotionKey] ON [dbo].[FactInternetSales];
DROP INDEX PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber ON FactInternetSales;

ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimCustomer];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimCurrency];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate1];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate2];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimProduct];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimPromotion];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimSalesTerritory];
ALTER TABLE [dbo].[FactInternetSalesReason] DROP CONSTRAINT [FK_FactInternetSalesReason_FactInternetSales]
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber]


ALTER DATABASE AdventureWorksDW
ADD FILEGROUP  AdventureWorksDW_Memory_Optimized_Data CONTAINS MEMORY_OPTIMIZED_DATA
GO

ALTER DATABASE AdventureWorksDW ADD 
FILE (name='AdventureworksDW_MOD', filename='F:\SQL\LabFiles\Lab04\Starter\SetupFiles\AdventureworksDW_MOD') 
TO FILEGROUP AdventureWorksDW_Memory_Optimized_Data

EXEC dbo.sp_rename @objname = N'[dbo].[FactInternetSales]', @newname = N'FactInternetSales_old', @objtype = N'OBJECT'
GO

USE [AdventureWorksDW]
GO

SET ANSI_NULLS ON
GO

CREATE TABLE [dbo].[FactInternetSales]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float](53) NOT NULL,
	[DiscountAmount] [float](53) NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CustomerPONumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,

 CONSTRAINT [FactInternetSales_primaryKey]  PRIMARY KEY NONCLUSTERED HASH 
(
	[SalesOrderNumber],
	[SalesOrderLineNumber]
)WITH ( BUCKET_COUNT = 2097152)
,INDEX CCI_OnlineFactInternetSales CLUSTERED COLUMNSTORE
)WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_AND_DATA )

GO

INSERT INTO [AdventureWorksDW].[dbo].[FactInternetSales] ([ProductKey], [OrderDateKey], [DueDateKey], [ShipDateKey], [CustomerKey], [PromotionKey], [CurrencyKey], [SalesTerritoryKey], [SalesOrderNumber], [SalesOrderLineNumber], [RevisionNumber], [OrderQuantity], [UnitPrice], [ExtendedAmount], [UnitPriceDiscountPct], [DiscountAmount], [ProductStandardCost], [TotalProductCost], [SalesAmount], [TaxAmt], [Freight], [CarrierTrackingNumber], [CustomerPONumber], [OrderDate], [DueDate], [ShipDate]) SELECT [ProductKey], [OrderDateKey], [DueDateKey], [ShipDateKey], [CustomerKey], [PromotionKey], [CurrencyKey], [SalesTerritoryKey], [SalesOrderNumber], [SalesOrderLineNumber], [RevisionNumber], [OrderQuantity], [UnitPrice], [ExtendedAmount], [UnitPriceDiscountPct], [DiscountAmount], [ProductStandardCost], [TotalProductCost], [SalesAmount], [TaxAmt], [Freight], [CarrierTrackingNumber], [CustomerPONumber], [OrderDate], [DueDate], [ShipDate] FROM [AdventureWorksDW].[dbo].[CopyFactInternetSales] 
GO
