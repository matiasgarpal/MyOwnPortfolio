CREATE VIEW DW.VW_Dim_Release_Date
as
SELECT DateKey							  AS	Last_Update_DateDateKey
      ,CalendarDate						  AS	Last_Update_DateCalendarDate
      ,CalendarDayOfYear				  AS	Last_Update_DateCalendarDayOfYear
      ,CalendarMonthName				  AS	Last_Update_DateCalendarMonthName
      ,CalendarMonthNumber				  AS	Last_Update_DateCalendarMonthNumber
      ,CalendarQuarter					  AS	Last_Update_DateCalendarQuarter
      ,CalendarSemester					  AS	Last_Update_DateCalendarSemester
      ,CalendarDayOfWeekName			  AS	Last_Update_DateCalendarDayOfWeekName
      ,CalendarDayOfWeek				  AS	Last_Update_DateCalendarDayOfWeek
      ,CalendarDayOfMonth				  AS	Last_Update_DateCalendarDayOfMonth
      ,CalendarWeekOfMonth				  AS	Last_Update_DateCalendarWeekOfMonth
      ,CalendarWeekOfYear				  AS	Last_Update_DateCalendarWeekOfYear
      ,CalendarYear						  AS	Last_Update_DateCalendarYear
      ,CalendarYearMonthAsInteger		  AS	Last_Update_DateCalendarYearMonthAsInteger
      ,CalendarYearQuarterAsInteger		  AS	Last_Update_DateCalendarYearQuarterAsInteger
      ,CalendarYearSemesterAsInteger	  AS	Last_Update_DateCalendarYearSemesterAsInteger
      ,LastDayOfCalendarMonthIndicator	  AS	Last_Update_DateLastDayOfCalendarMonthIndicator
      ,LastDateOfCalendarMonth			  AS	Last_Update_DateLastDateOfCalendarMonth
      ,HolidayIndicator					  AS	Last_Update_DateHolidayIndicator
      ,WorkingDayIndicator				  AS	Last_Update_DateWorkingDayIndicator
      ,WeekdayWeekend					  AS	Last_Update_DateWeekdayWeekend
      ,FiscalDate						  AS	Last_Update_DateFiscalDate
      ,FiscalDateKey					  AS	Last_Update_DateFiscalDateKey
      ,FiscalDayOfYear					  AS	Last_Update_DateFiscalDayOfYear
      ,FiscalMonthName					  AS	Last_Update_DateFiscalMonthName
      ,FiscalMonthNumber				  AS	Last_Update_DateFiscalMonthNumber
      ,FiscalQuarter					  AS	Last_Update_DateFiscalQuarter
      ,FiscalSemester					  AS	Last_Update_DateFiscalSemester
      ,FiscalDayOfWeekName				  AS	Last_Update_DateFiscalDayOfWeekName
      ,FiscalDayOfWeek					  AS	Last_Update_DateFiscalDayOfWeek
      ,FiscalDayOfMonth					  AS	Last_Update_DateFiscalDayOfMonth
      ,FiscalWeekOfMonth				  AS	Last_Update_DateFiscalWeekOfMonth
      ,FiscalWeekOfYear					  AS	Last_Update_DateFiscalWeekOfYear
      ,FiscalYear						  AS	Last_Update_DateFiscalYear
      ,FiscalYearWeekAsInteger			  AS	Last_Update_DateFiscalYearWeekAsInteger
      ,FiscalYearMonthAsInteger			  AS	Last_Update_DateFiscalYearMonthAsInteger
      ,FiscalYearQuarterAsInteger		  AS	Last_Update_DateFiscalYearQuarterAsInteger
      ,FiscalYearSemesterAsInteger		  AS	Last_Update_DateFiscalYearSemesterAsInteger
      ,LastDayOfFiscalMonthIndicator	  AS	Last_Update_DateLastDayOfFiscalMonthIndicator
      ,LastDateOfFiscalMonth			  AS	Last_Update_DateLastDateOfFiscalMonth
  FROM 
    VideoGames_Sales.DW.Dim_Date
  WHERE 
	DATEKEY <> 0