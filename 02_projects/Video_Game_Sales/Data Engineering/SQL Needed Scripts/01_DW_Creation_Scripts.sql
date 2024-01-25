CREATE SCHEMA SRC --Raw Data before replacing descriptions by ids
GO

CREATE SCHEMA INTERMEDIATE --For saving intermediate results (AKA clean and prepared data)
GO

CREATE SCHEMA DW --Actual DW
GO

-- ##Source Tables, for raw data
CREATE TABLE SRC.Fact_VideoGames_Sales(
	GameName  nvarchar(1000) NULL,
	Console   nvarchar(20) NULL,
	Publisher nvarchar(100) NULL,
	Developer nvarchar(100) NULL,
	VGChartz_Score decimal(3, 1) NULL,
	Critic_Score decimal(3, 1) NULL,
	User_Score decimal(3, 1) NULL,
	Total_Shipped int NULL,
	Total_Sales int NULL,
	NA_Sales int NULL,
	PAL_Sales int NULL,
	Japan_Sales int NULL,
	Other_Sales int NULL,
	Release_Date date NULL,
	Last_Update date NULL
)
GO

CREATE TABLE SRC.Dim_Console(
	Console_Abbreviation nvarchar(20) NOT NULL
)
GO

CREATE TABLE SRC.Dim_Developer(
	Developer nvarchar(100) NOT NULL
)
GO

CREATE TABLE SRC.Dim_Publisher(
	Publisher nvarchar(100) NOT NULL
)
GO

CREATE TABLE SRC.Dim_VideoGames(
	Game_Name nvarchar(1000) NOT NULL
)
GO

----------------------------
-- #Intermediate tables, created when needed
----------------------------

/*
INTERMEDIATE TABLES NOT REQUIRED FOR THE FOLLOWING
TABLES, AS THEY HAVE A SINGLE COLUMN AND WE WON'T PERFORM ANY TRANSFORMATION
NOR UPDATES, JUST INSERTS:
Dim_Developer
Dim_Publisher
Dim_VideoGames
Dim_Console
*/

CREATE TABLE INTERMEDIATE.Dim_Consoles_Information
(
Console_Abbreviation nvarchar(20) not null
,Console_Name nvarchar(200) null 
,Developer nvarchar(200) null
,Release_Date DATE NULL
,Origin_Country NVARCHAR(100) NULL
,Generation NVARCHAR(50) NULL	
,Type NVARCHAR(100) NULL		
,Media_Type NVARCHAR(100) NULL	
,Graphics NVARCHAR(100) NULL	
,Online_Play NVARCHAR(20) NULL  
,Predecessor NVARCHAR(100) NULL 
,Successor NVARCHAR(100) NULL
,INCOMPLETE_INFORMATION NVARCHAR(3) NOT NULL DEFAULT ('NO')	
)
GO

-- ##Source Tables, for raw data
CREATE TABLE INTERMEDIATE.Fact_VideoGames_Sales(
	ID_VideoGame bigint NOT NULL,
	ID_Console   bigint NOT NULL,
	ID_Publisher bigint NOT NULL,
	ID_Developer bigint NOT NULL,
	VGChartz_Score decimal(3, 1) NULL,
	Critic_Score decimal(3, 1) NULL,
	User_Score decimal(3, 1) NULL,
	Total_Shipped int NULL,
	Total_Sales int NULL,
	NA_Sales int NULL,
	PAL_Sales int NULL,
	Japan_Sales int NULL,
	Other_Sales int NULL,
	ID_Release_Date bigint NOT NULL,
	Last_Update date NULL,
	HASH_VALUE VARBINARY (8000) NOT NULL
)
GO

----------------------------
-- DW layer, for final tables
----------------------------

