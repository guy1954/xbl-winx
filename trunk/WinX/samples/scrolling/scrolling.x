'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates scrolling, the mouse wheel and the keyboard
'
' This program is public domain
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
DECLARE FUNCTION onScroll (pos, hWnd, direction)
DECLARE FUNCTION onMouseWheel (hWnd, delta, x, y)
DECLARE FUNCTION onKeyDown (hWnd, key)
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
	SHARED xoffset
	SHARED yoffset
	
	SHARED pen
	SHARED brush
	
	'create the window
	#hMain = WinXNewWindow (0, "Scrolling demo", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)
	
	'add scrollbars
	WinXScroll_Show (#hMain, $$TRUE, $$TRUE)
	
	'set the ranges and page size functions
	WinXScroll_SetRange (#hMain, $$DIR_HORIZ, 0, 800)
	WinXScroll_SetRange (#hMain, $$DIR_VERT, 0, 600)
	WinXScroll_SetPage (#hMain, $$DIR_HORIZ, 1, 0, 10)
	WinXScroll_SetPage (#hMain, $$DIR_VERT, 1, 0, 10)
	
	'register the callbacks
	WinXRegOnScroll (#hMain, &onScroll())
	WinXRegOnMouseWheel (#hMain, &onMouseWheel())
	WinXRegOnKeyDown (#hMain, &onKeyDown())
	
	'lets draw something
	pen = CreatePen ($$PS_SOLID, 3, 0x000000FF)
	brush = CreateSolidBrush (0x00FF0000)
	WinXDrawFilledEllipse (#hMain, pen, brush, 0, 0, 800, 600)
	WinXUpdate (#hMain)
	
	WinXDisplay (#hMain)
	
	RETURN 0
END FUNCTION
'
' ######################
' #####  onScroll  #####
' ######################
' Handle scrolling events
FUNCTION onScroll (pos, hWnd, direction)
	SHARED xoffset
	SHARED yoffset
	
	SHARED pen
	SHARED brush
	
	SELECT CASE direction
		CASE $$DIR_HORIZ
			deltaX = xoffset-pos
			deltaY = 0
			xoffset = pos
		CASE $$DIR_VERT
			deltaX = 0
			deltaY = yoffset-pos
			yoffset = pos
	END SELECT
	
	'redraw the ellipse at a different position
	WinXClear (#hMain)
	WinXDrawFilledEllipse (#hMain, pen, brush, 0-xoffset, 0-yoffset, 800-xoffset, 600-yoffset)
	
	'note that when scrolling, we use WinXScroll_Update rather than WinXUpdate
	'Although WinXUpdate would work, WinXScroll_Update gives better looking results
	WinXScroll_Update (#hMain, deltaX, deltaY)
END FUNCTION
'
' ##########################
' #####  onMouseWheel  #####
' ##########################
' Handle mouse wheel events
FUNCTION onMouseWheel (hWnd, delta, x, y)
	STATIC deltaSoFar
	
	'delta accumalates over mouse wheel events
	deltaSoFar = deltaSoFar + delta
	
	'scroll one line for every 120 deltas
	IF deltaSoFar > 0 THEN
		DO WHILE deltaSoFar >= 120
			deltaSoFar = deltaSoFar - 120
			WinXScroll_Scroll (hWnd, $$DIR_VERT, $$UNIT_LINE, -1)
		LOOP
	ELSE
		DO WHILE deltaSoFar <= 120
			deltaSoFar = deltaSoFar + 120
			WinXScroll_Scroll (hWnd, $$DIR_VERT, $$UNIT_LINE, +1)
		LOOP
	END IF
END FUNCTION
'
' #######################
' #####  onKeyDown  #####
' #######################
' Handle keyboard events
FUNCTION onKeyDown (hWnd, key)
	SELECT CASE key
		CASE $$VK_UP
			'WinXScroll_Scroll scrolls the window
			WinXScroll_Scroll (hWnd, $$DIR_VERT, $$UNIT_LINE, -1)
		CASE $$VK_DOWN
			WinXScroll_Scroll (hWnd, $$DIR_VERT, $$UNIT_LINE, +1)
		CASE $$VK_LEFT
			WinXScroll_Scroll (hWnd, $$DIR_HORIZ, $$UNIT_LINE, -1)
		CASE $$VK_RIGHT
			WinXScroll_Scroll (hWnd, $$DIR_HORIZ, $$UNIT_LINE, +1)
		CASE $$VK_PRIOR
			WinXScroll_Scroll (hWnd, $$DIR_VERT, $$UNIT_PAGE, -1)
		CASE $$VK_NEXT
			WinXScroll_Scroll (hWnd, $$DIR_VERT, $$UNIT_PAGE, +1)
		CASE $$VK_HOME
			WinXScroll_Scroll (hWnd, $$DIR_VERT, $$UNIT_END, -1)
		CASE $$VK_END
			WinXScroll_Scroll (hWnd, $$DIR_VERT, $$UNIT_END, +1)
	END SELECT
END FUNCTION
END PROGRAM