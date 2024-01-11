-- =============================================
-- Author:		Matías García Palacios
-- Create date: 01/09/2023.-
-- Description:	
--
-- We will load data from SRC.Dim_Consoles_Information to the INTERMEDIATE
-- table INTERMEDIATE.Dim_Consoles_Information.
-- Just proceed this way:
--
-- 1) Consoles Names modified by ChatGPT are already loaded on INTERMEDIATE.Dim_Consoles_Information 
-- 2) We will just load Consoles Abbreviations from VGZChart that we don't (Specifying that the row's information is incomplete)
-- already have in the intermediate table.
-- This means, for these mentioned values we will only have Abbreviation only, not the whole information.
-- 3) Once we loaded those rows, we are able to load the Final entity DW.Dim_Consoles_Information 
-- using the SP: DW.SP_Load_Dim_Consoles_Information
--
-- =============================================
CREATE PROCEDURE DW.SP_Load_INTERMEDIATE_Dim_Consoles_Information 
AS
BEGIN

	-- Inserting new values only
	insert into INTERMEDIATE.Dim_Consoles_Information
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
      ,INCOMPLETE_INFORMATION)
	select
		 NEW.Console_Abbreviation
		,'NOT SPECIFIED' Console_Name
		,'NOT SPECIFIED' Developer
		,'9999-01-01' Release_Date
		,'NOT SPECIFIED' Origin_Country
		,'NOT SPECIFIED' Generation
		,'NOT SPECIFIED' Type
		,'NOT SPECIFIED' Media_Type
		,'NOT SPECIFIED' Graphics
		,'NOT SPECIFIED' Online_Play
		,'NOT SPECIFIED' Predecessor
		,'NOT SPECIFIED' Successor
		,'YES' INCOMPLETE_INFORMATION
	from 
		SRC.Dim_Console NEW
		left join INTERMEDIATE.Dim_Consoles_Information OLD ON OLD.Console_Abbreviation = NEW.Console_Abbreviation
	WHERE
		OLD.Console_Abbreviation IS NULL --Just non existent values.

END
GO
