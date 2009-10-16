'
' ####################
' #####  PROLOG  #####
' ####################
'
' A program that allows the user to draw lines
' demonstrates menus, toolbars, status bars and mouse input
'
' This program is in the public domain
'
VERSION "1.00"
'
	IMPORT "xst"				' Standard library : required by most programs
'	IMPORT "xsx"				' Extended standard library
'	IMPORT "xio"				' Console input/ouput library

'	IMPORT "xst_s.lib"
' IMPORT "xsx_s.lib"
' IMPORT "xio_s.lib"

	IMPORT "gdi32"			' gdi32.dll
	IMPORT "user32"		  ' user32.dll
	IMPORT "kernel32"	  ' kernel32.dll
'	IMPORT "shell32"		' shell32.dll
'	IMPORT "msvcrt"		  ' msvcrt.dll
	IMPORT "WinX"				' GUI library

'
'define constants
'for the main menu
$$ID_DRAW			= 100
$$ID_HELP			= 101

'for the draw menu
$$ID_REDPEN		= 200
$$ID_GREENPEN	= 201
$$ID_BLUEPEN	= 202
$$ID_CLEAR		= 203

DECLARE FUNCTION Entry ()
DECLARE FUNCTION onMouseMove (hWnd, x, y)
DECLARE FUNCTION onMouseDown (hWnd, button, x, y)
DECLARE FUNCTION onMouseUp (hWnd, button, x, y)
DECLARE FUNCTION onCommand (id, code, hWnd)
'
'
' ######################
' #####  Entry ()  #####
' ######################
'
FUNCTION Entry ()
	SHARED	currentPen
	SHARED	mouseDown
	SHARED	startX
	SHARED	startY
	SHARED	idLastLine
	SHARED	redPen
	SHARED	greenPen
	SHARED	bluePen

	'initialise the WinX library, WinX will crash if you don't do this
	IF WinX() THEN QUIT(0)

	'make the main menu
	'menu items are comma seperated
	'each menu item has an associated id.  In this case $$ID_DRAW is the id of the first item.
	'The id of the second item is $$ID_DRAW+1, the next item would be $$ID_DRAW+2 if there was one
	hMenu = WinXNewMenu ("&Draw, &Help", $$ID_DRAW, $$FALSE)
	'now we'll make a sub mennu
	hSub = WinXNewMenu ("&Red Pen, &Green Pen, &Blue Pen, &Clear Drawing", $$ID_REDPEN, $$TRUE)
	'and attach the sub menu to the main menu bar
	WinXMenu_Attach (hSub, hMenu, $$ID_DRAW)

	'make the main window
	#winMain = WinXNewWindow (0, "Draw Lines", -1, -1, 400, 300, $$XWSS_APP, 0, 0, hMenu)

	'now let's make the toolbar
	'first, load the images
	hImage = LoadImageA (0, &"toolbar.bmp", $$IMAGE_BITMAP, 0,0, $$LR_LOADFROMFILE)

	'this function creates a toolbar, notice that we only need to specify the main bitmap,
	'the others are automagically generated if we don't supply them.
	#tbrMain = WinXNewToolbar (32, 32, 5, hImage, 0, 0, 0x00FF00FF, $$TRUE, $$FALSE)

	'add the buttons
	WinXToolbar_AddToggleButton (#tbrMain, $$ID_REDPEN, 0, "Select red pen", $$TRUE, $$FALSE, $$FALSE)
	WinXToolbar_AddToggleButton (#tbrMain, $$ID_GREENPEN, 1, "Select green pen", $$TRUE, $$FALSE, $$FALSE)
	WinXToolbar_AddToggleButton (#tbrMain, $$ID_BLUEPEN, 2, "Select blue pen", $$TRUE, $$FALSE, $$FALSE)
	WinXToolbar_AddSeparator (#tbrMain)
	WinXToolbar_AddButton (#tbrMain, $$ID_CLEAR, 3, "Clear the drawing area", $$FALSE, $$FALSE)
	WinXToolbar_AddButton (#tbrMain, $$ID_HELP, 4, "Click here for help", $$FALSE, $$FALSE)

	'the red pen is initially selected
	WinXToolbar_ToggleButton(#tbrMain, $$ID_REDPEN, $$TRUE)

	WinXSetWindowToolbar (#winMain, #tbrMain)

	'make the toolbar visible
	WinXShow (#tbrMain)

	'make a two part status bar
	'we're not bothering to get the returned handle or set the id
	WinXAddStatusBar (#winMain, ",Red Pen Selected", 0)

	'make the pens
	redPen		= CreatePen ($$PS_SOLID, 3, 0x000000FF)
	greenPen	= CreatePen ($$PS_SOLID, 3, 0x00008000)
	bluePen		= CreatePen ($$PS_SOLID, 3, 0x00FF0000)
	currentPen = redPen

	'register the callbacks
	WinXRegOnCommand (#winMain, &onCommand())
	WinXRegOnMouseMove (#winMain, &onMouseMove())
	WinXRegOnMouseDown (#winMain, &onMouseDown())
	WinXRegOnMouseUp (#winMain, &onMouseUp())

	'display the window
	WinXDisplay (#winMain)

	WinXDoEvents()

END FUNCTION
'
' #########################
' #####  onMouseMove  #####
' #########################
'
'
'
FUNCTION onMouseMove (hWnd, x, y)
	SHARED	currentPen
	SHARED	mouseDown
	SHARED	startX
	SHARED	startY
	SHARED	idLastLine

	IF mouseDown THEN
		WinXUndo (hWnd, idLastLine)
		idLastLine = WinXDrawLine (#winMain, currentPen, startX, startY, x, y)
		WinXUpdate (#winMain)
	END IF

	WinXStatus_SetText (#winMain, 0, "x: "+STRING(x)+", y: "+STRING(y))
END FUNCTION
'
' #########################
' #####  onMouseDown  #####
' #########################
'
'
'
FUNCTION onMouseDown (hWnd, button, x, y)
	SHARED	currentPen
	SHARED	mouseDown
	SHARED	startX
	SHARED	startY
	SHARED	idLastLine

	mouseDown = $$TRUE
	startX = x
	startY = y

	'capture the mouse
	'this is so that we continue to get mouse events even after the mouse leaves the window
	SetCapture (hWnd)

	idLastLine = WinXDrawLine (#winMain, currentPen, x, y, x, y)
	WinXUpdate (#winMain)
END FUNCTION
'
' #######################
' #####  onMouseUp  #####
' #######################
'
'
'
FUNCTION onMouseUp (hWnd, button, x, y)
	SHARED	currentPen
	SHARED	mouseDown
	SHARED	startX
	SHARED	startY
	SHARED	idLastLine

	mouseDown = $$FALSE

	'release the mouse
	ReleaseCapture ()

	WinXUndo (hWnd, idLastLine)
	idLastLine = WinXDrawLine (#winMain, currentPen, startX, startY, x, y)
	WinXUpdate (#winMain)
END FUNCTION
'
' #######################
' #####  onCommand  #####
' #######################
'
'
'
FUNCTION onCommand (id, code, hWnd)
	SHARED	currentPen
	SHARED	redPen
	SHARED	greenPen
	SHARED	bluePen

	mouseDown = $$FALSE
	SELECT CASE id
		CASE $$ID_HELP
			WinXDialog_Message (#winMain, "Drag the mouse in the client area to draw lines\nUse the menu or toolbar to change the pen and clear the drawing area", "Help", 0, 0)
		CASE $$ID_REDPEN
			currentPen = redPen
			WinXStatus_SetText (#winMain, 1, "Red Pen Selected")

			'this code makes sure the toolbars and menus stay consistent
			CheckMenuRadioItem (GetMenu (#winMain), $$ID_REDPEN, $$ID_BLUEPEN, $$ID_REDPEN, $$MF_BYCOMMAND)
			WinXToolbar_ToggleButton(#tbrMain, $$ID_REDPEN, $$TRUE)
			WinXToolbar_ToggleButton(#tbrMain, $$ID_GREENPEN, $$FALSE)
			WinXToolbar_ToggleButton(#tbrMain, $$ID_BLUEPEN, $$FALSE)
		CASE $$ID_GREENPEN
			currentPen = greenPen
			WinXStatus_SetText (#winMain, 1, "Green Pen Selected")
			CheckMenuRadioItem (GetMenu (#winMain), $$ID_REDPEN, $$ID_BLUEPEN, $$ID_GREENPEN, $$MF_BYCOMMAND)
			WinXToolbar_ToggleButton(#tbrMain, $$ID_REDPEN, $$FALSE)
			WinXToolbar_ToggleButton(#tbrMain, $$ID_GREENPEN, $$TRUE)
			WinXToolbar_ToggleButton(#tbrMain, $$ID_BLUEPEN, $$FALSE)
		CASE $$ID_BLUEPEN
			currentPen = bluePen
			WinXStatus_SetText (#winMain, 1, "Blue Pen Selected")
			CheckMenuRadioItem (GetMenu (#winMain), $$ID_REDPEN, $$ID_BLUEPEN, $$ID_BLUEPEN, $$MF_BYCOMMAND)
			WinXToolbar_ToggleButton(#tbrMain, $$ID_REDPEN, $$FALSE)
			WinXToolbar_ToggleButton(#tbrMain, $$ID_GREENPEN, $$FALSE)
			WinXToolbar_ToggleButton(#tbrMain, $$ID_BLUEPEN, $$TRUE)
		CASE $$ID_CLEAR
			WinXClear (#winMain)
			WinXUpdate (#winMain)
	END SELECT
END FUNCTION
END PROGRAM