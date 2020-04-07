--EXERCISE 1

USE AdventureWorks
GO

CREATE TABLE Sales.MediaOutlet
(
MediaOutletID INT NOT NULL,
MediaOutletName NVARCHAR(40) NOT NULL,
PrimaryContact NVARCHAR(50) NOT NULL,
City NVARCHAR(50) NOT NULL
);



CREATE TABLE Sales.PrintMediaPlacement
(
PrintMediaPlacementID INT NOT NULL,
MediaOutletID INT NOT NULL,
PlacementDate DATETIME NOT NULL,
PublicationDate DATETIME NOT NULL,
ProductID INT NOT NULL,
PlacementCost DECIMAL(18,2) NOT NULL
);


--END 

--EXERCISE 2

ALTER TABLE Sales.MediaOutlet ADD CONSTRAINT IX_MediaOutlet UNIQUE CLUSTERED (MediaOutletID);

ALTER TABLE Sales.PrintMediaPlacement ADD CONSTRAINT IX_PrintMediaPlacement UNIQUE CLUSTERED (PrintMediaPlacementID);

--END

--EXERCISE 3

Declare @start int=1, @end int=32767
-- Use a CTE to create ID's
;With MediaIDS( Number ) as
(
    Select @start as Number
        union all
    Select Number + 1
        from MediaIDS
        where Number < @end
)
--Can only recurse 32767 times
INSERT INTO Sales.MediaOutlet
           (MediaOutletID
           ,MediaOutletName
           ,PrimaryContact
           ,City)
Select Number, 
NEWID() Name, -- random name etc
NEWID() Contact,
NEWID() City
from MediaIDS Option (MaxRecursion 32767);

;With MediaIDS( Number ) as
(
    Select @start as Number
        union all
    Select Number + 1
        from MediaIDS
        where Number < @end
)
--Can only recurse 32767 times
INSERT INTO Sales.PrintMediaPlacement
           (PrintMediaPlacementID
           ,MediaOutletID
           ,PlacementDate
           ,PublicationDate
		   ,ProductID
		   ,PlacementCost)
Select Number,
ABS(CHECKSUM(NewId())) % 32767 MediaID,
GETDATE() - ABS(CHECKSUM(NewId())) % 365,
GETDATE() - ABS(CHECKSUM(NewId())) % 365,
ABS(CHECKSUM(NewId())) % 32767 ProductID,
RAND(ABS(CHECKSUM(NewId())) % 32767)*1000
from MediaIDS Option (MaxRecursion 32767);

SELECT PMP.*, MO.City 
FROM Sales.PrintMediaPlacement PMP
JOIN Sales.MediaOutlet MO ON PMP.MediaOutletID=MO.MediaOutletID
WHERE PublicationDate BETWEEN '2015-09-1' AND '2015-09-30'
AND PlacementCost BETWEEN 1 AND 2000
ORDER BY PlacementCost DESC;


CREATE NONCLUSTERED INDEX NCI_PrintMediaPlacement
ON [Sales].[PrintMediaPlacement] ([PublicationDate],[PlacementCost])
INCLUDE ([MediaOutletID],[PlacementDate],[ProductID])
GO

--END

