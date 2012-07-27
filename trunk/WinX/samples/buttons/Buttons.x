'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates check buttons and radio buttons, also more advanced use of the autosizer
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

$$RB1 = 100
$$RB2 = 101
$$RB3 = 102
$$CB1 = 103
$$CB2 = 104
$$CB3 = 105
$$CB_ALL = 106

'
DECLARE FUNCTION Entry ()
DECLARE FUNCTION initWindow ()
DECLARE FUNCTION onCommand (id, code, hWnd)
'
'
' ######################
' #####  Entry ()  #####
' ######################
'
FUNCTION Entry ()
	'make sure WinX is properly initialised
	IF WinX() THEN QUIT(0)

	'quit if either of these fail
	IF initWindow () THEN QUIT(0)

	WinXDoEvents()

	WinXCleanUp ()    ' optional cleanup
	QUIT (0)          ' stop run

END FUNCTION
'
' ########################
' #####  initWindow  #####
' ########################
'
'
'
FUNCTION initWindow ()

	'create the main window
	#hMain = WinXNewWindow (0, "Buttons Example", -1, -1, 200, 200, $$XWSS_APP, 0, 0, 0)
	WinXSetMinSize (#hMain, 160, 160)

	'set up the layout
	'we are using three auto sizer series.
	'row will be a row in the main series containing two columns: checks and radios...
	row = WinXNewAutoSizerSeries ($$DIR_HORIZ)
	checks = WinXNewAutoSizerSeries ($$DIR_VERT)
	radios = WinXNewAutoSizerSeries ($$DIR_VERT)

	'organise the series into this order
	WinXAutoSizer_SetInfo (row, WinXAutoSizer_GetMainSeries(#hMain), 50, 1.0, 0, 0, 1.0, 1.0, $$SIZER_SERIES)
	WinXAutoSizer_SetInfo (checks, row, 0, 0.5, -1, 0, 60, 1.0, $$SIZER_SERIES)
	WinXAutoSizer_SetInfo (radios, row, 0, 0.5, -1, 0, 60, 1.0, $$SIZER_SERIES)

	'add the check buttons
	WinXAutoSizer_SetInfo (WinXAddCheckButton (#hMain, "Check 1", $$TRUE, $$FALSE, $$CB1), checks, 0, 25, 0, 0, 1.0, 1.0, 0)
	WinXAutoSizer_SetInfo (WinXAddCheckButton (#hMain, "Check 2", $$FALSE, $$FALSE, $$CB2), checks, 0, 25, 0, 0, 1.0, 1.0, 0)
	WinXAutoSizer_SetInfo (WinXAddCheckButton (#hMain, "Check 3", $$FALSE, $$FALSE, $$CB3), checks, 0, 25, 0, 0, 1.0, 1.0, 0)
	WinXAutoSizer_SetInfo (WinXAddCheckButton (#hMain, "Select All", $$FALSE, $$FALSE, $$CB_ALL), checks, 0, 25, 0, 0, 1.0, 1.0, 0)

	'add the radio buttons
	WinXAutoSizer_SetInfo (WinXAddRadioButton (#hMain, "Radio 1", $$TRUE, $$FALSE, $$RB1), radios, 0, 25, 0, 0, 1.0, 1.0, 0)
	WinXAutoSizer_SetInfo (WinXAddRadioButton (#hMain, "Radio 2", $$FALSE, $$FALSE, $$RB2), radios, 0, 25, 0, 0, 1.0, 1.0, 0)
	WinXAutoSizer_SetInfo (WinXAddRadioButton (#hMain, "Radio 3", $$FALSE, $$FALSE, $$RB3), radios, 0, 25, 0, 0, 1.0, 1.0, 0)

	'select the first radio button
	WinXButton_SetCheck (GetDlgItem(#hMain, $$RB1), $$TRUE)

	'register the callbacks
	WinXRegOnCommand (#hMain, &onCommand())

	'This function enables the use of the tab and arrow keys to navigate the window.
	'it comes at the expense of the ability to process these keypresses.
	WinXEnableDialogInterface(#hMain, $$TRUE)

	WinXDisplay (#hMain)

	RETURN 0
END FUNCTION
'
' #######################
' #####  onCommand  #####
' #######################
'
'
'
FUNCTION onCommand (id, code, hWnd)

	SELECT CASE id
		'insert cases for your ids here.
		CASE $$CB_ALL
			'select every checkbox
			IF WinXButton_GetCheck (hWnd) THEN check = $$TRUE ELSE check = $$FALSE
			WinXButton_SetCheck (GetDlgItem(#hMain, $$CB1), check)
			WinXButton_SetCheck (GetDlgItem(#hMain, $$CB2), check)
			WinXButton_SetCheck (GetDlgItem(#hMain, $$CB3), check)
	END SELECT

END FUNCTION
END PROGRAM