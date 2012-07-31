'
' ####################
' #####  PROLOG  #####
' ####################
'
' An WinX GUI program
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
DECLARE FUNCTION onEnterLeave (hWnd, mouseInWindow)
DECLARE FUNCTION onMouseUp (hWnd, button, x, y)
DECLARE FUNCTION swapBytes (rgb)
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
	WinXCleanUp () ' optional cleanup
	QUIT (0)          ' stop run

END FUNCTION
'
' ########################
' #####  initWindow  #####
' ########################
FUNCTION initWindow ()
	' this array needs to be shared
	SHARED colours[]

	' If you were using all 216 colours, you would generate this automatically
	' I'm only using 16 for demo purposes, so I'm defining them manually
	DIM colours[15]
	colours[0] = 0x000000
	colours[1] = 0x660000
	colours[2] = 0x006600
	colours[3] = 0x000066
	colours[4] = 0x666600
	colours[5] = 0x006666
	colours[6] = 0x660066
	colours[7] = 0x666666
	colours[8] = 0x333333
	colours[9] = 0xFF0000
	colours[10] = 0x00FF00
	colours[11] = 0x0000FF
	colours[12] = 0xFFFF00
	colours[13] = 0x00FFFF
	colours[14] = 0xFF00FF
	colours[15] = 0xFFFFFF

	' Create some pens for drawing the borders
	#penWhite = CreatePen ($$PS_SOLID, 1, 0xFFFFFF)
	#penBlack = CreatePen ($$PS_SOLID, 1, 0x000000)

	' Create the main window.  Notice the 2 extended styles, these create a tool window which is always on top
'	#hMain = WinXNewWindow (0, "Click a colour to copy it to the clipboard", -1, -1, 256, 16, $$XWSS_POPUP, $$WS_EX_TOOLWINDOW|$$WS_EX_TOPMOST, 0, 0)
	#hMain = WinXNewWindow (0, "Click a colour to copy it to the clipboard", -1, -1, 262, 40, $$XWSS_POPUP, $$WS_EX_TOOLWINDOW|$$WS_EX_TOPMOST, 0, 0)
	' A new WinX function, set the window background colour
	WinXSetWindowColour (#hMain, 0x000000)

	' Each colour in the palatte is a child window
	FOR x = 0 TO 15
		' Child windows are made with the WinXNewChildWindow function
		' notice that I set the control id to 100+index into colours.
		' this will allow me to easily retreive the colour this control refers
		' to later on.
		hChild = WinXNewChildWindow (#hMain, "", 0, 0, 100+x)
		' Let's give them tooltips
		WinXAddTooltip (hChild, "#"+HEX$(colours[x],6))
		' Set the colour for the child window
		WinXSetWindowColour (hChild, swapBytes(colours[x]))
		' Draw the border
		WinXDrawRect (hChild, #penBlack, 0, 0, 15, 15)
		' Move the window to the correct location
		MoveWindow (hChild, x<<4, 0, 16, 16, $$TRUE)
		' And register it's callbacks.  Notice the new onEnterLeave callback which is invoked when
		' the mouse enters or leaves the control
		WinXRegOnEnterLeave (hChild, &onEnterLeave())
		WinXRegOnMouseUp (hChild, &onMouseUp())
	NEXT

	' make the window visible
	WinXDisplay (#hMain)

END FUNCTION
'
' ##########################
' #####  onEnterLeave  #####
' ##########################
' redraw the border. The border is drawn on the child window, therefore the coordinates
' are relative to the child window.  This means that this one simple piece of code
' will draw the border in the correct place for all colours.
FUNCTION onEnterLeave (hWnd, mouseInWindow)
	SHARED colours[]

	WinXClear (hWnd)
	IF mouseInWindow THEN
		WinXDrawRect (hWnd, #penWhite, 0, 0, 15, 15)
	ELSE
		WinXDrawRect (hWnd, #penBlack, 0, 0, 15, 15)
	END IF
	WinXUpdate (hWnd)
	RETURN 1
END FUNCTION
'
' #######################
' #####  onMouseUp  #####
' #######################
' Clicks are processed on mouse up, always.  Its just one of those counter intuitive things...
FUNCTION onMouseUp (hWnd, button, x, y)
	SHARED colours[]

msg$ = "button = "+STRING$(button)+", $$MBT_LEFT = "+STRING$($$MBT_LEFT)
MessageBoxA (#hMain, &msg$, &"Debug", $$MB_ICONINFORMATION)
	IF button = $$MBT_LEFT THEN
		' Remember I set the control id to 100+index into colours array?
		' now we can recover the id to get the index to this control's  colour
		colour = GetDlgCtrlID (hWnd)-100
		' copying to the clipboard is so easy
		WinXClip_PutString ("#"+HEX$(colours[colour],6))
		RETURN 1
	END IF
END FUNCTION
'
' #######################
' #####  swapBytes  #####
' #######################
' Looks like we have some endianess issues.  This function swaps the R and B components
FUNCTION swapBytes (rgb)
	RETURN ((rgb & 0x0000FF)<<16)|(rgb & 0x00FF00)|((rgb & 0xFF0000)>>16)
END FUNCTION


END PROGRAM