CREATE TABLE DW.Dim_Consoles_Information
(
ID_Console bigint not null IDENTITY(1,1) PRIMARY KEY
,Console_Abbreviation nvarchar(20) not null
,Console_Name nvarchar(200) null DEFAULT ('NOT SPECIFIED')
,Developer nvarchar(200) null DEFAULT ('NOT SPECIFIED')
,Release_Date DATE NULL
,Origin_Country NVARCHAR(100) NULL DEFAULT ('NOT SPECIFIED')
,Generation NVARCHAR(50) NULL DEFAULT ('NOT SPECIFIED')
,Type NVARCHAR(100) NULL DEFAULT ('NOT SPECIFIED')
,Media_Type NVARCHAR(100) NULL DEFAULT ('NOT SPECIFIED')
,Graphics NVARCHAR(100) NULL DEFAULT ('NOT SPECIFIED')
,Online_Play NVARCHAR(20) NULL DEFAULT ('NOT SPECIFIED')
,Predecessor NVARCHAR(100) NULL DEFAULT ('NOT SPECIFIED')
,Successor NVARCHAR(100) NULL DEFAULT ('NOT SPECIFIED')
,Audit_Insert_TS DATETIME2(7) NOT NULL DEFAULT (GETDATE())	-- To identify whenever a row was updated/inserted	
,Audit_Insert_Username nvarchar(20) not null DEFAULT ('ETL System') -- To identify who inserted the row
,Audit_Update_TS DATETIME2(7) NULL	-- To identify whenever a row was updated/inserted
,Audit_Update_Username nvarchar(20) null -- To identify who inserted the row
,INCOMPLETE_INFORMATION NVARCHAR(3) NOT NULL DEFAULT ('NO')
)
GO

CREATE TABLE DW.Dim_Developer(
	ID_Developer bigint not null IDENTITY(1,1) PRIMARY KEY,
	Developer nvarchar(100) NOT NULL,
	Audit_Insert_TS DATETIME2(7) NOT NULL DEFAULT (GETDATE()),	-- To identify whenever a row was updated/inserted	
	Audit_Insert_Username nvarchar(20) not null DEFAULT ('ETL System') -- To identify who inserted the row
)
GO

CREATE TABLE DW.Dim_Publisher(
	ID_Publisher bigint not null IDENTITY(1,1) PRIMARY KEY,
	Publisher nvarchar(100) NOT NULL,
	Audit_Insert_TS DATETIME2(7) NOT NULL DEFAULT (GETDATE()),	-- To identify whenever a row was updated/inserted	
	Audit_Insert_Username nvarchar(20) not null DEFAULT ('ETL System') -- To identify who inserted the row
)
GO

CREATE TABLE DW.Dim_VideoGames(
	ID_VideoGame bigint not null IDENTITY(1,1) PRIMARY KEY,
	Game_Name nvarchar(1000) NOT NULL,
	Audit_Insert_TS DATETIME2(7) NOT NULL DEFAULT (GETDATE()),	-- To identify whenever a row was updated/inserted	
	Audit_Insert_Username nvarchar(20) not null DEFAULT ('ETL System') -- To identify who inserted the row
)
GO


CREATE TABLE DW.Dim_Date ( --Loaded with sp "dbo.usp_GenerateDates"
    DateKey INT NOT NULL PRIMARY KEY,
    CalendarDate DATE,
    CalendarDayOfYear INT,
    CalendarMonthName NVARCHAR(1000),
    CalendarMonthNumber INT,
    CalendarQuarter INT,
    CalendarSemester INT,
    CalendarDayOfWeekName NVARCHAR(1000),
    CalendarDayOfWeek INT,
    CalendarDayOfMonth INT,
    CalendarWeekOfMonth INT,
    CalendarWeekOfYear INT,
    CalendarYear INT,
    CalendarYearMonthAsInteger INT,
    CalendarYearQuarterAsInteger INT,
    CalendarYearSemesterAsInteger INT,
    LastDayOfCalendarMonthIndicator NVARCHAR(1000),
    LastDateOfCalendarMonth DATE,
    HolidayIndicator NVARCHAR(1000),
    WorkingDayIndicator NVARCHAR(1000),
    WeekdayWeekend NVARCHAR(1000),
    FiscalDate DATE,
    FiscalDateKey INT,
    FiscalDayOfYear INT,
    FiscalMonthName NVARCHAR(1000),
    FiscalMonthNumber INT,
    FiscalQuarter INT,
    FiscalSemester INT,
    FiscalDayOfWeekName NVARCHAR(1000),
    FiscalDayOfWeek INT,
    FiscalDayOfMonth INT,
    FiscalWeekOfMonth INT,
    FiscalWeekOfYear INT,
    FiscalYear INT,
    FiscalYearWeekAsInteger INT,
    FiscalYearMonthAsInteger INT,
    FiscalYearQuarterAsInteger INT,
    FiscalYearSemesterAsInteger INT,
    LastDayOfFiscalMonthIndicator NVARCHAR(1000),
    LastDateOfFiscalMonth DATE
);
GO

