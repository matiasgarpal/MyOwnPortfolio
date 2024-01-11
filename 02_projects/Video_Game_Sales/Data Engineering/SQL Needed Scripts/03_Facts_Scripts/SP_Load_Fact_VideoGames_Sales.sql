-- =============================================
-- Author:		Matías García Palacios
-- Create date: 01/10/2023.-
-- Description:	
--
-- We will load data from INTERMEDIATE.Fact_Internet_Sales to the final
-- Datawarehouse entity DW.Fact_Internet_Sales.
-- Instead of updating existing records to update their update date, scores or sales data
-- changes, or deleting them to load the newest values, we will just flag them as "NON CURRENT VERSION",
-- setting existing records with 'NON CURRENT VERSION' on the "IS_CURRENT_VERSION" flag, and 'CURRENT VERSION' on the new added records.
-- Obviously, we could use a flag like with 1|0 values, but Kimball recommends to avoid those practices.
-- Doing this, in a future we will be able to follow videogames sales/score evolution across time.
--
-- =============================================
CREATE PROCEDURE DW.SP_Load_Fact_VideoGames_Sales 
AS
BEGIN

	DECLARE @DATETIME_BATCH DATETIME2(7) = GETDATE() --AsIt is part of the PK, it should be the same across the whole batch

	--Inserting Modified Records Only records.
	--This means:
	--If a record with SAME PRIMARY KEY and SAME HASH VALUE EXISTS, WE WON'T DO ANYTHING
	--If a record WITH SAME PRIMARY KEY and DIFFERENT HASH VALUE EXISTS, WE INSERT THE NEW  ONE
	--If a record with the arriving primary key doesn't exist as a current version, we insert It.
	INSERT INTO DW.Fact_VideoGames_Sales 
	(
	   ID_VideoGame
      ,ID_Console
      ,ID_Publisher
      ,ID_Developer
      ,VGChartz_Score
      ,Critic_Score
      ,User_Score
      ,Total_Shipped
      ,Total_Sales
      ,NA_Sales
      ,PAL_Sales
      ,Japan_Sales
      ,Other_Sales
      ,ID_Release_Date
      ,Last_Update
      ,HASH_VALUE
      ,Audit_Insert_TS
      ,Audit_Insert_Username
      ,Audit_Update_TS
      ,Audit_Update_Username
      ,IS_CURRENT_VERSION
	)
	SELECT
		 NEW.ID_VideoGame
		,NEW.ID_Console
		,NEW.ID_Publisher
		,NEW.ID_Developer
		,NEW.VGChartz_Score
		,NEW.Critic_Score
		,NEW.User_Score
		,NEW.Total_Shipped
		,NEW.Total_Sales
		,NEW.NA_Sales
		,NEW.PAL_Sales
		,NEW.Japan_Sales
		,NEW.Other_Sales
		,NEW.ID_Release_Date
		,NEW.Last_Update
		,NEW.HASH_VALUE
		,@DATETIME_BATCH Audit_Insert_TS
		,'ETL System' Audit_Insert_Username
		,NULL Audit_Update_TS
		,NULL Audit_Update_Username
		,'CURRENT VERSION' IS_CURRENT_VERSION
	FROM
		INTERMEDIATE.Fact_VideoGames_Sales NEW
		LEFT JOIN DW.Fact_VideoGames_Sales OLD
		ON  NEW.ID_Console   =   OLD.ID_Console  
		AND NEW.ID_Developer = 	 OLD.ID_Developer
		AND NEW.ID_Publisher = 	 OLD.ID_Publisher
		AND NEW.ID_VideoGame = 	 OLD.ID_VideoGame
		AND NEW.HASH_VALUE   =  OLD.HASH_VALUE
		AND OLD.IS_CURRENT_VERSION = 'CURRENT VERSION' 
	WHERE
		OLD.HASH_VALUE IS NULL --We need a field that will never be null, otherwise, logic will fail.


	-- Setting Existing CURRENT records as NON CURRENT (only those videogames that arrive
	-- on the current refresh, AND ACTUALLY HAVE CHANGES)
	UPDATE OLD
	SET
		Audit_Update_TS = DATEADD(SECOND, 1, @DATETIME_BATCH)
		,Audit_Update_Username = 'ETL System'
		,IS_CURRENT_VERSION = 'NON CURRENT VERSION'
	FROM
		DW.Fact_VideoGames_Sales OLD
		INNER JOIN INTERMEDIATE.Fact_VideoGames_Sales NEW
		ON  NEW.ID_Console   =   OLD.ID_Console  
		AND NEW.ID_Developer = 	 OLD.ID_Developer
		AND NEW.ID_Publisher = 	 OLD.ID_Publisher
		AND NEW.ID_VideoGame = 	 OLD.ID_VideoGame
		AND NEW.HASH_VALUE   <>  OLD.HASH_VALUE
	WHERE 
		OLD.IS_CURRENT_VERSION = 'CURRENT VERSION' --To avoid scaning the whole table.

END
GO
