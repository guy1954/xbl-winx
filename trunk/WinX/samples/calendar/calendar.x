'
' ####################
' #####  PROLOG  #####
' ####################
'
' A program to demonstrate calendars and time pickers
'
' This program is in the public domain
'
VERSION	"1.00"
'
	IMPORT	"xst"   		' standard library	: required by most programs
'	IMPORT  "xsx"				' extended std library
'	IMPORT	"xio"				' console io library
	IMPORT	"gdi32"     ' gdi32.dll
	IMPORT  "user32"    ' user32.dll
	IMPORT  "kernel32"  ' kernel32.dll
	IMPORT  "comctl32"	' comctl32.dll			: common controls library
'	IMPORT	"comdlg32"  ' comdlg32.dll	    : common dialog library
'	IMPORT	"xma"   		' math library			: Sin/Asin/Sinh/Asinh/Log/Exp/Sqrt...
'	IMPORT	"xcm"				' complex math library
'	IMPORT  "msvcrt"		' msvcrt.dll				: C function library
'	IMPORT  "shell32"   ' shell32.dll
	IMPORT	"WinX"			' The Xwin GUI library

' constants for the controls
$$ID_CALENDAR = 100
$$ID_DTP = 101

DECLARE FUNCTION Entry ()
DECLARE FUNCTION initWindow ()
DECLARE FUNCTION onCalendarSelect (idControl, SYSTEMTIME time)
'
'
' ######################
' #####  Entry ()  #####
' ######################
'
FUNCTION Entry ()
	'make sure WinX is properly initialised
	IF WinX() THEN QUIT(0)

	'quit if this fails
	IF initWindow () THEN QUIT(0)

	WinXDoEvents ()
END FUNCTION
'
' ########################
' #####  initWindow  #####
' ########################
'
'
'
FUNCTION initWindow ()
	SYSTEMTIME time

	' Create the main window
	#hMain = WinXNewWindow (0, "Calendar example", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)

	' Make a calendar control
	monthsX = 1
	monthsY = 1
	hCal = WinXAddCalendar (#hMain, @monthsX, @monthsY, $$ID_CALENDAR)

	' Make a time picker control initialised to the current time
	GetLocalTime (&time)
	hDTP = WinXAddTimePicker (#hMain, $$DTS_SHORTDATEFORMAT, time, $$TRUE, $$ID_DTP)

	' Set the auto sizer info so the controls are centered with fixed size
	hInnerSeries = WinXNewAutoSizerSeries ($$DIR_VERT)
	WinXAutoSizer_SetInfo (hCal, hInnerSeries, 0, monthsY, -1, 0, monthsX, 1.0, 0)
	WinXAutoSizer_SetInfo (hDTP, hInnerSeries, 2, 24, -1, 0, 100, 1.0, 0)
	WinXAutoSizer_SetInfo (hInnerSeries, WinXAutoSizer_GetMainSeries (#hMain), 0, 1.0, -1, -1, monthsX, monthsY+26, $$SIZER_SERIES)

	'remember to register callbacks
	WinXRegOnCalendarSelect (#hMain, &onCalendarSelect())

	WinXDisplay (#hMain)

	RETURN 0
END FUNCTION
'
' ##############################
' #####  onCalendarSelect  #####
' ##############################
'
FUNCTION onCalendarSelect (idControl, SYSTEMTIME time)
	WinXTimePicker_SetTime (GetDlgItem (#hMain, $$ID_DTP), time, $$TRUE)
END FUNCTION
END PROGRAM