-- =============================================
-- Author:		Matías García Palacios
-- Create date: 01/10/2023.-
-- Description:	
--
-- We will load data from SRC.Dim_Consoles_Information to the final
-- Datawarehouse entity DW.Dim_Consoles_Information.
-- It will not use the INTERMEDIATE schema, because we won't do any 
-- transformation on data. Just proceed this way:
--
-- 1) If the Consoles Abbreviation Name exists, we will update its values (even when It will always receive the same 
-- information. It's just to show the update behaviour).
-- 2) If the Consoles Abbreviation Name doesn't exist, we will insert It.
--
-- =============================================
CREATE PROCEDURE DW.SP_Load_Dim_Consoles_Information 
AS
BEGIN

	DECLARE @DATETIME_BATCH DATETIME2(7) = GETDATE() --AsIt is part of the PK, it should be the same across the whole batch

	--Updating existing values
	UPDATE OLD
	SET
       OLD.Console_Name				= NEW.Console_Name
      ,OLD.Developer				= NEW.Developer
      ,OLD.Release_Date				= NEW.Release_Date
      ,OLD.Origin_Country			= NEW.Origin_Country
      ,OLD.Generation				= NEW.Generation
      ,OLD.Type						= NEW.Type
      ,OLD.Media_Type				= NEW.Media_Type
      ,OLD.Graphics					= NEW.Graphics
      ,OLD.Online_Play				= NEW.Online_Play
      ,OLD.Predecessor				= NEW.Predecessor
      ,OLD.Successor				= NEW.Successor
      ,OLD.Audit_Update_TS			= @DATETIME_BATCH
      ,OLD.Audit_Update_Username	= 'ETL System'
      ,OLD.INCOMPLETE_INFORMATION	= NEW.INCOMPLETE_INFORMATION
	FROM
		DW.Dim_Consoles_Information OLD
		INNER JOIN INTERMEDIATE.Dim_Consoles_Information NEW ON NEW.Console_Abbreviation = OLD.Console_Abbreviation

	-- Inserting new values
	insert into DW.Dim_Consoles_Information
	  (Console_Abbreviation
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
      ,INCOMPLETE_INFORMATION)
	select
	   NEW.Console_Abbreviation
      ,NEW.Console_Name
      ,NEW.Developer
      ,NEW.Release_Date
      ,NEW.Origin_Country
      ,NEW.Generation
      ,NEW.Type
      ,NEW.Media_Type
      ,NEW.Graphics
      ,NEW.Online_Play
      ,NEW.Predecessor
      ,NEW.Successor
      ,DATEADD(SECOND, 1, @DATETIME_BATCH) AS Audit_Insert_TS
      ,'ETL System' as Audit_Insert_Username
      ,NEW.INCOMPLETE_INFORMATION
	from 
		INTERMEDIATE.Dim_Consoles_Information NEW
		LEFT JOIN DW.Dim_Consoles_Information OLD ON OLD.Console_Abbreviation = NEW.Console_Abbreviation
	WHERE
		OLD.ID_Console IS NULL --Just non existent values.
END
GO
