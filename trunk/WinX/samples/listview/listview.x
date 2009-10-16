'
' ####################
' #####  PROLOG  #####
' ####################
'
' A simple list view control demo
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

$$ID_LV = 100
DECLARE FUNCTION Entry ()
DECLARE FUNCTION initWindow ()
DECLARE FUNCTION onLabelEdit (control, code, item, STRING text)
DECLARE FUNCTION onColumnClick (control, iColumn)
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
	'this is where you create and initialise your window

	#hMain = WinXNewWindow (0, "Listview Demo", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)


	'this is a good place to add controls such as status bars and buttons to your window
	hLV = WinXAddListView (#hMain, 0, 0, $$TRUE, $$LVS_REPORT, $$ID_LV)
	WinXAutoSizer_SetSimpleInfo (hLV, WinXAutoSizer_GetMainSeries (#hMain), 0, 1, 0)

	WinXListView_AddColumn (hLV, 0, 100, "Column 1", 0)
	WinXListView_AddColumn (hLV, 1, 100, "Column 2", 1)
	WinXListView_AddColumn (hLV, 2, 100, "Column 3", 2)
	WinXListView_AddColumn (hLV, 3, 100, "Column 4", 3)

	WinXListView_AddItem (hLV, -1, "Item 1 \0E \0A \05", -1)
	WinXListView_AddItem (hLV, -1, "Item 2 \0D \0B \04", -1)
	WinXListView_AddItem (hLV, -1, "Item 3 \0C \0C \03", -1)
	WinXListView_AddItem (hLV, -1, "Item 4 \0B \0D \02", -1)
	WinXListView_AddItem (hLV, -1, "Item 5 \0A \0E \01", -1)

	'remember to register callbacks
	WinXRegOnLabelEdit (#hMain, &onLabelEdit())
	WinXRegOnColumnClick (#hMain, &onColumnClick())

	WinXDisplay (#hMain)

	RETURN 0
END FUNCTION
'
' #########################
' #####  onLabelEdit  #####
' #########################
'
'
'
FUNCTION onLabelEdit (control, code, item, STRING text)
	' Allow all editing operations
	RETURN $$TRUE
END FUNCTION

FUNCTION onColumnClick (control, iColumn)
	' Sort by the clicked column
	WinXListView_Sort (GetDlgItem (#hMain, control), iColumn, $$FALSE)
END FUNCTION
END PROGRAM