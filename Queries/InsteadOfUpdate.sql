ALTER TRIGGER TR_Product_Update
ON dbo.vProducts
INSTEAD OF UPDATE AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @UserId int = (SELECT AppUserId from inserted), @ProductSubCategoryId int = (SELECT ProductSubCategoryId from inserted) , @ProductName varchar(50) = (SELECT ProductName from inserted)
	
	UPDATE vProducts SET ProductSubCategoryId= @ProductSubCategoryId FROM inserted WHERE inserted.AppUserId=@UserId
	UPDATE vProducts SET ProductName=@ProductName FROM inserted WHERE inserted.AppUserId=@UserId
	
END

UPDATE vProducts SET ProductSubCategoryId=3 , ProductName ='FOREVER 21 JEANS' WHERE AppUserId=2

select * from vProducts
select * from Products
select * from Sellers