USE AdventureWorks
GO

CREATE PROCEDURE Production.GetAvailableModelsAsXML
AS
BEGIN
	SELECT p.ProductID,p.Name as ProductName,p.ListPrice,p.Color,p.SellStartDate,pm.ProductModelID,pm.Name as ProductModel FROM Production.Product AS p
	  INNER JOIN Production.ProductModel AS pm ON p.ProductModelID = pm.ProductModelID 
	  WHERE p.SellStartDate IS NOT NULL AND p.SellEndDate IS NULL
	  ORDER BY p.SellStartDate, p.Name DESC
	  FOR XML RAW('AvailableModel'), ROOT('AvailableModels');
END;
GO

EXEC Production.GetAvailableModelsAsXML

----

CREATE PROCEDURE Sales.UpdateSalesTerritoriesByXML (@SalespersonMods xml)
AS
BEGIN
	UPDATE Sales.SalesPerson SET TerritoryID = updates.SalesTerritoryID FROM Sales.SalesPerson sp INNER JOIN 
	(SELECT SalespersonMod.value('@BusinessEntityID','int') AS BusinessEntityID, 
	SalespersonMod.value('(Mods/Mod/@SalesTerritoryID)[1]','int') AS SalesTerritoryID FROM @SalespersonMods.nodes('/SalespersonMods/SalespersonMod') 
	AS SalespersonMods(SalespersonMod)) AS updates ON sp.BusinessEntityID = updates.BusinessEntityID;
END;
GO

DECLARE	@xmlTestString nvarchar(2000);
SET @xmlTestString = '<SalespersonMods>      <SalespersonMod BusinessEntityID="274">            <Mods>                <Mod SalesTerritoryID="3"/>            </Mods>      </SalespersonMod>       <SalespersonMod BusinessEntityID="278">            <Mods>                 <Mod SalesTerritoryID="4"/>            </Mods>      </SalespersonMod>   </SalespersonMods> ';
DECLARE @testxml xml;
SET @testxml=@xmlTestString;

EXEC Sales.UpdateSalesTerritoriesByXML @testxml

select * from Sales.SalesPerson where TerritoryID = 3 or TerritoryID = 4