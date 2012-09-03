'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates the animation control
'
' This program is in the public domain.
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

'define constants
$$ID_ANIMATE = 100

'
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

	'quit if either of these fail
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
	SECURITY_ATTRIBUTES sa
	'this is where you create and initialise your window

	#hMain = WinXNewWindow (0, "Animation Example", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)

	'for this small example, we don't need to use the autosizer
	MoveWindow (WinXAddAnimation (#hMain, "x.avi", $$ID_ANIMATE), 10, 10, 100, 100, $$TRUE)

	'start playing the animation
	WinXAni_Play(GetDlgItem (#hMain, $$ID_ANIMATE))

	WinXDisplay (#hMain)

	RETURN 0
END FUNCTION

END PROGRAM