CREATE TABLE DW.Fact_VideoGames_Sales(
	ID_VideoGame BIGINT NOT NULL,
	ID_Console 	BIGINT NOT NULL,
	ID_Publisher BIGINT NOT NULL,
	ID_Developer BIGINT NOT NULL,
	VGChartz_Score decimal(3, 1) NULL,
	Critic_Score decimal(3, 1) NULL,
	User_Score decimal(3, 1) NULL,
	Total_Shipped int NULL,
	Total_Sales int NULL,
	NA_Sales int NULL,
	PAL_Sales int NULL,
	Japan_Sales int NULL,
	Other_Sales int NULL,
	ID_Release_Date INT NOT NULL,
	Last_Update date NULL,
	HASH_VALUE varbinary (8000) NOT NULL, --## To detect any changes on data
	Audit_Insert_TS DATETIME2(7) NOT NULL DEFAULT (GETDATE()),	-- To identify whenever a row was updated/inserted	
	Audit_Insert_Username nvarchar(20) not null DEFAULT ('ETL System'), -- To identify who inserted the row
	Audit_Update_TS DATETIME2(7) NULL,	-- To identify whenever a row was updated/inserted
	Audit_Update_Username nvarchar(20) null, -- To identify who inserted the row
	IS_CURRENT_VERSION nvarchar(20) default('CURRENT VERSION')  NOT NULL --we will save every videogame's history, to create an evolution chart in the future.
)
GO

--------------------------------
--Adding 'NOT SPECIFIED' rows to our tables 
---------------------------------

SET IDENTITY_INSERT DW.Dim_Consoles_Information ON
GO

INSERT INTO DW.Dim_Consoles_Information
           (ID_Console
	     ,Console_Abbreviation
           ,Console_Name
           ,Developer
           ,Release_Date
           ,Origin_Country
           ,Generation
           ,Type
           ,Media_Type
           ,Graphics
           ,Online_Play
           ,Predecessor
           ,Successor
           ,Audit_Insert_TS
           ,Audit_Insert_Username
           ,Audit_Update_TS
           ,Audit_Update_Username
           ,INCOMPLETE_INFORMATION)
     VALUES
           (0
		,'N/S'
           ,'NOT SPECIFIED'
           ,'NOT SPECIFIED'
           ,'9999-12-31'
           ,'NOT SPECIFIED'
           ,'NOT SPECIFIED'
           ,'NOT SPECIFIED'
           ,'NOT SPECIFIED'
           ,'NOT SPECIFIED'
           ,'NOT SPECIFIED'
           ,'NOT SPECIFIED'
           ,'NOT SPECIFIED'
           ,GETDATE()
           ,'NOT SPECIFIED'
           ,NULL
           ,NULL
           ,'NO'
			)
GO

SET IDENTITY_INSERT DW.Dim_Consoles_Information OFF
GO

INSERT INTO DW.Dim_Date
           (DateKey
           ,CalendarDate
           ,CalendarDayOfYear
           ,CalendarMonthName
           ,CalendarMonthNumber
           ,CalendarQuarter
           ,CalendarSemester
           ,CalendarDayOfWeekName
           ,CalendarDayOfWeek
           ,CalendarDayOfMonth
           ,CalendarWeekOfMonth
           ,CalendarWeekOfYear
           ,CalendarYear
           ,CalendarYearMonthAsInteger
           ,CalendarYearQuarterAsInteger
           ,CalendarYearSemesterAsInteger
           ,LastDayOfCalendarMonthIndicator
           ,LastDateOfCalendarMonth
           ,HolidayIndicator
           ,WorkingDayIndicator
           ,WeekdayWeekend
           ,FiscalDate
           ,FiscalDateKey
           ,FiscalDayOfYear
           ,FiscalMonthName
           ,FiscalMonthNumber
           ,FiscalQuarter
           ,FiscalSemester
           ,FiscalDayOfWeekName
           ,FiscalDayOfWeek
           ,FiscalDayOfMonth
           ,FiscalWeekOfMonth
           ,FiscalWeekOfYear
           ,FiscalYear
           ,FiscalYearWeekAsInteger
           ,FiscalYearMonthAsInteger
           ,FiscalYearQuarterAsInteger
           ,FiscalYearSemesterAsInteger
           ,LastDayOfFiscalMonthIndicator
           ,LastDateOfFiscalMonth)
     VALUES
           (0
           ,'9999-12-31'
           ,0
           ,'NOT SPECIFIED'
           ,0
           ,0
           ,0
           ,'NOT SPECIFIED'
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,'NOT SPECIFIED'
           ,'9999-12-31'
           ,'NOT SPECIFIED'
           ,'NOT SPECIFIED'
           ,'NOT SPECIFIED'
           ,'9999-12-31'
           ,0
           ,0
           ,'NOT SPECIFIED'
           ,0
           ,0
           ,0
           ,'NOT SPECIFIED'
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,'NOT SPECIFIED'
           ,'9999-12-31')
