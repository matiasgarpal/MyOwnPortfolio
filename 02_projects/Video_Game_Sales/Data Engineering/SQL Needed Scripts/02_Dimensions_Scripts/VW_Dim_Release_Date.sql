CREATE VIEW DW.VW_Dim_Release_Date
as
SELECT DateKey							  AS	Release_Date_DateKey
      ,CalendarDate						  AS	Release_Date_CalendarDate
      ,CalendarDayOfYear				  AS	Release_Date_CalendarDayOfYear
      ,CalendarMonthName				  AS	Release_Date_CalendarMonthName
      ,CalendarMonthNumber				  AS	Release_Date_CalendarMonthNumber
      ,CalendarQuarter					  AS	Release_Date_CalendarQuarter
      ,CalendarSemester					  AS	Release_Date_CalendarSemester
      ,CalendarDayOfWeekName			  AS	Release_Date_CalendarDayOfWeekName
      ,CalendarDayOfWeek				  AS	Release_Date_CalendarDayOfWeek
      ,CalendarDayOfMonth				  AS	Release_Date_CalendarDayOfMonth
      ,CalendarWeekOfMonth				  AS	Release_Date_CalendarWeekOfMonth
      ,CalendarWeekOfYear				  AS	Release_Date_CalendarWeekOfYear
      ,CalendarYear						  AS	Release_Date_CalendarYear
      ,CalendarYearMonthAsInteger		  AS	Release_Date_CalendarYearMonthAsInteger
      ,CalendarYearQuarterAsInteger		  AS	Release_Date_CalendarYearQuarterAsInteger
      ,CalendarYearSemesterAsInteger	  AS	Release_Date_CalendarYearSemesterAsInteger
      ,LastDayOfCalendarMonthIndicator	  AS	Release_Date_LastDayOfCalendarMonthIndicator
      ,LastDateOfCalendarMonth			  AS	Release_Date_LastDateOfCalendarMonth
      ,HolidayIndicator					  AS	Release_Date_HolidayIndicator
      ,WorkingDayIndicator				  AS	Release_Date_WorkingDayIndicator
      ,WeekdayWeekend					  AS	Release_Date_WeekdayWeekend
      ,FiscalDate						  AS	Release_Date_FiscalDate
      ,FiscalDateKey					  AS	Release_Date_FiscalDateKey
      ,FiscalDayOfYear					  AS	Release_Date_FiscalDayOfYear
      ,FiscalMonthName					  AS	Release_Date_FiscalMonthName
      ,FiscalMonthNumber				  AS	Release_Date_FiscalMonthNumber
      ,FiscalQuarter					  AS	Release_Date_FiscalQuarter
      ,FiscalSemester					  AS	Release_Date_FiscalSemester
      ,FiscalDayOfWeekName				  AS	Release_Date_FiscalDayOfWeekName
      ,FiscalDayOfWeek					  AS	Release_Date_FiscalDayOfWeek
      ,FiscalDayOfMonth					  AS	Release_Date_FiscalDayOfMonth
      ,FiscalWeekOfMonth				  AS	Release_Date_FiscalWeekOfMonth
      ,FiscalWeekOfYear					  AS	Release_Date_FiscalWeekOfYear
      ,FiscalYear						  AS	Release_Date_FiscalYear
      ,FiscalYearWeekAsInteger			  AS	Release_Date_FiscalYearWeekAsInteger
      ,FiscalYearMonthAsInteger			  AS	Release_Date_FiscalYearMonthAsInteger
      ,FiscalYearQuarterAsInteger		  AS	Release_Date_FiscalYearQuarterAsInteger
      ,FiscalYearSemesterAsInteger		  AS	Release_Date_FiscalYearSemesterAsInteger
      ,LastDayOfFiscalMonthIndicator	  AS	Release_Date_LastDayOfFiscalMonthIndicator
      ,LastDateOfFiscalMonth			  AS	Release_Date_LastDateOfFiscalMonth
  FROM 
    VideoGames_Sales.DW.Dim_Date
  WHERE 
	DATEKEY <> 0