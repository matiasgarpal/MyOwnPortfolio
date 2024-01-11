-- =============================================
-- Author:		Matías García Palacios
-- Create date: 01/09/2023.-
-- Description:	
--
-- We will load data from SRC.Dim_Publisher to the final
-- Datawarehouse entity DW.Dim_Publisher.
-- It will not use the INTERMEDIATE schema, because we won't do any 
-- transformation on data. Just proceed this way:
--
-- 1) If the Publisher Name exists, we won't insert/modify It.
-- 2) If the Publisher Name doesn't exist, we will insert It.
--
-- =============================================
CREATE PROCEDURE DW.SP_Load_Dim_Publisher 
AS
BEGIN

	DECLARE @DATETIME_BATCH DATETIME2(7) = GETDATE() --AsIt is part of the PK, it should be the same across the whole batch

	-- Inserting new values only
	insert into DW.Dim_Publisher
	(Publisher, Audit_Insert_TS, Audit_Insert_Username)
	select
	NEW.Publisher,
	@DATETIME_BATCH as Audit_Insert_TS,
	'ETL System' as Audit_Insert_Username
	from 
		SRC.Dim_Publisher NEW
		left join DW.Dim_Publisher OLD ON OLD.Publisher = NEW.Publisher
	WHERE
		OLD.ID_Publisher IS NULL --Just non existent values.
END
GO
