'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates some of the image API
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
	IMPORT	"xma"   		' math library			: Sin/Asin/Sinh/Asinh/Log/Exp/Sqrt...
'	IMPORT	"xcm"				' complex math library
'	IMPORT  "msvcrt"		' msvcrt.dll				: C function library
'	IMPORT  "shell32"   ' shell32.dll
	IMPORT	"WinX"			' The Xwin GUI library
	
'
$$BT_SAVE = 100
DECLARE FUNCTION Entry ()
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
	IF initWindow () THEN QUIT(0)
	
	WinXDoEvents (0)
	
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
	'Create a window
	#hMain = WinXNewWindow (0, "Image Demo", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)
	
	'demonstrate some of what the image API can do
	'first, load some images
	#hPattern = WinXDraw_LoadImage ("pattern.bmp", $$FILETYPE_WINBMP)
	#hBackGround = WinXDraw_LoadImage ("backGround.bmp", $$FILETYPE_WINBMP)
	
	'now generate different sizes of the pattern bitmap
	#hPatternSmall = WinXDraw_ResizeImage (#hPattern, 100, 75)
	#hPatternLarge = WinXDraw_ResizeImage (#hPattern, 400, 300)
	
	'next, add alpha channels
	WinXDraw_SetConstantAlpha (#hPattern, 0.5)
	WinXDraw_SetConstantAlpha (#hPatternLarge, 0.2)
	
	'premultiply the alpha channels for drawing
	WinXDraw_PremultiplyImage (#hPattern)
	WinXDraw_PremultiplyImage (#hPatternLarge)
	
	'Draw the images
	WinXDrawImage (#hMain, #hBackGround, 0, 0, 660, 300, 0, 0, $$FALSE)
	WinXDrawImage (#hMain, #hPatternSmall, 0, 0, 100, 75, 0, 0, $$FALSE)
	WinXDrawImage (#hMain, #hPattern, 80, 0, 200, 150, 0, 0, $$TRUE)
	WinXDrawImage (#hMain, #hPatternLarge, 260, 0, 400, 300, 0, 0, $$TRUE)

	'create a couple of buttons
	MoveWindow (WinXAddButton (#hMain, "Save", 0, $$BT_SAVE), 2, 2, 80, 25, $$TRUE)
	
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
	'Clean up resources before quitting
	WinXDraw_DeleteImage (#hPattern)
	WinXDraw_DeleteImage (#hPatternSmall)
	WinXDraw_DeleteImage (#hPatternLarge)
	WinXDraw_DeleteImage (#hBackGround)
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
		CASE $$BT_SAVE
			'create an image
			hSave = WinXDraw_CreateImage (660, 300)
			'draw the window onto the bitmap
			WinXDraw_Snapshot (#hMain, 0, 0, hSave)
			'save the bitmap
			WinXDraw_SaveImage (hSave, WinXDialog_SaveFile$ (#hMain, "Save As...", "Windows Bitmap Files (*.bmp)\0*.bmp\0All Files (*.*)\0*.*\0\0", "", $$TRUE), $$FILETYPE_WINBMP)
			'and finnaly, free the image
			WinXDraw_DeleteImage (hSave)
	END SELECT
	
END FUNCTION
END PROGRAM