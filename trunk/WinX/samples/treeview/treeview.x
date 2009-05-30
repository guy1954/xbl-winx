'
' ####################
' #####  PROLOG  #####
' ####################
'
' A program to demonstrate tree view controls
'
' This program is in the public domain
'
VERSION	"1.00"
'
	IMPORT	"xst"   		' standard library	: required by most programs
'	IMPORT  "xsx"				' extended std LIBRARY
'	IMPORT	"xma"
'	IMPORT	"xio"				' console io library
	IMPORT	"gdi32"     ' gdi32.dll
	IMPORT  "user32"    ' user32.dll
	IMPORT  "kernel32"  ' kernel32.dll
	IMPORT  "comctl32"	' comctl32.dll			: common controls library
'	IMPORT	"comdlg32"  ' comdlg32.dll	    : common dialog library
'	IMPORT	"xma"   		' math library			: Sin/Asin/Sinh/Asinh/Log/Exp/Sqrt...
'	IMPORT	"xcm"				' complex math library
'	IMPORT  "msvcrt"		' msvcrt.dll				: C function library
	IMPORT  "shell32"   ' shell32.dll
	IMPORT	"WinX"			' The Xwin GUI library

'define constants
$$ID_TREE = 100

DECLARE FUNCTION Entry ()
DECLARE FUNCTION initWindow ()
DECLARE FUNCTION onLabelEdit (control, item, code, STRING text)
DECLARE FUNCTION onDrag (control, code, item, x, y)
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

	'create the main window
	#hMain = WinXNewWindow (0, "Tree View demo", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)
	
	'Create the tree view
	hIml = ImageList_Create (16, 16, $$ILC_COLOR32|$$ILC_MASK, 3, 0)
	ImageList_AddMasked (hIml, LoadImageA (0, &"images.bmp", $$IMAGE_BITMAP, 0, 0, $$LR_LOADFROMFILE), 0x00FF00FF)
	hTV = WinXAddTreeView (#hMain, hIml, $$TRUE, $$TRUE, $$ID_TREE)
	WinXAutoSizer_SetSimpleInfo (hTV, -1, 0, 1, 0)
	
	'add some items to the tree view
	#root = WinXTreeView_AddItem (hTV, $$TVI_ROOT, $$TVI_LAST, 1, 1, "Root")
	n = WinXTreeView_AddItem (hTV, #root, $$TVI_LAST, 0, 0, "Node 1")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 2, 2, "Leaf 1")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 2, 2, "Leaf 2")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 2, 2, "Leaf 3")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 2, 2, "Leaf 4")
	n = WinXTreeView_AddItem (hTV, #root, $$TVI_LAST, 0, 0, "Node 2")
	n2 = WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 0, 0, "Node 3")
	WinXTreeView_AddItem (hTV, n2, $$TVI_LAST, 2, 2, "Leaf 5")
	WinXTreeView_AddItem (hTV, n2, $$TVI_LAST, 2, 2, "Leaf 6")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 2, 2, "Leaf 7")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 2, 2, "Leaf 8")
	n = WinXTreeView_AddItem (hTV, #root, $$TVI_LAST, 2, 2, "Leaf 9")
	n = WinXTreeView_AddItem (hTV, #root, $$TVI_LAST, 2, 2, "Leaf 10")
	
	'must register the callbacks
	WinXRegOnLabelEdit (#hMain, &onLabelEdit())
	WinXRegOnDrag (#hMain, &onDrag())
	
	WinXDisplay (#hMain)
	
	RETURN 0
END FUNCTION
'
' #########################
' #####  onLabelEdit  #####
' #########################
' Called when the user attempts to edit a label
FUNCTION onLabelEdit (control, code, item, STRING text)
	SELECT CASE code
		CASE $$EDIT_START
			'always allow editing
			RETURN $$TRUE
		CASE $$EDIT_DONE
			'always allow the change
			WinXDialog_Error ("You changed tree view item: "+STRING$(item)+" to: \n\""+text+"\"", "info", 0)
			RETURN $$TRUE
	END SELECT
END FUNCTION
'
' ####################
' #####  onDrag  #####
' ####################
' Called when the user drags a tree view item
FUNCTION onDrag (control, code, item, x, y)
	STATIC dragItem
	
	SELECT CASE code
		CASE $$DRAG_START
			IF item = #root THEN
				' You cannot drag this item
				RETURN $$FALSE
			ELSE
				'keep track of the item we're dragging
				dragItem = item
				RETURN $$TRUE
			END IF
		CASE $$DRAG_DRAGGING
			'Make sure the item is a valid drop target
			IF item = dragItem || item = 0 || item = WinXTreeView_GetParentItem (GetDlgItem (#hMain, $$ID_TREE), dragItem) THEN RETURN $$FALSE ELSE RETURN $$TRUE
		CASE $$DRAG_DONE
			hTV = GetDlgItem (#hMain, $$ID_TREE)
			'if item is valid, move it
			IF !((item = dragItem) || (item = 0) || (item = WinXTreeView_GetParentItem (hTV, dragItem))) THEN
				WinXTreeView_CopyItem (hTV, item, $$TVI_FIRST, dragItem)
				WinXTreeView_DeleteItem (hTV, dragItem)
			END IF
			RETURN $$TRUE
	END SELECT
END FUNCTION
END PROGRAM