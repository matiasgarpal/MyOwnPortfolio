CREATE VIEW DW.VW_Last_Refresh_Date
AS
SELECT
	DATEADD(HOUR, -3, GETUTCDATE()) AS Last_PBI_Refresh_UTC3,
	DATEADD(HOUR, -5, GETUTCDATE()) AS Last_PBI_Refresh_UTC5,
	max(audit_insert_ts) AS Last_DW_Refresh_UTC3,
	DATEADD(HOUR, -2, max(audit_insert_ts))  AS Last_DW_Refresh_UTC5
from
	DW.Fact_VideoGames_Sales