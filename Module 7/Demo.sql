USE AdventureworksDW

SET STATISTICS IO ON
GO

SELECT	ProductKey
		,SUM(UnitPrice) SumUnitPrice
		,AVG(UnitPrice) AvgUnitPrice
		,SUM(OrderQuantity) SumOrderQty
		,AVG(OrderQuantity) AvgOrderQty
		,SUM(TotalProductCost) SumTotalProductCost
		,AVG(TotalProductCost) AvgTotalProductCost
		,SUM(UnitPrice - TotalProductCost) ProductProfit
FROM dbo.FactInternetSales 
GROUP BY ProductKey
ORDER BY ProductKey
GO

SET STATISTICS IO OFF
GO

--Data space used: 615,584 KB
sp_spaceused 'dbo.FactInternetSales'
GO


ALTER TABLE [dbo].[FactInternetSalesReason] DROP CONSTRAINT [FK_FactInternetSalesReason_FactInternetSales]
GO

ALTER TABLE [dbo].[FactInternetSalesReason] DROP CONSTRAINT [PK_FactInternetSalesReason_SalesOrderNumber_SalesOrderLineNumber_SalesReasonKey]
GO

ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber]
GO

CREATE CLUSTERED COLUMNSTORE INDEX PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber on [FactInternetSales] 
GO

--Data space used: 39,928 KB (15x smaller than the rowstore table!)
sp_spaceused 'dbo.FactInternetSales'
GO
