'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates dragging list box items
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

'define constants
$$ID_LIST = 100

DECLARE FUNCTION Entry ()
DECLARE FUNCTION initWindow ()
DECLARE FUNCTION onDrag (idCtr, drag_const, drag_item_start, drag_running_item, x, y)
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

	'Create the main window
	#hMain = WinXNewWindow (0, "Listbox dragging demo", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)

	'Create the list box
	hLB = WinXAddListBox (#hMain, $$FALSE, $$FALSE, $$ID_LIST)
	WinXAutoSizer_SetInfo (hLB, -1, 0, 1, 0, 0, 1, 1, $$SIZER_SIZERELREST)

	'enable dragging
	WinXListBox_EnableDragging (GetDlgItem (#hMain, $$ID_LIST))

	'add some items
	FOR i = 1 TO 100
		WinXListBox_AddItem (hLB, -1, "Item "+STR$(i))
	NEXT

	'remember to register the callback
	WinXRegOnDrag (#hMain, &onDrag())

	WinXDisplay (#hMain)

	RETURN 0
END FUNCTION
'
' ####################
' #####  onDrag  #####
' ####################
' This function is called when the user drags an drag_running_item
FUNCTION onDrag (idCtr, drag_const, drag_item_start, drag_running_item, x, y)
	SHARED dragItem

	SELECT CASE drag_const
		CASE $$DRAG_START
			'remember the drag_running_item we're dragging
			dragItem =  drag_running_item
			RETURN $$TRUE
		CASE $$DRAG_DRAGGING
			'if drag_running_item is valid then allow otherwise deny
			IF drag_running_item = dragItem THEN RETURN $$FALSE
			RETURN $$TRUE
		CASE $$DRAG_DONE
			hListBox = GetDlgItem (#hMain, $$ID_LIST)

			'if the drag_running_item is invalid, do nothing
			IF drag_running_item = -1 THEN	RETURN $$TRUE

			'move the drag_running_item
			IF dragItem < drag_running_item THEN DEC drag_running_item
			Item$ = WinXListBox_GetItem$ (hListBox, dragItem)
			WinXListBox_RemoveItem (hListBox, dragItem)
			WinXListBox_AddItem (hListBox, drag_running_item, Item$)
			WinXListBox_SetCaret (hListBox, drag_running_item)
	END SELECT
END FUNCTION
END PROGRAM