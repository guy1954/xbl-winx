'
' ####################
' #####  PROLOG  #####
' ####################
'
' An WinX GUI program
'
VERSION	"0.0000"

	$$PI				= 0d400921FB54442D18
	$$TWOPI			= 0d401921FB54442D18
	$$PI3DIV2		= 0d4012D97C7F3321D2
	$$PIDIV2		= 0d3FF921FB54442D18
	$$PIDIV4		= 0d3FE921FB54442D18
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
DECLARE FUNCTION initApp ()
DECLARE FUNCTION initWindow ()
DECLARE FUNCTION cleanUp ()
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
  IF initApp () THEN QUIT(0)
	IF initWindow () THEN QUIT(0)

	WinXDoEvents ()

	cleanUp ()

END FUNCTION
'
' #####################
' #####  initApp  #####
' #####################
'
'
'
FUNCTION initApp ()
	'Your initilialisation code goes here
	'eg, initialising global data structures, reading registry settings, loading files...

	RETURN 0
END FUNCTION
'
' ########################
' #####  initWindow  #####
' ########################
'
'
'
FUNCTION initWindow ()
	'this is where you create and initialise your window

	#hMain = WinXNewWindow (0, "My Window", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)

	'this is a good place to add controls such as status bars and buttons to your window
	bluePen = CreatePen ($$PS_SOLID, 2, 0x00FF0000)
	redPen = CreatePen ($$PS_SOLID, 2, 0x000000FF)
	WinXDrawEllipse (#hMain, bluePen, 0, 0, 100, 200)
	WinXDrawRect (#hMain, bluePen, 0, 0, 100, 100)
	WinXDrawFilledArea (#hMain, CreateSolidBrush (0x000000FF), 0x00FF0000, 10, 10)
	WinXDrawFilledArea (#hMain, CreateSolidBrush (0x0000FF00), 0x00FF0000, 50, 50)

	WinXDrawArc (#hMain, redPen, 100, 100, 300, 200, 0, 2*$$PI)
	WinXDrawArc (#hMain, bluePen, 100, 100, 300, 200, 0, $$PI/3.0)

	WinXDrawBezier (#hMain, bluePen, 100, 0, 200, 100, 200, 0, 100, 100)

	'remember to register callbacks
	WinXRegOnCommand (#hMain, &onCommand())

	WinXDisplay (#hMain)

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
	'this is where you clean up any resources that need to be deallocated

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
	END SELECT

END FUNCTION
END PROGRAM