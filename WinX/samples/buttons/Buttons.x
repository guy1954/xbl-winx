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
DECLARE FUNCTION hMain_OnClose (hWnd) ' to process $$WM_CLOSE wMsg
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
'	WinXSetMinSize (#hMain, 200, 200)

	RB1 = WinXAddRadioButton (#hMain, "Radio 1", $$TRUE, $$FALSE, $$RB1) ' create radio button $$RB1
	RB2 = WinXAddRadioButton (#hMain, "Radio 2", $$FALSE, $$FALSE, $$RB2) ' create radio button $$RB2
	RB3 = WinXAddRadioButton (#hMain, "Radio 3", $$FALSE, $$FALSE, $$RB3) ' create radio button $$RB3

	CB1 = WinXAddCheckButton (#hMain, "Check 1", $$TRUE, $$FALSE, $$CB1) ' create check box $$CB1
	CB2 = WinXAddCheckButton (#hMain, "Check 2", $$FALSE, $$FALSE, $$CB2) ' create check box $$CB2
	CB3 = WinXAddCheckButton (#hMain, "Check 3", $$FALSE, $$FALSE, $$CB3) ' create check box $$CB3
	CB_ALL = WinXAddCheckButton (#hMain, "Select All", $$FALSE, $$FALSE, $$CB_ALL) ' create check box $$CB_ALL

	'set up the layout
	'we are using three auto sizer series.
	'hMain_horiz will be a row in the main series containing two columns: checks_vert and radios_vert...

	main_series = WinXAutoSizer_GetMainSeries (#hMain)

	hMain_horiz = WinXNewAutoSizerSeries ($$DIR_HORIZ)
	WinXAutoSizer_SetSimpleInfo (hMain_horiz, main_series, 0.0, 1.0, $$SIZER_SERIES)

	checks_vert  = WinXNewAutoSizerSeries ($$DIR_VERT)
	WinXAutoSizer_SetSimpleInfo (checks_vert, hMain_horiz, 0.0, 0.5, $$SIZER_SERIES)

	radios_vert  = WinXNewAutoSizerSeries ($$DIR_VERT)
	WinXAutoSizer_SetSimpleInfo (radios_vert, hMain_horiz, 0.0, 0.5, $$SIZER_SERIES)

	'add the check buttons
	WinXAutoSizer_SetSimpleInfo (CB1, checks_vert, 0.0, 0.25, $$SIZER_FLAGS_NONE)
	WinXAutoSizer_SetSimpleInfo (CB2, checks_vert, 0.0, 0.25, $$SIZER_FLAGS_NONE)
	WinXAutoSizer_SetSimpleInfo (CB3, checks_vert, 0.0, 0.25, $$SIZER_FLAGS_NONE)
	WinXAutoSizer_SetSimpleInfo (CB_ALL, checks_vert, 0.0, 1.0, $$SIZER_SIZERELREST)

	'add the radio buttons
	WinXAutoSizer_SetSimpleInfo (RB1, radios_vert, 0.0, 0.333, $$SIZER_FLAGS_NONE)
	WinXAutoSizer_SetSimpleInfo (RB2, radios_vert, 0.0, 0.333, $$SIZER_FLAGS_NONE)
	WinXAutoSizer_SetSimpleInfo (RB3, radios_vert, 0.0, 1.0, $$SIZER_SIZERELREST)

	'select the first radio button
	WinXButton_SetCheck (GetDlgItem(#hMain, $$RB1), $$TRUE)

	'register the callbacks
	WinXRegOnCommand (#hMain, &onCommand())

	addrProc = &hMain_OnClose () ' to process $$WM_CLOSE wMsg
	WinXRegOnClose (#hMain, addrProc)

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

FUNCTION hMain_OnClose (hWnd)

'	RETURN 1 ' quit is canceled
	' quit application
	PostQuitMessage ($$WM_QUIT)
	RETURN 0 ' quit is confirmed

END FUNCTION
END PROGRAM