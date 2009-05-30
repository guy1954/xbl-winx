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
DECLARE FUNCTION onDrag (idControl, status, item, x, y)
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
' This function is called when the user drags an item
FUNCTION onDrag (idControl, status, item, x, y)
	SHARED dragItem
	
	SELECT CASE status
		CASE $$DRAG_START
			'remember the item we're dragging
			dragItem =  item
			RETURN $$TRUE
		CASE $$DRAG_DRAGGING
			'if item is valid then allow otherwise deny
			IF item = dragItem THEN RETURN $$FALSE
			RETURN $$TRUE
		CASE $$DRAG_DONE
			hListBox = GetDlgItem (#hMain, $$ID_LIST)
			
			'if the item is invalid, do nothing
			IF item = -1 THEN	RETURN $$TRUE
			
			'move the item
			IF dragItem < item THEN DEC item
			Item$ = WinXListBox_GetItem$ (hListBox, dragItem)
			WinXListBox_RemoveItem (hListBox, dragItem)
			WinXListBox_AddItem (hListBox, item, Item$)
			WinXListBox_SetCaret (hListBox, item)
	END SELECT
END FUNCTION
END PROGRAM