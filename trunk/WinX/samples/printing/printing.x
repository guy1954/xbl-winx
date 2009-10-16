'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates simple printing
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

'
DECLARE FUNCTION Entry ()
DECLARE FUNCTION initWindow ()
DECLARE FUNCTION cleanUp ()
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

	WinXDoEvents ()

	cleanUp ()

END FUNCTION
'
' ########################
' #####  initWindow  #####
' ########################
'
'
'
FUNCTION initWindow ()
	' Create a window to print from, this will never actually be displayed
	#hMain = WinXNewWindow (0, "Printing", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)

	'Create some graphics to print
	#hPen = CreatePen ($$PS_SOLID, 4, 0)
	WinXDrawLine (#hMain, #hPen, 4, 4, 396, 296)
	WinXDrawLine (#hMain, #hPen, 396, 4, 4, 296)
	WinXDrawRect (#hMain, #hPen, 4, 4, 396, 296)

	'display the print configuration dialogs
	'if the user cancels the page setup dialog, we're done
	IF WinXPrint_PageSetup (0)
		rangeMin = 1
		rangeMax = -1	'all pages will be the default
		hPrinter = WinXPrint_Start (1, 1, @rangeMin, @rangeMax, @cxPhys, @cyPhys, "WinX Print Test", $$TRUE, 0)
		'print the image, maintaining the aspect ratio
		WinXPrint_Page (hPrinter, #hMain, 0, 0, 400, 300, cxPhys, XLONG(300.0/400.0*DOUBLE(cxPhys)), 1, 1)
		'must call this once printing is done
		WinXPrint_Done (hPrinter)
	END IF

	PostQuitMessage (0)

	RETURN 0
END FUNCTION
'
' #####################
' #####  cleanUp  #####
' #####################
'
'
'
FUNCTION cleanUp ()
	'Clean up uneeded resources
	DeleteObject (#hPen)
END FUNCTION
END PROGRAM