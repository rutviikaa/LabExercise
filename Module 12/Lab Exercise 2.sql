USE InternetSales
GO
CREATE PROCEDURE dbo.AddItemToCart
	@SessionID INT, @TimeAdded DATETIME, @CustomerKey INT, @ProductKey INT, @Quantity INT
	WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN 
	ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')  
	INSERT INTO dbo.ShoppingCart (SessionID, TimeAdded, CustomerKey, ProductKey, Quantity)	VALUES 	(@SessionID, @TimeAdded, @CustomerKey, @ProductKey, @Quantity)
END
GO

CREATE PROCEDURE dbo.DeleteItemFromCart
	@SessionID INT, @ProductKey INT
	WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN 
	ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')  
	DELETE FROM dbo.ShoppingCart WHERE SessionID = @SessionID AND ProductKey = @ProductKey
END
GO

CREATE PROCEDURE dbo.EmptyCart
	@SessionID INT
	WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN 
	ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')  
	DELETE FROM dbo.ShoppingCart WHERE SessionID = @SessionID
END
GO

DECLARE @currentime DATETIME = GETDATE()
EXEC dbo.AddItemToCart 3,@currentime,2,3,1
EXEC dbo.AddItemToCart 3,@currentime,2,4,1
SELECT * FROM dbo.ShoppingCart

EXEC dbo.DeleteItemFromCart 3,4
SELECT * FROM dbo.ShoppingCart

EXEC dbo.EmptyCart 3
SELECT * FROM dbo.ShoppingCart