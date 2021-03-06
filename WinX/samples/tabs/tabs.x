'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates tab controls
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

'Define constants
$$ID_TABS = 100
$$ID_BUTTON1 = 101
$$ID_BUTTON2 = 102
$$ID_BUTTON3 = 103
$$ID_BUTTON4 = 104

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

	'quit if this fails
	IF initWindow () THEN QUIT(0)

	WinXDoEvents (0)

END FUNCTION
'
' ########################
' #####  initWindow  #####
' ########################
'
'
'
FUNCTION initWindow ()

	'Create the main window
	#hMain = WinXNewWindow (0, "Tab control demo " + WinXVersion$ (), -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)

	'Make the tab control and add it to the auto sizer
	hTabs = WinXAddTabs (#hMain, $$FALSE, $$ID_TABS)
	WinXAutoSizer_SetSimpleInfo (hTabs, -1, 0.00, 1.00, 0)
'	main_series = WinXAutoSizer_GetMainSeries (#hMain) ' get the main series
'	space# = 0.00	' first control (0%)
'	size# = 1.00	' the size of this control (100%)
'	x# = 0.00			' left margin (0%)
'	y# = 0.00			' top margin (0%)
'	w# = 0.98			' width (98%)
'	h# = 0.98			' height (98%)
'	flags = 0
'	WinXAutoSizer_SetInfo (hTabs, main_series, space#, size#, x#, y#, w#, h#, flags)

	'add some tabs
	WinXTabs_AddTab (hTabs, "Tab 1", -1)
	WinXTabs_AddTab (hTabs, "Tab 2", -1)
	WinXTabs_AddTab (hTabs, "Tab 3", -1)

	'now add some controls to those tabs
	WinXAutoSizer_SetSimpleInfo (WinXAddButton (#hMain, "Button 1", 0, $$ID_BUTTON1), WinXTabs_GetAutosizerSeries (hTabs, 0), 0, 1, 0)
	WinXAutoSizer_SetSimpleInfo (WinXAddButton (#hMain, "Button 2", 0, $$ID_BUTTON2), WinXTabs_GetAutosizerSeries (hTabs, 1), 0, 0.5, 0)
	WinXAutoSizer_SetSimpleInfo (WinXAddButton (#hMain, "Button 3", 0, $$ID_BUTTON3), WinXTabs_GetAutosizerSeries (hTabs, 1), 0, 0.5, 0)
	WinXAutoSizer_SetSimpleInfo (WinXAddButton (#hMain, "Button 4", 0, $$ID_BUTTON4), WinXTabs_GetAutosizerSeries (hTabs, 2), 0, 1, 0)

	'register the callback
	WinXRegOnCommand (#hMain, &onCommand())

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
		CASE $$ID_BUTTON1
			WinXDialog_Error ("You clicked button 1", "message", 0)
		CASE $$ID_BUTTON2
			WinXDialog_Error ("You clicked button 2", "message", 0)
		CASE $$ID_BUTTON3
			WinXDialog_Error ("You clicked button 3", "message", 0)
		CASE $$ID_BUTTON4
			WinXDialog_Error ("You clicked button 4", "message", 0)
	END SELECT

END FUNCTION
END PROGRAM