GO

SET IDENTITY_INSERT DW.Dim_Developer ON
GO

INSERT INTO DW.Dim_Developer
           (ID_Developer
           ,Developer
           ,Audit_Insert_TS
           ,Audit_Insert_Username)
     VALUES
           (0
           ,'NOT SPECIFIED'
           ,GETDATE()
           ,'NOT SPECIFIED'
           )
GO

SET IDENTITY_INSERT DW.Dim_Developer OFF
GO

SET IDENTITY_INSERT DW.Dim_Publisher ON
GO

INSERT INTO DW.Dim_Publisher
           (ID_Publisher
           ,Publisher
           ,Audit_Insert_TS
           ,Audit_Insert_Username)
     VALUES
           (0
           ,'NOT SPECIFIED'
           ,GETDATE()
           ,'NOT SPECIFIED'
           )
GO

SET IDENTITY_INSERT DW.Dim_Publisher OFF
GO

SET IDENTITY_INSERT DW.Dim_VideoGames ON
GO

INSERT INTO DW.Dim_VideoGames
           (ID_VideoGame
           ,Game_Name
           ,Audit_Insert_TS
           ,Audit_Insert_Username)
     VALUES
           (0
           ,'NOT SPECIFIED'
           ,GETDATE()
           ,'NOT SPECIFIED'
           )
GO

SET IDENTITY_INSERT DW.Dim_VideoGames OFF
GO

---------------------------------------
--Adding foreign Keys to our FACT Table
---------------------------------------

ALTER TABLE DW.Fact_VideoGames_Sales
ADD FOREIGN KEY (ID_Console) REFERENCES DW.Dim_Consoles_Information(ID_Console);

ALTER TABLE DW.Fact_VideoGames_Sales
ADD FOREIGN KEY (ID_VideoGame) REFERENCES DW.Dim_VideoGames(ID_VideoGame);

ALTER TABLE DW.Fact_VideoGames_Sales
ADD FOREIGN KEY (ID_Publisher) REFERENCES DW.Dim_Publisher(ID_Publisher);

ALTER TABLE DW.Fact_VideoGames_Sales
ADD FOREIGN KEY (ID_Developer) REFERENCES DW.Dim_Developer(ID_Developer);

ALTER TABLE DW.Fact_VideoGames_Sales
ADD FOREIGN KEY (ID_Release_Date) REFERENCES DW.Dim_Date(DateKey);

---------------------------------------
--Adding Primary Key to our FACT Table
---------------------------------------

ALTER TABLE DW.Fact_VideoGames_Sales
ADD CONSTRAINT PK_Fact_VideoGames_Sales PRIMARY KEY (ID_VideoGame, ID_Console, ID_Publisher, ID_Developer, HASH_VALUE);
GO

---------------------------------------
--Adding Unique Keys to Dim Tables
---------------------------------------

ALTER TABLE DW.Dim_Consoles_Information
ADD CONSTRAINT UK_Consoles UNIQUE (Console_Abbreviation);
GO

ALTER TABLE DW.Dim_Developer
ADD CONSTRAINT UK_Develper UNIQUE (Developer);
GO

ALTER TABLE DW.Dim_Publisher
ADD CONSTRAINT UK_Publisher UNIQUE (Publisher);
GO

ALTER TABLE DW.Dim_VideoGames
ADD CONSTRAINT UK_VideoGames UNIQUE (Game_Name);
GO