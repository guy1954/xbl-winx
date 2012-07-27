PROGRAM "listview"
VERSION "2.00"
'
' listview - A program to demonstrate list view controls
' Copyright © public domain 2007 Callum Lowcay and Guy Lonne.
'
' ***** Versions *****
' 1.00-2007-Callum Lowcay-original version.
' 2.00-25jul12-Guy-expanded edit process.
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
' These are standard functions that belong to all Xblite GUI programs
'
DECLARE FUNCTION Entry                   () ' program entry point
DECLARE FUNCTION StartUp                 () ' application setup
DECLARE FUNCTION CleanUp                 () ' application cleanup
DECLARE FUNCTION CreateWindows           () ' create windows and other child controls
DECLARE FUNCTION InitWindows             () ' for initializations after CreateWindows()
DECLARE FUNCTION GuiTellApiError         (msg$)       ' displays an API error message
DECLARE FUNCTION GuiTellRunError         (msg$)       ' displays an execution error message

'
'
' ============================================
' =====  Callback Function Declarations  =====
' ============================================
'
' WinX's callback functions for your windows:
' To process $$WM_PAINT wMsg
' - windowX_OnPaint (XLONG hWnd, XLONG hdc)
' - registered with WinXRegOnPaint
'
' To process $$WM_COMMAND wMsg
' - windowX_OnCommand (XLONG idCtr, XLONG notifyCode, XLONG hCtr)
' - registered with WinXRegOnCommand
'
' To process $$WM_NOTIFY wMsg's events
' - windowX_OnSelect (XLONG idCtr, XLONG event, XLONG parameter)
' - registered with WinXRegOnSelect
'
' To process $$WM_CLOSE wMsg
' - windowX_OnClose (XLONG hWnd)
' Note: a zero-RETURN resumes WinX's default closing,
'       a non-zero RETURN cancels WinX's default closing.
' - registered with WinXRegOnClose
'
DECLARE FUNCTION Main_OnCommand (idCtr, notifyCode, hCtr) ' to process $$WM_COMMAND wMsg
DECLARE FUNCTION Main_OnSelect (idCtr, notifyCode, parameter) ' to process $$WM_NOTIFY wMsg
DECLARE FUNCTION Main_OnClose (hWnd) ' to process $$WM_CLOSE wMsg

DECLARE FUNCTION Main_OnLabelEdit (idCtr, edit_const, edit_item, edit_sub_item, newLabel$) ' to process $$LVN_BEGINLABELEDIT wMsg
DECLARE FUNCTION Main_OnItem (idCtr, event, VK)  ' to process $$LVN_KEYDOWN wMsg
' ============================================
'
'
' #########################################
' #####  Shared Constant Definitions  #####
' #########################################
'
' Shared constants which represent the control IDs.
' (the prefix '$$' declares implicitly a shared constant)
'
'
' ***** Constants used as control identificators for window #hMain *****
'
' control identificators for #hMain
$$ID_LV          = 101	' list view 'Column 1,Column 2,Column 3,Column 4'
'
' menu identificators for Window #hMain
$$Menubar        = 8000	' menu bar
'
$$MnuFile        = 8001	' submenu '&File'
$$MnuCell        = 8002	' submenu '&Edit Cell'
'
$$MnuFileExit    = 8003	' menu item 'E&xit\tAlt+X'
'
$$MnuEditList    = 8008	' menu item '&Edit Cell\tF2'
$$MnuEndEditList = 8009	' menu item 'E&nd Edit of Cell'
'
'
' ***** Shared Program Constants *****
'
'
'
' ##########################################
' #####  Shared Variable Declarations  #####
' ##########################################
'
' (SHARED declares shared variables; in function bodies, a variable prefixed
'  by '#' is also a shared variable, but implicitly declared)
'
'
'
' #################################
' #####  Program Entry Point  #####
' #################################
'
' this function is invoked by convention on program startup,
' not because of its name, but because it is defined first
' (eg its body is in first position in the source)
'
FUNCTION Entry ()
	SHARED hLV ' the global handle to the ListView
	STATIC entry            ' ensure Entry is entered only one time

	IF entry THEN RETURN    ' enter once
	entry = $$TRUE          ' enter occured

