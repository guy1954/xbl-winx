'
'
' ####################
' #####  PROLOG  #####
' ####################
'
PROGRAM "WinX"
VERSION "0.6.0.2"
'CONSOLE
'
' WinX - Windows GUI library for XBLite.
' Copyright (c) LGPL 2007-2008 Callum Lowcay,
'                    2009-2019 Guy Lonne.
' The WinX GUI library is distributed under the
' terms and conditions of the GNU LGPL, see the file COPYING_LIB
' which should be included in the WinX distribution.
'
' ***** Description *****
'
' WinX.dll is easy to use, with a comprehensive set of functions and is
' perfect to experiment GUI programming with quick prototypes.
'
'
' ***** Notes *****
'
' 1. All functions are prefixed by "WinX"
' 2. Use SHIFT+F9 to compile
' 3. Use F10 to build WinX.dll
' 4. Use compiler switch -m4
'
' WinXs functions return bOK ($$TRUE on success), as opposed to
' XBasic/XBLite libray's functions, which always return bErr ($$TRUE on fail).
'
' ***** Versions *****
'
' Contributors:
'     Callum Lowcay (original version)
'     Guy "GL" Lonne (evolutions)
'
' 0.6.0.1-Callum Lowcay-Original version.
'
' 0.6.0.2-GL-10sep08-some corrections.
' ".firstItem" := ".iHead"
' ".lastItem" := ".iTail"
' ".forColour" := ".forColor"
' ".backColour" := ".backColor"
' "colour" := "color"
' "customColours[" := "#CustomColors["
' "$$DOCK_FOWARD" := "$$DOCK_FORWARD"
' "FUNCTION VOID" := "FUNCTION"
' "seperator" := "separator"
' "Seperator" := "Separator"
'
'
' ##############################
' #####  Import Libraries  #####
' ##############################
'
'
' XBLite headers
'
' DLL build+++
	IMPORT "xst"		' XBLite Standard Library
	IMPORT "xsx"		' XBLite Standard eXtended Library
'	IMPORT "xio"		' console library
	IMPORT "xma"		' XBLite Math Library (Sin/Asin/Sinh/Asinh/Log/Exp/Sqrt...)
	IMPORT "adt"		' Callum's Abstract Data Types library
' DLL build~~~

' Uncomment for a static build.
' Static build---
'	IMPORT "xst_s.lib"
'	IMPORT "xsx_s.lib"
'	IMPORT "xma_s.lib"
''	IMPORT "xio_s.lib"
'	IMPORT "adt_s.lib"
' Static build~~~
'
' WinAPI DLL headers
'
	IMPORT "kernel32"			' Operating System
'
' ---Note: import gdi32 BEFORE shell32 and user32
	IMPORT "gdi32"				' Graphic Device Interface
	IMPORT "shell32"			' interface to Operating System
	IMPORT "user32"				' Windows management
'
' ---Note: import comctl32 BEFORE comdlg32
	IMPORT "comctl32"			' Common controls; ==> initialize w/ InitCommonControlsEx ()
	IMPORT "comdlg32"			' Standard dialog boxes (opening and saving files ...)
	IMPORT "advapi32"			' advanced API: security, services, registry ...
	IMPORT "msimg32"			' image manipulation
'
'
' #######################
' #####  M4 macros  #####
' #######################
' Notes:
' - use the compiler switch -m4
m4_include(`accessors.m4')
'
'
' ****************************************
' *****  COMPOSITE TYPE DEFINITIONS  *****
' ****************************************
'
'the data type to manage bindings
TYPE BINDING
	XLONG			.hWnd						'handle to the window this binds to, when 0, this record is not in use
	XLONG			.backCol				'window background color
	XLONG			.hStatus				'handle to the status bar, if there is one
	XLONG			.statusParts		'the upper index of partitions in the status bar
	XLONG			.msgHandlers		'index into an array of arrays of message handlers
	XLONG			.minW
	XLONG			.minH
	XLONG			.maxW
	XLONG			.maxH
	XLONG			.autoDrawInfo		'information for the auto drawer (id >= 1)
	XLONG			.autoSizerInfo	'information for the auto sizer (series >= 0)
	XLONG			.hBar						'either a toolbar or a rebar
	XLONG			.hToolTips			'each window gets a tooltip control
	DOUBLE		.hScrollPageM		'the high level scrolling data
	XLONG			.hScrollPageC
	XLONG			.hScrollUnit
	DOUBLE		.vScrollPageM
	XLONG			.vScrollPageC
	XLONG			.vScrollUnit
	XLONG			.useDialogInterface		'true to enable dialog style keyboard navigation amoung controls
	XLONG			.hWndNextClipViewer		'if the onClipChange callback is used, we become a clipboard viewer
	XLONG			.hCursor							'custom cursor for this window
	XLONG			.isMouseInWindow
	XLONG			.hUpdateRegion
'new in 0.6.0.2
	XLONG			.hAccelTable		' handle to the window's accelerator table
'Callback Handlers
	FUNCADDR	.paint(XLONG, XLONG)	'hWnd, hdc : paint the window
	FUNCADDR	.dimControls(XLONG, XLONG, XLONG)	'hWnd, w, h : dimension the controls
	FUNCADDR	.onCommand(XLONG, XLONG, XLONG)		'idCtr, notifyCode, hCtr
	FUNCADDR	.onMouseMove(XLONG, XLONG, XLONG)	'hWnd, x, y
	FUNCADDR	.onMouseDown(XLONG, XLONG, XLONG, XLONG)		'hWnd, MBT_const, x, y
	FUNCADDR	.onMouseUp(XLONG, XLONG, XLONG, XLONG)		'hWnd, MBT_const, x, y
	FUNCADDR	.onMouseWheel(XLONG, XLONG, XLONG, XLONG)	'hWnd, delta, x, y
	FUNCADDR	.onKeyDown(XLONG, XLONG)			'hWnd, VK
	FUNCADDR	.onKeyUp(XLONG, XLONG)				'hWnd, VK
	FUNCADDR	.onChar(XLONG, XLONG)				'hWnd, char
	FUNCADDR	.onScroll(XLONG, XLONG, XLONG)	'pos, hWnd, direction
	FUNCADDR	.onTrackerPos(XLONG, XLONG)		'idCtr, pos
	FUNCADDR	.onDrag(XLONG, XLONG, XLONG, XLONG, XLONG)		'idCtr, drag_const, drag_item, drag_x, drag_y
	FUNCADDR	.onLabelEdit(XLONG, XLONG, XLONG, STRING)		'idCtr, edit_const, edit_item, newLabel$
	FUNCADDR	.onClose(XLONG)	' hWnd
	FUNCADDR	.onFocusChange(XLONG, XLONG)	' hWnd, hasFocus
	FUNCADDR	.onClipChange()	' Sent when clipboard changes
	FUNCADDR	.onEnterLeave(XLONG, XLONG)	' hWnd, mouseInWindow
	FUNCADDR	.onItem(XLONG, XLONG, XLONG)		' idCtr, event, VK (virtualKey for $$NM_KEYDOWN)
	FUNCADDR	.onColumnClick(XLONG, XLONG)		' idCtr, iColumn
	FUNCADDR	.onCalendarSelect(XLONG, SYSTEMTIME)	' idCtr, time
	FUNCADDR	.onDropFiles(XLONG, XLONG, XLONG, STRING[])		' hWnd, x, y, @fileList$[]
END TYPE
'message handler data type
TYPE MSGHANDLER
	XLONG			.msg	'when 0, this record is not in use
	FUNCADDR	.handler(XLONG, XLONG, XLONG, XLONG)		' hWnd, wMsg, wParam, lParam
END TYPE
'Headers for grouped lists
TYPE DRAWLISTHEAD
	XLONG			.inUse
	XLONG			.iHead
	XLONG			.iTail
END TYPE
TYPE SIZELISTHEAD
	XLONG			.inUse
	XLONG			.iHead
	XLONG			.iTail
	XLONG			.direction
END TYPE
'info for the auto sizer
TYPE AUTOSIZERINFO
	XLONG			.prevItem
	XLONG			.nextItem
	XLONG			.hWnd
	XLONG			.hSplitter
	DOUBLE		.space
	DOUBLE		.size
	DOUBLE		.x
	DOUBLE		.y
	DOUBLE		.w
	DOUBLE		.h
	XLONG			.flags
END TYPE
'info for WinX splitter
TYPE SPLITTERINFO
	XLONG			.group
	XLONG			.id
	XLONG			.direction
	XLONG			.maxSize

	XLONG			.min
	XLONG			.max
	XLONG			.dock
	XLONG			.docked	' 0 if not docked, old position when docked
END TYPE
$$DOCK_DISABLED	= 0
$$DOCK_FORWARD	= 1
$$DOCK_BACKWARD	= 2
'data structures for auto drawer
TYPE DRAWRECT
	XLONG		.x1
	XLONG		.y1
	XLONG		.x2
	XLONG		.y2
END TYPE
TYPE DRAWRECTCONTROL
	XLONG		.x1
	XLONG		.y1
	XLONG		.x2
	XLONG		.y2
	XLONG		.xC1
	XLONG		.yC1
	XLONG		.xC2
	XLONG		.yC2
END TYPE
TYPE SIMPLEFILL
	XLONG		.x
	XLONG		.y
	XLONG		.col
END TYPE
TYPE DRAWTEXT
	XLONG		.x
	XLONG		.y
	XLONG		.iString
	XLONG		.forColor
	XLONG		.backColor
END TYPE
TYPE DRAWIMAGE
	XLONG		.x
	XLONG		.y
	XLONG		.w
	XLONG		.h
	XLONG		.xSrc
	XLONG		.ySrc
	XLONG		.hImage
	XLONG		.blend
END TYPE
TYPE AUTODRAWRECORD
	XLONG			.toDelete
	XLONG			.hUpdateRegion
	XLONG			.hPen
	XLONG			.hBrush
	XLONG			.hFont
	FUNCADDR	.draw(XLONG, AUTODRAWRECORD, XLONG, XLONG)
	UNION
		DRAWRECT				.rect
		DRAWRECTCONTROL	.rectControl
		SIMPLEFILL			.simpleFill
		DRAWTEXT				.text
		DRAWIMAGE				.image
	END UNION
END TYPE
TYPE PRINTINFO
	XLONG		.hDevMode
	XLONG		.hDevNames
	XLONG		.rangeMin
	XLONG		.rangeMax
	XLONG		.marginLeft
	XLONG		.marginRight
	XLONG		.marginTop
	XLONG		.marginBottom
	XLONG		.printSetupFlags
	XLONG		.continuePrinting
	XLONG		.hCancelDlg
END TYPE
$$DLGCANCEL_ST_PAGE = 100

'Data structure for customising toolbars
TYPE TBBUTTONDATA
	XLONG			.enabled
	XLONG			.optional
	TBBUTTON	.tbb
END TYPE
'
'
' ***********************************
' *****  BLOCK EXPORT (part 1)  *****
' ***********************************
'
EXPORT
'
' WinX - A Win32 abstraction for XBLite.
' Copyright (c) Callum Lowcay 2007-2008 - Licensed under the GNU LGPL
' Evolutions: Guy Lonne 2009-2019.
'
' *****************************
' *****   CONSTANTS and   *****
' *****  COMPOSITE TYPES  *****
' *****************************
'
' Red/Green/Blue/Alpha
TYPE RGBA
	UBYTE	.blue
	UBYTE	.green
	UBYTE	.red
	UBYTE	.alpha
END TYPE

'Simplified window styles
$$XWSS_APP					= 0x00000000
$$XWSS_APPNORESIZE	=	0x00000001
$$XWSS_POPUP				= 0x00000002
$$XWSS_POPUPNOTITLE	= 0x00000003
$$XWSS_NOBORDER			= 0x00000004

'mouse buttons
$$MBT_LEFT		= 1
$$MBT_MIDDLE	= 2
$$MBT_RIGHT	= 3

'font styles
$$FONT_BOLD					= 0x00000001
$$FONT_ITALIC				= 0x00000002
$$FONT_UNDERLINE		= 0x00000004
$$FONT_STRIKEOUT		= 0x00000008

'file types
$$FILETYPE_WINBMP		= 1

'auto sizer flags (sizerBlock.flags)
$$SIZER_FLAGS_NONE  = 0x0
$$SIZER_SIZERELREST	= 0x00000001
$$SIZER_XRELRIGHT		= 0x00000002
$$SIZER_YRELBOTTOM	= 0x00000004
$$SIZER_SERIES			= 0x00000008
$$SIZER_WCOMPLEMENT	= 0x00000010
$$SIZER_HCOMPLEMENT	= 0x00000020
$$SIZER_SPLITTER		= 0x00000040

' 0.6.0.2-$$CONTROL			= 0
$$DIR_VERT		= 1
$$DIR_HORIZ		= 2
$$DIR_REVERSE	= 0x80000000

$$UNIT_LINE		= 0
$$UNIT_PAGE		= 1
$$UNIT_END		= 2

'Drag and Drop Operations
'drag states
$$DRAG_START		= 0
$$DRAG_DRAGGING	= 1
$$DRAG_DONE			= 2

'edit states
$$EDIT_START		= 0
$$EDIT_DONE			= 1

$$CHANNEL_RED   = 2
$$CHANNEL_GREEN	= 1
$$CHANNEL_BLUE	= 0
$$CHANNEL_ALPHA	= 3

$$ACL_REG_STANDARD = "D:(A;OICI;GRKRKW;;;WD)(A;OICI;GAKA;;;BA)"

$$TextLengthMax = 512		' text's length upper limit for WinX's functions
'
'
' *************************
' *****   FUNCTIONS   *****
' *************************
'
DECLARE FUNCTION WinX () ' To be called first

' Add functions
DECLARE FUNCTION WinXAddAccelerator (ACCEL @accel[], cmd, key, control, alt, shift) ' add accelerator key
DECLARE FUNCTION WinXAddAcceleratorTable (ACCEL @accel[]) ' create an accelerator table
DECLARE FUNCTION WinXAddAnimation (hParent, file$, idCtr) ' add animation file
DECLARE FUNCTION WinXAddButton (hParent, text$, hImage, idCtr) ' add push button
DECLARE FUNCTION WinXAddCalendar (hParent, @monthsX, @monthsY, idCtr) ' add calendar control
DECLARE FUNCTION WinXAddCheckBox (hParent, text$, isFirst, pushlike, idCtr) ' add checkbox
DECLARE FUNCTION WinXAddCheckButton (hParent, text$, isFirst, pushlike, idCtr) ' add check button
DECLARE FUNCTION WinXAddComboBox (hParent, listHeight, canEdit, images, idCtr) ' add combo box
DECLARE FUNCTION WinXAddControl (hParent, class$, text$, style, exStyle, idCtr) ' add custom control
DECLARE FUNCTION WinXAddEdit (hParent, text$, style, idCtr) ' add edit control
DECLARE FUNCTION WinXAddGroupBox (hParent, text$, idCtr) ' add group box
DECLARE FUNCTION WinXAddListBox (hParent, sort, multiSelect, idCtr) ' add listbox
DECLARE FUNCTION WinXAddListView (hParent, hilLargeIcons, hilSmallIcons, editable, view, idCtr) ' add listview control
DECLARE FUNCTION WinXAddProgressBar (hParent, smooth, idCtr) ' add progress bar
DECLARE FUNCTION WinXAddRadioButton (hParent, text$, isFirst, pushlike, idCtr) ' add radio button
DECLARE FUNCTION WinXAddStatic (hParent, text$, hImage, style, idCtr) ' add text box
DECLARE FUNCTION WinXAddStatusBar (hWnd, initialStatus$, idCtr) ' add status bar
DECLARE FUNCTION WinXAddTabs (hParent, multiline, idCtr) ' add tabstip control
DECLARE FUNCTION WinXAddTimePicker (hParent, format, SYSTEMTIME initialTime, timeValid, idCtr) ' add time picker control
DECLARE FUNCTION WinXAddTooltip (hCtr, theTip$) ' add tooltips to control
DECLARE FUNCTION WinXAddTrackBar (hParent, enableSelection, posToolTip, idCtr) ' add track bar
DECLARE FUNCTION WinXAddTreeView (hParent, hImages, editable, draggable, idCtr) ' add treeview

' Animation
DECLARE FUNCTION WinXAni_Play (hAni) ' start playing the animation
DECLARE FUNCTION WinXAni_Stop (hAni) ' stop playing the animation

' Accelerators
DECLARE FUNCTION WinXAttachAccelerators (hWnd, hAccel) ' attach accelerator table to window

' Auto Sizer
DECLARE FUNCTION WinXAutoSizer_GetMainSeries (hWnd) ' get window's main series
DECLARE FUNCTION WinXAutoSizer_SetInfo (hWnd, series, space#, size#, xx#, yy#, ww#, hh#, flags) ' series setup
DECLARE FUNCTION WinXAutoSizer_SetSimpleInfo (hWnd, series, space#, size#, flags) ' simplified series setup

' Check box or Radio button
DECLARE FUNCTION WinXButton_GetCheck (hButton) ' get check state
DECLARE FUNCTION WinXButton_SetCheck (hButton, checked) ' set check state

' Calendar
DECLARE FUNCTION WinXCalendar_GetSelection (hCal, SYSTEMTIME @time)
DECLARE FUNCTION WinXCalendar_SetSelection (hCal, SYSTEMTIME time)

' WinX Cleanup
DECLARE FUNCTION WinXCleanUp () ' optional cleanup

' Clipboard
DECLARE FUNCTION WinXClip_GetImage ()
DECLARE FUNCTION WinXClip_GetString$ ()
DECLARE FUNCTION WinXClip_IsImage ()
DECLARE FUNCTION WinXClip_IsString ()
DECLARE FUNCTION WinXClip_PutImage (hImage)
DECLARE FUNCTION WinXClip_PutString (Stri$)

' Combo box
DECLARE FUNCTION WinXComboBox_AddItem (hCombo, index, indent, item$, iImage, iSelImage)
DECLARE FUNCTION WinXComboBox_Clear (hCombo) ' clear out contents of combo box
DECLARE FUNCTION WinXComboBox_DeleteItem (hCombo, index)
DECLARE FUNCTION WinXComboBox_GetEditText$ (hCombo)
DECLARE FUNCTION WinXComboBox_GetItem$ (hCombo, index)
DECLARE FUNCTION WinXComboBox_GetSelection (hCombo)
DECLARE FUNCTION WinXComboBox_RemoveItem (hCombo, index, @number_left)
DECLARE FUNCTION WinXComboBox_SetEditText (hCombo, text$)
DECLARE FUNCTION WinXComboBox_SetSelection (hCombo, index)

' Standard Windows dialogs
DECLARE FUNCTION WinXDialog_Error (msg$, title$, severity)
DECLARE FUNCTION WinXDialog_Message (hOwner, msg$, title$, iIcon, hMod) ' display message dialog box
DECLARE FUNCTION WinXDialog_OpenFile$ (hOwner, title$, extensions$, initialName$, multiSelect) ' File Open Dialog
DECLARE FUNCTION WinXDialog_Question (hOwner, msg$, title$, cancel, defaultButton)
DECLARE FUNCTION WinXDialog_SaveFile$ (hOwner, title$, extensions$, initialName$, overwritePrompt) ' File Save Dialog

' Drawing functions
DECLARE FUNCTION WinXDrawArc (hWnd, hPen, x1, y1, x2, y2, DOUBLE theta1, DOUBLE theta2)
DECLARE FUNCTION WinXDrawBezier (hWnd, hPen, x1, y1, x2, y2, xC1, yC1, xC2, yC2)
DECLARE FUNCTION WinXDrawEllipse (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawFilledArea (hWnd, hBrush, colBound, x, y)
DECLARE FUNCTION WinXDrawFilledEllipse (hWnd, hPen, hBrush, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawFilledRect (hWnd, hPen, hBrush, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawImage (hWnd, hImage, x, y, w, h, xSrc, ySrc, blend)
DECLARE FUNCTION WinXDrawLine (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawRect (hWnd, hPen, x1, y1, x2, y2)

DECLARE FUNCTION WinXDraw_Clear (hWnd)
DECLARE FUNCTION WinXDraw_Undo (hWnd, idDraw) ' undo a drawing operation

' Color
DECLARE FUNCTION WinXDraw_GetColor (hOwner, initialRGB) ' Color Picker
DECLARE FUNCTION WinXDraw_GetColour (hOwner, initialRGB) ' Colour Picker

' Font
DECLARE FUNCTION WinXDraw_GetFontDialog (hOwner, LOGFONT @logFont, @fontRGB) ' Font Picker
DECLARE FUNCTION WinXDraw_GetFontHeight (hFont, @ascent, @descenct)
DECLARE FUNCTION LOGFONT WinXDraw_MakeLogFont (font$, height, style)

' Image
DECLARE FUNCTION WinXDraw_CopyImage (hImage)
DECLARE FUNCTION WinXDraw_CreateImage (w, h)
DECLARE FUNCTION WinXDraw_DeleteImage (hImage)
DECLARE FUNCTION WinXDraw_LoadImage (fileName$, fileType)
DECLARE FUNCTION WinXDraw_GetImageChannel (hImage, channel, UBYTE @data[])
DECLARE FUNCTION WinXDraw_GetImageInfo (hImage, @w, @h, @pBits)
DECLARE FUNCTION RGBA WinXDraw_GetImagePixel (hImage, x, y)
DECLARE FUNCTION DOUBLE WinXDraw_PixelsPerPoint ()
DECLARE FUNCTION WinXDraw_PremultiplyImage (hImage)
DECLARE FUNCTION WinXDraw_ResizeImage (hImage, w, h)
DECLARE FUNCTION WinXDraw_SaveImage (hImage, fileName$, fileType)
DECLARE FUNCTION WinXDraw_SetConstantAlpha (hImage, DOUBLE alpha)
DECLARE FUNCTION WinXDraw_SetImageChannel (hImage, channel, UBYTE @data[])
DECLARE FUNCTION WinXDraw_SetImagePixel (hImage, x, y, codeRGB)
DECLARE FUNCTION WinXDraw_Snapshot (hWnd, x, y, hImage)

' Text
DECLARE FUNCTION WinXDrawText (hWnd, hFont, text$, x, y, backCol, forCol)
DECLARE FUNCTION WinXDraw_GetTextWidth (hFont, text$, maxWidth)

' Font
DECLARE FUNCTION WinXKillFont (@hFont) ' free logical font
DECLARE FUNCTION WinXSetFont (hCtr, hFont) ' apply font to control

' Keyboard
DECLARE FUNCTION WinXIsKeyDown (key)

' Mouse
DECLARE FUNCTION WinXGetMousePos (hWnd, @x, @y)
DECLARE FUNCTION WinXIsMousePressed (button)

' List box
DECLARE FUNCTION WinXListBox_AddItem (hListBox, index, item$)
DECLARE FUNCTION WinXListBox_EnableDragging (hListBox)
DECLARE FUNCTION WinXListBox_GetIndex (hListBox, searchFor$)
DECLARE FUNCTION WinXListBox_GetItem$ (hListBox, index) ' get the text of listbox item
DECLARE FUNCTION WinXListBox_GetSelectionArray (hListBox, @indexList[]) ' get all selected items in the listbox
DECLARE FUNCTION WinXListBox_RemoveItem (hListBox, index)
DECLARE FUNCTION WinXListBox_SetCaret (hListBox, index)
DECLARE FUNCTION WinXListBox_SetSelectionArray (hListBox, indexList[]) ' select listed listbox items

' List view
DECLARE FUNCTION WinXListView_AddColumn (hLV, iColumn, wColumn, label$, iSubItem) ' add a column to listview for use in report view
DECLARE FUNCTION WinXListView_AddItem (hLV, iItem, item$, iIcon) ' add a new item to a listview
DECLARE FUNCTION WinXListView_Clear (hLV) ' clear out contents of listview
DECLARE FUNCTION WinXListView_DeleteColumn (hLV, iColumn)
DECLARE FUNCTION WinXListView_DeleteItem (hLV, iItem)
DECLARE FUNCTION WinXListView_GetItemFromPoint (hLV, x, y)
DECLARE FUNCTION WinXListView_GetItemText (hLV, iItem, uppSubItem, @aSubItem$[])
DECLARE FUNCTION WinXListView_GetSelectionArray (hLV, @indexList[]) ' get selected item(s) in a listview
DECLARE FUNCTION WinXListView_SetItemText (hLV, iItem, iSubItem, newText$) ' set new item/sub-item's text
DECLARE FUNCTION WinXListView_SetSelection (hLV, iItem) ' select this item
DECLARE FUNCTION WinXListView_SetSelectionArray (hLV, indexList[]) ' multi-select these items
DECLARE FUNCTION WinXListView_SetView (hLV, view)
DECLARE FUNCTION WinXListView_Sort (hLV, iCol, decreasing)

' Menu
DECLARE FUNCTION WinXMenu_Attach (subMenu, newParent, idMenu)

' New functions
DECLARE FUNCTION SECURITY_ATTRIBUTES WinXNewACL (ssd$, inherit)
DECLARE FUNCTION WinXNewAutoSizerSeries (direction)
DECLARE FUNCTION WinXNewChildWindow (hParent, title$, style, exStyle, idCtr)
DECLARE FUNCTION WinXNewFont (fontName$, pointSize, weight, bItalic, bUnderL, bStrike)
DECLARE FUNCTION WinXNewMenu (menuList$, firstID, isPopup)
DECLARE FUNCTION WinXNewToolbar (wButton, hButton, nButtons, hBmpButtons, hBmpDis, hBmpHot, transparentRGB, toolTips, customisable)
DECLARE FUNCTION WinXNewToolbarUsingIls (hilNor, hilDis, hilHot, toolTips, customisable)
DECLARE FUNCTION WinXNewWindow (hOwner, title$, x, y, w, h, simpleStyle, exStyle, icon, menu)

' Print
DECLARE FUNCTION WinXPrint_DevUnitsPerInch (hPrinter, @w, @h)
DECLARE FUNCTION WinXPrint_Done (hPrinter) ' reset the printer context hPrinter
DECLARE FUNCTION DOUBLE WinXPrint_LogUnitsPerPoint (hPrinter, cyLog, cyPhys)
DECLARE FUNCTION WinXPrint_Page (hPrinter, hWnd, x, y, cxLog, cyLog, cxPhys, cyPhys, pageNum, pageCount)
DECLARE FUNCTION WinXPrint_PageSetup (hOwner)
DECLARE FUNCTION WinXPrint_Start (minPage, maxPage, @rangeMin, @rangeMax, @cxPhys, @cyPhys, fileName$, showDialog, hOwner)

' Progess bar
DECLARE FUNCTION WinXProgress_SetMarquee (hProg, enable)
DECLARE FUNCTION WinXProgress_SetPos (hProg, DOUBLE pos)

' Callback register
DECLARE FUNCTION WinXRegControlSizer (hWnd, FUNCADDR FnOnSize)
DECLARE FUNCTION WinXRegMessageHandler (hWnd, wMsg, FUNCADDR FnMsgHandler)
DECLARE FUNCTION WinXRegOnCalendarSelect (hWnd, FUNCADDR FnOnCalendarSelect) ' handles message $$MCN_SELCHANGE notifyCode
DECLARE FUNCTION WinXRegOnChar (hWnd, FUNCADDR FnOnChar)
DECLARE FUNCTION WinXRegOnClipChange (hWnd, FUNCADDR FnOnClipChange)
DECLARE FUNCTION WinXRegOnClose (hWnd, FUNCADDR FnOnClose) ' handles message WM_CLOSE
DECLARE FUNCTION WinXRegOnColumnClick (hWnd, FUNCADDR FnOnColumnClick)
DECLARE FUNCTION WinXRegOnCommand (hWnd, FUNCADDR FnOnCommand) ' handles message WM_COMMAND
DECLARE FUNCTION WinXRegOnDrag (hWnd, FUNCADDR FnOnDrag)
DECLARE FUNCTION WinXRegOnDropFiles (hWnd, FUNCADDR FnOnDrag)
DECLARE FUNCTION WinXRegOnEnterLeave (hWnd, FUNCADDR FnOnEnterLeave)
DECLARE FUNCTION WinXRegOnFocusChange (hWnd, FUNCADDR FnOnFocusChange)
DECLARE FUNCTION WinXRegOnItem (hWnd, FUNCADDR FnOnItem)
DECLARE FUNCTION WinXRegOnKeyDown (hWnd, FUNCADDR FnOnKeyDown) ' handles message WM_KEYDOWN
DECLARE FUNCTION WinXRegOnKeyUp (hWnd, FUNCADDR FnOnKeyUp) ' handles message WM_KEYUP
DECLARE FUNCTION WinXRegOnLabelEdit (hWnd, FUNCADDR FnOnLabelEdit)
DECLARE FUNCTION WinXRegOnMouseDown (hWnd, FUNCADDR FnOnMouseDown)
DECLARE FUNCTION WinXRegOnMouseMove (hWnd, FUNCADDR FnOnMouseMove)
DECLARE FUNCTION WinXRegOnMouseUp (hWnd, FUNCADDR FnOnMouseUp)
DECLARE FUNCTION WinXRegOnMouseWheel (hWnd, FUNCADDR FnOnMouseWheel)
DECLARE FUNCTION WinXRegOnPaint (hWnd, FUNCADDR FnOnPaint) ' handles message WM_PAINT
DECLARE FUNCTION WinXRegOnScroll (hWnd, FUNCADDR FnOnScroll)
DECLARE FUNCTION WinXRegOnTrackerPos (hWnd, FUNCADDR FnOnTrackerPos)

' Windows registry
DECLARE FUNCTION WinXRegistry_ReadBin (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
DECLARE FUNCTION WinXRegistry_ReadInt (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result)
DECLARE FUNCTION WinXRegistry_ReadString (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
DECLARE FUNCTION WinXRegistry_WriteBin (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, szBuf$)
DECLARE FUNCTION WinXRegistry_WriteInt (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, int)
DECLARE FUNCTION WinXRegistry_WriteString (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, szBuf$)

' Scroll bar
DECLARE FUNCTION WinXScroll_GetPos (hWnd, direction, @pos)
DECLARE FUNCTION WinXScroll_Scroll (hWnd, direction, unitType, scrollingDirection)
DECLARE FUNCTION WinXScroll_SetPage (hWnd, direction, DOUBLE mul, constant, scrollUnit)
DECLARE FUNCTION WinXScroll_SetPos (hWnd, direction, pos)
DECLARE FUNCTION WinXScroll_SetRange (hWnd, direction, min, max)
DECLARE FUNCTION WinXScroll_Show (hWnd, horiz, vert)
DECLARE FUNCTION WinXScroll_Update (hWnd, deltaX, deltaY)

' Window
DECLARE FUNCTION WinXDisplay (hWnd)
DECLARE FUNCTION WinXDoEvents (hAccel) ' the message loop
DECLARE FUNCTION WinXEnableDialogInterface (hWnd, enable) ' enable/disable a dialog-type interface
DECLARE FUNCTION WinXGetPlacement (hWnd, @minMax, RECT @restored)
DECLARE FUNCTION WinXGetText$ (hWnd)
DECLARE FUNCTION WinXGetUseableRect (hWnd, RECT @rect)
DECLARE FUNCTION WinXGroupBox_GetAutosizerSeries (hGB)
DECLARE FUNCTION WinXHide (hWnd)
DECLARE FUNCTION WinXSetCursor (hWnd, hCursor)
DECLARE FUNCTION WinXSetMinSize (hWnd, w, h)
DECLARE FUNCTION WinXSetPlacement (hWnd, minMax, RECT restored)
DECLARE FUNCTION WinXSetStyle (hWnd, add, addEx, sub, subEx) ' set style and extended style
DECLARE FUNCTION WinXSetText (hWnd, text$)
DECLARE FUNCTION WinXSetWindowColor (hWnd, backRGB)
DECLARE FUNCTION WinXSetWindowColour (hWnd, backRGB)
DECLARE FUNCTION WinXSetWindowToolbar (hWnd, hToolbar)
DECLARE FUNCTION WinXShow (hWnd)
DECLARE FUNCTION WinXUpdate (hWnd)

' Splitter
DECLARE FUNCTION WinXSplitter_GetPos (series, hCtr, @position, @docked)
DECLARE FUNCTION WinXSplitter_SetPos (series, hCtr, position, docked)
DECLARE FUNCTION WinXSplitter_SetProperties (series, hCtr, min, max, dock)

' Status bar
DECLARE FUNCTION WinXStatus_GetText$ (hWnd, part)
DECLARE FUNCTION WinXStatus_SetText (hWnd, part, text$)

' Tabs
DECLARE FUNCTION WinXTabs_AddTab (hTabs, label$, index)
DECLARE FUNCTION WinXTabs_DeleteTab (hTabs, iTab)
DECLARE FUNCTION WinXTabs_GetAutosizerSeries (hTabs, iTab)
DECLARE FUNCTION WinXTabs_GetCurrentTab (hTabs)
DECLARE FUNCTION WinXTabs_SetCurrentTab (hTabs, iTab)

' Time picker
DECLARE FUNCTION WinXTimePicker_GetTime (hDTP, SYSTEMTIME @time, @timeValid) ' get time from a Date/Time Picker control
DECLARE FUNCTION WinXTimePicker_SetTime (hDTP, SYSTEMTIME time, timeValid) ' set the time for a Date/Time Picker control

' Toolbar
DECLARE FUNCTION WinXToolbar_AddButton (hToolbar, commandId, iImage, theTip$, optional, moveable)
DECLARE FUNCTION WinXToolbar_AddControl (hToolbar, hCtr, w)
DECLARE FUNCTION WinXToolbar_AddSeparator (hToolbar)
DECLARE FUNCTION WinXToolbar_AddToggleButton (hToolbar, commandId, iImage, theTip$, mutex, optional, moveable)
DECLARE FUNCTION WinXToolbar_EnableButton (hToolbar, iButton, enable)
DECLARE FUNCTION WinXToolbar_ToggleButton (hToolbar, iButton, on)

' Track bar
DECLARE FUNCTION WinXTracker_GetPos (hTracker)
DECLARE FUNCTION WinXTracker_SetLabels (hTracker, leftLabel$, rightLabel$)
DECLARE FUNCTION WinXTracker_SetPos (hTracker, newPos)
DECLARE FUNCTION WinXTracker_SetRange (hTracker, USHORT min, USHORT max, ticks)
DECLARE FUNCTION WinXTracker_SetSelRange (hTracker, USHORT start, USHORT end)

' Tree view
DECLARE FUNCTION WinXTreeView_AddItem (hTreeView, hParent, hInsertAfter, iImage, iImageSelect, item$)
DECLARE FUNCTION WinXTreeView_CopyItem (hTreeView, hNodeParent, hNodeAfter, hNode)
DECLARE FUNCTION WinXTreeView_DeleteItem (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_GetChildItem (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_GetItemFromPoint (hTreeView, x, y)
DECLARE FUNCTION WinXTreeView_GetItemLabel$ (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_GetNextItem (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_GetParentItem (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_GetPreviousItem (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_GetRootItem (hTreeView) ' get treeview root handle
DECLARE FUNCTION WinXTreeView_GetSelection (hTreeView)
DECLARE FUNCTION WinXTreeView_SetItemLabel (hTreeView, hNode, label$)
DECLARE FUNCTION WinXTreeView_SetSelection (hTreeView, hNode)

' Version
DECLARE FUNCTION WinXVersion$ () ' get WinX's current version

END EXPORT
'
'
' ********************************************
' *****  INTERNAL FUNCTION DECLARATIONS  *****
' ********************************************
'
DECLARE FUNCTION ApiAlphaBlend (hdcDest, nXOriginDest, nYOrigDest, nWidthDest, nHeightDest, hdcSrc, nXOriginSrc, nYOriginSrc, nWidthSrc, nHeightSrc, BLENDFUNCTION blendFunction)
DECLARE FUNCTION ApiLBItemFromPt (hLB, x, y, bAutoScroll)

DECLARE FUNCTION CompareLVItems (item1, item2, hLV)

'new in 0.6.0.2
DECLARE FUNCTION Delete_binding (idBinding) ' delete a binding accessed by its id
DECLARE FUNCTION Get_binding (hWnd, @idBinding, BINDING @binding) ' get data of binding accessed by its id

DECLARE FUNCTION GuiAlert (msg$, title$) ' display message dialog box
DECLARE FUNCTION GuiTellApiError (msg$) ' display a WinAPI error message
DECLARE FUNCTION GuiTellDialogError (hOwner, title$) ' display a dialog error message
DECLARE FUNCTION GuiTellRunError (msg$) ' display a run-time error message

DECLARE FUNCTION NewChild (class$, text$, style, x, y, w, h, hParent, idCtr, exStyle) ' create a child window
DECLARE FUNCTION NewWindow (class$, title$, style, x, y, w, h, exStyle) ' create a window

DECLARE FUNCTION STRING_Extract$ (text$, start, end) ' extract a sub-string

DECLARE FUNCTION XWSStoWS (xwss)

DECLARE FUNCTION autoDraw_add (idList, iData)
DECLARE FUNCTION autoDraw_clear (idList)
DECLARE FUNCTION autoDraw_draw (hdc, idList, x0, y0)

DECLARE FUNCTION autoSizer (AUTOSIZERINFO sizerBlock, direction, x0, y0, w, h, currPos) ' the auto sizer function, resizes child windows

DECLARE FUNCTION autoSizerGroup_add (direction)
DECLARE FUNCTION autoSizerGroup_delete (series)
DECLARE FUNCTION autoSizerGroup_show (series, visible)
DECLARE FUNCTION autoSizerGroup_size (series, x0, y0, w, h)

DECLARE FUNCTION autoSizerInfo_add (series, AUTOSIZERINFO sizerBlock)
DECLARE FUNCTION autoSizerInfo_delete (series, iData)
DECLARE FUNCTION autoSizerInfo_get (series, iData, AUTOSIZERINFO @sizerBlock)
DECLARE FUNCTION autoSizerInfo_update (series, iData, AUTOSIZERINFO sizerBlock)
'
' binding
'
DECLARE FUNCTION binding_add (BINDING binding)
DECLARE FUNCTION binding_delete (id)
DECLARE FUNCTION binding_get (id, BINDING @binding)
DECLARE FUNCTION binding_update (id, BINDING binding)

DECLARE FUNCTION cancelDlgOnClose (hWnd) ' onClose() callback for the cancel printing dialog box
DECLARE FUNCTION cancelDlgOnCommand (idCtr, code, hWnd) ' onCommand() callback for the cancel printing dialog box

DECLARE FUNCTION drawArc (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawBezier (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawEllipse (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawEllipseNoFill (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawFill (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawImage (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawLine (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawRect (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawRectNoFill (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawText (hdc, AUTODRAWRECORD record, x0, y0)
'
' Windows Message Handler
'
DECLARE FUNCTION handlerGroup_add ()
DECLARE FUNCTION handlerGroup_delete (group)

DECLARE FUNCTION handlerInfo_add (group, MSGHANDLER handler)
DECLARE FUNCTION handlerInfo_delete (group, iBlock)
DECLARE FUNCTION handlerInfo_get (group, iBlock, MSGHANDLER @handler)
DECLARE FUNCTION handlerInfo_update (group, iBlock, MSGHANDLER handler)

DECLARE FUNCTION handler_call (group, @ret_value, hWnd, wMsg, wParam, lParam)
DECLARE FUNCTION handler_find (group, wMsg)

DECLARE FUNCTION mainWndProc (hWnd, wMsg, wParam, lParam)
DECLARE FUNCTION onNotify (hWnd, wParam, lParam, BINDING binding)

DECLARE FUNCTION initPrintInfo ()
DECLARE FUNCTION printAbortProc (hdc, nCode)

DECLARE FUNCTION groupBox_SizeContents (hGB, pRect)
DECLARE FUNCTION tabs_SizeContents (hTabs, pRect)

DECLARE FUNCTION refreshWindow (hWnd)
DECLARE FUNCTION sizeWindow (hWnd, w, h)

DECLARE FUNCTION splitterProc (hWnd, wMsg, wParam, lParam) ' splitter control callback function
'
' Auto Drawer
'
DeclareAccess(AUTODRAWRECORD)
'
' Generic Linked List
'
DeclareAccess(LINKEDLIST)
'
' Splitter
'
DeclareAccess(SPLITTERINFO)
'
'
' ***** Shared Program Constants *****
'
$$MAIN_CLASS$			= "WinXMainClass"
$$SPLITTER_CLASS$	= "WinXSplitterClass"

$$auto_sizer$    = "WinXAutoSizerSeries"
$$LeftSubSizer$  = "WinXLeftSubSizer"
$$RightSubSizer$ = "WinXRightSubSizer"
$$SizerInfo$     = "autoSizerInfoBlock"
'
'
' ***********************************
' *****  SOME GLOBAL VARIABLES  *****
' ***********************************
'
SHARED XLONG	hInst		' global instance handle
SHARED XLONG	#bReentry		' ensure enter once
SHARED XLONG	hClipMem		' to copy to the clipboard
SHARED XLONG	hWinXIcon		' WinX's application icon

SHARED XLONG	DLM_MESSAGE
SHARED XLONG	#CustomColors[]		' for WinXDraw_GetColor()

' for drag and drop
SHARED XLONG	tvDragButton
SHARED XLONG	tvDragItem		' if treeview, its property "Disable Drag And Drop" must NOT be set
SHARED XLONG	tvDragImage		' image list for the dragging effect

SHARED PRINTINFO printInfo

SHARED XLONG	#lvs_column_index		' zero-based index of the column to sort by
SHARED XLONG	#lvs_decreasing		' $$TRUE to sort decreasing instead of increasing

SHARED BINDING	bindings[]			'a simple array of bindings

SHARED MSGHANDLER	handlers[]	'a 2D array of handlers
SHARED handlersUM[]	'a usage map so we can see which groups are in use

SHARED AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
SHARED SIZELISTHEAD autoSizerInfoUM[]

SHARED AUTODRAWRECORD	autoDrawInfo[]	'info for the auto drawer
SHARED DRAWLISTHEAD autoDrawInfoUM[]

SHARED TBBUTTONDATA tbbd[]	' info for toolbar customisation
SHARED tbbdUM[]
'
'
' ######################
' #####  WinX ()  #####
' ######################
'	/*
'	[WinX]
' Description = Initialise the WinX library
' Function    = WinX ()
' ArgCount    = 0
' Return      = $$FALSE on success, else $$TRUE on fail.
' Remarks     = Sometimes this gets called automatically.  If your program crashes as soon as you call WinXNewWindow then WinX has not been initialised properly.
'	See Also    =
'	Examples    = IFF WinX () THEN QUIT(0)
'	*/
FUNCTION WinX ()
	SHARED		hInst		' instance handle
	SHARED		hWinXIcon		' WinX's application icon
	SHARED		BINDING	bindings[]			'a simple array of bindings

	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		handlersUM[]	'a usage map so we can see which groups are in use

	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]

	SHARED		AUTODRAWRECORD	autoDrawInfo[]	'info for the auto drawer
	SHARED		DRAWLISTHEAD autoDrawInfoUM[]

	SHARED TBBUTTONDATA tbbd[]	' info for toolbar customisation
	SHARED tbbdUM[]

	WNDCLASSEX wcex		' window class
	INITCOMMONCONTROLSEX	iccex
	OSVERSIONINFOEX os		' to tweack depending on Windows version

	SetLastError (0)
	IF #bReentry THEN RETURN $$FALSE		' enter once...
	#bReentry = $$TRUE		' ...and then no more

' Uncomment for a static build.
' Static build---
'	Xst ()		' initialize Standard Library
'	Xsx ()		' initialize Standard eXtended Library
'	Xma ()		' initialize Math Library
''	Xio ()		' Console input/ouput library
' Static build~~~

	SetLastError (0)
	hInst = GetModuleHandleA (0)
	GetVersionExA (&os)

	ADT ()		' initialize the Abstract Data Types Library

	DIM bindings[0]

	DIM handlers[0,0]
	DIM handlersUM[0]

	DIM autoSizerInfo[0,0]
	DIM autoSizerInfoUM[0]

	DIM autoDrawInfo[0,0]
	DIM autoDrawInfoUM[0]

	DIM tbbd[0]
	DIM tbbdUM[0]

	STRING_Init ()
	SPLITTERINFO_Init ()
	LINKEDLIST_Init ()
	AUTODRAWRECORD_Init ()
'
' initialize the specific common controls classes from the common
' control dynamic-link library
'
	iccex.dwSize = SIZE (INITCOMMONCONTROLSEX)
'
' $$ICC_ANIMATE_CLASS      : animate
' $$ICC_BAR_CLASSES        : toolbar, statusbar, trackbar, tooltips
' $$ICC_COOL_CLASSES       : rebar (coolbar) control
' $$ICC_DATE_CLASSES       : month picker, date picker, time picker, up-down
' $$ICC_HOTKEY_CLASS       : hotkey
' $$ICC_INTERNET_CLASSES   : WIN32_IE >= 0x0400
' $$ICC_LISTVIEW_CLASSES   : listview, header
' $$ICC_PAGESCROLLER_CLASS : page scroller (WIN32_IE >= 0x0400)
' $$ICC_PROGRESS_CLASS     : progress bar
' $$ICC_TAB_CLASSES        : tab control, tooltips
' $$ICC_TREEVIEW_CLASSES   : treeview, tooltips
' $$ICC_UPDOWN_CLASS       : up-down
' $$ICC_USEREX_CLASSES     : extended combo box
' $$ICC_WIN95_CLASSES      : everything else
'
	iccex.dwICC  = $$ICC_ANIMATE_CLASS      | _
	             $$ICC_BAR_CLASSES        | _
	             $$ICC_COOL_CLASSES       | _
	             $$ICC_DATE_CLASSES       | _
	             $$ICC_HOTKEY_CLASS       | _
	             $$ICC_INTERNET_CLASSES   | _
	             $$ICC_LISTVIEW_CLASSES   | _
	             $$ICC_NATIVEFNTCTL_CLASS | _
	             $$ICC_PAGESCROLLER_CLASS | _
	             $$ICC_PROGRESS_CLASS     | _
	             $$ICC_TAB_CLASSES        | _
	             $$ICC_TREEVIEW_CLASSES   | _
	             $$ICC_UPDOWN_CLASS       | _
	             $$ICC_USEREX_CLASSES     | _
	             $$ICC_WIN95_CLASSES
'
' 0.6.0.2-old---
' GL-don't bother error checking!
'	IFF InitCommonControlsEx (&iccex) THEN RETURN $$TRUE
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	InitCommonControlsEx (&iccex)
' 0.6.0.2-new~~~
'
	initPrintInfo ()

	'set wcex.hIcon with WinX's application icon
	hWinXIcon = 0
	hLib = LoadLibraryA (&"WinX.dll")
	IF hLib THEN
		' Make sure that WinX.RC file contains the statement:
		' "WinXIcon ICON WinX.ico"
		hWinXIcon = LoadIconA (hLib, &"WinXIcon")
		FreeLibrary (hLib)
		hLib = 0
	ENDIF

	'register WinX main window class
	wcex.style					= $$CS_PARENTDC
	wcex.lpfnWndProc		= &mainWndProc()
	wcex.cbClsExtra = 0		' no extra bytes after the window class
	wcex.cbWndExtra = 4		' space for the index to a BINDING structure
	wcex.hInstance			= hInst
	wcex.hIcon					= hWinXIcon
	wcex.hCursor				= LoadCursorA (0, $$IDC_ARROW)
'
' 0.6.0.2-old---
'	wcex.hbrBackground	= $$COLOR_BTNFACE + 1
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	IF os.dwMajorVersion > 5 THEN
		wcex.hbrBackground = $$COLOR_WINDOW
	ELSE
		' up to Windows XP
		wcex.hbrBackground	= $$COLOR_BTNFACE + 1
	ENDIF
' 0.6.0.2-new~~~
'
	wcex.lpszClassName	= &$$MAIN_CLASS$
	wcex.cbSize = SIZE (WNDCLASSEX)

	IFZ RegisterClassExA (&wcex) THEN RETURN $$TRUE		' fail

	'register WinX splitter class
	wcex.style					= $$CS_PARENTDC
	wcex.lpfnWndProc = &splitterProc ()		' splitter control callback function
	wcex.lpszMenuName = 0
	wcex.cbClsExtra = 0		' no extra bytes after the window class
	wcex.cbWndExtra = 4		' space for the index to a SPLITTERINFO structure
	wcex.hInstance			= hInst
	wcex.hIcon					= 0
	wcex.hCursor				= 0
'
' 0.6.0.2-old---
'	wcex.hbrBackground	= $$COLOR_BTNFACE + 1
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	IF os.dwMajorVersion > 5 THEN
		wcex.hbrBackground = $$COLOR_WINDOW
	ELSE
		' up to Windows XP
		wcex.hbrBackground	= $$COLOR_BTNFACE + 1
	ENDIF
' 0.6.0.2-new~~~
'
	wcex.lpszClassName	= &$$SPLITTER_CLASS$
	wcex.cbSize = SIZE (WNDCLASSEX)

	RegisterClassExA (&wcex)

'	' display WinX's current version
'	msg$ = "Using library WinX v" + WinXVersion$ ()
'	GuiAlert (msg$, "")

	RETURN $$FALSE		' success

END FUNCTION
'
' ################################
' #####  WinXAddAccelerator  #####
' ################################
' /*
' [WinXAddAccelerator]
' Description = Adds an accelerator to an accelerator array
' Function    = WinXAddAccelerator (ACCEL @accel[], cmd, key, control, alt, shift)
' ArgCount    = 6
' Arg1        = accel[] : an array of accelerators
' Arg2        = cmd : the command the accelerator sends to $$WM_COMMAND
' Arg3        = key : the VK key code
' Arg4        = control : $$TRUE if Control key pressed
' Arg5        = alt : $$TRUE if Alt key pressed
' Arg6        = shift : $$TRUE if Shift key pressed
' Return      = $$TRUE on success or $$FALSE on fail
' Remarks     = array accel[] is automatically augmented
' See Also    = WinXAddAcceleratorTable
' Examples    = bOK = WinXAddAccelerator (@accel[], $$mnuFileOpen, 'O', $$TRUE, $$FALSE, $$FALSE)
' */
FUNCTION WinXAddAccelerator (ACCEL accel[], cmd, key, control, alt, shift)

	VK = $$FVIRTKEY
	IF alt     THEN VK = VK|$$FALT
	IF control THEN VK = VK|$$FCONTROL
	IF shift   THEN VK = VK|$$FSHIFT

	IFZ accel[] THEN
		DIM accel[0]
		upp = 0
	ELSE
		upp = UBOUND (accel[]) + 1
		REDIM accel[upp]
	ENDIF

	accel[upp].fVirt = VK
	accel[upp].key = key
	accel[upp].cmd = cmd

	RETURN $$TRUE		' success

END FUNCTION
'
' #####################################
' #####  WinXAddAcceleratorTable  #####
' #####################################
'
'	/*
' [WinXAddAcceleratorTable]
' Description = Creates an accelerator table pour API TranslateAcceleratorA().
' Function    = WinXAddAcceleratorTable()
' ArgCount    = 1
' Arg1        = ACCEL accel[]: an array of accelerators
' Return      = the new accelerator table handle or 0 on fail
' Remarks     =
' See Also    = WinXAddAccelerator
' Examples    = hAccel = WinXAddAcceleratorTable (@accel[])
' */
'
FUNCTION WinXAddAcceleratorTable (ACCEL accel[])

	SetLastError (0)
	hAccel = 0
	IF accel[] THEN
		cEntries = UBOUND (accel[]) + 1
		hAccel = CreateAcceleratorTableA (&accel[0], cEntries)
		IFZ hAccel THEN
			msg$ = "WinXAddAcceleratorTable: Can't create accelerator table"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF
	RETURN hAccel

END FUNCTION
'
' ##############################
' #####  WinXAddAnimation  #####
' ##############################
'
'	/*
' [WinXAddAnimation]
' Description = Creates a new animation control.
' Function    = WinXAddAnimation()
' ArgCount    = 3
' Arg1        = hParent: the handle to the parent window
' Arg2        = file$: the animation file to play
' Arg3        = idCtr: the unique id for this control
' Return      = $$TRUE on success or $$FALSE on fail
' Remarks     =
' See Also    = WinXAni_Play, WinXAni_Stop
' Examples    = bOK = WinXAddAnimation (hParent, file$, idCtr)
' */
'
FUNCTION WinXAddAnimation (hParent, file$, idCtr)
	hCtr = NewChild ("SysAnimate32", "", $$ACS_CENTER, 0, 0, 0, 0, hParent, idCtr, 0)
	IF hCtr THEN
		SetLastError (0)
		SendMessageA (hCtr, $$ACM_OPENA, 0, &file$)
		RETURN hCtr
	ENDIF
END FUNCTION
'
' ###########################
' #####  WinXAddButton  #####
' ###########################
'	/*
'	[WinXAddButton]
' Description = Creates a new button and adds it to the specified window
' Function    = hButton = WinXAddButton (hParent, text$, hImage, idCtr)
' ArgCount    = 4
'	Arg1        = hParent : The parent window to contain this control
' Arg2				= text$ : The text the button will display. If hImage is not 0, this is either "bitmap" or "icon" depending on whether hImage is a handle to a bitmap or an icon
' Arg3				= hImage : If this is an image button this parameter is the handle to the image, otherwise it must be 0
' Arg4				= idCtr : The unique id for this button
'	Return      = $$TRUE on success or $$FALSE on error
' Remarks     = To create a button that contains a text label, hImage must be 0. \n
' To create a button with an image, load either a bitmap or an icon using the standard gdi functions. \n
' Set the hImage parameter to the handle gdi gives you and the text$ parameter to either "bitmap" or "icon" \n
' Depending on what kind of image you loaded.
'	See Also    =
'	Examples    = 'Define constants to identify the buttons<br/>\n
' $$IDBUTTON1 = 100<br/>$$IDBUTTON2 = 101<br/>\n
'  'Make a button with a text label<br/>\n
'  hButton = WinXAddButton (#hMain, "Click me!", 0, $$IDBUTTON1)</br>\n
'  'Make a button with a bitmap (which in this case is included in the resource file of your application)<br/>\n
'  hBmp = LoadBitmapA (GetModuleHandleA(0), &"bitmapForButton2")<br/>\n
'  hButton2 = WinXAddButton (#hMain, "bitmap", hBmp, $$IDBUTTON2)<br/>
'	*/
FUNCTION WinXAddButton (hParent, text$, hImage, idCtr)

	' set the style
	style = $$BS_PUSHBUTTON
	imageType = 0
	IF hImage THEN
		SELECT CASE LCASE$ (text$)
			CASE "icon"
				style = style|$$BS_ICON
				imageType = $$IMAGE_ICON
			CASE "bitmap"
				style = style|$$BS_BITMAP
				imageType = $$IMAGE_BITMAP
		END SELECT
	ENDIF

	'make the window
	style = style|$$WS_TABSTOP
	hCtr = NewChild ("button", text$, style, 0, 0, 0, 0, hParent, idCtr, 0)
	IF hCtr THEN
		IF hImage THEN
			'add the image
			SetLastError (0)
			ret = SendMessageA (hCtr, $$BM_SETIMAGE, imageType, hImage)
			IFZ ret THEN WinXSetText (hCtr, "err " + text$)		' fail
		ENDIF

		'and we're done!
		RETURN hCtr
	ENDIF

END FUNCTION
'
' #############################
' #####  WinXAddCalendar  #####
' #############################
'
'	/*
' [WinXAddCalendar]
' Description = Creates a new calendar control.
' Function    = WinXAddCalendar()
' ArgCount    = 3
' Arg1        = hParent: the handle to the parent window
' Arg2        = monthsX: the number of months to display in the x direction, returns the width of the control
' Arg3        = monthsY: the number of months to display in the y direction, returns the height of the control
' Return      = the handle to the new calendar control, or 0 on fail
' Remarks     =
' See Also    = WinXCalendar_GetSelection, WinXCalendar_SetSelection
' Examples    = hCal = WinXAddCalendar (hParent, monthsX, monthsY)
' */
'
FUNCTION WinXAddCalendar (hParent, @monthsX, @monthsY, idCtr)
	RECT rect

	hCtr = NewChild ("SysMonthCal32", "", $$WS_TABSTOP, 0, 0, 0, 0, hParent, idCtr, 0)
	IF hCtr THEN
		SetLastError (0)
		SendMessageA (hCtr, $$MCM_GETMINREQRECT, 0, &rect)

		monthsX = monthsX*(rect.right-rect.left)
		monthsY = monthsY*(rect.bottom-rect.top)

		RETURN hCtr
	ENDIF

END FUNCTION
'
' #############################
' #####  WinXAddCheckBox  #####
' #############################
' Creates a new checkbox.
' Wrapper to WinXAddCheckButton()
FUNCTION WinXAddCheckBox (hParent, text$, isFirst, pushlike, idCtr)
	bOK = WinXAddCheckButton (hParent, text$, isFirst, pushlike, idCtr)
	RETURN bOK
END FUNCTION
'
' ################################
' #####  WinXAddCheckButton  #####
' ################################
' Adds a new check button control
' hParent = the handle to the parent window
' text$ = the text of the check control
' isFirst = $$TRUE if this is the first check button in the group, otherwise $$FALSE
' pushlike = $TRUE if the button is to be displayed as a pushbutton
' idCtr = the unique id for this control
' returns the handle to the check button or 0 on fail
FUNCTION WinXAddCheckButton (hParent, text$, isFirst, pushlike, idCtr)

	style = $$WS_TABSTOP|$$BS_AUTOCHECKBOX

	IF isFirst  THEN style = style|$$WS_GROUP
	IF pushlike THEN style = style|$$BS_PUSHLIKE

	hCtr = NewChild ("button", text$, style, 0, 0, 0, 0, hParent, idCtr, 0)

	RETURN hCtr

END FUNCTION
'
' #############################
' #####  WinXAddComboBox  #####
' #############################
' creates a new combobox
' hParent = the handle to the parent window
' canEdit = $$TRUE if the User can enter their own item in the edit box
' images = if this combo box displays images with items, this is a handle to the image list, else 0
' idCtr = id for the control
' returns the new extended combo box handle or 0 on fail.
FUNCTION WinXAddComboBox (hParent, listHeight, canEdit, images, idCtr)
	style = $$WS_TABSTOP

	IF canEdit THEN
		' $$CBS_DROPDOWN     : Editable Drop Down List
		style = style|$$CBS_DROPDOWN
	ELSE
		' $$CBS_DROPDOWNLIST : Non-editable Drop Down List
		style = style|$$CBS_DROPDOWNLIST
	ENDIF

	hCtr = NewChild ("ComboBoxEx32", "", style, 0, 0, 0, (listHeight + 22), hParent, idCtr, 0)
	IF hCtr THEN
		IF images THEN
			SendMessageA (hCtr, $$CBEM_SETIMAGELIST, 0, images)
		ENDIF
		RETURN hCtr
	ENDIF

END FUNCTION
'
' ############################
' #####  WinXAddControl  #####
' ############################
' Adds a new custom control
' hParent = the handle to the parent window
' class$ = class name for the control - this will be in the control's documentation
' text$ = initial text to appear in the control - not all controls use this parameter
' idCtr = unique id to identify the control
' style = windows style of the control.  You do not have to include $$WS_CHILD or $$WS_VISIBLE
' exStyle = extended style of the control.  For most controls this will be 0
' returns the new custom control handle or 0 on fail.
FUNCTION WinXAddControl (hParent, class$, text$, style, exStyle, idCtr)
	hCtr = NewChild (class$, text$, style, 0, 0, 0, 0, hParent, idCtr, exStyle)
	RETURN hCtr
END FUNCTION
'
' #########################
' #####  WinXAddEdit  #####
' #########################
' Adds a new edit control to the window
' hParent = the handle to the parent window
' text$ = initial text to display in the control
' flags = additional style flags of the control
' idCtr = unique id for this control
' returns the new edit box handle or 0 on fail.
FUNCTION WinXAddEdit (hParent, text$, flags, idCtr)

	style = $$WS_TABSTOP|$$WS_BORDER
	IF style AND $$ES_MULTILINE THEN
		' multiline editor
		style = style|$$WS_VSCROLL|$$WS_HSCROLL
	ENDIF
	style = style | flags		' passed style flags
	hCtr = NewChild ("edit", text$, style, 0, 0, 0, 0, hParent, idCtr, $$WS_EX_CLIENTEDGE)
	RETURN hCtr

END FUNCTION
'
' #############################
' #####  WinXAddGroupBox  #####
' #############################
' Creates a new group box and adds it to the specified window
' hParent = the handle to the parent window
' text$ = label for the group box
' idCtr = unique id for this control
' returns the new group box handle or 0 on fail.
FUNCTION WinXAddGroupBox (hParent, text$, idCtr)

	hCtr = NewChild ("button", text$, $$BS_GROUPBOX, 0, 0, 0, 0, hParent, idCtr, 0)
	IF hCtr THEN
		SetPropA (hCtr, &$$LeftSubSizer$, &groupBox_SizeContents())

		series = autoSizerGroup_add ($$DIR_VERT)		' index
		SetPropA (hCtr, &$$auto_sizer$, series)
		IF series < 0 THEN
			msg$ = "WinXAddGroupBox: Can't add auto sizer to group box" + STR$ (idCtr)
			GuiAlert (msg$, "")
		ENDIF
	ENDIF

	RETURN hCtr

END FUNCTION
'
' ############################
' #####  WinXAddListBox  #####
' ############################
' Makes a new listbox
' hParent     = the handle to the parent window
' sort        = $$TRUE : sort items increasing
' multiSelect = $$TRUE : multiple selections
' idCtr       = control id for the listbox
' returns the new listbox handle or 0 on fail.
FUNCTION WinXAddListBox (hParent, sort, multiSelect, idCtr)

	style = $$WS_TABSTOP|$$WS_BORDER

	IF sort THEN
		' $$LBS_SORT: Sort items increasing
		style = style|$$LBS_SORT
	ENDIF

	IF multiSelect THEN
		' $$LBS_EXTENDEDSEL: Multiple selections
		style = style|$$LBS_EXTENDEDSEL
	ENDIF

	' $$LBS_NOTIFY: enables $$WM_COMMAND's notification code ($$LBN_SELCHANGE)
	style = style|$$LBS_NOTIFY
'
' $$WS_VSCROLL    : Vertical   Scroll Bar
' $$WS_HSCROLL    : Horizontal Scroll Bar
' $$LBS_HASSTRINGS: Items are strings
'
	style = style|$$WS_VSCROLL|$$WS_HSCROLL|$$LBS_HASSTRINGS

	hCtr = NewChild ("listbox", "", style, 0, 0, 0, 0, hParent, idCtr, 0)

	RETURN hCtr

END FUNCTION
'
' #############################
' #####  WinXAddListView  #####
' #############################
' Creates a new listview
' editable = $$TRUE to enable label editing
' view is a view constant ($$LVS_LIST (default), $$LVS_REPORT, $$LVS_ICON, $$LVS_SMALLICON)
' returns the new listview handle or 0 on fail.
FUNCTION WinXAddListView (hParent, hilLargeIcons, hilSmallIcons, editable, view, idCtr)

	style = $$WS_TABSTOP		' multi-selection by default
	IF editable THEN style = style|$$LVS_EDITLABELS

	IF view THEN
		bApply = $$FALSE
		SELECT CASE TRUE
			CASE view AND $$LVS_LIST
				bApply = $$TRUE
			CASE view AND $$LVS_REPORT
				bApply = $$TRUE
			CASE view AND $$LVS_SMALLICON
				bApply = $$TRUE
' 0.6.0.2-old---
' Defined as a zero view constant (!),
' $$LVS_ICON makes the listview go berserk!
'
'			CASE view AND $$LVS_ICON
'				bApply = $$TRUE
' 0.6.0.2-old~~~
		END SELECT

		IF bApply THEN style = style | view
	ENDIF

	exStyle = $$LVS_EX_FULLROWSELECT|$$LVS_EX_LABELTIP

	hCtr = NewChild ("SysListView32", "", style, 0, 0, 0, 0, hParent, idCtr, exStyle)
	IF hCtr THEN
		' patch: set now the listview's extended style
		SendMessageA (hCtr, $$LVM_SETEXTENDEDLISTVIEWSTYLE, $$LVS_EX_FULLROWSELECT|$$LVS_EX_LABELTIP, $$LVS_EX_FULLROWSELECT|$$LVS_EX_LABELTIP)

		SendMessageA (hCtr, $$LVM_SETIMAGELIST, $$LVSIL_NORMAL, hilLargeIcons)
		SendMessageA (hCtr, $$LVM_SETIMAGELIST, $$LVSIL_SMALL , hilSmallIcons)

		RETURN hCtr
	ENDIF

END FUNCTION
'
' ################################
' #####  WinXAddProgressBar  #####
' ################################
' Creates a new progress bar
' hParent = the handle to the parent window
' smooth = $$TRUE if the progress bar is not to be segmented
' idCtr = unique id constant for this control
' returns the new progress bar handle or 0 on fail.
FUNCTION WinXAddProgressBar (hParent, smooth, idCtr)

	style = $$WS_TABSTOP|$$WS_GROUP
	IF smooth THEN
		style = style|$$PBS_SMOOTH
	ENDIF

	hCtr = NewChild ("msctls_progress32", "", style, 0, 0, 0, 0, hParent, idCtr, 0)
	IF hCtr THEN
		' set the minimum and maximum values for the progress bar
		minMax = MAKELONG (0, 1000)
		SendMessageA (hCtr, $$PBM_SETRANGE, 0, minMax)
		RETURN hCtr
	ENDIF

END FUNCTION
'
' ################################
' #####  WinXAddRadioButton  #####
' ################################
' Creates a new radio button
' hParent = the handle to the parent window
' text$ = title of radio button
' isFirst = $$TRUE if this is the first radio button in the group, otherwise $$FALSE
' pushlike = $$TRUE if the button is to be displayed as a push button
' idCtr = unique id constant for the radio button
' returns the new radio button handle or 0 on fail.
FUNCTION WinXAddRadioButton (hParent, text$, isFirst, pushlike, idCtr)

	style = $$WS_TABSTOP|$$BS_AUTORADIOBUTTON

	IF isFirst  THEN style = style|$$WS_GROUP
	IF pushlike THEN style = style|$$BS_PUSHLIKE

	hCtr = NewChild ("button", text$, style, 0, 0, 0, 0, hParent, idCtr, 0)
	RETURN hCtr

END FUNCTION
'
' ###########################
' #####  WinXAddStatic  #####
' ###########################
' Creates a new static control
' hParent = the handle to the parent window
' text$ = text for the static control
' hImage = image to use or 0 if no image
' flags = additional style flags of static control
' idCtr = unique id for this control
' returns the new static control handle or 0 on fail.
FUNCTION WinXAddStatic (hParent, text$, hImage, flags, idCtr)

	style = flags		' passed style flags

	IF hImage THEN
		'add the image
		SELECT CASE LCASE$ (text$)
			CASE "icon"
				style = style|$$SS_ICON
				imageType = $$IMAGE_ICON
			CASE "bitmap"
				style = style|$$SS_BITMAP
				imageType = $$IMAGE_BITMAP
		END SELECT
	ENDIF

	hCtr = NewChild ("static", text$, style, 0, 0, 0, 0, hParent, idCtr, 0)
	IFZ hCtr THEN RETURN 0

	IF hImage THEN
		'add the image
		SetLastError (0)
		ret = SendMessageA (hCtr, $$STM_SETIMAGE, imageType, hImage)
		IFZ ret THEN
			WinXSetText (hCtr, "err " + text$)
			msg$ = "WinXAddStatic: Can't set " + text$ + " to static" + STR$ (idCtr)
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

	'and we're done
	RETURN hCtr

END FUNCTION
'
' ##############################
' #####  WinXAddStatusBar  #####
' ##############################
' Adds a status bar to a window
' hWnd = the window to add the status bar to
' initialStatus$ = a string to initialise the status bar with.  This string contains
'  a number of strings, one for each panel, separated by commas
' idCtr = the id of the status bar
' returns a handle to the new status bar or 0 on fail
FUNCTION WinXAddStatusBar (hWnd, initialStatus$, idCtr)
	BINDING	binding
	RECT rect

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	'get the parent window's style
	window_style = GetWindowLongA (hWnd, $$GWL_STYLE)
	IF window_style AND $$WS_SIZEBOX THEN
		style = $$SBARS_SIZEGRIP
	ELSE
		style = 0
	ENDIF

	'make the status bar
	hCtr = NewChild ("msctls_statusbar32", "", style, 0, 0, 0, 0, hWnd, idCtr, 0)
	IFZ hCtr THEN RETURN 0

	'now prepare the parts
' 0.6.0.2-old---
'	XstParseStringToStringArray (initialStatus$, ",", @s$[])
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
' Extract the comma separated values from initialStatus$
' and place each of them in text$[].
'
	IFZ INSTR (initialStatus$, ",") THEN
		' no comma => singleton
		DIM text$[0]
		text$[0] = initialStatus$
	ELSE
		' one or more commas => parse the comma-separated list
		errNum = ERROR ($$FALSE)
		bErr = XstParseStringToStringArray (initialStatus$, ",", @text$[])
		IF bErr THEN
			msg$ = "WinXAddStatusBar: Can't parse " + initialStatus$
			GuiTellRunError (msg$)
			RETURN 0		' fail
		ENDIF
	ENDIF

	'create array parts[] for holding the right edge cooordinates
	uppPart = UBOUND (text$[])
	DIM parts[uppPart]

	' calculate the right edge coordinate for each part, and
	' copy the coordinates to the array
	SetLastError (0)
	ret = GetClientRect (hCtr, &rect)
	IFZ ret THEN
		msg$ = "WinXAddStatusBar: Can't get client rectangle of the status bar"
		GuiTellApiError (msg$)
		RETURN 0		' fail
	ENDIF

	cPart = uppPart + 1		' number of right edge cooordinates
	w = rect.right - rect.left
	FOR i = 0 TO uppPart
		parts[i] = ((i+1)*w)/cPart
	NEXT i
	parts[uppPart] = -1		' extend to the right edge of the window

	'set the part info
	SendMessageA (hCtr, $$SB_SETPARTS, cPart, &parts[0])

	'and finally, set the text
	FOR i = 0 TO uppPart
		SendMessageA (hCtr, $$SB_SETTEXT, i, &text$[i])
	NEXT i

	'and update the binding
	binding.hStatus = hCtr
	binding.statusParts = uppPart
	binding_update (idBinding, binding)

	RETURN hCtr

END FUNCTION
'
' #########################
' #####  WinXAddTabs  #####
' #########################
' Creates a new tab control
' hParent = the handle to the parent window
' multiline = $$TRUE if this is a multiline control
' idCtr = unique id for this control
' returns the new tab control handle or 0 on fail.
FUNCTION WinXAddTabs (hParent, multiline, idCtr)

	SetLastError (0)
	style = $$WS_TABSTOP
'
' both the tab and parent controls must have the $$WS_CLIPSIBLINGS window style
' $$WS_CLIPSIBLINGS : Clip Sibling Area
' $$TCS_HOTTRACK    : Hot track
'
	style = style|$$TCS_HOTTRACK|$$WS_CLIPSIBLINGS

	IF multiline THEN style = style|$$TCS_MULTILINE

	hCtr = NewChild ("SysTabControl32", "", style, 0, 0, 0, 0, hParent, idCtr, 0)
	IFZ hCtr THEN RETURN 0
'
' Add $$WS_CLIPSIBLINGS style to the parent if missing.
'
	parent_style = GetWindowLongA (hParent, $$GWL_STYLE)
	IFZ parent_style AND $$WS_CLIPSIBLINGS THEN
		parent_style = parent_style|$$WS_CLIPSIBLINGS
		SetWindowLongA (hParent, $$GWL_STYLE, parent_style)
	ENDIF

	SetPropA (hCtr, &$$LeftSubSizer$, &tabs_SizeContents())

' 0.6.0.2-needed?
'	series = autoSizerGroup_add ($$DIR_VERT)
'	SetPropA (hCtr, &$$auto_sizer$, series)
'	IF series < 0 THEN
'		msg$ = "WinXAddTabs: Can't add auto sizer to tab control" + STR$ (idCtr)
'		XstAlert (msg$)
'	ENDIF
' 0.6.0.2-new~~~

	RETURN hCtr

END FUNCTION
'
' ###############################
' #####  WinXAddTimePicker  #####
' ###############################
' Creates a new Date/Time Picker control
' format = the format for the control, should be $$DTS_LONGDATEFORMAT, $$DTS_SHORTDATEFORMAT or $$DTS_TIMEFORMAT
' initialTime = the time to initialise the control TO
' timeValid = $$TRUE if the initialTime parameter is valid
' idCtr = the unique id for this control
' returns the handle to the control or 0 on fail
FUNCTION WinXAddTimePicker (hParent, format, SYSTEMTIME initialTime, timeValid, idCtr)

	SetLastError (0)

	style = $$WS_TABSTOP
	SELECT CASE format
		CASE $$DTS_LONGDATEFORMAT, $$DTS_SHORTDATEFORMAT, $$DTS_TIMEFORMAT
			style = style | format
	END SELECT

	hCtr = NewChild ("SysDateTimePick32", "", style, 0, 0, 0, 0, hParent, idCtr, 0)
	IF hCtr THEN
		IF timeValid THEN
			wParam = $$GDT_VALID
			lParam = &initialTime
		ELSE
			wParam = $$GDT_NONE
			lParam = 0
		ENDIF
		SendMessageA (hCtr, $$DTM_SETSYSTEMTIME, wParam, lParam)

		RETURN hCtr
	ENDIF

END FUNCTION
'
' ############################
' #####  WinXAddTooltip  #####
' ############################
' Adds a tooltip to a control
' hCtr = the handle to the control to set the tooltip for
' theTip$ = the text of the tooltip
' returns bOK: $$TRUE on success
FUNCTION WinXAddTooltip (hCtr, theTip$)
	BINDING binding
	TOOLINFO ti

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hCtr
		CASE 0
			msg$ = "WinXAddTooltip: no control handle for tooltips control " + theTip$
			GuiAlert (msg$, "")

		CASE ELSE
			theTip$ = TRIM$ (theTip$)
			IFZ theTip$ THEN
				msg$ = "WinXAddTooltip: no text for tooltips control"
				GuiAlert (msg$, "")
				theTip$ = "(Missing)"
			ENDIF

			'get the binding of the parent window
			hParent = GetParent (hCtr)
			IFZ hParent THEN EXIT SELECT
			IFF Get_binding (hParent, @idBinding, @binding) THEN EXIT SELECT

			ti.uFlags = $$TTF_SUBCLASS|$$TTF_IDISHWND
			ti.hwnd = hParent
			ti.uId = hCtr
			ti.lpszText = &theTip$

			' is there any info on this control?
			fInfo = SendMessageA (binding.hToolTips, $$TTM_GETTOOLINFO, 0, &ti)
			IFZ fInfo THEN
				wMsg = $$TTM_ADDTOOL		' make new entry
' 0.6.0.2-new+++
				style = $$WS_POPUP|$$TTS_NOPREFIX|$$TTS_ALWAYSTIP
				binding.hToolTips = NewChild ("tooltips_class32", "", style, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, hParent, 0, 0)
				IFZ binding.hToolTips THEN
					msg$ = "WinXAddTooltip: Can't add tooltips " + theTip$
					GuiTellApiError (msg$)
					EXIT SELECT
				ENDIF
' 0.6.0.2-new~~~
			ELSE
				wMsg = $$TTM_UPDATETIPTEXT		' update the text
			ENDIF
			ti.cbSize = SIZE (TOOLINFO)

			'add the tooltip text theTip$
			SetLastError (0)
			ret = SendMessageA (binding.hToolTips, wMsg, 0, &ti)
			IF ret THEN
				bOK = $$TRUE
			ELSE
				msg$ = "WinXAddTooltip: Can't add tooltips " + theTip$
				GuiTellApiError (msg$)
			ENDIF

	END SELECT

	RETURN bOK

END FUNCTION
'
' #############################
' #####  WinXAddTrackBar  #####
' #############################
' Adds a new trackbar control
' hParent = the parent window for the trackbar
' enableSelection = $$TRUE to enable selctions in the trackbar
' posToolTip = $$TRUE to enable a tooltip which displays the position of the slider
' idCtr = the unique id constant of this trackbar
' returns the handle to the trackbar or 0 on fail
FUNCTION WinXAddTrackBar (hParent, enableSelection, posToolTip, idCtr)
	style = $$WS_TABSTOP|$$TBS_AUTOTICKS
	IF enableSelection THEN style = style|$$TBS_ENABLESELRANGE
	IF posToolTip      THEN style = style|$$TBS_TOOLTIPS
	hCtr = NewChild ("msctls_trackbar32", "", style, 0, 0, 0, 0, hParent, idCtr, 0)
	RETURN hCtr
END FUNCTION
'
' #############################
' #####  WinXAddTreeView  #####
' #############################
' Creates a new treeview
' hParent = the handle to the parent window
' editable = $$TRUE to enable label editing
' draggable = $$TRUE to enable dragging
' idCtr = unique id constant for this control
' returns the new treeview handle or 0 on fail.
FUNCTION WinXAddTreeView (hParent, hImages, editable, draggable, idCtr)

	style = $$WS_TABSTOP
'
' $$TVS_LINESATROOT : Lines at root
' $$TVS_HASLINES    : |--lines
' $$TVS_HASBUTTONS  : [-]/[+]
'
	style = style|$$TVS_HASBUTTONS|$$TVS_HASLINES|$$TVS_LINESATROOT

	IFF draggable THEN style = style|$$TVS_DISABLEDRAGDROP
	IF editable   THEN style = style|$$TVS_EDITLABELS

	hCtr = NewChild ("SysTreeView32", "", style, 0, 0, 0, 0, hParent, idCtr, 0)
	IF hCtr THEN
		IF hImages THEN
			'attach the image list to treeview
			SendMessageA (hCtr, $$TVM_SETIMAGELIST, $$TVSIL_NORMAL, hImages)
		ENDIF
		RETURN hCtr
	ENDIF

END FUNCTION
'
' ##########################
' #####  WinXAni_Play  #####
' ##########################
' Starts playing an animation control
' hAni = the animation control to play
' returns bOK: $$TRUE on success
FUNCTION WinXAni_Play (hAni)
	SetLastError (0)
	IF hAni THEN
		wFrom = 0		' zero-based index of the frame where playing begins
		wTo = -1		' -1 means end with the last frame in the AVI clip
		lParam = MAKELONG (wFrom, wTo)
		IF SendMessageA (hAni, $$ACM_PLAY, -1, lParam) THEN
			RETURN $$TRUE		' success
		ENDIF
	ENDIF
END FUNCTION
'
' ##########################
' #####  WinXAni_Stop  #####
' ##########################
' Stops playing and animation control
' hAni = the animation control to stop playing
' returns bOK: $$TRUE on success
FUNCTION WinXAni_Stop (hAni)
	SetLastError (0)
	IF hAni THEN
		IF SendMessageA (hAni, $$ACM_STOP, 0, 0) THEN
			RETURN $$TRUE
		ENDIF
	ENDIF
END FUNCTION
'
' ####################################
' #####  WinXAttachAccelerators  #####
' ####################################
' Attaches an accelerator table to a window
' hWnd = window to add the accelerator table to
' hAccel = accelerator table handle
' returns bOK: $$TRUE on success
FUNCTION WinXAttachAccelerators (hWnd, hAccel)
	BINDING binding

	bOK = $$FALSE
	IF hAccel THEN
		'get the binding
		IF Get_binding (hWnd, @idBinding, @binding) THEN
			binding.hAccelTable = hAccel
			bOK = binding_update (idBinding, binding)
		ENDIF
	ENDIF
	RETURN bOK
END FUNCTION
'
' #########################################
' #####  WinXAutoSizer_GetMainSeries  #####
' #########################################
' Gets the id of the main auto sizer series for a window
' hWnd = the window to get the series for
' returns the id of the main series of the window
' or -1 on fail.
' Note: The main series is horizontal.
'
'	main_series = WinXAutoSizer_GetMainSeries (#hMain) ' get the main series
'	IF main_series < 0 THEN
'		severity = 2		' error
'		title$ = PROGRAM$ (0) + "-Fail"
'		msg$ = "initWindow: Can't get the main series"
'	ELSE
'		severity = 0		' simple message
'		title$ = PROGRAM$ (0) + "-Debug"
'		msg$ = "initWindow: main_series =" + STR$ (main_series)
'	ENDIF
'	WinXDialog_Error (msg$, title$, severity)
'
FUNCTION WinXAutoSizer_GetMainSeries (hWnd)
	BINDING binding

	main_series = -1		' not an index
	'get the binding
	IF Get_binding (hWnd, @idBinding, @binding) THEN
		IF binding.autoSizerInfo >= 0 THEN
			main_series = binding.autoSizerInfo
		ENDIF
	ENDIF
	RETURN main_series
END FUNCTION
'
' ###################################
' #####  WinXAutoSizer_SetInfo  #####
' ###################################
' Sets info for the auto sizer to use when sizing your controls
' hCtr = the handle to the control to resize
' series = the series to place the control in
'          -1 for parent's series
' space# = the space from the previous control
' size# = the size of this control
' x#, y#, w#, h# = the size and position of the control on the current window
' flags = a set of $$SIZER flags
' returns bOK: $$TRUE on success
'
'	space# = 0.00	' first control (0%)
'	size# = 1.00	' the size of this control (100%)
'	x# = 0.00			' left margin (0%)
'	y# = 0.00			' top margin (0%)
'	w# = 0.98			' width (98%)
'	h# = 0.98			' height (98%)
'	flags = 0
'	WinXAutoSizer_SetInfo (hTV, -1, space#, size#, x#, y#, w#, h#, flags)
'
FUNCTION WinXAutoSizer_SetInfo (hCtr, series, space#, size#, x#, y#, w#, h#, flags)
	SHARED hInst		' instance handle
	SHARED SIZELISTHEAD autoSizerInfoUM[]		' for the direction

	BINDING binding
	AUTOSIZERINFO sizerBlock
	SPLITTERINFO splitterInfo

	SetLastError (0)
	IFZ hInst THEN
		hInst = GetModuleHandleA (0)		' Unlikely!
	ENDIF
	bOK = $$FALSE

	SELECT CASE hCtr
		CASE 0
			msg$ = "WinXAutoSizer_SetInfo: no window handle for tooltips control " + theTip$
			GuiAlert (msg$, "")

		CASE ELSE
			IF series < 0 THEN
				' get the binding of the parent window
				hParent = GetParent (hCtr)
				IFF Get_binding (hParent, @idBinding, @binding) THEN EXIT SELECT
				series = binding.autoSizerInfo
			ENDIF

			' associate the info
			sizerBlock.hWnd = hCtr
			sizerBlock.space = space#
			sizerBlock.size = size#
			sizerBlock.x = x#
			sizerBlock.y = y#
			sizerBlock.w = w#
			sizerBlock.h = h#
			sizerBlock.flags = flags

			' register the block
			idBlock = GetPropA (hCtr, &$$SizerInfo$)
			IF idBlock > 0 THEN
				'update an old block
				bOK = autoSizerInfo_update (series, idBlock - 1, sizerBlock)
			ELSE
				' make a new block
				slot = autoSizerInfo_add (series, sizerBlock)
				IF slot < 0 THEN
					msg$ = "WinXAutoSizer_SetInfo: Can't add the auto sizer's information"
					GuiAlert (msg$, "")
					EXIT SELECT
				ENDIF
				idBlock = slot + 1
' 0.6.0.2-old---
'				SetLastError (0)
'				IFZ SetPropA (hCtr, &$$SizerInfo$, idBlock) THEN
'					msg$ = "WinXAutoSizer_SetInfo: Can't set the auto sizer's information"
'					GuiTellApiError (msg$)
'					EXIT SELECT
'				ENDIF
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
				SetPropA (hCtr, &$$SizerInfo$, idBlock)
' 0.6.0.2-new~~~
				'make a splitter if we need one
				IF sizerBlock.flags AND $$SIZER_SPLITTER THEN
					splitterInfo.group = series
					splitterInfo.id = idBlock - 1
					splitterInfo.direction = autoSizerInfoUM[series].direction

					autoSizerInfo_get (series, idBlock - 1, @sizerBlock)
					idSplitter = SPLITTERINFO_New (@splitterInfo)
					IF idSplitter <= 0 THEN EXIT SELECT

					hParent = GetParent (hCtr)
					style = $$WS_CHILD|$$WS_VISIBLE|$$WS_CLIPSIBLINGS

					SetLastError (0)
					sizerBlock.hSplitter = CreateWindowExA (0, &$$SPLITTER_CLASS$, 0, style, 0, 0, 0, 0, hParent, 0, hInst, idSplitter)
					IFZ sizerBlock.hSplitter THEN
						msg$ = "WinXAutoSizer_SetInfo: Can't create the splitter control"
						GuiTellApiError (msg$)
						EXIT SELECT
					ENDIF

					bOK = autoSizerInfo_update (series, idBlock - 1, sizerBlock)
					IFF bOK THEN
						msg$ = "WinXAutoSizer_SetInfo: Can't update the auto sizer's information"
						GuiAlert (msg$, "")
						EXIT SELECT
					ENDIF
				ENDIF
			ENDIF

			bOK = $$TRUE

	END SELECT

	refreshWindow (hCtr)
	RETURN bOK

END FUNCTION
'
' #########################################
' #####  WinXAutoSizer_SetSimpleInfo  #####
' #########################################
' A simplified version of WinXAutoSizer_SetInfo
FUNCTION WinXAutoSizer_SetSimpleInfo (hWnd, series, DOUBLE space, DOUBLE size, flags)
' 0.6.0.2-old---
'	RETURN WinXAutoSizer_SetInfo (hWnd, series, space, size, 0.00, 0.00, 1.00, 1.00, flags)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	bOK = $$FALSE
	IF hWnd THEN
		x# = 0.00		' left margin (0%)
		y# = 0.00		' top margin (0%)
		w# = 0.99		' width (99%)
		h# = 0.99		' height (99%)
		bOK = WinXAutoSizer_SetInfo (hWnd, series, space, size, x#, y#, w#, h#, flags)
	ENDIF
	RETURN bOK
' 0.6.0.2-new~~~
END FUNCTION
'
' #################################
' #####  WinXButton_GetCheck  #####
' #################################
' Gets the check state of a check or radio button
' hButton = the handle to the button to get the check state for
' returns $$TRUE if the button is checked, $$FALSE otherwise
FUNCTION WinXButton_GetCheck (hButton)
	SetLastError (0)
	IF hButton THEN
		state = SendMessageA (hButton, $$BM_GETCHECK, 0, 0)
		IF state AND $$BST_CHECKED THEN RETURN $$TRUE
	ENDIF
END FUNCTION
'
' #################################
' #####  WinXButton_SetCheck  #####
' #################################
' Sets the check state of a check or radio button
' hButton = the handle to the button to set the check state for
' checked = $$TRUE to check the button, $$FALSE to uncheck it
' returns bOK: $$TRUE on success
FUNCTION WinXButton_SetCheck (hButton, checked)
	SetLastError (0)
	IF hButton THEN
		IF checked THEN
			state = $$BST_CHECKED
		ELSE
			state = $$BST_UNCHECKED
		ENDIF
		SendMessageA (hButton, $$BM_SETCHECK, state, 0)
		RETURN $$TRUE
	ENDIF
END FUNCTION
'
' #######################################
' #####  WinXCalendar_GetSelection  #####
' #######################################
' Get the selection in a calendar control
' hCal = the handle to the calendard control
' start = the variable to store the start of the selection range
' end = the variable to store the end of the selection range
' returns bOK: $$TRUE on success
'
' Usage:
'	SYSTEMTIME time
'
'	bOK = WinXCalendar_GetSelection (hCal, @time)
'	IFF bOK THEN
'		msg$ = "WinXCalendar_GetSelection: Can't get the selection in a calendar control"
' 		GuiTellApiError (msg$)
'		RETURN $$TRUE ' error
'	ENDIF
'
FUNCTION WinXCalendar_GetSelection (hCal, SYSTEMTIME time)
' 0.6.0.2-old---
'	IFZ SendMessageA (hCal, $$MCM_GETCURSEL, 0, &time) THEN RETURN $$FALSE ELSE RETURN $$TRUE
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	SetLastError (0)
	IF hCal THEN
		timeSize = SIZE (time)
		IF SendMessageA (hCal, $$MCM_GETCURSEL, timeSize, &time) THEN
			RETURN $$TRUE
		ELSE
			msg$ = "WinXCalendar_GetSelection: Can't get the selected date"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF
' 0.6.0.2-new~~~
END FUNCTION
'
' #######################################
' #####  WinXCalendar_SetSelection  #####
' #######################################
' Set the selection in a calendar control
' hCal = the handle to the calendard control
' start = the start of the selection range
' end = the end of the selection range
' returns bOK: $$TRUE on success
FUNCTION WinXCalendar_SetSelection (hCal, SYSTEMTIME time)
	SetLastError (0)
	IF hCal THEN
		ret = SendMessageA (hCal, $$MCM_SETCURSEL, 0, &time)
		IF ret THEN
			RETURN $$TRUE		' success
		ELSE
			msg$ = "WinXCalendar_SetSelection: Can't set a selection in the calendatr"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF
END FUNCTION
'
' #########################
' #####  WinXCleanUp  #####
' #########################
' Optional cleanup.
FUNCTION WinXCleanUp ()
	SHARED hInst
	SHARED hClipMem		' to copy to the clipboard
	SHARED tvDragImage		' drag image
	SHARED BINDING bindings[]

	SetLastError (0)

	IFZ hInst THEN
		' Unlikely!
		hInst = GetModuleHandleA (0)
	ENDIF
'
' Free global allocated memory.
'
	IF hClipMem THEN GlobalFree (hClipMem)
	hClipMem = 0		' don't free twice
'
' Delete the image list created by CreateDragImage.
'
	IF tvDragImage THEN ImageList_Destroy (tvDragImage)
	tvDragImage = 0
'
' Preserve the window handles because
' $$WM_DESTROY causes the deletion of corresponding binding.
'
	upp = UBOUND (bindings[])
	DIM window_handle[upp]
	iAdd = -1

	IFZ hInst THEN
		' Unlikely!
		FOR i = 0 TO upp
			IF bindings[i].hWnd THEN
				' hold the window handle
				INC iAdd
				window_handle[iAdd] = bindings[i].hWnd
			ENDIF
		NEXT i
	ELSE
		FOR i = 0 TO upp
			IF bindings[i].hWnd THEN
				hWndInst = GetWindowLongA (bindings[i].hWnd, $$GWL_HINSTANCE)
				SELECT CASE hWndInst
					CASE 0, hInst
						' Same instance: hold the window handle!
						INC iAdd
						window_handle[iAdd] = bindings[i].hWnd
				END SELECT
			ENDIF
		NEXT i
	ENDIF

	IF iAdd < upp THEN
		upp = iAdd
		REDIM window_handle[upp]
	ENDIF
'
' Destroy all windows (backwards).
'
	IF window_handle[] THEN
		FOR i = UBOUND (window_handle[]) TO 0 STEP -1
			' hide the window to prevent from crashing
			ret = ShowWindow (window_handle[i], $$SW_HIDE)
			IF ret THEN
				' $$WM_DESTROY causes the deletion of corresponding binding
				DestroyWindow (window_handle[i])
			ENDIF
		NEXT i
	ENDIF

	#bReentry = $$FALSE

END FUNCTION
'
' ###############################
' #####  WinXClip_GetImage  #####
' ###############################
' Get an image from the clipboard
' returns the handle to the bitmap or 0 on fail
FUNCTION WinXClip_GetImage ()
	BITMAPINFOHEADER bmi

	SetLastError (0)

	r_hImage = 0

	hClipData = 0
	hClip = OpenClipboard (0)		' open the clipboard
	SELECT CASE hClip
		CASE 0		' clipboard unavailable

		CASE ELSE
			hClipData = GetClipboardData ($$CF_DIB)
			IFZ hClipData THEN EXIT SELECT

			pGlobalMem = GlobalLock (hClipData)
			IFZ pGlobalMem THEN EXIT SELECT

			RtlMoveMemory (&bmi, pGlobalMem, ULONGAT (pGlobalMem))
			r_hImage = WinXDraw_CreateImage (bmi.biWidth, bmi.biHeight)
			hdc = CreateCompatibleDC (0)
			hOld = SelectObject (hdc, r_hImage)

			height = ABS (bmi.biHeight)
			pBits = pGlobalMem + SIZE (BITMAPINFOHEADER)

			SELECT CASE bmi.biBitCount
				CASE 1 : pBits = pBits + 8
				CASE 4 : pBits = pBits + 64
				CASE 8 : pBits = pBits + 1024

				CASE 16, 24, 32
					SELECT CASE bmi.biCompression
						CASE $$BI_RGB
						CASE $$BI_BITFIELDS
							pBits = pBits + 12
					END SELECT

			END SELECT
			'
			'PRINT "WinXClip_GetImage: bmi.biBitCount ="; bmi.biBitCount
			'
			SetDIBitsToDevice (hdc, 0, 0, bmi.biWidth, height, 0, 0, 0, height, pBits, pGlobalMem, $$DIB_RGB_COLORS)

			SelectObject (hdc, hOld)
			DeleteDC (hdc) : hdc = 0

	END SELECT

	IF hClipData THEN
		GlobalUnlock (hClipData)
		hClipData = 0
	ENDIF

	IF hClip THEN
		CloseClipboard ()
		hClip = 0
	ENDIF

	RETURN r_hImage

END FUNCTION
'
' ################################
' #####  WinXClip_GetString  #####
' ################################
' Gets a string from the clipboard
' returns the string or an empty string on fail
FUNCTION WinXClip_GetString$ ()

	SetLastError (0)
	IF OpenClipboard (0) THEN
		hClipData = GetClipboardData ($$CF_TEXT)
		IF hClipData THEN
			pGlobalMem = GlobalLock (hClipData)
			IF pGlobalMem THEN
				text$ = CSTRING$ (pGlobalMem)
			ENDIF
			GlobalUnlock (hClipData)
		ENDIF
		CloseClipboard ()
		RETURN text$
	ENDIF

END FUNCTION
'
' ##############################
' #####  WinXClip_IsImage  #####
' ##############################
' Checks to see if the clipboard contains an image
' returns bOK: $$TRUE on success
FUNCTION WinXClip_IsImage ()
	SetLastError (0)
	ret = IsClipboardFormatAvailable ($$CF_DIB)
	IF ret THEN
		RETURN $$TRUE		' clipboard contains an image
	ELSE
		msg$ = "WinXClip_IsImage: Can't check if clipboard contains an image"
		GuiTellApiError (msg$)
	ENDIF
END FUNCTION
'
' ###############################
' #####  WinXClip_IsString  #####
' ###############################
' Checks to see if the clipboard contains a string
' returns $$TRUE if the clipboard contains a string, otherwise $$FALSE
FUNCTION WinXClip_IsString ()
	SetLastError (0)
	ret = IsClipboardFormatAvailable ($$CF_TEXT)
	IF ret THEN
		RETURN $$TRUE		' clipboard contains a string
	ELSE
		msg$ = "WinXClip_IsString: Can't check if clipboard contains a string"
		GuiTellApiError (msg$)
	ENDIF
END FUNCTION
'
' ###############################
' #####  WinXClip_PutImage  #####
' ###############################
' Copy an image to the clipboad
' hImage = the handle to the image to add to the clipboard
' returns bOK: $$TRUE on success
FUNCTION WinXClip_PutImage (hImage)
	SHARED hClipMem		' to copy to the clipboard
	BITMAPINFOHEADER bmi
	DIBSECTION ds

	SetLastError (0)
	bOK = $$FALSE

	hClip = 0

	SELECT CASE hImage
		CASE 0
		CASE ELSE
			IFZ GetObjectA (hImage, SIZE (DIBSECTION), &bmp) THEN EXIT SELECT

			hClip = OpenClipboard (0)
			IFZ hClip THEN EXIT SELECT

			IF hClipMem THEN GlobalFree (hClipMem)		' GL-07dec11-avoid memory leak
			'allocate memory
			cbBits = ds.dsBm.height * ((ds.dsBm.width * ds.dsBm.bitsPixel + 31) \ 32)
			hClipMem = GlobalAlloc ($$GMEM_MOVEABLE|$$GMEM_ZEROINIT, SIZE (BITMAPINFOHEADER) + cbBits)
			IFZ hClipMem THEN EXIT SELECT

			pGlobalMem = GlobalLock (hClipMem)
			RtlMoveMemory (pGlobalMem, &ds.dsBmih, SIZE (BITMAPINFOHEADER))
			RtlMoveMemory (pGlobalMem + SIZE (BITMAPINFOHEADER), ds.dsBm.bits, cbBits)
			GlobalUnlock (hClipMem)		' don't send locked memory to clipboard

			EmptyClipboard ()
			hData = SetClipboardData ($$CF_DIB, hClipMem)		' send memory to the clipboard
			IF hData THEN bOK = $$TRUE		' success

	END SELECT

	IF hClip THEN
		CloseClipboard ()
		hClip = 0
	ENDIF

	RETURN bOK

END FUNCTION
'
' ################################
' #####  WinXClip_PutString  #####
' ################################
' Copies a string to the clipboard
' Stri$ = The string to copy
' returns bOK: $$TRUE on success
FUNCTION WinXClip_PutString (Stri$)
	SHARED hClipMem		' to copy to the clipboard

	SetLastError (0)
	bOK = $$FALSE

	' open the clipboard
	hClip = OpenClipboard (0)
	SELECT CASE hClip
		CASE 0		' can't open the clipboard
		CASE ELSE
			'remove current clipboard's contents
			EmptyClipboard ()
			IFZ Stri$ THEN EXIT SELECT

			IF hClipMem THEN
				'avoid memory leak
				GlobalFree (hClipMem)
				hClipMem = 0		' don't free twice
			ENDIF

			' allocate memory
			hClipMem = GlobalAlloc ($$GMEM_MOVEABLE|$$GMEM_ZEROINIT, (LEN (Stri$) + 1))
			IFZ hClipMem THEN EXIT SELECT

			' lock the object into memory
			pGlobalMem = GlobalLock (hClipMem)
			IFZ pGlobalMem THEN EXIT SELECT

			' move the string into the memory we locked
			RtlMoveMemory (pGlobalMem, &Stri$, LEN (Stri$))

			' don't send clipboard locked memory
			GlobalUnlock (hClipMem)

			' remove current clipboard's contents
			EmptyClipboard ()

			' put text in the clipboard
			hData = SetClipboardData ($$CF_TEXT, hClipMem)
			IF hData THEN bOK = $$TRUE		' success

	END SELECT

	IF hClip THEN
		CloseClipboard ()
		hClip = 0
	ENDIF

	RETURN bOK

END FUNCTION
'
' ##################################
' #####  WinXComboBox_AddItem  #####
' ##################################
' adds an item to a combo box
' hCombo = the handle to the combo box
' index = the index to insert the item at, use -1 to add to the end
' indent = the number of indents to place the item at
' item$ = the item text
' iImage = the index to the image, ignored if this combo box doesn't have images
' iSelImage = the index of the image displayed when this item is selected
' returns the index of the new item, or -1 on fail
FUNCTION WinXComboBox_AddItem (hCombo, index, indent, item$, iImage, iSelImage)
	COMBOBOXEXITEM cbexi

	SetLastError (0)
	r_index = 0
	IF hCombo THEN
		cbexi.mask = $$CBEIF_IMAGE|$$CBEIF_INDENT|$$CBEIF_SELECTEDIMAGE|$$CBEIF_TEXT
		IF index < 0 THEN
			cbexi.iItem = -1		' add to the end
		ELSE
			cbexi.iItem = index
		ENDIF
		cbexi.pszText = &item$
		cbexi.cchTextMax = LEN (item$)

		cbexi.iImage = iImage
		cbexi.iSelectedImage = iSelImage
		cbexi.iIndent = indent

		r_index = SendMessageA (hCombo, $$CBEM_INSERTITEM, 0, &cbexi)
		IF r_index < 0 THEN
			msg$ = "WinXComboBox_AddItem: Can't add new item"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

	RETURN r_index

END FUNCTION
'
' ################################
' #####  WinXComboBox_Clear  #####
' ################################
' Clears out the extended combo box's contents
' and resets the content of its edit control.
' hCombo = extended combo box handle
FUNCTION WinXComboBox_Clear (hCombo)
	SetLastError (0)
	IF hCombo THEN
		SendMessageA (hCombo, $$CB_RESETCONTENT, 0, 0)
		RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' #####################################
' #####  WinXComboBox_DeleteItem  #####
' #####################################
' Deletes an item from a combo box
' hCombo = the handle to the combo box
' index = the zero-based index of the item to delete
' returns bOK: $$TRUE on success
FUNCTION WinXComboBox_DeleteItem (hCombo, index)

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hCombo
		CASE 0
		CASE ELSE
			IF index < 0 THEN EXIT SELECT
			'
			count = SendMessageA (hCombo, $$CB_GETCOUNT, 0, 0)
			IF index < count THEN
				ret = SendMessageA (hCombo, $$CBEM_DELETEITEM, index, 0)
				IF ret THEN
					bOK = $$TRUE
				ELSE
					msg$ = "WinXComboBox_DeleteItem: Can't remove item at index " + STRING$ (index)
					GuiTellApiError (msg$)
				ENDIF
			ENDIF
			'
	END SELECT

	RETURN bOK

END FUNCTION
'
' #######################################
' #####  WinXComboBox_GetEditText$  #####
' #######################################
' Gets the text in the edit cotrol of a combo box
' hCombo = the handle to the combo box
' returns the text or an empty string on fail
FUNCTION WinXComboBox_GetEditText$ (hCombo)
	SetLastError (0)
	IF hCombo THEN
		hEdit = SendMessageA (hCombo, $$CBEM_GETEDITCONTROL, 0, 0)
		IF hEdit THEN
			text$ = WinXGetText$ (hEdit)
			RETURN text$
		ENDIF
	ENDIF
END FUNCTION
'
' ###################################
' #####  WinXComboBox_GetItem$  #####
' ###################################
' Gets the text of an item
' hCombo = the handle to the combo box
' index = the zero-based index of the item to get
'         or -1 to retrieve the item displayed in the edit control.
' returns the text of the item, or an empty string on fail
FUNCTION WinXComboBox_GetItem$ (hCombo, index)
	COMBOBOXEXITEM cbexi

	SetLastError (0)
	IF hCombo THEN
		IF index < 0 THEN
			' retrieve the item displayed in the edit control
			index = -1
		ENDIF
		cbexi.mask = $$CBEIF_TEXT
		cbexi.iItem = index

		cbexi.cchTextMax = $$TextLengthMax
		szBuf$ = NULL$ (cbexi.cchTextMax)
		cbexi.pszText = &szBuf$

		ret = SendMessageA (hCombo, $$CBEM_GETITEM, 0, &cbexi)
'
' $$TextLengthMax too small+++
		IF ret >= $$TextLengthMax THEN
'			msg$ = "WinXListView_GetItemText-Bug?: ret =" + STR$(ret) + " >=" + STR$ ($$TextLengthMax) + " ($$TextLengthMax)"
'			GuiAlert (msg$, "")
			'
			cbexi.cchTextMax = ret
			szBuf$ = NULL$ (cbexi.cchTextMax)
			cbexi.pszText = &szBuf$
			ret = SendMessageA (hCombo, $$CBEM_GETITEM, 0, &cbexi)
		ENDIF
' $$TextLengthMax too small~~~
'
		IF ret THEN
			RETURN CSTRING$ (cbexi.pszText)
		ELSE
			msg$ = "WinXComboBox_GetItem$: Can't get the item's text"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

END FUNCTION
'
' #######################################
' #####  WinXComboBox_GetSelection  #####
' #######################################
' gets the current selection
' hCombo = the handle to the combo box
' returns the currently selected item or $$CB_ERR on fail
'
' Usage:
'	indexSel = WinXComboBox_GetSelection (hCombo)		' get current selection index
'	IF indexSel >= 0 THEN
'		item$ = WinXComboBox_GetItem$ (hCombo, indexSel)
'	ENDIF
'
FUNCTION WinXComboBox_GetSelection (hCombo)
	SetLastError (0)
	IF hCombo THEN
		RETURN SendMessageA (hCombo, $$CB_GETCURSEL, 0, 0)
	ENDIF
END FUNCTION
'
' #####################################
' #####  WinXComboBox_RemoveItem  #####
' #####################################
' removes an item from a combobox
' hCombo = the handle to the combobox
' index = the zero-based index of the item to delete
' r_number_left = the number of items remaining in the list
'  or -1 on fail
FUNCTION WinXComboBox_RemoveItem (hCombo, index, @r_number_left)
' 0.6.0.2-old---
'	RETURN SendMessageA (hCombo, $$CBEM_DELETEITEM, index, 0)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	SetLastError (0)
	r_number_left = -1

	IF hCombo THEN
		IF index >= 0 THEN		'zero-based index
			count = SendMessageA (hCombo, $$CB_GETCOUNT, 0, 0)
			IF index < count THEN
				ret = SendMessageA (hCombo, $$CBEM_DELETEITEM, index, 0)
				IF ret = (count-1) THEN
					r_number_left = ret
					RETURN $$TRUE
				ELSE
					msg$ = "WinXComboBox_RemoveItem: Can't remove item at index " + STRING$ (index)
					GuiTellApiError (msg$)
				ENDIF
			ENDIF
		ENDIF
	ENDIF
' 0.6.0.2-new~~~
END FUNCTION
'
' ######################################
' #####  WinXComboBox_SetEditText  #####
' ######################################
' Sets the text in the edit control for a combo box
' hCombo = the handle to the combo box
' text$ = the text to put in the control
' returns bOK: $$TRUE on success
FUNCTION WinXComboBox_SetEditText (hCombo, text$)
	SetLastError (0)
	IF hCombo THEN
		hEdit = SendMessageA (hCombo, $$CBEM_GETEDITCONTROL, 0, 0)
		IF hEdit THEN
			' GL-08feb11-WinXSetText (hCombo, text$)
			WinXSetText (hEdit, text$)
			RETURN $$TRUE		' success
		ELSE
			msg$ = "WinXComboBox_SetEditText: Can't set the text of the combo box"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF
END FUNCTION
'
' #######################################
' #####  WinXComboBox_SetSelection  #####
' #######################################
' Selects an item in a combo box
' hCombo = the handle to the combo box
' index = the index of the item to select,
'         -1 to deselect everything.
' returns bOK: $$TRUE on success
FUNCTION WinXComboBox_SetSelection (hCombo, index)

	SetLastError (0)
	bOK = $$FALSE

	IF hCombo THEN
		IF index < 0 THEN
			' unselect
			SendMessageA (hCombo, $$CB_SETCURSEL, -1, 0)		' unselect everything
			bOK = $$TRUE
		ELSE
			' select combo box item
			ret = SendMessageA (hCombo, $$CB_SETCURSEL, index, 0)
			IF ret = $$CB_ERR THEN
				msg$ = "WinXComboBox_SetSelection: Can't select the item at index " + STRING$ (index)
				GuiTellApiError (msg$)
			ELSE
				bOK = $$TRUE
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ##############################
' #####  WinXDialog_Error  #####
' ##############################
' Displays an error dialog box
' msg$ = the message to display
' title$ = the title of the message box
' severity = severity of the error
' 0 = debug, 1 = warning, 2 = error, 3 = unrecoverable error
' returns $$TRUE or abort if unrecoverable error
'
' Usage:
'	title$ = "Action"
'	IF bOK THEN
'		severity = 0		' simple message
'		msg$ = "OK!"
'	ELSE
'		severity = 2		' error
'		msg$ = "Error!"
'	ENDIF
'	WinXDialog_Error (msg$, title$, severity)
'
FUNCTION WinXDialog_Error (msg$, title$, severity)

	IF severity < 0 THEN severity = 0
	IF severity > 3 THEN severity = 3

	icon = 0
	SELECT CASE severity
		CASE 0 : icon = $$MB_ICONASTERISK
		CASE 1 : icon = $$MB_ICONWARNING
		CASE 2 : icon = $$MB_ICONSTOP
		CASE 3 : icon = $$MB_ICONSTOP
	END SELECT

	hWnd = GetActiveWindow ()
	MessageBoxA (hWnd, &msg$, &title$, $$MB_OK|icon)
'
' 0.6.0.2-old---
'	IF severity = 3 THEN QUIT(0)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	IF severity = 3 THEN XstAbend ("WinXDialog_Error: Unrecoverable error.")
' 0.6.0.2-new~~~
'
	RETURN $$TRUE

END FUNCTION
'
' ################################
' #####  WinXDialog_Message  #####
' ################################
' Displays a simple message dialog box
' hOwner = the handle to the owner window, 0 for none
' msg$ = the text to display
' title$ = the title for the dialog
' iIcon = the id of the icon to use
' hMod = the handle to the module from which the icon comes, 0 for this module
' returns bOK: $$TRUE on success
'
' Usage:
' WinXClip_PutString (Stri$)
' WinXDialog_Message (#winMain, Stri$, "String In Clipboard", 0, hInst)
'
FUNCTION WinXDialog_Message (hOwner, msg$, title$, iIcon, hMod)
	SHARED hInst		' instance handle
	MSGBOXPARAMS mb

	SetLastError (0)
	IFZ hInst THEN
		hInst = GetModuleHandleA (0)		' Unlikely!
	ENDIF

	mb.lpszText = &msg$
	mb.lpszCaption = &title$
	mb.dwStyle = $$MB_OK
	IF iIcon THEN
		mb.dwStyle = mb.dwStyle|$$MB_USERICON
	ENDIF
	mb.lpszIcon = iIcon

	IFZ hMod THEN
		mb.hInstance = hInst
	ELSE
		mb.hInstance = hMod
	ENDIF

	IFZ hOwner THEN
		mb.hwndOwner = GetActiveWindow ()
	ELSE
		mb.hwndOwner = hOwner
	ENDIF
	mb.cbSize = SIZE (MSGBOXPARAMS)

	MessageBoxIndirectA (&mb)
	RETURN $$TRUE		' success

END FUNCTION
'
' ##################################
' #####  WinXDialog_OpenFile$  #####
' ##################################
' Displays a File Open Dialog.
' hOwner = the handle to the window to own this dialog
' title$ = the title for the dialog
' extensions$ = a string containing the file extensions the dialog supports
' initialName$ = the filename to initialize the dialog with
' multiSelect = $$TRUE to enable selection of multiple items, otherwise $$FALSE
'
' returns the opened files or "" on cancel or error
'
' File filter ofn.lpstrFilter
' ===========
' i.e.: extensions$ = "Text Files|*.txt|Image Files|*.bmp;*.jpg)
'
' ofn.lpstrFilter = buffer containing pairs of zero-terminated filter strings:
' i.e. extensions$ = "Desc_1|Ext_1|...Desc_n|Ext_n"
' ==> fileFilter$ = "Desc_10Ext_10...Desc_n0Ext_n0"
'
' The 1st string in each pair describes a filter (for example, "Text Files"),
' the 2nd string specifies the filter pattern (for example, "*.TXT").
' ...
'
' Multiple filters can be specified for a single item by separating the
' filter-pattern strings with a semicolon (for example, "*.txt;*.doc;*.bak").
' The last string in the buffer must be terminated by two zero-characters.
' If this parameter is NULL, the dialog box will not display any filters.
' The filter strings are assumed to be in the proper order, the operating
' system not changing the order.
'
' Usage:
'
'	title$ = "Open " + ext_lc$ + " File"
'	extensions$ = "Files (*" + ext_lc$ + ")|*" + ext_lc$
'	initialName$ = "*" + ext_lc$
'	multiSelect = $$FALSE
'
'	opened$ = WinXDialog_OpenFile$ (#winMain, title$, extensions$, initialName$, multiSelect)
'	IFZ opened$ THEN
'		bOpen = $$FALSE
'	ELSE
'		bOpen = $$TRUE
'	ENDIF
'
FUNCTION WinXDialog_OpenFile$ (hOwner, title$, extensions$, initialName$, multiSelect)
	SHARED hInst		' instance handle
	OPENFILENAME ofn

	IFZ hInst THEN
		hInst = GetModuleHandleA (0)		' Unlikely!
	ENDIF

	SetLastError (0)
	r_selFiles$ = ""
'
' set initial file parts
' initialName$ = "path\name.ext"
'
	initDir$ = ""		' <path\>
	initFN$ = ""		' <name>
	initExt$ = ""		' <.ext>
'
' Parse initialName$ to compute initDir$, initFN$, initExt$.
'
	initialName$ = TRIM$ (initialName$)
	IFZ initialName$ THEN
		XstGetCurrentDirectory (@initialName$)
		initialName$ = initialName$ + $$PathSlash$ + "*.*"
	ENDIF
'
' Ensure Windows' path slashes.
'
	pos = INSTR (initialName$, "/")
	DO WHILE pos
		initialName${pos-1} = '\\'
		pos = INSTR (initialName$, "/", pos+1)
	LOOP
'
'msg$ = "WinXDialog_OpenFile$: initialName$ = " + initialName$
'GuiAlert (msg$, "")
'
	SELECT CASE TRUE
		CASE RIGHT$ (initialName$) = $$PathSlash$		' GL-15dec08-initialName$ is a directory
			initDir$ = initialName$

		CASE RIGHT$ (initialName$) = ":"		' GL-14nov11-initialName$ is a drive
			initDir$ = initialName$

		CASE ELSE
'
' 0.6.0.2-old---
' Handle initialName$ = ".\\images\\*.bmp".
'
'			XstDecomposePathname (initialName$, @initDir$, "", @initFN$, "", @initExt$)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			slash = RINSTR (initialName$, $$PathSlash$)
			IFZ slash THEN
				initDir$ = initialName$
			ELSE
				initDir$ = LEFT$ (initialName$, slash)
			ENDIF
			dot = INSTR (initialName$, ".", slash+1)
			IFZ dot THEN
				initFN$ = STRING_Extract$ (initialName$, slash+1, LEN(initialName$))
				initExt$ = ""
			ELSE
				IF (slash+1) = dot THEN
					initFN$ = "*"
				ELSE
					initFN$ = STRING_Extract$ (initialName$, slash+1, dot-1)
				ENDIF
				initExt$ = STRING_Extract$ (initialName$, dot, LEN(initialName$))		' initExt$ = <.ext>
			ENDIF
' 0.6.0.2-new~~~
'
	END SELECT
'
'msg$ = "WinXDialog_OpenFile$: initFN$ = <" + initFN$ + ">, initExt$ = <" + initExt$ + ">"
'GuiAlert (msg$, "")
'
	' compute ofn.lpstrInitialDir
	initDir$ = TRIM$ (initDir$)
	IF initDir$ THEN
		' clip off a final $$PathSlash$
		IF RIGHT$ (initDir$) = $$PathSlash$ THEN initDir$ = RCLIP$ (initDir$)
		ofn.lpstrInitialDir = &initDir$
	ENDIF
'
' SET file filter fileFilter$ WITH ARGUMENT extensions$
' ==============================================================================
' i.e.: extensions$ = "Text Files|*.TXT|Image Files|*.bmp;*.jpg)|
'
' fileFilter$ = buffer containing pairs of zero-terminated filter strings:
' i.e. extensions$ = "Desc_1|Ext_1|...Desc_n|Ext_n"
' ==> fileFilter$ = "Desc_10Ext_10...Desc_n0Ext_n0"
'
' The 1st string in each pair describes a filter (for example, "Text Files"),
' the 2nd string specifies the filter pattern (for example, "*.TXT").
' ...
'
' Multiple filters can be specified for a single item by separating the
' filter-pattern strings with a semicolon (for example, "*.TXT;*.DOC;*.BAK").
' The last string in the buffer must be terminated by two zero-characters.
' If this parameter is NULL, the dialog box will not display any filters.
' The filter strings are assumed to be in the proper order, the operating
' system not changing the order.
' ==============================================================================
'
	fileFilter$ = TRIM$ (extensions$)
	IF RIGHT$ (fileFilter$) <> "|" THEN fileFilter$ = fileFilter$ + "|"
'
' replace all separators "|" by the zero-character
'
	pos = INSTR (fileFilter$, "|")
	DO WHILE pos > 0
		fileFilter${pos-1} = 0
		pos = INSTR (fileFilter$, "|", pos+1)
	LOOP

	ofn.lpstrFilter = &fileFilter$
	ofn.nFilterIndex = 1

	IF initExt$ THEN
		' look for the extension to compute ofn.nFilterIndex
		pos = RINSTRI (extensions$, initExt$)
		IF (pos > 0) THEN
			source$ = LEFT$ (extensions$, pos)
			IF INSTR (source$, "|") THEN
				count = XstTally (source$, "|")
				ofn.nFilterIndex = 1 + (count \ 2)
			ENDIF
		ENDIF
	ENDIF
'
' debug+++
'msg$ = "WinXDialog_OpenFile$: initFN$ = <" + initFN$ + ">, initExt$ = <" + initExt$ + ">"
'GuiAlert (msg$, "")
' debug~~~
'
	path$ = initFN$ + initExt$

	' initialize buffer szBuf$
	IF LEN (path$) >= $$MAX_PATH THEN
		szBuf$ = LEFT$ (path$, $$MAX_PATH)		' truncate path$
	ELSE
		szBuf$ = path$ + NULL$ ($$MAX_PATH - LEN (path$))		' pad path$
	ENDIF
	ofn.lpstrFile = &szBuf$
	ofn.nMaxFile = LEN (szBuf$)
'
' debug+++
'msg$ = "WinXDialog_OpenFile$: szBuf$ = " + szBuf$
'GuiAlert (msg$, "")
' debug~~~
'
	IF title$ THEN ofn.lpstrTitle = &title$		' dialog title

	' set dialog flags
	ofn.flags = $$OFN_FILEMUSTEXIST|$$OFN_EXPLORER

	IF multiSelect THEN
		ofn.flags = ofn.flags|$$OFN_ALLOWMULTISELECT
	ENDIF
'
' Allows to open "Read Only" (no lock) the selected file(s).
'
	ofn.flags = ofn.flags|$$OFN_READONLY		' show the checkbox "Read Only" (initially checked)

	ofn.lpstrDefExt = &initExt$

	IFZ hOwner THEN
		ofn.hwndOwner = GetActiveWindow ()
	ELSE
		ofn.hwndOwner = hOwner
	ENDIF
	ofn.hInstance = hInst

	ofn.lStructSize = SIZE (OPENFILENAME)		' length of the structure (in bytes)
	SetLastError (0)
	ret = GetOpenFileNameA (&ofn)		' fire off dialog
' 0.6.0.2-new+++
	IFZ ret THEN
		caption$ = "WinXDialog_OpenFile$: Windows' Open File Error"
		GuiTellDialogError (hOwner, caption$)
		RETURN		' fail
	ENDIF
' 0.6.0.2-new~~~

	' build r_selFiles$, a list of selected files, separated by ";"
	IFF multiSelect THEN
		opened$ = CSTRING$ (ofn.lpstrFile)
		opened$ = TRIM$ (opened$)
		r_selFiles$ = opened$
	ELSE
		' opened file loop
		r_selFiles$ = ""
		p = ofn.lpstrFile
		DO WHILE UBYTEAT (p)		' list loop
			opened$ = ""
			DO		' opened file name loop
				opened$ = opened$ + CHR$ (UBYTEAT (p))
				INC p
			LOOP WHILE UBYTEAT (p)

			opened$ = TRIM$ (opened$)
			IFZ r_selFiles$ THEN
				r_selFiles$ = opened$
			ELSE
				r_selFiles$ = r_selFiles$ + ";" + opened$
			ENDIF
			INC p		' skip nul terminator
		LOOP
	ENDIF

	RETURN r_selFiles$

END FUNCTION
'
' #################################
' #####  WinXDialog_Question  #####
' #################################
' Displays a dialog asking the User a question
' hOwner = the handle to the owner window or 0 for none
' text$ = the question
' title$ = the dialog box title
' cancel = $$TRUE to enable the cancel button
' defaultButton = the zero-based index of the default button
' returns the id of the button the User selected
'
' Usage:
'FUNCTION winMain_OnClose (hWnd)
'
'	title$ = PROGRAM$ (0) + "-Exit"
'	msg$ = "Are you sure you want to quit the application?"
'	mret = WinXDialog_Question (#winMain, msg$, title$, $$FALSE, 0)		' default to the 'Yes' button
'	IF mret = $$IDNO THEN RETURN 1		' quit is canceled
'
'	' quit application
'	PostQuitMessage ($$WM_QUIT)
'	RETURN 0		' quit is confirmed
'
'END FUNCTION
'
FUNCTION WinXDialog_Question (hOwner, msg$, title$, cancel, defaultButton)

	SetLastError (0)
	IF cancel THEN
		style = $$MB_YESNOCANCEL
	ELSE
		style = $$MB_YESNO
	ENDIF
	SELECT CASE defaultButton
		CASE 1 : style = style|$$MB_DEFBUTTON2
		CASE 2 : style = style|$$MB_DEFBUTTON3
	END SELECT
	style = style|$$MB_ICONQUESTION

	IFZ hOwner THEN
		hOwner = GetActiveWindow ()
	ENDIF

	ret = MessageBoxA (hOwner, &msg$, &title$, style)
	RETURN ret

END FUNCTION
'
' ##################################
' #####  WinXDialog_SaveFile$  #####
' ##################################
' Displays a File Save Dialog.
' hOwner = the handle to the parent window
' title$ = the title of the dialog box
' extensions$ = a string listing the supported extensions
' initialName$ = the name to initialise the dialog with
' overwritePrompt = $$TRUE to warn the User when they are about to overwrite a file, $$FALSE otherwise
' returns the bachup file or the empty string on error/cancel.
FUNCTION WinXDialog_SaveFile$ (hOwner, title$, extensions$, initialName$, overwritePrompt)
	SHARED hInst		' instance handle
	OPENFILENAME ofn

	IFZ hInst THEN
		hInst = GetModuleHandleA (0)		' Unlikely!
	ENDIF

	SetLastError (0)
'
' set file filter fileFilter$ with argument extensions$
' i.e.: extensions$ = "Image Files (*.bmp, *.jpg)|*.bmp;*.jpg"
' .                 ==> fileFilter$ = "Image Files (*.bmp, *.jpg)0*.bmp;*.jpg00"
'
	fileFilter$ = TRIM$ (extensions$)

	' add a trailing separator as terminator for convenience
	IF RIGHT$ (fileFilter$) <> "|" THEN fileFilter$ = fileFilter$ + "|"

	defExt$ = ""
'
' use the 1st extension as a default----------------vvv
' i.e.: fileFilter$ = "Image Files (*.bmp, *.jpg)|*.bmp;*.jpg|"
' .            posSepBeg-------------------------^     ^     ^
' .        posSemiColumn-------------------------------+     |
' .            posSepEnd-------------------------------------+
'
' extensions$ = "Image Files (*.bmp, *.jpg)|*.bmp;*.jpg||"
' .             |-------description--------|--pattern--|
' - state 1 = in filter description
' - state 2 = in filter pattern
'
	filterState = 1		' start with a filter description (first pair element)

	' replace all separators "|" by the zero-character
	pos = INSTR (fileFilter$, "|")
	DO WHILE pos
		SELECT CASE filterState
			CASE 1 : filterState = 2		' skip the filter description

			CASE 2		' 2nd pair element = filter pattern
'
' the 2nd pair element in each pair describes a pattern
' .       defExt$--------vvv
' i.e.               "|*.bmp;*.jpg|"
' .     posFirst------^     ^     ^
' . posSemiColumn-----------+     |
' .     posLast-------------------+
'
				IFZ defExt$ THEN
					posFirst = pos		' position of the 1st separator '|'
					posLast = INSTR (fileFilter$, "|", posFirst)		' position of the 2nd separator '|'
					posSemiColumn = INSTR (fileFilter$, ";", posFirst)		' position of an eventual extensions list separator ';'

					IF (posSemiColumn > 0) && (posSemiColumn < posLast) THEN
						' extension list, separator is ';'
						cCh = posSemiColumn - posFirst		' i.e. "|*.ext1;*.ext2;...|"
					ELSE
						' single extension
						cCh = posLast - posFirst		' i.e. "|*.ext1|"
					ENDIF
					IF cCh > 0 THEN
						' extract the default extension from the pattern (it's the 1st of the list)
						defExt$ = MID$ (fileFilter$, posFirst, cCh)		' clip up to the separator (';' or '|')
						' remove the leading dot from the extension
						pos = INSTR (defExt$, ".")
						IF (pos > 0) THEN defExt$ = LCLIP$ (defExt$, pos)
					ENDIF
				ENDIF

				filterState = 1		' switch to the description

		END SELECT

		fileFilter${pos-1} = 0		' replace '|' by zero-character
		pos = INSTR (fileFilter$, "|", pos+1)		' position of the next separator '|'
	LOOP

	ofn.lpstrFilter = &fileFilter$

	' initialize buffer szBuf$
	IF LEN (initialName$) >= $$MAX_PATH THEN
		szBuf$ = LEFT$ (initialName$, $$MAX_PATH)		' truncate initialName$
	ELSE
		szBuf$ = initialName$ + NULL$ ($$MAX_PATH - LEN (initialName$))		' pad initialName$
	ENDIF
	ofn.lpstrFile = &szBuf$
	ofn.nMaxFile = LEN (szBuf$)

	ofn.lpstrTitle = &title$
	IF defExt$ <> "*" THEN ofn.lpstrDefExt = &defExt$
	IF overwritePrompt THEN
		ofn.flags = $$OFN_OVERWRITEPROMPT
	ENDIF
	IFZ hOwner THEN
		ofn.hwndOwner = GetActiveWindow ()
	ELSE
		ofn.hwndOwner = hOwner
	ENDIF
	ofn.hInstance = hInst
	ofn.lStructSize = SIZE (OPENFILENAME)

	SetLastError (0)
	ret = GetSaveFileNameA (&ofn)
' 0.6.0.2-new+++
	IFZ ret THEN
		caption$ = "WinXDialog_SaveFile$: Windows' Save File Error"
		GuiTellDialogError (hOwner, caption$)
		RETURN		' fail
	ENDIF
' 0.6.0.2-new~~~

	r_savedPath$ = CSTRING$ (ofn.lpstrFile)
	RETURN r_savedPath$

END FUNCTION
'
' #########################
' #####  WinXDrawArc  #####
' #########################
' Draws an arc
' returns id of record.
FUNCTION WinXDrawArc (hWnd, hPen, x1, y1, x2, y2, DOUBLE theta1, DOUBLE theta2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	halfW = (x2-x1)/2
	halfH = (y2-y1)/2

	'normalise the angles
	theta1 = theta1-(INT(theta1/$$TWOPI)*$$TWOPI)
	theta2 = theta2-(INT(theta2/$$TWOPI)*$$TWOPI)

	SELECT CASE theta1
		CASE 0
			a1# = halfW
			o1# = 0
		CASE $$PIDIV2
			a1# = 0
			o1# = halfH
		CASE $$PI
			a1# = -halfW
			o1# = 0
		CASE $$PI3DIV2
			a1# = 0
			o1# = -halfH
		CASE ELSE
			IF theta1+$$PIDIV2 > $$PI THEN a1# = -halfW ELSE a1# = halfW
			o1# =a1#*Tan(theta1)
			IF ABS(o1#) > halfH THEN
				IF theta1 > $$PI THEN o1# = -halfH ELSE o1# = halfH
				a1# = o1#/Tan(theta1)
			ENDIF
	END SELECT

	SELECT CASE theta2
		CASE 0
			a2# = halfW
			o2# = 0
		CASE $$PIDIV2
			a2# = 0
			o2# = halfH
		CASE $$PI
			a2# = -halfW
			o2# = 0
		CASE $$PI3DIV2
			a2# = 0
			o2# = -halfH
		CASE ELSE
			IF theta2+$$PIDIV2 > $$PI THEN a2# = -halfW ELSE a2# = halfW
			o2# =a2#*Tan(theta2)
			IF ABS(o2#) > halfH THEN
				IF theta2 > $$PI THEN o2# = -halfH ELSE o2# = halfH
				a2# = o2#/Tan(theta2)
			ENDIF
	END SELECT

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	record.hPen = hPen
	record.hUpdateRegion = CreateRectRgn (MIN(x1,x2)-10, MIN(y1,y2)-10, MAX(x1,x2)+10, MAX(y1,y2)+10)
	record.rectControl.x1 = x1
	record.rectControl.y1 = y1
	record.rectControl.x2 = x2
	record.rectControl.y2 = y2
	record.rectControl.xC1 = a1#+x1+halfW
	record.rectControl.yC1 = y1+halfH-o1#
	record.rectControl.xC2 = a2#+x1+halfW
	record.rectControl.yC2 = y1+halfH-o2#

	record.draw = &drawArc()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	binding_update (idBinding, binding)

	iData = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, iData)
	RETURN iData
END FUNCTION
'
' ############################
' #####  WinXDrawBezier  #####
' ############################
' Draws a bezier spline
FUNCTION WinXDrawBezier (hWnd, hPen, x1, y1, x2, y2, xC1, yC1, xC2, yC2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	record.hPen = hPen
	record.hUpdateRegion = CreateRectRgn (MIN(x1,x2)-10, MIN(y1,y2)-10, MAX(x1,x2)+10, MAX(y1,y2)+10)
	record.rectControl.x1 = x1
	record.rectControl.y1 = y1
	record.rectControl.x2 = x2
	record.rectControl.y2 = y2
	record.rectControl.xC1 = xC1
	record.rectControl.yC1 = yC1
	record.rectControl.xC2 = xC2
	record.rectControl.yC2 = yC2

	record.draw = &drawBezier()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	binding_update (idBinding, binding)

	iData = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, iData)
	RETURN iData
END FUNCTION
'
' #############################
' #####  WinXDrawEllipse  #####
' #############################
' Draws an ellipse
FUNCTION WinXDrawEllipse (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	record.hPen = hPen
	record.hUpdateRegion = CreateRectRgn (MIN(x1,x2)-10, MIN(y1,y2)-10, MAX(x1,x2)+10, MAX(y1,y2)+10)
	record.hBrush = hBrush
	record.rect.x1 = x1
	record.rect.y1 = y1
	record.rect.x2 = x2
	record.rect.y2 = y2

	record.draw = &drawEllipseNoFill()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	binding_update (idBinding, binding)

	iData = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, iData)
	RETURN iData
END FUNCTION
'
' ################################
' #####  WinXDrawFilledArea  #####
' ################################
' Fills an enclosed area with a brush
FUNCTION WinXDrawFilledArea (hWnd, hBrush, colBound, x, y)
	AUTODRAWRECORD	record
	BINDING			binding
	RECT rect

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	GetWindowRect (hWnd, &rect)
	record.hUpdateRegion = CreateRectRgn (rect.left, rect.top, rect.right, rect.bottom)
	record.hBrush = hBrush
	record.simpleFill.x = x
	record.simpleFill.y = y
	record.simpleFill.col = colBound

	record.draw = &drawFill()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	binding_update (idBinding, binding)

	iData = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, iData)
	RETURN iData
END FUNCTION
'
' #############################
' #####  WinXDrawEllipse  #####
' #############################
' Draws an ellipse
' hWnd = the window to draw the ellipse on
' hPen and hBrush = the handles to the pen and brush to use
' x1, y1, x2, y2 = the coordinates of the ellipse
' returns the id of the ellipse
FUNCTION WinXDrawFilledEllipse (hWnd, hPen, hBrush, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	record.hUpdateRegion = CreateRectRgn (MIN(x1,x2)-10, MIN(y1,y2)-10, MAX(x1,x2)+10, MAX(y1,y2)+10)
	record.hPen = hPen
	record.hBrush = hBrush
	record.rect.x1 = x1
	record.rect.y1 = y1
	record.rect.x2 = x2
	record.rect.y2 = y2

	record.draw = &drawEllipse()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	binding_update (idBinding, binding)

	iData = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, iData)
	RETURN iData
END FUNCTION
'
' ##########################
' #####  WinXDrawRect  #####
' ##########################
' Draws a rectangle
' hPen and hBrush = the handles to the pen and brush to use
' x1, y1, x2, y2 = the coordinates of the rectangle
' returns the id of the filled rectangle
FUNCTION WinXDrawFilledRect (hWnd, hPen, hBrush, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	record.hUpdateRegion = CreateRectRgn (MIN(x1,x2)-10, MIN(y1,y2)-10, MAX(x1,x2)+10, MAX(y1,y2)+10)
	record.hPen = hPen
	record.hBrush = hBrush
	record.rect.x1 = x1
	record.rect.y1 = y1
	record.rect.x2 = x2
	record.rect.y2 = y2

	record.draw = &drawRect()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	binding_update (idBinding, binding)

	iData = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, iData)
	RETURN iData
END FUNCTION
'
' ###########################
' #####  WinXDrawImage  #####
' ###########################
' Draws an image
' hWnd = the handle to the window to draw on
' hImage = the handle to the image to draw
' x, y, w, h = the x, h, w, and h of the bitmap to blit
' xSrc, ySrc = the x, y coordinates on the image to blit from
' blend = $$TRUE if the image has been premultiplied for alpha blending
' returns the handle to the operation or 0 on fail
FUNCTION WinXDrawImage (hWnd, hImage, x, y, w, h, xSrc, ySrc, blend)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	record.hUpdateRegion = CreateRectRgn (x-1, y-1, x+w+2, y+h+2)
	record.image.x = x
	record.image.y = y
	record.image.w = w
	record.image.h = h
	record.image.xSrc = xSrc
	record.image.ySrc = ySrc
	record.image.hImage = hImage
	record.image.blend = blend

	record.draw = &drawImage()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	binding_update (idBinding, binding)

	iData = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, iData)
	RETURN iData
END FUNCTION
'
' ##########################
' #####  WinXDrawLine  #####
' ##########################
' Draws a line
' hWnd = the handle to the window to draw to
' hPen = a handle to a pen to draw the line with
' x1, y1, x2, y2 = the coordinates of the line
' returns the id of the line
FUNCTION WinXDrawLine (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	record.hPen = hPen
	record.hUpdateRegion = CreateRectRgn (MIN(x1,x2)-10, MIN(y1,y2)-10, MAX(x1,x2)+10, MAX(y1,y2)+10)
	record.rect.x1 = x1
	record.rect.y1 = y1
	record.rect.x2 = x2
	record.rect.y2 = y2

	record.draw = &drawLine()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	binding_update (idBinding, binding)

	iData = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, iData)
	RETURN iData
END FUNCTION
'
' ##########################
' #####  WinXDrawRect  #####
' ##########################
' Draws a rectangle
FUNCTION WinXDrawRect (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	record.hUpdateRegion = CreateRectRgn (MIN(x1,x2)-10, MIN(y1,y2)-10, MAX(x1,x2)+10, MAX(y1,y2)+10)
	record.hPen = hPen
	record.rect.x1 = x1
	record.rect.y1 = y1
	record.rect.x2 = x2
	record.rect.y2 = y2

	record.draw = &drawRectNoFill()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	binding_update (idBinding, binding)

	iData = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, iData)
	RETURN iData
END FUNCTION
'
' ############################
' #####  WinXDraw_Clear  #####
' ############################
' Clears all the graphics in a window
' hWnd = the handle to the window to clear
' returns bOK: $$TRUE on success
FUNCTION WinXDraw_Clear (hWnd)
	BINDING			binding
	RECT rect

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hWnd
		CASE 0
			msg$ = "WinXDraw_Clear: Null handle for the window"
			GuiAlert (msg$, "")

		CASE ELSE
			IFF Get_binding (hWnd, @idBinding, @binding) THEN
				msg$ = "WinXDraw_Clear: Can't get the binding of the window"
				GuiAlert (msg$, "")
				EXIT SELECT		' fail
			ENDIF

			SetLastError (0)
			ret = GetClientRect (hWnd, &rect)
			IFZ ret THEN
				msg$ = "WinXDraw_Clear: Can't get the client rectangle of the window"
				GuiTellApiError (msg$)
				EXIT SELECT		' fail
			ENDIF

			' create a rectangular region
			binding.hUpdateRegion = CreateRectRgn (0, 0, rect.right, rect.bottom)
			bOK = binding_update (idBinding, binding)
			IFF bOK THEN
				msg$ = "WinXDraw_Clear: Can't update the binding of the window"
				GuiAlert (msg$, "")
				EXIT SELECT		' fail
			ENDIF

			bOK = autoDraw_clear (binding.autoDrawInfo)
			IFF bOK THEN
				msg$ = "WinXDraw_Clear: Can't clear the auto drawer of the window"
				GuiAlert (msg$, "")
				EXIT SELECT		' fail
			ENDIF

			' rectangular region no longer needed
			DeleteObject (binding.hUpdateRegion)
			binding.hUpdateRegion = 0
			bOK = binding_update (idBinding, binding)

	END SELECT

	RETURN bOK

END FUNCTION
'
' ###########################
' #####  WinXDraw_Undo  #####
' ###########################
' Undoes a drawing operation
' idDraw = the id of the operation
' returns bOK: $$TRUE on success
FUNCTION WinXDraw_Undo (hWnd, idDraw)
	AUTODRAWRECORD	record
	BINDING			binding
	LINKEDLIST	autoDrawList

	SetLastError (0)
	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

'	LINKEDLIST_Get (binding.autoDrawInfo, @autoDrawList)
'	LinkedList_GetItem (autoDrawList, idDraw, @iData)
	AUTODRAWRECORD_Get (idDraw, @record)
	record.toDelete = $$TRUE
	IFZ binding.hUpdateRegion THEN
		binding.hUpdateRegion = record.hUpdateRegion
	ELSE
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
		DeleteObject (record.hUpdateRegion)
	ENDIF
'
' 0.6.0.2-old---
'	IF record.draw = &drawText () THEN STRING_Delete (record.text.iString)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	IF record.text.iString THEN
		STRING_Delete (record.text.iString)
		record.text.iString = 0
	ENDIF
' 0.6.0.2-new~~~
'
	AUTODRAWRECORD_Update (idDraw, record)
'	LinkedList_DeleteItem (@autoDrawList, idDraw)
'	LINKEDLIST_Update (binding.autoDrawInfo, @autoDrawList)

	bOK = binding_update (idBinding, binding)
	RETURN bOK

END FUNCTION
'
' ###############################
' #####  WinXDraw_GetColor  #####
' ###############################
' Displays a dialog box allowing the user to select a colour
' initialRGB = the colour to initialise the dialog box with
' returns the colour the user selected
'
' Usage:
' new_color = WinXDraw_GetColor (#winMain, color)
' IFZ new_color THEN
' 	' User canceled
' ENDIF
'
FUNCTION WinXDraw_GetColor (hOwner, initialRGB)
	RETURN WinXDraw_GetColour (hOwner, initialRGB)
END FUNCTION
'
' ################################
' #####  WinXDraw_GetColour  #####
' ################################
' Displays a dialog box allowing the User to select a color
' initialRGB = the color to initialise the dialog box with
' returns the color the User selected
FUNCTION WinXDraw_GetColour (hOwner, initialRGB)
	SHARED #CustomColors[]
	CHOOSECOLOR cc

	SetLastError (0)
	r_RGB = 0

	IFZ #CustomColors[] THEN
		'init the custom colors
		DIM #CustomColors[15]
' 0.6.0.2-old---
'		FOR i = 0 TO 15
'			#CustomColors[i] = 0x00FFFFFF
'		NEXT i
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
		i = 0 : #CustomColors[i] = RGB (240, 240, 240)		' very light gray
		INC i : #CustomColors[i] = $$LightBlue - RGB (0, 0, 50)		' less Blue => lighter
		INC i : #CustomColors[i] = $$MediumBlue - RGB (0, 0, 50)		' less Blue => lighter
		INC i : #CustomColors[i] = $$MediumGreen - RGB (0, 50, 0)		' less Green => lighter
		INC i : #CustomColors[i] = $$MediumCyan - RGB (0, 50, 0)		' less Green => lighter
		INC i : #CustomColors[i] = $$MediumRed - RGB (50, 0, 0)		' less Red => lighter
		INC i : #CustomColors[i] = $$MediumMagenta - RGB (50, 0, 0)		' less Red => lighter
		INC i : #CustomColors[i] = $$BrightYellow - RGB (50, 50, 0)		' less Blue and Green => lighter
		INC i : #CustomColors[i] = $$MediumGrey - RGB (50, 50, 50)		' less Blue, Green and Red => lighter
		INC i : #CustomColors[i] = $$MediumSteel - RGB (50, 50, 50)		' less Blue, Green and Red => lighter
		INC i : #CustomColors[i] = $$BrightOrange - RGB (50, 0, 0)		' less Red => lighter
		INC i : #CustomColors[i] = $$Aqua
		INC i : #CustomColors[i] = $$MediumViolet - RGB (50, 0, 50)		' less Blue and Red => lighter
		INC i : #CustomColors[i] = $$Violet - RGB (50, 0, 50)		' less Blue and Red => lighter
		INC i : #CustomColors[i] = $$DarkViolet - RGB (50, 0, 50)		' less Blue and Red => lighter
		INC i : #CustomColors[i] = RGB (150, 200, 250)		' very light blue
' 0.6.0.2-new~~~
	ENDIF
	cc.lpCustColors = &#CustomColors[]

	cc.flags = $$CC_RGBINIT

	' set initial text color
	cc.rgbResult = 0
	IF initialRGB > 0 THEN
		cc.rgbResult = initialRGB MOD (1+RGB(255,255,255))		' assign a valid RGB color
	ENDIF

	IFZ hOwner THEN
		cc.hwndOwner = GetActiveWindow ()
	ELSE
		cc.hwndOwner = hOwner
	ENDIF
	cc.lStructSize = SIZE (CHOOSECOLOR)

	SetLastError (0)
	ret = ChooseColorA (&cc)
	IF ret THEN
		r_RGB = cc.rgbResult		' User clicked button OK
	ELSE
		caption$ = "WinXDraw_GetColor: Color Picker Error"
		GuiTellDialogError (hOwner, caption$)
	ENDIF

	RETURN r_RGB

END FUNCTION
'
' ####################################
' #####  WinXDraw_GetFontDialog  #####
' ####################################
' Displays the get font dialog box
' hOwner = the owner of the dialog
' r_font = the LOGFONT structure to initialize the dialog and store the output
' r_fontRGB = the color of the returned font
' returns bOK: $$TRUE on success
FUNCTION WinXDraw_GetFontDialog (hOwner, LOGFONT r_font, @r_fontRGB)
	SHARED hInst		' instance handle
	CHOOSEFONT chf

	IFZ hInst THEN
		hInst = GetModuleHandleA (0)		' Unlikely!
	ENDIF

	SetLastError (0)
	bOK = $$FALSE

	'set initial text color
	chf.rgbColors = 0
	IF r_fontRGB > 0 THEN
		chf.rgbColors = r_fontRGB MOD (1 + RGB (255, 255, 255))		' assign a valid RGB color
	ENDIF

	chf.hInstance = hInst
	chf.lpLogFont = &r_font		' logical font structure
'
' - $$CF_EFFECTS            : allows to select strikeout, underline, and color options
' - $$CF_SCREENFONTS        : causes dialog to show up
' - $$CF_INITTOLOGFONTSTRUCT: initial settings shows up when the dialog appears
'
	chf.flags = $$CF_EFFECTS|$$CF_SCREENFONTS|$$CF_INITTOLOGFONTSTRUCT

	IFZ hOwner THEN
		chf.hwndOwner = GetActiveWindow ()
	ELSE
		chf.hwndOwner = hOwner
	ENDIF
	chf.lStructSize = SIZE (CHOOSEFONT)
'
' -------------------------------------------------------------------
' create a Font dialog box that enables the User to choose attributes
' for a logical font; these attributes include a typeface name, style
' (bold, italic, or regular), point size, effects (underline,
' strikeout, and text color), and a script (or character set)
' -------------------------------------------------------------------
'
	r_fontRGB = 0
	SetLastError (0)
	ret = ChooseFontA (&chf)
	IFZ ret THEN
		caption$ = "WinXDraw_GetFontDialog: Windows' Font Picker Error"
		GuiTellDialogError (hOwner, caption$)
	ELSE
		fontName$ = TRIM$ (r_font.faceName)
		IF fontName$ THEN
			r_font.height = ABS (r_font.height)
			r_fontRGB = chf.rgbColors		' returned text color
		ENDIF
		bOK = $$TRUE
	ENDIF

	RETURN bOK

END FUNCTION
'
' ####################################
' #####  WinXDraw_GetFontHeight  #####
' ####################################
' Gets the height of a specified font
FUNCTION WinXDraw_GetFontHeight (hFont, @ascent, @descenct)
	TEXTMETRIC tm

	SetLastError (0)

	ascent = 0
	descent = 0
	IF hFont THEN
		hDC = CreateCompatibleDC (0)
		IF hDC THEN
			SelectObject (hDC, hFont)
			GetTextMetricsA (hDC, &tm)
			DeleteDC (hDC) : hDC = 0

			ascent = tm.ascent
			descent = tm.descent
			RETURN tm.height
		ENDIF
	ENDIF
END FUNCTION
'
' ##################################
' #####  WinXDraw_MakeLogFont  #####
' ##################################
' Creates a logical font structure which you can use to create a real font
' font$ = the name of the font to use
' height = the height of the font in pixels
' style = a set of flags describing the style of the font
' returns the logical font r_font
FUNCTION LOGFONT WinXDraw_MakeLogFont (font$, height, style)

	LOGFONT r_font

	SetLastError (0)

	r_font.height = height
	r_font.width = 0

	IF style AND $$FONT_BOLD THEN
		r_font.weight = $$FW_BOLD
	ELSE
		r_font.weight = $$FW_NORMAL
	ENDIF
	IF style AND $$FONT_ITALIC    THEN r_font.italic    = 1 ELSE r_font.italic    = 0
	IF style AND $$FONT_UNDERLINE THEN r_font.underline = 1 ELSE r_font.underline = 0
	IF style AND $$FONT_STRIKEOUT THEN r_font.strikeOut = 1 ELSE r_font.strikeOut = 0

	r_font.charSet = $$DEFAULT_CHARSET
	r_font.outPrecision = $$OUT_DEFAULT_PRECIS
	r_font.clipPrecision = $$CLIP_DEFAULT_PRECIS
	r_font.quality = $$DEFAULT_QUALITY
	r_font.pitchAndFamily = $$DEFAULT_PITCH|$$FF_DONTCARE

	' ensure a nul-terminated font name
	sizeBuf = SIZE (r_font.faceName)
	IF LEN (font$) < sizeBuf THEN
		' pad with trailing nul chars
		r_font.faceName = font$ + NULL$ (sizeBuf - 1)
	ELSE
		' terminate with a nul char
		r_font.faceName = LEFT$ (font$, sizeBuf - 1)
	ENDIF

	RETURN r_font

END FUNCTION
'
' ################################
' #####  WinXDraw_CopyImage  #####
' ################################
' Generates a copy of an image, preserving alpha channel
' hImage =  the handle to the image to copy
' returns the handle to the copy or 0 on fail
FUNCTION WinXDraw_CopyImage (hImage)
	BITMAP bmpSrc
	BITMAP bmpDst

	SetLastError (0)
	hBmpRet = 0

	IF GetObjectA (hImage, SIZE (BITMAP), &bmpSrc) THEN
		hBmpRet = WinXDraw_CreateImage (bmpSrc.width, bmpSrc.height)
		IF hBmpRet THEN
			IF GetObjectA (hBmpRet, SIZE (BITMAP), &bmpDst) THEN
				RtlMoveMemory (bmpDst.bits, bmpSrc.bits, (bmpDst.width * bmpDst.height) << 2)
			ENDIF
		ENDIF
	ENDIF
	RETURN hBmpRet
END FUNCTION
'
' ##################################
' #####  WinXDraw_CreateImage  #####
' ##################################
' Creates a new image
' w, h = the width and height for the new image
' returns the handle to a DIB section representing the image
FUNCTION WinXDraw_CreateImage (w, h)
	BITMAPINFOHEADER bmih

	SetLastError (0)

	bmih.biSize = SIZE (BITMAPINFOHEADER)
	bmih.biWidth  = w
	bmih.biHeight = h
	bmih.biPlanes = 1
	bmih.biBitCount = 32
	bmih.biCompression = $$BI_RGB

	hDIBsection = CreateDIBSection (0, &bmih, $$DIB_RGB_COLORS, &bits, 0, 0)
	RETURN hDIBsection
END FUNCTION
'
' ##################################
' #####  WinXDraw_DeleteImage  #####
' ##################################
' Deletes an image
' hImage = the image to delete
' returns bOK: $$TRUE on success
FUNCTION WinXDraw_DeleteImage (hImage)
	SetLastError (0)
	IF hImage THEN
		IF DeleteObject (hImage) THEN
			RETURN $$TRUE
		ENDIF
	ENDIF
END FUNCTION
'
' ################################
' #####  WinXDraw_LoadImage  #####
' ################################
' Loads an image from disk
' fileName$ = the name of the file
' fileType = the type of file
' returns a handle to the image or 0 on fail
FUNCTION WinXDraw_LoadImage (fileName$, fileType)
	BITMAPINFOHEADER bmih
	BITMAPFILEHEADER bmfh
	BITMAP bmp

	SetLastError (0)
	hBmpRet = 0

	SELECT CASE fileType
		CASE $$FILETYPE_WINBMP
			IFZ fileName$ THEN EXIT SELECT

			'first, load the bitmap
			flags = $$LR_DEFAULTCOLOR|$$LR_CREATEDIBSECTION|$$LR_LOADFROMFILE
			hBitmap = LoadImageA (0, &fileName$, $$IMAGE_BITMAP, 0, 0, flags)
			IFZ hBitmap THEN EXIT SELECT

			'now copy it to a standard format
			GetObjectA (hBitmap, SIZE (BITMAP), &bmp)
			hBmpRet = WinXDraw_CreateImage (bmp.width, bmp.height)
			IFZ hBmpRet THEN EXIT SELECT

			hSrc = CreateCompatibleDC (0)
			hDst = CreateCompatibleDC (0)
			hOldSrc = SelectObject (hSrc, hBitmap)
			hOldDst = SelectObject (hDst, hBmpRet)
			BitBlt (hDst, 0, 0, bmp.width, bmp.height, hSrc, 0, 0, $$SRCCOPY)
			SelectObject (hSrc, hOldSrc)
			SelectObject (hDst, hOldDst)

			DeleteObject (hBitmap) : hBitmap = 0
			DeleteDC (hDst) : hDst = 0
			DeleteDC (hSrc) : hSrc = 0

	END SELECT

	RETURN hBmpRet

END FUNCTION
'
' ######################################
' #####  WinXDraw_GetImageChannel  #####
' ######################################
' Retrieves on of the channels of a WinX image
' hImage =  the handle of the image
' channel = the channel if, 0 for blue, 1 for green, 2 for red, 3 for alpha
' r_data[] =  the UBYTE array to store the channel data
' returns bOK: $$TRUE on success, dimensions data[] appropriately
FUNCTION WinXDraw_GetImageChannel (hImage, channel, UBYTE r_data[])
	BITMAP bmp
	ULONG pixel

	SetLastError (0)
	' reset the returned array
	DIM r_data[]

	IF hImage THEN
		SELECT CASE channel
			CASE 0, 1, 2, 3
				IF GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN
					downshift = channel << 3
					maxPixel = bmp.width * bmp.height - 1
					DIM r_data[maxPixel]
					FOR i = 0 TO maxPixel
						pixel = ULONGAT (bmp.bits, i << 2)
						r_data[i] = UBYTE ((pixel >> downshift) & 0x000000FF)
					NEXT i
					RETURN $$TRUE		' success
				ENDIF
		END SELECT
	ENDIF
END FUNCTION
'
' ###################################
' #####  WinXDraw_GetImageInfo  #####
' ###################################
' Gets information about an image
' hImage = the handle of the image to get info on
' w, h = the width and height of the image
' pBits = the pointer to the bits.  They are arranged row first with the last row at the top of the file
' returns bOK: $$TRUE on success
FUNCTION WinXDraw_GetImageInfo (hImage, @w, @h, @pBits)
	BITMAP bmp

	SetLastError (0)
	w = 0
	h = 0
	pBits = 0

	IF hImage THEN
		IF GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN
			w = bmp.width
			h = bmp.height
			pBits = bmp.bits
			RETURN $$TRUE		' success
		ENDIF
	ENDIF
END FUNCTION
'
' ####################################
' #####  WinXDraw_GetImagePixel  #####
' ####################################
' Gets a pixel on WinX image
' hImage =  the handle to the image
' x, y = the x and y coordinates of the pixel
' returns the RGBA color at the point
FUNCTION RGBA WinXDraw_GetImagePixel (hImage, x, y)
	BITMAP bmp
	RGBA pointRGBA

	SetLastError (0)
	IF GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN
		IF (x >= 0) && (x < bmp.width) && (y >= 0) && (y < bmp.height) THEN
			ULONGAT (&pointRGBA) = ULONGAT (bmp.bits, ((bmp.height - 1 - y) * bmp.width + x) << 2)
		ENDIF
	ENDIF
	RETURN pointRGBA
END FUNCTION
'
' #####################################
' #####  WinXDraw_PixelsPerPoint  #####
' #####################################
' gets the conversion factor between screen pixels and points
FUNCTION DOUBLE WinXDraw_PixelsPerPoint ()

	SetLastError (0)
	cvtHeight# = 0.0
	hDC = GetDC (GetDesktopWindow ())
	IF hDC THEN
		cvtHeight# = DOUBLE (GetDeviceCaps (hDC, $$LOGPIXELSY)) / 72.0
		ReleaseDC (GetDesktopWindow (), hDC)
	ENDIF
	RETURN cvtHeight#

END FUNCTION
'
' #######################################
' #####  WinXDraw_PremultiplyImage  #####
' #######################################
' Premultiplis an image with its alpha channel in preparation for alpha blending
' hImage =  the image to premultiply
' returns bOK: $$TRUE on success
FUNCTION WinXDraw_PremultiplyImage (hImage)
	BITMAP bmp
	RGBA rgba

	SetLastError (0)
	IF hImage THEN
		IF GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN
			maxPixel = (bmp.width * bmp.height) - 1
			FOR i = 0 TO maxPixel
				' get pixel
				ULONGAT (&rgba) = ULONGAT (bmp.bits, i << 2)
				rgba.blue = UBYTE ((XLONG (rgba.blue) * XLONG (rgba.alpha)) \ 255)
				rgba.green = UBYTE ((XLONG (rgba.green) * XLONG (rgba.alpha)) \ 255)
				rgba.red = UBYTE ((XLONG (rgba.red) * XLONG (rgba.alpha)) \ 255)
				ULONGAT (bmp.bits, i << 2) = ULONGAT (&rgba)
			NEXT i
			RETURN $$TRUE		' success
		ENDIF
	ENDIF
END FUNCTION
'
' ###################################
' #####  WinXDraw_ResizeBitmap  #####
' ###################################
' Resize an image cleanly using bicubic interpolation
' hImage = the handle to the source image
' w, h = the width and height for the new image
' returns the handle to the resized image or 0 on fail
FUNCTION WinXDraw_ResizeImage (hImage, w, h)
	BITMAP bmpSrc
	BITMAP bmpDst

	SetLastError (0)
	hBmpRet = 0

	SELECT CASE hImage
		CASE 0
		CASE ELSE
			IF w <= 0 THEN EXIT SELECT
			IF h <= 0 THEN EXIT SELECT

			IFZ GetObjectA (hImage, SIZE (BITMAP), &bmpSrc) THEN EXIT SELECT

			hBmpRet = WinXDraw_CreateImage (w, h)
			IFZ hBmpRet THEN EXIT SELECT
			IFZ GetObjectA (hBmpRet, SIZE (BITMAP), &bmpDst) THEN EXIT SELECT

			hdcDest = CreateCompatibleDC (0)
			hdcSrc = CreateCompatibleDC (0)
			SetStretchBltMode (hdcDest, $$HALFTONE)
			hOldDest = SelectObject (hdcDest, hBmpRet)
			hOldSrc = SelectObject (hdcSrc, hImage)
			StretchBlt (hdcDest, 0, 0, w, h, hdcSrc, 0, 0, bmpSrc.width, bmpSrc.height, $$SRCCOPY)
			SelectObject (hdcDest, hOldDest)
			SelectObject (hdcSrc, hOldSrc)
			DeleteDC (hdcDest)
			DeleteDC (hdcSrc)

	END SELECT

	RETURN hBmpRet

END FUNCTION
'
' #################################
' #####  WinXDraw_SaveBitmap  #####
' #################################
' Saves an image to a file on disk
' hImage = the image to save
' fileName$ = the name for the file
' fileType =  the format in which to save the file
' returns bOK: $$TRUE on success
FUNCTION WinXDraw_SaveImage (hImage, fileName$, fileType)
	BITMAPINFOHEADER bmih
	BITMAPFILEHEADER bmfh
	BITMAP bmp

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE fileType
		CASE $$FILETYPE_WINBMP
			IFZ hImage THEN EXIT SELECT
			IFZ fileName$ THEN EXIT SELECT
			IFZ GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN EXIT SELECT

			fileNumber = OPEN (fileName$, $$WRNEW)
			IF fileNumber < 0 THEN EXIT SELECT

			bmfh.bfType = 0x4D42
			bmfh.bfSize = SIZE (BITMAPFILEHEADER) + SIZE (BITMAPINFOHEADER) + (bmp.widthBytes * bmp.height)
			bmfh.bfOffBits = SIZE (BITMAPFILEHEADER) + SIZE (BITMAPINFOHEADER)

			bmih.biSize = SIZE (BITMAPINFOHEADER)
			bmih.biWidth = bmp.width
			bmih.biHeight = bmp.height
			bmih.biPlanes = bmp.planes
			bmih.biBitCount = bmp.bitsPixel
			bmih.biCompression = $$BI_RGB

			WRITE[fileNumber], bmfh
			WRITE[fileNumber], bmih
			XstBinWrite (fileNumber, bmp.bits, bmp.widthBytes * bmp.height)
			CLOSE (fileNumber)
			fileNumber = 0

			bOK = $$TRUE		' success

	END SELECT

	RETURN bOK

END FUNCTION
'
' #######################################
' #####  WinXDraw_SetConstantAlpha  #####
' #######################################
' Sets the transparency of an image to a constant value
' hImage = the handle to the image
' alpha = the constant alpha
' returns bOK: $$TRUE on success
FUNCTION WinXDraw_SetConstantAlpha (hImage, DOUBLE alpha)
	BITMAP bmp
	ULONG intAlpha

	SetLastError (0)
	IF hImage THEN
		SELECT CASE channel
			CASE 0, 1
				IF GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN
					intAlpha = ULONG (alpha * 255.0) << 24
					maxPixel = bmp.width * bmp.height - 1
					FOR i = 0 TO maxPixel
						ULONGAT (bmp.bits, i << 2) = (ULONGAT (bmp.bits, i << 2) AND 0x00FFFFFFFF) | intAlpha
					NEXT i
					RETURN $$TRUE		' success
				ENDIF
		END SELECT
	ENDIF
END FUNCTION
'
' ######################################
' #####  WinXDraw_SetImageChannel  #####
' ######################################
' Sets one of the channels of a WinX image
' hImage = the handle to the image
' channel = the channel id, 0 for blue, 1 for green, 2 for red, 3 for alpha
' r_data[] = the channel data, a single dimensional UBYTE array containing the channel data
' returns bOK: $$TRUE on success
FUNCTION WinXDraw_SetImageChannel (hImage, channel, UBYTE r_data[])
	BITMAP bmp

	SetLastError (0)

	IF hImage THEN
		SELECT CASE channel
			CASE 0, 1, 2, 3
				IF GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN
					upshift = channel << 3
					mask = NOT (255 << upshift)

					maxPixel = bmp.width * bmp.height - 1
					IF maxPixel <> UBOUND (r_data[]) THEN RETURN $$FALSE

					FOR i = 0 TO maxPixel
						ULONGAT (bmp.bits, i << 2) = (ULONGAT (bmp.bits, i << 2) AND mask) | ULONG (r_data[i]) << upshift
					NEXT i
					RETURN $$TRUE		' success
				ENDIF
		END SELECT
	ENDIF
END FUNCTION
'
' ####################################
' #####  WinXDraw_SetImagePixel  #####
' ####################################
' Sets a pixel on a WinX image
' hImage = the handle to the image
' x, y = the coordinates of the pixel
' codeRGB = the color for the pixel
' returns bOK: $$TRUE on success
FUNCTION WinXDraw_SetImagePixel (hImage, x, y, codeRGB)
	BITMAP bmp

	SetLastError (0)
	IF hImage THEN
		IF GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN
			pixelRGB = 0
			IF codeRGB > 0 THEN
				pixelRGB = codeRGB MOD (1 + RGB (255, 255, 255))		' assign a valid RGB color
			ENDIF
			IF x >= 0 && x < bmp.width && y >= 0 && y < bmp.height THEN
				ULONGAT (bmp.bits, ((bmp.height - 1 - y) * bmp.width + x) << 2) = pixelRGB
				RETURN $$TRUE		' success
			ENDIF
		ENDIF
	ENDIF
END FUNCTION
'
' ###############################
' #####  WinXDraw_Snapshot  #####
' ###############################
' Takes a snapshot of a WinX window and stores the result in an image
' hWnd = the window to photograph
' x, y = the x and y coordinates of the upper left hand corner of the picture
' hImage = the image to store the result
' returns bOK: $$TRUE on success
FUNCTION WinXDraw_Snapshot (hWnd, x, y, hImage)
	BINDING			binding

	SetLastError (0)
	'get the binding
	IF Get_binding (hWnd, @idBinding, @binding) THEN
		hDC = CreateCompatibleDC (0)
		hOld = SelectObject (hDC, hImage)
		autoDraw_draw (hDC, binding.autoDrawInfo, x, y)
		SelectObject (hDC, hOld)
		DeleteDC (hDC)
		RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' ##########################
' #####  WinXDrawText  #####
' ##########################
' Draws some text on a window
' hWnd = the handle to the window
' hFont = the handle to the font
' text$ = the text to print
' x, y = the coordintates to print the text at
' backCol, forCol = the colors for the text
' returns the index of the element or -1 on fail
FUNCTION WinXDrawText (hWnd, hFont, text$, x, y, backCol, forCol)
	AUTODRAWRECORD	record
	BINDING			binding
	TEXTMETRIC tm
	SIZEAPI size

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	hDC = CreateCompatibleDC (0)
	SelectObject (hDC, hFont)
	GetTextExtentPoint32A (hDC, &text$, LEN (text$), &size)
	DeleteDC (hDC) : hDC = 0

	SetLastError (0)
	record.hUpdateRegion = CreateRectRgn (x-1, y-1, x+size.cx+1, y+size.cy+1)
	record.hFont = hFont
	record.text.x = x
	record.text.y = y
	record.text.iString = STRING_New(text$)
	record.text.forColor = forCol
	record.text.backColor = backCol

	record.draw = &drawText()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	binding_update (idBinding, binding)

	iData = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, iData)
	RETURN iData

END FUNCTION
'
' ###################################
' #####  WinXDraw_GetTextWidth  #####
' ###################################
' Gets the width of a string using a specified font
' hFont = the font to use
'  (0 for the default font)
' text$ = the string to get the length for
' maxWidth = the maximum width available for the text, set to -1 if there is no maximum width
' returns the width of the text in pixels, or the number of characters in the string that can be displayed
' at a max width of maxWidth if the width of the text exceeds maxWidth.  If maxWidth is exceeded the return is < 0
FUNCTION WinXDraw_GetTextWidth (hFont, text$, maxWidth)
	SIZEAPI size

	SetLastError (0)
	width = 0

	IFZ hFont THEN
		hFont = GetStockObject ($$DEFAULT_GUI_FONT)
	ENDIF

	SetLastError (0)
	hDC = CreateCompatibleDC (0)
	IFZ hDC THEN
		msg$ = "WinXDraw_GetTextWidth: Can't create compatible DC"
		GuiTellApiError (msg$)
	ELSE
		SelectObject (hDC, hFont)
		GetTextExtentExPointA (hDC, &text$, LEN (text$), maxWidth, &fit, 0, &size)
		DeleteDC (hDC) : hDC = 0

		' maxWidth == -1 for no maximum width
		IF (maxWidth = -1) || (fit >= LEN (text$)) THEN
			width = size.cx
			'GuiAlert ("WinXDraw_GetTextWidth: size.cx = " + STR$ (size.cx), "WinX-Debug")
		ELSE
			width = -fit
			'GuiAlert ("WinXDraw_GetTextWidth: -fit = " + STR$ (-fit), "WinX-Debug")
		ENDIF
	ENDIF

	RETURN width

END FUNCTION
'
' ##########################
' #####  WinXKillFont  #####
' ##########################
' Releases a logical font.
' r_hFont = handle to the logical font, reset on deletion.
' returns bOK: $$TRUE if success
FUNCTION WinXKillFont (@r_hFont)

	SetLastError (0)
	bOK = $$FALSE

	IF r_hFont THEN
		ret = DeleteObject (r_hFont)		' free memory space
		IF ret THEN
			bOK = $$TRUE
			r_hFont = 0
		ENDIF
	ELSE
		msg$ = "WinXKillFont: Ignore a NULL font handle"
		GuiAlert (msg$, "")
	ENDIF

	RETURN bOK

END FUNCTION
'
' #########################
' #####  WinXSetFont  #####
' #########################
' Sets the font for a control
' hCtr = the handle to the control
' hFont = the handle to the font
' returns bOK: $$TRUE on success
FUNCTION WinXSetFont (hCtr, hFont)
	SHARED hFontDefault		' standard font

	IFZ hFontDefault THEN
		hFontDefault = GetStockObject ($$ANSI_VAR_FONT)		' get the standard font
	ENDIF

	SetLastError (0)
	bOK = $$FALSE

	IF hCtr THEN
		IFZ hFont THEN
			hFont = hFontDefault
		ENDIF
		' check hFont not null
		IF hFont THEN
			SetLastError (0)
			SendMessageA (hCtr, $$WM_SETFONT, hFont, $$FALSE)		' $$WM_SETFONT does not return a value
			RETURN $$TRUE
		ENDIF
	ENDIF

END FUNCTION
'
' ###########################
' #####  WinXIsKeyDown  #####
' ###########################
' Checks to see of a key is pressed
' key = the ascii code of the key or a VK code for special keys
' returns $$TRUE if the key is pressed and $$FALSE if it is not
FUNCTION WinXIsKeyDown (key)
	SetLastError (0)
'
' Have to check the high order bit, and since GetKeyState() returns a short,
' that might not be where you expected it.
'
	IF key THEN
		state = GetKeyState (key)
		IF state AND 0x8000 THEN RETURN $$TRUE		' a key was pressed
	ENDIF
END FUNCTION
'
' #############################
' #####  WinXGetMousePos  #####
' #############################
' Gets the mouse position
' hWnd = the handle to the window to get the coordinates relative to, 0 for none
' x = the variable to store the mouse x position
' y = the variable to store the mouse y position
' returns bOK: $$TRUE on success
FUNCTION WinXGetMousePos (hWnd, @x, @y)
	POINT pt

	SetLastError (0)
	x = 0
	y = 0

	GetCursorPos (&pt)

	IFZ hWnd THEN hWnd = GetActiveWindow ()

	IF hWnd THEN
		ScreenToClient (hWnd, &pt)
		x = pt.x
		y = pt.y
		RETURN $$TRUE
	ENDIF

END FUNCTION
'
' ################################
' #####  WinXIsMousePressed  #####
' ################################
' Checks to see if a mouse button is pressed
' button = a MBT constant
' returns $$TRUE if the button is pressed, $$FALSE if it is not
FUNCTION WinXIsMousePressed (button)

	SetLastError (0)
	vk = 0

	IF GetSystemMetrics ($$SM_SWAPBUTTON) THEN
		' the mouse buttons are swapped
		SELECT CASE button
			CASE $$MBT_LEFT 	: vk = $$VK_RBUTTON
			CASE $$MBT_MIDDLE	: vk = $$VK_MBUTTON
			CASE $$MBT_RIGHT	: vk = $$VK_LBUTTON
		END SELECT
	ELSE
		SELECT CASE button
			CASE $$MBT_LEFT		: vk = $$VK_LBUTTON
			CASE $$MBT_MIDDLE	: vk = $$VK_MBUTTON
			CASE $$MBT_RIGHT	: vk = $$VK_RBUTTON
		END SELECT
	ENDIF

	IF vk THEN
		IF GetAsyncKeyState (vk) THEN
			RETURN $$TRUE
		ENDIF
	ENDIF

END FUNCTION
'
' #################################
' #####  WinXListBox_AddItem  #####
' #################################
' Adds an item to a list box.
' hListBox = the list box to add to
' index = the zero-based index to insert the item at, -1 for the end of the list
' Item$ = the string to add to the list
' returns the index of the string in the list or $$LB_ERR on fail
FUNCTION WinXListBox_AddItem (hListBox, index, Item$)
	SetLastError (0)
	IF hListBox THEN
		style = GetWindowLongA (hListBox, $$GWL_STYLE)
		IF style AND $$LBS_SORT THEN
			wMsg = $$LB_ADDSTRING
			indexAdd = 0
		ELSE
			wMsg = $$LB_INSERTSTRING
			indexAdd = index
		ENDIF
		RETURN SendMessageA (hListBox, wMsg, indexAdd, &Item$)
	ENDIF
END FUNCTION
'
' ########################################
' #####  WinXListBox_EnableDragging  #####
' ########################################
' Enables dragging on a list box.  Make sure to register the onDrag callback as well
' hListBox = the handle to the list box to enable dragging on
' returns bOK: $$TRUE on success
FUNCTION WinXListBox_EnableDragging (hListBox)
	SHARED DLM_MESSAGE

	SetLastError (0)
	IF hListBox THEN
		style = GetWindowLongA (hListBox, $$GWL_STYLE)
		IF style AND $$LBS_EXTENDEDSEL THEN
			msg$ = "WinXListBox_EnableDragging-Drag is invalid for a multi-selection listbox"
			GuiAlert (msg$, "")
		ENDIF

		SetLastError (0)
		IF MakeDragList (hListBox) THEN
			DLM_MESSAGE = RegisterWindowMessageA (&$$DRAGLISTMSGSTRING)
			IF DLM_MESSAGE THEN RETURN $$TRUE		' success
		ENDIF
	ENDIF
END FUNCTION
'
' ##################################
' #####  WinXListBox_GetIndex  #####
' ##################################
' Gets the index of a particular string
' hListBox = the handle to the list box containing the string
' searchFor$ = the string to search for
' returns the index of the item or -1 on fail
FUNCTION WinXListBox_GetIndex (hListBox, searchFor$)

	SetLastError (0)
	r_index = -1		' not an index
	IF hListBox THEN
		IF searchFor$ THEN
			DO
				SetLastError (0)
				r_index = SendMessageA (hListBox, $$LB_FINDSTRING, r_index, &searchFor$)
				IF r_index = $$LB_ERR THEN EXIT DO
				SetLastError (0)
			LOOP WHILE SendMessageA (hListBox, $$LB_GETTEXTLEN, r_index, 0) > LEN (searchFor$)
		ENDIF
	ENDIF
	RETURN r_index

END FUNCTION
'
' ##################################
' #####  WinXListBox_GetItem$  #####
' ##################################
' Gets a list box item
' hListBox = the handle to the listbox to get the item from
' index = the index of the item to get
' returns the string of the item, or an empty string on fail
FUNCTION WinXListBox_GetItem$ (hListBox, index)
	SetLastError (0)
	IF hListBox THEN
		IF index >= 0 THEN
			cc = SendMessageA (hListBox, $$LB_GETTEXTLEN, index, 0)
			szBuf$ = NULL$ (cc)
			SetLastError (0)
			cc = SendMessageA (hListBox, $$LB_GETTEXT, index, &szBuf$)
			IF cc THEN
				RETURN CSTRING$ (&szBuf$)
			ELSE
				msg$ = "WinXListBox_GetItem$: Can't get a list box item"
				GuiTellApiError (msg$)
			ENDIF
		ENDIF
	ENDIF
END FUNCTION
'
' ###########################################
' #####  WinXListBox_GetSelectionArray  #####
' ###########################################
' Gets the selected item(s) in a listbox
' hListBox = listbox to get the items from
' r_indexList[] = array to place the indexes of selected items into
' returns the number of selected items or 0 if fail
'
' Usage:
'	cSel = WinXListBox_GetSelectionArray (hListBox, @indexList[])
'	IFZ cSel THEN XstAlert ("No selected items")
'
FUNCTION WinXListBox_GetSelectionArray (hListBox, r_indexList[])

	SetLastError (0)
	r_cSel = 0

	SELECT CASE hListBox
		CASE 0
		CASE ELSE
			style = GetWindowLongA (hListBox, $$GWL_STYLE)
			IF style AND $$LBS_EXTENDEDSEL THEN
				' multiple selections
				r_cSel = SendMessageA (hListBox, $$LB_GETSELCOUNT, 0, 0)
				IF r_cSel > 0 THEN
					DIM r_indexList[r_cSel - 1]
					SendMessageA (hListBox, $$LB_GETSELITEMS, r_cSel, &r_indexList[0])
				ENDIF
			ELSE
				' single selection
				selItem = SendMessageA (hListBox, $$LB_GETCURSEL, 0, 0)
				IF selItem >= 0 THEN
					DIM r_indexList[0]
					r_indexList[0] = selItem
					r_cSel = 1
				ENDIF
			ENDIF

	END SELECT

	IF r_cSel <= 0 THEN
		r_cSel = 0		' just in case
		DIM r_indexList[]		' reset the returned array
	ENDIF

	RETURN r_cSel

END FUNCTION
'
' ####################################
' #####  WinXListBox_RemoveItem  #####
' ####################################
' removes an item from a list box
' hListBox = the list box to remove from
' index = the index of the item to remove, -1 to remove the last item
' returns the number of strings remaining in the list or $$LB_ERR if index is out of range
'
' Usage:
'	ret = WinXListBox_RemoveItem (hListBox, index)
'	IF ret < 0 THEN
'		msg$ = "WinXListBox_RemoveItem: Can't remove item at index " + STRING$ (index)
'		GuiTellApiError (msg$)
'	ENDIF
'
FUNCTION WinXListBox_RemoveItem (hListBox, index)
	SetLastError (0)
	IF hListBox THEN
		IF index < 0 THEN
			index = SendMessageA (hListBox, $$LB_GETCOUNT, 0, 0) - 1
		ENDIF
		r_count = SendMessageA (hListBox, $$LB_DELETESTRING, index, 0)
		RETURN r_count
	ENDIF
END FUNCTION
'
' ##################################
' #####  WinXListBox_SetCaret  #####
' ##################################
' Sets the caret item for a list box
' hListBox = the handle to the list box to set the caret for
' item = the item to move the caret to
' returns bOK: $$TRUE on success
FUNCTION WinXListBox_SetCaret (hListBox, item)
	SetLastError (0)
	IF hListBox THEN
		IFZ SendMessageA (hListBox, $$LB_SETCARETINDEX, item, $$FALSE) = $$LB_ERR THEN
			RETURN $$TRUE
		ENDIF
	ENDIF
END FUNCTION
'
' ###########################################
' #####  WinXListBox_SetSelectionArray  #####
' ###########################################
' Sets the selection on a listbox
' hListBox = the handle to the list box to set the selection for
' indexList[] = an array of item indexes to select
' returns bOK: $$TRUE on success
'
' notes:
' - indexList[i] > count - 1 (last): no selection
' - idx < 0: idx = -1 (unselect for single selection)
'
FUNCTION WinXListBox_SetSelectionArray (hListBox, indexList[])

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hListBox
		CASE 0
		CASE ELSE
			IFZ indexList[] THEN EXIT SELECT		' empty array

			count = SendMessageA (hListBox, $$LB_GETCOUNT, 0, 0)
			IFZ count THEN EXIT SELECT

			style = GetWindowLongA (hListBox, $$GWL_STYLE)
			IF style AND $$LBS_EXTENDEDSEL THEN
				' multiple selections

				' first, unselect everything
				SetLastError (0)
				SendMessageA (hListBox, $$LB_SETSEL, $$FALSE, -1)

				failed = $$FALSE
				upp = UBOUND (indexList[])
				FOR i = 0 TO upp
					IF indexList[i] >= 0 THEN
						ret = SendMessageA (hListBox, $$LB_SETSEL, 1, indexList[i])
						IF ret = $$LB_ERR THEN failed = $$TRUE
					ENDIF
				NEXT i
				IFF failed THEN bOK = $$TRUE
			ELSE
				' single selection
				IF indexList[0] < 0 THEN indexList[0] = -1		' unselect

				SetLastError (0)
				ret = SendMessageA (hListBox, $$LB_SETCURSEL, indexList[0], 0)
				IF ret <> -1 THEN
					' the listbox is scrolled, if necessary, to bring the selected item into view
					SetLastError (0)
					SendMessageA (hListBox, $$LB_SETTOPINDEX, indexList[0], 0)
					bOK = $$TRUE
				ENDIF
			ENDIF

	END SELECT

	RETURN bOK

END FUNCTION
'
' ####################################
' #####  WinXListView_AddColumn  #####
' ####################################
' Adds a column to a listview control for use in report view
' iColumn = the zero-based index for the new column
' wColumn = the width of the column
' label$ = the label$ for the column
' numSubItem = the one-based subscript of the sub item the column displays
' returns the index to the column or -1 on fail
FUNCTION WinXListView_AddColumn (hLV, iColumn, wColumn, label$, numSubItem)
	LV_COLUMN lvCol

	SetLastError (0)
	r_index = -1

	IF hLV THEN
		lvCol.mask = $$LVCF_FMT|$$LVCF_WIDTH|$$LVCF_TEXT|$$LVCF_SUBITEM
		lvCol.fmt = $$LVCFMT_LEFT
		lvCol.cx = wColumn
		lvCol.pszText = &label$
		lvCol.cchTextMax = LEN (label$)
		lvCol.iSubItem = iColumn
		lvCol.iOrder = numSubItem
		'
		ret = SendMessageA (hLV, $$LVM_INSERTCOLUMN, iColumn, &lvCol)
		IF ret >= 0 THEN
			r_index = ret
		ELSE
			msg$ = "WinXListView_AddColumn: Can't add column" + STR$ (iColumn) + ", label <" + label$ + ">"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

	RETURN r_index

END FUNCTION
'
' ##################################
' #####  WinXListView_AddItem  #####
' ##################################
' Adds a new item to a list view control
' iItem: the index at which to insert the item, -1 to add to the end of the list
' list$: the label for the item plus subitems in the form "label\0subItem1\0subItem2..."
'        or "label|subItem1|subItem2..."
' iIcon: the index to the icon/image or -1 if this item has no icon
' returns the index to the item or -1 on fail
'
' Usage:
'	list$ = "Item 1 \0E \0A \05"
'	indexAdd = WinXListView_AddItem (hLV, -1, list$, -1)		' add last
'	IF indexAdd < 0 THEN
'		msg$ = "WinXListView_AddItem: Can't add listview item '" + list$ + "'"
'		XstAlert (msg$)
'	ENDIF
'
FUNCTION WinXListView_AddItem (hLV, iItem, list$, iIcon)

	LV_ITEM lvi

	SetLastError (0)
	r_index = -1

	SELECT CASE hLV
		CASE 0
		CASE ELSE
			source$ = TRIM$ (list$)
			IFZ source$ THEN EXIT SELECT
'
' Replace all embedded zero-characters by separator "|".
'
			FOR i = LEN (source$) - 1 TO 0 STEP -1
				IFZ source${i} THEN source${i} = '|'
			NEXT i
'
' Extract the values separated by | from source$
' and place each of them in text$[].
'
			IFZ INSTR (source$, "|") THEN
				DIM text$[0]
				text$[0] = source$
			ELSE
				errNum = ERROR ($$FALSE)
				bErr = XstParseStringToStringArray (source$, "|", @text$[])
				IF bErr THEN
					msg$ = "WinXListView_AddItem: Can't parse <" + source$ + ">"
					GuiTellRunError (msg$)
					EXIT SELECT		' fail
				ENDIF
			ENDIF
'
' Set the listvew item.
'
			lvi.mask = $$LVIF_TEXT
			IF iIcon > -1 THEN lvi.mask = lvi.mask|$$LVIF_IMAGE

			count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
			IF iItem >= 0 && iItem < count THEN
				lvi.iItem = iItem
			ELSE
				lvi.iItem = count
			ENDIF

			' insert item and set the first subitem
			lvi.iSubItem = 0
			lvi.pszText = &text$[0]
			lvi.iImage = iIcon

			SetLastError (0)
			r_index = SendMessageA (hLV, $$LVM_INSERTITEM, 0, &lvi)
			IF r_index < 0 THEN
				msg$ = "WinXListView_AddItem: Can't insert item <" + source$ + ">, index = " + STRING$ (lvi.iItem)
				GuiTellApiError (msg$)
				EXIT SELECT		' fail
			ENDIF

			' set the other subitems
			upp = UBOUND (text$[])
			FOR i = 1 TO upp		' skip 1st listvew item
				lvi.mask = $$LVIF_TEXT
				lvi.iItem = r_index
				lvi.iSubItem = i
				lvi.pszText = &text$[i]
				SetLastError (0)
				ret = SendMessageA (hLV, $$LVM_SETITEM, 0, &lvi)
				IFZ ret THEN
					msg$ = "WinXListView_AddItem: Can't set subitem" + STR$ (i) + ", value <" + text$[i] + ">"
					GuiTellApiError (msg$)
				ENDIF
			NEXT i

	END SELECT

	RETURN r_index

END FUNCTION
'
' ################################
' #####  WinXListView_Clear  #####
' ################################
' Clears out the listview's contents
' returns bOK: $$TRUE on success
FUNCTION WinXListView_Clear (hLV)

	SetLastError (0)
	IF hLV THEN
		SendMessageA (hLV, $$LVM_DELETEALLITEMS, 0, 0)
		RETURN $$TRUE		' success
	ENDIF

END FUNCTION
'
' #######################################
' #####  WinXListView_DeleteColumn  #####
' #######################################
' Deletes a column in a listview control
' iColumn = the zero-based index of the column to delete
' returns bOK: $$TRUE on success
FUNCTION WinXListView_DeleteColumn (hLV, iColumn)
	IF hLV THEN
		IF SendMessageA (hLV, $$LVM_DELETECOLUMN, iColumn, 0) THEN
			RETURN $$TRUE
		ENDIF
	ENDIF
END FUNCTION
'
' #####################################
' #####  WinXListView_DeleteItem  #####
' #####################################
' Deletes an item from a listview control
' returns bOK: $$TRUE on success
FUNCTION WinXListView_DeleteItem (hLV, iItem)
	SetLastError (0)
	IF hLV THEN
		IF SendMessageA (hLV, $$LVM_DELETEITEM, iItem, 0) THEN
			RETURN $$TRUE
		ENDIF
	ENDIF
END FUNCTION
'
' ###########################################
' #####  WinXListView_GetItemFromPoint  #####
' ###########################################
' Gets a list view item given its coordinates
' hLV = the handle of the listview
' x, y = the x and y coordinates to find the item at
' returns the item index or -1 on fail
FUNCTION WinXListView_GetItemFromPoint (hLV, x, y)
	LVHITTESTINFO lvHit

	SetLastError (0)
	IF hLV THEN
		lvHit.pt.x = x
		lvHit.pt.y = y
		RETURN SendMessageA (hLV, $$LVM_HITTEST, 0, &lvHit)
	ENDIF
END FUNCTION
'
' ######################################
' #####  WinXListView_GetItemText  #####
' ######################################
' Gets the text for a list view item
' hLV = the handle to the list view
' iItem = the zero-based index of the item
' cSubItems = the number of sub items to get
' text$[] = the array to store the result
' returns bOK: $$TRUE on success
'
' Usage:
'	retrieve the first 2 columns of the 1st item
'	bOK = WinXListView_GetItemText (hLV, 0, 1, @aSubItem$[])
'
FUNCTION WinXListView_GetItemText (hLV, iItem, cSubItems, @text$[])
	LV_ITEM lvi		' listview item

	DIM text$[cSubItems]
	FOR i = 0 TO cSubItems
		lvi.mask = $$LVIF_TEXT
		lvi.iItem = iItem
		lvi.iSubItem = i
		lvi.cchTextMax = $$TextLengthMax
		szBuf$ = NULL$ (lvi.cchTextMax)
		lvi.pszText = &szBuf$

		ret = SendMessageA (hLV, $$LVM_GETITEM, iItem, &lvi)
'
' $$TextLengthMax too small+++
		IF ret >= $$TextLengthMax THEN
'			msg$ = "WinXListView_GetItemText-Bug?: ret =" + STR$(ret) + " >=" + STR$ ($$TextLengthMax) + " ($$TextLengthMax)"
'			GuiAlert (msg$, "")
			'
			lvi.cchTextMax = ret
			szBuf$ = NULL$ (lvi.cchTextMax)
			lvi.pszText = &szBuf$
			ret = SendMessageA (hLV, $$LVM_GETITEM, iItem, &lvi)
		ENDIF
' $$TextLengthMax too small~~~
'
		IF ret THEN
			text$[i] = CSTRING$ (&szBuf$)
		ENDIF

	NEXT i

	RETURN $$TRUE

END FUNCTION
'
' ############################################
' #####  WinXListView_GetSelectionArray  #####
' ############################################
' Gets all the selected items in a listview.
' r_indexList[] = the array in which to store the indecies of selected items
' returns the number of selected items
'
'	cSel = WinXListView_GetSelectionArray (hLV, @indexList[])		' get the selected item(s)
'
FUNCTION WinXListView_GetSelectionArray (hLV, r_indexList[])

	SetLastError (0)
	r_cSel = 0

	IF hLV THEN
		r_cSel = SendMessageA (hLV, $$LVM_GETSELECTEDCOUNT, 0, 0)
		IF r_cSel > 0 THEN
			DIM indexList[r_cSel - 1]

			slot = 0
			' now iterate over all the items to locate the selected ones
			upp = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0) - 1
			FOR i = 0 TO upp
				IF SendMessageA (hLV, $$LVM_GETITEMSTATE, i, $$LVIS_SELECTED) THEN
					indexList[slot] = i
					INC slot
					IF slot >= r_cSel THEN
						' the very last selection
						EXIT FOR
					ENDIF
				ENDIF
			NEXT i
		ENDIF
	ENDIF

	IF r_cSel <= 0 THEN
		r_cSel = 0		' just in case
		DIM r_indexList[]		' reset the returned array
	ENDIF

	RETURN r_cSel

END FUNCTION
'
' ######################################
' #####  WinXListView_SetItemText  #####
' ######################################
' Sets new text for an item
' iItem = the zero-based index of the item, iSubItem = 0 the 1 based index of the subitem or 0 if setting the main item
' returns bOK: $$TRUE on success
'
' Usage:
'	bOK = WinXListView_SetItemText (hLV, iItem, 3, sub_text$)		' set new sub-item's text for an item
'	IFF bOK THEN		' fail
'		msg$ = "WinXListView_SetItemText: Can't set 4th sub-item's text for item at index " + STRING$ (iItem)
'		GuiAlert (msg$, "")
'	ENDIF
'
FUNCTION WinXListView_SetItemText (hLV, iItem, iSubItem, newText$)
	LV_ITEM lvi		' listview item

	SetLastError (0)
	IF hLV THEN
		lvi.mask = $$LVIF_TEXT
		lvi.iItem = iItem
		IF iSubItem < 0 THEN
			lvi.iSubItem = 0		' first item?
		ELSE
			lvi.iSubItem = iSubItem
		ENDIF
		lvi.pszText = &newText$

		ret = SendMessageA (hLV, $$LVM_SETITEMTEXT, iItem, &lvi)
		IF ret THEN
			RETURN $$TRUE
		ELSE
			msg$ = "WinXListView_SetItemText: Can't set a sub-item's text for item at index " + STRING$ (iItem)
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

END FUNCTION
'
' #######################################
' #####  WinXListView_SetSelection  #####
' #######################################
' Sets the selection in a listview.
' hLV   = listview handle
' iItem = index to the item to set the selection, -1 to select all
' returns bOK: $$TRUE on success
FUNCTION WinXListView_SetSelection (hLV, iItem)
	LV_ITEM lvi		' listview item

	SetLastError (0)
	bOK = $$FALSE

	IF hLV THEN
		count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
		SELECT CASE TRUE
			CASE count > 0
				IF iItem < 0 THEN
					' select all
					low = 0 : upp = count - 1
				ELSE
					IF iItem >= count THEN iItem = count - 1		' last item
					'
					' select iItem (fake a loop)
					low = iItem : upp = iItem
				ENDIF
				'
				FOR index = low TO upp
					lvi.iItem = index
					lvi.mask = $$LVIF_STATE
					lvi.stateMask = $$LVIS_SELECTED
					'
					lvi.state = $$LVIS_SELECTED		' select
					SendMessageA (hLV, $$LVM_SETITEMSTATE, index, &lvi)
				NEXT index
				'
				SetFocus (hLV)
				bOK = $$TRUE
				'
		END SELECT
	ENDIF

	RETURN bOK

END FUNCTION
'
' ############################################
' #####  WinXListView_SetSelectionArray  #####
' ############################################
' Sets several selections in a listview control
' hLV = listview handle
' indexList[] = the array in which are stored the indecies of selected items
' returns bOK: $$TRUE on success
'
' Usage:
'	DIM indexList[1]		' select the third and 4th items
'	indexList[0] = 2
'	indexList[1] = 3
'	bOK = WinXListView_SetSelectionArray (hLV, @indexList[])
'
FUNCTION WinXListView_SetSelectionArray (hLV, indexList[])
	LV_ITEM lvi		' listview item

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hLV
		CASE 0
		CASE ELSE
			IFZ indexList[] THEN EXIT SELECT

			count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
			IFZ count THEN EXIT SELECT

			style = GetWindowLongA (hLV, $$GWL_STYLE)
			IF style AND $$LVS_SINGLESEL THEN
				' single selection
				IF indexList[0] >= count THEN EXIT SELECT
				'
				idx = indexList[0]
				IF idx < 0 THEN idx = -1		' unselect
				lvi.state = $$LVIS_SELECTED
				lvi.stateMask = $$LVIS_SELECTED
				SendMessageA (hLV, $$LVM_SETITEMSTATE, idx, &lvi)
			ELSE
				' multiple selections
				' first, unselect everything
				lvi.state = ~$$LVIS_SELECTED
				lvi.stateMask = $$LVIS_SELECTED
				SendMessageA (hLV, $$LVM_SETITEMSTATE, -1, &lvi)
				'
				upp = UBOUND (indexList[])
				FOR i = 0 TO upp
					IF indexList[i] < 0 THEN DO NEXT
					IF indexList[i] >= count THEN DO NEXT
					'
					lvi.state = $$LVIS_SELECTED
					lvi.stateMask = $$LVIS_SELECTED
					SendMessageA (hLV, $$LVM_SETITEMSTATE, indexList[i], &lvi)
				NEXT i
			ENDIF

			SetFocus (hLV)
			bOK = $$TRUE

	END SELECT

	RETURN bOK

END FUNCTION
'
' ##################################
' #####  WinXListView_SetView  #####
' ##################################
' Sets the view of a listview control
' hLV = the handle to the control
' view = the view to set
' returns bOK: $$TRUE on success
FUNCTION WinXListView_SetView (hLV, view)
	IF hLV THEN
		style = GetWindowLongA (hLV, $$GWL_STYLE)
		style = (style AND NOT($$LVS_ICON|$$LVS_SMALLICON|$$LVS_LIST|$$LVS_REPORT)) OR view
		SetWindowLongA (hLV, $$GWL_STYLE, style)
	ENDIF
END FUNCTION
'
' ###############################
' #####  WinXListView_Sort  #####
' ###############################
' Sorts the items in a list view control
' hLV = the list view control to sort
' iCol = the zero-based index of the column to sort by
' decreasing = $$TRUE to sort descending instead of ascending
' returns bOK: $$TRUE on success
FUNCTION WinXListView_Sort (hLV, iCol, decreasing)
	SHARED #lvs_column_index
	SHARED #lvs_decreasing

	SetLastError (0)
	IF hLV THEN
		#lvs_column_index = iCol
		IF decreasing THEN
			#lvs_decreasing = $$TRUE
		ELSE
			#lvs_decreasing = $$FALSE
		ENDIF
		ret = SendMessageA (hLV, $$LVM_SORTITEMSEX, hLV, &CompareLVItems())
		IF ret THEN
			RETURN $$TRUE		' success
		ENDIF
	ENDIF

END FUNCTION
'
' #############################
' #####  WinXMenu_Attach  #####
' #############################
' Attach a sub menu to another menu
' subMenu = the sub menu to attach
' newParent = the new parent menu
' idMenu = the id to attach to
' returns bOK: $$TRUE on success
FUNCTION WinXMenu_Attach (subMenu, newParent, idMenu)
	MENUITEMINFO	mii

	SetLastError (0)

	SELECT CASE TRUE
		CASE subMenu = 0
		CASE newParent <> 0
			mii.fMask = $$MIIM_SUBMENU
			mii.hSubMenu = subMenu
			mii.cbSize = SIZE (MENUITEMINFO)

			' attach sub-menu idMenu to menu newParent
			ret = SetMenuItemInfoA (newParent, idMenu, 0, &mii)
			IF ret THEN RETURN $$TRUE		' success

	END SELECT

END FUNCTION
'
' ########################
' #####  WinXNewACL  #####
' ########################
' Creates a security attributes structure
' ssd$ = a string describing the ACL, 0 for null
' inherit = $$TRUE if these attributes can be inherited, otherwise $$FALSE
' returns the SECURITY_ATTRIBUTES structure
FUNCTION SECURITY_ATTRIBUTES WinXNewACL (ssd$, inherit)
	SECURITY_ATTRIBUTES ret

	ret.length = SIZE (SECURITY_ATTRIBUTES)
	IF inherit THEN ret.inherit = 1

	IF ssd$ THEN
' 0.6.0.2-old---
'		ConvertStringSecurityDescriptorToSecurityDescriptorA (&ssd$, $$SDDL_REVISION_1, &ret.securityDescriptor, 0)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
		funcName$ = "ConvertStringSecurityDescriptorToSecurityDescriptorA"
		dllName$ = "advapi32.dec"
		DIM args[3]
		args[0] = &ssd$
		args[1] = $$SDDL_REVISION_1
		args[2] = &ret.securityDescriptor
		args[3] = 0
		XstCall (funcName$, dllName$, @args[])
' 0.6.0.2-new~~~
	ENDIF

	RETURN ret

END FUNCTION
'
' ####################################
' #####  WinXNewAutoSizerSeries  #####
' ####################################
' Adds a new auto sizer series
' direction = $$DIR_VERT or $$DIR_HORIZ
' returns the handle of the new auto sizer series
FUNCTION WinXNewAutoSizerSeries (direction)
	RETURN autoSizerGroup_add (direction)
END FUNCTION
'
' ################################
' #####  WinXNewChildWindow  #####
' ################################
' Creates a new control
FUNCTION WinXNewChildWindow (hParent, title$, style, exStyle, idCtr)
	SHARED		hInst
	BINDING binding
	LINKEDLIST autoDrawList

	SetLastError (0)
	IFZ hInst THEN
		hInst = GetModuleHandleA (0)		' Unlikely!
	ENDIF

	hWnd = NewChild ($$MAIN_CLASS$, title$, style, 0, 0, 0, 0, hParent, idCtr, exStyle)

	'make a binding
	binding.hWnd = hWnd
	style = $$WS_POPUP|$$TTS_NOPREFIX|$$TTS_ALWAYSTIP
	binding.hToolTips = CreateWindowExA (0, &"tooltips_class32", 0, style, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, hWnd, 0, hInst, 0)

	binding.msgHandlers = handlerGroup_add ()
	LinkedList_Init (@autoDrawList)
	binding.autoDrawInfo = LINKEDLIST_New (autoDrawList)
	binding.autoSizerInfo = autoSizerGroup_add ($$DIR_VERT)		' index

	SetWindowLongA (hWnd, $$GWL_USERDATA, binding_add (binding))

	'and we're done!
	RETURN hWnd

END FUNCTION
'
' #########################
' #####  WinXNewFont  #####
' #########################
'
' Creates a logical font.
'
' fontName$  = name of the font
' pointSize  = size of the font in points
' weight     = weight of the font as $$FW_THIN,...
' bItalic    = $$TRUE for italic characters
' bUnderL    = $$TRUE for underlined characters
' bStrike    = $$TRUE for striken-out characters
'
' returns the handle to the new font or 0 on fail.
'
FUNCTION WinXNewFont (fontName$, pointSize, weight, bItalic, bUnderL, bStrike)
	LOGFONT logFont

	SetLastError (0)
	r_hFont = 0

	' check fontName$ not empty
	fontName$ = TRIM$ (fontName$)
	IFZ fontName$ THEN
		msg$ = "WinXNewFont: empty font face"
		GuiAlert (msg$, "")
		RETURN		' fail
	ENDIF

	' hFontToClone provides with a well-formed font structure
	SetLastError (0)
	hFontToClone = GetStockObject ($$DEFAULT_GUI_FONT)		' get a font to clone
	IFZ hFontToClone THEN
		msg$ = "GetStockObject: Can't get a font to clone"
		GuiTellApiError (msg$)
		RETURN		' invalid handle
	ENDIF

	bytes = 0		' number of bytes stored into the buffer
	bErr = $$FALSE
	SetLastError (0)
	bytes = GetObjectA (hFontToClone, SIZE (LOGFONT), &logFont)		' fill allocated structure logFont
	IF bytes <= 0 THEN
		msg$ = "GetObjectA: Can't fill allocated structure logFont"
		GuiTellApiError (msg$)
		RETURN
	ENDIF

	' release the cloned font
	DeleteObject (hFontToClone) : hFontToClone = 0		' free memory space

	' set the cloned font structure with the passed parameters
	logFont.faceName = fontName$

	IFZ pointSize THEN
		logFont.height = 0
	ELSE
		' character height is specified (in points)
		pointH = pointSize
		IF pointH < 0 THEN pointH = -pointH		' make it positive
		'
		' convert pointSize to pixels
		SetLastError (0)
		hdc = GetDC ($$HWND_DESKTOP)		' get a handle to the desktop context
		IFZ hdc THEN
			msg$ = "GetDC: Can't get a handle to the desktop context"
			bErr = GuiTellApiError (msg$)
			IF bErr THEN RETURN		' invalid handle
		ENDIF
		'
		' Windows expects the font height to be in pixels and negative
		logFont.height = MulDiv (pointH, GetDeviceCaps (hdc, $$LOGPIXELSY), -72)
		ReleaseDC ($$HWND_DESKTOP, hdc)		' release the handle to the desktop context
	ENDIF

	SELECT CASE weight
		CASE $$FW_THIN, $$FW_EXTRALIGHT, $$FW_LIGHT, $$FW_NORMAL, $$FW_MEDIUM, _
		     $$FW_SEMIBOLD, $$FW_BOLD, $$FW_EXTRABOLD, $$FW_HEAVY, $$FW_DONTCARE
			logFont.weight = weight
		CASE ELSE
			logFont.weight = $$FW_NORMAL
	END SELECT

	IF bItalic THEN logFont.italic = 1    ELSE logFont.italic = 0
	IF bUnderL THEN logFont.underline = 1 ELSE logFont.underline = 0
	IF bStrike THEN logFont.strikeOut = 1 ELSE logFont.strikeOut = 0

	SetLastError (0)
	r_hFont = CreateFontIndirectA (&logFont)		' create logical font r_hFont
	IFZ r_hFont THEN
		msg$ = "CreateFontIndirectA: Can't create logical font r_hFont"
		GuiTellApiError (msg$)
	ENDIF

	RETURN r_hFont

END FUNCTION
'
' #########################
' #####  WinXNewMenu  #####
' #########################
' Generates a new menu
' menuList$ = a string representing the menu.  Items are seperated by commas,
'  two commas in a row indicate a separator.  Use & to specify hotkeys and && for &.
' firstID = the id of the first item, the other ids are assigned sequentially
' isPopup = $$TRUE if this is a popup menu else $$FALSE
' returns a handle to the menu or 0 on fail
FUNCTION WinXNewMenu (menuList$, firstID, isPopup)
	'parse the string
' 0.6.0.2-old---
'	XstParseStringToStringArray (menuList$, ",", @items$[])
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	SetLastError (0)
	r_hMenu = 0

	menuList$ = TRIM$ (menuList$)
	IFZ menuList$ THEN menuList$ = "(empty)"
'
' Extract the comma separated values from menuList$
' and place each of them in itemList$[].
'
	IFZ INSTR (menuList$, ",") THEN
		' no comma => singleton
		DIM itemList$[0]
		itemList$[0] = menuList$
	ELSE
		' one or more commas => parse the comma-separated list
		errNum = ERROR ($$FALSE)
		bErr = XstParseStringToStringArray (menuList$, ",", @itemList$[])
		IF bErr THEN
			msg$ = "WinXNewMenu: Can't parse CSV line " + menuList$
			GuiTellRunError (msg$)
			RETURN 0		' fail
		ENDIF
	ENDIF
' 0.6.0.2-new~~~

	msg$ = "WinXNewMenu: Can't create "
	IF isPopup THEN
		msg$ = msg$ + "popup menu"
		r_hMenu = CreatePopupMenu ()
	ELSE
		msg$ = msg$ + "dropdown menu"
		r_hMenu = CreateMenu ()
	ENDIF
	IFZ r_hMenu THEN
		GuiTellApiError (msg$)
		msg$ = "WinXNewMenu: Can't create the sub-menu"
		RETURN 0		' fail
	ENDIF

	'now write the menu items
	idMenu = firstID

	upp = UBOUND (itemList$[])
	FOR i = 0 TO upp
		IFZ TRIM$ (itemList$[i]) THEN
			AppendMenuA (r_hMenu, $$MF_SEPARATOR, 0, 0)		' separator
		ELSE
			SetLastError (0)
			ret = AppendMenuA (r_hMenu, $$MF_STRING|$$MF_ENABLED, idMenu, &itemList$[i])		' menu option
			IFZ ret THEN
				msg$ = "WinXNewMenu: Can't add menu option" + STR$ (idMenu) + " " + itemList$[i]
				GuiTellApiError (msg$)
			ENDIF
			INC idMenu
		ENDIF
	NEXT i

	RETURN r_hMenu

END FUNCTION
'
' ############################
' #####  WinXNewToolbar  #####
' ############################
'
' Generates a new toolbar.
'
' wButton     : The width of a button image in pixels
' hButton     : the height of a button image in pixels
' nButtons    : the number of buttons images
' hBmpButtons : a handle to the bitmap containing the button images
' hBmpDis     : the appearance of the buttons when disabled or 0 for default
' hBmpHot     : the appearance of the buttons when the mouse is over them or 0 for default
' transparentRGB    : the color to use as transparent
' toolTips    : $$TRUE to enable tool tips, $$FALSE to disable them
'(customisable: $$TRUE if this toolbar can be customised.)
'  !!THIS FEATURE IS NOT IMPLEMENTED YET, USE $$FALSE FOR THIS PARAMETER!!
'
' returns the new toolbar handle or 0 on fail.
'
' Usage:
' load the 3 image lists
' hBmpButtons = LoadBitmapA (hInst, "toolbarImg")       ' normal
' hBmpHot     = LoadBitmapA (hInst, &"toolbarHotImg")   ' hot
' hBmpDis     = LoadBitmapA (hInst, &"toolbarGrayImg")  ' gray
' returns the handle to the toolbar.
'
' transparentRGB = RGB (255, 0, 255) ' color code for transparency
'
' #tbrMain = WinXNewToolbar (16, 16, 9, hBmpButtons, hBmpDis, hBmpHot, transparentRGB, $$TRUE, $$FALSE)
'
FUNCTION WinXNewToolbar (wButton, hButton, nButtons, hBmpButtons, hBmpDis, hBmpHot, transparentRGB, toolTips, customisable)
	BITMAP bitMap

	SetLastError (0)

	IFZ hBmpButtons THEN
		msg$ = "WinXNewToolbar: Ignore a NULL bitmap handle"
		GuiAlert (msg$, "")
		RETURN
	ENDIF

	hToolbar = 0

	' GL-some argument checking...
	IF nButtons <= 0 THEN nButtons = 1

	' bmpWidth = wButton*nButtons
	ret = GetObjectA (hBmpButtons, SIZE (BITMAP), &bitMap)		' get bitmap's sizes
	SELECT CASE ret
		CASE 0
			IF hButton <= 16 THEN
				hButton = 16
				wButton = 16
			ELSE
				IF hButton <= 24 THEN
					hButton = 24
					wButton = 24
				ELSE
					hButton = 32
					wButton = 32
				ENDIF
			ENDIF
			'
		CASE ELSE
			' save bitmap size for later use
			bmpWidth  = bitMap.width
			bmpHeight = bitMap.height
			'
			SELECT CASE TRUE
				CASE bmpHeight <= (16+4)
					hButton = 16
					wButton = 16

				CASE bmpHeight <= (24+4)
					hButton = 24
					wButton = 24

				CASE ELSE
					hButton = 32
					wButton = 32

			END SELECT
			'
			' make image lists
			flags = $$ILC_COLOR24|$$ILC_MASK
			hilNor = ImageList_Create (wButton, bmpHeight, flags, nButtons, 0)
			hilDis = ImageList_Create (wButton, bmpHeight, flags, nButtons, 0)
			hilHot = ImageList_Create (wButton, bmpHeight, flags, nButtons, 0)
			'
			' make 2 memory DCs for image manipulations
			hDC = GetDC (GetDesktopWindow ())
			hMem = CreateCompatibleDC (hDC)
			hSource = CreateCompatibleDC (hDC)
			ReleaseDC (GetDesktopWindow (), hDC)
			'
			' make a mask for the normal buttons
			hblankS = SelectObject (hSource, hBmpButtons)
			hBmpMask = CreateCompatibleBitmap (hSource, bmpWidth, bmpHeight)
			hblankM = SelectObject (hMem, hBmpMask)
			BitBlt (hMem, 0, 0, bmpWidth, bmpHeight, hSource, 0, 0, $$SRCCOPY)
			'
			GOSUB makeMask
			'
			hBmpButtons = SelectObject (hSource, hblankS)
			hBmpMask = SelectObject (hMem, hblankM)
			'
			' Add to image list
			ImageList_Add (hilNor, hBmpButtons, hBmpMask)
			'
			' now let's do the gray buttons
			IF hBmpDis THEN
				' generate a mask
				hblankS = SelectObject (hSource, hBmpDis)
				hblankM = SelectObject (hMem, hBmpMask)
				BitBlt (hMem, 0, 0, bmpWidth, bmpHeight, hSource, 0, 0, $$SRCCOPY)
				GOSUB makeMask
			ELSE
				' generate hBmpDis
				hblankS = SelectObject (hSource, hBmpMask)
				hBmpDis = CreateCompatibleBitmap (hSource, bmpWidth, bmpHeight)
				hblankM = SelectObject (hMem, hBmpDis)
				'
				upper_x = bmpWidth - 1
				upper_y = bmpHeight - 1
				FOR y = 0 TO upper_y
					FOR x = 0 TO upper_x
						col = GetPixel (hSource, x, y)
						'IF col = 0x00000000 THEN SetPixel (hMem, x, y, 0x00808080)
						IFZ col THEN SetPixel (hMem, x, y, $$MediumGrey)
					NEXT x
				NEXT y
			ENDIF
			'
			SelectObject (hSource, hblankS)
			SelectObject (hMem, hblankM)
			ImageList_Add (hilDis, hBmpDis, hBmpMask)
			'
			' and finaly, the hot buttons
			IF hBmpHot THEN
				' generate a mask
				hblankS = SelectObject (hSource, hBmpHot)
				hblankM = SelectObject (hMem, hBmpMask)
				BitBlt (hMem, 0, 0, bmpWidth, bmpHeight, hSource, 0, 0, $$SRCCOPY)
				GOSUB makeMask
			ELSE
				' generate a brighter version of hBmpButtons
				' hBmpHot = hBmpButtons
				hblankS = SelectObject (hSource, hBmpButtons)
				'
				' hBmpHot = CopyImage (hBmpButtons, $$IMAGE_BITMAP, bmpWidth, bmpHeight, 0)
				hBmpHot = CreateCompatibleBitmap (hSource, bmpWidth, bmpHeight)
				hblankM = SelectObject (hMem, hBmpHot)
				'
				upper_x = bmpWidth - 1
				upper_y = bmpHeight - 1
				FOR y = 0 TO upper_y
					FOR x = 0 TO upper_x
						col = GetPixel (hSource, x, y)
						'
						red = (col & 0xFF)
						IF red < 215 THEN red = red + 40		'red+((0xFF-red)\3)
						'
						green = (col & 0xFF00) >> 8
						IF green < 215 THEN green = green + 40		'green+((0xFF-green)\3)
						'
						blue = (col & 0xFF0000) >> 16
						IF blue < 215 THEN blue = blue + 40		'blue+((0xFF-blue)\3)
						'
						color = red | (green << 8) | (blue << 16)
						SetPixel (hMem, x, y, color)
					NEXT x
				NEXT y
			ENDIF
			'
			SelectObject (hSource, hblankS)
			SelectObject (hMem, hblankM)
			'
			ImageList_Add (hilHot, hBmpHot, hBmpMask)
			'
			' ok, now clean up
			DeleteDC (hMem) : hMem = 0
			DeleteDC (hSource) : hSource = 0
			'
			' delete the bitmap handles they are no longer need
			IF hBmpButtons THEN
				DeleteObject (hBmpButtons) : hBmpButtons = 0
			ENDIF
			IF hBmpDis THEN
				DeleteObject (hBmpDis) : hBmpDis = 0
			ENDIF
			IF hBmpHot THEN
				DeleteObject (hBmpHot) : hBmpHot = 0
			ENDIF
			'
			' and make the toolbar
			hToolbar = WinXNewToolbarUsingIls (hilNor, hilDis, hilHot, toolTips, customisable)
			'
			' GL-28mar16-set the ToolBar bitmap size
			SendMessageA (hToolbar, $$TB_SETBITMAPSIZE, 0, MAKELONG (wButton, hButton))
			'
	END SELECT

	' return a handle to the toolbar
	RETURN hToolbar

	SUB makeMask
		IFZ hMem THEN EXIT SUB

		upper_x = bmpWidth - 1
		upper_y = bmpHeight - 1
		FOR y = 0 TO upper_y
			FOR x = 0 TO upper_x
				col = GetPixel (hSource, x, y)		' get source's pixel
				IF col = transparentRGB THEN
					' transparency
					pixelRGB = $$White
					SetPixel (hSource, x, y, pixelRGB)		' reset source's pixel
				ELSE
					pixelRGB = $$Black
				ENDIF
				' set target's pixel
				SetPixel (hMem, x, y, pixelRGB)
			NEXT x
		NEXT y
	END SUB
END FUNCTION
'
' ####################################
' #####  WinXNewToolbarUsingIls  #####
' ####################################
' Make a new toolbar using the specified image lists
' hilNor       = image list for the buttons
' hilDis       = images to be displayed when the buttons are disabled
' hilHot       = images to be displayed on mouse over
' toolTips     = $$TRUE to enable tooltips control
' customisable = $$TRUE to enable customisation
' returns the new toolbar handle or 0 on fail.
FUNCTION WinXNewToolbarUsingIls (hilNor, hilDis, hilHot, toolTips, customisable)
	SHARED hInst		' instance handle

	IFZ hInst THEN
		hInst = GetModuleHandleA (0)		' Unlikely!
	ENDIF
	SetLastError (0)
'
' style
' $$TBSTYLE_FLAT     : Flat toolbar
' $$TBSTYLE_LIST     : bitmap+text
' $$TBSTYLE_TOOLTIPS : Add tooltips
'
	style = $$TBSTYLE_FLAT|$$TBSTYLE_LIST
	IF toolTips THEN
		style = style|$$TBSTYLE_TOOLTIPS
	ENDIF
'
' 0.6.0.2-old---
'	IF customisable THEN
'		style = style|$$CCS_ADJUSTABLE
'		SetPropA (hToolbar, &"customisationData", tbbd_addGroup ())
'	ELSE
'		SetPropA (hToolbar, &"customisationData", -1)
'	ENDIF
' 0.6.0.2-old~~~
'
	SetLastError (0)
	hToolbar = CreateWindowExA (0, &"ToolbarWindow32", 0, style, 0, 0, 0, 0, 0, 0, hInst, 0)
	IFZ hToolbar THEN
		msg$ = "WinXNewToolbarUsingIls: Can't create toolbar hToolbar"
		GuiTellApiError (msg$)
	ELSE
		' use the more modern features of new Common Controls Library
		exStyle = $$TBSTYLE_EX_MIXEDBUTTONS|$$TBSTYLE_EX_DOUBLEBUFFER|$$TBSTYLE_EX_DRAWDDARROWS
		SendMessageA (hToolbar, $$TB_SETEXTENDEDSTYLE, 0, exStyle)

		' add the ImageLists to the ToolBar
		SendMessageA (hToolbar, $$TB_SETIMAGELIST, 0, hilNor)		        ' Normal
		SendMessageA (hToolbar, $$TB_SETHOTIMAGELIST, 0, hilHot)		      ' Hot Selected
		SendMessageA (hToolbar, $$TB_SETDISABLEDIMAGELIST, 0, hilDis)		' Disabled

		'set the ToolBar Buttons
		SendMessageA (hToolbar, $$TB_BUTTONSTRUCTSIZE, SIZE (TBBUTTON), 0)

		RETURN hToolbar
	ENDIF

END FUNCTION
'
' ###########################
' #####  WinXNewWindow  #####
' ###########################
'	/*
'	[WinXNewWindow]
' Description = create a new window
' Function    = hWnd = WinXNewWindow (hOwner, title$, x, y, w, h, simpleStyle, exStyle, icon, menu)
' ArgCount    = 9
' Arg1				= hOwner : The parent of the new window
' Arg2				= title$ : The title for the new window
' Arg3				= x : the x position for the new window, -1 for centre
' Arg4				= y : the y position for the new window, -1 for centre
' Arg5				= w : the width of the client area of the new window
' Arg6				= h : the height of the client area of the new window
' Arg7				= simpleStyle : a simple style constant
' Arg8				= exStyle : an extended window style, look up CreateWindowEx in the win32 developer's guide for a list of extended styles
' Arg9				= hIcon : the handle to the hIcon for the window, 0 for default
' Arg10			= menu : the handle to the menu for the window, 0 for no menu
'	Return      = The handle to the new window or 0 on fail
' Remarks     = Simple style constants:<dl>\n
'<dt>$$XWSS_APP</dt><dd>A standard window</dd>\n
'<dt>$$XWSS_APPNORESIZE</dt><dd>Same as the standard window, but cannot be resized or maximised</dd>\n
'<dt>$$XWSS_POPUP</dt><dd>A popup window, cannot be minimised</dd>\n
'<dt>$$XWSS_POPUPNOTITLE</dt><dd>A popup window with no title bar</dd>\n
'<dt>$$XWSS_NOBORDER</dt><dd>A window with no border, useful for full screen apps</dd></dl>
'	See Also    =
'	Examples    = 'Make a simple window<br/>\n
' WinXNewWindow (0, "My window", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)
'	*/
FUNCTION WinXNewWindow (hOwner, title$, x, y, w, h, simpleStyle, exStyle, hIcon, menu)
	SHARED		hInst
	SHARED hWinXIcon		' WinX's application icon

	BINDING binding
	RECT	rect
	LINKEDLIST autoDrawList
'
' 0.6.0.2-new+++
	SetLastError (0)
	IFZ hInst THEN
		hInst = GetModuleHandleA (0)
	ENDIF
' 0.6.0.2-new~~~
'
	rect.right = w
	rect.bottom = h

	style = XWSStoWS(simpleStyle)
'
' 0.6.0.2-old---
'	IF menu THEN fMenu = 1 ELSE fMenu = 0
'	AdjustWindowRectEx (&rect, style, fMenu, exStyle)
' 0.6.0.2-old~~~
'
	IF x < 0 THEN
		' center the window
		SetLastError (0)
		screenWidth = GetSystemMetrics ($$SM_CXSCREEN)
		x = (screenWidth - (rect.right-rect.left))/2
	ENDIF

	IF y < 0 THEN
		SetLastError (0)
		screenHeight = GetSystemMetrics ($$SM_CYSCREEN)
		y = (screenHeight - (rect.bottom-rect.top))/2
	ENDIF

	SetLastError (0)
	window_handle = NewWindow ($$MAIN_CLASS$, title$, style, x, y, w, h, exStyle)
' 0.6.0.2-new+++
	IFZ window_handle THEN
		msg$ = "WinXNewWindow: Can't create the window, window class " + $$MAIN_CLASS$
		GuiTellApiError (msg$)
		RETURN 0		' fail
	ENDIF
' 0.6.0.2-new~~~

	'now add the icon
	IFZ hIcon THEN
		'use WinX's icon when a passed hIcon is NULL
		hIcon = hWinXIcon
	ENDIF
	IF hIcon THEN
		SendMessageA (hWindow, $$WM_SETICON, $$ICON_BIG, hIcon)
		SendMessageA (hWindow, $$WM_SETICON, $$ICON_SMALL, hIcon)
	ENDIF

	DIM arr[1]
	arr[0] = $$ICON_BIG
	arr[1] = $$ICON_SMALL
	FOR i = 0 TO 1
		SetLastError (0)
		ret = SendMessageA (window_handle, $$WM_SETICON, arr[i], hIcon)
		IFZ ret THEN
			msg$ = "WinXNewWindow: Can't set the window icon"
			GuiTellApiError (msg$)
		ENDIF
	NEXT i

	IF menu THEN
		SetLastError (0)
		ret = SetMenu (window_handle, menu)		' activate the menubar
		IFZ ret THEN
			msg$ = "WinXNewWindow: Can't activate the menubar"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF
' 0.6.0.2-new~~~

	'make a binding
	binding.hWnd = window_handle
	dwStyle = $$WS_POPUP|$$TTS_NOPREFIX|$$TTS_ALWAYSTIP
	binding.hToolTips = CreateWindowExA(0, &"tooltips_class32", 0, dwStyle, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, window_handle, 0, hInst, 0)

	'allocate the binding
	binding.msgHandlers = handlerGroup_add ()
	LinkedList_Init (@autoDrawList)
	binding.autoDrawInfo = LINKEDLIST_New (autoDrawList)

	binding.autoSizerInfo = autoSizerGroup_add ($$DIR_VERT)		'create the main series (vertical)

	'store the binding id in class data area
' 0.6.0.2-old---
'	SetWindowLongA (window_handle, $$GWL_USERDATA, binding_add(binding))
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	idBinding = binding_add (binding)
	IF idBinding > 0 THEN
		SetWindowLongA (window_handle, $$GWL_USERDATA, idBinding)
	ELSE
		msg$ = "WinXNewWindow: Can't add binding to the new window"
		GuiAlert (msg$, "WinX-Internal Error")
	ENDIF
' 0.6.0.2-new~~~

	'and we're done!
	RETURN window_handle

END FUNCTION
'
' #######################################
' #####  WinXPrint_DevUnitsPerInch  #####
' #######################################
' Computes the number of device units in an inch
' w, h = variables to store the width and height
' returns bOK: $$TRUE on success
FUNCTION WinXPrint_DevUnitsPerInch (hPrinter, @w, @h)

	SetLastError (0)
	w = 0
	h = 0
	IF hPrinter THEN
		w = GetDeviceCaps (hPrinter, $$LOGPIXELSX)
		IF w THEN
			SetLastError (0)
			h = GetDeviceCaps (hPrinter, $$LOGPIXELSY)
			IF h THEN RETURN $$TRUE		' success
		ENDIF
	ENDIF

END FUNCTION
'
' ############################
' #####  WinXPrint_Done  #####
' ############################
' Finishes printing
' hPrinter =  the handle to the printer
' returns bOK: $$TRUE on success
FUNCTION WinXPrint_Done (hPrinter)
	SHARED	PRINTINFO	printInfo

	SetLastError (0)
	IF hPrinter THEN
		EndDoc (hPrinter)
		DeleteDC (hPrinter)
		DestroyWindow (printInfo.hCancelDlg)
		printInfo.continuePrinting = $$FALSE
		RETURN $$TRUE
	ENDIF
END FUNCTION
'
' ########################################
' #####  WinXPrint_LogUnitsPerPoint  #####
' ########################################
' Gets the conversion factor between logical units and points
FUNCTION DOUBLE WinXPrint_LogUnitsPerPoint (hPrinter, cyLog, cyPhys)

	DOUBLE convFactor

	SetLastError (0)
	convFactor = DOUBLE (GetDeviceCaps (hPrinter, $$LOGPIXELSY))
	convFactor = (convFactor * cyLog) / (72.0 * cyPhys)
	RETURN convFactor

END FUNCTION
'
' ############################
' #####  WinXPrint_Page  #####
' ############################
' Prints a single page
' hPrinter = the handle to the printer
' hWnd = the handle to the window to print
' x, y, cxLog, cyLog = the coordinates, width and height of the rectangle on the window to print
' cxPhys, cyPhys = the width and height of that rectangle in printer units
' returns bOK: $$TRUE on success
FUNCTION WinXPrint_Page (hPrinter, hWnd, x, y, cxLog, cyLog, cxPhys, cyPhys, pageNum, pageCount)
	SHARED	PRINTINFO	printInfo
	AUTODRAWRECORD	record
	BINDING			binding
	RECT rect

	SetLastError (0)
	IFZ hPrinter THEN RETURN $$FALSE

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	'get the clipping rect for the printer
	rect.left = (GetDeviceCaps (hPrinter, $$LOGPIXELSX)*printInfo.marginLeft)\1000
	rect.right = GetDeviceCaps(hPrinter, $$PHYSICALWIDTH) - (GetDeviceCaps (hPrinter, $$LOGPIXELSX)*printInfo.marginRight)\1000 + 1
	rect.top = (GetDeviceCaps (hPrinter, $$LOGPIXELSY)*printInfo.marginTop)\1000
	rect.bottom = GetDeviceCaps(hPrinter, $$PHYSICALHEIGHT) - (GetDeviceCaps (hPrinter, $$LOGPIXELSY)*printInfo.marginBottom)\1000 + 1

	'set up clipping
	hRgn = CreateRectRgnIndirect (&rect)
	SelectClipRgn (hPrinter, hRgn)
	DeleteObject (hRgn)

	'set up the scaling
	SetMapMode (hPrinter, $$MM_ANISOTROPIC)
	SetWindowOrgEx (hPrinter, 0, 0, 0)
	SetWindowExtEx (hPrinter, cxLog, cyLog, 0)
	SetViewportOrgEx (hPrinter, rect.left, rect.top, 0)
	SetViewportExtEx (hPrinter, cxPhys, cyPhys, 0)
	SetStretchBltMode (hPrinter, $$HALFTONE)

	'set the text in the cancel dialog
	WinXSetText (GetDlgItem (printInfo.hCancelDlg, $$DLGCANCEL_ST_PAGE), "Printing page "+STRING$(pageNum)+" of "+STRING$(pageCount)+"...")

	'play the auto drawer info into the printer
	StartPage (hPrinter)
	autoDraw_draw (hPrinter, binding.autoDrawInfo, x, y)
	IF EndPage (hPrinter) > 0 THEN
		RETURN $$TRUE
	ENDIF
END FUNCTION
'
' #################################
' #####  WinXPrint_PageSetup  #####
' #################################
' Displays a page setup dialog box to the User and updates the print parameters according to the result
' hOwner = the handle to the window that owns the dialog
' returns bOK: $$TRUE on success
FUNCTION WinXPrint_PageSetup (hOwner)
	SHARED	PRINTINFO	printInfo
	PAGESETUPDLG pageSetupDlg
	UBYTE localeInfo[3]

	SetLastError (0)
	pageSetupDlg.lStructSize = SIZE (PAGESETUPDLG)
	IF hOwner THEN
		pageSetupDlg.hwndOwner = hOwner
	ELSE
		pageSetupDlg.hwndOwner = GetActiveWindow()
	ENDIF
	pageSetupDlg.hDevMode = printInfo.hDevMode
	pageSetupDlg.hDevNames = printInfo.hDevNames
	pageSetupDlg.flags = $$PSD_DEFAULTMINMARGINS|$$PSD_MARGINS
	pageSetupDlg.rtMargin.left = printInfo.marginLeft
	pageSetupDlg.rtMargin.right = printInfo.marginRight
	pageSetupDlg.rtMargin.top = printInfo.marginTop
	pageSetupDlg.rtMargin.bottom = printInfo.marginBottom

	GetLocaleInfoA ($$LOCALE_USER_DEFAULT, $$LOCALE_IMEASURE, &localeInfo[], SIZE (localeInfo[]))
	IF (localeInfo[0] = '0') THEN
		'The User prefers the metric system, so convert the units
		pageSetupDlg.rtMargin.left = XLONG(DOUBLE(pageSetupDlg.rtMargin.left)*2.54)
		pageSetupDlg.rtMargin.right = XLONG(DOUBLE(pageSetupDlg.rtMargin.right)*2.54)
		pageSetupDlg.rtMargin.top = XLONG(DOUBLE(pageSetupDlg.rtMargin.top)*2.54)
		pageSetupDlg.rtMargin.bottom = XLONG(DOUBLE(pageSetupDlg.rtMargin.bottom)*2.54)
	ENDIF

	IF PageSetupDlgA (&pageSetupDlg) THEN
		printInfo.marginLeft = pageSetupDlg.rtMargin.left
		printInfo.marginRight = pageSetupDlg.rtMargin.right
		printInfo.marginTop = pageSetupDlg.rtMargin.top
		printInfo.marginBottom = pageSetupDlg.rtMargin.bottom
		IFZ printInfo.hDevMode THEN printInfo.hDevMode = pageSetupDlg.hDevMode
		IFZ printInfo.hDevNames THEN printInfo.hDevNames = pageSetupDlg.hDevNames
		IF pageSetupDlg.flags AND $$PSD_INHUNDREDTHSOFMILLIMETERS THEN
			printInfo.marginLeft = XLONG(DOUBLE(printInfo.marginLeft) / 2.54)
			printInfo.marginRight = XLONG(DOUBLE(printInfo.marginRight) / 2.54)
			printInfo.marginTop = XLONG(DOUBLE(printInfo.marginTop) / 2.54)
			printInfo.marginBottom = XLONG(DOUBLE(printInfo.marginBottom) / 2.54)
		ENDIF
		RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' #############################
' #####  WinXPrint_Start  #####
' #############################
' Optionally displays a print settings dialog box then starts printing.
' minPage = the minimum page the User can select
' maxPage = the maximum page the User can select
' rangeMin = the initial minimum page, 0 for selection.  The User may change this value
' rangeMax = the initial maximum page, -1 for all pages.  The User may change this value
' cxPhys = the number of device pixels accross - the margins
' cyPhys = the number of device units vertically - the margins
' showDialog = $$TRUE to display a dialog or $$FALSE to use defaults
' hOwner = the handle to the window that owns the print settins dialog box or 0 for none
' returns the handle to the printer or 0 on fail
FUNCTION WinXPrint_Start (minPage, maxPage, @rangeMin, @rangeMax, @cxPhys, @cyPhys, fileName$, showDialog, hOwner)
	SHARED	PRINTINFO	printInfo
	PRINTDLG printDlg
	DOCINFO docInfo

	SetLastError (0)

	' First, get a DC
	IF showDialog THEN
		printDlg.lStructSize = SIZE (PRINTDLG)
		IF hOwner THEN
			printDlg.hwndOwner = hOwner
		ELSE
			printDlg.hwndOwner = GetActiveWindow()
		ENDIF
		printDlg.hDevMode = printInfo.hDevMode
		printDlg.hDevNames = printInfo.hDevNames
		printDlg.flags = printInfo.printSetupFlags|$$PD_RETURNDC|$$PD_USEDEVMODECOPIESANDCOLLATE
		IFZ rangeMin THEN
			printDlg.flags = printDlg.flags|$$PD_SELECTION
			printDlg.nFromPage = minPage
			printDlg.nToPage = maxPage
		ELSE
			printDlg.flags = printDlg.flags|$$PD_NOSELECTION
			IF rangeMax != -1 THEN
				printDlg.flags = printDlg.flags|$$PD_PAGENUMS
				printDlg.nFromPage = rangeMin
				printDlg.nToPage = rangeMax
			ELSE
				printDlg.nFromPage = minPage
				printDlg.nToPage = maxPage
			ENDIF
		ENDIF

		printDlg.nMinPage = minPage
		printDlg.nMaxPage = maxPage

		IF PrintDlgA (&printDlg) THEN
			IFZ printInfo.hDevMode THEN printInfo.hDevMode = printDlg.hDevMode
			IFZ printInfo.hDevNames THEN printInfo.hDevNames = printDlg.hDevNames
			printInfo.printSetupFlags = printDlg.flags
			IF printDlg.flags AND $$PD_PAGENUMS THEN
				rangeMin = printDlg.nFromPage	'range
				rangeMax = printDlg.nToPage
			ELSE
				IF printDlg.flags AND $$PD_SELECTION THEN
					rangeMin = 0	'selection
				ELSE
					rangeMax = -1	'all pages
				ENDIF
			ENDIF
			hDC = printDlg.hdc
		ELSE
			RETURN 0
		ENDIF
	ELSE
		IFZ printInfo.hDevMode THEN
			' Get a DEVMODE structure for the default printer in the default configuration
			printDlg.lStructSize = SIZE (PRINTDLG)
			printDlg.hDevMode = 0
			printDlg.hDevNames = 0
			printDlg.flags = $$PD_USEDEVMODECOPIESANDCOLLATE|$$PD_RETURNDEFAULT
			PrintDlgA (&printDlg)
			printInfo.hDevMode = printDlg.hDevMode
			printInfo.hDevNames = printDlg.hDevNames
		ENDIF
		' We need a pointer the DEVMODE structure
		pDevMode = GlobalLock (printInfo.hDevMode)
		IF pDevMode THEN
			' Get the device name safely
			devName$ = NULL$ (32)
			FOR i = 0 TO 28 STEP 4
				ULONGAT (&devName$, i) = ULONGAT (pDevMode, i)
			NEXT i
			hDC = CreateDCA (0, &devName$, 0, pDevMode)
		ENDIF
		GlobalUnlock (printInfo.hDevMode)

		IFZ hDC THEN RETURN 0
	ENDIF

	' OK, we have a DC.  Now let's get the physical sizes
	cxPhys = GetDeviceCaps(hDC, $$PHYSICALWIDTH) - (GetDeviceCaps (hDC, $$LOGPIXELSX)*(printInfo.marginLeft+printInfo.marginRight))\1000
	cyPhys = GetDeviceCaps(hDC, $$PHYSICALHEIGHT) - (GetDeviceCaps (hDC, $$LOGPIXELSY)*(printInfo.marginTop+printInfo.marginBottom))\1000

	' Sort out an abort proc
	printInfo.hCancelDlg = WinXNewWindow (0, "Printing "+fileName$, -1, -1, 300, 70, $$XWSS_POPUP, 0, 0, 0)
	MoveWindow (WinXAddStatic (printInfo.hCancelDlg, "Preparing to print", 0, $$SS_CENTER, $$DLGCANCEL_ST_PAGE), 0, 8, 300, 24, $$TRUE)
	MoveWindow (WinXAddButton (printInfo.hCancelDlg, "Cancel", 0, $$IDCANCEL), 110, 30, 80, 25, $$TRUE)
	WinXDisplay (printInfo.hCancelDlg)
	SetAbortProc (hDC, &printAbortProc ())
	printInfo.continuePrinting = $$TRUE

	' Now we can start the printing
	docInfo.size = SIZE (DOCINFO)
	docInfo.docName = &fileName$
	StartDocA (hDC, &docInfo)

	RETURN hDC
END FUNCTION
'
' #####################################
' #####  WinXProgress_SetMarquee  #####
' #####################################
' Enables or disables marquee mode
' hProg = the progress bar
' enable = $$TRUE to enable marquee mode, $$FALSE to disable
' returns bOK: $$TRUE on success
FUNCTION WinXProgress_SetMarquee (hProg, enable)

	SetLastError (0)
	IF hProg THEN
		styleOld = GetWindowLongA (hProg, $$GWL_STYLE)
		IF enable THEN
			style = styleOld|$$PBS_MARQUEE
			fEnable = 1
		ELSE
			style = styleOld & (NOT $$PBS_MARQUEE)
			fEnable = 0
		ENDIF
		SetWindowLongA (hProg, $$GWL_STYLE, style)
		SendMessageA (hProg, $$PBM_SETMARQUEE, fEnable, 50)
		RETURN $$TRUE
	ENDIF

END FUNCTION
'
' #################################
' #####  WinXProgress_SetPos  #####
' #################################
' Sets the position of a progress bar
' hProg = the handle to the progress bar
' pos = proportion of progress bar to shade
' returns bOK: $$TRUE on success
FUNCTION WinXProgress_SetPos (hProg, DOUBLE pos)
	SetLastError (0)
	IF hProg THEN
		SendMessageA (hProg, $$PBM_SETPOS, (1000.0*pos), 0)
		RETURN $$TRUE
	ENDIF
END FUNCTION
'
' #################################
' #####  WinXRegControlSizer  #####
' #################################
'	/*
'	[WinXRegControlSizer]
' Description = Registers a callback function to handle the sizing of controls
' Function    = WinXRegControlSizer (hWnd, FUNCADDR FnOnSize)
' ArgCount    = 2
'	Arg1        = hWnd : The window to register the callback for
' Arg2				= FnOnSize : The address of the callback function
'	Return      = $$TRUE on success or $$FALSE on error
' Remarks     = This function allows you to use your own control sizing code instead of the default \n
'WinX auto sizer.  You will have to resize all controls, including status bars and toolbars, if you use \n
'this callback.  The callback function has two XLONG parameters, w and h.
'	See Also    =
'	Examples    = WinXRegControlSizer (#hMain, &customSizer())
'	*/
FUNCTION WinXRegControlSizer (hWnd, FUNCADDR FnOnSize)
	BINDING			binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegControlSizer: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnSize THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegControlSizer: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.dimControls = FnOnSize
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegControlSizer: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ###################################
' #####  WinXRegMessageHandler  #####
' ###################################
'	/*
'	[WinXRegMessageHandler]
' Description = Registers a message handler callback function
' Function    = WinXRegMessageHandler (hWnd, wMsg, FUNCADDR FnMsgHandler)
' ArgCount    = 3
'	Arg1        = hWnd : The window to register the callback for
' Arg2				= wMsg : The message the callback processes
' Arg3				= FnMsgHandler : The address of the callback function
'	Return      = $$TRUE on success or $$FALSE on error
' Remarks     = This function is designed for developers who need custom processing of a windows message, \n
'for example, to use a custom control that sends custom messages. \n
'If you register a handler for a message WinX normally handles itself then the message handler is called \n
'first, then WinX performs the default behaviour. The callback function takes 4 XLONG parameters, hWnd, wMsg, \n
'wParam and lParam
'	See Also    =
'	Examples    = WinXRegMessageHandler (#hMain, $$WM_NOTIFY, &handleNotify())\n
' <br/>\n
' Note: mainWndProc expects FUNCTION FnMsgHandler (hWnd, wMsg, wParam, lParam)\n
' to return a non-zero value if it handled the message wMsg
'	*/
FUNCTION WinXRegMessageHandler (hWnd, wMsg, FUNCADDR FnMsgHandler)
	BINDING			binding
	MSGHANDLER	handler

	IF hWnd THEN
		IF wMsg THEN
			IF FnMsgHandler THEN
				'get the binding
				IF Get_binding (hWnd, @idBinding, @binding) THEN
					'prepare the handler
					handler.msg = wMsg
					handler.handler = FnMsgHandler		' (hWnd, wMsg, wParam, lParam)

					'and add it
					index = handlerInfo_add (binding.msgHandlers, handler)
					IF index >= 0 THEN RETURN $$TRUE		' success
				ENDIF
			ENDIF
		ENDIF
	ENDIF

END FUNCTION
'
' #####################################
' #####  WinXRegOnCalendarSelect  #####
' #####################################
' Set the onCalendarSelect callback
' hWnd = the handle to the window to set the callback for
' FnOnCalendarSelect = the address of the callback
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnCalendarSelect (hWnd, FUNCADDR FnOnCalendarSelect)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnCalendarSelect: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnCalendarSelect THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnCalendarSelect: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onCalendarSelect = FnOnCalendarSelect		' (idCtr, time)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnCalendarSelect: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ###########################
' #####  WinXRegOnChar  #####
' ###########################
' Registers the onChar callback function
' hWnd = the handle to the window to register the callback for
' FnOnChar = the address of the callback function
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnChar (hWnd, FUNCADDR FnOnChar)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnChar: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnChar THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnChar: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onChar = FnOnChar		' (hWnd, char)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnChar: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' #################################
' #####  WinXRegOnClipChange  #####
' #################################
' Registers a callback for when the clipboard changes
' hWnd = the handle to the window
' FnOnClipChange = the address of the callback
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnClipChange (hWnd, FUNCADDR FnOnClipChange)
	BINDING	binding

	IF hWnd THEN
		IF FnOnClipChange THEN
			'get the binding
			IF Get_binding (hWnd, @idBinding, @binding) THEN
				binding.onClipChange = FnOnClipChange
				RETURN binding_update (idBinding, binding)
			ENDIF
		ENDIF
	ENDIF
END FUNCTION
'
' ############################
' #####  WinXRegOnClose  #####
' ############################
' Registers the FnOnClose callback
FUNCTION WinXRegOnClose (hWnd, FUNCADDR FnOnClose)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnClose: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnClose THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnClose: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onClose = FnOnClose		' (hWnd)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnClose: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ##################################
' #####  WinXRegOnColumnClick  #####
' ##################################
' Registers the onColumnClick callback for a listview control
' hWnd = the window to register the callback for
' FnOnColumnClick = the address of the callback function
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnColumnClick (hWnd, FUNCADDR FnOnColumnClick)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnColumnClick: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnColumnClick THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnColumnClick: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onColumnClick = FnOnColumnClick		' (idCtr, iColumn)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnColumnClick: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ##############################
' #####  WinXRegOnCommand  #####
' ##############################
' Registers the FnOnCommand callback function
' hWnd = the window to register
' FnOnCommand = the function to process commands
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnCommand (hWnd, FUNCADDR FnOnCommand)
	BINDING			binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnCommand: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnCommand THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnCommand: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onCommand = FnOnCommand		' (idCtr, notifyCode, hCtr)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnCommand: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ###########################
' #####  WinXRegOnDrag  #####
' ###########################
' Register FnOnDrag
' hWnd = the window to register the callback for
' FnOnDrag = the address of the callback function
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnDrag (hWnd, FUNCADDR FnOnDrag)
	BINDING	binding

	IF hWnd THEN
		IF FnOnDrag THEN
			'get the binding
			IF Get_binding (hWnd, @idBinding, @binding) THEN
				binding.onDrag = FnOnDrag		' (idCtr, drag_const, drag_item, drag_x, drag_y)
				RETURN binding_update (idBinding, binding)
			ENDIF
		ENDIF
	ENDIF
END FUNCTION
'
' ################################
' #####  WinXRegOnDropFiles  #####
' ################################
' Registers the onDropFiles callback for a window
' hWnd = the window to register the callback for
' FnDropFiles = the address of the callback function
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnDropFiles (hWnd, FUNCADDR FnDropFiles)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnDropFiles: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnDropFiles THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnDropFiles: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onDropFiles = FnDropFiles		' (hWnd, x, y, @fileList$[])
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnDropFiles: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' #################################
' #####  WinXRegOnEnterLeave  #####
' #################################
' Registers the onEnterLeave callback
' hWnd = the handle to the window to register the callback for
' FnOnEnterLeave = the address of the callback function
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnEnterLeave (hWnd, FUNCADDR FnOnEnterLeave)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnEnterLeave: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnEnterLeave THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnEnterLeave: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onEnterLeave = FnOnEnterLeave		' (hWnd, mouseInWindow)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnEnterLeave: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ##################################
' #####  WinXRegOnFocusChange  #####
' ##################################
' Registers a callback for when the focus changes
' hWnd = the handle to the window
' FnOnFocusChange = the callback function
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnFocusChange (hWnd, FUNCADDR FnOnFocusChange)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnFocusChange: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnFocusChange THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnFocusChange: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onFocusChange = FnOnFocusChange		' (hWnd, hasFocus)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnFocusChange: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ###########################
' #####  WinXRegOnItem  #####
' ###########################
' Registers the onItem callback for a listview control
' hWnd = the window to register the message for
' FnOnItem = the address of the callback function
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnItem (hWnd, FUNCADDR FnOnItem)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnItem: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnItem THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnItem: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onItem = FnOnItem		' (idCtr, event, virtualKey)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnItem: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ##############################
' #####  WinXRegOnKeyDown  #####
' ##############################
' Registers the onKeyDown callback function
' hWnd = the handle to the window to register the callback for
' FnOnKeyDown = the address of the onKeyDown callback function
' returns bOK: $$TRUE on success
'
' Usage:
'	addrProc = &winAbout_OnKeyDown ()		' handles message WM_KEYDOWN
'	WinXRegOnKeyDown (#winAbout, addrProc)
'
FUNCTION WinXRegOnKeyDown (hWnd, FUNCADDR FnOnKeyDown)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnKeyDown: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnKeyDown THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnKeyDown: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onKeyDown = FnOnKeyDown		' (hWnd, VK)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnKeyDown: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ############################
' #####  WinXRegOnKeyUp  #####
' ############################
' Registers the onKeyUp callback function
' hWnd = the handle to the window to register the callback for
' FnOnKeyUp = the address of the callback function
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnKeyUp (hWnd, FUNCADDR FnOnKeyUp)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnKeyUp: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnKeyUp THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnKeyUp: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onKeyUp = FnOnKeyUp		' (hWnd, VK)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnKeyUp: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ################################
' #####  WinXRegOnLabelEdit  #####
' ################################
' Register the onLabelEdit callback
' hWnd = the window to register the callback for
' FnOnLabelEdit = the address of the callback function
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnLabelEdit (hWnd, FUNCADDR FnOnLabelEdit)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnLabelEdit: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnLabelEdit THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnLabelEdit: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onLabelEdit = FnOnLabelEdit		' (idCtr, edit_const, edit_item, newLabel$)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnLabelEdit: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ################################
' #####  WinXRegOnMouseDown  #####
' ################################
' Registers a callback for when the mouse is pressed
' hWnd = the handle to the window
' FnOnMouseDown = the function to call when the mouse is pressed
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnMouseDown (hWnd, FUNCADDR FnOnMouseDown)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnMouseDown: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnMouseDown THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnMouseDown: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onMouseDown = FnOnMouseDown		' (hWnd, VK)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnMouseDown: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ################################
' #####  WinXRegOnMouseMove  #####
' ################################
' Registers a callback for whne the mouse is moved
' hWnd = the handle to the window
' FnOnMouseMove = the function to call when the mouse moves
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnMouseMove (hWnd, FUNCADDR FnOnMouseMove)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnMouseMove: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnMouseMove THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnMouseMove: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onMouseMove = FnOnMouseMove		' (hWnd, x, y)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnMouseMove: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ##############################
' #####  WinXRegOnMouseUp  #####
' ##############################
' Registers a callback for when the mouse is released
' hWnd = the handle to the window
' FnOnMouseUp = the function to call when the mouse is released
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnMouseUp (hWnd, FUNCADDR FnOnMouseUp)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnMouseUp: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnMouseUp THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnMouseUp: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onMouseUp = FnOnMouseUp		' (hWnd, MBT_const, x, y)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnMouseUp: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' #################################
' #####  WinXRegOnMouseWheel  #####
' #################################
' Registers a callback for when the mouse wheel is rotated
' hWnd = the handle to the window
' FnOnMouseWheel = the function to call when the mouse wheel is rotated
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnMouseWheel (hWnd, FUNCADDR FnOnMouseWheel)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnMouseWheel: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnMouseWheel THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnMouseWheel: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onMouseWheel = FnOnMouseWheel		' (hWnd, delta, x, y)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnMouseWheel: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ############################
' #####  WinXRegOnPaint  #####
' ############################
'	/*
'	[WinXRegOnPaint]
' Description = Registers a callback function to process painting events
' Function    = WinXRegOnPaint (hWnd, FUNCADDR onPaint)
' ArgCount    = 2
'	Arg1        = hWnd : The handle to the window to register the callback for
' Arg2				= onPaint : The address of the function to use for the callback
'	Return      = $$TRUE on success or $$FALSE on error
' Remarks     = The callback function must take a single XLONG parameter called \n
'hdc, this parameter is the handle to the device context to draw on. \n
'If you register this callback, auto drawer is disabled.\n
'	See Also    =
'	Examples    = WinXRegOnPaint (#hMain, &onPaint())
'	*/
FUNCTION WinXRegOnPaint (hWnd, FUNCADDR FnOnPaint)
	BINDING binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnPaint: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnPaint THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnPaint: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.paint = FnOnPaint
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnPaint: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' #############################
' #####  WinXRegOnScroll  #####
' #############################
' Registers the onScroll callback
' hWnd = the handle to the window to register the callback for
' FnOnScroll = the address of the callback function
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnScroll (hWnd, FUNCADDR FnOnScroll)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnScroll: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnScroll THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnScroll: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onScroll = FnOnScroll		' (pos, hWnd, direction)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnScroll: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' #################################
' #####  WinXRegOnTrackerPos  #####
' #################################
' Registers the onTrackerPos callback
' hWnd = the handle of the window to register the callback for
' FnOnTrackerPos = the address of the callback function
' returns bOK: $$TRUE on success
FUNCTION WinXRegOnTrackerPos (hWnd, FUNCADDR FnOnTrackerPos)
	BINDING	binding

	bOK = $$FALSE

	IFZ hWnd THEN
		msg$ = "WinXRegOnTrackerPos: Window handle hWnd is null"
		GuiAlert (msg$, "")
	ELSE
		IF FnOnTrackerPos THEN
			'get the binding
			bOK = Get_binding (hWnd, @idBinding, @binding)
			IFF bOK THEN
				msg$ = "WinXRegOnTrackerPos: Can't get window's binding"
				GuiAlert (msg$, "")
			ELSE
				binding.onTrackerPos = FnOnTrackerPos		' (idCtr, pos)
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinXRegOnTrackerPos: Can't update window's binding"
					GuiAlert (msg$, "")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ##################################
' #####  WinXRegistry_ReadBin  #####
' ##################################
' Read binary data from the registry
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' createOnFail = $$TRUE to create the key if it doesn't exist.  Assigns result to the key
' sa = the security attributes for the key if it is created
' result$ = the binary data read from the registry
' returns bOK: $$TRUE on success
FUNCTION WinXRegistry_ReadBin (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		GOSUB QueryVariable
		RegCloseKey (hSubKey)
	ELSE
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition)
		IFZ zeroOK THEN		' (0 is for success)
			SELECT CASE disposition
				CASE $$REG_CREATED_NEW_KEY
					IF createOnOpenFail THEN
						zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &result$, LEN (result$))
						IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
					ENDIF
				CASE $$REG_OPENED_EXISTING_KEY
					GOSUB QueryVariable
			END SELECT
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN bOK
'
' Queries a value in the Registry.
' returns bOK.
'
	SUB QueryVariable
		zeroOK = RegQueryValueExA (hSubKey, &value$, 0, &type, 0, &cbSize)
		IFZ zeroOK THEN
			SELECT CASE type
				CASE $$REG_EXPAND_SZ, $$REG_SZ, $$REG_MULTI_SZ
					result$ = NULL$ (cbSize)
					zeroOK = RegQueryValueExA (hSubKey, &value$, 0, &type, &result$, &cbSize)
					IFZ zeroOK THEN bOK = $$TRUE
			END SELECT
		ELSE
			IF createOnOpenFail THEN
				zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_EXPAND_SZ, &result$, LEN (result$) + 1)
				IFZ zeroOK THEN bOK = $$TRUE
			ENDIF
		ENDIF
	END SUB
END FUNCTION
'
' ##################################
' #####  WinXRegistry_ReadInt  #####
' ##################################
' Reads an integer from the registry
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' createOnFail = $$TRUE to create the key if it doesn't exist.  Assigns result to the key
' sa = the security attributes for the key if it is created
' result = the integer read from the registry
' returns bOK: $$TRUE on success
FUNCTION WinXRegistry_ReadInt (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result)

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	four = 4

	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		zeroOK = RegQueryValueExA (hSubKey, &value$, 0, &type, &result, &four)
		IFZ zeroOK THEN		' (0 is for success)
			bOK = $$TRUE
		ELSE
			IF createOnOpenFail THEN
				zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &result, 4)
				IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
			ENDIF
		ENDIF
		RegCloseKey (hSubKey)
	ELSE
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition)
		IFZ zeroOK THEN		' (0 is for success)
			SELECT CASE disposition
				CASE $$REG_CREATED_NEW_KEY
					IF createOnOpenFail THEN
						zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &result, 4)
						IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
					ENDIF
				CASE $$REG_OPENED_EXISTING_KEY
					zeroOK = RegQueryValueExA (hSubKey, &value$, 0, &type, &result, &four)
					IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
			END SELECT
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' #####################################
' #####  WinXRegistry_ReadString  #####
' #####################################
' Reads a string from the registry
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' createOnFail = $$TRUE to create the key if it doesn't exist.  Assigns result to the key
' sa = the security attributes for the key if it is created
' result$ = the string read from the registry
' returns bOK: $$TRUE on success
FUNCTION WinXRegistry_ReadString (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	'IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		GOSUB QueryVariable
		RegCloseKey (hSubKey)
	ENDIF

	IFF bOK THEN
		'IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition)
		IFZ zeroOK THEN		' (0 is for success)
			SELECT CASE disposition
				CASE $$REG_OPENED_EXISTING_KEY
					GOSUB QueryVariable

				CASE $$REG_CREATED_NEW_KEY
					IF createOnOpenFail THEN
						zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_EXPAND_SZ, &result$, LEN (result$) + 1)
						IFZ zeroOK THEN bOK = $$TRUE
					ENDIF

			END SELECT
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN bOK
'
' Queries a value in the Registry.
' returns bOK.
'
	SUB QueryVariable
		zeroOK = RegQueryValueExA (hSubKey, &value$, 0, &type, 0, &cbSize)
		IFZ zeroOK THEN
			SELECT CASE type
				CASE $$REG_EXPAND_SZ, $$REG_SZ, $$REG_MULTI_SZ
					result$ = NULL$ (cbSize)
					zeroOK = RegQueryValueExA (hSubKey, &value$, 0, &type, &result$, &cbSize)
					IFZ zeroOK THEN bOK = $$TRUE
			END SELECT
		ELSE
			IF createOnOpenFail THEN
				zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_EXPAND_SZ, &result$, LEN (result$) + 1)
				IFZ zeroOK THEN bOK = $$TRUE
			ENDIF
		ENDIF
	END SUB
END FUNCTION
'
' ###################################
' #####  WinXRegistry_WriteBin  #####
' ###################################
' Writes binary data into the registry
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' createOnFail = $$TRUE to create the key if it doesn't exist.  Assigns result to the key
' sa = the security attributes for the key if it is created
' szBuf$ = the binary data to write into the registry
' returns bOK: $$TRUE on success
FUNCTION WinXRegistry_WriteBin (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, szBuf$)

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &szBuf$, LEN (szBuf$))
		IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
		RegCloseKey (hSubKey)
	ELSE
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition)
		IFZ zeroOK THEN		' (0 is for success)
			zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &szBuf$, LEN (szBuf$))
			IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ###################################
' #####  WinXRegistry_WriteInt  #####
' ###################################
' Writes an integer into the registry
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' sa = the security attributes for the key if it is created
' int = the integer to write into the registry
' returns bOK: $$TRUE on success
FUNCTION WinXRegistry_WriteInt (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, int)

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &int, 4)
		IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
		RegCloseKey (hSubKey)
	ELSE
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition)
		IFZ zeroOK THEN		' (0 is for success)
			zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &int, 4)
			IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ######################################
' #####  WinXRegistry_WriteString  #####
' ######################################
' Writes a string into the registry
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' createOnFail = $$TRUE to create the key if it doesn't exist.  Assigns result to the key
' sa = the security attributes for the key if it is created
' szBuf$ = the string to write into the registry
' returns bOK: $$TRUE on success
FUNCTION WinXRegistry_WriteString (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, szBuf$)

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_SZ, &szBuf$, LEN (szBuf$))
		IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
		RegCloseKey (hSubKey)
	ELSE
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition)
		IFZ zeroOK THEN		' (0 is for success)
			zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_SZ, &szBuf$, LEN (szBuf$))
			IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ###############################
' #####  WinXScroll_GetPos  #####
' ###############################
' Gets the scrolling position of a window
' hWnd = the handle to the window
' direction = the scrolling direction
' pos = the variable to store the scrolling position
' returns bOK: $$TRUE on success
FUNCTION WinXScroll_GetPos (hWnd, direction, @pos)
	SCROLLINFO si

	SetLastError (0)
	IF hWnd THEN
		typeBar = 0
		SELECT CASE direction AND 0x00000003
			CASE $$DIR_HORIZ : typeBar = $$SB_HORZ
			CASE $$DIR_VERT  : typeBar = $$SB_VERT
			CASE ELSE
				RETURN $$FALSE
		END SELECT
		IF typeBar THEN
			si.cbSize = SIZE (SCROLLINFO)
			si.fMask = $$SIF_POS
			GetScrollInfo (hWnd, typeBar, &si)
			pos = si.nPos
			RETURN $$TRUE		' success
		ENDIF
	ENDIF
END FUNCTION
'
' ###############################
' #####  WinXScroll_Scroll  #####
' ###############################
' hWnd = the handle to the window to scroll
' direction = the direction to scroll in
' unitType = the type of unit to scroll by
' scrollDirection = + to scroll up, - to scroll down
' returns bOK: $$TRUE on success
FUNCTION WinXScroll_Scroll (hWnd, direction, unitType, scrollingDirection)

	SetLastError (0)

	SELECT CASE unitType
		CASE $$UNIT_LINE
			IF scrollingDirection < 0 THEN wParam = $$SB_LINEUP ELSE wParam = $$SB_LINEDOWN
		CASE $$UNIT_PAGE
			IF scrollingDirection < 0 THEN wParam = $$SB_PAGEUP ELSE wParam = $$SB_PAGEDOWN
		CASE $$UNIT_END
			IF scrollingDirection < 0 THEN wParam = $$SB_TOP ELSE wParam = $$SB_BOTTOM
		CASE ELSE
			RETURN $$FALSE
	END SELECT

	wMsg = 0
	i = ABS (scrollingDirection)
	IF i THEN
		SELECT CASE direction
			CASE $$DIR_HORIZ : wMsg = $$WM_HSCROLL
			CASE $$DIR_VERT  : wMsg = $$WM_VSCROLL
		END SELECT
	ENDIF

	IF wMsg THEN
		' scroll i times
		FOR j = 1 TO i
			SendMessageA (hWnd, wMsg, wParam, 0)
		NEXT j
		RETURN $$TRUE
	ENDIF

END FUNCTION
'
' ################################
' #####  WinXScroll_SetPage  #####
' ################################
' Sets the page size mapping function
' hWnd = the handle to the window containing the scroll bar
' direction = the direction of the scrollbar to set the info for
' mul = the number to multiply the window width/height by to get the page width/height
' constant = the constant to add to the page width/height
' scrollUnit = the number of units to scroll by when the arrows are clicked
' returns bOK: $$TRUE on success
FUNCTION WinXScroll_SetPage (hWnd, direction, DOUBLE mul, constant, scrollUnit)
	BINDING	binding
	RECT rect
	SCROLLINFO si

	SetLastError (0)

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	SetLastError (0)
	ret = GetClientRect (hWnd, &rect)
	IFZ ret THEN
		msg$ = "WinXScroll_SetPage: Can't get the client rectangle of the window"
		GuiTellApiError (msg$)
		RETURN $$FALSE
	ENDIF

	si.cbSize = SIZE (SCROLLINFO)
	si.fMask = $$SIF_PAGE|$$SIF_DISABLENOSCROLL

	SELECT CASE direction AND 0x00000003		' GL?
		CASE $$DIR_HORIZ
			binding.hScrollPageM = mul
			binding.hScrollPageC = constant
			binding.hScrollUnit = scrollUnit
			typeBar = $$SB_HORZ

			si.nPage = (rect.right-rect.left)*mul + constant
		CASE $$DIR_VERT
			binding.vScrollPageM = mul
			binding.vScrollPageC = constant
			binding.vScrollUnit = scrollUnit
			typeBar = $$SB_VERT

			si.nPage = (rect.bottom-rect.top)*mul + constant
		CASE ELSE
			RETURN $$FALSE
	END SELECT

	binding_update (idBinding, binding)
	SetScrollInfo (hWnd, typeBar, &si, 1)

	RETURN $$TRUE

END FUNCTION
'
' ###############################
' #####  WinXScroll_SetPos  #####
' ###############################
' Sets the scrolling position of a window
' hWnd = the handle to the window
' direction = the scrolling direction
' pos = the new scrolling position
' returns bOK: $$TRUE on success
FUNCTION WinXScroll_SetPos (hWnd, direction, pos)
	SCROLLINFO si

	SetLastError (0)

	si.cbSize = SIZE (SCROLLINFO)
	si.fMask = $$SIF_POS
	si.nPos = pos
	SELECT CASE direction AND 0x00000003		' GL?
		CASE $$DIR_HORIZ : typeBar = $$SB_HORZ
		CASE $$DIR_VERT  : typeBar = $$SB_VERT
		CASE ELSE
			RETURN $$FALSE
	END SELECT
	SetScrollInfo (hWnd, typeBar, &si, 1)

	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXScroll_SetRange  #####
' #################################
' Sets the range the scrollbar moves through
' hWnd = the handle to the window the scrollbar belongs to
' direction = the direction of the scrollbar
' min = the minimum value of the range
' max = the maximum value of the range
' returns bOK: $$TRUE on success
FUNCTION WinXScroll_SetRange (hWnd, direction, min, max)
	SCROLLINFO si

	SetLastError (0)
	IFZ hWnd THEN RETURN $$FALSE

	SELECT CASE direction AND 0x00000003		' GL?
		CASE $$DIR_HORIZ : typeBar = $$SB_HORZ
		CASE $$DIR_VERT  : typeBar = $$SB_VERT
		CASE ELSE
			RETURN $$FALSE
	END SELECT

	si.cbSize	= SIZE (SCROLLINFO)
	si.fMask	= $$SIF_RANGE|$$SIF_DISABLENOSCROLL
	si.nMin		= min
	si.nMax		= max

	SetScrollInfo (hWnd, typeBar, &si, 1)		' redraw

	refreshWindow (hWnd)

	RETURN $$TRUE

END FUNCTION
'
' #############################
' #####  WinXScroll_Show  #####
' #############################
' Hides or displays the scrollbars for a window
' hWnd = the handle to the window to set the scrollbars for
' horiz = $$TRUE to enable the horizontal scrollbar, $$FALSE otherwise
' vert = $$TRUE to enable the vertical scrollbar, $$FALSE otherwise
' returns bOK: $$TRUE on success
FUNCTION WinXScroll_Show (hWnd, horiz, vert)

	SetLastError (0)
	IF hWnd THEN
		style = GetWindowLongA (hWnd, $$GWL_STYLE)
		IF horiz THEN style = style|$$WS_HSCROLL ELSE style = style AND NOT $$WS_HSCROLL
		IF vert  THEN style = style|$$WS_VSCROLL ELSE style = style AND NOT $$WS_VSCROLL
		SetWindowLongA (hWnd, $$GWL_STYLE, style)
		SetWindowPos (hWnd, 0, 0, 0, 0, 0, $$SWP_NOMOVE|$$SWP_NOSIZE|$$SWP_NOZORDER|$$SWP_FRAMECHANGED)
		RETURN $$TRUE
	ENDIF

END FUNCTION
'
' ###############################
' #####  WinXScroll_Update  #####
' ###############################
' Updates the client area of a window after a scroll
' hWnd = the handle to the window to scroll
' deltaX = the distance to scroll horizontally
' deltaY = the distance to scroll vertically
' returns bOK: $$TRUE on success
FUNCTION WinXScroll_Update (hWnd, deltaX, deltaY)
	RECT rect

	SetLastError (0)
	IF hWnd THEN
		ret = GetClientRect (hWnd, &rect)
		IFZ ret THEN
			msg$ = "WinXScroll_Update: Can't get the client rectangle of the window"
			GuiTellApiError (msg$)
		ELSE
			ScrollWindowEx (hWnd, deltaX, deltaY, 0, &rect, 0, 0, $$SW_ERASE|$$SW_INVALIDATE)
			RETURN $$TRUE
		ENDIF
	ENDIF
END FUNCTION
'
' #########################
' #####  WinXDisplay  #####
' #########################
'	/*
'	[WinXDisplay]
' Description = Displays a window for the first time
' Function    = WinXDisplay (hWnd)
' ArgCount    = 1
'	Arg1        = hWnd : The handle to the window to display
' Return      = $$TRUE if the window was previously visible.
' Remarks     = This function should be called after all the child controls have been added to the window.  It calls the sizing function, which is either the registered callback or the auto sizer.
'	See Also    =
'	Examples    = WinXDisplay (#hMain)
'	*/
FUNCTION WinXDisplay (hWnd)

	SetLastError (0)
	bPreviouslyVisible = $$FALSE

	IFZ hWnd THEN
		hWnd = GetActiveWindow ()
	ENDIF

	IF hWnd THEN
		refreshWindow (hWnd)
		SetLastError (0)
		ret = ShowWindow (hWnd, $$SW_SHOWNORMAL)		' $$SW_SHOW is reserved to WinXShow
		IF ret THEN
			bPreviouslyVisible = $$TRUE
'		ELSE
'			msg$ = "WinXDisplay: Can't display the window"
'			GuiTellApiError (msg$)
		ENDIF
	ENDIF

	RETURN bPreviouslyVisible

END FUNCTION
'
' ##########################
' #####  WinXDoEvents  #####
' ##########################
'	/*
'	[WinXDoEvents]
' Description = Processes events
' Function    = WinXDoEvents (hAccel)
' ArgCount    = 1
' Arg1        = hAccel : The handle to a table of keyboard accelerators (also known as keyboard shortcuts).  Use 0 if you don't want to process keyboard accelerators
' Return      = $$FALSE on receiving a quit message or $$TRUE on error
' Remarks     = This function doesn't return until the window is destroyed or a quit message is received.
'	See Also    =
'	Examples    = WinXDoEvents (0)
'	*/
FUNCTION WinXDoEvents (passed_accel)
	BINDING binding
	MSG msg		' will be sent to window callback function when an event occurs
'
' Supervise system messages until
' - the User decides to leave the application (RETURN $$FALSE)
' - an error occurred (returns bErr: $$TRUE on error)
'
	DO		' the message loop
		ret = GetMessageA (&msg, 0, 0, 0)		' retrieve next message from queue
		SELECT CASE ret
			CASE  0 : RETURN $$FALSE		' received a quit message
			CASE -1 : RETURN $$TRUE							' fail
			CASE ELSE
				' deal with window messages
				hWnd = GetActiveWindow ()
				'
				' Process accelerator keys for menu commands.
				'
				bOK = Get_binding (hWnd, @idBinding, @binding)
				IFF bOK THEN
					' default to the passed acceleration table (if any)
					binding.hAccelTable = passed_accel
				ELSE
					' use the acceleration table attached to the window
					' or default to the passed acceleration table (if any)
					IFZ binding.hAccelTable THEN binding.hAccelTable = passed_accel
				ENDIF

				bDispatch = $$FALSE
				' process accelerator keys for menu commands
				ret = TranslateAcceleratorA (hWnd, binding.hAccelTable, &msg)
				IFZ ret THEN
					IF (!IsWindow (hWnd)) || (!IsDialogMessageA (hWnd, &msg)) THEN		' send only non-dialog messages
						bDispatch = $$TRUE
					ENDIF
				ENDIF
				IF bDispatch THEN
					' send only non-dialog messages
					' translate virtual-key messages into character messages
					' ex.: SHIFT + a is translated as "A"
					TranslateMessage (&msg)

					' send message to window callback function
					DispatchMessageA (&msg)
				ENDIF
		END SELECT
	LOOP		' forever

END FUNCTION
'
' #######################################
' #####  WinXEnableDialogInterface  #####
' #######################################
' Enables or disables the dialog interface
' hWnd = the handle to the window to enable or disable the dialog interface for
' enable = $$TRUE to enable the dialog interface, otherwise $$FALSE
' returns bOK: $$TRUE on success
FUNCTION WinXEnableDialogInterface (hWnd, enable)
	BINDING binding

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hWnd
		CASE 0
		CASE ELSE
			'get the binding
			IFF Get_binding (hWnd, @idBinding, @binding) THEN EXIT SELECT

			IF enable THEN
				binding.useDialogInterface = $$TRUE
			ELSE
				binding.useDialogInterface = $$FALSE
			ENDIF
			IF binding.useDialogInterface THEN
				' enable dialog interface => set $$WS_POPUPWINDOW
				WinXSetStyle (hWnd, $$WS_POPUPWINDOW, 0, $$WS_OVERLAPPED, 0)
			ELSE
				' disable dialog interface => set $$WS_OVERLAPPED
				WinXSetStyle (hWnd, $$WS_OVERLAPPED, 0, $$WS_POPUPWINDOW, 0)
			ENDIF
			bOK = binding_update (idBinding, binding)

	END SELECT

	RETURN bOK

END FUNCTION
'
' ##############################
' #####  WinXGetPlacement  #####
' ##############################
' hWnd = the handle to the window
' minMax = the variable to store the minimised/maximised state
' restored = the variable to store the restored position and size
' returns bOK: $$TRUE on success
FUNCTION WinXGetPlacement (hWnd, @minMax, RECT restored)

	WINDOWPLACEMENT wp
	RECT rect_null

	SetLastError (0)
	minMax = 0
	restored = rect_null

	IFZ hWnd THEN hWnd = GetActiveWindow ()

	IF hWnd THEN
		wp.length = SIZE (WINDOWPLACEMENT)
		IF GetWindowPlacement (hWnd, &wp) THEN
			restored = wp.rcNormalPosition
			minMax = wp.showCmd
			RETURN $$TRUE		' success
		ENDIF
	ENDIF
END FUNCTION
'
' ##########################
' #####  WinXGetText$  #####
' ##########################
' Gets the text from a control.
' hCtr = control handle
' returns a string containing the text of the control.
FUNCTION WinXGetText$ (hCtr)

	SetLastError (0)
	ret$ = ""

	SELECT CASE hCtr
		CASE 0
			msg$ = "WinXGetText$: Ignore a NULL control handle"
			GuiAlert (msg$, "")
			'
		CASE ELSE
			cCh = GetWindowTextLengthA (hCtr)		' get character count
			IF cCh <= 0 THEN EXIT SELECT
			'
			sizeBuf = cCh + 1		' 1 output byte per input character + 0 terminator
			szBuf$ = NULL$ (sizeBuf)
			'
			SetLastError (0)
			cCh = GetWindowTextA (hCtr, &szBuf$, sizeBuf)		' get the text
			IF cCh <= 0 THEN
				msg$ = "WinXGetText$: Can't get the text from control, handle " + STRING$ (hCtr)
				GuiTellApiError (msg$)
				EXIT SELECT
			ENDIF
			'
			ret$ = LEFT$ (szBuf$, cCh)
			'
	END SELECT

	RETURN ret$

END FUNCTION
'
' ################################
' #####  WinXGetUseableRect  #####
' ################################
' Gets a rect describing the usable protion of a window's client area,
' that is, the portion not obscured with a toolbar or status bar
' hWnd = the handle to the window to get the rect for
' r_rect = the variable to hold the RECT structure
' returns bOK: $$TRUE on success
' ------------------------------------------------------------
' In conformance with conventions for the RECT structure, the
' bottom-right coordinates of the returned rectangle are
' exclusive. In other words, the pixel at (right, bottom) lies
' immediately outside the rectangle.
' ------------------------------------------------------------
'
' eg bOK = WinXGetUseableRect (hWnd, @rectUsable)
'
FUNCTION WinXGetUseableRect (hWnd, RECT rectUsable)
	BINDING binding
	RECT tmpRect

	SetLastError (0)
	bOK = $$FALSE
	rectUsable = tmpRect		' reset the returned value

	SELECT CASE hWnd
		CASE 0
		CASE ELSE
			'get the binding
			IFF Get_binding (hWnd, @idBinding, @binding) THEN EXIT SELECT

			SetLastError (0)
			ret = GetClientRect (hWnd, &rectUsable)
			IFZ ret THEN
				rectUsable = tmpRect		' reset the returned value
				msg$ = "WinXGetUseableRect: Can't get the client rectangle of the window"
				GuiTellApiError (msg$)
				EXIT SELECT
			ENDIF
'
' 0.6.0.2-old---
'			winWidth  = rectUsable.right  - rectUsable.left
'			winHeight = rectUsable.bottom - rectUsable.top
'
'			' only adjusts the right and bottom values
'			tmpRect.left   = 0
'			tmpRect.top    = 0
'			tmpRect.right  = winWidth
'			tmpRect.bottom = winHeight
'
'			style = GetWindowLongA (hWnd, $$GWL_STYLE)
'			exStyle = GetWindowLongA (hWnd, $$GWL_EXSTYLE)
'
'			menu = GetMenu (hWnd)
'			IFZ menu THEN fMenu = 0 ELSE fMenu = 1
'
'			AdjustWindowRectEx (&tmpRect, style, fMenu, exStyle)
'
'			winWidth  = tmpRect.right  - tmpRect.left
'			rectUsable.right = winWidth + rectUsable.left
'
'			winHeight = tmpRect.bottom - tmpRect.top
'			rectUsable.bottom = winHeight + rectUsable.top
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			rectUsable.left  = rectUsable.left  + GetSystemMetrics ($$SM_CXFRAME)		' width of the window frame

			' 1.account for the caption's height
			rectUsable.top = rectUsable.top + GetSystemMetrics ($$SM_CYCAPTION)		' height of caption

			' 2.account for the menubar's height
			menu = GetMenu (hWnd)
			IF menu THEN
				rectUsable.top = rectUsable.top + GetSystemMetrics ($$SM_CYMENU)		' height of single-line menu
			ENDIF

			'exStyle = GetWindowLongA (hWnd, $$GWL_EXSTYLE)

			' 3.account for the toolbar's height
			IF binding.hBar THEN
				'tool bar
				SetLastError (0)
				ret = GetClientRect (binding.hBar, &tmpRect)
				IF ret THEN
					rectUsable.top = rectUsable.top + tmpRect.top - tmpRect.bottom
				ELSE
					msg$ = "WinXGetUseableRect: Can't get the client rectangle of the tool bar"
					GuiTellApiError (msg$)
				ENDIF
			ENDIF

			' 4.account for the status bar's height
			IF binding.hStatus THEN
				'status bar
				SetLastError (0)
				ret = GetClientRect (binding.hStatus, &tmpRect)
				IF ret THEN
					rectUsable.bottom = rectUsable.bottom + tmpRect.top - tmpRect.bottom
				ELSE
					msg$ = "WinXGetUseableRect: Can't get the client rectangle of the status bar"
					GuiTellApiError (msg$)
				ENDIF
			ENDIF

			style = GetWindowLongA (hWnd, $$GWL_STYLE)
			IF style & $$WS_VSCROLL THEN
				rectUsable.right = rectUsable.right - GetSystemMetrics ($$SM_CXVSCROLL)		' width vertical scroll bar
			ENDIF

			' 5.account for the horizontal scrollbar's height
			IF style & $$WS_HSCROLL THEN
				rectUsable.bottom = rectUsable.bottom - GetSystemMetrics ($$SM_CXHSCROLL)		' width horizontal scroll bar
			ENDIF

			bOK = $$TRUE		' success

	END SELECT

	RETURN bOK

END FUNCTION
'
' #############################################
' #####  WinXGroupBox_GetAutosizerSeries  #####
' #############################################
' Gets the auto sizer series for a group box
' hGB = the handle to the group box
' returns the group box's series or -1 on fail.
FUNCTION WinXGroupBox_GetAutosizerSeries (hGB)
	SetLastError (0)
	series = -1
	IF hGB THEN
		index = GetPropA (hGB, &$$auto_sizer$)
		IF index >= 0 THEN series = index
	ENDIF
	RETURN series
END FUNCTION
'
' ######################
' #####  WinXHide  #####
' ######################
' Hides a window or control
' hWnd = the handle to the control or window to hide
' returns bOK: $$TRUE on success
FUNCTION WinXHide (hWnd)
	SetLastError (0)
	IF hWnd THEN
		ret = ShowWindow (hWnd, $$SW_HIDE)
		IF ret THEN
			RETURN $$TRUE		' success
		ELSE
			msg$ = "WinXHide: Can't hide the window"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF
END FUNCTION
'
' ###########################
' #####  WinXSetCursor  #####
' ###########################
' Sets a window's cursor
' hWnd = the handle to the window
' hCursor = the cursor
' returns bOK: $$TRUE on success
FUNCTION WinXSetCursor (hWnd, hCursor)
	BINDING	binding

	SetLastError (0)
	IF hCursor THEN
		'get the binding
		IF Get_binding (hWnd, @idBinding, @binding) THEN
			binding.hCursor = hCursor
			bOK = binding_update (idBinding, binding)
			RETURN bOK
		ENDIF
	ENDIF
END FUNCTION
'
' ############################
' #####  WinXSetMinSize  #####
' ############################
' Sets the minimum size for a window
' hWnd = the window handle
' w and h = the minimum width and height of the client area
' returns bOK: $$TRUE on success
FUNCTION WinXSetMinSize (hWnd, w, h)
	BINDING			binding
	RECT rect

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hWnd
		CASE 0
		CASE ELSE
			'get the binding
			IFF Get_binding (hWnd, @idBinding, @binding) THEN EXIT SELECT
'
' 0.6.0.2-new+++
			cxminimized = GetSystemMetrics ($$SM_CXMINIMIZED)		' Width of rectangle into which minimised windows must fit
			IF w < cxminimized THEN w = cxminimized

			cyminimized = GetSystemMetrics ($$SM_CYMINIMIZED)		' Height of rectangle into which minimised windows must fit
			IF h < cyminimized THEN h = cyminimized
' 0.6.0.2-new~~~
'
' 0.6.0.2-old---
'			' only adjusts the right and bottom values
'			rect.left = 0
'			rect.top = 0
'			rect.right = w
'			rect.bottom = h
'			menu = GetMenu (hWnd)
'			IF menu THEN
'				fMenu = 1
'			ELSE
'				fMenu = 0
'			ENDIF
'			AdjustWindowRectEx (&rect, GetWindowLongA (hWnd, $$GWL_STYLE), fMenu, GetWindowLongA (hWnd, $$GWL_EXSTYLE))
' 0.6.0.2-old~~~
'
			binding.minW = rect.right-rect.left
			binding.minH = rect.bottom-rect.top
			bOK = binding_update (idBinding, binding)

	END SELECT

	RETURN bOK

END FUNCTION
'
' ##############################
' #####  WinXSetPlacement  #####
' ##############################
' hWnd = the handle to the window
' minMax = minimised/maximised state, can be null in which case no changes are made
' restored = the restored position and size, can be null in which case not changes are made
' returns bOK: $$TRUE on success
FUNCTION WinXSetPlacement (hWnd, minMax, RECT restored)

	WINDOWPLACEMENT wp
	RECT rect_null

	SetLastError (0)
	bOK = $$FALSE
	restored = rect_null		' rectangle null

	IF hWnd THEN
		wp.length = SIZE (WINDOWPLACEMENT)
		IF GetWindowPlacement (hWnd, &wp) THEN
			IF wp.showCmd THEN wp.showCmd = minMax

			IF (restored.left | restored.right | restored.top | restored.bottom) THEN
				wp.rcNormalPosition = restored
			ENDIF

			wp.length = SIZE (WINDOWPLACEMENT)
			IF SetWindowPlacement (hWnd, &wp) THEN bOK = $$TRUE

			refreshWindow (hWnd)
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ##########################
' #####  WinXSetStyle  #####
' ##########################
' Changes the window style of a window or a control.
' hWnd     = handle to the window the change the style of
' styleAdd = styles to add
' addEx    = extended styles to add
' styleSub = styles to remove
' subEx    = extended styles to remove
' returns bOK: $$TRUE on success
FUNCTION WinXSetStyle (hWnd, styleAdd, addEx, styleSub, subEx)

	SetLastError (0)

	IFZ hWnd THEN RETURN

	bOK = $$TRUE		' assume success

	SELECT CASE TRUE
		CASE styleAdd = styleSub		' do nothing
			'
		CASE ELSE
			styleOld = GetWindowLongA (hWnd, $$GWL_STYLE)
			styleNew = styleOld
			'
			' 1.Subtract before Adding
			IF styleSub THEN
				IF styleNew THEN
					IF styleNew = styleSub THEN
						styleNew = 0
					ELSE
						styleNew = styleNew & (~styleSub)		' clear the style to "subtract"
					ENDIF
				ENDIF
			ENDIF
			'
			' 2.Add after Subtracting
			IFZ styleNew THEN
					styleNew = styleAdd
			ELSE
				IF styleAdd THEN
					styleNew = styleNew | styleAdd
				ENDIF
			ENDIF
			'
			' update the control only for a styleOld change
			IF styleNew = styleOld THEN EXIT SELECT
			'
			SetWindowLongA (hWnd, $$GWL_STYLE, styleNew)
			'
			' GL-18mar12-add or remove $$ES_READONLY flag with:
			' SendMessageA (handle, $$EM_SETREADONLY, On/off, 0)
			state = -1
			IF styleAdd & $$ES_READONLY THEN state = 1		' if $$ES_READONLY in styleAdd => read only
			IF styleSub & $$ES_READONLY THEN state = 0		' if $$ES_READONLY in styleSub => unprotected
			'
			IF state >= 0 THEN SendMessageA (hWnd, $$EM_SETREADONLY, state, 0)
			'
			' check update
			update = GetWindowLongA (hWnd, $$GWL_STYLE)
			IF update != styleNew THEN bOK = $$FALSE		' fail
			'
	END SELECT

	SELECT CASE TRUE
		CASE addEx = subEx		' do nothing
			'
		CASE ELSE
			exStyleOld = GetWindowLongA (hWnd, $$GWL_EXSTYLE)
			exStyleNew = exStyleOld
			'
			' 1.Subtract before Adding
			SELECT CASE 0
				CASE subEx		' nothing to subtract
				CASE exStyleNew		' nothing to subtract from
				CASE ELSE
					IF exStyleNew = subEx THEN
						exStyleNew = 0
					ELSE
						exStyleNew = exStyleNew & (~subEx)		' clear the extended style to "subtract"
					ENDIF
			END SELECT
			'
			' 2.Add after Subtracting
			SELECT CASE 0
				CASE addEx		' nothing to add
				CASE exStyleNew : exStyleNew = addEx
				CASE ELSE : exStyleNew = exStyleNew | addEx
			END SELECT
			'
			' update the control only for a exStyleOld change
			IF exStyleNew = exStyleOld THEN EXIT SELECT
			'
			' listview's extended styleNew mask is set using:
			' SendMessageA (handle, $$LVM_SETEXTENDEDLISTVIEWSTYLE, ...
			sizeBuf = 128
			szBuf$ = NULL$ (sizeBuf)
			ret = GetClassNameA (hWnd, &szBuf$, sizeBuf)
			class$ = TRIM$ (CSTRING$ (&szBuf$))
			SELECT CASE class$
				CASE $$WC_LISTVIEW
					SendMessageA (hWnd, $$LVM_SETEXTENDEDLISTVIEWSTYLE, 0, exStyleNew)
					update = SendMessageA (hWnd, $$LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
					'
				CASE $$WC_TABCONTROL
					SendMessageA (hWnd, $$TB_SETEXTENDEDSTYLE, 0, exStyleNew)
					update = SendMessageA (hWnd, $$TB_GETEXTENDEDSTYLE, 0, 0)
					'
				CASE ELSE
					SetWindowLongA (hWnd, $$GWL_EXSTYLE, exStyleNew)
					update = GetWindowLongA (hWnd, $$GWL_EXSTYLE)
					'
			END SELECT
			'
			' check update
			IF update != exStyleNew THEN bOK = $$FALSE		' fail
			'
	END SELECT

	RETURN bOK

END FUNCTION
'
' #########################
' #####  WinXSetText  #####
' #########################
' Sets the text for a control.
' hCtr = control handle
' text$ = text to set
' returns bOK: $$TRUE on success
FUNCTION WinXSetText (hCtr, text$)

	SetLastError (0)
	IF hCtr THEN
		ret = SetWindowTextA (hCtr, &text$)
		IF ret THEN
			RETURN $$TRUE		' success
		ELSE
			msg$ = "WinXSetText: Can't set the text of control, handle " + STRING$ (hCtr)
			GuiTellApiError (msg$)
		ENDIF
	ELSE
		msg$ = "WinXSetText: Ignore a NULL control handle"
		GuiAlert (msg$, "")
	ENDIF

END FUNCTION
'
' ################################
' #####  WinXSetWindowColor  #####
' ################################
' Changes the window background color
' hWnd = the window to change the color for
' backRGB = the new background color
' returns bOK: $$TRUE on success
'
' Usage:
'	codeRGB = RGB (240, 240, 240)		' very light grey
'	WinXSetWindowColor (#winMain, codeRGB)
'
FUNCTION WinXSetWindowColor (hWnd, backRGB)
	RETURN WinXSetWindowColour (hWnd, backRGB)
END FUNCTION
'
' #################################
' #####  WinXSetWindowColour  #####
' #################################
' Changes the window background color
' hWnd = the window to change the color for
' backRGB = the new background color
' returns bOK: $$TRUE on success
FUNCTION WinXSetWindowColour (hWnd, backRGB)
	BINDING	binding

	SetLastError (0)
	'get the binding
	IF Get_binding (hWnd, @idBinding, @binding) THEN
		IF binding.backCol THEN
			DeleteObject (binding.backCol)
			binding.backCol = 0
		ENDIF
		binding.backCol = CreateSolidBrush (backRGB)
		bOK = binding_update (idBinding, binding)
		RETURN bOK
	ENDIF

END FUNCTION
'
' ##################################
' #####  WinXSetWindowToolbar  #####
' ##################################
' Sets the window toolbar.
' hWnd = window to set
' hToolbar = toolbar to use
' returns bOK: $$TRUE on success
FUNCTION WinXSetWindowToolbar (hWnd, hToolbar)
	BINDING	binding

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE TRUE
		CASE hToolbar = 0
		CASE hWnd = 0
		CASE Get_binding (hWnd, @idBinding, @binding)
			'set the toolbar style
			style = GetWindowLongA (hToolbar, $$GWL_STYLE)
			style = style|$$WS_CHILD|$$WS_VISIBLE|$$CCS_TOP
			SetWindowLongA (hToolbar, $$GWL_STYLE, style)
			'
			'set the toolbar parent
			SetLastError (0)
			ret = SetParent (hToolbar, hWnd)
			IFZ ret THEN
				msg$ = "WinXSetWindowToolbar: Can't get the toolbar parent"
				GuiTellApiError (msg$)
			ELSE
				SendMessageA (hToolbar, $$TB_SETPARENT, hWnd, 0)
			ENDIF
			'
			'and update the binding
			binding.hBar = hToolbar
			bOK = binding_update (idBinding, binding)
			'
	END SELECT

	RETURN bOK

END FUNCTION
'
' ######################
' #####  WinXShow  #####
' ######################
' Shows a previously hidden window or control
' hWnd = the handle to the control or window to show
' returns bOK: $$TRUE on success
FUNCTION WinXShow (hWnd)
	SetLastError (0)
	IF hWnd THEN
		refreshWindow (hWnd)
		ret = ShowWindow (hWnd, $$SW_SHOW)
		IF ret THEN
			RETURN $$TRUE		' success
		ELSE
			msg$ = "WinXShow: Can't show the window"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF
END FUNCTION
'
' ########################
' #####  WinXUpdate  #####
' ########################
' Updates the specified window
' hWnd = the handle to the window
FUNCTION WinXUpdate (hWnd)
	BINDING binding
	RECT rect

	SetLastError (0)
	IFZ hWnd THEN RETURN $$FALSE

	'WinXGetUseableRect (hWnd, @rect)
	'InvalidateRect (hWnd, &rect, $$TRUE)

	bOK = $$FALSE

	'get the binding
	IF Get_binding (hWnd, @idBinding, @binding) THEN
		'PRINT binding.hUpdateRegion
		InvalidateRgn (hWnd, binding.hUpdateRegion, $$TRUE)
		DeleteObject (binding.hUpdateRegion)
		binding.hUpdateRegion = 0
		bOK = binding_update (idBinding, binding)
	ENDIF

	RETURN bOK

END FUNCTION
'
' #################################
' #####  WinXSplitter_GetPos  #####
' #################################
' Get the current position of a splitter control
' series = the series to which the splitter belongs
' hCtr = the control the splitter is attached to
' position = the variable to store the position of the splitter
' docked = the variable to store the docking state, $$TRUE when docked else $$FALSE
' returns bOK: $$TRUE on success
FUNCTION WinXSplitter_GetPos (series, hCtr, @position, @docked)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	SPLITTERINFO splitterInfo

	IF series < 0 || series > UBOUND (autoSizerInfoUM[]) THEN
		RETURN $$FALSE
	ENDIF
	IFF autoSizerInfoUM[series].inUse THEN RETURN $$FALSE

	' Walk the list until we find the auto drawer record we need
	found = $$FALSE
	i = autoSizerInfoUM[series].iHead
	DO WHILE i > -1
		IF autoSizerInfo[series, i].hWnd = hCtr THEN
			found = $$TRUE
			EXIT DO
		ENDIF
		i = autoSizerInfo[series, i].nextItem
	LOOP

	IFF found THEN RETURN $$FALSE

	idSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (idSplitter, @splitterInfo)

	IF splitterInfo.docked THEN
		position = splitterInfo.docked
		docked = $$TRUE
	ELSE
		position = autoSizerInfo[series, i].size
		docked = $$FALSE
	ENDIF

	RETURN $$TRUE		' success

END FUNCTION
'
' #################################
' #####  WinXSplitter_SetPos  #####
' #################################
' Set the current position of a splitter control
' series = the series to which the splitter belongs
' hCtr = the control the splitter is attached to
' position = the new position for the splitter
' returns bOK: $$TRUE on success
FUNCTION WinXSplitter_SetPos (series, hCtr, position, docked)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	SPLITTERINFO splitterInfo

	IF series < 0 || series > UBOUND (autoSizerInfoUM[]) THEN
		RETURN $$FALSE
	ENDIF
	IFF autoSizerInfoUM[series].inUse THEN RETURN $$FALSE

	' Walk the list until we find the auto sizer record we need
	found = $$FALSE
	i = autoSizerInfoUM[series].iHead
	DO WHILE i > -1
		IF autoSizerInfo[series, i].hWnd = hCtr THEN
			found = $$TRUE
			EXIT DO
		ENDIF
		i = autoSizerInfo[series, i].nextItem
	LOOP

	IFF found THEN RETURN $$FALSE

	idSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (idSplitter, @splitterInfo)

	IF docked THEN
		autoSizerInfo[series, i].size = 8
		splitterInfo.docked = position
	ELSE
		autoSizerInfo[series, i].size = position
		splitterInfo.docked = 0
	ENDIF

	SPLITTERINFO_Update (idSplitter, splitterInfo)

	hParent = GetParent (hCtr)
	IF hParent THEN
		refreshWindow (hParent)
	ENDIF

	RETURN $$TRUE		' success

END FUNCTION
'
' ########################################
' #####  WinXSplitter_SetProperties  #####
' ########################################
' Sets splitter info
' series = the series the control is located in
' hCtr = the handle to the control
' min = the minimum size of the control
' max = the maximum size of the control
' dock = $$TRUE to allow docking - else $$FALSE
' returns bOK: $$TRUE on success
FUNCTION WinXSplitter_SetProperties (series, hCtr, min, max, dock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	SPLITTERINFO splitterInfo

	IF series < 0 || series > UBOUND (autoSizerInfoUM[]) THEN
		RETURN $$FALSE
	ENDIF
	IFF autoSizerInfoUM[series].inUse THEN RETURN $$FALSE

	' Walk the list until we find the auto drawer record we need
	found = $$FALSE
	i = autoSizerInfoUM[series].iHead
	DO WHILE i > -1
		IF autoSizerInfo[series, i].hWnd = hCtr THEN
			found = $$TRUE
			EXIT DO
		ENDIF
		i = autoSizerInfo[series, i].nextItem
	LOOP

	IFF found THEN RETURN $$FALSE

	idSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (idSplitter, @splitterInfo)
	splitterInfo.min = min
	splitterInfo.max = max

	IF dock THEN
		IF autoSizerInfoUM[series].direction AND $$DIR_REVERSE THEN
			splitterInfo.dock = $$DOCK_BACKWARD
		ELSE
			splitterInfo.dock = $$DOCK_FORWARD
		ENDIF
	ELSE
		splitterInfo.dock = $$DOCK_DISABLED
	ENDIF

	SPLITTERINFO_Update (idSplitter, splitterInfo)

	RETURN $$TRUE		' success

END FUNCTION
'
' #################################
' #####  WinXStatus_GetText$  #####
' #################################
' Retrieves the text from a status bar
' hWnd = the window containing the status bar
' part = the part to get the text from
' returns the status text from the specified part of the status bar, or the empty string on fail
FUNCTION WinXStatus_GetText$ (hWnd, part)
	BINDING	binding

	SetLastError (0)
	'get the binding
	IF Get_binding (hWnd, @idBinding, @binding) THEN
		IF binding.hStatus THEN
			IF part <= binding.statusParts THEN
				cc = SendMessageA (binding.hStatus, $$SB_GETTEXTLENGTH, part, 0)
				szBuf$ = NULL$ (cc)
				SendMessageA (binding.hStatus, $$SB_GETTEXT, part, &szBuf$)
				ret$ = CSTRING$ (&szBuf$)
				RETURN ret$
			ENDIF
		ENDIF
	ENDIF

END FUNCTION
'
' ################################
' #####  WinXStatus_SetText  #####
' ################################
' Sets the text in a status bar
' hWnd = the window containing the status bar
' part = the partition to set the text for, zero-based
' text$ = the text to set the status to
' returns bOK: $$TRUE on success
FUNCTION WinXStatus_SetText (hWnd, part, text$)
	BINDING	binding

	SetLastError (0)
	'get the binding
	IF Get_binding (hWnd, @idBinding, @binding) THEN
		IF binding.hStatus THEN
			IF part < 0 THEN part = 0
			IF part <= binding.statusParts THEN
				SendMessageA (binding.hStatus, $$SB_SETTEXT, part, &text$)
				RETURN $$TRUE
			ENDIF
		ENDIF
	ENDIF

END FUNCTION
'
' #############################
' #####  WinXTabs_AddTab  #####
' #############################
' Adds a new tab to a tab control
' hTabs = the handle to the tab control
' label$ = the label for the new tab
' insertAfter = the index to insert at, -1 for to append
' returns the index of the tab
FUNCTION WinXTabs_AddTab (hTabs, label$, insertAfter)
	TC_ITEM tci		' tab control structure

	SetLastError (0)
	r_index = -1

	IF hTabs THEN
		tci.mask = $$TCIF_PARAM|$$TCIF_TEXT
		tci.pszText = &label$
		tci.cchTextMax = LEN (label$)
		tci.lParam = autoSizerGroup_add ($$DIR_VERT)		' (GL: autoSizerGroup_add returns an index compatible with tci.lParam)

		IF insertAfter < 0 THEN
			insertAfter = SendMessageA (hTabs, $$TCM_GETITEMCOUNT, 0, 0)
		ENDIF

		SetLastError (0)
		r_index = SendMessageA (hTabs, $$TCM_INSERTITEM, insertAfter, &tci)
		IF r_index < 0 THEN
			msg$ = "WinXTabs_AddTab: Can't add new tab " + label$
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

	RETURN r_index

END FUNCTION
'
' ################################
' #####  WinXTabs_DeleteTab  #####
' ################################
' Deletes a tab in a tab control
' hTabs = the handle the tab control
' iTab = the index of the tab to delete
' returns bOK: $$TRUE on success
FUNCTION WinXTabs_DeleteTab (hTabs, iTab)
	SetLastError (0)
	IF hTabs THEN
		ret = SendMessageA (hTabs, $$TCM_DELETEITEM, iTab, 0)
		IF ret THEN RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' ########################################
' #####  WinXTab_GetAutosizerSeries  #####
' ########################################
' Gets the auto sizer series for a tab
' hTabs = the tab control
' iTab = the index of the tab to get the auto sizer series for
' returns the index of the auto sizer series or -1 on fail
FUNCTION WinXTabs_GetAutosizerSeries (hTabs, iTab)
	TC_ITEM tci		' tab control structure

	SetLastError (0)
	r_index = -1

	IF hTabs THEN
		tci.mask = $$TCIF_PARAM
		IF SendMessageA (hTabs, $$TCM_GETITEM, iTab, &tci) THEN
			r_index = tci.lParam
			IF r_index < -1 THEN r_index = -1
		ENDIF
	ENDIF

	RETURN r_index

END FUNCTION
'
' ####################################
' #####  WinXTabs_GetCurrentTab  #####
' ####################################
' Gets the index of the currently selected tab
' hTabs = the handle to the tab control
' returns the index of the currently selected tab
FUNCTION WinXTabs_GetCurrentTab (hTabs)
	SetLastError (0)
	IF hTabs THEN
		RETURN SendMessageA (hTabs, $$TCM_GETCURSEL, 0, 0)
	ENDIF
END FUNCTION
'
' ####################################
' #####  WinXTabs_SetCurrentTab  #####
' ####################################
' Sets the current tab
' hTabs = the tab control
' iTab = the index of the new current tab
' returns bOK: $$TRUE on success
FUNCTION WinXTabs_SetCurrentTab (hTabs, iTab)

	SetLastError (0)
	bOK = $$FALSE

	IF hTabs THEN
		count = SendMessageA (hTabs, $$TCM_GETITEMCOUNT, 0, 0)
		IF count > 0 THEN
			uppTab = count - 1
			'
			IF iTab < 0 THEN iTab = 0		' select first tabstrip
			IF iTab > uppTab THEN iTab = uppTab		' select last tabstrip
			'
			ret = SendMessageA (hTabs, $$TCM_SETCURSEL, iTab, 0)
			IF ret THEN bOK = $$TRUE		' success
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' #####################################
' #####  WinXTimePicker_GetTime  #####
' #####################################
' Gets the time from a Date/Time Picker control
' hDTP = the handle to the control
' time = the structure to store the time
' returns bOK: $$TRUE on success
FUNCTION WinXTimePicker_GetTime (hDTP, SYSTEMTIME time, @r_timeValid)

	SetLastError (0)
	bOK = $$TRUE
	r_timeValid = $$FALSE

	SELECT CASE SendMessageA (hDTP, $$DTM_GETSYSTEMTIME, 0, &time)
		CASE $$GDT_VALID
			r_timeValid = $$TRUE

		CASE $$GDT_ERROR
			bOK = $$FALSE
			msg$ = "WinXTimePicker_GetTime: Can't get the time from Date/Time picker"
			GuiTellApiError (msg$)

	END SELECT

	RETURN bOK

END FUNCTION
'
' ####################################
' #####  WinXTimePicker_SetTime  #####
' ####################################
' Sets the time for a Date/Time Picker control
' hDTP = the handle to the control
' time = the time to set the control to
' returns bOK: $$TRUE on success
FUNCTION WinXTimePicker_SetTime (hDTP, SYSTEMTIME time, timeValid)

	SetLastError (0)
	IF hDTP THEN
		IF timeValid THEN
			wParam = $$GDT_VALID
			lParam = &time
		ELSE
			wParam = $$GDT_NONE
			lParam = 0
		ENDIF
		ret = SendMessageA (hDTP, $$DTM_SETSYSTEMTIME, wParam, lParam)
		IF ret THEN
			RETURN $$TRUE
		ELSE
			msg$ = "WinXTimePicker_SetTime$: Can't set the time for a Date/Time Picker control"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

END FUNCTION
'
' ###################################
' #####  WinXToolbar_AddButton  #####
' ###################################
' Adds a button to a toolbar
' hToolbar = the toolbar to add the button to
' commandId = the id for the button
' iImage = the index of the image to use for the button
' theTip$ = the text to use for the tooltip
' optional = $$TRUE if this button is optional, otherwise $$FALSE
'  !!THIS FEATURE IS NOT YET IMPLEMENTED, YOU SHOULD SET THIS PARAMETER TO $$FALSE!!
' moveable = $$TRUE if the button can be move, otherwise $$FALSE
'  !!THIS FEATURE IS NOT YET IMPLEMENTED, YOU SHOULD SET THIS PARAMETER TO $$FALSE!!
' returns bOK: $$TRUE on success
FUNCTION WinXToolbar_AddButton (hToolbar, commandId, iImage, theTip$, optional, moveable)
	TBBUTTON bt

	SetLastError (0)
	IF hToolbar THEN
		bt.iBitmap = iImage
		bt.idCommand = commandId
		bt.fsState = $$TBSTATE_ENABLED
		bt.fsStyle = $$BTNS_AUTOSIZE|$$BTNS_BUTTON
		bt.iString = &theTip$
		'
		ret = SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
		IF ret THEN RETURN $$TRUE
	ENDIF

END FUNCTION
'
' ####################################
' #####  WinXToolbar_AddControl  #####
' ####################################
' Adds a control to a toolbar control
' hToolbar = the handle to the toolbar to add the control to
' hControl = the handle to the control
' w = the width of the control in the toolbar, the control will be resized to the height of the toolbar and this width
' returns bOK: $$TRUE on success
FUNCTION WinXToolbar_AddControl (hToolbar, hControl, w)
	TBBUTTON bt
	RECT rect2

	SetLastError (0)
	IF hToolbar THEN
		bt.iBitmap = w+4
		bt.fsState = $$TBSTATE_ENABLED
		bt.fsStyle = $$BTNS_SEP

		iControl = SendMessageA (hToolbar, $$TB_BUTTONCOUNT, 0, 0)
		SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
		SendMessageA (hToolbar, $$TB_GETITEMRECT, iControl, &rect2)

		MoveWindow (hControl, rect2.left + 2, rect2.top, w, rect2.bottom - rect2.top, 1)

		SetParent (hControl, hToolbar)

		RETURN $$TRUE
	ENDIF

END FUNCTION
'
' ######################################
' #####  WinXToolbar_AddSeparator  #####
' ######################################
' Adds a button separator to a toolbar
' hToolbar = the handle to the toolbar
' returns bOK: $$TRUE on success
FUNCTION WinXToolbar_AddSeparator (hToolbar)
	TBBUTTON bt

	SetLastError (0)
	IF hToolbar THEN
		bt.iBitmap = 4
		bt.fsState = $$TBSTATE_ENABLED
		bt.fsStyle = $$BTNS_SEP
		ret = SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
		IF ret THEN RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' #########################################
' #####  WinXToolbar_AddToggleButton  #####
' #########################################
' Adds a toggle button to a toolbar
' hToolbar = the handle to the toolbar
' commandId = the command constant the button will generate
' iImage = the zero-based index of the image for this button
' theTip$ = the text for this button's tooltip
' mutex = $$TRUE if this toggle is mutually exclusive, ie. only one from a group can be toggled at a time
' returns bOK: $$TRUE on success
FUNCTION WinXToolbar_AddToggleButton (hToolbar, commandId, iImage, theTip$, mutex, optional, moveable)
	TBBUTTON bt

	SetLastError (0)

	IF hToolbar THEN
		bt.iBitmap = iImage
		bt.idCommand = commandId
		bt.fsState = $$TBSTATE_ENABLED
		bt.iString = &theTip$

		IF mutex THEN
			bt.fsStyle = $$BTNS_CHECKGROUP
		ELSE
			bt.fsStyle = $$BTNS_CHECK
		ENDIF
		bt.fsStyle = bt.fsStyle|$$BTNS_AUTOSIZE

		SetLastError (0)
		ret = SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
		IF ret THEN
			RETURN $$TRUE		' success
		ELSE
			msg$ = "WinXToolbar_AddToggleButton: Can't add toggle toolbar button, command id control " + STRING$ (commandId)
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

END FUNCTION
'
' ######################################
' #####  WinXToolbar_EnableButton  #####
' ######################################
' Enables or disables a toolbar button
' hToolbar = the handle to the toolbar on which the button resides
' idButton = the command id of the button
' enable = $$TRUE to enable the button, $$FALSE to disable
' returns bOK: $$TRUE on success
FUNCTION WinXToolbar_EnableButton (hToolbar, idButton, enable)

	SetLastError (0)
	bOK = $$FALSE

	IF hToolbar THEN
		IF enable THEN fEnableNew = 1 ELSE fEnableNew = $$FALSE

		' determine whether button idButton is enabled or disabled
		fEnableOld = SendMessageA (hToolbar, $$TB_ISBUTTONENABLED, idButton, 0)
		IF fEnableOld THEN fEnableOld = 1		' 1 = enabled

		IF fEnableNew <> fEnableOld THEN
			' toggle the state
			ret = SendMessageA (hToolbar, $$TB_ENABLEBUTTON, idButton, fEnableNew)
			IF ret THEN
				' check if the state was really toggled
				SetLastError (0)
				ret = SendMessageA (hToolbar, $$TB_ISBUTTONENABLED, idButton, 0)
				IF ret = fEnableNew THEN bOK = $$TRUE
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ######################################
' #####  WinXToolbar_ToggleButton  #####
' ######################################
' Toggles a toolbar button
' hToolbar = the handle to the toolbar on which the button resides
' idButton = the command id of the button
' on = $$TRUE to toggle the button on, $$FALSE to toggle the button off
' returns bOK: $$TRUE on success
FUNCTION WinXToolbar_ToggleButton (hToolbar, idButton, on)

	SetLastError (0)
	IF hToolbar THEN
		state = SendMessageA (hToolbar, $$TB_GETSTATE, idButton, 0)
		IF on THEN
			state = state|$$TBSTATE_CHECKED
		ELSE
			state = state AND NOT ($$TBSTATE_CHECKED)		' clear the state to "subtract"
		ENDIF
		'
		SetLastError (0)
		ret = SendMessageA (hToolbar, $$TB_SETSTATE, idButton, state)
		IF ret THEN
			RETURN $$TRUE		' success
		ELSE
			msg$ = "WinXToolbar_ToggleButton: Can't toggle toolbar button, command id control " + STRING$ (idButton)
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

END FUNCTION
'
' ################################
' #####  WinXTracker_GetPos  #####
' ################################
' Gets the position of the slider in a tracker bar control
' hTracker = the handle to the tracker
' returns the position of the slider
FUNCTION WinXTracker_GetPos (hTracker)
	SetLastError (0)
	RETURN SendMessageA (hTracker, $$TBM_GETPOS, 0, 0)
END FUNCTION
'
' ###################################
' #####  WinXTracker_SetLabels  #####
' ###################################
' Sets the labels for the start and end of a trackbar control
' hTracker = the handle to the tracker control
' leftLabel = the label for the left of the tracker
' rightLabel = the label for the right of the tracker
' returns bOK: $$TRUE on success
FUNCTION WinXTracker_SetLabels (hTracker, STRING leftLabel, STRING rightLabel)
	SIZEAPI left
	SIZEAPI right

	SetLastError (0)
	IFZ hTracker THEN RETURN $$FALSE

	'first, get any existing labels
	hLeft = SendMessageA (hTracker, $$TBM_GETBUDDY, $$TRUE, 0)
	hRight = SendMessageA (hTracker, $$TBM_GETBUDDY, $$FALSE, 0)

	IF hLeft THEN DestroyWindow (hLeft)
	IF hRight THEN DestroyWindow (hRight)

	'we need to get the width and height of the strings
	hdcMem = CreateCompatibleDC (0)
	SelectObject (hdcMem, GetStockObject ($$DEFAULT_GUI_FONT))
	GetTextExtentPoint32A (hdcMem, &leftLabel, LEN(leftLabel), &left)
	GetTextExtentPoint32A (hdcMem, &rightLabel, LEN(rightLabel), &right)
	DeleteDC (hdcMem)

	'now create the windows
	hParent = GetParent (hTracker)
	hLeft = WinXAddStatic (hParent, leftLabel, 0, $$SS_CENTER, 1)
	hRight = WinXAddStatic (hParent, rightLabel, 0, $$SS_CENTER, 1)
	MoveWindow (hLeft, 0, 0, left.cx+4, left.cy+4, 1)		' repaint
	MoveWindow (hRight, 0, 0, right.cx+4, right.cy+4, 1)		' repaint

	'and set them
	SendMessageA (hTracker, $$TBM_SETBUDDY, $$TRUE, hLeft)
	SendMessageA (hTracker, $$TBM_SETBUDDY, $$FALSE, hRight)

	RETURN $$TRUE		' success

END FUNCTION
'
' ################################
' #####  WinXTracker_SetPos  #####
' ################################
' Sets the position of the slider in a trackbar control
' hTracker = the handle to the tracker
' newPos = the new position of the slider
' returns bOK: $$TRUE on success
FUNCTION WinXTracker_SetPos (hTracker, newPos)
	SetLastError (0)
	IF hTracker THEN
		SendMessageA (hTracker, $$TBM_SETPOS, $$TRUE, newPos)
		RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' ##################################
' #####  WinXTracker_SetRange  #####
' ##################################
' Sets the range for a trackbar control
' hTracker = the control to set the range for
' min = the minimum value for the tracker
' max = the maximum value for the tracker
' ticks = the number of units per tick
' returns bOK: $$TRUE on success
FUNCTION WinXTracker_SetRange (hTracker, USHORT min, USHORT max, ticks)
	SetLastError (0)
	IF hTracker THEN
		SendMessageA (hTracker, $$TBM_SETRANGE, 1, MAKELONG(min, max))
		SendMessageA (hTracker, $$TBM_SETTICFREQ, ticks, 0)
		RETURN $$TRUE
	ENDIF
END FUNCTION
'
' #####################################
' #####  WinXTracker_SetSelRange  #####
' #####################################
' Sets the selection range for a tracker control
' hTracker = the handle to the tracker
' start = the start of the selection
' end  = the end of the selection
' returns bOK: $$TRUE on success
FUNCTION WinXTracker_SetSelRange (hTracker, USHORT start, USHORT end)
	SetLastError (0)
	IF hTracker THEN
		SendMessageA (hTracker, $$TBM_SETSEL, 1, MAKELONG(start, end))
		RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' ##################################
' #####  WinXTreeView_AddItem  #####
' ##################################
' Adds an item to a tree view control
' hTreeView = the handle to the tree view control to add the item to
' hParent = The parent item, 0 or $$TVI_ROOT for root
' hNodeAfter = The node to insert after, can be $$TVI_FIRST or $$TVI_LAST
' iImage = the index of the image for this item
' iImageSel = the index of the image to use when the item is expanded
' label$ = the text for the item
' returns the handle to the item or 0 on fail
'
' Usage:
' hNodeAdd = WinXTreeView_AddItem (hTreeView, hTree_root, $$TVI_LAST, 5, 4, label$)		' add last
' IF hNodeAdd < 0 THEN
'		msg$ = "WinXTreeView_AddItem: Can't add treeview node '" + label$ + "'"
'		XstAlert (msg$)
' ENDIF
'
FUNCTION WinXTreeView_AddItem (hTreeView, hParent, hNodeAfter, iImage, iImageSelect, label$)

	TV_INSERTSTRUCT tvis
	TV_ITEM tvi

	SetLastError (0)
	r_hNode = 0

	IF hTreeView THEN
		IFZ hParent THEN
			hParent = $$TVI_ROOT
			hNodeAfter = $$TVI_LAST
		ENDIF
		tvi.mask = $$TVIF_TEXT|$$TVIF_IMAGE|$$TVIF_SELECTEDIMAGE|$$TVIF_PARAM
		tvi.pszText = &label$
		tvi.cchTextMax = LEN (label$)

		tvi.iImage = iImage
		tvi.iSelectedImage = iImageSelect
		tvi.lParam = 0		' no data
		'
		tvis.hParent = hParent
		tvis.hInsertAfter = hNodeAfter
		tvis.item = tvi
		'
		r_hNode = SendMessageA (hTreeView, $$TVM_INSERTITEM, 0, &tvis)
		IFZ r_hNode THEN
			msg$ = "WinXTreeView_AddItem: Can't add node " + label$
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

	RETURN r_hNode

END FUNCTION
'
' ###################################
' #####  WinXTreeView_CopyItem  #####
' ###################################
'
'	/*
' [WinXTreeView_CopyItem]
' Description = Copy a node and its children.
' Function    = WinXTreeView_CopyItem
' ArgCount    = 4
' Arg1        = hTreeView: the handle to the tree view control
' Arg2        = hNodeParent: the parent of the node to copy this item to
' Arg3        = hNodeAfter: the node that will come before this item
' Arg4        = hNodeOld: the node to copy
' Return      = the new handle to the copied item or 0 on fail
' Remarks     = Uses API call: ret = SendMessageA (hTreeView, wMsg, wParam, lParam)
' See Also    =
' Examples    = new_hNode = WinXTreeView_CopyItem (hTreeView, hNodeParent, hNodeAfter, hNode)
' */
'
FUNCTION WinXTreeView_CopyItem (hTreeView, hNodeParent, hNodeAfter, hNodeOld)
	TV_ITEM tvi
	TV_INSERTSTRUCT tvis

	SetLastError (0)
	r_hNodeNew = 0

	SELECT CASE TRUE
		CASE hTreeView = 0
		CASE hNodeOld <> 0

			' get item hNodeOld
			tvi.mask = $$TVIF_CHILDREN | $$TVIF_HANDLE | $$TVIF_IMAGE | $$TVIF_PARAM | $$TVIF_SELECTEDIMAGE | $$TVIF_STATE | $$TVIF_TEXT
			tvi.hItem = hNodeOld
			tvi.stateMask = 0xFFFFFFFF

			tvi.cchTextMax = $$TextLengthMax
			szBuf$ = NULL$ (tvi.cchTextMax)
			tvi.pszText = &szBuf$

			SetLastError (0)
			ret = SendMessageA (hTreeView, $$TVM_GETITEM, 0, &tvi)
			IFZ ret THEN
				msg$ = "WinXTreeView_CopyItem: Can't get item at node " + STRING$ (hNodeOld)
				GuiTellApiError (msg$)
				EXIT SELECT
			ENDIF

			' insert node
			tvis.hParent = hNodeParent
			tvis.hInsertAfter = hNodeAfter
			tvis.item = tvi
			tvis.item.mask = $$TVIF_IMAGE | $$TVIF_PARAM | $$TVIF_SELECTEDIMAGE | $$TVIF_STATE | $$TVIF_TEXT
			tvis.item.cChildren = 0

			SetLastError (0)
			r_new_handle = SendMessageA (hTreeView, $$TVM_INSERTITEM, 0, &tvis)
			IFZ r_new_handle THEN
				msg$ = "WinXTreeView_CopyItem: Can't insert item after node " + STRING$ (hNodeAfter)
				GuiTellApiError (msg$)
				EXIT SELECT
			ENDIF

			IF tvi.cChildren > 0 THEN
				prevChild = $$TVI_FIRST
				child = WinXTreeView_GetChildItem (hTreeView, hNodeOld)
				DO WHILE child
					WinXTreeView_CopyItem (hTreeView, r_new_handle, prevChild, child)
					prevChild = child
					child = WinXTreeView_GetNextItem (hTreeView, prevChild)
				LOOP
			ENDIF

	END SELECT

	RETURN r_new_handle

END FUNCTION
'
' #####################################
' #####  WinXTreeView_DeleteItem  #####
' #####################################
'
'	/*
' [WinXTreeView_DeleteItem]
' Description = Deletes a node, including all of its children.
' Function    = WinXTreeView_DeleteItem
' ArgCount    = 2
' Arg1        = hTreeView: the handle to the tree view control
' Arg2        = hNode: the handle to the node to delete
' Return      = $$TRUE on success or $$FALSE on fail
' Remarks     = Uses API call: ret = SendMessageA (hTreeView, $$TVM_DELETEITEM, 0, hNode)
' See Also    = All functions prefixed by WinXTreeView_
' Examples    = bOK = WinXTreeView_DeleteItem (hTreeView, hNode)
' */
'
FUNCTION WinXTreeView_DeleteItem (hTreeView, hNode)
	SetLastError (0)
	IF hTreeView THEN
		ret = SendMessageA (hTreeView, $$TVM_DELETEITEM, 0, hNode)
		IF ret THEN
			RETURN $$TRUE
		ELSE
			msg$ = "WinXTreeView_DeleteItem: Can't delete current treeview node " + STRING$ (hNode)
			GuiTellApiError (msg$)
		ENDIF
	ENDIF
END FUNCTION
'
' #######################################
' #####  WinXTreeView_GetChildItem  #####
' #######################################
'
'	/*
' [WinXTreeView_GetChildItem]
' Description = Gets the first child of a tree view node.
' Function    = WinXTreeView_GetChildItem
' ArgCount    = 2
' Arg1        = hTreeView: the handle to the tree view control
' Arg2        = hNode: the node to get the first child from
' Return      = returns the handle to the child item or 0 on fail
' Remarks     = Uses API call: hChild = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_CHILD, hNode)
' See Also    =
' Examples    = hChild = WinXTreeView_GetChildItem (hTreeView, hNode)
' */
'
FUNCTION WinXTreeView_GetChildItem (hTreeView, hNode)
	SetLastError (0)
	IF hTreeView THEN
		RETURN SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_CHILD, hNode)
	ENDIF
END FUNCTION
'
' ###########################################
' #####  WinXTreeView_GetItemFromPoint  #####
' ###########################################
'
'	/*
' [WinXTreeView_GetItemFromPoint]
' Description = Gets a tree view node given its coordinates.
' Function    = WinXTreeView_GetItemFromPoint
' ArgCount    = 3
' Arg1        = hTreeView: the handle to the tree view control to get the item from
' Arg2        = x: the x coordinate
' Arg3        = y: the y coordinate
' Return      = returns a node handle or 0 on fail
' Remarks     = Uses API call: index = SendMessageA (hTreeView, $$TVM_HITTEST, 0, &tvHit)
' See Also    =
' Examples    = hNode = WinXTreeView_GetItemFromPoint (hTreeView, x, y)
' */
'
FUNCTION WinXTreeView_GetItemFromPoint (hTreeView, x, y)
	TV_HITTESTINFO tvHit

	SetLastError (0)
	IF hTreeView THEN
		tvHit.pt.x = x
		tvHit.pt.y = y
		hNode = SendMessageA (hTreeView, $$TVM_HITTEST, 0, &tvHit)
		IF hNode THEN
			RETURN hNode
		ELSE
			msg$ = "WinXTreeView_GetItemFromPoint: Can't get the handle tree view node from coordinates x = " + STRING$ (x) + " and y = " + STRING$ (y)
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

END FUNCTION
'
' ########################################
' #####  WinXTreeView_GetItemLabel$  #####
' ########################################
'
'	/*
' [WinXTreeView_GetItemLabel$]
' Description = Gets the label from a node.
' Function    = WinXTreeView_GetItemLabel$
' ArgCount    = 2
' Arg1        = hTreeView: the handle to the tree view control
' Arg2        = hNode: the node to get the label from
' Return      = the node label or an empty string on fail
' Remarks     = Uses API call: ret = SendMessageA (hTreeView, $$TVM_GETITEM, 0, &tvi)
' See Also    = All functions prefixed by WinXTreeView_
' Examples    = label$ = WinXTreeView_GetItemLabel$ (hTreeView, hNode)
' */
'
FUNCTION WinXTreeView_GetItemLabel$ (hTreeView, hNode)

	TVITEM tvi

	SetLastError (0)
	IF hTreeView THEN
		tvi.mask = $$TVIF_HANDLE|$$TVIF_TEXT
		tvi.hItem = hNode
		tvi.cchTextMax = $$TextLengthMax
		szBuf$ = NULL$ (tvi.cchTextMax)
		tvi.pszText = &szBuf$

		ret = SendMessageA (hTreeView, $$TVM_GETITEM, 0, &tvi)
'
' $$TextLengthMax too small+++
		IF ret >= $$TextLengthMax THEN
'			msg$ = "WinXTreeView_GetItemLabel$-Bug?: ret =" + STR$(ret) + " >=" + STR$ ($$TextLengthMax) + " ($$TextLengthMax)"
'			GuiAlert (msg$, "")
			'
			tvi.cchTextMax = ret
			szBuf$ = NULL$ (tvi.cchTextMax)
			tvi.pszText = &szBuf$
			ret = SendMessageA (hTreeView, $$TVM_GETITEM, 0, &tvi)
		ENDIF
' $$TextLengthMax too small~~~
'
		IF ret THEN
			ret$ = CSTRING$ (&szBuf$)
			RETURN ret$
		ELSE
			msg$ = "WinXTreeView_GetItemLabel$: Can't get the label from from node, handle " + STRING$ (hNode)
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

END FUNCTION
'
' ######################################
' #####  WinXTreeView_GetNextItem  #####
' ######################################
'
'	/*
' [WinXTreeView_GetNextItem]
' Description = Gets the next node in the tree view.
' Function    = WinXTreeView_GetNextItem
' ArgCount    = 2
' Arg1        = hTreeView: the handle to the tree view control
' Arg2        = hNode: the handle to the node to set the selection to, 0 to remove selection
' Return      = the handle of the next node or 0 on fail
' Remarks     = Uses API call: ret = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_NEXT, hNode)
' See Also    =
' Examples    = bOK = WinXTreeView_GetNextItem (hTreeView, hNode)
' */
'
FUNCTION WinXTreeView_GetNextItem (hTreeView, hNode)
	SetLastError (0)
	IF hTreeView THEN
		RETURN SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_NEXT, hNode)
	ENDIF
END FUNCTION
'
' ########################################
' #####  WinXTreeView_GetParentItem  #####
' ########################################
'
'	/*
' [WinXTreeView_GetParentItem]
' Description = Gets the parent of an node in a tree view.
' Function    = WinXTreeView_GetParentItem
' ArgCount    = 2
' Arg1        = hTreeView: the handle to the tree view control
' Arg2        = hNode: the node just after the node of interest
' Return      = $$TRUE on success or $$FALSE on fail
' Remarks     =
' See Also    = All functions prefixed by WinXTreeView_
' Examples    = bOK = WinXTreeView_GetParentItem (hTreeView, hNode)
' */
'
FUNCTION WinXTreeView_GetParentItem (hTreeView, hNode)
	SetLastError (0)
	IF hTreeView THEN
		RETURN SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_PARENT, hNode)
	ENDIF
END FUNCTION
'
' ##########################################
' #####  WinXTreeView_GetPreviousItem  #####
' ##########################################
'
'	/*
' [WinXTreeView_GetPreviousItem]
' Description = Gets the node that comes before a tree view node.
' Function    = WinXTreeView_GetPreviousItem()
' ArgCount    = 2
' Arg1        = hTreeView: the handle to the tree view control
' Arg2        = hNode: the node just after the node of interest
' Return      = the handle to the previous node or 0 on fail
' Remarks     =
' See Also    = All functions prefixed by WinXTreeView_
' Examples    = bOK = WinXTreeView_GetPreviousItem (hTreeView, hNode)
' */
'
FUNCTION WinXTreeView_GetPreviousItem (hTreeView, hNode)
	SetLastError (0)
	IF hTreeView THEN
		RETURN SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_PREVIOUS, hNode)
	ENDIF
END FUNCTION
'
' ######################################
' #####  WinXTreeView_GetRootItem  #####
' ######################################
'
'	/*
' [WinXTreeView_GetRootItem]
' Description = Gets a handle to the tree view root.
' Function    = WinXTreeView_GetRootItem()
' ArgCount    = 1
' Arg1        = hTreeView: the handle to the tree view control
' Return      = the treeview root handle on success or 0 on fail
' Remarks     = Uses API call: hRoot = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_ROOT, 0)
' See Also    = All functions prefixed by WinXTreeView_
' Examples    = hRoot = WinXTreeView_GetRootItem (hTreeView)
' */
'
FUNCTION WinXTreeView_GetRootItem (hTreeView)
	SetLastError (0)
	IF hTreeView THEN
		r_hRoot = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_ROOT, 0)
		IF r_hRoot THEN
			RETURN r_hRoot
		ELSE
			msg$ = "WinXTreeView_GetRootItem: Can't get root node"
			GuiTellApiError (msg$)
		ENDIF
	ENDIF
END FUNCTION
'
' #######################################
' #####  WinXTreeView_GetSelection  #####
' #######################################
'
'	/*
' [WinXTreeView_GetSelection]
' Description = Gets the current selection from a tree view control.
' Function    = WinXTreeView_GetSelection()
' ArgCount    = 1
' Arg1        = hTreeView: the handle to the tree view control
' Return      = $$TRUE on success or $$FALSE on fail
' Remarks     = Uses API call: hNode = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_CARET, 0)
' See Also    = All functions prefixed by WinXTreeView_
' Examples    = hNode = WinXTreeView_GetSelection (hTreeView)
' */
'
FUNCTION WinXTreeView_GetSelection (hTreeView)
	SetLastError (0)
	IF hTreeView THEN
		hNode = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_CARET, 0)
		RETURN hNode
	ENDIF
END FUNCTION
'
' #######################################
' #####  WinXTreeView_SetItemLabel  #####
' #######################################
'
'	/*
' [WinXTreeView_SetItemLabel]
' Description = Sets the label attribute of the passed tree view node.
' Function    = WinXTreeView_SetItemLabel()
' ArgCount    = 3
' Arg1        = hTreeView: the handle to the tree view control
' Arg2        = hNode: the handle to the node to set the selection to, 0 to remove selection
' Arg3        = newLabel$: the new text
' Return      = $$TRUE on success or $$FALSE on fail
' Remarks     = Uses API call: ret = SendMessageA (hTreeView, $$TVM_SETITEM, 0, &tvi)
' See Also    = All functions prefixed by WinXTreeView_
' Examples    = bOK = WinXTreeView_SetItemLabel (hTreeView, hNode, newLabel$)
' */
'
FUNCTION WinXTreeView_SetItemLabel (hTreeView, hNode, newLabel$)

	TVITEM tvi

	SetLastError (0)
	IF hTreeView THEN
		tvi.mask = $$TVIF_HANDLE|$$TVIF_TEXT
		tvi.hItem = hNode
		tvi.pszText = &newLabel$
		tvi.cchTextMax = LEN (newLabel$)
		ret = SendMessageA (hTreeView, $$TVM_SETITEM, 0, &tvi)
		IF ret THEN
			RETURN $$TRUE
		ELSE
			msg$ = "WinXTreeView_SetItemLabel: Can't set the node's label " + newLabel$
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

END FUNCTION
'
' #######################################
' #####  WinXTreeView_SetSelection  #####
' #######################################
'
'	/*
' [WinXTreeView_SetSelection]
' Description = Sets the selection for a tree view control.
' Function    = WinXTreeView_SetSelection()
' ArgCount    = 2
' Arg1        = hTreeView: the handle to the tree view control
' Arg2        = hNode: the handle to the node to set the selection to, 0 to remove selection
' Return      = $$TRUE on success or $$FALSE on fail
' Remarks     = Uses API call: ret = SendMessageA (hTreeView, $$TVM_SELECTITEM, $$TVGN_CARET, hNode)
' See Also    = All functions prefixed by WinXTreeView_
' Examples    = bOK = WinXTreeView_SetSelection (hTreeView, hNode)
' */
'
FUNCTION WinXTreeView_SetSelection (hTreeView, hNode)
	SetLastError (0)
	IF hTreeView THEN
		IFZ hNode THEN
			hNode = WinXTreeView_GetRootItem (hTreeView)
		ENDIF
		SetLastError (0)
		ret = SendMessageA (hTreeView, $$TVM_SELECTITEM, $$TVGN_CARET, hNode)
		IF ret THEN
			SetFocus (hTreeView)
			RETURN $$TRUE
		ENDIF
	ENDIF
END FUNCTION
'
' ##########################
' #####  WinXVersion$  #####
' ##########################
'
'	/*
' [WinXVersion$]
' Description = Gets library WinX's current version.
' Function    = WinXVersion$()
' ArgCount    = 0
' Return      = WinX's current version
' Examples    = version$ = WinXVersion$ ()
' */
'
FUNCTION WinXVersion$ ()
	version$ = VERSION$ (0)
	RETURN (version$)
END FUNCTION
'
'A wrapper for the misdefined AlphaBlend function.
'
FUNCTION ApiAlphaBlend (hdcDest, nXOriginDest, nYOrigDest, nWidthDest, nHeightDest, hdcSrc, nXOriginSrc, nYOriginSrc, nWidthSrc, nHeightSrc, BLENDFUNCTION blendFunction)

	SetLastError (0)
	DIM args[10]

	args[0] = hdcDest
	args[1] = nXOriginDest
	args[2] = nYOrigDest
	args[3] = nWidthDest
	args[4] = nHeightDest
	args[5] = hdcSrc
	args[6] = nXOriginSrc
	args[7] = nYOriginSrc
	args[8] = nWidthSrc
	args[9] = nHeightSrc
	args[10] = XLONGAT (&blendFunction)

	ret = XstCall ("AlphaBlend", "msimg32.dll", @args[])
	RETURN ret
END FUNCTION
'
' A wrapper for the troublesome LBItemFromPt function.
'
FUNCTION ApiLBItemFromPt (hLB, x, y, bAutoScroll)
	XLONG args[3]

	SetLastError (0)
	args[0] = hLB
	args[1] = x
	args[2] = y
	args[3] = bAutoScroll
	item = XstCall ("LBItemFromPt", "comctl32.dll", @args[])

	RETURN item

END FUNCTION
'
' ############################
' #####  CompareLVItems  #####
' ############################
' Compares two listview items
FUNCTION CompareLVItems (item1, item2, hLV)
	SHARED #lvs_column_index
	SHARED #lvs_decreasing

	LV_ITEM lvi		' listview item

	SetLastError (0)
'
' first item
'
	index = iItem1
	GOSUB GetItemText
	a$ = CSTRING$ (&szBuf$)
'
' second item
'
	index = iItem2
	GOSUB GetItemText
	b$ = CSTRING$ (&szBuf$)

	szBuf$ = ""

	ret = 0
	upp = MIN (LEN (a$), LEN (b$))		' include zero-terminator
	FOR i = 0 TO upp
		IF a${i} < b${i} THEN
			ret = -1
			EXIT FOR
		ENDIF
		IF a${i} > b${i} THEN
			ret = 1
			EXIT FOR
		ENDIF
	NEXT i

	IFZ ret THEN
		IF LEN (a$) < LEN (b$) THEN ret = -1
		IF LEN (a$) > LEN (b$) THEN ret =  1
	ENDIF

	IF #lvs_decreasing THEN ret = -ret
	RETURN ret

SUB GetItemText

	lvi.mask = $$LVIF_TEXT
	lvi.cchTextMax = $$TextLengthMax
	szBuf$ = NULL$ (lvi.cchTextMax)
	lvi.pszText = &szBuf$
	lvi.iItem = item1
	lvi.iSubItem = #lvs_column_index & 0x7FFFFFFF

	SetLastError (0)
	ret = SendMessageA (hLV, $$LVM_GETITEM, index, &lvi)
	IFZ ret THEN
		msg$ = "CompareLVItems: Can't get the data of list view item"
		GuiTellApiError (msg$)
		EXIT SUB
	ENDIF
'
' $$TextLengthMax too small+++
	sizeBuf = $$TextLengthMax
	DO WHILE ret
		text$ = CSTRING$ (lvi.pszText)
		IF LEN (text$) < sizeBuf THEN EXIT DO		' the API buffer could hold the text

		' increase the size of the API buffer
		sizeBuf = sizeBuf + $$TextLengthMax - 1
		szBuf$ = NULL$ (sizeBuf)
		lvi.pszText = &szBuf$

		SetLastError (0)
		ret = SendMessageA (hLV, $$LVM_GETITEM, index, &lvi)
	LOOP
' $$TextLengthMax too small~~~
'
END SUB

END FUNCTION
'
' ############################
' #####  Delete_binding  #####
' ############################
' Deletes a binding from the binding table
' "overloading" binding_delete
' idBinding = id of the binding to delete
' returns bOK: $$TRUE on success
FUNCTION Delete_binding (idBinding)
	BINDING binding
	LINKEDLIST autoDrawList

	bOK = binding_get (@idBinding, @binding)

	SELECT CASE bOK
		CASE $$TRUE
			IFZ binding.hWnd THEN EXIT SELECT

			' destroy accelerator table
			IF binding.hAccelTable THEN DestroyAcceleratorTable (binding.hAccelTable)
			binding.hAccelTable = 0

			' delete the auto drawer info
			autoDraw_clear (binding.autoDrawInfo)
			LINKEDLIST_Get (binding.autoDrawInfo, @autoDrawList)
			LinkedList_Uninit (@autoDrawList)
			LINKEDLIST_Delete (binding.autoDrawInfo)

			' delete the message handlers
			handlerGroup_delete (binding.msgHandlers)

			' delete the auto sizer info
			autoSizerGroup_delete (binding.autoSizerInfo)

			bOK = binding_delete (idBinding)

	END SELECT

	RETURN bOK

END FUNCTION
'
' #########################
' #####  Get_binding  #####
' #########################
' Gets data of a binding accessed by its id
' "overloading" binding_get
' hWnd = handle to the window
' idBinding = returned id of binding
' binding = returned data
' returns bOK: $$TRUE on success
FUNCTION Get_binding (hWnd, @idBinding, BINDING binding)
	BINDING item_null

	SetLastError (0)
	bOK = $$FALSE
	idBinding = 0

	IF hWnd THEN
		idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
		bOK = binding_get (idBinding, @binding)
	ENDIF

	IFF bOK THEN
		' binding is reset on fail
		binding = item_null
	ENDIF

	RETURN bOK
END FUNCTION
'
' ######################
' #####  GuiAlert  #####
' ######################
' Displays an alert.
' msg$   = the text to display
' title$ = the dialog's title
FUNCTION GuiAlert (msg$, title$)
	IFZ TRIM$(title$) THEN title$ = "WinX-Alert"
	hwnd = GetActiveWindow ()
	MessageBoxA (hwnd, &msg$, &title$, $$MB_ICONSTOP)
END FUNCTION
'
' #############################
' #####  GuiTellApiError  #####
' #############################
' Displays a WinAPI error message.
' returns bErr: $$TRUE only if an error REALLY occurred.
FUNCTION GuiTellApiError (msg$)

	' get the last error code, then clear it
	errNum = GetLastError ()
	SetLastError (0)
	IFZ errNum THEN RETURN		' was OK!

	fmtMsg$ = "Last error code " + STRING$ (errNum) + ": "

	' set up FormatMessageA arguments
	dwFlags = $$FORMAT_MESSAGE_FROM_SYSTEM|$$FORMAT_MESSAGE_IGNORE_INSERTS
	sizeBuf = 1020 : szBuf$ = NULL$ (sizeBuf)
	ret = FormatMessageA (dwFlags, 0, errNum, 0, &szBuf$, sizeBuf, 0)
	IFZ ret THEN
		fmtMsg$ = fmtMsg$ + "(unknown)"
	ELSE
		fmtMsg$ = fmtMsg$ + CSTRING$ (&szBuf$)
	ENDIF

	IFZ msg$ THEN msg$ = "Windows API error"
	fmtMsg$ = fmtMsg$ + "\r\n\r\n" + msg$

	' get the OS name and version
	bErr = XstGetOSName (@osName$)
	IF bErr THEN
		text$ = "(unknown)"
	ELSE
		IFZ osName$ THEN osName$ = "(unknown)"
		text$ = osName$ + " ver "
		bErr = XstGetOSVersion (@major, @minor, @platformId, @version$, @platform$)
		IF bErr THEN
			text$ = text$ + " (unknown)"
		ELSE
			text$ = text$ + STR$ (major) + "." + STRING$ (minor) + "-" + platform$
		ENDIF
	ENDIF
	fmtMsg$ = fmtMsg$ + "\r\n\r\nOS: " + text$
	? fmtMsg$		' output message to an active console

	title$ = "WinX-API Error"
	hwnd = GetActiveWindow ()
	MessageBoxA (hwnd, &fmtMsg$, &title$, $$MB_ICONSTOP)

	RETURN $$TRUE		' an error really occurred!

END FUNCTION
'
' ################################
' #####  GuiTellDialogError  #####
' ################################
' Debugging function for Windows standard dialogs WinXDialog_*'s:
' calls CommDlgExtendedError to get error code
' and displays the formatted run-time error message.
FUNCTION GuiTellDialogError (hOwner, title$)

	IFZ TRIM$ (title$) THEN title$ = "WinX-Standard Dialog Error"

	' call CommDlgExtendedError to get error code
	extErr = CommDlgExtendedError ()

	SELECT CASE extErr
		CASE 0
			' fmtMsg$ = "Cancel pressed, no error"
			RETURN		' don't display fmtMsg$

		CASE $$CDERR_DIALOGFAILURE   : fmtMsg$ = "Can't create the dialog box"
		CASE $$CDERR_FINDRESFAILURE  : fmtMsg$ = "Resource missing"
		CASE $$CDERR_NOHINSTANCE     : fmtMsg$ = "Instance handle missing"
		CASE $$CDERR_INITIALIZATION  : fmtMsg$ = "Can't initialize. Possibly out of memory"
		CASE $$CDERR_NOHOOK          : fmtMsg$ = "Hook procedure missing"
		CASE $$CDERR_LOCKRESFAILURE  : fmtMsg$ = "Can't lock a resource"
		CASE $$CDERR_NOTEMPLATE      : fmtMsg$ = "Template missing"
		CASE $$CDERR_LOADRESFAILURE  : fmtMsg$ = "Can't load a resource"
		CASE $$CDERR_STRUCTSIZE      : fmtMsg$ = "Internal error - invalid struct size"
		CASE $$CDERR_LOADSTRFAILURE  : fmtMsg$ = "Can't load a string"
		CASE $$CDERR_MEMALLOCFAILURE : fmtMsg$ = "Can't allocate memory for internal dialog structures"
		CASE $$CDERR_MEMLOCKFAILURE  : fmtMsg$ = "Can't lock memory"

		CASE ELSE : fmtMsg$ = "Unknown error code"
	END SELECT

	fmtMsg$ = "GuiTellDialogError: Last error code " + STRING$ (extErr) + ": " + fmtMsg$

	IFZ hOwner THEN hOwner = GetActiveWindow ()
	MessageBoxA (hOwner, &fmtMsg$, &title$, $$MB_ICONSTOP)

	RETURN $$TRUE		' an error really occurred!

END FUNCTION
'
' #############################
' #####  GuiTellRunError  #####
' #############################
'
' Displays a run-time error message.
'
' returns $$TRUE only if an error really occurred.
'
FUNCTION GuiTellRunError (msg$)

	' get current error, then clear it
	errNum = ERROR ($$FALSE)
	IFZ errNum THEN
		bErr = $$FALSE		' was OK!
	ELSE
		bErr = $$TRUE		' an error really occurred!
		'
		fmtMsg$ = "Error code " + STRING$ (errNum) + ", " + ERROR$ (errNum)
		'
		IFZ msg$ THEN msg$ = "XBLite library error"
		fmtMsg$ = fmtMsg$ + "\r\n\r\n" + msg$
		PRINT fmtMsg$		' output message to an active console
		'
		title$ = "WinX-XBLite Error"
		hwnd = GetActiveWindow ()
		MessageBoxA (hwnd, &fmtMsg$, &title$, $$MB_ICONSTOP)
	ENDIF

	RETURN bErr

END FUNCTION
'
' ######################
' #####  NewChild  #####
' ######################
' Creates a child window.
FUNCTION NewChild (class$, text$, style, x, y, w, h, hParent, idCtr, exStyle)
	SHARED hInst		' instance handle
	SHARED hFontDefault

	SetLastError (0)
	IFZ hInst THEN
		hInst = GetModuleHandleA (0)		' Unlikely!
	ENDIF

	IFZ hParent THEN
		msg$ = "NewChild: Can't create the child window '" + text$ + "', control class '" + class$ + "'"
		msg$ = msg$ + "\r\nNull handle to the parent window."
		GuiAlert (msg$, "")
		RETURN		' fail
	ENDIF

	' create the child window
	style = style|$$WS_CHILD|$$WS_VISIBLE

	hCtr = CreateWindowExA (exStyle, &class$, &text$, style, x, y, w, h, hParent, idCtr, hInst, 0)
	IFZ hCtr THEN
		msg$ = "NewChild: Can't create the child window '" + text$ + "', control class '" + class$ + "'"
		GuiTellApiError (msg$)
		RETURN		' fail
	ENDIF

	' create default font
	IFZ hFontDefault THEN
		hFontDefault = GetStockObject ($$ANSI_VAR_FONT)
	ENDIF

	SendMessageA (hCtr, $$WM_SETFONT, hFontDefault, 1)		' redraw
	RETURN hCtr

END FUNCTION
'
' #######################
' #####  NewWindow  #####
' #######################
' Creates a window.
FUNCTION NewWindow (class$, title$, style, x, y, w, h, exStyle)
	SHARED hInst		' instance handle

	SetLastError (0)
	IFZ hInst THEN
		hInst = GetModuleHandleA (0)		' Unlikely!
	ENDIF
	hWnd = CreateWindowExA (exStyle, &class$, &title$, style, x, y, w, h, 0, 0, hInst, 0)
	IFZ hWnd THEN
		msg$ = "NewWindow: Can't create the window, window class " + class$
		GuiTellApiError (msg$)
	ENDIF

	RETURN hWnd

END FUNCTION
'
' #############################
' #####  STRING_Extract$  #####
' #############################
'
' Extracts a sub-string.
' text$ = the text
' start = starting position
' end   = ending position
'
FUNCTION STRING_Extract$ (text$, start, end)

	IF start < 1 THEN start = 1

	IF end < start THEN end = LEN (text$)
	IF end > LEN (text$) THEN end = LEN (text$)

	IF end < start THEN
		ret$ = ""
	ELSE
		length = end - start + 1
		ret$ = TRIM$ (MID$ (text$, start, length))
	ENDIF

	RETURN ret$

END FUNCTION
'
' ######################
' #####  XWSStoWS  #####
' ######################
' Convert a simplified window style to a window style
' xwss = the simplified style
' returns a window style.
FUNCTION XWSStoWS (xwss)
	SELECT CASE xwss
		CASE $$XWSS_APP          : style = $$WS_OVERLAPPEDWINDOW
		CASE $$XWSS_APPNORESIZE  : style = $$WS_OVERLAPPED|$$WS_CAPTION|$$WS_SYSMENU|$$WS_MINIMIZEBOX
		CASE $$XWSS_POPUP        : style = $$WS_POPUPWINDOW|$$WS_CAPTION
		CASE $$XWSS_POPUPNOTITLE : style = $$WS_POPUPWINDOW
		CASE $$XWSS_NOBORDER     : style = $$WS_POPUP
		CASE ELSE                : style = 0
	END SELECT
	RETURN style
END FUNCTION
'
' ##########################
' #####  autoDraw_add  #####
' ##########################
FUNCTION autoDraw_add (idList, iData)
	LINKEDLIST autoDrawList

	slot = -1
	bOK = LINKEDLIST_Get (idList, @autoDrawList)
	IF bOK THEN
		LinkedList_Append (@autoDrawList, iData)
		bOK = LINKEDLIST_Update (idList, autoDrawList)
		IF bOK THEN
			slot = autoDrawList.cItems - 1
		ENDIF
	ENDIF
	RETURN slot

END FUNCTION
'
' ############################
' #####  autoDraw_clear  #####
' ############################
' Clears out all the auto drawer records in a group
' idList = the group to clear
' returns bOK: $$TRUE on success
FUNCTION autoDraw_clear (idList)
	LINKEDLIST list
	AUTODRAWRECORD record

	IF LINKEDLIST_Get (idList, @list) THEN
		hWalk = LinkedList_StartWalk (list)

		DO WHILE LinkedList_Walk (hWalk, @iData)
			AUTODRAWRECORD_Get (iData, @record)
'
' 0.6.0.2-old---
'			IF record.draw = &drawText () THEN
'				STRING_Delete (record.text.iString)
'			ENDIF
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			IF record.text.iString THEN
				STRING_Delete (record.text.iString)
				record.text.iString = 0
			ENDIF
' 0.6.0.2-new~~~
'
			DeleteObject (record.hUpdateRegion)
			record.hUpdateRegion = 0
			AUTODRAWRECORD_Delete (iData)
		LOOP
		LinkedList_EndWalk (hWalk)
		LinkedList_DeleteAll (@list)

		LINKEDLIST_Update (idList, list)

		RETURN $$TRUE		' success
	ENDIF

END FUNCTION
'
' ###########################
' #####  autoDraw_draw  #####
' ###########################
' Draws the auto drawer records
' hdc = the dc to draw to
' idList = the group of records to draw
' returns bOK: $$TRUE on success
FUNCTION autoDraw_draw (hdc, idList, x0, y0)
	LINKEDLIST autoDrawList
	AUTODRAWRECORD record

	bOK = $$FALSE

	SELECT CASE hdc
		CASE 0
		CASE ELSE
			IFF LINKEDLIST_Get (idList, @autoDrawList) THEN EXIT SELECT

			hPen = 0
			hBrush = 0
			hFont = 0

			hWalk = LinkedList_StartWalk (autoDrawList)
			DO WHILE LinkedList_Walk (hWalk, @iData)
				AUTODRAWRECORD_Get (iData, @record)

				SELECT CASE record.hPen
					CASE 0, hPen
					CASE ELSE		' IF record.hPen != 0 && record.hPen != hPen THEN
						hPen = record.hPen
						SelectObject (hdc, hPen)
				END SELECT

				SELECT CASE record.hBrush
					CASE 0, hBrush
					CASE ELSE		' IF record.hBrush != 0 && record.hBrush != hBrush THEN
						hBrush = record.hBrush
						SelectObject (hdc, hBrush)
				END SELECT

				SELECT CASE record.hFont
					CASE 0, hFont
					CASE ELSE		' IF record.hFont != 0 && record.hFont != hFont THEN
						hFont = record.hFont
						SelectObject (hdc, hFont)
				END SELECT

				IF record.toDelete THEN
'
' GL-31oct19-Note+++
' WinXDraw_Clear is supposed to clear all the graphics in a window;
' code for "erase previously displayed text" missing here?
' (see my note in text.x demo)
' GL-31oct19-Note~~~
'
					AUTODRAWRECORD_Delete (iData)
					LinkedList_DeleteThis (hWalk, @autoDrawList)
				ELSE
					@record.draw (hdc, record, x0, y0)
				ENDIF
			LOOP
			LinkedList_EndWalk (hWalk)

			bOK = $$TRUE		' success

	END SELECT

	RETURN bOK

END FUNCTION
'
' #######################
' #####  autoSizer  #####
' #######################
' The auto sizer function, resizes child windows
FUNCTION autoSizer (AUTOSIZERINFO	sizerBlock, direction, x0, y0, nw, nh, currPos)
	RECT rect
	SPLITTERINFO splitterInfo
	FUNCADDR leftInfo (XLONG, XLONG)
	FUNCADDR rightInfo (XLONG, XLONG)

	'if there is an info block, here, resize the window
	IFZ sizerBlock.hWnd THEN RETURN
'
' Calculate the SIZE.
'
	'first, the x, y, w and h of the box
	SELECT CASE direction AND 0x00000003
		CASE $$DIR_VERT
			IF sizerBlock.space <= 1 THEN sizerBlock.space = sizerBlock.space*nh

			IF sizerBlock.flags AND $$SIZER_SIZERELREST THEN
				IF direction AND $$DIR_REVERSE THEN rest = currPos ELSE rest = nh-currPos
				IF sizerBlock.size <= 1 THEN sizerBlock.size = sizerBlock.size*rest ELSE sizerBlock.size = rest-sizerBlock.size
				sizerBlock.size = sizerBlock.size-sizerBlock.space
			ELSE
				IF sizerBlock.size <= 1 THEN sizerBlock.size = sizerBlock.size*nh
			ENDIF

			IF sizerBlock.x <= 1 THEN sizerBlock.x = sizerBlock.x*nw
			IF sizerBlock.y <= 1 THEN sizerBlock.y = sizerBlock.y*sizerBlock.size
			IF sizerBlock.w <= 1 THEN sizerBlock.w = sizerBlock.w*nw
			IF sizerBlock.h <= 1 THEN sizerBlock.h = sizerBlock.h*sizerBlock.size

			boxX = x0
			boxY = y0+currPos+sizerBlock.space
			boxW = nw
			boxH = sizerBlock.size

			IF sizerBlock.flags AND $$SIZER_SPLITTER THEN
				boxH = boxH-8
				sizerBlock.h = sizerBlock.h - 8

				IF direction AND $$DIR_REVERSE THEN h = boxY-boxH-8 ELSE h = boxY+boxH
				MoveWindow (sizerBlock.hSplitter, boxX, h, boxW, 8, $$FALSE)
				InvalidateRect (sizerBlock.hSplitter, 0, 1)		' erase

				idSplitter = GetWindowLongA (sizerBlock.hSplitter, $$GWL_USERDATA)
				SPLITTERINFO_Get (idSplitter, @splitterInfo)
				IF direction AND $$DIR_REVERSE THEN splitterInfo.maxSize = currPos-sizerBlock.space ELSE splitterInfo.maxSize = nh-currPos-sizerBlock.space
				SPLITTERINFO_Update (idSplitter, splitterInfo)
			ENDIF

			IF direction AND $$DIR_REVERSE THEN boxY = boxY-boxH

		CASE $$DIR_HORIZ
			IF sizerBlock.space <= 1 THEN sizerBlock.space = sizerBlock.space*nw

			IF sizerBlock.flags AND $$SIZER_SIZERELREST THEN
				IF direction AND $$DIR_REVERSE THEN rest = currPos ELSE rest = nw-currPos
				IF sizerBlock.size <= 1 THEN sizerBlock.size = sizerBlock.size*rest ELSE sizerBlock.size = rest-sizerBlock.size
				sizerBlock.size = sizerBlock.size-sizerBlock.space
			ELSE
				IF sizerBlock.size <= 1 THEN sizerBlock.size = sizerBlock.size*nw
			ENDIF

			IF sizerBlock.x <= 1 THEN sizerBlock.x = sizerBlock.x*sizerBlock.size
			IF sizerBlock.y <= 1 THEN sizerBlock.y = sizerBlock.y*nh
			IF sizerBlock.w <= 1 THEN sizerBlock.w = sizerBlock.w*sizerBlock.size
			IF sizerBlock.h <= 1 THEN sizerBlock.h = sizerBlock.h*nh
			boxX = x0+currPos+sizerBlock.space
			boxY = y0
			boxW = sizerBlock.size
			boxH = nh

			IF sizerBlock.flags AND $$SIZER_SPLITTER THEN
				boxW = boxW-8
				sizerBlock.w = sizerBlock.w - 8

				IF direction AND $$DIR_REVERSE THEN h = boxX-boxW-8 ELSE h = boxX+boxW
				MoveWindow (sizerBlock.hSplitter, h, boxY, 8, boxH, $$FALSE)
				InvalidateRect (sizerBlock.hSplitter, 0, 1)		' erase

				idSplitter = GetWindowLongA (sizerBlock.hSplitter, $$GWL_USERDATA)
				SPLITTERINFO_Get (idSplitter, @splitterInfo)
				IF direction AND $$DIR_REVERSE THEN splitterInfo.maxSize = currPos-sizerBlock.space ELSE splitterInfo.maxSize = nw-currPos-sizerBlock.space
				SPLITTERINFO_Update (idSplitter, splitterInfo)
			ENDIF

			IF direction AND $$DIR_REVERSE THEN boxX = boxX-boxW

	END SELECT

	'adjust the width and height as necessary
	IF sizerBlock.flags AND $$SIZER_WCOMPLEMENT THEN sizerBlock.w = boxW-sizerBlock.w
	IF sizerBlock.flags AND $$SIZER_HCOMPLEMENT THEN sizerBlock.h = boxH-sizerBlock.h

	'adjust x and y
	IF sizerBlock.x < 0 THEN
		sizerBlock.x = (boxW-sizerBlock.w)\2
	ELSE
		IF sizerBlock.flags AND $$SIZER_XRELRIGHT THEN sizerBlock.x = boxW-sizerBlock.x
	ENDIF
	IF sizerBlock.y < 0 THEN
		sizerBlock.y = (boxH-sizerBlock.h)\2
	ELSE
		IF sizerBlock.flags AND $$SIZER_YRELBOTTOM THEN sizerBlock.y = boxH-sizerBlock.y
	ENDIF

	IF sizerBlock.flags AND $$SIZER_SERIES THEN
		autoSizerGroup_size (sizerBlock.hWnd, sizerBlock.x+boxX, sizerBlock.y+boxY, sizerBlock.w, sizerBlock.h)
	ELSE
		' Actually size the control
		IF (sizerBlock.w<1) || (sizerBlock.h<1) THEN
			ShowWindow (sizerBlock.hWnd, $$SW_HIDE)
		ELSE
			ShowWindow (sizerBlock.hWnd, $$SW_SHOW)
			MoveWindow (sizerBlock.hWnd, sizerBlock.x+boxX, sizerBlock.y+boxY, sizerBlock.w, sizerBlock.h, $$TRUE)
		ENDIF

		leftInfo = GetPropA (sizerBlock.hWnd, &$$LeftSubSizer$)
		rightInfo = GetPropA (sizerBlock.hWnd, &$$RightSubSizer$)
		IF leftInfo THEN
			series = @leftInfo(sizerBlock.hWnd, &rect)
			autoSizerGroup_size (series, sizerBlock.x+boxX+rect.left, sizerBlock.y+boxY+rect.top, (rect.right-rect.left), (rect.bottom-rect.top))
		ENDIF
		IF rightInfo THEN
			series = @rightInfo(sizerBlock.hWnd, &rect)
			autoSizerGroup_size (series, sizerBlock.x+boxX+rect.left, _
			sizerBlock.y+boxY+rect.top, (rect.right-rect.left), (rect.bottom-rect.top))
		ENDIF
	ENDIF

	IF direction AND $$DIR_REVERSE THEN
		currPosNew = currPos-sizerBlock.space-sizerBlock.size
	ELSE
		currPosNew = currPos+sizerBlock.space+sizerBlock.size
	ENDIF
	RETURN currPosNew

END FUNCTION
'
' ################################
' #####  autoSizerGroup_add  #####
' ################################
' Adds a new group of auto sizer info blocks
' returns the index of the new group or -1 on fail
FUNCTION autoSizerGroup_add (direction)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	AUTOSIZERINFO autoSizerInfoLocal[]

	'look for a blank slot
	slot = -1
	upp = UBOUND(autoSizerInfoUM[])
	FOR i = 0 TO upp
		IFF autoSizerInfoUM[i].inUse THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	'allocate more memory if needed
	IF slot < 0 THEN
		slot = UBOUND(autoSizerInfoUM[])+1
		upper_slot = (slot<<1)|3
		REDIM autoSizerInfoUM[upper_slot]
		REDIM autoSizerInfo[upper_slot,]
	ENDIF

	autoSizerInfoUM[slot].inUse = $$TRUE
	autoSizerInfoUM[slot].direction = direction
	autoSizerInfoUM[slot].iHead = -1
	autoSizerInfoUM[slot].iTail = -1

	DIM autoSizerInfoLocal[0]
	SWAP autoSizerInfoLocal[], autoSizerInfo[slot,]

	RETURN slot

END FUNCTION
'
' ###################################
' #####  autoSizerGroup_delete  #####
' ###################################
' Deletes a group of auto sizer info blocks
' series = the group to delete
' returns bOK: $$TRUE on success
FUNCTION autoSizerGroup_delete (series)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	AUTOSIZERINFO item_null[]

	IF series >= 0 && series <= UBOUND (autoSizerInfoUM[]) THEN
		autoSizerInfoUM[series].inUse = $$FALSE
		SWAP autoSizerInfo[series,], item_null[]
		RETURN $$TRUE
	ENDIF

END FUNCTION
'
' #################################
' #####  autoSizerGroup_show  #####
' #################################
' Hides or shows an auto sizer group
' series = the group to hide or show
' visible = $$TRUE to make the series visible, $$FALSE to hide them
' returns bOK: $$TRUE on success
FUNCTION autoSizerGroup_show (series, visible)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE series < 0 || series > UBOUND (autoSizerInfoUM[])

		CASE autoSizerInfoUM[series].inUse
			IF visible THEN command = $$SW_SHOWNA ELSE command = $$SW_HIDE

			iData = autoSizerInfoUM[series].iHead
			DO WHILE iData > -1
				IF autoSizerInfo[series, iData].hWnd THEN
					ShowWindow (autoSizerInfo[series, iData].hWnd, command)
				ENDIF
				iData = autoSizerInfo[series, iData].nextItem
			LOOP
			bOK = $$TRUE

	END SELECT

	RETURN bOK

END FUNCTION
'
' #################################
' #####  autoSizerGroup_size  #####
' #################################
' Automatically resizes all the controls in a group
' series = the group to resize
' w = the new width of the parent window
' h = the new height of the parent window
' returns bOK: $$TRUE on success
FUNCTION autoSizerGroup_size (series, x0, y0, w, h)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE series < 0 || series > UBOUND (autoSizerInfoUM[])

		CASE autoSizerInfoUM[series].inUse
' 0.6.0.2-new+++
			' compute nNumWindows for later call BeginDeferWindowPos (nNumWindows)
			nNumWindows = 0
			iData = autoSizerInfoUM[series].iHead
			DO WHILE iData > -1
				IF autoSizerInfo[series, iData].hWnd THEN
					INC nNumWindows
				ENDIF
				iData = autoSizerInfo[series, iData].nextItem
			LOOP
			IFZ nNumWindows THEN EXIT SELECT		' none!
' 0.6.0.2-new~~~
			currPos = 0
			IF autoSizerInfoUM[series].direction AND $$DIR_REVERSE THEN
				SELECT CASE autoSizerInfoUM[series].direction AND 0x00000003
					CASE $$DIR_HORIZ : currPos = w
					CASE $$DIR_VERT  : currPos = h
				END SELECT
			ENDIF
' 0.6.0.2-old---
'			#hWinPosInfo = BeginDeferWindowPos (10)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			#hWinPosInfo = BeginDeferWindowPos (nNumWindows)
' 0.6.0.2-new~~~
			iData = autoSizerInfoUM[series].iHead
			DO WHILE iData > -1
				IF autoSizerInfo[series, iData].hWnd THEN
					currPos = autoSizer (autoSizerInfo[series, iData], autoSizerInfoUM[series].direction, x0, y0, w, h, currPos)
				ENDIF
				iData = autoSizerInfo[series, iData].nextItem
			LOOP
			EndDeferWindowPos (#hWinPosInfo)
			bOK = $$TRUE

	END SELECT

	RETURN bOK

END FUNCTION
'
' ###############################
' #####  autoSizerInfo_add  #####
' ###############################
' Adds a new auto sizer info block
' sizerBlock = the auto sizer block to add
' returns the index of the auto sizer block or -1 on fail
FUNCTION autoSizerInfo_add (series, AUTOSIZERINFO sizerBlock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	AUTOSIZERINFO autoSizerInfoLocal[]

	slot = -1

	SELECT CASE TRUE
		CASE series < 0 || series > UBOUND (autoSizerInfoUM[])

		CASE autoSizerInfoUM[series].inUse
			upp = UBOUND (autoSizerInfo[series,])
			FOR i = 0 TO upp
				IFZ autoSizerInfo[series, i].hWnd THEN
					slot = i
					EXIT FOR
				ENDIF
			NEXT i

			IF slot < 0 THEN
				slot = UBOUND (autoSizerInfo[series,]) + 1
				upp = (slot<<1)|3
				SWAP autoSizerInfoLocal[], autoSizerInfo[series,]
				REDIM autoSizerInfoLocal[upp]
				SWAP autoSizerInfoLocal[], autoSizerInfo[series,]
			ENDIF

			autoSizerInfo[series, slot] = sizerBlock

			autoSizerInfo[series, slot].nextItem = -1

			IF autoSizerInfoUM[series].iTail < 0 THEN
				'Make this the first item
				autoSizerInfoUM[series].iHead = slot
				autoSizerInfoUM[series].iTail = slot
				autoSizerInfo[series, slot].prevItem = -1
			ELSE
				'add to the end of the list
				autoSizerInfo[series, slot].prevItem = autoSizerInfoUM[series].iTail
				autoSizerInfo[series, autoSizerInfoUM[series].iTail].nextItem = slot
				autoSizerInfoUM[series].iTail = slot
			ENDIF

	END SELECT

	RETURN slot

END FUNCTION
'
' ##################################
' #####  autoSizerInfo_delete  #####
' ##################################
' Deletes an auto sizer info block
' iData = the index of the auto sizer to delete
' returns bOK: $$TRUE on success
FUNCTION autoSizerInfo_delete (series, iData)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE series < 0 || series > UBOUND (autoSizerInfoUM[])
		CASE autoSizerInfoUM[series].inUse = $$FALSE
		CASE iData < 0 || iData > UBOUND (autoSizerInfo[series,])

		CASE autoSizerInfo[series, iData].hWnd
			autoSizerInfo[series, iData].hWnd = 0

			IF iData = autoSizerInfoUM[series].iHead THEN
				autoSizerInfoUM[series].iHead = autoSizerInfo[series, iData].nextItem
				autoSizerInfo[series, autoSizerInfo[series, iData].nextItem].prevItem = -1
				IF autoSizerInfoUM[series].iHead < 0 THEN autoSizerInfoUM[series].iTail = -1
			ELSE
				IF iData = autoSizerInfoUM[series].iTail THEN
					autoSizerInfo[series, autoSizerInfoUM[series].iTail].nextItem = -1
					autoSizerInfoUM[series].iTail = autoSizerInfo[series, iData].prevItem
					IF autoSizerInfoUM[series].iTail < 0 THEN autoSizerInfoUM[series].iHead = -1
				ELSE
					autoSizerInfo[series, autoSizerInfo[series, iData].nextItem].prevItem = autoSizerInfo[series, iData].prevItem
					autoSizerInfo[series, autoSizerInfo[series, iData].prevItem].nextItem = autoSizerInfo[series, iData].nextItem
				ENDIF
			ENDIF
			bOK = $$TRUE

	END SELECT

	RETURN bOK

END FUNCTION
'
' ###############################
' #####  autoSizerInfo_get  #####
' ###############################
' Get an auto sizer info block
' iData = the index of the block to get
' sizerBlock = the variable to store the block
' returns bOK: $$TRUE on success
FUNCTION autoSizerInfo_get (series, iData, AUTOSIZERINFO sizerBlock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE series < 0 || series > UBOUND (autoSizerInfoUM[])
		CASE autoSizerInfoUM[series].inUse = $$FALSE
		CASE iData < 0 || iData > UBOUND (autoSizerInfo[series,])

		CASE autoSizerInfo[series, iData].hWnd
			IFZ autoSizerInfo[series, iData].hWnd THEN EXIT SELECT

			sizerBlock = autoSizerInfo[series, iData]
			bOK = $$TRUE

	END SELECT

	RETURN bOK

END FUNCTION
'
' ##################################
' #####  autoSizerInfo_update  #####
' ##################################
' Update an auto sizer info block
' iData = index of the block to update
' sizerBlock = the new version of the info block
' returns bOK: $$TRUE on success
FUNCTION autoSizerInfo_update (series, iData, AUTOSIZERINFO sizerBlock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE series < 0 || series > UBOUND (autoSizerInfoUM[])
		CASE autoSizerInfoUM[series].inUse = $$FALSE
		CASE iData < 0 || iData > UBOUND (autoSizerInfo[series,])

		CASE autoSizerInfo[series, iData].hWnd
			autoSizerInfo[series, iData] = sizerBlock
			bOK = $$TRUE

	END SELECT

	RETURN bOK

END FUNCTION
'
' binding
'
' #########################
' #####  binding_add  #####
' #########################
' Add a binding to the binding table
' binding = the binding to add
' returns the id of the binding
FUNCTION binding_add (BINDING binding)
	SHARED		BINDING	bindings[]

	'look for a blank slot
	slot = -1
	upp = UBOUND(bindings[])
	FOR i = 0 TO upp
		IFZ bindings[i].hWnd THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	'allocate more memory if needed
	IF slot < 0 THEN
		slot = UBOUND(bindings[])+1
		upp = (slot<<1)|3
		REDIM bindings[upp]
	ENDIF

	'set the binding
	bindings[slot] = binding
	RETURN (slot+1)
END FUNCTION
'
' ############################
' #####  binding_delete  #####
' ############################
' Deletes a binding from the binding table
' id = the id of the binding to delete
' returns bOK: $$TRUE on success
FUNCTION binding_delete (id)
	SHARED		BINDING	bindings[]
	LINKEDLIST list

	bOK = $$FALSE
	slot = id - 1

	IF (slot >= 0) && (slot <= UBOUND (bindings[])) THEN
		'delete the auto drawer info
		autoDraw_clear (bindings[slot].autoDrawInfo)
		LINKEDLIST_Get (bindings[slot].autoDrawInfo, @list)
		LinkedList_Uninit (@list)
		LINKEDLIST_Delete (bindings[slot].autoDrawInfo)

		'delete the message handlers
		handlerGroup_delete (bindings[slot].msgHandlers)

		'delete the auto sizer info
		autoSizerGroup_delete (bindings[slot].autoSizerInfo)

		bindings[slot].hWnd = 0
		bOK = $$TRUE
	ENDIF

	RETURN bOK

END FUNCTION
'
' #########################
' #####  binding_get  #####
' #########################
' Retrieves a binding
' id = the id of the binding to get
' binding = the variable to store the binding
' returns bOK: $$TRUE on success
FUNCTION binding_get (id, BINDING binding)
	SHARED		BINDING	bindings[]
	BINDING binding_null

	bOK = $$FALSE
	slot = id-1
	IF (slot >= 0) && (slot <= UBOUND (bindings[])) THEN
		IF bindings[slot].hWnd THEN
			binding = bindings[slot]
			bOK = $$TRUE
		ENDIF
	ENDIF
	IFF bOK THEN
		binding = binding_null
	ENDIF
	RETURN bOK
END FUNCTION
'
' ############################
' #####  binding_update  #####
' ############################
' Updates a binding
' id = the id of the binding to update
' binding = the new version of the binding
' returns bOK: $$TRUE on success
FUNCTION binding_update (id, BINDING binding)
	SHARED		BINDING	bindings[]

	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND (bindings[])) THEN
		IF binding.hWnd = bindings[slot].hWnd THEN
			' must be same window
			bindings[slot] = binding
			RETURN $$TRUE
		ENDIF
	ENDIF
	msg$ = "binding_update: invalid id" + STR$ (id)
	GuiAlert (msg$, "")

END FUNCTION
'
' ##############################
' #####  cancelDlgOnClose  #####
' ##############################
' onClose callback for the cancel printing dialog box
FUNCTION cancelDlgOnClose (hWnd)
	SHARED	PRINTINFO	printInfo

	SetLastError (0)
	printInfo.continuePrinting = $$FALSE
	printInfo.hCancelDlg = 0
	DestroyWindow (hWnd)
END FUNCTION
'
' ################################
' #####  cancelDlgOnCommand  #####
' ################################
' onCommand callback for the cancel printing dialog box
FUNCTION cancelDlgOnCommand (idCtr, code, hWnd)
	SHARED	PRINTINFO	printInfo

	IF printInfo.hCancelDlg THEN
		SELECT CASE idCtr
			CASE $$IDCANCEL
				SendMessageA (printInfo.hCancelDlg, $$WM_CLOSE, 0, 0)
		END SELECT
	ENDIF
END FUNCTION
'
' #####################
' #####  drawArc  #####
' #####################
FUNCTION drawArc (hdc, AUTODRAWRECORD record, x0, y0)
	IF hdc THEN
		Arc (hdc, record.rectControl.x1-x0, record.rectControl.y1-y0, record.rectControl.x2-x0, _
		record.rectControl.y2-y0, record.rectControl.xC1-x0, record.rectControl.yC1-y0, _
		record.rectControl.xC2-x0, record.rectControl.yC2-y0)
	ENDIF
END FUNCTION
'
' ########################
' #####  drawBezier  #####
' ########################
FUNCTION drawBezier (hdc, AUTODRAWRECORD record, x0, y0)
	POINT pt[]

	IF hdc THEN
		DIM pt[3]
		pt[0].x = record.rectControl.x1  -x0
		pt[0].y = record.rectControl.y1  -y0
		pt[1].x = record.rectControl.xC1 -x0
		pt[1].y = record.rectControl.yC1 -y0
		pt[2].x = record.rectControl.xC2 -x0
		pt[2].y = record.rectControl.yC2 -y0
		pt[3].x = record.rectControl.x2  -x0
		pt[3].y = record.rectControl.y2  -y0
		PolyBezier (hdc, &pt[0], 4)
	ENDIF
END FUNCTION
'
' #########################
' #####  drawEllipse  #####
' #########################
' Draw an ellipse
' hdc = the dc to draw on
' record = the draw record
FUNCTION drawEllipse (hdc, AUTODRAWRECORD record, x0, y0)
	IF hdc THEN
		Ellipse (hdc, record.rect.x1-x0, record.rect.y1-y0, record.rect.x2-x0, record.rect.y2-y0)
	ENDIF
END FUNCTION
'
' ###############################
' #####  drawEllipseNoFill  #####
' ###############################
FUNCTION drawEllipseNoFill (hdc, AUTODRAWRECORD record, x0, y0)
	IF hdc THEN
		xMid = (record.rect.x1+record.rect.x2)\2-x0
		y1py0 = record.rect.y1-y0
		Arc (hdc, record.rect.x1-x0, y1py0, record.rect.x2-x0, record.rect.y2-y0, xMid, y1py0, xMid, y1py0)
	ENDIF
END FUNCTION
'
' ######################
' #####  drawFill  #####
' ######################
FUNCTION drawFill (hdc, AUTODRAWRECORD record, x0, y0)
	IF hdc THEN
		ExtFloodFill (hdc, record.simpleFill.x-x0, record.simpleFill.y-y0, record.simpleFill.col, $$FLOODFILLBORDER)
	ENDIF
END FUNCTION
'
' #######################
' #####  drawImage  #####
' #######################
' Draws an image
FUNCTION drawImage (hdc, AUTODRAWRECORD record, x0, y0)
	BLENDFUNCTION blfn

	SetLastError (0)
	IFZ hdc THEN RETURN

	hdcSrc = CreateCompatibleDC (0)
	hOld = SelectObject (hdcSrc, record.image.hImage)
	IF record.image.blend THEN
		blfn.BlendOp = $$AC_SRC_OVER
		blfn.SourceConstantAlpha = 255
		blfn.AlphaFormat = $$AC_SRC_ALPHA
		'AlphaBlend is misdefined in headers, so call it through a wrapper
		ApiAlphaBlend (hdc, record.image.x-x0, record.image.y-y0, record.image.w, record.image.h, hdcSrc, _
		record.image.xSrc, record.image.ySrc, record.image.w, record.image.h, blfn)
	ELSE
		BitBlt (hdc, record.image.x-x0, record.image.y-y0, record.image.w, record.image.h, hdcSrc, _
		record.image.xSrc, record.image.ySrc, $$SRCCOPY)
	ENDIF
	SelectObject (hdcSrc, hOld)
END FUNCTION
'
' ######################
' #####  drawLine  #####
' ######################
' Draws a line
' hdc = the dc to draw the line on
' record = the record containing info for the line
FUNCTION drawLine (hdc, AUTODRAWRECORD record, x0, y0)
	IF hdc THEN
		MoveToEx (hdc, record.rect.x1-x0, record.rect.y1-y0, 0)
		LineTo (hdc, record.rect.x2-x0, record.rect.y2-y0)
	ENDIF
END FUNCTION
'
' ######################
' #####  drawRect  #####
' ######################
' draws a rectangle
' hdc = the dc to draw on
' record = the draw record
FUNCTION drawRect (hdc, AUTODRAWRECORD record, x0, y0)
	IF hdc THEN
		x = record.rect.x1-x0
		y = record.rect.y1-y0
		w = record.rect.x2-x0
		h = record.rect.y2-y0
		Rectangle (hdc, x, y, w, h)
	ENDIF
END FUNCTION
'
' ############################
' #####  drawRectNoFill  #####
' ############################
FUNCTION drawRectNoFill (hdc, AUTODRAWRECORD record, x0, y0)
	POINT pt[]

	IFZ hdc THEN RETURN
	DIM pt[4]
	pt[0].x = record.rect.x1-x0
	pt[0].y = record.rect.y1-y0
	pt[1].x = record.rect.x2-x0
	pt[1].y = pt[0].y
	pt[2].x = pt[1].x
	pt[2].y = record.rect.y2-y0
	pt[3].x = pt[0].x
	pt[3].y = pt[2].y
	pt[4] = pt[0]
	Polyline (hdc, &pt[0], 5)
END FUNCTION
'
' ######################
' #####  drawText  #####
' ######################
' Draws a text string
FUNCTION drawText (hdc, AUTODRAWRECORD record, x0, y0)
	SetLastError (0)
	IFZ hd THEN
		SetTextColor (hdc, record.text.forColor)
		IF record.text.backColor < 0 THEN
			SetBkMode (hdc, $$TRANSPARENT)
		ELSE
			SetBkMode (hdc, $$OPAQUE)
			SetBkColor (hdc, record.text.backColor)
		ENDIF
		STRING_Get (record.text.iString, @text$)
		ExtTextOutA (hdc, record.text.x-x0, record.text.y-y0, options, 0, &text$, LEN(text$), 0)
	ENDIF
END FUNCTION
'
' ##############################
' #####  handlerGroup_add  #####
' ##############################
' Adds a new group of handlers
' returns the id of the group
FUNCTION handlerGroup_add ()
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		handlersUM[]	'a usage map so we can see which groups are in use

	slot = -1
	upp = UBOUND (handlersUM[])
	FOR i = 0 TO upp
		IFZ handlersUM[i] THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	IF slot < 0 THEN
		slot = upp+1
		upp = (slot<<1)|3
		REDIM handlersUM[upp]
		REDIM handlers[upp,]
	ENDIF

	handlersUM[slot] = $$TRUE

	RETURN (slot+1)
END FUNCTION
'
' #################################
' #####  handlerGroup_delete  #####
' #################################
' Deletes a group of handlers
' group = the group to delete
' returns bOK: $$TRUE on success
FUNCTION handlerGroup_delete (group)
	SHARED MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED handlersUM[]	'a usage map so we can see which groups are in use
	MSGHANDLER	group_null[]	'a local version of the group

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE group < 0 || group > UBOUND (handlers[])

		CASE handlersUM[group]
			handlersUM[group] = $$FALSE		' not in use
			IF handlers[group,] THEN
				SWAP group_null[], handlers[group,]
			ENDIF
			bOK = $$TRUE

	END SELECT

	RETURN bOK

END FUNCTION
'
' #############################
' #####  handlerInfo_add  #####
' #############################
' Add a new handler to a group
' group = the group to add the handler to
' handler = the handler to add
' returns the index of the new handler or -1 on fail
FUNCTION handlerInfo_add (group, MSGHANDLER handler)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		handlersUM[]	'a usage map so we can see which groups are in use
	MSGHANDLER	group[]	'a local version of the group

	slot = -1

	SELECT CASE TRUE
		CASE handler.msg = 0
		CASE group < 0 || group > UBOUND (handlers[])

		CASE handlersUM[group]
			upp = UBOUND (handlers[group,])

			'check if already there
			bFound = $$FALSE
			FOR i = 0 TO upp
				IF handlers[group, i].msg = handler.msg THEN
					bFound = $$TRUE
					EXIT FOR
				ENDIF
			NEXT i
			IF bFound THEN EXIT SELECT

			'find a free slot
			slot = -1
			FOR i = 0 TO upp
				IFZ handlers[group, i].msg THEN
					slot = i
					handlers[group, slot] = handler
					EXIT FOR
				ENDIF
			NEXT i

			IF slot < 0 THEN		'allocate more memmory
' 0.6.0.2-old---
' TECHNICAL TRICK
' ===============
' GL: the deleted code can't compile -bc (bounds checking)
'
'				slot = UBOUND (handlers[group,]) + 1
'				SWAP group[], handlers[group,]
'				REDIM group[ ((UBOUND (group[]) + 1) << 1) - 1]
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
				DIM group[]
				SWAP group[], handlers[group,]		' ie.: "group[] := handlers[group,]"
				IFZ group[] THEN
					DIM group[0]
					slot = 0
				ELSE
					slot = UBOUND (group[]) + 1
					upp = (slot<<1)|3
					REDIM group[upp]
				ENDIF
' 0.6.0.2-new~~~
				group[slot] = handler

				SWAP handlers[group,], group[]		' ie.: "handlers[group,] := group[]"
			ENDIF

	END SELECT

	RETURN slot
END FUNCTION
'
' ################################
' #####  handlerInfo_delete  #####
' ################################
' Delete a single handler
' group and index = the group and id of the handler to delete
' returns bOK: $$TRUE on success
FUNCTION handlerInfo_delete (group, index)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED handlersUM[]

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE group < 0 || group > UBOUND (handlers[])
		CASE index < 0 || index > UBOUND (handlers[group,])

		CASE handlersUM[group]
			handlers[group, index].msg = 0
			bOK = $$TRUE

	END SELECT

	RETURN bOK

END FUNCTION
'
' #############################
' #####  handlerInfo_get  #####
' #############################
' Retrieve a handler from the handler array
' group and index are the group and id of the handler to retrieve
' r_handler = the variable to store the handler
' returns bOK: $$TRUE on success
FUNCTION handlerInfo_get (group, index, MSGHANDLER r_handler)
	SHARED MSGHANDLER handlers[]		'a 2D array of handlers
	SHARED handlersUM[]		'a usage map so we can see which groups are in use
	MSGHANDLER item_null

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE group < 0 || group > UBOUND (handlers[])
		CASE index < 0 || index > UBOUND (handlers[group,])

		CASE handlersUM[group]
			IF handlers[group, index].msg THEN
				r_handler = handlers[group, index]
				bOK = $$TRUE		' success
			ENDIF

	END SELECT

	IFF bOK THEN
		r_handler = item_null		' reset
	ENDIF

	RETURN bOK

END FUNCTION
'
' ################################
' #####  handlerInfo_update  #####
' ################################
' Updates an existing handler
' group and index are the group and id of the handler to update
' handler is the new version of the handler
' returns bOK: $$TRUE on success
FUNCTION handlerInfo_update (group, index, MSGHANDLER handler)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED handlersUM[]

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE group < 0 || group > UBOUND (handlers[])
		CASE index < 0 || index > UBOUND (handlers[group,])

		CASE handlersUM[group]
			IF handlers[group, index].msg THEN
				handlers[group, index] = handler
				bOK = $$TRUE
			ENDIF

	END SELECT

	RETURN bOK

END FUNCTION
'
' ##########################
' #####  handler_call  #####
' ##########################
' Calls the handler for a specified message
' group = the group to call from
' ret_value = the variable to hold the message return value
' hwnd, wMsg, wParam, lParam = the usual definitions for these parameters
' returns bOK: $$TRUE on success
FUNCTION handler_call (group, @ret_value, hWnd, wMsg, wParam, lParam)
	SHARED MSGHANDLER handlers[]		'a 2D array of handlers

	ret_value = 0
	'first, find the handler
	index = handler_find (group, wMsg)
	IF index >= 0 THEN
		'then call it
		ret_value = @handlers[group, index].handler (hWnd, wMsg, wParam, lParam)
		RETURN $$TRUE
	ENDIF

END FUNCTION
'
' ##########################
' #####  handler_find  #####
' ##########################
' Locates a handler in the handler array
' group = the id of the group to search
' wMsg = the message to search for
' returns the id of the message handler, -1 if it fails
'  to find anything and -2 if there is a bounds error
FUNCTION handler_find (group, wMsg)
	SHARED MSGHANDLER handlers[]		'a 2D array of handlers
	SHARED handlersUM[]		'a usage map so we can see which groups are in use

	slot = -1		' not found

	SELECT CASE TRUE
		CASE group < 0 || group > UBOUND (handlers[])
			slot = -2		' bounds error

		CASE handlersUM[group]
			upp = UBOUND (handlers[group,])
			FOR i = 0 TO upp
				IF handlers[group,i].msg = wMsg THEN
					slot = i
					EXIT FOR
				ENDIF
			NEXT i

	END SELECT

	RETURN slot

END FUNCTION
'
' #########################
' #####  mainWndProc  #####
' #########################
' The main window procedure
' parameters and return are as usual
FUNCTION mainWndProc (hWnd, wMsg, wParam, lParam)

	SHARED tvDragButton
	SHARED tvDragItem
	SHARED tvDragImage
	SHARED DLM_MESSAGE
	SHARED hClipMem		' to copy to the clipboard

	STATIC s_dragItem
	STATIC s_lastDragItem
'	STATIC s_lastW ' unused
'	STATIC s_lastH ' unused

	PAINTSTRUCT	ps
	BINDING binding
'	BINDING innerBinding
	MINMAXINFO mmi
	RECT rect
	SCROLLINFO si
	DRAGLISTINFO	dli
	TV_HITTESTINFO tvHit
	POINT pt
	POINT mouseXY
	TRACKMOUSEEVENT tme

	XLONG idCtr, notifyCode, hCtr

	' Message handled with a return code.
	XLONG bHandled		' bHandled = $$TRUE => message handled
	XLONG ret_value		' return code when bHandled = $$TRUE

	SetLastError (0)

	'set to true if we handle the message
	bHandled = $$FALSE

	' mainWndProc return value
	ret_value = 0

	'get the binding
	IFF Get_binding (hWnd, @idBinding, @binding) THEN
		RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam)
	ENDIF
'
' Call first any associated message handler.
'
	IF binding.msgHandlers THEN
		bOK = handler_call (binding.msgHandlers, @ret, hWnd, wMsg, wParam, lParam)
		IF bOK THEN
			bHandled = $$TRUE
			ret_value = ret
		ENDIF
	ENDIF
'
' Handle the message.
'
	SELECT CASE wMsg
		CASE $$WM_DRAWCLIPBOARD
			IF binding.hWndNextClipViewer THEN SendMessageA (binding.hWndNextClipViewer, $$WM_DRAWCLIPBOARD, wParam, lParam)
			RETURN @binding.onClipChange ()

		CASE $$WM_CHANGECBCHAIN
			IF wParam = binding.hWndNextClipViewer THEN
				binding.hWndNextClipViewer = lParam
			ELSE
				IF binding.hWndNextClipViewer THEN SendMessageA (binding.hWndNextClipViewer, $$WM_CHANGECBCHAIN, wParam, lParam)
			ENDIF

			RETURN 0

		CASE $$WM_DESTROYCLIPBOARD
			IF hClipMem THEN
				GlobalFree (hClipMem)
				hClipMem = 0		'prevent from freeing twice hClipMem
			ENDIF
			RETURN 0

		CASE $$WM_DROPFILES
			DragQueryPoint (wParam, &pt)

			cFiles = DragQueryFileA (wParam, -1, 0, 0)
			IF cFiles > 0 THEN
				upp = cFiles - 1
				DIM fileList$[upp]
				FOR i = 0 TO upp
					cc = DragQueryFileA (wParam, i, 0, 0)
					IF cc > 0 THEN
						fileList$[i] = NULL$ (cc)
						DragQueryFileA (wParam, i, &fileList$[i], cc)
					ENDIF
				NEXT i
				DragFinish (wParam)

				RETURN @binding.onDropFiles (hWnd, pt.x, pt.y, @fileList$[])
			ENDIF

			DragFinish (wParam)
			RETURN 0

		CASE $$WM_COMMAND		' User selected a command
' 0.6.0.2-old---
'			RETURN @binding.onCommand(LOWORD (wParam), HIWORD (wParam), lParam)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			IF binding.onCommand THEN
				idCtr = LOWORD (wParam)
				notifyCode = HIWORD (wParam)
				RETURN @binding.onCommand (idCtr, notifyCode, lParam)
			ENDIF
			IF binding.useDialogInterface THEN
				SELECT CASE idCtr
					CASE $$IDCANCEL
						IF notifyCode = $$BN_CLICKED THEN
							' handle Escape
							ShowWindow (hWnd, $$SW_HIDE)
							RETURN 1
						ENDIF
				END SELECT
			ENDIF
' 0.6.0.2-new~~~
			RETURN 0

		CASE $$WM_ERASEBKGND		' the window background must be erased
			IF binding.backCol THEN
				' Erase the background by filling
				' the client rectangle using the binding.backCol brush.
				SetLastError (0)
				ret = GetClientRect (hWnd, &rect)
				IFZ ret THEN
					msg$ = "mainWndProc: Can't get the client rectangle of the window"
					GuiTellApiError (msg$)
				ELSE
					FillRect (wParam, &rect, binding.backCol)
					RETURN 0
				ENDIF
			ENDIF
			RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam)

		CASE $$WM_PAINT
			hDC = BeginPaint (hWnd, &ps)

			'use auto drawer
			WinXGetUseableRect (hWnd, @rect)
' DELETED---
			' Auto scroll?
'				IF binding.hScrollPageM THEN
'					GetScrollInfo (hWnd, $$SB_HORZ, &si)
'					xOff = (si.nPos-binding.hScrollPageC)\binding.hScrollPageM
'					GetScrollInfo (hWnd, $$SB_VERT, &si)
'					yOff = (si.nPos-binding.hScrollPageC)\binding.hScrollPageM
'				ENDIF
' DELETED~~~
			autoDraw_draw(hDC, binding.autoDrawInfo, xOff, yOff)

			ret_value = @binding.paint(hWnd, hDC)

			EndPaint (hWnd, &ps)

			RETURN ret_value

		CASE $$WM_SIZE
			w = LOWORD (lParam)
			h = HIWORD (lParam)
			sizeWindow (hWnd, w, h)
			bHandled = $$TRUE

		CASE $$WM_HSCROLL,$$WM_VSCROLL
			' TrackBar scrolling.
			sizeBuf = LEN ("msctls_trackbar32")
			szBuf$ = NULL$ (sizeBuf+1)
			GetClassNameA (lParam, &szBuf$, sizeBuf)
			szBuf$ = TRIM$ (CSTRING$ (&szBuf$))
			IF szBuf$ = "msctls_trackbar32" THEN
				RETURN @binding.onTrackerPos (GetDlgCtrlID (lParam), SendMessageA (lParam, $$TBM_GETPOS, 0, 0))
			ENDIF

			' Default scrolling.
			sbval = LOWORD (wParam)
			IF wMsg = $$WM_HSCROLL THEN
				typeBar = $$SB_HORZ
				dir = $$DIR_HORIZ
				scrollUnit = binding.hScrollUnit
			ELSE
				typeBar = $$SB_VERT
				dir = $$DIR_VERT
				scrollUnit = binding.vScrollUnit
			ENDIF

			si.cbSize = SIZE (SCROLLINFO)
			si.fMask = $$SIF_ALL|$$SIF_DISABLENOSCROLL
			GetScrollInfo (hWnd, typeBar, &si)

			IF si.nPage <= (si.nMax-si.nMin) THEN
				SELECT CASE sbval
					CASE $$SB_TOP
						si.nPos = 0
					CASE $$SB_BOTTOM
						si.nPos = si.nMax-si.nPage+1
					CASE $$SB_LINEUP
						IF si.nPos < scrollUnit THEN si.nPos = 0 ELSE si.nPos = si.nPos - scrollUnit
					CASE $$SB_LINEDOWN
						IF si.nPos+scrollUnit > si.nMax-si.nPage+1 THEN si.nPos = si.nMax-si.nPage+1 ELSE si.nPos = si.nPos + scrollUnit
					CASE $$SB_PAGEUP
						IF si.nPos < si.nPage THEN si.nPos = 0 ELSE si.nPos = si.nPos - si.nPage
					CASE $$SB_PAGEDOWN
						IF si.nPos+si.nPage > (si.nMax-si.nPage+1) THEN si.nPos = si.nMax-si.nPage+1 ELSE si.nPos = si.nPos + si.nPage
					CASE $$SB_THUMBTRACK
						si.nPos = si.nTrackPos
				END SELECT
			ENDIF

			SetScrollInfo (hWnd, typeBar, &si, 1)
			RETURN @binding.onScroll(si.nPos, hWnd, dir)
' DELETED---
' This allows for mouse activation of child windows, for some reason WM_ACTIVATE doesn't work
' unfortunately it interferes with label editing - hence the strange hWnd != wParam condition
'		CASE $$WM_MOUSEACTIVATE
'			IF hWnd != wParam THEN
'				SetFocus (hWnd)
'				RETURN $$MA_NOACTIVATE
'			END IF
'			RETURN $$MA_ACTIVATE
'			WinXGetMousePos (wParam, @x, @y)
'			hChild = wParam
'			DO WHILE hChild
'				wParam = hChild
'				hChild = ChildWindowFromPoint (wParam, x, y)
'			LOOP
'			IF wParam = GetFocus() THEN RETURN $$MA_NOACTIVATE
' DELETED~~~
		CASE $$WM_SETFOCUS
			IF binding.onFocusChange THEN RETURN @binding.onFocusChange(hWnd, $$TRUE)

		CASE $$WM_KILLFOCUS
			IF binding.onFocusChange THEN RETURN @binding.onFocusChange(hWnd, $$FALSE)

		CASE $$WM_SETCURSOR
			IF binding.hCursor THEN
				IF LOWORD (lParam) = $$HTCLIENT THEN
					SetCursor (binding.hCursor)
					RETURN $$TRUE
				ENDIF
			ENDIF

		CASE $$WM_MOUSEMOVE
			mouseXY.x = LOWORD (lParam)
			mouseXY.y = HIWORD (lParam)

			IFF binding.isMouseInWindow THEN
				tme.cbSize = SIZE (tme)
				tme.dwFlags = $$TME_LEAVE
				tme.hwndTrack = hWnd
				TrackMouseEvent (&tme)
				binding.isMouseInWindow = $$TRUE
				binding_update (idBinding, binding)

				@binding.onEnterLeave (hWnd, $$TRUE)
			ENDIF

			IF (tvDragButton = $$MBT_LEFT) || (tvDragButton = $$MBT_RIGHT) THEN
				GOSUB dragTreeViewItem
				IFZ ret_value THEN
					cursor = $$IDC_NO
				ELSE
					cursor = $$IDC_ARROW
				ENDIF
				SetCursor (LoadCursorA (0, cursor))
				ret_value = 0
			ELSE
				ret_value = @binding.onMouseMove(hWnd, LOWORD (lParam), HIWORD (lParam))
			ENDIF
			RETURN ret_value

		CASE $$WM_MOUSELEAVE
			binding.isMouseInWindow = $$FALSE
			binding_update (idBinding, binding)

			@binding.onEnterLeave (hWnd, $$FALSE)
			RETURN 0

		CASE $$WM_LBUTTONDOWN
			mouseXY.x = LOWORD (lParam)
			mouseXY.y = HIWORD (lParam)
			RETURN @binding.onMouseDown(hWnd, $$MBT_LEFT, LOWORD (lParam), HIWORD (lParam))

		CASE $$WM_MBUTTONDOWN
			mouseXY.x = LOWORD (lParam)
			mouseXY.y = HIWORD (lParam)
			RETURN @binding.onMouseDown(hWnd, $$MBT_MIDDLE, LOWORD (lParam), HIWORD (lParam))

		CASE $$WM_RBUTTONDOWN
			mouseXY.x = LOWORD (lParam)
			mouseXY.y = HIWORD (lParam)
			RETURN @binding.onMouseDown(hWnd, $$MBT_RIGHT, LOWORD (lParam), HIWORD (lParam))

		CASE $$WM_LBUTTONUP
			mouseXY.x = LOWORD (lParam)
			mouseXY.y = HIWORD (lParam)
			IF tvDragButton = $$MBT_LEFT THEN
				'dragged with left button
				GOSUB dragTreeViewItem
				@binding.onDrag(GetDlgCtrlID (tvDragItem), $$DRAG_DONE, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
				GOSUB endDragTreeViewItem
				ret_value = 0
			ELSE
				'dragged with right button
				ret_value = @binding.onMouseUp(hWnd, $$MBT_LEFT,LOWORD (lParam), HIWORD (lParam))
			ENDIF
			RETURN ret_value

		CASE $$WM_MBUTTONUP
			mouseXY.x = LOWORD (lParam)
			mouseXY.y = HIWORD (lParam)
			RETURN @binding.onMouseUp(hWnd, $$MBT_MIDDLE, LOWORD (lParam), HIWORD (lParam))

		CASE $$WM_RBUTTONUP
			mouseXY.x = LOWORD (lParam)
			mouseXY.y = HIWORD (lParam)
			IF tvDragButton = $$MBT_LEFT THEN
				GOSUB dragTreeViewItem
				@binding.onDrag(GetDlgCtrlID (tvDragItem), $$DRAG_DONE, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
				GOSUB endDragTreeViewItem
				ret_value = 0
			ELSE
				ret_value = @binding.onMouseUp(hWnd, $$MBT_RIGHT, LOWORD (lParam), HIWORD (lParam))
			ENDIF
			RETURN ret_value

		CASE $$WM_MOUSEWHEEL
' BROKEN---
' This message is broken.  It gets passed to active window rather than the window under the mouse
' ----------------------
'
'			mouseXY.x = LOWORD (lParam)
'			mouseXY.y = HIWORD (lParam)
'
'			? "-";hWnd
'			hChild = WindowFromPoint (mouseXY.x, mouseXY.y)
'			? hChild
'			ScreenToClient (hChild, &mouseXY)
'			hChild = ChildWindowFromPointEx (hChild, mouseXY.x, mouseXY.y, $$CWP_ALL)
'			? hChild
'
'			idInnerBinding = GetWindowLongA (hChild, $$GWL_USERDATA)
'			IFF binding_get (idInnerBinding, @innerBinding) THEN
' -------------------------------------------------------
' kept+++
				RETURN @binding.onMouseWheel(hWnd, HIWORD (wParam), LOWORD (lParam), HIWORD (lParam))
' kept~~~
' -------------------------------------------------------
'			ELSE
'				IF innerBinding.onMouseWheel THEN
'					RETURN @innerBinding.onMouseWheel(hChild, HIWORD (wParam), LOWORD (lParam), HIWORD (lParam))
'				ELSE
'					RETURN @binding.onMouseWheel(hWnd, HIWORD (wParam), LOWORD (lParam), HIWORD (lParam))
'				END IF
'			END IF
' BROKEN~~~
		CASE $$WM_KEYDOWN
			RETURN @binding.onKeyDown(hWnd, wParam)

		CASE $$WM_KEYUP
			RETURN @binding.onKeyUp(hWnd, wParam)

		CASE $$WM_CHAR
			RETURN @binding.onChar(hWnd, wParam)

		CASE DLM_MESSAGE
			IF DLM_MESSAGE THEN
				RtlMoveMemory (&dli, lParam, SIZE (DRAGLISTINFO))

				SELECT CASE dli.uNotification
					CASE $$DL_BEGINDRAG
						item = ApiLBItemFromPt (dli.hWnd, dli.ptCursor.x, dli.ptCursor.y, $$TRUE)
						WinXListBox_AddItem (dli.hWnd, -1, " ")
						RETURN @binding.onDrag(wParam, $$DRAG_START, item, dli.ptCursor.x, dli.ptCursor.y)

					CASE $$DL_CANCELDRAG
						@binding.onDrag(wParam, $$DRAG_DONE, -1, dli.ptCursor.x, dli.ptCursor.y)
						WinXListBox_RemoveItem (dli.hWnd, -1)

					CASE $$DL_DRAGGING
						item = ApiLBItemFromPt (dli.hWnd, dli.ptCursor.x, dli.ptCursor.y, 1)
						IF item >= 0 THEN
							IF @binding.onDrag(wParam, $$DRAG_DRAGGING, item, dli.ptCursor.x, dli.ptCursor.y) THEN
								IF item != s_dragItem THEN
									SendMessageA (dli.hWnd, $$LB_GETITEMRECT, item, &rect)
									InvalidateRect (dli.hWnd, 0, 1)		' erase
									UpdateWindow (dli.hWnd)
									hDC = GetDC (dli.hWnd)

									'draw insert bar
									MoveToEx (hDC, rect.left+1, rect.top-1, 0)
									LineTo (hDC, rect.right-1, rect.top-1)

									MoveToEx (hDC, rect.left+1, rect.top, 0)
									LineTo (hDC, rect.right-1, rect.top)

									MoveToEx (hDC, rect.left+1, rect.top-3, 0)
									LineTo (hDC, rect.left+1, rect.top+3)

									MoveToEx (hDC, rect.left+2, rect.top-2, 0)
									LineTo (hDC, rect.left+2, rect.top+2)

									MoveToEx (hDC, rect.right-2, rect.top-3, 0)
									LineTo (hDC, rect.right-2, rect.top+3)

									MoveToEx (hDC, rect.right-3, rect.top-2, 0)
									LineTo (hDC, rect.right-3, rect.top+2)

									ReleaseDC (dli.hWnd, hDC)
									s_dragItem = item
								ENDIF
								RETURN $$DL_MOVECURSOR
							ELSE
								IF item != s_dragItem THEN
									InvalidateRect (dli.hWnd, 0, 1)		' erase
									s_dragItem = item
								ENDIF
								RETURN $$DL_STOPCURSOR
							ENDIF
						ELSE
							IF item != s_dragItem THEN
								InvalidateRect (dli.hWnd, 0, 1)		' erase
								s_dragItem = -1
							ENDIF
							RETURN $$DL_STOPCURSOR
						ENDIF

					CASE $$DL_DROPPED
						InvalidateRect (dli.hWnd, 0, 1)		' erase
						item = ApiLBItemFromPt (dli.hWnd, dli.ptCursor.x, dli.ptCursor.y, 1)
						IFF @binding.onDrag(wParam, $$DRAG_DRAGGING, item, dli.ptCursor.x, dli.ptCursor.y) THEN
							item = -1
						ENDIF
						@binding.onDrag(wParam, $$DRAG_DONE, item, dli.ptCursor.x, dli.ptCursor.y)
						WinXListBox_RemoveItem (dli.hWnd, -1)

				END SELECT
			ENDIF
			bHandled = $$TRUE

		CASE $$WM_GETMINMAXINFO
			pMmi = &mmi
			XLONGAT (&&mmi) = lParam
			mmi.ptMinTrackSize.x = binding.minW
			mmi.ptMinTrackSize.y = binding.minH
			XLONGAT (&&mmi) = pMmi
			bHandled = $$TRUE		' handled

		CASE $$WM_PARENTNOTIFY
			SELECT CASE LOWORD (wParam)
				CASE $$WM_DESTROY
					'free the auto sizer block if there is one
					autoSizerInfo_delete (binding.autoSizerInfo, GetPropA (lParam, &$$SizerInfo$)-1)
			END SELECT
			bHandled = $$TRUE

		CASE $$WM_NOTIFY		' notification message
			RETURN onNotify (hWnd, wParam, lParam, binding)

		CASE $$WM_TIMER
			SELECT CASE wParam
				CASE -1
					IF s_lastDragItem = s_dragItem THEN
						ImageList_DragShowNolock ($$FALSE)
						SendMessageA (tvDragItem, $$TVM_EXPAND, $$TVE_EXPAND, s_dragItem)
						ImageList_DragShowNolock ($$TRUE)
					ENDIF
					KillTimer (hWnd, -1)
			END SELECT
			RETURN 0

		CASE $$WM_CLOSE		' closed by User
' 0.6.0.2-old---
'			IFZ binding.onClose THEN
'				DestroyWindow (hWnd)
'				PostQuitMessage($$WM_QUIT)		' quit program
'			ELSE
'				RETURN @binding.onClose (hWnd)
'			ENDIF
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			IF binding.onClose THEN
				' Last chance to cancel closing:
				' a non-zero return code will cancel WinX's default closing.
				ret_value = @binding.onClose (hWnd)
			ENDIF

			IFZ ret_value THEN
				WinXHide (hWnd)
				IF idBinding = 1 THEN
					' User destroyed the main window to quit program
					PostQuitMessage ($$WM_QUIT)		' quit program
				ENDIF
			ENDIF
			RETURN ret_value
' 0.6.0.2-new~~~

		CASE $$WM_DESTROY
			ChangeClipboardChain (hWnd, binding.hWndNextClipViewer)
			'clear the binding
			Delete_binding (idBinding)
			bHandled = $$TRUE

	END SELECT

		IF bHandled THEN RETURN ret_value

		RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam)

	SUB dragTreeViewItem
		tvHit.pt.x = LOWORD (lParam)
		tvHit.pt.y = HIWORD (lParam)
		ClientToScreen (hWnd, &tvHit.pt)
		pt = tvHit.pt

		GetWindowRect (tvDragItem, &rect)
		tvHit.pt.x = tvHit.pt.x - rect.left
		tvHit.pt.y = tvHit.pt.y - rect.top

		SendMessageA (tvDragItem, $$TVM_HITTEST, 0, &tvHit)

		IF tvHit.hItem != s_dragItem THEN
			ImageList_DragShowNolock ($$FALSE)
			SendMessageA (tvDragItem, $$TVM_SELECTITEM, $$TVGN_DROPHILITE, tvHit.hItem)
			ImageList_DragShowNolock (1)
			s_dragItem = tvHit.hItem
		ENDIF

		IF WinXTreeView_GetChildItem (tvDragItem, tvHit.hItem) THEN
			SetTimer (hWnd, -1, 400, 0)
			s_lastDragItem = s_dragItem
		ENDIF

		ret_value = @binding.onDrag(GetDlgCtrlID (tvDragItem), $$DRAG_DRAGGING, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
		ImageList_DragMove (pt.x, pt.y)
	END SUB
	SUB endDragTreeViewItem
		IF tvDragButton THEN
			tvDragButton = 0
			ImageList_EndDrag ()
			IF tvDragImage THEN
				ImageList_Destroy (tvDragImage)
				tvDragImage = 0
			ENDIF
			ReleaseCapture ()
			SendMessageA (tvDragItem, $$TVM_SELECTITEM, $$TVGN_DROPHILITE, 0)
		ENDIF
	END SUB
END FUNCTION
'
' ######################
' #####  onNotify  #####
' ######################
' Handles notification messages
FUNCTION onNotify (hWnd, wParam, lParam, BINDING binding)

	SHARED tvDragButton
	SHARED tvDragItem
	SHARED tvDragImage

	NMHDR nmhdr
	TV_DISPINFO nmtvdi
	NM_TREEVIEW nmtv
	LV_DISPINFO nmlvdi
	NMKEY nmkey
	NM_LISTVIEW nmlv
	NMSELCHANGE nmsc
	RECT rect
	SYSTEMTIME sysTime		' for message $$MCN_SELCHANGE

	XLONG ret_value		' return code when bHandled = $$TRUE

	SetLastError (0)
	IFZ hWnd THEN RETURN
	IFZ lParam THEN RETURN

	ret_value = 0		' not handled

	pNmhdr = &nmhdr
	XLONGAT (&&nmhdr) = lParam

	SELECT CASE nmhdr.code
		CASE $$NM_CLICK, $$NM_DBLCLK, $$NM_RCLICK, $$NM_RDBLCLK, $$NM_RETURN, $$NM_HOVER
			ret_value = @binding.onItem (nmhdr.idFrom, nmhdr.code, 0)

		CASE $$NM_KEYDOWN
			IF binding.onItem THEN
				pNmkey = &nmkey
				XLONGAT (&&nmkey) = lParam
				ret_value = @binding.onItem (nmhdr.idFrom, nmhdr.code, nmkey.nVKey)
				XLONGAT (&&nmkey) = pNmkey
			ENDIF

		CASE $$MCN_SELECT, $$MCN_SELCHANGE
			IF binding.onCalendarSelect THEN
				pNmsc = &nmsc
				XLONGAT (&&nmsc) = lParam
' 0.6.0.2-old---
'				ret_value = @binding.onCalendarSelect (nmhdr.idFrom, nmsc.stSelStart)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
				IF notifyCode = $$MCN_SELECT THEN
					sysTime = nmsc.stSelStart
				ELSE
					SendMessageA (nmsc.hdr.hwndFrom, $$MCM_GETCURSEL, SIZE (SYSTEMTIME), &sysTime)
				ENDIF
				ret_value = @binding.onCalendarSelect (nmhdr.idFrom, sysTime)
' 0.6.0.2-new~~~
				XLONGAT (&&nmsc) = pNmsc
			ENDIF

		CASE $$TVN_BEGINLABELEDIT		'  sent as notification
			' the program sent a message $$TVM_EDITLABEL
			IF binding.onLabelEdit THEN
				pNmtvdi = &nmtvdi
				XLONGAT (&&nmtvdi) = lParam
				'.onLabelEdit(idCtr, edit_const, edit_item, newLabel$)
				ret = @binding.onLabelEdit(nmtvdi.hdr.idFrom, $$EDIT_START, nmtvdi.item.hItem, "")
				IFZ ret THEN ret_value = 1 ELSE ret_value = 0
				XLONGAT (&&nmtvdi) = pNmtvdi
			ENDIF

		CASE $$TVN_ENDLABELEDIT
			pNmtvdi = &nmtvdi
			XLONGAT (&&nmtvdi) = lParam
' 0.6.0.2-old---
'			ret_value = @binding.onLabelEdit(nmtvdi.hdr.idFrom, $$EDIT_DONE, nmtvdi.item.hItem, CSTRING$(nmtvdi.item.pszText))
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			newLabel$ = CSTRING$ (nmtvdi.item.pszText)
			IFZ binding.onLabelEdit THEN
				hTreeView = GetDlgItem (hWnd, nmtvdi.hdr.idFrom)
				WinXTreeView_SetItemLabel (hTreeView, nmtvdi.item.hItem, newLabel$)		' update label
			ELSE
				' .onLabelEdit(idCtr, edit_const, edit_item, newLabel$)
				ret_value = @binding.onLabelEdit (nmtvdi.hdr.idFrom, $$EDIT_DONE, nmtvdi.item.hItem, newLabel$)
			ENDIF
' 0.6.0.2-new~~~
			XLONGAT (&&nmtvdi) = pNmtvdi

		CASE $$TVN_BEGINDRAG,$$TVN_BEGINRDRAG
			'begin the notify trap
			pNmtv = &nmtv
			XLONGAT (&&nmtv) = lParam
			IF @binding.onDrag(nmtv.hdr.idFrom, $$DRAG_START, nmtv.itemNew.hItem, nmtv.ptDrag.x, nmtv.ptDrag.y) THEN
				tvDragItem = nmtv.hdr.hwndFrom

				SELECT CASE nmhdr.code
					CASE $$TVN_BEGINDRAG	: tvDragButton = $$MBT_LEFT
					CASE $$TVN_BEGINRDRAG	: tvDragButton = $$MBT_RIGHT
				END SELECT

				XLONGAT (&rect) = nmtv.itemNew.hItem
				SendMessageA (nmtv.hdr.hwndFrom, $$TVM_GETITEMRECT, $$TRUE, &rect)
				rect.left = rect.left-SendMessageA (nmtv.hdr.hwndFrom, $$TVM_GETINDENT, 0, 0)

				'create the dragging image
				w = rect.right-rect.left
				h = rect.bottom-rect.top
				hDCtv = GetDC (nmtv.hdr.hwndFrom)
				mDC = CreateCompatibleDC (hDCtv)
				hBmp = CreateCompatibleBitmap (hDCtv, w, h)
				hEmpty = SelectObject (mDC, hBmp)
				BitBlt (mDC, 0, 0, w, h, hDCtv, rect.left, rect.top, $$SRCCOPY)
				SelectObject (mDC, hEmpty)
				ReleaseDC (nmtv.hdr.hwndFrom, hDCtv)
				DeleteDC (mDC)

				tvDragImage = ImageList_Create (w, h, $$ILC_COLOR32|$$ILC_MASK, 1, 0)
				ImageList_AddMasked (tvDragImage, hBmp, 0x00FFFFFF)

				ImageList_BeginDrag (tvDragImage, 0, nmtv.ptDrag.x-rect.left, nmtv.ptDrag.y-rect.top)
				ImageList_DragEnter (GetDesktopWindow (), rect.left, rect.top)

				SetCapture (hWnd)		' snap mouse & window
			ENDIF
			XLONGAT (&&nmtv) = pNmtv

' 0.6.0.2-new+++
		CASE $$LVN_ITEMCHANGED, $$TVN_SELCHANGED
			RETURN @binding.onItem (idCtr, nmhdr.code, lParam)
' 0.6.0.2-new~~~

		CASE $$TCN_SELCHANGE
			IF nmhdr.hwndFrom THEN
				currTab = SendMessageA (nmhdr.hwndFrom, $$TCM_GETCURSEL, 0, 0)
				maxTab = SendMessageA (nmhdr.hwndFrom, $$TCM_GETITEMCOUNT, 0, 0)-1
				FOR i = 0 TO maxTab
					'only current tab is visible
					IF i = currTab THEN visible = $$TRUE ELSE visible = $$FALSE
					autoSizerGroup_show (WinXTabs_GetAutosizerSeries (nmhdr.hwndFrom, i), visible)
					IF visible THEN
						refreshWindow (GetParent (nmhdr.hwndFrom))
					ENDIF
				NEXT i
			ENDIF

' 0.6.0.2-new+++
		CASE $$LVN_ITEMCHANGED, $$TVN_SELCHANGED
			RETURN @binding.onItem (nmhdr.idFrom, nmhdr.code, lParam)
' 0.6.0.2-new~~~

		CASE $$LVN_COLUMNCLICK
			IF binding.onColumnClick THEN
				pNmlv = &nmlv		' listview structure
				XLONGAT (&&nmlv) = lParam
				ret_value = @binding.onColumnClick (nmhdr.idFrom, nmlv.iSubItem)
				XLONGAT (&&nmlv) = pNmlv
			ENDIF

		CASE $$LVN_BEGINLABELEDIT		'  sent as notification
			' the program sent a message $$LVM_EDITLABEL
			IF binding.onLabelEdit THEN
				pNmlvdi = &nmlvdi
				XLONGAT (&&nmlvdi) = lParam
				'.onLabelEdit (idCtr, edit_const, edit_item, edit_sub_item, newLabel$)
				ret = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_START, nmlvdi.item.iItem, "")
				IFZ ret THEN ret_value = $$TRUE ELSE ret_value = $$FALSE
				XLONGAT (&&nmlvdi) = pNmlvdi
			ENDIF

		CASE $$LVN_ENDLABELEDIT
			pNmlvdi = &nmlvdi
			XLONGAT (&&nmlvdi) = lParam
' 0.6.0.2-old---
'			ret_value = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_DONE, nmlvdi.item.iItem, CSTRING$(nmlvdi.item.pszText))
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			newText$ = CSTRING$ (nmlvdi.item.pszText)
			IFZ binding.onLabelEdit THEN
				hLV = GetDlgItem (hWnd, nmlvdi.hdr.idFrom)
				WinXListView_SetItemText (hLV, nmlvdi.item.iItem, nmlvdi.item.iSubItem, newText$)		' update text
			ELSE
				'.onLabelEdit (idCtr, edit_const, edit_item, edit_sub_item, newLabel$)
				ret_value = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_DONE, nmlvdi.item.iItem, newText$)
			ENDIF
' 0.6.0.2-new~~~
			XLONGAT (&&nmlvdi) = pNmlvdi
	END SELECT

	XLONGAT (&&nmhdr) = pNmhdr
	RETURN ret_value

END FUNCTION
'
' ###########################
' #####  initPrintInfo  #####
' ###########################
FUNCTION initPrintInfo ()
	SHARED	PRINTINFO	printInfo
	PAGESETUPDLG pageSetupDlg

	'pageSetupDlg.lStructSize = SIZE (PAGESETUPDLG)
	'pageSetupDlg.flags = $$PSD_DEFAULTMINMARGINS|$$PSD_RETURNDEFAULT
	'PageSetupDlgA (&pageSetupDlg)

	'printInfo.hDevMode = pageSetupDlg.hDevMode
	'printInfo.hDevNames = pageSetupDlg.hDevNames
	printInfo.rangeMin = 1
	printInfo.rangeMax = -1
	printInfo.marginLeft = 1000
	printInfo.marginRight = 1000
	printInfo.marginTop = 1000
	printInfo.marginBottom = 1000
	printInfo.printSetupFlags = $$PD_ALLPAGES
'
' 0.6.0.2-new+++
' TECHNICAL TRICK
' ===============
' GL: Prevent these functions to be optimized out.
'
	addrCallback = &cancelDlgOnClose()
	addrCallback = &cancelDlgOnCommand()
' 0.6.0.2-new~~~
'
END FUNCTION
'
' ############################
' #####  printAbortProc  #####
' ############################
' Abort proc for printing
' (hdc, nCode are unused!)
FUNCTION printAbortProc (hdc, nCode)
	SHARED	PRINTINFO	printInfo
	MSG msg

	' Check to see if any messages are waiting in the queue
	DO WHILE PeekMessageA (&msg, 0, 0, 0, $$PM_REMOVE)
		IFZ IsDialogMessageA (printInfo.hCancelDlg, &msg) THEN
			' Translate the message and dispatch it to WindowProc()
			TranslateMessage (&msg)
			DispatchMessageA (&msg)
		ENDIF
' 0.6.0.2-new+++
		' If the message is WM_QUIT, exit the WHILE loop
		IF msg.message = $$WM_QUIT THEN EXIT DO
' 0.6.0.2-new~~~
	LOOP

	RETURN printInfo.continuePrinting
END FUNCTION
'
' ###################################
' #####  groupBox_SizeContents  #####
' ###################################
' Gets the viewable area for a group box
' returns the auto sizer series, -1 if fail.
FUNCTION groupBox_SizeContents (hGB, pRect)
	RECT rect

	SetLastError (0)
	r_series = -1		' NOT a group series

	IF hGB THEN
		aRect = &rect
		XLONGAT (&&rect) = pRect

		ret = GetClientRect (hGB, &rect)
		IFZ ret THEN
			msg$ = "groupBox_SizeContents: Can't get the client rectangle of the group box"
			GuiTellApiError (msg$)
		ELSE
			rect.left = rect.left+4
			rect.right = rect.right-4
			rect.top = rect.top+16
			rect.bottom = rect.bottom-4

			XLONGAT (&&rect) = aRect

			group_series = GetPropA (hGB, &$$auto_sizer$)
			IF group_series > 0 THEN r_series = group_series		' 0 is NEVER a group series
		ENDIF
	ENDIF

	RETURN r_series

END FUNCTION
'
' ###############################
' #####  tabs_SizeContents  #####
' ###############################
' Resizes a tabstrip
' hTabs = tab control
' pRect = pointer to a RECT structure
' returns the auto sizer series or -1 on fail.
FUNCTION tabs_SizeContents (hTabs, pRect)

	SetLastError (0)
	series = -1		' not an index
	IF hTabs THEN
		IF pRect THEN
			ret = GetClientRect (hTabs, pRect)
			IFZ ret THEN
				msg$ = "tabs_SizeContents: Can't get the rectangle of the tab control"
				GuiTellApiError (msg$)
			ELSE
				SendMessageA (hTabs, $$TCM_ADJUSTRECT, 0, pRect)
				series = WinXTabs_GetAutosizerSeries (hTabs, WinXTabs_GetCurrentTab (hTabs))
			ENDIF
		ENDIF
	ENDIF
	RETURN series

END FUNCTION
'
' ###########################
' #####  refreshWindow  #####
' ###########################
' Refreshes a window
' hWnd = handle to the window to refresh
FUNCTION refreshWindow (hWnd)
	RECT rect

	SetLastError (0)
	IF hWnd THEN
		ret = GetClientRect (hWnd, &rect)
		IF ret THEN
			sizeWindow (hWnd, rect.right-rect.left, rect.bottom-rect.top)
		ENDIF
	ENDIF
END FUNCTION
'
' ########################
' #####  sizeWindow  #####
' ########################
' Resizes a window
' hWnd = handle to the window to resize
' wNew and hNew = new width and height
' returns nothing of interest
FUNCTION sizeWindow (hWnd, wNew, hNew)

	BINDING	binding
	SCROLLINFO si
'	WINDOWPLACEMENT WinPla
	RECT rect
	RECT tmpRect

	SetLastError (0)
	ret_value = 0

	'get the binding
	SELECT CASE Get_binding (hWnd, @idBinding, @binding)
		CASE $$TRUE
			'handle the minimum width
			bResize = $$FALSE
			IF wNew < binding.minW THEN
				wNew = binding.minW
				bResize = $$TRUE
			ENDIF

			'handle the minimum height
			IF hNew < binding.minH THEN
				hNew = binding.minH
				bResize = $$TRUE
			ENDIF

			IF bResize THEN SetWindowPos (hWnd, $$HWND_TOP, 0, 0, wNew, hNew, $$SWP_NOMOVE)

			IF binding.hBar THEN
				'now handle the toolbar
				GetClientRect (binding.hBar, &tmpRect)
				height = tmpRect.bottom - tmpRect.top
				SendMessageA (binding.hBar, $$WM_SIZE, wNew, height)
			ENDIF

			IF binding.hStatus THEN
				'handle the status bar
				GetClientRect (binding.hStatus, &rect)
				height = rect.bottom - rect.top
				SendMessageA (binding.hStatus, $$WM_SIZE, wNew, height)

				' first, resize the partitions
				cPart = binding.statusParts + 1
				IF cPart <= 0 THEN cPart = 1
				uppPart = cPart - 1
				DIM parts[uppPart]

				IF cPart > 1 THEN
					FOR i = 0 TO uppPart
						parts[i] = ((i + 1) * wNew) / cPart
					NEXT i
				ENDIF
				parts[uppPart] = -1		' extend to the right edge of the window

				SendMessageA (binding.hStatus, $$SB_SETPARTS, cPart, &parts[0])
				SendMessageA (binding.hStatus, $$WM_SIZE, wNew, hNew)
				'MoveWindow (binding.hStatus, 0, 0, 0, 0, 1)		'reposition status bar?
			ENDIF

			'and the scroll bars
			xoff = 0
			yoff = 0

			style = GetWindowLongA (hWnd, $$GWL_STYLE)

			IF style AND $$WS_HSCROLL THEN
				si.cbSize = SIZE (SCROLLINFO)
				si.fMask = $$SIF_PAGE|$$SIF_DISABLENOSCROLL
				si.nPage = (wNew * binding.hScrollPageM) + binding.hScrollPageC
				SetScrollInfo (hWnd, $$SB_HORZ, &si, $$TRUE)

				si.fMask = $$SIF_POS
				GetScrollInfo (hWnd, $$SB_HORZ, &si)
				xoff = si.nPos
			ENDIF

			IF style AND $$WS_VSCROLL THEN
				si.cbSize = SIZE (SCROLLINFO)
				si.fMask = $$SIF_PAGE|$$SIF_DISABLENOSCROLL
				si.nPage = (hNew * binding.vScrollPageM) + binding.vScrollPageC
				SetScrollInfo (hWnd, $$SB_VERT, &si, $$TRUE)

				si.fMask = $$SIF_POS
				GetScrollInfo (hWnd, $$SB_VERT, &si)
				yoff = si.nPos
			ENDIF

			IF binding.autoSizerInfo >= 0 THEN
				'use the auto sizer
				WinXGetUseableRect (hWnd, @tmpRect)
				x = tmpRect.left   - xoff
				y = tmpRect.top    - yoff
				w = tmpRect.right  - tmpRect.left
				h = tmpRect.bottom - tmpRect.top
				autoSizerGroup_size (binding.autoSizerInfo, x, y, w, h)
			ENDIF

			IF binding.onScroll THEN
				@binding.onScroll (xoff, hWnd, $$DIR_HORIZ)
				@binding.onScroll (yoff, hWnd, $$DIR_VERT)
			ENDIF

			IF binding.dimControls THEN
				ret_value = @binding.dimControls (hWnd, wNew, hNew)
			ENDIF

			InvalidateRect (hWnd, 0, $$FALSE)

	END SELECT

	RETURN ret_value

END FUNCTION
'
' ##########################
' #####  splitterProc  #####
' ##########################
' Window procedure for WinX Splitters.
FUNCTION splitterProc (hSplitter, wMsg, wParam, lParam)

	STATIC dragging
	STATIC POINT mousePos
	STATIC inDock
	STATIC mouseIn
	STATIC POINT vertex[]

	AUTOSIZERINFO sizerBlock
	SPLITTERINFO splitterInfo
	RECT rect
	RECT dock
	PAINTSTRUCT ps
	TRACKMOUSEEVENT tme
	POINT newMousePos
	POINT pt

	SetLastError (0)
	SPLITTERINFO_Get (GetWindowLongA (hSplitter, $$GWL_USERDATA), @splitterInfo)

	SELECT CASE wMsg
		CASE $$WM_CREATE
			'lParam format = iSlitterInfo
			SetWindowLongA (hSplitter, $$GWL_USERDATA, XLONGAT (lParam))
			mouseIn = 0

			DIM vertex[2]

		CASE $$WM_PAINT
			hDC = BeginPaint (hSplitter, &ps)

			hShadPen = CreatePen ($$PS_SOLID, 1, GetSysColor ($$COLOR_3DSHADOW))
			hBlackPen = CreatePen ($$PS_SOLID, 1, 0x000000)
			hBlackBrush = CreateSolidBrush (0x000000)
			hHighlightBrush = CreateSolidBrush (GetSysColor($$COLOR_HIGHLIGHT))
			SelectObject (hDC, hShadPen)

			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hSplitter, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN FillRect (hDC, &dock, hHighlightBrush)

			SELECT CASE splitterInfo.direction AND 0x00000003
				CASE $$DIR_VERT
					SELECT CASE TRUE
						CASE $$DOCK_DISABLED
						CASE ((splitterInfo.dock = $$DOCK_FORWARD)&&(splitterInfo.docked = 0))|| _
						((splitterInfo.dock = $$DOCK_BACKWARD)&&(splitterInfo.docked > 0))
							GOSUB DrawVert
							' Draw arrows
							SelectObject (hDC, hBlackPen)
							SelectObject (hDC, hBlackBrush)
							vertex[0].x = 3+dock.left
							vertex[0].y = 5+dock.top
							vertex[1].x = 9+dock.left
							vertex[1].y = 5+dock.top
							vertex[2].x = 6+dock.left
							vertex[2].y = 2+dock.top
							Polygon (hDC, &vertex[0], 3)
							vertex[0].x = 3+dock.left+107
							vertex[0].y = 5+dock.top
							vertex[1].x = 9+dock.left+107
							vertex[1].y = 5+dock.top
							vertex[2].x = 6+dock.left+107
							vertex[2].y = 2+dock.top
							Polygon (hDC, &vertex[0], 3)
						CASE ((splitterInfo.dock = $$DOCK_BACKWARD)&&(splitterInfo.docked = 0))|| _
						((splitterInfo.dock = $$DOCK_FORWARD)&&(splitterInfo.docked > 0))
							GOSUB DrawVert
							' Draw arrows
							SelectObject (hDC, hBlackPen)
							SelectObject (hDC, hBlackBrush)
							vertex[0].x = 3+dock.left
							vertex[0].y = 2+dock.top
							vertex[1].x = 9+dock.left
							vertex[1].y = 2+dock.top
							vertex[2].x = 6+dock.left
							vertex[2].y = 5+dock.top
							Polygon (hDC, &vertex[0], 3)
							vertex[0].x = 3+dock.left+107
							vertex[0].y = 2+dock.top
							vertex[1].x = 9+dock.left+107
							vertex[1].y = 2+dock.top
							vertex[2].x = 6+dock.left+107
							vertex[2].y = 5+dock.top
							Polygon (hDC, &vertex[0], 3)
					END SELECT
				CASE $$DIR_HORIZ
					SELECT CASE TRUE
						CASE $$DOCK_DISABLED
						CASE ((splitterInfo.dock = $$DOCK_FORWARD)&&(splitterInfo.docked = 0))|| _
						((splitterInfo.dock = $$DOCK_BACKWARD)&&(splitterInfo.docked > 0))
							GOSUB DrawHoriz
							' Draw arrows
							SelectObject (hDC, hBlackPen)
							SelectObject (hDC, hBlackBrush)
							vertex[0].x = 5+dock.left
							vertex[0].y = 3+dock.top
							vertex[1].x = 2+dock.left
							vertex[1].y = 6+dock.top
							vertex[2].x = 5+dock.left
							vertex[2].y = 9+dock.top
							Polygon (hDC, &vertex[0], 3)
							vertex[0].x = 5+dock.left
							vertex[0].y = 3+dock.top+107
							vertex[1].x = 2+dock.left
							vertex[1].y = 6+dock.top+107
							vertex[2].x = 5+dock.left
							vertex[2].y = 9+dock.top+107
							Polygon (hDC, &vertex[0], 3)
						CASE ((splitterInfo.dock = $$DOCK_BACKWARD)&&(splitterInfo.docked = 0))|| _
						((splitterInfo.dock = $$DOCK_FORWARD)&&(splitterInfo.docked > 0))
							GOSUB DrawHoriz
							' Draw arrows
							SelectObject (hDC, hBlackPen)
							SelectObject (hDC, hBlackBrush)
							vertex[0].x = 2+dock.left
							vertex[0].y = 3+dock.top
							vertex[1].x = 5+dock.left
							vertex[1].y = 6+dock.top
							vertex[2].x = 2+dock.left
							vertex[2].y = 9+dock.top
							Polygon (hDC, &vertex[0], 3)
							vertex[0].x = 2+dock.left
							vertex[0].y = 3+dock.top+107
							vertex[1].x = 5+dock.left
							vertex[1].y = 6+dock.top+107
							vertex[2].x = 2+dock.left
							vertex[2].y = 9+dock.top+107
							Polygon (hDC, &vertex[0], 3)
					END SELECT
			END SELECT

			DeleteObject (hShadPen)
			DeleteObject (hBlackPen)
			DeleteObject (hBlackBrush)

			EndPaint (hSplitter, &ps)

			RETURN 0

		CASE $$WM_LBUTTONDOWN
			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hSplitter, &pt)
			IFF PtInRect (&dock, pt.x, pt.y) || splitterInfo.docked THEN
				SetCapture (hSplitter)
				dragging = $$TRUE
				mousePos.x = LOWORD (lParam)
				mousePos.y = HIWORD (lParam)
				ClientToScreen (hSplitter, &mousePos)
			ENDIF

			RETURN 0

		CASE $$WM_SETCURSOR
			GOSUB GetRect

			GetCursorPos (&pt)
			ScreenToClient (hSplitter, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
				SetCursor (LoadCursorA (0, $$IDC_HAND))
			ELSE
				GOSUB SetSizeCursor
			ENDIF

			RETURN $$TRUE		' fail

		CASE $$WM_MOUSEMOVE
			GOSUB GetRect

			GetCursorPos (&pt)
			ScreenToClient (hSplitter, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
				IFF inDock THEN
					'SetCursor (LoadCursorA (0, $$IDC_HAND))
					InvalidateRect (hSplitter, 0, 1)		' erase
				ENDIF
				inDock = $$TRUE
			ELSE
				IF inDock THEN
					'GOSUB SetSizeCursor
					InvalidateRect (hSplitter, 0, 1)		' erase
				ENDIF
				inDock = $$FALSE
			ENDIF

			IFF mouseIn THEN
				GetCursorPos (&pt)
				ScreenToClient (hSplitter, &pt)
				IF PtInRect (&dock, pt.x, pt.y) THEN
					SetCursor (LoadCursorA (0, $$IDC_HAND))
					InvalidateRect (hSplitter, 0, 1)		' erase
					inDock = $$TRUE
				ELSE
					GOSUB SetSizeCursor
					inDock = $$FALSE
				ENDIF

				tme.cbSize = SIZE (tme)
				tme.dwFlags = $$TME_LEAVE
				tme.hwndTrack = hSplitter
				TrackMouseEvent (&tme)
				mouseIn = $$TRUE
			ENDIF

			IF dragging THEN
' 0.6.0.2-new+++
				IF splitterInfo.group <= 0 THEN RETURN
				IF splitterInfo.id < 0 THEN RETURN
' 0.6.0.2-new~~~
				newMousePos.x = LOWORD (lParam)
				newMousePos.y = HIWORD (lParam)
				ClientToScreen (hSplitter, &newMousePos)

				'PRINT mouseX, newMouseX, mouseY, newMouseY

				autoSizerInfo_get (splitterInfo.group, splitterInfo.id, @sizerBlock)

				SELECT CASE splitterInfo.direction AND 0x00000003
					CASE $$DIR_HORIZ : delta = newMousePos.x - mousePos.x
					CASE $$DIR_VERT  : delta = newMousePos.y - mousePos.y
				END SELECT

				IFZ delta THEN RETURN 0		' fail
				IF splitterInfo.direction AND $$DIR_REVERSE THEN
					sizerBlock.size = sizerBlock.size-delta
					IF splitterInfo.min && sizerBlock.size < splitterInfo.min THEN
						sizerBlock.size = splitterInfo.min
					ELSE
						IF splitterInfo.max && (sizerBlock.size > splitterInfo.max) THEN sizerBlock.size = splitterInfo.max
					ENDIF
				ELSE
					sizerBlock.size = sizerBlock.size+delta
					IF splitterInfo.max && (sizerBlock.size > splitterInfo.max) THEN
						sizerBlock.size = splitterInfo.max
					ELSE
						IF splitterInfo.min && sizerBlock.size < splitterInfo.min THEN sizerBlock.size = splitterInfo.min
					ENDIF
				ENDIF

				IF sizerBlock.size < 8 THEN
					sizerBlock.size = 8
				ELSE
					IF sizerBlock.size > splitterInfo.maxSize THEN sizerBlock.size = splitterInfo.maxSize
				ENDIF

				autoSizerInfo_update (splitterInfo.group, splitterInfo.id, sizerBlock)
				refreshWindow (GetParent (hSplitter))

				mousePos = newMousePos
			ENDIF

			RETURN 0

		CASE $$WM_LBUTTONUP
			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hSplitter, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
' 0.6.0.2-new+++
				IF splitterInfo.group <= 0 THEN RETURN
				IF splitterInfo.id < 0 THEN RETURN
' 0.6.0.2-new~~~
				IF splitterInfo.docked THEN
					autoSizerInfo_get (splitterInfo.group, splitterInfo.id, @sizerBlock)
					sizerBlock.size = splitterInfo.docked
					splitterInfo.docked = 0

					SPLITTERINFO_Update (GetWindowLongA (hSplitter, $$GWL_USERDATA), splitterInfo)

					autoSizerInfo_update (splitterInfo.group, splitterInfo.id, sizerBlock)
					refreshWindow (GetParent (hSplitter))
				ELSE
					autoSizerInfo_get (splitterInfo.group, splitterInfo.id, @sizerBlock)
					splitterInfo.docked = sizerBlock.size
					sizerBlock.size = 8

					SPLITTERINFO_Update (GetWindowLongA (hSplitter, $$GWL_USERDATA), splitterInfo)

					autoSizerInfo_update (splitterInfo.group, splitterInfo.id, sizerBlock)
					refreshWindow (GetParent (hSplitter))
				ENDIF
			ELSE
				dragging = $$FALSE
				ReleaseCapture ()
			ENDIF

			RETURN 0

		CASE $$WM_MOUSELEAVE
			InvalidateRect (hSplitter, 0, 1)		' erase
			mouseIn = $$FALSE

			RETURN 0

		CASE $$WM_DESTROY
			SPLITTERINFO_Delete (GetWindowLongA (hSplitter, $$GWL_USERDATA))

			RETURN 0

		CASE ELSE
			RETURN DefWindowProcA (hSplitter, wMsg, wParam, lParam)

	END SELECT

	SUB DrawVert
		' Draw border
		MoveToEx (hDC, dock.left, dock.top, 0)
		LineTo (hDC, dock.left, dock.bottom)
		MoveToEx (hDC, dock.right, dock.top, 0)
		LineTo (hDC, dock.right, dock.bottom)

		' Draw the line
		state = 0
		FOR i = 13 TO 106
			SELECT CASE state
				CASE 0
					SetPixel (hDC, dock.left+i, 3, GetSysColor($$COLOR_3DHILIGHT))
					INC state
				CASE 1
					SetPixel (hDC, dock.left+i, 4, GetSysColor($$COLOR_3DSHADOW))
					INC state
				CASE 2
					state = 0
			END SELECT
		NEXT i
	END SUB

	SUB DrawHoriz
		' Draw border
		MoveToEx (hDC, dock.left, dock.top, 0)
		LineTo (hDC, dock.right, dock.top)
		MoveToEx (hDC, dock.left, dock.bottom, 0)
		LineTo (hDC, dock.right, dock.bottom)

		' Draw the line
		state = 0
		FOR i = 13 TO 106
			SELECT CASE state
				CASE 0
					SetPixel (hDC, 3, i+dock.top, GetSysColor($$COLOR_3DHILIGHT))
					INC state
				CASE 1
					SetPixel (hDC, 4, i+dock.top, GetSysColor($$COLOR_3DSHADOW))
					INC state
				CASE 2
					state = 0
			END SELECT
		NEXT i
	END SUB

	SUB GetRect
		IF splitterInfo.dock = $$DOCK_DISABLED THEN
			dock.left = 0
			dock.right = 0
			dock.bottom = 0
			dock.top = 0
		ELSE
			SetLastError (0)
			ret = GetClientRect (hSplitter, &rect)
			IFZ ret THEN
				msg$ = "splitterProc: Can't get the client rectangle of the window"
				GuiTellApiError (msg$)
			ELSE
				SELECT CASE splitterInfo.direction AND 0x00000003
					CASE $$DIR_VERT
						dock.left = (rect.right-120)/2
						dock.right = dock.left+120
						dock.top = 0
						dock.bottom = 8
					CASE $$DIR_HORIZ
						dock.top = (rect.bottom-120)/2
						dock.bottom = dock.top+120
						dock.left = 0
						dock.right = 8
				END SELECT
			ENDIF
		ENDIF
	END SUB

	SUB SetSizeCursor
		IF (splitterInfo.direction AND 0x00000003) = $$DIR_HORIZ THEN
			cursor = $$IDC_SIZEWE		' vertical bar
		ELSE
			cursor = $$IDC_SIZENS		' horizontal bar
		ENDIF
		SetCursor (LoadCursorA (0, cursor))
	END SUB

END FUNCTION
'
' Auto Drawer
'
DefineAccess(AUTODRAWRECORD)
'
' Generic Linked List
'
DefineAccess(LINKEDLIST)
'
' Splitter
'
DefineAccess(SPLITTERINFO)

END PROGRAM
