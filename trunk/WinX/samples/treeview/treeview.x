PROGRAM "treeview"
VERSION "2.00"
'
' treeview - A program to demonstrate tree view controls
' Copyright © public domain 2007 Callum Lowcay and Guy Lonne.
'
' ***** Versions *****
' 1.00-2007-Callum Lowcay-original version.
' 2.00-16jul12-Guy-expanded drag/edit process.
'
'
' ##############################
' #####  Import Libraries  #####
' ##############################
'
	IMPORT "kernel32"   ' operating system
	IMPORT "gdi32"      ' Graphic Device Interface
	IMPORT "shell32"    ' interface to the operating system
	IMPORT "user32"     ' Windows management
	IMPORT "comctl32"   ' common controls (needed for the Windows styles)
'
' xblite DLL headers
'
' dynamically linked libraries
	IMPORT "xst"        ' Xblite Standard library
	IMPORT "xsx"        ' Xblite Standard eXtended library
'	IMPORT "xio"        ' console
	IMPORT "WinX"       ' Callum Lowcay's Windows GUI library
'
'
'
'
' ############################################
' #####  Internal Function Declarations  #####
' ############################################
'
'
DECLARE FUNCTION Entry () ' program entry point

DECLARE FUNCTION CleanUp () ' application cleanup

DECLARE FUNCTION CreateWindows () ' create windows and other child controls

DECLARE FUNCTION GuiTellApiError (msg$) ' displays an API error message
DECLARE FUNCTION GuiTellRunError (msg$) ' displays an execution error message

DECLARE FUNCTION InitWindows () ' for initializations after CreateWindows()

DECLARE FUNCTION Main_OnClose (hWnd) ' to process $$WM_CLOSE wMsg
DECLARE FUNCTION Main_OnCommand (idCtr, notifyCode, hCtr) ' to process $$WM_COMMAND wMsg
DECLARE FUNCTION Main_OnDrag (idCtr, drag_const, drag_item_start, drag_running_item, drag_x, drag_y) ' to process $$WM_LBUTTONUP wMsg
DECLARE FUNCTION Main_OnItem (idCtr, event, VK)
DECLARE FUNCTION Main_OnLabelEdit (idCtr, edit_item, edit_const, newLabel$) ' to process $$TVN_BEGINLABELEDIT wMsg
DECLARE FUNCTION Main_OnSelect (idCtr, notifyCode, parameter) ' to process $$WM_NOTIFY wMsg

DECLARE FUNCTION StartUp () ' application setup
'
'
' #########################################
' #####  Shared Constant Definitions  #####
' #########################################
'
'
' ***** Constants used as control identificators for window #hMain *****
'
' control identificators for #hMain
$$Tree           = 101	' tree view
'
' menu identificators for Window #hMain
$$Menubar        = 8000	' menu bar
'
$$MnuFile        = 8001	' submenu '&File'
$$MnuNode        = 8002	' submenu '&Edit Node'
'
$$MnuFileExit    = 8003	' menu item 'E&xit\tAlt+X'
'
$$MnuEditTree    = 8008	' menu item '&Edit Tree Node\tF2'
$$MnuEndEditTree = 8009	' menu item 'E&nd Edit of Tree Node'
'
FUNCTION Entry ()
	STATIC entry            ' ensure Entry is entered only one time

	IF entry THEN RETURN    ' enter once
	entry = $$TRUE          ' enter occured

