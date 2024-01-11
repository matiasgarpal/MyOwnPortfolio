-- =============================================
-- Author:		Matías García Palacios
-- Create date: 01/09/2023.-
-- Description:	
--
-- We will load data from SRC.Dim_VideoGames to the final
-- Datawarehouse entity DW.Dim_VideoGames.
-- It will not use the INTERMEDIATE schema, because we won't do any 
-- transformation on data. Just proceed this way:
--
-- 1) If the VideoGames Name exists, we won't insert/modify It.
-- 2) If the VideoGames Name doesn't exist, we will insert It.
--
-- =============================================
CREATE PROCEDURE DW.SP_Load_Dim_VideoGames 
AS
BEGIN

	DECLARE @DATETIME_BATCH DATETIME2(7) = GETDATE() --AsIt is part of the PK, it should be the same across the whole batch

	-- Inserting new values only
	insert into DW.Dim_VideoGames
	(Game_Name, Audit_Insert_TS, Audit_Insert_Username)
	select
	NEW.Game_Name,
	@DATETIME_BATCH as Audit_Insert_TS,
	'ETL System' as Audit_Insert_Username
	from 
		SRC.Dim_VideoGames NEW
		left join DW.Dim_VideoGames OLD ON OLD.Game_Name = NEW.Game_Name
	WHERE
		OLD.ID_VideoGame IS NULL --Just non existent values.
END
GO
