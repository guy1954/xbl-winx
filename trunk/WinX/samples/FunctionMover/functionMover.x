'
' ####################
' #####  PROLOG  #####
' ####################
'
' A program which allows you to move functions in a program to improve readability
'
' It was originally a little prorgram I wrote to solve my dislike of randomly ordered functions.
' I used WinX for the GUI as an exercise in eating one's own dog food, and
' because I'm too lazy to write another demo it is now part of the WinX demos
'
' This program demonstrates list boxes, buttons, the Auto Sizer, open and save dialogs
' and the use of WinX in a real program
'
' This program is in the public domain
'
VERSION "1.00"
'
	IMPORT "xst"				' Standard library : required by most programs
	IMPORT "xsx"				' Extended standard library
'	IMPORT "xio"				' Console input/ouput library

'	IMPORT "xst_s.lib"
' IMPORT "xsx_s.lib"
' IMPORT "xio_s.lib"

	IMPORT "gdi32"			' gdi32.dll
	IMPORT "user32"		  ' user32.dll
	IMPORT "kernel32"	  ' kernel32.dll
'	IMPORT "shell32"		' shell32.dll
'	IMPORT "msvcrt"		  ' msvcrt.dll
	IMPORT "WinX"				' GUI library
	
'
'define constants
$$ID_UP		= 0
$$ID_DOWN	= 1
$$ID_SAVE	= 2
$$ID_LOAD	= 3
$$ID_LIST	= 4

'a filter string for XBlite source files
'note that it contains pairs of strings seperated with \0.  The whole thing is terminated with another \0
'The first string in each pair is displayed to the user in the file types combo box
'the second is a filter pattern which specifies which files the type applies to
$$FILTERSTRING$ = "XBlite source files (*.x)\0*.x\0All Files (*.*)\0*.*\0\0"

TYPE FUNC
	XLONG	.decLine
	XLONG	.startLine
	XLONG	.endLine
END TYPE


