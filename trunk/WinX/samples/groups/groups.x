'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates group boxes
'
' This program is in the public domain
'
VERSION	"0.0000"
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
	
'
$$RB1 = 100
$$RB2 = 101
$$RB3 = 102
$$CHK1 = 103
$$CHK2 = 104
$$CHK3 = 105


DECLARE FUNCTION Entry ()
DECLARE FUNCTION initWindow ()
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
	
	'create the main window
	#hMain = WinXNewWindow (0, "Group Box demo", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)
	
	'the window will have two group boxes
	hGB = WinXAddGroupBox (#hMain, "Some radio buttons", 0)
	series1 = WinXGroupBox_GetAutosizerSeries (hGB)	'get the auto sizer series associate with the group box
	'the x, y, w, h and flags parameters are used so the group box isn't drawn too close to the window frame
	WinXAutoSizer_SetInfo (hGB, -1, 0, 0.5, 2, 0, 4, 2, $$SIZER_WCOMPLEMENT|$$SIZER_HCOMPLEMENT)
	
	'do the same thing for the next group box
	hGB = WinXAddGroupBox (#hMain, "Some check boxes", 0)
	series2 = WinXGroupBox_GetAutosizerSeries (hGB)
	WinXAutoSizer_SetInfo (hGB, -1, 0, 0.5, 2, 0, 4, 2, $$SIZER_WCOMPLEMENT|$$SIZER_HCOMPLEMENT)
	
	'add some radio buttons to the first series
	third# = 1.0/3.0
	WinXAutoSizer_SetInfo (WinXAddRadioButton (#hMain, "Radio 1", $$TRUE, $$FALSE, $$RB1), series1, 0, third#, 0, -1, 1.0, 22, 0)
	WinXAutoSizer_SetInfo (WinXAddRadioButton (#hMain, "Radio 2", $$FALSE, $$FALSE, $$RB2), series1, 0, third#, 0, -1, 1.0, 22, 0)
	WinXAutoSizer_SetInfo (WinXAddRadioButton (#hMain, "Radio 3", $$FALSE, $$FALSE, $$RB3), series1, 0, third#, 0, -1, 1.0, 22, 0)
	
	'and some checks to the second
	WinXAutoSizer_SetInfo (WinXAddCheckButton (#hMain, "check 1", $$TRUE, $$FALSE, $$CHK1), series2, 0, third#, 0, -1, 1.0, 22, 0)
	WinXAutoSizer_SetInfo (WinXAddCheckButton (#hMain, "check 2", $$FALSE, $$FALSE, $$CHK2), series2, 0, third#, 0, -1, 1.0, 22, 0)
	WinXAutoSizer_SetInfo (WinXAddCheckButton (#hMain, "check 3", $$FALSE, $$FALSE, $$CHK3), series2, 0, third#, 0, -1, 1.0, 22, 0)
	
	'remember to register callbacks
	WinXEnableDialogInterface (#hMain, $$TRUE)
	
	WinXDisplay (#hMain)
	
	RETURN 0
END FUNCTION
END PROGRAM