'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates text output
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


$$BT_FONT = 100
'
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
	SHARED LOGFONT logFont
	SHARED colour
	'this is where you create and initialise your window

	#winMain = WinXNewWindow (0, "Text output", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)

	'this is a good place to add controls such as status bars and buttons to your window
	MoveWindow (WinXAddButton (#winMain, "Select Font", 0, $$BT_FONT), 2, 2, 80, 20, $$TRUE)

	'remember to register callbacks
	WinXRegOnCommand (#winMain, &onCommand())

	WinXDisplay (#winMain)

	logFont = WinXDraw_MakeLogFont ("Arial", 30, $$FONT_BOLD|$$FONT_ITALIC|$$FONT_UNDERLINE)
	#hFont = CreateFontIndirectA (&logFont)
	colour = 0
	WinXDrawText (#winMain, #hFont, "Hello World!", 2, 24, 0x00FFFFFF, colour)

	text$ = "Welcome to the VIXEN Setup Wizard"
	backCol = $$LightGrey ' $$COLOR_BTNFACE + 1
	forCol  = $$Black
	WinXDrawText (#winMain, #hFont, text$, 160, 60, backCol, forCol)

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
	SHARED LOGFONT logFont
	SHARED colour

	SELECT CASE id
		CASE $$BT_FONT
			WinXDraw_GetFontDialog (#winMain, @logFont, @colour)

			DeleteObject (#hFont)
			#hFont = CreateFontIndirectA (&logFont)
			WinXClear (#winMain)
			WinXDrawText (#winMain, #hFont, "Hello World!", 2, 24, 0x00FFFFFF, colour)
			WinXUpdate (#winMain)
	END SELECT

END FUNCTION
END PROGRAM