'	XioCreateConsole ("", 100) ' create console, if console is not wanted, comment out this line

	' The WinX() initialization call should go in the entry function.
	' This is because WinX could crash if a WinX function is called before
	' the library is initialized.
	IF WinX ()           THEN XstAbend ("Can't initialize WinX.dll")
	IF StartUp ()        THEN XstAbend ("Can't initialize the application")
	IF CreateWindows ()  THEN XstAbend ("Can't create the windows")
	InitWindows ()          ' for initializations after CreateWindows()

	text$ = "Do you want some explanations?"
	title$ = "Starting " + PROGRAM$ (0) + ".exe"
	mret = WinXDialog_Question (#hMain, text$, title$, $$FALSE, 1)		' default to the 'No' button
	IF mret = $$IDYES THEN
		msg$ = "To start editing a ListView cell, select first the cell,"
		msg$ = msg$ + $$CRLF$ + "and do any of the following:"
		msg$ = msg$ + $$CRLF$ + "- Triple-click on the selected cell;"
		msg$ = msg$ + $$CRLF$ + "- Click on the menu option \"Edit Cell\tF2\";"
		msg$ = msg$ + $$CRLF$ + "- Press accelerator key F2."
		msg$ = msg$ + $$CRLF$ + $$CRLF$ + "To stop editing:"
		msg$ = msg$ + $$CRLF$ + "- Either press the Enter key,"
		msg$ = msg$ + $$CRLF$ + "- Or click on another cell."
		title$ = "Edit a ListView Cell"
		MessageBoxA (#hMain, &msg$, &title$, $$MB_ICONINFORMATION)
	ENDIF
	SetFocus (hLV)

	WinXDoEvents ()         ' monitor the events
	CleanUp ()              ' application cleanup
'	XioFreeConsole ()       ' free console
	QUIT (0)

END FUNCTION


FUNCTION StartUp () ' application setup
	' Your initialization code goes here
	' e.g. initializing global data structures, reading registry settings, loading files...
	'
	' Returns
	' - an error flag: $$TRUE = fail, $$FALSE = success

	SHARED hInst

	' the DLL are initialized here, to prevent non-initializing calls from crashing

	errNum = SetLastError (0)
	hInst = GetModuleHandleA (0) ' get current instance handle
	IFZ hInst THEN ' fail: null handle
		msg$ = "GetModuleHandleA: Can't get current instance handle with 'hInst = GetModuleHandleA (0)'"
		GuiTellApiError (msg$)
		RETURN $$TRUE ' fail
	ENDIF

END FUNCTION

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

FUNCTION CreateWindows ()	' create the windows of the application
' This function generates all the windows that you've created
' and makes the first window visible
	SHARED hInst
	SHARED hLV ' the global handle to the ListView

	ACCEL accel[]          ' accelerator table


	' ***************** Begin window #hMain setup *****************
	' *********** Begin Menu setup **************
	' build the menubar #hMenubar
	menuList$ = "&File, &Edit Cell"
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
		msg$ = "WinXNewMenu: Can't generate menu #hMnuFile with '#hMnuFile = WinXNewMenu (menuList$, $$MnuFileExit, $$FALSE)'"
		GuiTellApiError (msg$)
	ENDIF

	SetLastError (0)
	bOK = WinXMenu_Attach (#hMnuFile, #hMenubar, $$MnuFile) ' attach submenu #hMnuFile to its parent menu #hMenubar
	IFF bOK THEN  ' fail
		msg$ = "WinXMenu_Attach: Can't attach submenu #hMnuFile to its parent menu #hMenubar with 'bOK = WinXMenu_Attach (#hMnuFile, #hMenubar, $$MnuFile)'"
		GuiTellApiError (msg$)
	ENDIF

	' build the submenu #hMnuCell
	menuList$ = "&Edit Cell\tF2, E&nd Edit of Cell"
	errNum = SetLastError (0)
	#hMnuCell = WinXNewMenu (menuList$, $$MnuEditList, $$FALSE) ' generate menu #hMnuCell
	IFZ #hMnuCell THEN ' fail: null handle
		msg$ = "WinXNewMenu: Can't generate menu #hMnuCell with '#hMnuCell = WinXNewMenu (menuList$, $$MnuEditList, $$FALSE)'"
		GuiTellApiError (msg$)
	ENDIF

	SetLastError (0)
	bOK = WinXMenu_Attach (#hMnuCell, #hMenubar, $$MnuCell) ' attach submenu #hMnuCell to its parent menu #hMenubar
	IFF bOK THEN  ' fail
		msg$ = "WinXMenu_Attach: Can't attach submenu #hMnuCell to its parent menu #hMenubar with 'bOK = WinXMenu_Attach (#hMnuCell, #hMenubar, $$MnuCell)'"
		GuiTellApiError (msg$)
	ENDIF

	DIM accel[] ' array of accelerators
	WinXAddAccelerator (@accel[],$$MnuFileExit, 'X', $$FALSE, $$TRUE, $$FALSE)
	WinXAddAccelerator (@accel[],$$MnuEditList, $$VK_F2, $$FALSE, $$FALSE, $$FALSE)

	errNum = SetLastError (0)
	hAccel = WinXAddAcceleratorTable (@accel[]) ' create accelerator table
	IFZ hAccel THEN ' fail: null handle
		msg$ = "WinXAddAcceleratorTable: Can't create accelerator table with 'hAccel = WinXAddAcceleratorTable (@accel[])'"
		GuiTellApiError (msg$)
	ENDIF

	' *************** End Menu setup ******************

	hIcon = 0
	' ---- create window #hMain -----
	titleBar$ = "List View Demo, v" + VERSION$ (0)
	errNum = SetLastError (0)
	#hMain = WinXNewWindow (0, titleBar$, -1, -1, 406, 334, $$XWSS_APP, 0, hIcon, #hMenubar) ' create window #hMain
	IFZ #hMain THEN ' fail: null handle
		msg$ = "WinXNewWindow: Can't create window #hMain with '#hMain = WinXNewWindow (0, titleBar$, -1, -1, 406, 334, $$XWSS_APP, 0, hIcon, #hMenubar)'"
		GuiTellApiError (msg$)
		RETURN $$TRUE ' fail
	ENDIF

	WinXAttachAccelerators (#hMain, hAccel) ' attach the accelerator table to the window

	' *************** Begin Controls setup **************

	' creating list view hLV
	' must have the $$LVS_EDITLABELS and $$LVS_REPORT styles
	errNum = SetLastError (0)
	hLV = WinXAddListView (#hMain, 0, 0, $$TRUE, $$LVS_REPORT | $$LVS_SINGLESEL, $$ID_LV)
	IFZ hLV THEN ' fail: null handle
		msg$ = "WinXAddListView: Can't create list view $$ID_LV"
		GuiTellApiError (msg$)
	ENDIF
	' **************** End Controls setup ***************

'	MoveWindow (hLV, 1, 1, 393, 275, 1)
	WinXAutoSizer_SetSimpleInfo (hLV, WinXAutoSizer_GetMainSeries (#hMain), 0, 1, 0)
	' ***************** End window #hMain setup *****************

	' register the callback functions
	addrWndProc = &Main_OnCommand () ' to process $$WM_COMMAND wMsg
	WinXRegOnCommand (#hMain, addrWndProc)

	addrWndProc = &Main_OnSelect () ' to process $$WM_NOTIFY wMsg
	WinXRegOnSelect (#hMain, addrWndProc)

	addrWndProc = &Main_OnLabelEdit () ' to process $$LVN_BEGINLABELEDIT wMsg
	WinXRegOnLabelEdit (#hMain, addrWndProc)

	addrWndProc = &Main_OnItem ()  ' to process $$LVN_KEYDOWN wMsg
	WinXRegOnItem (#hMain, addrWndProc)

	addrWndProc = &Main_OnClose () ' to process $$WM_CLOSE wMsg
	WinXRegOnClose (#hMain, addrWndProc)

	' Comment out WinXDisplay if you don't want the window visible initially
	WinXDisplay (#hMain)


END FUNCTION ' CreateWindows

'
'
' ############################
' #####  InitWindows ()  #####
' ############################
'
' Add code to this function to initialize anything your program needs
' to initialize after CreateWindows() creates your programs windows.
' For initialization before CreateWindows(), add code to StartUp().
'
' Do not delete this function, leave it empty if not needed.
'
FUNCTION InitWindows () ' for initializations after CreateWindows()
	SHARED hLV ' the global handle to the ListView

	WinXListView_AddColumn (hLV, 0, 100, "Column 1", 0)
	WinXListView_AddColumn (hLV, 1, 100, "Column 2", 1)
	WinXListView_AddColumn (hLV, 2, 100, "Column 3", 2)
	WinXListView_AddColumn (hLV, 3, 100, "Column 4", 3)

	WinXListView_FreezeOnSelect (hLV) ' disable $$LVN_ITEMCHANGED

	WinXListView_AddItem (hLV, -1, "Item 1 \0E \0A \05", -1)
	WinXListView_AddItem (hLV, -1, "Item 2 \0D \0B \04", -1)
	WinXListView_AddItem (hLV, -1, "Item 3 \0C \0C \03", -1)
	WinXListView_AddItem (hLV, -1, "Item 4 \0B \0D \02", -1)
	WinXListView_AddItem (hLV, -1, "Item 5 \0A \0E \01", -1)

	WinXListView_UseOnSelect (hLV) ' re-enable $$LVN_ITEMCHANGED
	DIM iItems[0] ' selectionne the first item
	WinXListView_SetSelection (hLV, @iItems[])

	WinXShow (#hMain) ' show window #hMain

END FUNCTION


FUNCTION CleanUp () ' application cleanup
	' this is where you clean up any resources that need to be deallocated


	WinXCleanUp () ' optional cleanup

END FUNCTION


FUNCTION Main_OnCommand (idCtr, notifyCode, hCtr)
	SHARED hLV ' the global handle to the ListView
	SHARED g_edit_typein		' handle to the edit control used to Main_OnItem
	SHARED g_iSelect	' index of the edited item
	SHARED g_iSubItem	' index of the edited sub-item

	SELECT CASE idCtr
		CASE $$MnuFileExit
			Main_OnClose (#hMain)
			RETURN 1 ' handled
			'
		CASE $$MnuEditList
			IF g_iSelect <> -1 THEN
				SetFocus (hLV)
				g_edit_typein = SendMessageA (hLV, $$LVM_EDITLABEL, g_iSelect, g_iSubItem)
			ENDIF
			RETURN 1 ' handled
			'
		CASE $$MnuEndEditList
'			SendMessageA (hLV, $$LVM_ENDEDITLABELNOW, 0, 0)
			RETURN 1 ' handled
			'
	END SELECT ' CASE idCtr

END FUNCTION


FUNCTION Main_OnSelect (idCtr, notifyCode, parameter) ' to process $$WM_NOTIFY wMsg
	SHARED hLV ' the global handle to the ListView
	SHARED g_edit_typein		' handle to the edit control used to Main_OnItem
	SHARED g_iSelect	' index of the edited item
	SHARED g_iSubItem	' index of the edited sub-item

	STATIC s_numItemOld    ' previous item number (0 is Not a number)
	STATIC s_numSubItemOld ' previous sub-item number
	NM_LISTVIEW nmlv       ' list view structure

	SELECT CASE idCtr
		CASE $$ID_LV
			SELECT CASE notifyCode
				CASE $$LVN_ITEMCHANGED
					IF parameter THEN
						XstCopyMemory (parameter, &nmlv, SIZE (nmlv))
						IF ((nmlv.iItem + 1) = s_numItemOld) && ((nmlv.iSubItem + 1) = s_numSubItemOld) THEN RETURN 1
						'
						s_numItemOld = (nmlv.iItem + 1)
						s_numSubItemOld = (nmlv.iSubItem + 1)
						'
						WinXListView_FreezeOnSelect (hLV) ' disable $$LVN_ITEMCHANGED
						g_iSelect = nmlv.iItem
						g_iSubItem = nmlv.iSubItem
					ENDIF
					WinXListView_UseOnSelect (hLV) ' re-enable $$LVN_ITEMCHANGED
					SetFocus (hLV)
					RETURN 1 ' handled
					'
			END SELECT
			'
	END SELECT

END FUNCTION


FUNCTION Main_OnClose (hWnd)

'	RETURN 1 ' quit is canceled
	' quit application
	PostQuitMessage ($$WM_QUIT)
	RETURN 0 ' quit is confirmed

END FUNCTION

' Called when the user attempts to edit a label
FUNCTION Main_OnLabelEdit (idCtr, edit_const, edit_item, edit_sub_item, newLabel$)
	SHARED hLV ' the global handle to the ListView
	SHARED g_edit_typein		' handle to the edit control used to Main_OnItem
	SHARED g_iSelect	' index of the edited item
	SHARED g_iSubItem	' index of the edited sub-item

	STATIC s_oldLabel$

	SELECT CASE edit_const
		CASE $$EDIT_START
			g_iSelect = edit_item
			g_iSubItem = edit_sub_item
			WinXListView_GetItemText (hLV, g_iSelect, g_iSubItem, @text$[])
			s_oldLabel$ = text$[g_iSubItem]
			s_oldLabel$ = TRIM$ (s_oldLabel$)
			RETURN 1
			'
		CASE $$EDIT_DONE
			'
			retVal = 0 ' not handled
			wType = $$MB_ICONSTOP
			newLabel$ = TRIM$ (newLabel$)
			SELECT CASE TRUE
				CASE LEN (newLabel$) = 0
					msg$ = "Empty entry; old cell contents \"" + s_oldLabel$ + "\" restored!"
					'
				CASE newLabel$ = s_oldLabel$
					msg$ = "Expected old cell contents \"" + s_oldLabel$ + "\" to change"
					'
				CASE ELSE
					retVal = 1 ' HANDLED!
					msg$ = "Old cell contents \"" + s_oldLabel$ + "\", changed to \"" + newLabel$ + "\""
					wType = $$MB_ICONINFORMATION
					'
			END SELECT
			'
			title$ = "Edit a ListView Cell"
			MessageBoxA (#hMain, &msg$, &title$, wType)
			'
			IF retVal = 1 THEN WinXListView_SetItemText (hLV, g_iSelect, g_iSubItem, newLabel$) ' update the cell
			'
			DIM iItems[0]
			iItems[0] = g_iSelect
			WinXListView_SetSelection (hLV, @iItems[])
			'
			RETURN retVal
			'
	END SELECT

END FUNCTION

FUNCTION Main_OnItem (idCtr, event, VK)
	SHARED hLV ' the global handle to the ListView
	SHARED g_edit_typein		' handle to the edit control used to Main_OnItem
	SHARED g_iSelect	' index of the edited item
	SHARED g_iSubItem	' index of the edited sub-item

	SELECT CASE event
		CASE $$LVN_KEYDOWN
			SELECT CASE idCtr
				CASE $$ID_LV
					SELECT CASE VK
						CASE $$VK_F2
							count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0) ' number of items
							IFZ count THEN EXIT SELECT
							'
							IFZ g_edit_typein THEN
								' Begins in-place editing of the specified item's text,
								' replacing the text of the item with a single-line edit
								' control containing the text.
								' This message implicitly selects and focuses the specified item.
								' The control must have the focus before you send this
								' message to the control.
								DIM iItems[]
								WinXListView_GetSelection (hLV, @iItems[])
								IFZ iItems[] THEN RETURN
								'
								g_iSelect = iItems[0]
								SetFocus (hLV)
								g_edit_typein = SendMessageA (hLV, $$LVM_EDITLABEL, 0, hItem) ' call the $$LVM_EDITLABEL message
								'
								IFZ g_edit_typein THEN
									msg$ = "Main_OnItem: Can't get the edit control used to edit a ListView item text"
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

END PROGRAM
