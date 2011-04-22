PROGRAM "splitter"
VERSION "1.00"
'
' splitter - Demonstrates splitters and the new onClose callback FUNCTION
' Author: Callum Lowcay
' This program is in the public domain
'
' ***** Description *****
' (app's complete description).
'
' ***** Notes *****
'
' ***** Versions *****
' 1.00-22apr11-Guy-generated GUI prototype using viXen v1.99u.
' generation switches that are on:
' - Use Windows® XP Style
' - Use Callum Lowcay's WinX
' - Use Text-only Pushbuttons
' - Source Terse Mode
' - Meticulous Cleanup
'
	IMPORT "kernel32"   ' operating system
	IMPORT "gdi32"      ' Graphic Device Interface
	IMPORT "shell32"    ' interface to the operating system
	IMPORT "user32"     ' Windows management
	IMPORT "comctl32"   ' common controls (needed for the Windows styles)
'
	IMPORT "xst"        ' Xblite Standard library
	IMPORT "xsx"        ' Xblite Standard eXtended library
	IMPORT "WinX"       ' Callum Lowcay's Windows GUI library
'
'
'
'
DECLARE FUNCTION Entry () ' program entry point

DECLARE FUNCTION CreateWindows () ' create windows and other child controls

DECLARE FUNCTION StartUp () ' application setup

DECLARE FUNCTION hMain_OnClose (hWnd) ' to process $$WM_CLOSE msg
DECLARE FUNCTION hMain_OnCommand (idCtr, notifyCode, lParam) ' to process $$WM_COMMAND msg
'
' Control IDs
'
'
$$EdBottomRight = 101	' multiline edit 'Bottom right'
$$EdTopRight    = 102	' multiline edit 'Top right'
$$EdLeft        = 103	' multiline edit 'Left'
'
FUNCTION Entry ()
	STATIC entry

	IF entry THEN RETURN    ' enter once
	entry = $$TRUE          ' enter occured
	IF WinX () THEN QUIT (1)' abend
	StartUp ()              ' initialize program and libraries
	CreateWindows ()        ' create windows and other child controls
	WinXDoEvents ()         ' monitor the events
	WinXCleanUp ()          ' optional cleanup
	QUIT (0)

END FUNCTION

FUNCTION CreateWindows ()	' create the windows of the application
	SHARED hInst

	hIcon = 0

	titleBar$ = "WinX Splitter demo"
	#hMain = WinXNewWindow (0, titleBar$, -1, -1, 401, 301, $$XWSS_APP, 0, hIcon, 0) ' create new window #hMain
	' keep the initial width and height as minimum size
	WinXSetMinSize (#hMain, 401, 301) ' minimum size

	#hEdBottomRight = WinXAddEdit (#hMain, "Bottom right", 0, $$EdBottomRight) ' create multiline edit #hEdBottomRight
	#hEdTopRight = WinXAddEdit (#hMain, "Top right", 0, $$EdTopRight) ' create multiline edit #hEdTopRight
	#hEdLeft = WinXAddEdit (#hMain, "Left", 0, $$EdLeft) ' create multiline edit #hEdLeft

	MoveWindow (#hEdBottomRight, 194, 138, 203, 158, 1) ' repaint
	MoveWindow (#hEdTopRight, 196, 4, 203, 124, 1) ' repaint
	MoveWindow (#hEdLeft, 1, 1, 189, 291, 1) ' repaint

	' register the callback functions
	addrWndProc = &hMain_OnCommand () ' to process $$WM_COMMAND msg
	WinXRegOnCommand (#hMain, addrWndProc)

	addrWndProc = &hMain_OnClose () ' to process $$WM_CLOSE msg
	WinXRegOnClose (#hMain, addrWndProc)

	WinXDisplay (#hMain)

END FUNCTION ' CreateWindows

FUNCTION StartUp () ' application setup

	SHARED hInst

	SetLastError (0)
	hInst = GetModuleHandleA (0) ' get current instance handle
	IFZ hInst THEN
		msg$ = "GetModuleHandleA: Can't get current instance handle"
		XstAlert (msg$)
		RETURN $$TRUE ' fail
	ENDIF

END FUNCTION

FUNCTION hMain_OnClose (hWnd)

	DestroyWindow (#hMain)
	#hMain = 0
	PostQuitMessage ($$WM_QUIT) ' end execution

END FUNCTION

FUNCTION hMain_OnCommand (idCtr, notifyCode, lParam)
	SHARED hInst ' for WinXDialog_Message (#hMain, msg$, title$, &"0", hInst)

	SELECT CASE idCtr
	END SELECT ' CASE idCtr

END FUNCTION
END PROGRAM