'	XioCreateConsole ("", 100) ' create console, if console is not wanted, comment out this line

	IF WinX ()           THEN XstAbend ("Can't initialize WinX.dll")
	IF StartUp ()        THEN XstAbend ("Can't initialize the application")
	IF CreateWindows ()  THEN XstAbend ("Can't create the windows")
	InitWindows ()          ' for initializations after CreateWindows()

	msg$ = "To start editing a TreeView node, select first the node,"
	msg$ = msg$ + $$CRLF$ + "and do any of the following:"
	msg$ = msg$ + $$CRLF$ + "- Triple-click on the selected node;"
	msg$ = msg$ + $$CRLF$ + "- Click on the menu option \"Edit node/Edit Label\tF2\";"
	msg$ = msg$ + $$CRLF$ + "- Press accelerator key F2."
	msg$ = msg$ + $$CRLF$ + $$CRLF$ + "To stop editing:"
	msg$ = msg$ + $$CRLF$ + "- Either press the Enter key;"
	msg$ = msg$ + $$CRLF$ + "- Or click on another node."

	title$ = "Edit a TreeView Label"
	MessageBoxA (#hMain, &msg$, &title$, $$MB_ICONINFORMATION)

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
	SHARED hTV ' the handle to the tree view $$Tree

	ACCEL accel[]          ' accelerator table

	' ***************** Begin window #hMain setup *****************
	' *********** Begin Menu setup **************
	' build the menubar #hMenubar
	menuList$ = "&File, &Edit Node"
	errNum = SetLastError (0)
	#hMenubar = WinXNewMenu (menuList$, $$MnuFile, $$FALSE) ' generate menu #hMenubar
	IFZ #hMenubar THEN ' fail: null handle
		msg$ = "WinXNewMenu: Can't generate menu #hMenubar with '#hMenubar = WinXNewMenu (menuList$, $$MnuFile, $$FALSE)'"
		GuiTellApiError (msg$)
	ENDIF

	' build the submenu #hMnuFile
	menuList$ = "E&xit\tAlt+X"
	errNum = SetLastError (0)
	#hMnuFile = WinXNewMenu (menuList$, $$MnuFileExit, $$FALSE) ' generate menu #hMnuFile
	IFZ #hMnuFile THEN ' fail: null handle
		msg$ = "WinXNewMenu: Can't generate menu #hMnuFile with '#hMnuFile = WinXNewMenu (menuList$, $$MnuFileNew, $$FALSE)'"
		GuiTellApiError (msg$)
	ENDIF

	SetLastError (0)
	bOK = WinXMenu_Attach (#hMnuFile, #hMenubar, $$MnuFile) ' attach submenu #hMnuFile to its parent menu #hMenubar
	IFF bOK THEN  ' fail
		msg$ = "WinXMenu_Attach: Can't attach submenu #hMnuFile to its parent menu #hMenubar with 'bOK = WinXMenu_Attach (#hMnuFile, #hMenubar, $$MnuFile)'"
		GuiTellApiError (msg$)
	ENDIF

	' build the submenu #hMnuNode
	menuList$ = "&Edit Tree Node\tF2, E&nd Edit of Tree Node"
	errNum = SetLastError (0)
	#hMnuNode = WinXNewMenu (menuList$, $$MnuEditTree, $$FALSE) ' generate menu #hMnuNode
	IFZ #hMnuNode THEN ' fail: null handle
		msg$ = "WinXNewMenu: Can't generate menu #hMnuNode with '#hMnuNode = WinXNewMenu (menuList$, $$MnuEditTree, $$FALSE)'"
		GuiTellApiError (msg$)
	ENDIF

	SetLastError (0)
	bOK = WinXMenu_Attach (#hMnuNode, #hMenubar, $$MnuNode) ' attach submenu #hMnuNode to its parent menu #hMenubar
	IFF bOK THEN  ' fail
		msg$ = "WinXMenu_Attach: Can't attach submenu #hMnuNode to its parent menu #hMenubar with 'bOK = WinXMenu_Attach (#hMnuNode, #hMenubar, $$MnuNode)'"
		GuiTellApiError (msg$)
	ENDIF

	DIM accel[] ' array of accelerators
	WinXAddAccelerator (@accel[],$$MnuFileExit, 'X', $$FALSE, $$TRUE, $$FALSE)
	WinXAddAccelerator (@accel[],$$MnuEditTree, $$VK_F2, $$FALSE, $$FALSE, $$FALSE)

	errNum = SetLastError (0)
	hAccel = WinXAddAcceleratorTable (@accel[]) ' create accelerator table
	IFZ hAccel THEN ' fail: null handle
		msg$ = "WinXAddAcceleratorTable: Can't create accelerator table with 'hAccel = WinXAddAcceleratorTable (@accel[])'"
		GuiTellApiError (msg$)
	ENDIF

	' *************** End Menu setup ******************

	hIcon = 0
	' ---- create window #hMain -----
	titleBar$ = "Tree View Drag and Edit Label Demo, v" + VERSION$ (0)
	errNum = SetLastError (0)
	#hMain = WinXNewWindow (0, titleBar$, -1, -1, 406, 334, $$XWSS_APP, 0, hIcon, #hMenubar) ' create window #hMain
	IFZ #hMain THEN ' fail: null handle
		msg$ = "WinXNewWindow: Can't create window #hMain"
		GuiTellApiError (msg$)
		RETURN $$TRUE ' fail
	ENDIF
	WinXAttachAccelerators (#hMain, hAccel) ' attach the accelerator table to the window

	' *************** Begin Controls setup **************

	' creating tree view hTV

	' create an image list of 3 pictures with a size of 16x16 pixels, of 32-bit quality
	errNum = SetLastError (0)
	hImages = ImageList_Create (16, 16, ($$ILC_COLOR32 | $$ILC_MASK), 3, 0) ' create image list hImages
	IFZ hImages THEN ' fail: null handle
		msg$ = "ImageList_Create: Can't create image list hImages"
		GuiTellApiError (msg$)
	ENDIF

	errNum = SetLastError (0)
	hbmImage = LoadBitmapA (hInst, &"imagesImg") ' load the tree view images
	IFZ hbmImage THEN ' fail: null handle
		msg$ = "LoadBitmapA: Can't load the tree view images"
		GuiTellApiError (msg$)
	ENDIF

	iFirstImg = ImageList_AddMasked (hImages, hbmImage, 0x00FF00FF) ' add images to the image list
	IF iFirstImg < 0 THEN ' fail: invalid index
		msg$ = "ImageList_AddMasked: Can't add images to the image list"
		GuiTellApiError (msg$)
	ENDIF

	' label editing enabled
	' dragging enabled

	' style
	' $$TVS_HASBUTTONS  : [-]/[+]
	' $$TVS_HASLINES    : |--lines
	' $$TVS_LINESATROOT : Lines at root
	' $$TVS_EDITLABELS  : Editable

	errNum = SetLastError (0)
	hTV = WinXAddTreeView (#hMain, hImages, $$TRUE, $$TRUE, $$Tree) ' create tree view $$Tree
	IFZ hTV THEN ' fail: null handle
		msg$ = "WinXAddTreeView: Can't create tree view $$Tree"
		GuiTellApiError (msg$)
	ENDIF

	DeleteObject (hbmImage) ' release the bitmap

	' $$WS_HSCROLL : Horizontal scroll bar
	' $$WS_VSCROLL : Vertical scroll bar
	styleAdd = $$WS_HSCROLL | $$WS_VSCROLL ' style to add

	' $$WS_EX_CLIENTEDGE : Sunken Edged Border
	exStyleAdd = $$WS_EX_CLIENTEDGE ' extended style to add

	WinXSetStyle (hTV, styleAdd, exStyleAdd, 0, 0) ' set style and extended style mask
	' **************** End Controls setup ***************

'	MoveWindow (hTV, 1, 1, 396, 298, 1)
	WinXAutoSizer_SetSimpleInfo (hTV, WinXAutoSizer_GetMainSeries (#hMain), 0, 1, 0)
	' ***************** End window #hMain setup *****************

	' register the callback functions
	addrWndProc = &Main_OnCommand () ' to process $$WM_COMMAND wMsg
	WinXRegOnCommand (#hMain, addrWndProc)

	addrWndProc = &Main_OnSelect () ' to process $$WM_NOTIFY wMsg
	WinXRegOnSelect (#hMain, addrWndProc)

	addrWndProc = &Main_OnClose () ' to process $$WM_CLOSE wMsg
	WinXRegOnClose (#hMain, addrWndProc)

	addrWndProc = &Main_OnDrag () ' to process $$WM_LBUTTONUP wMsg
	WinXRegOnDrag (#hMain, addrWndProc)

	addrWndProc = &Main_OnLabelEdit () ' to process $$TVN_BEGINLABELEDIT wMsg
	WinXRegOnLabelEdit (#hMain, addrWndProc)

	addrWndProc = &Main_OnItem ()
	WinXRegOnItem (#hMain, addrWndProc)

	WinXDisplay (#hMain)

END FUNCTION ' CreateWindows

FUNCTION GuiTellApiError (msg$)		' display an API error message

	' get the last error code, then clear it
	errNum = GetLastError ()
	SetLastError (0)
	IFZ errNum THEN RETURN ' was OK!

	fmtMsg$ = "Last error code " + STRING$ (errNum) + ": "

	' set up FormatMessageA arguments
	dwFlags = $$FORMAT_MESSAGE_FROM_SYSTEM | $$FORMAT_MESSAGE_IGNORE_INSERTS
	bufSize = 1020
	buf$ = NULL$ (bufSize)
	ret = FormatMessageA (dwFlags, 0, errNum, 0, &buf$, bufSize, 0)
	IFZ ret THEN
		fmtMsg$ = fmtMsg$ + "(unknown)"
	ELSE
		fmtMsg$ = fmtMsg$ + CSTRING$ (&buf$)
	ENDIF

	IFZ msg$ THEN msg$ = "Windows API error"
	fmtMsg$ = fmtMsg$ + $$CRLF$ + msg$

	' get the OS name and version
	bErr = XstGetOSName (@os$)
	IF bErr THEN
		msg$ = "XstGetOSName: Can't get the OS name"
		GuiTellRunError (msg$)
		st$ = "(unkown)"
	ELSE
		IFZ os$ THEN os$ = "(unkown)"
		st$ = os$ + " ver."
		bErr = XstGetOSVersion (@major, @minor, @platformId, @version$, @platform$)
		IF bErr THEN
			msg$ = "XstGetOSVersion: Can't get the OS version"
			GuiTellRunError (msg$)
			st$ = st$ + " unkown"
		ELSE
			st$ = st$ + STR$ (major) + "." + STRING$ (minor) + "-" + platform$
		ENDIF
	ENDIF
	fmtMsg$ = fmtMsg$ + $$CRLF$ + $$CRLF$ + "OS: " + st$

	' set up MessageBoxA arguments
	hwnd = GetActiveWindow ()
	title$ = PROGRAM$ (0) + "-API Error"
	MessageBoxA (hwnd, &fmtMsg$, &title$, $$MB_ICONSTOP)

	RETURN $$TRUE ' an error really occurred!

END FUNCTION

FUNCTION GuiTellRunError (msg$)		' display the run-time error message

	' get current error, then clear it
	errNum = ERROR (0)
	IFZ errNum THEN RETURN ' was OK!

	fmtMsg$ = "Error code " + STRING$ (errNum) + ": " + ERROR$ (errNum)

	IFZ msg$ THEN msg$ = "Xblite library error"
	fmtMsg$ = fmtMsg$ + $$CRLF$ + msg$

	' set up MessageBoxA arguments
	hwnd = GetActiveWindow ()
	title$ = PROGRAM$ (0) + "-Execution Error"
	MessageBoxA (hwnd, &fmtMsg$, &title$, $$MB_ICONSTOP)

	RETURN $$TRUE ' an error really occurred!

END FUNCTION

FUNCTION InitWindows () ' for initializations after CreateWindows()
	SHARED hTV ' the handle to the tree view $$Tree

	WinXTreeView_FreezeOnSelect (hTV) ' disable $$TVN_SELCHANGED

	item$ = "Root"
	SetLastError (0)
	#Tree_root = WinXTreeView_AddItem (hTV, $$TVI_ROOT, $$TVI_LAST, 1, 1, item$)
	IFZ #Tree_root THEN ' fail
		msg$ = "WinXTreeView_AddItem: Can't add item " + item$
		GuiTellApiError (msg$)
	ENDIF

	'add some items to the tree view
	n = WinXTreeView_AddItem (hTV, #Tree_root, $$TVI_LAST, 0, 0, "Node 1")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 3, 2, "Leaf 1")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 3, 2, "Leaf 2")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 3, 2, "Leaf 3")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 3, 2, "Leaf 4")

	WinXTreeView_ExpandItem (hTV, n)

	n = WinXTreeView_AddItem (hTV, #Tree_root, $$TVI_LAST, 0, 0, "Node 2")
	n2 = WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 0, 0, "Node 3")
	WinXTreeView_AddItem (hTV, n2, $$TVI_LAST, 3, 2, "Leaf 5")
	WinXTreeView_AddItem (hTV, n2, $$TVI_LAST, 3, 2, "Leaf 6")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 3, 2, "Leaf 7")
	WinXTreeView_AddItem (hTV, n, $$TVI_LAST, 3, 2, "Leaf 8")

	WinXTreeView_UseOnSelect (hTV) ' re-enable $$TVN_SELCHANGED
	WinXTreeView_SetSelection (hTV, #Tree_root)

	WinXShow (#hMain) ' show window #hMain

END FUNCTION

FUNCTION Main_OnClose (hWnd)

'	RETURN 1 ' quit is canceled
	' quit application
	PostQuitMessage ($$WM_QUIT)
	RETURN 0 ' quit is confirmed

END FUNCTION

FUNCTION Main_OnCommand (idCtr, notifyCode, hCtr)
	SHARED hTV		' the handle to the tree view
	SHARED g_edit_typein		' handle to the edit control used to Main_OnItem

	SELECT CASE idCtr
		CASE $$MnuFileExit
			Main_OnClose (#hMain)
			RETURN 1 ' handled
			'
		CASE $$MnuEditTree
			hItem = WinXTreeView_GetSelection (hTV)
			SetFocus (hTV)
			g_edit_typein = SendMessageA (hTV, $$TVM_EDITLABEL, 0, hItem)
			'
			RETURN 1 ' handled
			'
		CASE $$MnuEndEditTree
			SendMessageA (hTV, $$TVM_ENDEDITLABELNOW, 0, 0)
			RETURN 1 ' handled
			'
		CASE $$IDOK
			' capture the "Enter" key from the inplace edit box, which is placed there
			' by Windows in response to $$TVM_EDITLABEL
			IF notifyCode = $$BN_CLICKED THEN
				IF g_edit_typein THEN
					SendMessageA (hTV, $$TVM_ENDEDITLABELNOW, 0, 0)
					RETURN 1 ' handled
				ENDIF
			ENDIF ' clicked
			'
	END SELECT ' CASE idCtr

END FUNCTION

' Called when the user drags a tree view item
FUNCTION Main_OnDrag (idCtr, drag_const, drag_item_start, drag_running_item, drag_x, drag_y)
	SHARED hTV ' the handle to the tree view
	STATIC s_dragItem_start ' to make sure we drag and drop the right item

	IFZ hTV THEN RETURN

	SELECT CASE drag_const
		CASE $$DRAG_START
			IF drag_running_item = #Tree_root THEN RETURN ' You cannot drag this drag_running_item
			'
			'keep track of the drag_running_item we're dragging
			s_dragItem_start = drag_running_item
			RETURN 1 ' OK!

		CASE $$DRAG_DRAGGING
			' the drag_running_item is a valid drop target
			IF drag_running_item = s_dragItem_start || drag_running_item = 0 || drag_running_item = WinXTreeView_GetParentItem (hTV, s_dragItem_start) THEN RETURN
			'
			RETURN 1 ' OK!

		CASE $$DRAG_DONE
			IF drag_item_start <> s_dragItem_start THEN RETURN
			IFZ drag_running_item THEN RETURN
			IF drag_running_item = drag_item_start THEN RETURN

			' valid g_drag_running_item, move it!
			hItemNew = WinXTreeView_CopyItem (hTV, drag_running_item, $$TVI_FIRST, s_dragItem_start)
			WinXTreeView_DeleteItem (hTV, s_dragItem_start)
			s_dragItem_start = 0
			'
			RETURN 1 ' OK!
			'
	END SELECT

END FUNCTION

FUNCTION Main_OnItem (idCtr, event, VK)
	SHARED hTV		' the handle to the tree view
	SHARED g_edit_typein		' handle to the edit control used to Main_OnItem

	SELECT CASE event
		CASE $$TVN_KEYDOWN
			SELECT CASE idCtr
				CASE $$Tree
					SELECT CASE VK
						CASE $$VK_F2
							IFZ g_edit_typein THEN
								' Begins in-place editing of the specified item's text,
								' replacing the text of the item with a single-line edit
								' control containing the text.
								' This message implicitly selects and focuses the specified item.
								' The control must have the focus before you send this
								' message to the control.
								hItem = WinXTreeView_GetSelection (hTV)
								SetFocus (hTV)
								g_edit_typein = SendMessageA (hTV, $$TVM_EDITLABEL, 0, hItem) ' call the $$TVM_EDITLABEL message
								'
								IFZ g_edit_typein THEN
									msg$ = "Main_OnItem: Can't get the edit control used to edit a TreeView item text"
									GuiTellApiError (msg$)
								ELSE
									' limit the length of the text that the User may enter into the edit control
									SendMessageA (g_edit_typein, $$EM_LIMITTEXT, 30, 0)		' limit text to 30 characters
								ENDIF
							ELSE
							ENDIF ' g_edit_typein
							'
							RETURN 1		' handled
							'
					END SELECT		' VK
					'
			END SELECT		' idCtr
			'
	END SELECT		' event

END FUNCTION

' Called when the user attempts to edit a label
FUNCTION Main_OnLabelEdit (idCtr, edit_const, hItem, newLabel$)
	SHARED hTV		' the handle to the tree view $$Tree
	SHARED g_edit_typein ' handle to the edit control used to edit a TreeView item text
	STATIC s_oldLabel$

	SELECT CASE edit_const
		CASE $$EDIT_START
			s_oldLabel$ = WinXTreeView_GetItemLabel$ (hTV, hItem)
			RETURN 1
			'
		CASE $$EDIT_DONE
			IFZ TRIM$ (newLabel$) THEN
				WinXTreeView_SetItemLabel (hTV, hItem, s_oldLabel$)
				RETURN
			ENDIF
			msg$ = "Old label \"" + s_oldLabel$ + "\", changed to \"" + newLabel$ + "\""
			title$ = "Edit a TreeView Label"
			MessageBoxA (#hMain, &msg$, &title$, $$MB_ICONINFORMATION)
			RETURN 1
			'
	END SELECT

END FUNCTION

FUNCTION Main_OnSelect (idCtr, notifyCode, parameter) ' to process $$WM_NOTIFY wMsg
	SHARED hTV ' the handle to the tree view $$Tree

	NM_TREEVIEW nmtv     ' tree view structure

	SELECT CASE idCtr
		CASE $$Tree
			SELECT CASE notifyCode
				CASE $$TVN_SELCHANGED
					hItem = 0
					IF parameter THEN
						WinXTreeView_FreezeOnSelect (hTV) ' disable $$TVN_SELCHANGED
						' fill nmtv using parameter
						IF #hNodeExpandOld THEN WinXTreeView_CollapseItem (hTV, #hNodeExpandOld)
						'
						XstCopyMemory (parameter, &nmtv, SIZE (nmtv))
						hItem = nmtv.itemNew.hItem
						IFZ WinXTreeView_GetChildCount (hTV, hItem) THEN
							hParent = WinXTreeView_GetParentItem (hTV, hItem)
							IF hParent <> #hNodeExpandOld THEN
								WinXTreeView_CollapseItem (hTV, #hNodeExpandOld)
								WinXTreeView_ExpandItem (hTV, hParent)
								#hNodeExpandOld = hParent
							ENDIF
						ELSE
							' has children
							WinXTreeView_ExpandItem (hTV, hItem)
							#hNodeExpandOld = hItem
						ENDIF
						WinXTreeView_SetSelection (hTV, hItem)
					ENDIF
					WinXTreeView_UseOnSelect (hTV) ' re-enable $$TVN_SELCHANGED
					'
					RETURN 1 ' handled
					'
			END SELECT
			'
	END SELECT

END FUNCTION

FUNCTION StartUp () ' application setup
	'
	' Returns
	' - an error flag: $$TRUE = fail, $$FALSE = success

	SHARED hInst

	errNum = SetLastError (0)
	hInst = GetModuleHandleA (0) ' get current instance handle
	IFZ hInst THEN ' fail: null handle
		msg$ = "GetModuleHandleA: Can't get current instance handle"
		GuiTellApiError (msg$)
		RETURN $$TRUE ' fail
	ENDIF

END FUNCTION

END PROGRAM
