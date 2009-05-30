'
' ####################
' #####  PROLOG  #####
' ####################
'
' A program to demonstrate clipboard access.  Also includes some autodraw and scrolling
'
' This program is in the public domain
'
VERSION	"1.00"
'
	IMPORT	"xst"   		' standard library	: required by most programs
	IMPORT  "xsx"				' extended std library
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
DECLARE FUNCTION onClipChange ()
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
	' Create the main window
	#hMain = WinXNewWindow (0, "Clipboard Viewer (Copy something onto the clipboard and see what happens)", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)
	' Give the window a white background
	WinXSetWindowColour (#hMain, 0xFFFFFF)
	' Setup the scrollbars
	WinXScroll_Show (#hMain, $$TRUE, $$TRUE)
	WinXScroll_SetPage (#hMain, $$DIR_VERT, 1, 0, 10)
	WinXScroll_SetPage (#hMain, $$DIR_HORIZ, 1, 0, 10)
	
	'remember to register callbacks
	WinXRegOnClipChange (#hMain, &onClipChange())
	WinXRegOnScroll (#hMain, &onScroll())
	WinXRegOnMouseWheel (#hMain, &onMouseWheel())
	WinXRegOnKeyDown (#hMain, &onKeyDown())
	
	WinXDisplay (#hMain)
	
	' initialise the display
	onClipChange ()
	
	RETURN 0
END FUNCTION
'
' ##########################
' #####  onClipChange  #####
' ##########################
'
'
'
FUNCTION onClipChange ()
	' A few shared variables we need for this and scrolling
	SHARED hImage
	SHARED x, y, w, h
	SHARED clipText$[]
	
	' x and y are the scrolling offsets
	x = 0
	y = 0
	WinXClear (#hMain)
	WinXDraw_DeleteImage (hImage)
	
	' clear data from the old clipboard data
	hImage = 0
	DIM ClipText$[]
	
	' What kind of data is on the clipboard?
	SELECT CASE TRUE
		CASE WinXClip_IsString ()
			' It's a string, so we need a font
			hFont = GetStockObject ($$SYSTEM_FIXED_FONT)
			lineHeight = WinXDraw_GetFontHeight(hFont, 0, 0)
			
			' Split the text into lines and expand tabs
			buffer$ = WinXClip_GetString$ ()
			XstReplace (@buffer$, "\t", "  ", 0)
			XstStringToStringArray (buffer$, @clipText$[])
			
			' Find out how tall and wide the text is
			h = lineHeight*(UBOUND(clipText$[])+1)
			w = 0
			FOR i = 0 TO UBOUND(clipText$[])
				pw = WinXDraw_GetTextWidth (hFont, clipText$[i], -1)
				IF pw > w THEN w = pw
			NEXT
			
			' Update the scrollbars
			WinXScroll_SetRange (#hMain, $$DIR_VERT, 0, h)
			WinXScroll_SetRange (#hMain, $$DIR_HORIZ, 0, w)
			
			' Write the text to the window
			FOR i = 0 TO UBOUND(clipText$[])
				WinXDrawText (#hMain, hFont, clipText$[i], -x, -y+i*lineHeight, -1, 0x000000)
			NEXT
		CASE WinXClip_IsImage ()
			hImage = WinXClip_GetImage ()
			
			' Get the width and height and update the scrollbars
			WinXDraw_GetImageInfo (hImage, @w, @h, @pBits)
			WinXScroll_SetRange (#hMain, $$DIR_VERT, 0, h)
			WinXScroll_SetRange (#hMain, $$DIR_HORIZ, 0, w)
			
			' Write the image to the window
			WinXDrawImage (#hMain, hImage, -x, -y, w, h, 0, 0, $$FALSE)
	END SELECT
	WinXUpdate (#hMain)
	
END FUNCTION
'
' ######################
' #####  onScroll  #####
' ######################
'
'
'
FUNCTION onScroll (pos, hWnd, direction)
	SHARED hImage
	SHARED x, y, w, h
	SHARED clipText$[]

	' Update the scrolling position and calculate deltas
	WinXClear (#hMain)
	SELECT CASE direction
		CASE $$DIR_VERT
			deltaY = y-pos
			y = pos
		CASE $$DIR_HORIZ
			deltaX = x-pos
			x = pos
	END SELECT
	
	' Write out the new window contents
	IF hImage THEN
		WinXDrawImage (#hMain, hImage, -x, -y, w, h, 0, 0, $$FALSE)
	ELSE
		hFont = GetStockObject ($$SYSTEM_FIXED_FONT)
		lineHeight = WinXDraw_GetFontHeight(hFont, 0, 0)
		FOR i = 0 TO UBOUND(clipText$[])
			WinXDrawText (#hMain, hFont, clipText$[i], -x, -y+i*lineHeight, 0xFFFFFF, 0x000000)
		NEXT
	END IF
	
	' And update
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