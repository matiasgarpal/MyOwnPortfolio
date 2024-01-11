-- =============================================
-- Author:		Matías García Palacios
-- Create date: 01/10/2023.-
-- Description:	
--
-- We will load data from SRC.Fact_VideoGames_Sales to the INTERMEDIATE
-- table INTERMEDIATE.Fact_VideoGames_Sales, making every needed transformation and
-- getting foreign keys. (It's the last table loaded, so, every other dimension will be 
-- already loaded)
--
-- =============================================
CREATE PROCEDURE DW.SP_Load_INTERMEDIATE_Fact_VideoGames_Sales 
AS
BEGIN

	--Truncating last load values
	TRUNCATE TABLE INTERMEDIATE.Fact_VideoGames_Sales;

	-- Inserting new values only
	insert into INTERMEDIATE.Fact_VideoGames_Sales
	(ID_VideoGame
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
      ,HASH_VALUE)
	SELECT 
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
	  FROM (
	select
		 COALESCE(VIDEOGAMES.ID_VideoGame,0) ID_VideoGame
		,COALESCE(CONSOLES.ID_Console,0)     ID_Console
		,COALESCE(PUBLISHER.ID_Publisher,0)  ID_Publisher
		,COALESCE(DEVELOPER.ID_Developer,0)  ID_Developer
		,VGChartz_Score
		,Critic_Score
		,User_Score
		,Total_Shipped
		,Total_Sales
		,NA_Sales
		,PAL_Sales
		,Japan_Sales
		,Other_Sales
		,COALESCE(DDATE.DateKey,0) ID_Release_Date
		,Last_Update
		,HASHBYTES('SHA1',
		CONCAT( 
		 COALESCE(VIDEOGAMES.ID_VideoGame,0)
		,COALESCE(CONSOLES.ID_Console,0)    
		,COALESCE(PUBLISHER.ID_Publisher,0) 
		,COALESCE(DEVELOPER.ID_Developer,0) 
		,VGChartz_Score
		,Critic_Score
		,User_Score
		,Total_Shipped
		,Total_Sales
		,NA_Sales
		,PAL_Sales
		,Japan_Sales
		,Other_Sales)) HASH_VALUE, --To identify data with changing values
		ROW_NUMBER() OVER (PARTITION BY 
		 COALESCE(VIDEOGAMES.ID_VideoGame,0)
		,COALESCE(CONSOLES.ID_Console,0)    
		,COALESCE(PUBLISHER.ID_Publisher,0) 
		,COALESCE(DEVELOPER.ID_Developer,0) 
		ORDER BY Last_Update DESC) RN --We detected some duplicates on the source data. FOR EXAMPLE: NIGHTS OF AZURE for PSV
	from 
		SRC.Fact_VideoGames_Sales FACT
		left join DW.Dim_VideoGames VIDEOGAMES ON VIDEOGAMES.Game_Name = FACT.GameName
		left join DW.Dim_Consoles_Information CONSOLES ON CONSOLES.Console_Abbreviation = FACT.Console
		left join DW.Dim_Publisher PUBLISHER ON PUBLISHER.Publisher = FACT.Publisher
		left join DW.Dim_Developer DEVELOPER ON DEVELOPER.Developer = FACT.Developer
		left join DW.Dim_Date DDATE ON DDATE.CalendarDate = FACT.Release_Date
	) FACT
	WHERE
		RN = 1 --TO GET THE LATEST RECORD FROM SOURCE

END
GO
