'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates combo boxes
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

'
$$ID_COMBO = 100
$$ID_BUTTON = 101

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

	'quit if this fails
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

	'create the main window
	#hMain = WinXNewWindow (0, "Combobox demo", -1, -1, 300, 48, $$XWSS_APPNORESIZE, 0, 0, 0)

	'make the combo box
	hCombo = WinXAddComboBox (#hMain, 120, $$TRUE, 0, $$ID_COMBO)
	MoveWindow (hCombo, 0, 0, 300, 22, $$TRUE)

	'and add some items
	WinXComboBox_AddItem (hCombo, -1, 0, "Item 1", 0, 0)
	WinXComboBox_AddItem (hCombo, -1, 1, "Item 2", 0, 0)
	WinXComboBox_AddItem (hCombo, -1, 0, "Item 3", 0, 0)
	WinXComboBox_AddItem (hCombo, -1, 0, "Item 4", 0, 0)
	WinXComboBox_AddItem (hCombo, -1, 0, "Item 5", 0, 0)
	WinXComboBox_AddItem (hCombo, -1, 0, "Item 6", 0, 0)
	WinXComboBox_AddItem (hCombo, -1, 0, "Item 7", 0, 0)

	'make a button
	MoveWindow (WinXAddButton (#hMain, "Get combo text", 0, $$ID_BUTTON), 0, 26, 300, 22, $$TRUE)

	'remember to register the callback
	WinXRegOnCommand (#hMain, &onCommand())

	WinXDisplay (#hMain)

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

	SELECT CASE id
		CASE $$ID_COMBO
			SELECT CASE code
				'action for combo box
				CASE $$CBN_SELCHANGE
					WinXDialog_Error ("You selected item "+STRING$(WinXComboBox_GetSelection (hWnd)+1), "Message", 0)
			END SELECT
		CASE $$ID_BUTTON
			SELECT CASE code
				'action for button
				CASE $$BN_CLICKED
					WinXDialog_Error ("The edit box says: "+WinXComboBox_GetEditText$(GetDlgItem (#hMain, $$ID_COMBO)), "Message", 0)
			END SELECT
	END SELECT

END FUNCTION
END PROGRAM