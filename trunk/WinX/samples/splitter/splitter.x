PROGRAM "splitter"
VERSION "1.00"
'
' splitter - Demonstrates splitters and the new onClose callback FUNCTION
' This program is in the public domain
' Author: Callum Lowcay.
'
	IMPORT "kernel32"   ' operating system
	IMPORT "gdi32"      ' Graphic Device Interface
	IMPORT "shell32"    ' interface to the operating system
	IMPORT "user32"     ' Windows management
	IMPORT "comctl32"   ' common controls (needed for the Windows styles)
'
	IMPORT "xst"        ' Xblite Standard library
	IMPORT "xsx"        ' Xblite Standard eXtended library
'	IMPORT "xio"        ' console
	IMPORT "WinX"       ' Callum Lowcay's Windows GUI library
'
'
'
'
DECLARE FUNCTION Entry () ' program entry point

DECLARE FUNCTION CleanUp () ' application cleanup

DECLARE FUNCTION CreateWindows () ' create windows and other child controls

DECLARE FUNCTION InitGui () ' initialize the User Interface
DECLARE FUNCTION InitWindows () ' for initializations after CreateWindows()

DECLARE FUNCTION StartUp () ' application setup

DECLARE FUNCTION hMain_OnClose (hWnd) ' to process $$WM_CLOSE msg
DECLARE FUNCTION hMain_OnCommand (idCtr, notifyCode, lParam) ' to process $$WM_COMMAND msg
'
'
' ***** Constants used as control identificators for window #hMain *****
'
' control identificators for #hMain
$$EdLeft        = 101	' multiline edit 'Left'
$$EdTopRight    = 102	' multiline edit 'Top right'
$$EdBottomRight = 103	' multiline edit 'Bottom right'
'
FUNCTION Entry ()
	STATIC entry

	IF entry THEN RETURN    ' enter once
	entry = $$TRUE          ' enter occured
'	XioCreateConsole ("", 50)
	IF WinX () THEN QUIT (1)' abend
	StartUp ()              ' initialize program and libraries
	InitGui ()              ' initialize the GUI
	CreateWindows ()        ' create windows and other child controls
	InitWindows ()          ' for initializations after CreateWindows()
	WinXDoEvents ()         ' monitor the events
	CleanUp ()              ' application cleanup
'	XioFreeConsole ()       ' free console
	QUIT (0)

END FUNCTION

FUNCTION CleanUp () ' application cleanup

	WinXCleanUp () ' optional cleanup

END FUNCTION

FUNCTION CreateWindows ()	' create the windows of the application
	SHARED hInst

	hIcon = 0

	titleBar$ = "WinX Splitter demo"
	#hMain = WinXNewWindow (0, titleBar$, -1, -1, 401, 301, $$XWSS_APP, 0, hIcon, 0) ' create new window #hMain
	IFZ #hMain THEN ' fail: null handle
		msg$ = "WinXNewWindow: Can't create new window #hMain"
		XstAlert (msg$)
	ENDIF

	style = $$WS_VSCROLL | $$WS_HSCROLL | $$ES_AUTOHSCROLL | $$ES_MULTILINE
	#hEdBottomRight = WinXAddEdit (#hMain, "Bottom right", style, $$EdBottomRight) ' create multiline edit #hEdBottomRight

	style = $$WS_VSCROLL | $$WS_HSCROLL | $$ES_AUTOHSCROLL | $$ES_MULTILINE
	#hEdTopRight = WinXAddEdit (#hMain, "Top right", style, $$EdTopRight) ' create multiline edit #hEdTopRight

	style = $$WS_VSCROLL | $$WS_HSCROLL | $$ES_AUTOHSCROLL | $$ES_MULTILINE
	#hEdLeft = WinXAddEdit (#hMain, "Left", style, $$EdLeft) ' create multiline edit #hEdLeft

'	MoveWindow (#hEdBottomRight, 194, 138, 203, 156, 1) ' repaint
'	MoveWindow (#hEdTopRight, 196, 4, 203, 124, 1) ' repaint
'	MoveWindow (#hEdLeft, 1, 1, 189, 291, 1) ' repaint

	' Create the right pane
	vertical = WinXNewAutoSizerSeries ($$DIR_VERT|$$DIR_REVERSE)
	' Note the use of the splitter flag to create a splitter
	' Also notice the use of WinXAutoSizer_SetSimpleInfo to reduce parameters
	WinXAutoSizer_SetSimpleInfo (#hEdBottomRight, vertical, 0, 100, $$SIZER_SPLITTER)
	WinXAutoSizer_SetSimpleInfo (#hEdTopRight, vertical, 0, 1, $$SIZER_SIZERELREST)

	' Now for the left pane
	horizontal = WinXNewAutoSizerSeries ($$DIR_HORIZ)

	WinXAutoSizer_SetSimpleInfo (#hEdLeft, horizontal, 0, 100, $$SIZER_SPLITTER)

	WinXAutoSizer_SetSimpleInfo (vertical, horizontal, 0, 1, $$SIZER_SIZERELREST|$$SIZER_SERIES)

	' And finally add them to the main series
	WinXAutoSizer_SetSimpleInfo (horizontal, WinXAutoSizer_GetMainSeries (#hMain), 0, 1, $$SIZER_SERIES)

	' set the minimum ranges and make the left splitter dockable
	WinXSplitter_SetProperties (vertical, #hEdBottomRight, 48, 200, $$FALSE)
	WinXSplitter_SetProperties (horizontal, #hEdLeft, 48, 200, $$TRUE)

	' register the callback functions
	addrWndProc = &hMain_OnCommand () ' to process $$WM_COMMAND msg
	WinXRegOnCommand (#hMain, addrWndProc)

	addrWndProc = &hMain_OnClose () ' to process $$WM_CLOSE msg
	WinXRegOnClose (#hMain, addrWndProc)

	WinXDisplay (#hMain)

END FUNCTION ' CreateWindows

FUNCTION InitGui () ' initialize the User Interface

END FUNCTION

FUNCTION InitWindows () ' for initializations after CreateWindows()

	WinXShow (#hMain) ' show the window #hMain

END FUNCTION

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

	' Make sure the user really wanted to quit
	IF MessageBoxA (#hMain, &"Really quit?", &"Question", $$MB_YESNO|$$MB_ICONQUESTION) = $$IDYES THEN
		DestroyWindow (#hMain)
		#hMain = 0
		PostQuitMessage ($$WM_QUIT) ' end execution
	END IF

END FUNCTION

FUNCTION hMain_OnCommand (idCtr, notifyCode, lParam)
	SHARED hInst ' for WinXDialog_Message (#hMain, msg$, title$, &"0", hInst)

	SELECT CASE idCtr
	END SELECT ' CASE idCtr

END FUNCTION
END PROGRAM
