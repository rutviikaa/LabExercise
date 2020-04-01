---------------------------------------------------------------------
-- LAB 02

Create Schema DirectMarketing Authorization dbo;
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a script to create a table to store the Competitor data.
---------------------------------------------------------------------
Create Table DirectMarketing.Competitor
(
	CompetitorId	int	NOT NULL IDENTITY(1,1) PRIMARY KEY,
	CompetitorName	varchar(50)	NOT NULL,
	Strength_of_competition	varchar(50)	NULL,
	City	varchar(50)	NOT NULL
	

);
GO




---------------------------------------------------------------------
-- Task 2
-- 
-- Write a script to create a table to store the TVAdvertisement data.
---------------------------------------------------------------------
Create Table DirectMarketing.TVAdvertisement
(
	TVAdvertisementId	int	NOT NULL IDENTITY(1,1) PRIMARY KEY ,
	TVAdvertisementName	varchar(50)	NOT NULL,
	Repeatition	int	NOT NULL,
	Duration time NOT NULL,
	Cost	money	NOT NULL
);
GO






---------------------------------------------------------------------
-- Task 3
-- 
-- Write a script to create a table to store the CampaignResponse data.
---------------------------------------------------------------------
Create Table DirectMarketing.CampaignResponse
(
	CampaignResponseId	int	NOT NULL IDENTITY(1,1) PRIMARY KEY,
	CampaignName	varchar(50)	NOT NULL,
	CampaignResponseType	varchar(20)	NOT NULL,
	NumberOfResponse	int	NOT NULL,
	BeginDate	datetimeoffset(7)	NOT NULL,
	EndDate	datetimeoffset(7)	NOT NULL,
	City	varchar(50)	NOT NULL,
	Lead	varchar(20)	NOT NULL,
	InterestedTenant	varchar(20)	NOT NULL,
	ConfirmTenant	varchar(20)	NOT NULL,
	Invested	money	NOT NULL,
	Profit	money	NOT NULL
	

);
GO

