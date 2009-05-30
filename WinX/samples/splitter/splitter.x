'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates splitters and the new onClose callback FUNCTION
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
DECLARE FUNCTION Entry ()
DECLARE FUNCTION initWindow ()
DECLARE FUNCTION onClose (hWnd)
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
	#hMain = WinXNewWindow (0, "WinX Splitter demo", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)
	
	' Create the right pane
	vertical = WinXNewAutoSizerSeries ($$DIR_VERT|$$DIR_REVERSE)
	' Note the use of the splitter flag to create a splitter
	' Also notice the use of WinXAutoSizer_SetSimpleInfo to reduce parameters
	hEdBottomRight = WinXAddEdit (#hMain, "Bottom right", $$ES_MULTILINE|$$WS_HSCROLL|$$WS_VSCROLL, 0)
	hEdTopRight = WinXAddEdit (#hMain, "Top right", $$ES_MULTILINE|$$WS_HSCROLL|$$WS_VSCROLL, 0)
	WinXAutoSizer_SetSimpleInfo (hEdBottomRight, vertical, 0, 100, $$SIZER_SPLITTER)
	WinXAutoSizer_SetSimpleInfo (hEdTopRight, vertical, 0, 1, $$SIZER_SIZERELREST)
	
	' Now for the left pane
	horizontal = WinXNewAutoSizerSeries ($$DIR_HORIZ)
	hEdLeft = WinXAddEdit (#hMain, "Left", $$ES_MULTILINE|$$WS_HSCROLL|$$WS_VSCROLL, 0)
	WinXAutoSizer_SetSimpleInfo (hEdLeft, horizontal, 0, 100, $$SIZER_SPLITTER)
	WinXAutoSizer_SetSimpleInfo (vertical, horizontal, 0, 1, $$SIZER_SIZERELREST|$$SIZER_SERIES)
	
	' And finnaly add them to the main series
	WinXAutoSizer_SetSimpleInfo (horizontal, WinXAutoSizer_GetMainSeries (#hMain), 0, 1, $$SIZER_SERIES)
	
	' set the minimum ranges and make the left splitter dockable
	WinXSplitter_SetProperties (vertical, hEdBottomRight, 48, 200, $$FALSE)
	WinXSplitter_SetProperties (horizontal, hEdLeft, 48, 200, $$TRUE)
	
	'remember to register callbacks
	WinXRegOnClose (#hMain, &onClose())
	
	WinXDisplay (#hMain)
	
	RETURN 0
END FUNCTION
'
' #####################
' #####  onClose  #####
' #####################
' A callback for when the user attempts to close the window
'
'
FUNCTION onClose (hWnd)
	' Make sure the user really wanted to quit
	IF MessageBoxA (#hMain, &"Really quit?", &"Question", $$MB_YESNO|$$MB_ICONQUESTION) = $$IDYES THEN
		' This causes WinXDoEvents to return
		PostQuitMessage (0)
	END IF
END FUNCTION
END PROGRAM