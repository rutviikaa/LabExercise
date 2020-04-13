Use MarketDev;
GO

CREATE PROCEDURE Marketing.GetProductsByColor
@Color nvarchar(16)
AS
SET NOCOUNT ON;
BEGIN
	SELECT p.ProductID,	p.ProductName, p.ListPrice AS Price, p.Color, p.Size, p.SizeUnitMeasureCode AS UnitOfMeasure FROM Marketing.Product AS p
	WHERE (p.Color = @Color) OR (p.Color IS NULL AND @Color IS NULL) ORDER BY ProductName;
END
GO

EXEC Marketing.GetProductsByColor 'Blue';
GO

EXEC Marketing.GetProductsByColor NULL;
GO