DECLARE FUNCTION Entry ()
DECLARE FUNCTION onCommand (id, code, hWnd)
DECLARE FUNCTION swapLBItems (hLB, item1, item2)
DECLARE FUNCTION populateList (fileName$)
DECLARE FUNCTION swapFuncs (index1, index2)
'
'
' ######################
' #####  Entry ()  #####
' ######################
'
FUNCTION Entry ()
	SHARED fileLoaded$
	
	'initialise the WinX library, WinX will crash if you don't do this
	IF WinX() THEN QUIT(0)

	'make the main window
	#hMain = WinXNewWindow (0, "Function Mover", -1, -1, 400, 300, $$XWSS_APP, 0, _
	LoadIconA (GetModuleHandleA (0), &"scrabble"), hMenu)
  
	'create and size the controls
	'first off, create a new series to place the buttons in
	sButtons = WinXNewAutoSizerSeries ($$DIR_HORIZ)

	'the column
	WinXAutoSizer_SetInfo (WinXAddListBox (#hMain, $$FALSE, $$FALSE, $$ID_LIST), WinXAutoSizer_GetMainSeries(#hMain), 0, 27, 0, 0, 1, 1, $$SIZER_SIZERELREST)
	' I'm inserting 2 pixels of space here to make it look better.  Remove it to see what I mean
	WinXAutoSizer_SetInfo (sButtons, WinXAutoSizer_GetMainSeries(#hMain), 2, 25, 0, 0, 1, 1, $$SIZER_SERIES)
	
	'the embedded row
	WinXAutoSizer_SetInfo (WinXAddButton (#hMain, "Load", 0, $$ID_LOAD), sButtons, 0, 0.25, 0, 0, 1, 1, 0)
	WinXAutoSizer_SetInfo (WinXAddButton (#hMain, "Save", 0, $$ID_SAVE), sButtons, 0, 0.25, 0, 0, 1, 1, 0)
	WinXAutoSizer_SetInfo (WinXAddButton (#hMain, "Up", 0, $$ID_UP),			sButtons, 0, 0.25, 0, 0, 1, 1, 0)
	WinXAutoSizer_SetInfo (WinXAddButton (#hMain, "Down", 0, $$ID_DOWN), sButtons, 0, 0.25, 0, 0, 1, 1, 0)
	
	'seeing as there aren't any files loaded yet
	fileLoaded$ = ""
	'and we should disable the buttons that can't be used
	'note the use of win32 API functions.  These are so simple that WinX versions would serve
	'only to confuse.
	EnableWindow (GetDlgItem (#hMain, $$ID_SAVE), $$FALSE)
	EnableWindow (GetDlgItem (#hMain, $$ID_UP), $$FALSE)
	EnableWindow (GetDlgItem (#hMain, $$ID_DOWN), $$FALSE)
	
	
	'register the callbacks
	WinXRegOnCommand (#hMain, &onCommand())
	WinXEnableDialogInterface(#hMain, $$TRUE)
	
	'display the window
	WinXDisplay (#hMain)
	
	WinXDoEvents(0)

END FUNCTION
'
' #######################
' #####  onCommand  #####
' #######################
'
'
'
FUNCTION onCommand (id, code, hWnd)
	SHARED fileLoaded$
	SHARED progLines$[]
	SHARED numLines
	SHARED numFuncs
	
	SELECT CASE id
		CASE $$ID_UP
			WinXListBox_GetSelection (GetDlgItem (#hMain, $$ID_LIST), @index[])
			IF index[0] > 1 THEN
				swapFuncs (index[0]-1, index[0])
				
				'a little function I wrote to swap items in a list box
				'this function isn't a part of WinX, yet
				swapLBItems (GetDlgItem (#hMain, $$ID_LIST), index[0]-1, index[0])
				
				index[0] = index[0]-1
				WinXListBox_SetSelection (GetDlgItem (#hMain, $$ID_LIST), @index[])
			END IF
			
		CASE $$ID_DOWN
			WinXListBox_GetSelection (GetDlgItem (#hMain, $$ID_LIST), @index[])
			IF index[0] < numFuncs THEN
				swapFuncs (index[0], index[0]+1)
				
				swapLBItems (GetDlgItem (#hMain, $$ID_LIST), index[0], index[0]+1)
				
				index[0] = index[0]+1
				WinXListBox_SetSelection (GetDlgItem (#hMain, $$ID_LIST), @index[])
			END IF
			
		CASE $$ID_SAVE
			'WinXSaveFile$ uses the standard windows Save as dialog box to get a file name
			'see docs for details
			fileName$ = WinXDialog_SaveFile$ (#hMain, "Save as...", $$FILTERSTRING$, fileLoaded$, $$TRUE)
			fileNum = OPEN (fileName$, $$WRNEW)
			FOR i = 0 TO (numLines-1)
				PRINT[fileNum], progLines$[i]
			NEXT
			CLOSE(fileNum)
			
		CASE $$ID_LOAD
			'WinXOpenFile$ uses a standard windows Open dialog box to get a file name
			'see docs for details
			fileName$ = WinXDialog_OpenFile$ (#hMain, "Select an XBlite source file", $$FILTERSTRING$, "", $$FALSE)
			IF fileName$ != "" THEN
				IFF populateList (fileName$) THEN MessageBoxA (#hMain, &"Cannot open file", &"Error", $$MB_OK|$$MB_ICONSTOP)
			END IF
			
			'enable the buttons
			fileLoaded$ = fileName$
			EnableWindow (GetDlgItem (#hMain, $$ID_SAVE), $$TRUE)
			EnableWindow (GetDlgItem (#hMain, $$ID_UP), $$TRUE)
			EnableWindow (GetDlgItem (#hMain, $$ID_DOWN), $$TRUE)
	END SELECT
END FUNCTION
'
' #########################
' #####  swapLBItems  #####
' #########################
' Swaps 2 items in a list box
' hLB = the handle to the listbox to swap the items in
' item1 = the index of the first item
' item2 = the index of the second item
' returns $$TRUE on success or $$FALSE on fail
FUNCTION swapLBItems (hLB, item1, item2)
	item1$ = WinXListBox_GetItem$ (hLB, item1)
	item2$ = WinXListBox_GetItem$ (hLB, item2)
	
	IF item1$ = "" || item2$ ="" THEN RETURN $$FALSE
	
	WinXListBox_RemoveItem (hLB, item1)
	WinXListBox_AddItem (hLB, item1, item2$)
	WinXListBox_RemoveItem (hLB, item2)
	WinXListBox_AddItem (hLB, item2, item1$)
	
	RETURN $$TRUE
END FUNCTION
'
' ##########################
' #####  populateList  #####
' ##########################
' A function to populate the list of functions
' fileName = the file to load the functions from
' returns $$TRUE on success or $$FALSE on fail
FUNCTION populateList (fileName$)
	SHARED progLines$[]
	SHARED numLines
	SHARED FUNC funcList[]
	SHARED numFuncs
	
	fileNum = OPEN (fileName$, $$RD)
	
	IF fileNum = -2 THEN RETURN $$FALSE
	
	i = 0
	DIM progLines$[2047]
	DO WHILE !EOF (fileNum)
		IF i > UBOUND(progLines$[]) THEN REDIM progLines$[((UBOUND(progLines$[])+1)<<1)-1]
		progLines$[i] = INFILE$ (fileNum)
		INC i
	LOOP
	
	CLOSE(fileNum)
	
	numLines = i
	
	DIM funcList[63]

	lastEnd = -1
	numFuncs = -1
	
	FOR i = 0 TO numLines-1
		'get the first token
		SELECT CASE XstParse$ (progLines$[i], " ", 1)
			CASE "DECLARE"
				IF XstParse$ (progLines$[i], " ", 2) = "FUNCTION" THEN
					funcName$ = XstParse$ (progLines$[i], " ", 3)
					next$ = XstParse$ (progLines$[i], " ", 4)
					IF LEFT$(next$,1) != "(" THEN funcName$ = next$
					
					index = WinXListBox_AddItem (GetDlgItem (#hMain, $$ID_LIST), -1, funcName$)
					IF index > UBOUND(funcList[]) THEN REDIM funcList[((UBOUND(funcList[])+1)<<1)-1]
					funcList[index].decLine = i
					INC numFuncs
				END IF
			CASE "FUNCTION"
				'get the function name
				funcName$ = XstParse$ (progLines$[i], " ", 2)
				next$ = XstParse$ (progLines$[i], " ", 3)
				IF LEFT$(next$,1) != "(" THEN funcName$ = next$
				
				'find the function
				index = WinXListBox_GetIndex (GetDlgItem (#hMain, $$ID_LIST), funcName$)
				IF lastEnd > -1 THEN funcList[index].startLine = lastEnd ELSE funcList[index].startLine = i
			CASE "END"
				IF XstParse$ (progLines$[i], " ", 2) = "FUNCTION" THEN
					funcList[index].endLine = i
					lastEnd = i+1
				END IF
		END SELECT
	NEXT
	
	'now we need to make sure the functions are in the same order as their declarations
	DIM newProgLines$[numLines]
	destI = 0
	FOR i = 0 TO (funcList[0].startLine-1)
		newProgLines$[destI] = progLines$[i]
		INC destI
	NEXT
	
	FOR i = 0 TO numFuncs
		'output the function
		startLine = destI
		
		FOR j = funcList[i].startLine TO (funcList[i].endLine)
			newProgLines$[destI] = progLines$[j]
			INC destI
		NEXT
		
		'update it's record
		funcList[i].startLine = startLine
		funcList[i].endLine = startLine+(funcList[i].endLine-funcList[i].startLine)
	NEXT
	
	SWAP newProgLines$[], progLines$[]
	
'	FOR i = 0 TO maxFunc
'		PRINT "FOR: ";WinXListBox_GetItem$ (GetDlgItem (#hMain, $$ID_LIST), i)
'		PRINT "START LINE: ";funcList[i].startLine
'		PRINT "END LINE: ";funcList[i].endLine;"\n"
'	NEXT
	
	RETURN $$TRUE
END FUNCTION
'
' #######################
' #####  swapFuncs  #####
' #######################
' Swaps two functions
' index1 and index2 = the indexs to the functions
' returns $$TRUE on success or $$FALSE on fail
FUNCTION swapFuncs (index1, index2)
	SHARED progLines$[]
	SHARED numLines
	SHARED FUNC funcList[]
	SHARED numFuncs
	
	DIM newProgLines$[numLines]
	
	'first, swap the declarations
	SWAP progLines$[funcList[index1].decLine], progLines$[funcList[index2].decLine]
	
	'now swap the functions
	destI = 0
	FOR i = 0 TO (funcList[index1].startLine-1)
		newProgLines$[destI] = progLines$[i]
		INC destI
	NEXT

	func2StartLine = destI
	FOR i = funcList[index2].startLine TO funcList[index2].endLine
		newProgLines$[destI] = progLines$[i]
		INC destI
	NEXT
	
	FOR i = funcList[index1].endLine+1 TO (funcList[index2].startLine-1)
		newProgLines$[destI] = progLines$[i]
		INC destI
	NEXT
	
	func1StartLine = destI
	FOR i = funcList[index1].startLine TO funcList[index1].endLine
		newProgLines$[destI] = progLines$[i]
		INC destI
	NEXT
	
	FOR i = (funcList[index2].endLine+1) TO numLines
		newProgLines$[destI] = progLines$[i]
		INC destI
	NEXT
	
	SWAP newProgLines$[], progLines$[]
	
	'now swap the references
	func1EndLine = funcList[index1].endLine-funcList[index1].startLine
	func2EndLine = funcList[index2].endLine-funcList[index2].startLine
	
	funcList[index1].startLine = func2StartLine
	funcList[index1].endLine = func2StartLine+func2EndLine
	
	funcList[index2].startLine = func1StartLine
	funcList[index3].endLine = func1StartLine+func1EndLine
	
	RETURN $$TRUE
END FUNCTION

END PROGRAM
