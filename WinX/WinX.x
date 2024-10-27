'
'
' ####################
' #####  PROLOG  #####
' ####################
'
PROGRAM "WinX"
VERSION "0.6.0.5"		' 27 October 2024
EXPLICIT
'CONSOLE
'
' WinX - *The* GUI library for XBLite
' Copyright (c) LGPL Callum Lowcay 2007-2008.
' Evolutions: Guy Lonne 2009-2024.
' Purpose: WinX.dll is a set of XBLite Win32 API wrappers for coding GUI applications.
'
' ------------------------------------------------------------------------------
' The WinX GUI library is distributed under the
' terms and conditions of the GNU LGPL, see the file COPYING_LIB
' which should be included in the WinX distribution.
' ------------------------------------------------------------------------------
'
'
' ***** Description *****
'
' Library WinX: the Windows API made easy!
'
' WinX.dll is a Windowing library for XBLite;
' it makes easy Windows GUI programming through a set of wrappers
' for the Windows APIs. WinX is perfect to experiment GUI coding
' by means of quick prototypes.
'
'
' ***** Notes *****
'
' No longer requires m4 macro processing to compile.
'
' Deploying WinX.dll for dynamic calls
' ====================================
' 1.Use SHIFT+F9 to compile
' 2.Use F10 to build WinX.dll
' Created:
' - ./WinX.dec
' - ./WinX.lib
' - ./WinX.dll
' 3.Enable 'clean' makefile option
' 4.Use again F10 to deploy WinX.dll
' Created:
' - C:/xblite/include/WinX.dec
' - C:/xblite/lib/WinX.lib
' - C:/xblite/programs/WinX.dll
'
' Contrary to the XBasic/XBLite convention of RETURNing an error flag bErr,
' WinX functions return bOK ($$TRUE on success).
'
'
' ***** Versions *****
'
' Contributors:
'     Callum Lowcay (original version 0.6.0.1 circa 2007)
'     Guy "GL" Lonne (evolutions)
'
' 0.6.0.1-Callum Lowcay-2007-Original version.
'
' 0.6.0.2-GL-10sep08-Small changes.
' - GL-10nov08-Corrected function WinXListBox_GetSelectionArray():
'              replaced wMsg by $$LB_GETSELITEMS since wMsg was not set and would be zero.
' - GL-28oct09-Forced hideReadOnly in WinXDialog_OpenFile$()
'              and allow to open "Read Only" (no lock) the selected file(s):
'              ofn.flags = ofn.flags OR $$OFN_READONLY		' show the checkbox "Read Only" (initially checked)
' - GL-28oct09-Added GUI accelerators.
'
' 0.6.0.3-GL-10nov08-Small changes.
' - Corrected function WinXListBox_GetSelectionArray.
' - Replaced wMsg by $$LB_GETSELITEMS since wMsg was not set and would be zero.
' - Added the new functions.
'
' Accelerators
' - WinXAddAcceleratorTable: create an accelerator table
' - WinXAttachAccelerator  : attach accelerator table to window
'
' 0.6.0.3-GL-10sep08-Added new functions.
' - WinXMakeFilterString$: make a filter string
' - WinXVersion$         : retrieve WinX current version
' - WinXKillFont         : release a logical font
'
' 0.6.0.4-GL-09apr24-Compile WinX.x is now "stand-alone".
' - GL removed any dependencies on:
'     . M4 code snippets
'     . xma.dll
'     . adt.dll
'
' 0.6.0.5-GL-27oct24-Added 5 new functions.
'-  WinXCtr_Adjust_size					: resize the control to reflect its window's new width and height
'-  WinXCtr_Adjust_width				: change the control's width to reflect its window's new width
'-  WinXCtr_Adjust_height				: change the control's height to reflect its window's new height
'-  WinXCtr_Slide_left_or_right	: slide left or right the control
'-  WinXCtr_Slide_up_or_down		: slide up or down the control
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
'	-- The following IMPORTs are needed for a DLL build.
'	(Comment out for a static build)
	IMPORT "xst"		' XBLite Standard Library
	IMPORT "xsx"		' XBLite Standard eXtended Library
'
' Needed for testing purpose only.
'	IMPORT "xio"		' console library
'
' No longer needed.
'	IMPORT "xma"		' XBLite Math Library (Sin/Asin/Sinh/Asinh/Log/Exp/Sqrt...)
'	IMPORT "adt"		' Callum's Abstract Data Types library
' DLL build===
'
' Win32 API DLL headers
'
	IMPORT "kernel32"			' Operating System
' ---Note: import kernel32 BEFORE gdi32
	IMPORT "gdi32"				' Graphic Device Interface
' ---Note: import gdi32 BEFORE shell32 and user32
	IMPORT "shell32"			' interface to Operating System
	IMPORT "user32"				' Windows management
'
' ---Note: import gdi32 BEFORE comctl32
	IMPORT "comctl32"			' Common controls; ==> initialize w/ InitCommonControlsEx ()
' ---Note: import comctl32 BEFORE comdlg32
	IMPORT "comdlg32"			' Standard dialog boxes (opening and saving files ...)
	IMPORT "advapi32"			' advanced API: security, services, registry ...
	IMPORT "msimg32"			' image manipulation
'
'
' ****************************************
' *****  COMPOSITE TYPE DEFINITIONS  *****
' ****************************************
'
TYPE LINKEDNODE
	XLONG	.iNext
	XLONG	.iData
END TYPE
'
TYPE LINKEDWALK
	XLONG	.first
	XLONG	.iPrev
	XLONG	.iCurrentNode
	XLONG	.iNext
	XLONG	.last
END TYPE

'Headers for linked lists
TYPE LINKEDLIST
	XLONG	.iHead
	XLONG	.iTail
	XLONG	.cItems
END TYPE
'
'
'the data type to manage bindings
TYPE BINDING
	XLONG			.hWnd						'handle of the window this binds to, when 0, this binding record is not in use
	XLONG			.backCol				'window background color
	XLONG			.hStatus				'handle of the status bar, if there is one
	XLONG			.statusParts		'the upper index of partitions in the status bar
	XLONG			.msgHandlers		'index into an array of arrays of message handlers
' .minW and .minH = the minimum width and height of the window rectangle
	XLONG			.minW
	XLONG			.minH
' .maxW and .maxH = the maximum width and height of the window rectangle
	XLONG			.maxW
	XLONG			.maxH
	XLONG			.autoDrawInfo		'information for the auto-draw (id >= 1)
	XLONG			.autoSizerInfo	'information for the auto-sizer (valid series: binding.autoSizerInfo >= 0)
	XLONG			.hBar						'either a toolbar or a rebar
	XLONG			.hToolTips			'each window gets a tooltip control
	DOUBLE		.hScrollPageM		'the high level scrolling data
	XLONG			.hScrollPageC
	XLONG			.hScrollUnit
	DOUBLE		.vScrollPageM
	XLONG			.vScrollPageC
	XLONG			.vScrollUnit
	XLONG			.useDialogInterface		'true to enable dialog style keyboard navigation amoung controls
	XLONG			.hWndNextClipViewer		'if .onClipChange() is used, we become a clipboard viewer
	XLONG			.hCursor							'custom cursor for this window
	XLONG			.isMouseInWindow
	XLONG			.hUpdateRegion
'
'new in 0.6.0.2
	XLONG			.hAccelTable		' handle of the window's accelerator table
'
' Callback Handlers.
'
	FUNCADDR	.paint(XLONG, XLONG)	'hWnd, hdc : paint the window
	FUNCADDR	.dimControls(XLONG, XLONG, XLONG)	'hWnd, w, h : dimension the controls
	FUNCADDR	.onCommand(XLONG, XLONG, XLONG)		'id, code, hWnd
	FUNCADDR	.onMouseMove(XLONG, XLONG, XLONG)	'hWnd, x, y
	FUNCADDR	.onMouseDown(XLONG, XLONG, XLONG, XLONG)					'hWnd, MBT const, x, y
	FUNCADDR	.onMouseUp(XLONG, XLONG, XLONG, XLONG)						'hWnd, MBT const, x, y
	FUNCADDR	.onMouseWheel(XLONG, XLONG, XLONG, XLONG)	'hWnd, delta, x, y
	FUNCADDR	.onKeyDown(XLONG, XLONG)			'hWnd, virt_key
	FUNCADDR	.onKeyUp(XLONG, XLONG)				'hWnd, virt_key
	FUNCADDR	.onChar(XLONG, XLONG)				'hWnd, char
	FUNCADDR	.onScroll(XLONG, XLONG, XLONG)	'pos, hWnd, direction
	FUNCADDR	.onTrackerPos(XLONG, XLONG)		'id, pos
	FUNCADDR	.onDrag(XLONG, XLONG, XLONG, XLONG, XLONG)	'idControl, drag const, item, x, y
	FUNCADDR	.onLabelEdit(XLONG, XLONG, XLONG, STRING)	'idControl, edit const, item, newLabel
	FUNCADDR	.onClose(XLONG)	' hWnd
	FUNCADDR	.onFocusChange(XLONG, XLONG)	' hWnd, hasFocus
	FUNCADDR	.onClipChange()	' Sent when clipboard changes
	FUNCADDR	.onEnterLeave(XLONG, XLONG)	' hWnd, mouseInWindow
	FUNCADDR	.onItem(XLONG, XLONG, XLONG)		' idControl, event, parameter
	FUNCADDR	.onColumnClick(XLONG, XLONG)		' idControl, iColumn
	FUNCADDR	.onCalendarSelect(XLONG, SYSTEMTIME)	' idcal, time
	FUNCADDR	.onDropFiles(XLONG, XLONG, XLONG, STRING[])	' hWnd, x, y, files
'
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
'info for the auto-sizer
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
'
'info for WinX splitter
TYPE SPLITTERINFO
	XLONG			.group		' the group id
	XLONG			.id			'actually, it's an index (index >= 0) rather than an id (id >= 1)
	XLONG			.direction
	XLONG			.maxSize

	XLONG			.min
	XLONG			.max
	XLONG			.dock
	XLONG			.docked	' 0 if not docked, old position when docked
END TYPE
'
$$DOCK_DISABLED	= 0
$$DOCK_FORWARD  = 1
$$DOCK_BACKWARD	= 2
'data structures for auto-draw
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
' **************************
' *****  BLOCK EXPORT  *****
' **************************
'
EXPORT
'
' WinX - A Win32 abstraction for XBLite.
' Copyright (c) Callum Lowcay 2007-2008 - Licensed under the GNU LGPL
' Evolutions: Guy Lonne 2009-2024.
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
'
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

$$MAIN_CLASS$ = "WinXMainClass"

'WinX Auto-sizer Flags (sizer_block.flags)
$$SIZER_FLAGS_NONE  = 0x0
$$SIZER_SIZERELREST	= 0x00000001
$$SIZER_XRELRIGHT		= 0x00000002
$$SIZER_YRELBOTTOM	= 0x00000004
$$SIZER_SERIES			= 0x00000008
$$SIZER_WCOMPLEMENT	= 0x00000010
$$SIZER_HCOMPLEMENT	= 0x00000020
$$SIZER_SPLITTER		= 0x00000040
'
'WinX Splitter Flags
' 0.6.0.2-$$CONTROL			= 0
$$DIR_VERT		= 1
$$DIR_HORIZ		= 2
$$DIR_REVERSE	= 0x80000000

$$UNIT_LINE		= 0
$$UNIT_PAGE		= 1
$$UNIT_END		= 2
'
'Drag and Drop Operations
'
'drag states
$$DRAG_START		= 0
$$DRAG_DRAGGING	= 1
$$DRAG_DONE			= 2

'edit states
$$EDIT_START		= 0
$$EDIT_DONE			= 1

$$CHANNEL_RED		= 2
$$CHANNEL_GREEN	= 1
$$CHANNEL_BLUE	= 0
$$CHANNEL_ALPHA	= 3

$$ACL_REG_STANDARD = "D:(A;OICI;GRKRKW;;;WD)(A;OICI;GAKA;;;BA)"
'
'
' *************************
' *****   FUNCTIONS   *****
' *************************
'
'
DECLARE FUNCTION WinX () ' To be called first
'
' Accelerators
'
DECLARE FUNCTION WinXAddAccelerator (ACCEL @accel[], cmd, key, control, alt, shift) ' add accelerator key
DECLARE FUNCTION WinXAddAcceleratorTable (ACCEL @accel[]) ' create an accelerator table
DECLARE FUNCTION WinXAttachAccelerators (hWnd, hAccel) ' attach accelerator table to window
'
' Add Widget
'
DECLARE FUNCTION WinXAddAnimation (hParent, file$, idCtr) ' add animation file
DECLARE FUNCTION WinXAddButton (hParent, text$, hImage, idCtr) ' add push button
DECLARE FUNCTION WinXAddCalendar (hParent, @monthsX, @monthsY, idCtr) ' add calendar control
DECLARE FUNCTION WinXAddCheckBox (hParent, text$, isFirst, pushlike, idCtr) ' add checkbox
DECLARE FUNCTION WinXAddCheckButton (hParent, text$, isFirst, pushlike, idCtr) ' add check button
DECLARE FUNCTION WinXAddComboBox (hParent, listHeight, canEdit, images, idCtr) ' add combo box
DECLARE FUNCTION WinXAddControl (hParent, class$, text$, style, exStyle, idCtr) ' add custom control
DECLARE FUNCTION WinXAddEdit (hParent, text$, style, idCtr) ' add edit control
DECLARE FUNCTION WinXAddGroupBox (hParent, text$, idCtr) ' add group box
DECLARE FUNCTION WinXAddListBox (hParent, sort, multiSelect, idCtr) ' add list box control
DECLARE FUNCTION WinXAddListView (hParent, hilLargeIcons, hilSmallIcons, editable, view, idCtr) ' add list view control
DECLARE FUNCTION WinXAddProgressBar (hParent, smooth, idCtr) ' add progress bar
DECLARE FUNCTION WinXAddRadioButton (hParent, text$, isFirst, pushlike, idCtr) ' add radio button
DECLARE FUNCTION WinXAddStatic (hParent, text$, hImage, style, idCtr) ' add text box
DECLARE FUNCTION WinXAddStatusBar (hParent, initialStatus$, idCtr) ' add status bar
DECLARE FUNCTION WinXAddTabs (hParent, multiline, idCtr) ' add tabstip control
DECLARE FUNCTION WinXAddTimePicker (hParent, format, SYSTEMTIME initialTime, timeValid, idCtr) ' add time picker control
DECLARE FUNCTION WinXAddTooltip (hCtr, tooltipText$) ' add tooltips to control
DECLARE FUNCTION WinXAddTrackBar (hParent, enableSelection, posToolTip, idCtr) ' add track bar
DECLARE FUNCTION WinXAddTreeView (hParent, hImages, editable, draggable, idCtr) ' add treeview
'
' Animation
'
DECLARE FUNCTION WinXAni_Play (hAni) ' start playing the animation
DECLARE FUNCTION WinXAni_Stop (hAni) ' stop  playing the animation
'
' Auto-Sizer
'
DECLARE FUNCTION WinXAutoSizer_GetMainSeries (hWnd) ' get the window's main series
DECLARE FUNCTION WinXGroupBox_GetAutosizerSeries (hGB) ' get the group box's series
DECLARE FUNCTION WinXTabs_GetAutosizerSeries (hTabs, iTab) ' get the selected tab's series

' GL-Note: space# <=> DOUBLE space# (DOUBLE is the 32-bit IEEE Single Precision Floating Point)
DECLARE FUNCTION WinXAutoSizer_SetInfo (hWnd, series, space#, size#, left#, top#, width#, height#, flags) ' auto-sizer series setup
DECLARE FUNCTION WinXAutoSizer_SetSimpleInfo (hWnd, series, space#, size#, flags) ' simplified series setup
'
' Check Box or Radio Button
'
DECLARE FUNCTION WinXButton_GetCheck (hButton) ' get check state
DECLARE FUNCTION WinXButton_SetCheck (hButton, checked) ' set check state
'
' Calendar
'
DECLARE FUNCTION WinXCalendar_GetSelection (hCal, SYSTEMTIME @time)
DECLARE FUNCTION WinXCalendar_SetSelection (hCal, SYSTEMTIME time)
'
' WinX Clean-up
'
DECLARE FUNCTION WinXCleanUp () ' optional clean-up
'
' Windows Clipboard
'
DECLARE FUNCTION WinXClip_GetImage ()
DECLARE FUNCTION WinXClip_GetString$ ()
DECLARE FUNCTION WinXClip_IsImage ()
DECLARE FUNCTION WinXClip_IsString ()
DECLARE FUNCTION WinXClip_PutImage (hImage)
DECLARE FUNCTION WinXClip_PutString (Stri$)
'
' Combo Box
'
DECLARE FUNCTION WinXComboBox_AddItem (hCombo, index, indent, item$, iImage, iSelImage) ' add an item to a combo box
DECLARE FUNCTION WinXComboBox_Clear (hCombo) ' delete all items of combo box
DECLARE FUNCTION WinXComboBox_GetEditText$ (hCombo) ' get the text in the edit control
DECLARE FUNCTION WinXComboBox_GetItem$ (hCombo, index) ' get the text of an item
DECLARE FUNCTION WinXComboBox_GetSelection (hCombo) ' get the index of the selected item
DECLARE FUNCTION WinXComboBox_RemoveItem (hCombo, index)
DECLARE FUNCTION WinXComboBox_SetEditText (hCombo, text$) ' set the text in the edit control
DECLARE FUNCTION WinXComboBox_SetSelection (hCombo, index) ' select an item
'
' Control Size and Position Within its Window
'
DECLARE FUNCTION WinXCtr_Adjust_size      (hWnd, win_initW, win_initH, winWidth, winHeight, bMenu, idCtr, x_init, y_init, w_init, h_init, @new_w, @new_h)		' resize the control to reflect its window's new width and height
DECLARE FUNCTION WinXCtr_Adjust_width     (hWnd, win_initW, winWidth, idCtr, w_init, h_init, @new_w)		' change the control's width to reflect its window's new width
DECLARE FUNCTION WinXCtr_Adjust_height    (hWnd, win_initH, winHeight, bMenu, idCtr, w_init, h_init, @new_h)		' change the control's height to reflect its window's new height

DECLARE FUNCTION WinXCtr_Slide_left_or_right (hWnd, win_initW, winWidth, idCtr, x_init, y_init, @new_x)		' slide left or right the control
DECLARE FUNCTION WinXCtr_Slide_up_or_down		 (hWnd, win_initH, winHeight, bMenu, idCtr, x_init, y_init, @new_y)		' slide up or down the control
'
' Standard Win32 API Dialogs
'
DECLARE FUNCTION WinXDialog_Error (msg$, title$, severity) ' display an error dialog box
DECLARE FUNCTION WinXDialog_OpenFile$ (hOwner, title$, extensions$, initialName$, multiSelect) ' File Open Dialog
DECLARE FUNCTION WinXDialog_Question (hOwner, msg$, title$, cancel, defaultButton) ' display a dialog asking the User a question
DECLARE FUNCTION WinXDialog_SaveFile$ (hOwner, title$, extensions$, initialName$, overwritePrompt) ' File Save Dialog

DECLARE FUNCTION WinXMakeFilterString$ (file_filter$) ' make a filter string
'
' Drawing Functions
'
DECLARE FUNCTION WinXDrawArc (hWnd, hPen, x1, y1, x2, y2, DOUBLE theta1, DOUBLE theta2)
DECLARE FUNCTION WinXDrawBezier (hWnd, hPen, x1, y1, x2, y2, xC1, yC1, xC2, yC2)
DECLARE FUNCTION WinXDrawEllipse (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawFilledArea (hWnd, hBrush, colBound, x, y)
DECLARE FUNCTION WinXDrawFilledEllipse (hWnd, hPen, hBrush, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawFilledRect (hWnd, hPen, hBrush, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawImage (hWnd, hImage, x, y, w, h, xSrc, ySrc, blend)
DECLARE FUNCTION WinXDrawLine (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawRect (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawText (hWnd, hFont, text$, x, y, backRGB, forRGB)

DECLARE FUNCTION WinXDraw_Clear (hWnd) ' clear all the graphics in a window
DECLARE FUNCTION WinXClear (hWnd) ' clear all the graphics in a window
'
' RGB Color
'
DECLARE FUNCTION WinXDraw_GetColor (hOwner, initialRGB) ' Color Picker
DECLARE FUNCTION WinXDraw_GetColour (hOwner, initialRGB) ' Colour Picker
'
' Logical Font
'
DECLARE FUNCTION LOGFONT WinXDraw_MakeLogFont (font$, height, style)
DECLARE FUNCTION WinXKillFont (@hFont) ' free a logical font
DECLARE FUNCTION WinXDraw_GetFontDialog (hOwner, LOGFONT @logFont, @fontRGB) ' Font Picker
DECLARE FUNCTION WinXDraw_GetFontHeight (hFont, @ascent, @descent)
DECLARE FUNCTION WinXSetFont (hCtr, hFont) ' apply font to control
'
' Image
'
DECLARE FUNCTION WinXDraw_CopyImage (hImage)
DECLARE FUNCTION WinXDraw_CreateImage (w, h)
DECLARE FUNCTION WinXDraw_DeleteImage (hImage)
DECLARE FUNCTION WinXDraw_GetImageChannel (hImage, channel, UBYTE @data[])
DECLARE FUNCTION WinXDraw_GetImageInfo (hImage, @w, @h, @pBits)
DECLARE FUNCTION RGBA WinXDraw_GetImagePixel (hImage, x, y)
DECLARE FUNCTION WinXDraw_LoadImage (fileName$, fileType)
DECLARE FUNCTION DOUBLE WinXDraw_PixelsPerPoint ()
DECLARE FUNCTION WinXDraw_PremultiplyImage (hImage)
DECLARE FUNCTION WinXDraw_ResizeImage (hImage, w, h)
DECLARE FUNCTION WinXDraw_SaveImage (hImage, fileName$, fileType)
DECLARE FUNCTION WinXDraw_SetConstantAlpha (hImage, DOUBLE alpha)
DECLARE FUNCTION WinXDraw_SetImageChannel (hImage, channel, UBYTE @data[])
DECLARE FUNCTION WinXDraw_SetImagePixel (hImage, x, y, codeRGB)
DECLARE FUNCTION WinXDraw_Snapshot (hWnd, x, y, hImage)

DECLARE FUNCTION WinXDraw_Undo (hWnd, idDraw) ' undo a drawing operation
DECLARE FUNCTION WinXUndo (hWnd, idDraw) ' undo a drawing operation
'
' Text
'
DECLARE FUNCTION WinXGetText$            (hWnd) ' get the text from a window or a control
DECLARE FUNCTION WinXSetText             (hWnd, text$) ' set the text of a window or a control
DECLARE FUNCTION WinXDraw_GetTextWidth   (hFont, text$, maxWidth)
'
' Keyboard
'
DECLARE FUNCTION WinXIsKeyDown (key)
'
' Mouse
'
DECLARE FUNCTION WinXGetMousePos (hWnd, @x, @y)
DECLARE FUNCTION WinXIsMousePressed (button)
'
' List Box
'
DECLARE FUNCTION WinXListBox_AddItem (hListBox, index, item$)
DECLARE FUNCTION WinXListBox_EnableDragging (hListBox) ' enable dragging on a list box
DECLARE FUNCTION WinXListBox_GetIndex (hListBox, searchFor$) ' get the index of a particular string
DECLARE FUNCTION WinXListBox_GetItem$ (hListBox, index) ' get the text of list box item
DECLARE FUNCTION WinXListBox_RemoveItem (hListBox, index)
DECLARE FUNCTION WinXListBox_SetCaret (hListBox, index) ' set the caret item

DECLARE FUNCTION WinXListBox_GetSelectionArray (hListBox, @indexList[]) ' get all selected items in the list box
DECLARE FUNCTION WinXListBox_SetSelectionArray (hListBox, indexList[]) ' multi-select listbox items
'
' List View
'
DECLARE FUNCTION WinXListView_AddColumn (hLV, iColumn, wColumn, label$, numSubItem) ' add a column to list view for use in report view
DECLARE FUNCTION WinXListView_AddItem (hLV, iItem, item$, iIcon) ' add a new item to a list view
DECLARE FUNCTION WinXListView_DeleteColumn (hLV, iColumn)
DECLARE FUNCTION WinXListView_DeleteItem (hLV, iItem)
DECLARE FUNCTION WinXListView_GetItemFromPoint (hLV, x, y)
DECLARE FUNCTION WinXListView_GetItemText (hLV, iItem, uppSubItem, @aSubItem$[])
DECLARE FUNCTION WinXListView_SetItemText (hLV, iItem, iSubItem, newText$) ' set new item/sub-item's text
DECLARE FUNCTION WinXListView_SetView (hLV, view)
DECLARE FUNCTION WinXListView_Sort (hLV, iCol, decreasing)

DECLARE FUNCTION WinXListView_GetSelectionArray (hLV, @indexList[])
DECLARE FUNCTION WinXListView_SetSelectionArray (hLV, indexList[])
'
' Menu
'
DECLARE FUNCTION WinXMenu_Attach (subMenu, newParent, idMenu)
'
' New Widget
'
DECLARE FUNCTION SECURITY_ATTRIBUTES WinXNewACL (ssd$, inherit)
DECLARE FUNCTION WinXNewAutoSizerSeries (direction)
DECLARE FUNCTION WinXNewChildWindow (hParent, title$, style, exStyle, idCtr)
DECLARE FUNCTION WinXNewFont (fontName$, pointSize, weight, bItalic, bUnderline, bStrikeOut) ' create a logical font
DECLARE FUNCTION WinXNewMenu (menuList$, firstID, isPopup)

DECLARE FUNCTION WinXNewToolbar (wButton, hButton, nButtons, hBmpButtons, hBmpGray, hBmpHot, transparentRGB, toolTips, customisable)
DECLARE FUNCTION WinXNewToolbarUsingIls (hilButtons, hilGray, hilHot, toolTips, customisable)

DECLARE FUNCTION WinXNewWindow (hOwner, titleBar$, x, y, w, h, simpleStyle, exStyle, icon, menu) ' create a new window
'
' Print
'
DECLARE FUNCTION WinXPrint_DevUnitsPerInch (hPrinter, @w, @h)
DECLARE FUNCTION WinXPrint_Done (hPrinter) ' reset the printer context
DECLARE FUNCTION DOUBLE WinXPrint_LogUnitsPerPoint (hPrinter, cyLog, cyPhys)
DECLARE FUNCTION WinXPrint_Page (hPrinter, hWnd, x, y, cxLog, cyLog, cxPhys, cyPhys, pageNum, pageCount)
DECLARE FUNCTION WinXPrint_PageSetup (hOwner)
DECLARE FUNCTION WinXPrint_Start (minPage, maxPage, @rangeMin, @rangeMax, @cxPhys, @cyPhys, fileName$, showDialog, hOwner)
'
' Progress Bar
'
DECLARE FUNCTION WinXProgress_SetMarquee (hProg, enable)
DECLARE FUNCTION WinXProgress_SetPos (hProg, DOUBLE pos)
'
' GUI Callback Registers
'
DECLARE FUNCTION WinXRegControlSizer (hWnd, FUNCADDR FnOnSize)
DECLARE FUNCTION WinXRegMessageHandler (hWnd, wMsg, FUNCADDR FnMsgHandler)
DECLARE FUNCTION WinXRegOnCalendarSelect (hWnd, FUNCADDR FnOnCalendarSelect) ' handles message $$MCN_SELCHANGE notifyCode
DECLARE FUNCTION WinXRegOnChar (hWnd, FUNCADDR FnOnChar)
DECLARE FUNCTION WinXRegOnClipChange (hWnd, FUNCADDR FnOnClipChange)
DECLARE FUNCTION WinXRegOnClose (hWnd, FUNCADDR FnOnClose) ' handles message $$WM_CLOSE
DECLARE FUNCTION WinXRegOnColumnClick (hWnd, FUNCADDR FnOnColumnClick)
DECLARE FUNCTION WinXRegOnCommand (hWnd, FUNCADDR FnOnCommand) ' handles message $$WM_COMMAND
DECLARE FUNCTION WinXRegOnDrag (hWnd, FUNCADDR FnOnDrag)
DECLARE FUNCTION WinXRegOnDropFiles (hWnd, FUNCADDR FnOnDrag)
DECLARE FUNCTION WinXRegOnEnterLeave (hWnd, FUNCADDR FnOnEnterLeave)
DECLARE FUNCTION WinXRegOnFocusChange (hWnd, FUNCADDR FnOnFocusChange)
DECLARE FUNCTION WinXRegOnItem (hWnd, FUNCADDR FnOnItem)
DECLARE FUNCTION WinXRegOnKeyDown (hWnd, FUNCADDR FnOnKeyDown) ' handles message $$WM_KEYDOWN
DECLARE FUNCTION WinXRegOnKeyUp (hWnd, FUNCADDR FnOnKeyUp) ' handles message $$WM_KEYUP
DECLARE FUNCTION WinXRegOnLabelEdit (hWnd, FUNCADDR FnOnLabelEdit)
DECLARE FUNCTION WinXRegOnMouseDown (hWnd, FUNCADDR FnOnMouseDown)
DECLARE FUNCTION WinXRegOnMouseMove (hWnd, FUNCADDR FnOnMouseMove)
DECLARE FUNCTION WinXRegOnMouseUp (hWnd, FUNCADDR FnOnMouseUp)
DECLARE FUNCTION WinXRegOnMouseWheel (hWnd, FUNCADDR FnOnMouseWheel)
DECLARE FUNCTION WinXRegOnPaint (hWnd, FUNCADDR FnOnPaint) ' handles message $$WM_PAINT
DECLARE FUNCTION WinXRegOnScroll (hWnd, FUNCADDR FnOnScroll)
DECLARE FUNCTION WinXRegOnTrackerPos (hWnd, FUNCADDR FnOnTrackerPos)
'
' Windows Registry
'
DECLARE FUNCTION WinXRegistry_ReadBin (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
DECLARE FUNCTION WinXRegistry_ReadInt (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result)
DECLARE FUNCTION WinXRegistry_ReadString (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
DECLARE FUNCTION WinXRegistry_WriteBin (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, szBuf$)
DECLARE FUNCTION WinXRegistry_WriteInt (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, int)
DECLARE FUNCTION WinXRegistry_WriteString (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, szBuf$)
'
' Scroll Bar
'
DECLARE FUNCTION WinXScroll_GetPos (hWnd, direction, @pos)
DECLARE FUNCTION WinXScroll_Scroll (hWnd, direction, unitType, scrollingDirection)
DECLARE FUNCTION WinXScroll_SetPage (hWnd, direction, DOUBLE mul, constant, scrollUnit)
DECLARE FUNCTION WinXScroll_SetPos (hWnd, direction, pos)
DECLARE FUNCTION WinXScroll_SetRange (hWnd, direction, min, max)
DECLARE FUNCTION WinXScroll_Show (hWnd, horiz, vert)
DECLARE FUNCTION WinXScroll_Update (hWnd, deltaX, deltaY)
'
' Window Functions
'
DECLARE FUNCTION WinXDisplay (hWnd)
DECLARE FUNCTION WinXHide (hWnd)
DECLARE FUNCTION WinXDoEvents () ' event loop
DECLARE FUNCTION WinXEnableDialogInterface (hWnd, enable) ' enable/disable a dialog-type interface
DECLARE FUNCTION WinXGetPlacement (hWnd, @minMax, RECT @restored)
DECLARE FUNCTION WinXGetUseableRect (hWnd, RECT @rect) ' get the useable portion the client area
DECLARE FUNCTION WinXSetCursor (hWnd, hCursor)
DECLARE FUNCTION WinXSetMinSize (hWnd, min_width, min_height) ' set minimum width and height of the window
DECLARE FUNCTION WinXSetPlacement (hWnd, minMax, RECT restored)
DECLARE FUNCTION WinXSetStyle (hWnd, addStyle, addEx, subStyle, subEx) ' set style and extended style
DECLARE FUNCTION WinXSetWindowColor (hWnd, backRGB) ' change the window background color
DECLARE FUNCTION WinXSetWindowColour (hWnd, backRGB) ' change the window background colour
DECLARE FUNCTION WinXSetWindowToolbar (hWnd, hToolbar)
DECLARE FUNCTION WinXShow (hWnd)
DECLARE FUNCTION WinXUpdate (hWnd) ' update the specified window
'
' WinX Splitter
'
DECLARE FUNCTION WinXSplitter_GetPos (series, hCtr, @position, @docked)
DECLARE FUNCTION WinXSplitter_SetPos (series, hCtr, position, docked)
DECLARE FUNCTION WinXSplitter_SetProperties (series, hCtr, min, max, dock)
'
' Status Bar
'
DECLARE FUNCTION WinXStatus_GetText$ (hWnd, part)
DECLARE FUNCTION WinXStatus_SetText (hWnd, part, text$)
'
' Tabs Control
'
DECLARE FUNCTION WinXTabs_AddTab (hTabs, label$, index) ' add a new tab
DECLARE FUNCTION WinXTabs_DeleteTab (hTabs, iTab)
DECLARE FUNCTION WinXTabs_GetCurrentTab (hTabs) ' get current tab selection
DECLARE FUNCTION WinXTabs_SetCurrentTab (hTabs, iTab) ' set the current tab
'
' Time Picker
'
DECLARE FUNCTION WinXTimePicker_GetTime (hDTP, SYSTEMTIME @time, @timeValid) ' get time from a Date/Time Picker control
DECLARE FUNCTION WinXTimePicker_SetTime (hDTP, SYSTEMTIME time, timeValid) ' set the time for a Date/Time Picker control
'
' Tool Bar
'
DECLARE FUNCTION WinXToolbar_AddButton (hToolbar, commandId, iImage, tooltipText$, optional, moveable)
DECLARE FUNCTION WinXToolbar_AddControl (hToolbar, hControl, w)
DECLARE FUNCTION WinXToolbar_AddSeparator (hToolbar)
DECLARE FUNCTION WinXToolbar_AddToggleButton (hToolbar, commandId, iImage, tooltipText$, mutex, optional, moveable)
DECLARE FUNCTION WinXToolbar_EnableButton (hToolbar, iButton, enable)
DECLARE FUNCTION WinXToolbar_ToggleButton (hToolbar, iButton, on)
'
' Track Bar
'
DECLARE FUNCTION WinXTracker_GetPos (hTracker)
DECLARE FUNCTION WinXTracker_SetLabels (hTracker, leftLabel$, rightLabel$)
DECLARE FUNCTION WinXTracker_SetPos (hTracker, newPos)
DECLARE FUNCTION WinXTracker_SetRange (hTracker, USHORT min, USHORT max, ticks)
DECLARE FUNCTION WinXTracker_SetSelRange (hTracker, USHORT start, USHORT end)
'
' Tree View
'
DECLARE FUNCTION WinXTreeView_AddItem (hTV, hParent, hNodeAfter, iImage, iImageSelect, label$) ' add a new node
DECLARE FUNCTION WinXTreeView_CopyItem (hTV, hParentItem, hItemInsertAfter, hNode)
DECLARE FUNCTION WinXTreeView_DeleteItem (hTV, hNode)
DECLARE FUNCTION WinXTreeView_GetChildItem (hTV, hNode)
DECLARE FUNCTION WinXTreeView_GetItemFromPoint (hTV, x, y)
DECLARE FUNCTION WinXTreeView_GetItemLabel$ (hTV, hNode)
DECLARE FUNCTION WinXTreeView_GetNextItem (hTV, hNode)
DECLARE FUNCTION WinXTreeView_GetParentItem (hTV, hNode)
DECLARE FUNCTION WinXTreeView_GetPreviousItem (hTV, hNode)
DECLARE FUNCTION WinXTreeView_GetSelection (hTV)
DECLARE FUNCTION WinXTreeView_SetItemLabel (hTV, hNode, label$)
DECLARE FUNCTION WinXTreeView_SetSelection (hTV, hNode)
'
' WinX Version
'
DECLARE FUNCTION WinXVersion$ () ' get WinX current version
'
' PRINT (internal)
'
DECLARE FUNCTION cancelDlgOnClose (hDlg) ' onClose callback function for the cancel printing dialog box
DECLARE FUNCTION cancelDlgOnCommand (idDlg, code, hDlg) ' onCommand callback function for the cancel printing dialog box
DECLARE FUNCTION initPrintInfo ()
DECLARE FUNCTION printAbortProc (hdc, nCode)

END EXPORT
'
' ******************************
' *****  END BLOCK EXPORT  *****
' ******************************
'
'
' ********************************************
' *****  INTERNAL FUNCTION DECLARATIONS  *****
' ********************************************
'
' Auto-Draw Information
'
DECLARE FUNCTION AUTODRAWRECORD_Delete (id) ' delete AUTODRAWRECORD item
DECLARE FUNCTION AUTODRAWRECORD_Get (id, AUTODRAWRECORD @item) ' get AUTODRAWRECORD item
DECLARE FUNCTION AUTODRAWRECORD_Init () ' AUTODRAWRECORD Pool initialization
DECLARE FUNCTION AUTODRAWRECORD_New (AUTODRAWRECORD item) ' add a new AUTODRAWRECORD item to AUTODRAWRECORD Pool
DECLARE FUNCTION AUTODRAWRECORD_Update (id, AUTODRAWRECORD item) ' update AUTODRAWRECORD item

DECLARE FUNCTION ApiAlphaBlend (hdcDest, nXOriginDest, nYOrigDest, nWidthDest, nHeightDest, hdcSrc, nXOriginSrc, nYOriginSrc, nWidthSrc, nHeightSrc, BLENDFUNCTION blendFunction)
DECLARE FUNCTION ApiLBItemFromPt (hLB, x, y, bAutoScroll)

DECLARE FUNCTION CleanUp () ' program clean-up

DECLARE FUNCTION CompareLVItems (item1, item2, hLV)
'
'new in 0.6.0.2
DECLARE FUNCTION Delete_the_binding (idBinding) ' delete a binding accessed by its id
DECLARE FUNCTION Get_the_binding (hWnd, @idBinding, BINDING @binding) ' get data of binding accessed by its id
'
' Debug
'
DECLARE FUNCTION GuiTellApiError         (msg$)		' display a WinAPI error message
DECLARE FUNCTION GuiTellRunError         (msg$)		' display a run-time error message
DECLARE FUNCTION GuiTellDialogError      (hOwner, title$) ' display a dialog error message
'
' Generic Linked List
'
DECLARE FUNCTION LINKEDLIST_Delete (id) ' delete LINKEDLIST item
DECLARE FUNCTION LINKEDLIST_Get (id, LINKEDLIST @item) ' get LINKEDLIST item
DECLARE FUNCTION LINKEDLIST_Init () ' LINKEDLIST Pool initialization
DECLARE FUNCTION LINKEDLIST_New (LINKEDLIST item) ' add a new LINKEDLIST item to LINKEDLIST Pool
DECLARE FUNCTION LINKEDLIST_Update (id, LINKEDLIST item) ' update LINKEDLIST item
'
' Generic Linked List Node
'
DECLARE FUNCTION LINKEDNODE_Delete (id) ' delete LINKEDNODE item
DECLARE FUNCTION LINKEDNODE_Get (id, LINKEDNODE @item) ' get LINKEDNODE item
DECLARE FUNCTION LINKEDNODE_Init () ' LINKEDNODE Pool initialization
DECLARE FUNCTION LINKEDNODE_New (LINKEDNODE item) ' add a new LINKEDNODE item to LINKEDNODE Pool
DECLARE FUNCTION LINKEDNODE_Update (id, LINKEDNODE item) ' update LINKEDNODE item

DECLARE FUNCTION LINKEDWALK_Delete (id) ' delete LINKEDWALK item
DECLARE FUNCTION LINKEDWALK_Get (id, LINKEDWALK @item) ' get LINKEDWALK item
DECLARE FUNCTION LINKEDWALK_Init () ' LINKEDWALK Pool initialization
DECLARE FUNCTION LINKEDWALK_New (LINKEDWALK item) ' add a new LINKEDWALK item to LINKEDWALK Pool
DECLARE FUNCTION LINKEDWALK_Update (id, LINKEDWALK item) ' update LINKEDWALK item
'
' Linked Lists
'
DECLARE FUNCTION LinkedList_Append (LINKEDLIST @list, iData) ' append an item to a linked list
DECLARE FUNCTION LinkedList_DeleteAll (LINKEDLIST @list) ' delete every item in a linked list
DECLARE FUNCTION LinkedList_DeleteThis (hWalk, LINKEDLIST @list) ' delete the item LinkedList_Walk just returned
DECLARE FUNCTION LinkedList_EndWalk (hWalk) ' close a walk handle
DECLARE FUNCTION LinkedList_Init (LINKEDLIST @list) ' initialize a linked list
DECLARE FUNCTION LinkedList_StartWalk (LINKEDLIST list) ' initialize a walk of a linked list
DECLARE FUNCTION LinkedList_Uninit (LINKEDLIST @list) ' uninitialize a linked list
DECLARE FUNCTION LinkedList_Walk (hWalk, @iData) ' get the next data item in a linked list
'
' WinX Splitter
'
DECLARE FUNCTION SPLITTERINFO_Delete (idBlock) ' delete splitter info block
DECLARE FUNCTION SPLITTERINFO_Get (idBlock, SPLITTERINFO @splitter_block) ' get splitter info block
DECLARE FUNCTION SPLITTERINFO_Init () ' splitter info blocks initialization
DECLARE FUNCTION SPLITTERINFO_New (SPLITTERINFO splitter_block) ' add a new splitter info block to splitter info blocks
DECLARE FUNCTION SPLITTERINFO_Update (idBlock, SPLITTERINFO splitter_block) ' update splitter info block
'
' STRING Functions
'
DECLARE FUNCTION STRING_Delete (id) ' delete stored string
DECLARE FUNCTION STRING_Extract$ (string$, start, end) ' extract a sub-string
DECLARE FUNCTION STRING_Get (id, @item$) ' get stored string
DECLARE FUNCTION STRING_Init () ' stored strings initialization
DECLARE FUNCTION STRING_New (item$) ' add a new stored string to stored strings

DECLARE FUNCTION XWSStoWS (xwss)
'
' Auto-Draw
'
DECLARE FUNCTION autoDraw_add (idList, iBlock)
DECLARE FUNCTION autoDraw_clear (idList)
DECLARE FUNCTION autoDraw_draw (hdc, idList, x0, y0)
'
' Auto-Sizer
'
DECLARE FUNCTION autoSizer (AUTOSIZERINFO sizer_block, direction, x0, y0, w, h, currPos) ' the auto-sizer function, resizes child windows
'
' Auto-Sizer Groups
'
DECLARE FUNCTION autoSizerInfo_addGroup (direction)
DECLARE FUNCTION autoSizerInfo_deleteGroup (series)
DECLARE FUNCTION autoSizerInfo_showGroup (series, visible)
DECLARE FUNCTION autoSizerInfo_sizeGroup (series, x0, y0, w, h)
'
' Auto-Sizer Information
'
DECLARE FUNCTION autoSizerInfo_add (series, AUTOSIZERINFO sizer_block)
DECLARE FUNCTION autoSizerInfo_delete (series, idDraw)
DECLARE FUNCTION autoSizerInfo_get (series, idDraw, AUTOSIZERINFO @sizer_block)
DECLARE FUNCTION autoSizerInfo_update (series, idDraw, AUTOSIZERINFO sizer_block)
'
' WinX Splitter Callback Procedure
'
DECLARE FUNCTION splitterProc (hSplitter, wMsg, wParam, lParam) ' WinX splitter callback function
'
' Window/Dialog Binding
'
DECLARE FUNCTION binding_add (BINDING binding)
DECLARE FUNCTION binding_delete (idBinding)
DECLARE FUNCTION binding_get (idBinding, BINDING @binding)
DECLARE FUNCTION binding_update (idBinding, BINDING binding)

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
' Windows Message Handler Groups
'
DECLARE FUNCTION handler_addGroup () ' add a new group of handlers
DECLARE FUNCTION handler_deleteGroup (group) ' delete a group of handlers
'
' Windows Message Handlers
'
DECLARE FUNCTION handler_add (group, MSGHANDLER handler) ' add a new handler to a group
DECLARE FUNCTION handler_call (group, @return_code, hWnd, wMsg, wParam, lParam) ' call the handler for message wMsg
DECLARE FUNCTION handler_delete (group, id) ' add a new handler to a handler group
DECLARE FUNCTION handler_find (group, wMsg) ' find a handler in the handler group
DECLARE FUNCTION handler_get (group, id, MSGHANDLER handler) ' retrieve a handler from the handler group
DECLARE FUNCTION handler_update (group, id, MSGHANDLER handler) ' update an existing handler in the handler group
'
' Main Window Callback Procedure
'
DECLARE FUNCTION mainWndProc (hWnd, wMsg, wParam, lParam)
DECLARE FUNCTION onNotify (hWnd, wParam, lParam, BINDING binding)

DECLARE FUNCTION sizeWindow (hWnd, w, h)
'
' Group Box Resize
'
DECLARE FUNCTION groupBox_SizeContents (hGB, pRect)
'
' Tabs Control Resize
'
DECLARE FUNCTION tabs_SizeContents (hTabs, pRect)

DECLARE FUNCTION UnregisterWinClass (className$, bDebugMode, sDebugText$) ' unregister the window class
'
' 96-bit IEEE Long Double Precision Precision Floating Point Tangent routine.
'
DECLARE FUNCTION LONGDOUBLE LongDoubleTangent (LONGDOUBLE a) ' Tangent of angle a
'
' Used with LongDoubleTangent().
'
$$PI      = 0d400921FB54442D18
$$PI3DIV2 = 0d4012D97C7F3321D2
$$TWOPI   = 0d401921FB54442D18
$$PIDIV2  = 0d3FF921FB54442D18
'
'
' ******************************************
' *****  SHARED VARIABLE DECLARATIONS  *****
' ******************************************
'
' WINDOWS GUI SHARED VARIABLES
'
SHARED g_hInst		' handle of current module
SHARED g_hFontDefault		' current program default font
SHARED STRING g_bReentry		' ensure WinX() is entered only one time
SHARED g_hClipMem		' global memory needed for clipboard operations
SHARED g_hWinXIcon		' WinX application icon

SHARED DLM_MESSAGE
SHARED g_customColors[]		' for WinXDraw_GetColor()

' for drag and drop
SHARED g_drag_button
SHARED g_drag_item		' if tree view control, its property "Disable Drag And Drop" must NOT be set
SHARED g_drag_image		' image list for the dragging effect

SHARED PRINTINFO printInfo

SHARED g_lvs_column_index		' zero-based index of the column to sort by
SHARED g_lvs_decreasing		' $$TRUE to sort decreasing instead of increasing

SHARED BINDING	bindings[]			'a simple array of bindings

SHARED MSGHANDLER	handlers[]	'a 2D array of handlers
SHARED SBYTE handlersUM[]	'a usage map so we can see which groups are in use

SHARED AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
SHARED SIZELISTHEAD autoSizerInfoUM[]

SHARED AUTODRAWRECORD	autoDrawInfo[]	'info for the auto-draw
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
' Description = Initialize the WinX library
' Function    = WinX ()
' ArgCount    = 0
' Return      = 0 on success, else 1, 2, 3...
' Remarks     = Sometimes this gets called automatically.  If your program crashes as soon as you call WinXNewWindow then WinX has not been initialized properly.
'	See Also    =
'	Examples    = IFF WinX () THEN QUIT(0)
'	*/
FUNCTION WinX ()

	SHARED		g_hInst		' handle of current module
	SHARED		g_hWinXIcon		' WinX application icon

	SHARED		BINDING			bindings[]			'a simple array of bindings

	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		SBYTE handlersUM[]	'a usage map so we can see which groups are in use

	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]

	SHARED		AUTODRAWRECORD	autoDrawInfo[]	'info for the auto-draw
	SHARED		DRAWLISTHEAD autoDrawInfoUM[]

	SHARED TBBUTTONDATA tbbd[]	' info for toolbar customisation
	SHARED tbbdUM[]

	SHARED STRING g_bReentry		' ensures WinX() is entered only one time

	INITCOMMONCONTROLSEX	iccex		' information for extended common controls classes
	WNDCLASSEX wcex		' extended window class
	OSVERSIONINFOEX os		' to tweack widgets depending on Windows version

	XLONG hLib 			' = LoadLibraryA (&"WinX.dll")
	XLONG ret				' win32 api return value (0 for fail)
	XLONG bErr			' $$TRUE for error

	SetLastError (0)
	g_hInst = GetModuleHandleA (0)

	IF g_bReentry THEN RETURN 0		' enter once...
	g_bReentry = "1"		' ...and then no more
'
' No longer needed.
'
'	ADT ()		' initialize Abstract Data Types
'
	' window bidings initialization
	DIM bindings[0]

	' message handlers initialization
	DIM handlers[0,0]
	DIM handlersUM[0]

	' auto-sizer initialization
	DIM autoSizerInfo[0,0]
	DIM autoSizerInfoUM[0]

	' auto-draw initialization
	DIM autoDrawInfo[0,0]
	DIM autoDrawInfoUM[0]

	' allocated info for toolbar customisation
	DIM tbbd[0]
	DIM tbbdUM[0]

	STRING_Init ()				' stored strings initialization
	SPLITTERINFO_Init ()		' WinX splitter information
	LINKEDLIST_Init ()		' WinX linked list
	AUTODRAWRECORD_Init ()		' WinX auto-draw information

	initPrintInfo ()
'
' initialize the specific common controls classes from the common
' control dynamic-link library
'
	iccex.dwSize = SIZE(INITCOMMONCONTROLSEX)
'
' $$ICC_ANIMATE_CLASS      : animate
' $$ICC_BAR_CLASSES        : toolbar, statusbar, trackbar, tooltips
' $$ICC_COOL_CLASSES       : rebar (coolbar) control
' $$ICC_DATE_CLASSES       : month picker, date picker, time picker, up-down control
' $$ICC_HOTKEY_CLASS       : hotkey
' $$ICC_INTERNET_CLASSES   : WIN32_IE >= 0x0400
' $$ICC_LISTVIEW_CLASSES   : list view control, header
' $$ICC_PAGESCROLLER_CLASS : page scroller (WIN32_IE >= 0x0400)
' $$ICC_PROGRESS_CLASS     : progress bar
' $$ICC_TAB_CLASSES        : tabs control, tooltips
' $$ICC_TREEVIEW_CLASSES   : tree view control, tooltips
' $$ICC_UPDOWN_CLASS       : up-down control
' $$ICC_USEREX_CLASSES     : extended combo box
' $$ICC_WIN95_CLASSES      : everything else
'
	iccex.dwICC  = $$ICC_ANIMATE_CLASS      OR _
	             $$ICC_BAR_CLASSES        OR _
	             $$ICC_COOL_CLASSES       OR _
	             $$ICC_DATE_CLASSES       OR _
	             $$ICC_HOTKEY_CLASS       OR _
	             $$ICC_INTERNET_CLASSES   OR _
	             $$ICC_LISTVIEW_CLASSES   OR _
	             $$ICC_NATIVEFNTCTL_CLASS OR _
	             $$ICC_PAGESCROLLER_CLASS OR _
	             $$ICC_PROGRESS_CLASS     OR _
	             $$ICC_TAB_CLASSES        OR _
	             $$ICC_TREEVIEW_CLASSES   OR _
	             $$ICC_UPDOWN_CLASS       OR _
	             $$ICC_USEREX_CLASSES     OR _
	             $$ICC_WIN95_CLASSES
'
' 0.6.0.2-old---
' GL-04mar09-don't bother error checking!
'	IFF InitCommonControlsEx (&iccex) THEN RETURN 1 ' fail
' 0.6.0.2-old===
' 0.6.0.2-new+++
	InitCommonControlsEx (&iccex)
' 0.6.0.2-new===
'
' Retrieve WinX application icon from WinX.dll
' to set wcex.hIcon with it.
' Note: Make sure that WinX.rc file contains the statement:
' "WinXIcon ICON WinX.ico"
'
	g_hWinXIcon = 0
	hLib = LoadLibraryA (&"WinX.dll")
	IF hLib THEN
'
' 0.6.0.1-new+++
		' GL-27jul12-Make sure that WinX.RC file contains the statement:
		' "WinXIcon ICON WinX.ico"
		SetLastError (0)
		g_hWinXIcon = LoadIconA (hLib, &"WinXIcon")
		IFZ g_hWinXIcon THEN
			msg$ = "WinX-LoadIconA: WinX application icon is null"
			bErr = GuiTellApiError (@msg$)
			IFF bErr THEN WinXDialog_Error (@msg$, @"WinX-Alert", 2)
		ENDIF
' 0.6.0.1-new===
'
		FreeLibrary (hLib)
		hLib = 0
	ENDIF

	SetLastError (0)
'
' 0.6.0.3-old---
'	GetVersionExA (&os)		' GL-17feb20-BAD!
' 0.6.0.3-old===
' 0.6.0.3-new+++
	os.dwOSVersionInfoSize = SIZE(OSVERSIONINFOEX)
	SetLastError (0)
	ret = GetVersionExA (&os)
	IFZ ret THEN
		msg$ = "WinX-GetVersionExA: Can't identify the current Operating System"
		bErr = GuiTellApiError (@msg$)
		IFF bErr THEN WinXDialog_Error (@msg$, @"WinX-Alert", 2)
		os.dwMajorVersion = 5		' unlikely fail: default to Windows XP
	ENDIF
' 0.6.0.3-new===
'
	'register WinX main window class
	wcex.style					= $$CS_PARENTDC
	wcex.lpfnWndProc		= &mainWndProc()
	wcex.lpszMenuName = 0
	wcex.cbClsExtra			= 0		' no extra bytes after the window class
	wcex.cbWndExtra			= 4		' space for the index to a BINDING structure
	wcex.hInstance			= g_hInst
	wcex.hIcon					= g_hWinXIcon
	wcex.hCursor				= LoadCursorA (0, $$IDC_ARROW)
'
' 0.6.0.2-old---
'	wcex.hbrBackground	= $$COLOR_BTNFACE + 1		' GetStockObject ($$GRAY_BRUSH)
' 0.6.0.2-old===
' 0.6.0.2-new+++
	IF os.dwMajorVersion <= 5 THEN
		' up to Windows XP
		wcex.hbrBackground = $$COLOR_BTNFACE + 1		' GetStockObject ($$GRAY_BRUSH)
	ELSE
		wcex.hbrBackground = $$COLOR_WINDOW
	ENDIF
' 0.6.0.2-new===
'
	wcex.lpszClassName	= &$$MAIN_CLASS$
	wcex.cbSize = SIZE(WNDCLASSEX)

	'register the main window class
	SetLastError (0)
	ret = RegisterClassExA (&wcex)
	IFZ ret THEN
		msg$ = "WinX-RegisterClassExA: Can't register the main window class"
		bErr = GuiTellApiError (@msg$)
		IFF bErr THEN WinXDialog_Error (@msg$, @"WinX-Alert", 2)
		'-RETURN 3		' fail
	ENDIF

	'register WinX splitter class
	wcex.style					= $$CS_PARENTDC
	wcex.lpfnWndProc		= &splitterProc()		' WinX splitter callback function
	wcex.lpszMenuName = 0
	wcex.cbClsExtra			= 0		' no extra bytes after the window class
	wcex.cbWndExtra			= 4		' space for the index to a SPLITTERINFO structure
	wcex.hInstance			= g_hInst
	wcex.hIcon					= 0
	wcex.hCursor				= 0
'
' 0.6.0.2-old---
'	wcex.hbrBackground	= $$COLOR_BTNFACE + 1
' 0.6.0.2-old===
' 0.6.0.2-new+++
	IF os.dwMajorVersion <= 5 THEN
		' up to Windows XP
		wcex.hbrBackground = $$COLOR_BTNFACE + 1		' GetStockObject ($$GRAY_BRUSH)
	ELSE
		wcex.hbrBackground = $$COLOR_WINDOW
	ENDIF
' 0.6.0.2-new===
'
	wcex.lpszClassName	= &"WinXSplitterClass"
	wcex.cbSize = SIZE(WNDCLASSEX)

	'register the WinX Splitter window class
	ret = RegisterClassExA (&wcex)
'
' 0.6.0.2-old---
'	' Don't bother error checking!
'	IFZ ret THEN RETURN 4		' fail
' 0.6.0.2-old===
' 0.6.0.2-new+++
	IFZ ret THEN
		msg$ = "WinX-RegisterClassExA: Can't register the WinX Splitter window class"
		bErr = GuiTellApiError (@msg$)
		IFF bErr THEN WinXDialog_Error (@msg$, @"WinX-Alert", 2)
		' -RETURN 4		' fail
	ENDIF
' 0.6.0.2-new===
'
' DEBUG---
'	' display WinX current version
'	msg$ = "Using library WinX v" + WinXVersion$ ()
'	WinXDialog_Error (@msg$, @"WinX-Information", 0)
' DEBUG===
'
	RETURN 0		' success

END FUNCTION
'
' ################################
' #####  WinXAddAccelerator  #####
' ################################
'	/*
'	[WinXAddAccelerator]
' Description = Adds an accelerator to an accelerator array.
' Function    = WinXAddAccelerator (ACCEL @accel[], cmd, key, control, alt, shift)
' ArgCount    = 6
'	Arg1        = accel[] : an array of accelerators
'	Arg2        = command_id : the command the accelerator sends to $$WM_COMMAND
'	Arg3        = vk_code : the Virtual Key code
'	Arg4        = control : $$TRUE if Control Virtual Key pressed
'	Arg5        = alt : $$TRUE if Alt Virtual Key pressed
'	Arg6        = shift : $$TRUE if Shift Virtual Key pressed
' Return      = $$TRUE on success, or $$FALSE on fail
' Remarks     = array accel[] is automatically augmented
'	See Also    = WinXAddAcceleratorTable
'	Examples    = bOK = WinXAddAccelerator (@accel[], $$mnuFileOpen, 'O', $$TRUE, $$FALSE, $$FALSE)<br/>
'	*/
FUNCTION WinXAddAccelerator (ACCEL accel[], command_id, vk_code, control, alt, shift)

	XLONG upp				' upper index
	XLONG virt_key				' Virtual Key

	virt_key = $$FVIRTKEY
	IF alt     THEN virt_key = virt_key OR $$FALT
	IF control THEN virt_key = virt_key OR $$FCONTROL
	IF shift   THEN virt_key = virt_key OR $$FSHIFT

	IFZ accel[] THEN
		DIM accel[0]
		upp = 0
	ELSE
		upp = UBOUND(accel[]) + 1
		REDIM accel[upp]
	ENDIF

	accel[upp].fVirt = virt_key
	accel[upp].key = vk_code
	accel[upp].cmd = command_id

	RETURN $$TRUE		' success

END FUNCTION
'
' #####################################
' #####  WinXAddAcceleratorTable  #####
' #####################################
'	/*
'	[WinXAddAcceleratorTable]
' Description = Creates an accelerator table for WinAPI TranslateAcceleratorA().
' Function    = WinXAddAcceleratorTable()
' ArgCount    = 1
'	Arg1        = ACCEL accel[]: an array of accelerators
' Return      = the new accelerator table handle, or 0 on fail
' Remarks     =
'	See Also    = WinXAddAccelerator
'	Examples    = hAccel = WinXAddAcceleratorTable (@accel[])
'	*/
FUNCTION WinXAddAcceleratorTable (ACCEL accel[])
	XLONG hAccel		' the handle of the new accelerator table
	XLONG cEntries	' count of the accelerator table entries
	XLONG bErr			' $$TRUE for error

	SetLastError (0)
	hAccel = 0
	IF accel[] THEN
		cEntries = UBOUND(accel[]) + 1
		hAccel = CreateAcceleratorTableA (&accel[0], cEntries)
		IFZ hAccel THEN
			msg$ = "WinX-WinXAddAcceleratorTable: Can't create accelerator table"
			bErr = GuiTellApiError (@msg$)
			IFF bErr THEN WinXDialog_Error (@msg$, @"WinX-Alert", 2)
		ENDIF
	ENDIF
	RETURN hAccel

END FUNCTION
'
' ##############################
' #####  WinXAddAnimation  #####
' ##############################
'	/*
'	[WinXAddAnimation]
' Description = Creates a new animation control and adds it to the specified window
' Function    = WinXAddAnimation()
' ArgCount    = 3
'	Arg1        = hParent: the parent window's handle
'	Arg2        = STRING file: the animation file to play
'	Arg3        = idCtr: the unique id constant for this animation control
' Return      = Returns the handle of the new animation control, or 0 on fail
' Remarks     =
'	See Also    = WinXAni_Play, WinXAni_Stop
'	Examples    = bOK = WinXAddAnimation (hParent, file$, idCtr)
'	*/
FUNCTION WinXAddAnimation (hParent, STRING file, idCtr)
	XLONG style				' animation style
	XLONG hCtr				' the handle of the new animation control

	style = $$WS_TABSTOP OR $$WS_GROUP OR $$ACS_CENTER

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &"SysAnimate32", 0, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	SendMessageA (hCtr, $$ACM_OPENA, 0, &file)
	RETURN hCtr
END FUNCTION
'
' ###########################
' #####  WinXAddButton  #####
' ###########################
'	/*
'	[WinXAddButton]
' Description = Creates a new button and adds it to the specified window
' Function    = hButton = WinXAddButton (hParent, STRING title, hImage, idCtr)
' ArgCount    = 4
'	Arg1        = hParent: The parent window to contain this control
'	Arg2        = STRING title: The text the button will display. If hImage is not 0, this is either "bitmap" or "icon" depending on whether hImage is the handle of a bitmap or an icon
'	Arg3        = hImage: If this is an image button this parameter is the handle of the image, otherwise it must be 0
'	Arg4        = idCtr: The unique id constant for this button
' Return      = the handle of the new button, or 0 on fail
' Remarks     = To create a button that contains a text label, hImage must be 0. \n
' To create a button with an image, load either a bitmap or an icon using the standard gdi functions. \n
' Sets the image parameter to the handle GDI gives you and the text parameter to either "bitmap" or "icon" \n
' Depending on what kind of image you loaded.
'	See Also    =
'	Examples    = 'Define constants to identify the buttons<br/>\n
' $$IDBUTTON1 = 100<br/>$$IDBUTTON2 = 101<br/>\n
'  'Make a button with a text label<br/>\n
'  hButton = WinXAddButton (#hMain, "Click me!", 0, $$IDBUTTON1)</br>\n
'  'Make a button with a bitmap (which in this case is included in the resource file of your program)<br/>\n
'  hBitmap = LoadBitmapA (GetModuleHandleA(0), &"bitmapForButton2")<br/>\n
'  hButton2 = WinXAddButton (#hMain, "bitmap", hBitmap, $$IDBUTTON2)<br/>
'	*/
FUNCTION WinXAddButton (hParent, STRING title, hImage, idCtr)

	XLONG style		' control style
	XLONG imageType		' image type
	XLONG hButton		' the handle of the new button

	' set the style
	style = $$BS_PUSHBUTTON
	imageType = 0
	IF hImage THEN
		SELECT CASE LCASE$(title)
			CASE "icon"
				style = style OR $$BS_ICON
				imageType = $$IMAGE_ICON
			CASE "bitmap"
				style = style OR $$BS_BITMAP
				imageType = $$IMAGE_BITMAP
		END SELECT
	ENDIF
	style = style OR $$WS_TABSTOP OR $$WS_GROUP

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hButton = CreateWindowExA (0, &$$BUTTON, &title, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hButton THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hButton, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	IF hImage THEN
		'add the image
		SetLastError (0)
		IFZ SendMessageA (hButton, $$BM_SETIMAGE, imageType, hImage) THEN
			WinXSetText (hButton, "err " + title)		' fail
		ENDIF
	ENDIF

	'and we're done
	RETURN hButton
END FUNCTION
'
' #############################
' #####  WinXAddCalendar  #####
' #############################
'	/*
'	[WinXAddCalendar]
' Description = Creates a new calendar control and adds it to the specified window
' Function    = WinXAddCalendar()
' ArgCount    = 4
'	Arg1        = hParent: the parent window's handle
'	Arg2        = monthsX: the number of months to display in the x direction, returns the width of the control
'	Arg3        = monthsY: the number of months to display in the y direction, returns the height of the control
'	Arg4        = idCtr: the unique id constant for this button
' Return      = the handle of the new calendar control, or 0 on fail
' Remarks     =
'	See Also    = WinXCalendar_GetSelection, WinXCalendar_SetSelection
'	Examples    = hCal = WinXAddCalendar (hParent, monthsX, monthsY)
'	*/
FUNCTION WinXAddCalendar (hParent, @monthsX, @monthsY, idCtr)
	RECT	rect
	XLONG style		' calendar control style
	XLONG hCtr		' the handle of the new calendar control

	style = $$WS_TABSTOP OR $$WS_GROUP

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &$$MONTHCAL_CLASS, 0, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	SetLastError (0)
	SendMessageA (hCtr, $$MCM_GETMINREQRECT, 0, &rect)

	monthsX = monthsX * (rect.right  - rect.left)
	monthsY = monthsY * (rect.bottom - rect.top)

	RETURN hCtr
END FUNCTION
'
' #############################
' #####  WinXAddCheckBox  #####
' #############################
' Creates a new checkbox.
' Note: Legacy wrapper to WinXAddCheckButton()
FUNCTION WinXAddCheckBox (hParent, text$, isFirst, pushlike, idCtr)
	XLONG bOK				' $$TRUE for success
	bOK = WinXAddCheckButton (hParent, text$, isFirst, pushlike, idCtr)
	RETURN bOK
END FUNCTION
'
' ################################
' #####  WinXAddCheckButton  #####
' ################################
' Adds a new check button.
' hParent = the parent window's handle
' title = the title of the check button
' isFirst = $$TRUE if this is the first check button in the group, otherwise $$FALSE
' pushlike = $TRUE if the button is to be displayed as a pushbutton
' idCtr = the unique id constant for this control
' returns the new check button's handle, or 0 on fail
FUNCTION WinXAddCheckButton (hParent, STRING title, isFirst, pushlike, idCtr)
	XLONG style				' check button style
	XLONG hCtr				' the new check button's handle

	style = $$WS_TABSTOP OR $$BS_AUTOCHECKBOX

	IF isFirst  THEN style = style OR $$WS_GROUP		' only the first has the WS_GROUP style
	IF pushlike THEN style = style OR $$BS_PUSHLIKE

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &$$BUTTON, &title, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	RETURN hCtr
END FUNCTION
'
' #############################
' #####  WinXAddComboBox  #####
' #############################
' Creates new extended combo box control and adds it to the specified window
' hParent = the parent window for the combo box
' canEdit = $$TRUE if the User can enter their own item in the edit control
' images = if this combo box displays images with items, this is the handle of an image list, else 0
' idCtr = the unique id constant for the control
' returns the new combo box's handle, or 0 on fail
FUNCTION WinXAddComboBox (hParent, listHeight, canEdit, images, idCtr)
	XLONG style				' control style
	XLONG hCtr				' the handle of the new control

	style = $$WS_TABSTOP OR $$WS_GROUP
	IF canEdit THEN
		' $$CBS_DROPDOWN     : Editable Drop Down List
		style = style OR $$CBS_DROPDOWN
	ELSE
		' $$CBS_DROPDOWNLIST : Non-editable Drop Down List
		style = style OR $$CBS_DROPDOWNLIST
	ENDIF

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &$$WC_COMBOBOXEX, 0, style, 0, 0, 0, (listHeight + 22), hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	IF images THEN
		SetLastError (0)
		SendMessageA (hCtr, $$CBEM_SETIMAGELIST, 0, images)
	ENDIF
	RETURN hCtr
END FUNCTION
'
' ############################
' #####  WinXAddControl  #####
' ############################
' Creates a new custom control and adds it to the specified window
' hParent = the window to add the control to
' class = the class name for the control - this will be in the control's documentation
' title = the initial text to appear in the control - not all controls use this parameter
' idCtr = the unique id to identify the control
' flags = the style of the control.  You do not have to include $$WS_CHILD or $$WS_VISIBLE
' exStyle = the extended style of the control;
'           for most controls this will be 0
' returns the handle of the new control, or 0 on fail
FUNCTION WinXAddControl (hParent, STRING class, STRING title, flags, exStyle, idCtr)
	XLONG style				' control style
	XLONG hCtr				' the handle of the new control

	style = flags		' passed style flags

	style = style OR $$WS_TABSTOP OR $$WS_GROUP

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (exStyle, &class, &title, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	RETURN hCtr
END FUNCTION
'
' #########################
' #####  WinXAddEdit  #####
' #########################
' Adds a new edit control to the window.
' hParent = the parent window
' title = the initial text to display in the control
' flags = additional style flags of the control
' idCtr = the unique id constant for this control
' returns the handle of the new edit control, or 0 on fail
FUNCTION WinXAddEdit (hParent, STRING title, flags, idCtr)
	XLONG style				' control style
	XLONG hCtr				' the handle of the new edit control

	style = flags		' passed style flags

	style = style OR $$WS_TABSTOP OR $$WS_BORDER '| $$WS_GROUP
	IF style AND $$ES_MULTILINE THEN
		' multiline edit box
		style = style OR $$WS_VSCROLL OR $$WS_HSCROLL
	ENDIF

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA ($$WS_EX_CLIENTEDGE, &$$EDIT, &title, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	RETURN hCtr
END FUNCTION
'
' #############################
' #####  WinXAddGroupBox  #####
' #############################
' Creates a new group box and adds it to the specified window.
' hParent = the parent window's handle
' label = the label for the group box
' idCtr = the unique id constant for this control
' returns the new group box's handle, or 0 on fail
FUNCTION WinXAddGroupBox (hParent, STRING label, idCtr)
	XLONG style				' group box style
	XLONG hCtr				' the new group box's handle
	XLONG series				' the auto-sizer group

	style = $$BS_GROUPBOX

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA ($$WS_EX_TRANSPARENT, &$$BUTTON, &label, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	SetPropA (hCtr, &"WinXLeftSubSizer", &groupBox_SizeContents())

	' add auto-sizer to group box
	series = autoSizerInfo_addGroup ($$DIR_VERT)		' series is an index
	IF series < 0 THEN
		msg$ = "WinX-WinXAddGroupBox: Warning - new series for group box" + STR$ (idCtr) + " is zero, which is the value of the main series"
		WinXDialog_Error (@msg$, @"WinX-Debug", 1)
	ENDIF
	SetPropA (hCtr, &"WinXAutoSizerSeries", series)
	IF series < 0 THEN
		msg$ = "WinX-WinXAddGroupBox: Can't add auto-sizer to group box" + STR$ (idCtr)
		WinXDialog_Error (@msg$, @"WinX-Internal Error", 2)
	ENDIF

	RETURN hCtr
END FUNCTION
'
' ############################
' #####  WinXAddListBox  #####
' ############################
' Creates a new list box control and adds it to the specified window
' hParent = the parent window's handle
' sort = $$TRUE if listbox is sorted (increasing)
' multiSelect = $$TRUE if the list box can have multiple selections
' idCtr = the unique id constant for the list box
' returns the new list box's handle, or 0 on fail
FUNCTION WinXAddListBox (hParent, sort, multiSelect, idCtr)
	XLONG style				' control style
	XLONG hCtr				' the handle of the new edit control
'
' $$LBS_STANDARD is a combination of $$LBS_SORT, $$LBS_NOTIFY, $$WS_VSCROLL, and $$WS_BORDER
' $$LBS_SORT  : Sort items increasing
' $$LBS_NOTIFY: enables $$WM_COMMAND's notification code ($$LBN_SELCHANGE)
' $$WS_VSCROLL: Vertical   Scroll Bar
'
	style = $$LBS_STANDARD		' Warning: does not allow dragNdrop

	IFZ sort THEN
		style = style AND (NOT $$LBS_SORT)		' don't sort items increasing
	ENDIF

	IF multiSelect THEN
		' $$LBS_EXTENDEDSEL: Multiple selections
		style = style OR $$LBS_EXTENDEDSEL
	ENDIF
'
' $$WS_HSCROLL    : Horizontal Scroll Bar
' $$LBS_HASSTRINGS: Items are strings
'
	style = style OR $$WS_HSCROLL OR $$LBS_HASSTRINGS

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &"LISTBOX", 0, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	RETURN hCtr
END FUNCTION
'
' #############################
' #####  WinXAddListView  #####
' #############################
' Creates a new list view control and adds it to the specified window
' hParent = the parent window's handle
' editable = $$TRUE to enable label editing
' view is a view constant ($$LVS_LIST (default), $$LVS_REPORT, $$LVS_ICON, $$LVS_SMALLICON)
' returns the new list view's handle, or 0 on fail
FUNCTION WinXAddListView (hParent, hilLargeIcons, hilSmallIcons, editable, view, idCtr)
	XLONG style				' list view style
	XLONG exStyle			' list view extended style
	XLONG hCtr				' the new list view's handle
'
' 0.6.0.2-old---
'	style = $$WS_TABSTOP OR $$WS_GROUP OR view
' 0.6.0.2-old===
' 0.6.0.2-new+++
	style = $$WS_TABSTOP OR $$WS_GROUP
'
' Defined as a zero view constant (!), $$LVS_ICON makes the list view control go berserk!
'
	IF view <> $$LVS_ICON THEN
		style = style OR view
	ENDIF
' 0.6.0.2-new===
'
	IF editable THEN style = style OR $$LVS_EDITLABELS

	exStyle = $$LVS_EX_FULLROWSELECT OR $$LVS_EX_LABELTIP

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &$$WC_LISTVIEW, 0, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	' PATCH: Set "manually" the extended style of the list view control.
	SendMessageA (hCtr, $$LVM_SETEXTENDEDLISTVIEWSTYLE, exStyle, exStyle)

	IF hilLargeIcons THEN
		SendMessageA (hCtr, $$LVM_SETIMAGELIST, $$LVSIL_NORMAL, hilLargeIcons)
	ENDIF
	IF hilSmallIcons THEN
		SendMessageA (hCtr, $$LVM_SETIMAGELIST, $$LVSIL_SMALL, hilSmallIcons)
	ENDIF

	RETURN hCtr
END FUNCTION
'
' ################################
' #####  WinXAddProgressBar  #####
' ################################
' Creates a new progress bar control and adds it to the specified window
' hParent = the parent window's handle
' smooth = $$TRUE if the progress bar is not to be segmented
' idCtr = the unique id constant for this control
' returns the new progress bar's handle, or 0 on fail
FUNCTION WinXAddProgressBar (hParent, smooth, idCtr)
	XLONG style				' progress bar style
	XLONG hCtr				' the new progress bar's handle
	XLONG minMax		' the minimum and maximum values for the progress bar

	style = $$WS_TABSTOP OR $$WS_GROUP
	IF smooth THEN
		style = style OR $$PBS_SMOOTH
	ENDIF

	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &$$PROGRESS_CLASS, 0, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	' set the minimum and maximum values for the progress bar
	minMax = MAKELONG (0, 1000)
	SendMessageA (hCtr, $$PBM_SETRANGE, 0, minMax)

	RETURN hCtr
END FUNCTION
'
' ################################
' #####  WinXAddRadioButton  #####
' ################################
' Adds a new radio button.
' hParent = the parent window's handle
' title = the title of the radio button
' isFirst = $$TRUE if this is the first radio button in the group, otherwise $$FALSE
' pushlike = $$TRUE if the button is to be displayed as a push button
' idCtr = the unique id constant for the radio button
' returns the handle of the new radio button, or 0 on fail
FUNCTION WinXAddRadioButton (hParent, STRING title, isFirst, pushlike, idCtr)
	XLONG style				' control style
	XLONG hCtr				' the handle of the new radio button

	style = $$WS_TABSTOP OR $$BS_AUTORADIOBUTTON

	IF isFirst  THEN style = style OR $$WS_GROUP		' only the first has the WS_GROUP style
	IF pushlike THEN style = style OR $$BS_PUSHLIKE

	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &$$BUTTON, &title, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	RETURN hCtr
END FUNCTION
'
' ###########################
' #####  WinXAddStatic  #####
' ###########################
' Adds a static control to a window.
' hParent = the parent window to add this control to
' title = the text for the static control
' hImage = the image to use, or 0 if no image
' flags = additional style flags of static control
' idCtr = the unique id constant for this control
' returns the handle of the new static control, or 0 on fail
FUNCTION WinXAddStatic (hParent, STRING title, hImage, flags, idCtr)
	XLONG style				' control style
	XLONG imageType
	XLONG hCtr				' the handle of the new static control

	style = flags		' passed style flags

	IF hImage THEN
		'add the image
		SELECT CASE LCASE$(text$)
			CASE "icon"
				style = style OR $$SS_ICON
				imageType = $$IMAGE_ICON
			CASE "bitmap"
				style = style OR $$SS_BITMAP
				imageType = $$IMAGE_BITMAP
		END SELECT
	ENDIF

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &"static", &title, style OR $$WS_TABSTOP OR $$WS_CHILD OR $$WS_VISIBLE, _
		0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	'add the image
	IF hImage THEN
		SendMessageA (hCtr, $$STM_SETIMAGE, imageType, hImage)
	ENDIF

	'and we're done
	RETURN hCtr
END FUNCTION
'
' ##############################
' #####  WinXAddStatusBar  #####
' ##############################
' Adds a status bar to the specified window
' hWnd = the window to add the status bar to
' initialStatus$ = a string to initialize the status bar with.  This string contains
' a number of strings for each panel, separated by commas
' idCtr = the unique id constant for this status bar
' returns the new status bar's handle, or 0 on fail
FUNCTION WinXAddStatusBar (hWnd, initialStatus$, idCtr)
	BINDING			binding
	XLONG		idBinding		' binding id
	RECT	rect
	XLONG window_style				' window's style
	XLONG style			' $$WS_SIZEBOX => sbStyle = $$SBARS_SIZEGRIP
	XLONG parts[]			' status bar's parts
	XLONG cPart
	XLONG w
	XLONG i						' running index
	XLONG ret					' win32 api return value (0 for fail)

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	style = 0

	'get the parent window's style
	window_style = GetWindowLongA (hWnd, $$GWL_STYLE)
	IF window_style AND $$WS_SIZEBOX THEN
		style = $$SBARS_SIZEGRIP
	ENDIF

	'make the status bar
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	binding.hStatus = CreateWindowExA (0, &$$STATUSCLASSNAME, 0, style OR $$WS_CHILD OR $$WS_VISIBLE, _
		0, 0, 0, 0, hWnd, idCtr, GetModuleHandleA (0), 0)
	IFZ binding.hStatus THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (binding.hStatus, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	'now prepare the parts
'
' 0.6.0.2-old---
'	XstParseStringToStringArray (initialStatus$, ",", @text$[])
' 0.6.0.2-old===
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
		XstParseStringToStringArray (initialStatus$, ",", @text$[])
	ENDIF
' 0.6.0.2-new===
'
	' create array parts[] for holding the right edge cooordinates
	binding.statusParts = UBOUND(text$[])
	DIM parts[binding.statusParts]

	' calculate the right edge coordinate for each part, and
	' copy the coordinates to the array
	SetLastError (0)
	ret = GetClientRect (binding.hStatus, &rect)
	IFZ ret THEN
		msg$ = "WinX-WinXAddStatusBar: Can't get client rectangle of the status bar"
		GuiTellApiError (@msg$)
		RETURN 0		' fail
	ENDIF

	cPart = binding.statusParts + 1		' number of right edge cooordinates
	w = rect.right - rect.left
	FOR i = 0 TO binding.statusParts
		parts[i] = ((i + 1) * w) / cPart
	NEXT i
	parts[binding.statusParts] = -1		' extend to the right edge of the window

	' set the part info
	SendMessageA (binding.hStatus, $$SB_SETPARTS, cPart, &parts[0])

	' and finally, set the text
	FOR i = 0 TO binding.statusParts
		SendMessageA (binding.hStatus, $$SB_SETTEXT, i, &text$[i])
	NEXT i

	' and update the binding
	binding_update (idBinding, binding)

	RETURN binding.hStatus
END FUNCTION
'
' #########################
' #####  WinXAddTabs  #####
' #########################
' Creates a new tabs control and adds it to the specified window
' hParent = the parent window's handle
' multiline = $$TRUE if this is a multiline control
' idCtr = the unique id constant for this control
' returns the handle of the new tabs control, or 0 on fail
FUNCTION WinXAddTabs (hParent, multiline, idCtr)
	XLONG style				' tabs control style
	XLONG hCtr				' the handle of the new tabs control
	XLONG parent_style		' parent control style

	SetLastError (0)
	style = $$WS_TABSTOP OR $$WS_GROUP
'
' both tabs and parent controls must have the $$WS_CLIPSIBLINGS window style
' $$WS_CLIPSIBLINGS : Clip Sibling Area
' $$TCS_HOTTRACK    : Hot track
'
	style = style OR $$TCS_HOTTRACK OR $$WS_CLIPSIBLINGS

	IF multiline THEN style = style OR $$TCS_MULTILINE

	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &$$WC_TABCONTROL, 0, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$TRUE)
'
' Add $$WS_CLIPSIBLINGS style to the parent if missing.
'
	parent_style = GetWindowLongA (hParent, $$GWL_STYLE)
	IFZ parent_style AND $$WS_CLIPSIBLINGS THEN
		parent_style = parent_style OR $$WS_CLIPSIBLINGS
		SetWindowLongA (hParent, $$GWL_STYLE, parent_style)
	ENDIF

	SetPropA (hCtr, &"WinXLeftSubSizer", &tabs_SizeContents ())
'
' 0.6.0.2-needed?
'	series = autoSizerInfo_addGroup ($$DIR_VERT)
'	SetPropA (hCtr, &"WinXAutoSizerSeries", series)
'	IF series < 0 THEN
'		msg$ = "WinXAddTabs: Can't add auto-sizer to tabs control" + STR$ (idCtr)
'		WinXDialog_Error (@msg$, @"WinX-Alert", 2)
'	ENDIF
' 0.6.0.2-new===
'
	RETURN hCtr
END FUNCTION
'
' ###############################
' #####  WinXAddTimePicker  #####
' ###############################
' Creates a new Date/Time Picker control and adds it to the specified window
' format = the format for the control, should be $$DTS_LONGDATEFORMAT, $$DTS_SHORTDATEFORMAT or $$DTS_TIMEFORMAT
' initialTime = the time to initialize the control to
' timeValid = $$TRUE if the initialTime parameter is valid
' idCtr = the unique id constant for this date/time picker
' returns the handle of the date/time picker, or 0 on fail
FUNCTION WinXAddTimePicker (hParent, format, SYSTEMTIME initialTime, timeValid, idCtr)
	XLONG style				' date/time picker style
	XLONG hCtr				' the handle of the new date/time picker
	XLONG wParam
	XLONG lParam

	SetLastError (0)
	style = $$WS_TABSTOP OR $$WS_GROUP
	SELECT CASE format
		CASE $$DTS_LONGDATEFORMAT, $$DTS_SHORTDATEFORMAT, $$DTS_TIMEFORMAT
			style = style OR format
	END SELECT

	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &$$DATETIMEPICK_CLASS, 0, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	IF timeValid THEN
		wParam = $$GDT_VALID
		lParam = &initialTime
	ELSE
		wParam = $$GDT_NONE
		lParam = 0
	ENDIF
	SendMessageA (hCtr, $$DTM_SETSYSTEMTIME, wParam, lParam)

	RETURN hCtr
END FUNCTION
'
' ############################
' #####  WinXAddTooltip  #####
' ############################
' Adds a tooltip to a control.
' hControl = the handle of the control to set the tooltip for
' tooltipText = the text of the tooltip
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXAddTooltip (hControl, STRING tooltipText)
	SHARED		g_hInst		' handle of current module

	BINDING			binding
	XLONG		idBinding		' binding id
	TOOLINFO ti
	XLONG hParent		' parent control of the tooltips control
	XLONG wMsg			' Windows message
	XLONG fInfo			' info on this control
	XLONG style			' tooltips style
	XLONG ret				' win32 api return value (0 for fail)
	XLONG bOK				' $$TRUE for success

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hControl
		CASE 0
			msg$ = "WinX-WinXAddTooltip: no control handle for tooltips control " + tooltipText
			WinXDialog_Error (@msg$, @"WinX-Information", 0)

		CASE ELSE
			tooltipText = TRIM$(tooltipText)
			IFZ tooltipText THEN
				msg$ = "WinX-WinXAddTooltip: no text for tooltips control"
				WinXDialog_Error (@msg$, @"WinX-Information", 0)
				tooltipText = "(Missing)"
			ENDIF

			'get the binding of the parent window
			hParent = GetParent(hControl)
			IFZ hParent THEN EXIT SELECT
			'
			IFF Get_the_binding (hParent, @idBinding, @binding) THEN EXIT SELECT
			'
			ti.uFlags = $$TTF_SUBCLASS OR $$TTF_IDISHWND
			ti.hwnd = hParent
			ti.uId = hControl
			ti.lpszText = &tooltipText

			' is there any info on this control?
			fInfo = SendMessageA (binding.hToolTips, $$TTM_GETTOOLINFO, 0, &ti)
			IF fInfo THEN
				wMsg = $$TTM_UPDATETIPTEXT		' just update the text
			ELSE
				wMsg = $$TTM_ADDTOOL		' make new entry
'
' 0.6.0.2-new+++
				style = $$WS_POPUP OR $$TTS_NOPREFIX OR $$TTS_ALWAYSTIP
				IFZ g_hInst THEN
					'get the handle of current module
					g_hInst = GetModuleHandleA (0)
				ENDIF

				binding.hToolTips = CreateWindowExA (0, &$$TOOLTIPS_CLASS, 0, style, _
					$$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, hControl, 0, g_hInst, 0)
				IFZ binding.hToolTips THEN
					msg$ = "WinX-WinXAddTooltip: Can't add tooltips " + tooltipText
					GuiTellApiError (@msg$)
					EXIT SELECT
				ENDIF
' 0.6.0.2-new===
'
			ENDIF

			' add the tooltip text
			ti.cbSize = SIZE(TOOLINFO)
			SetLastError (0)
			ret = SendMessageA (binding.hToolTips, wMsg, 0, &ti)
			IF ret THEN
				bOK = $$TRUE
			ELSE
				msg$ = "WinX-WinXAddTooltip: Can't add tooltips " + tooltipText
				GuiTellApiError (@msg$)
			ENDIF

	END SELECT

	RETURN bOK

END FUNCTION
'
' #############################
' #####  WinXAddTrackBar  #####
' #############################
' Creates a new track bar control and adds it to the specified window
' hParent = the parent window for the track bar
' enableSelection = $$TRUE to enable selections in the track bar
' posToolTip = $$TRUE to enable a tooltip which displays the position of the slider
' idCtr = the unique id constant of this trackbar
' returns the new trackbar's handle, or 0 on fail
FUNCTION WinXAddTrackBar (hParent, enableSelection, posToolTip, idCtr)
	XLONG style				' trackbar style
	XLONG hCtr				' the new trackbar's handle

	style = $$WS_TABSTOP OR $$WS_GROUP OR $$TBS_AUTOTICKS

	IF enableSelection THEN style = style OR $$TBS_ENABLESELRANGE
	IF posToolTip      THEN style = style OR $$TBS_TOOLTIPS

	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &$$TRACKBAR_CLASS, 0, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$TRUE)

	RETURN hCtr
END FUNCTION
'
' #############################
' #####  WinXAddTreeView  #####
' #############################
' Creates a new tree view control and adds it to the specified window
' hParent = the parent window's handle
' editable = $$TRUE to enable label editing
' draggable = $$TRUE to enable dragging
' idCtr = the unique id constant for this tree view
' returns the handle of the tree view, or 0 on fail
FUNCTION WinXAddTreeView (hParent, hImages, editable, draggable, idCtr)
	XLONG style				' tree view style
	XLONG hCtr				' the new tree view's handle

	style = $$WS_TABSTOP OR $$WS_GROUP
'
' $$TVS_LINESATROOT : Lines at root
' $$TVS_HASLINES    : |--lines
' $$TVS_HASBUTTONS  : [-]/[+]
'
	style = style OR $$TVS_HASBUTTONS OR $$TVS_HASLINES OR $$TVS_LINESATROOT

	IFF draggable THEN style = style OR $$TVS_DISABLEDRAGDROP
	IF editable   THEN style = style OR $$TVS_EDITLABELS

	'make the window
	style = style OR $$WS_CHILD OR $$WS_VISIBLE
	hCtr = CreateWindowExA (0, &$$WC_TREEVIEW, 0, style, 0, 0, 0, 0, hParent, idCtr, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	IF hImages THEN
		' attach the image list to tree view control
		SendMessageA (hCtr, $$TVM_SETIMAGELIST, $$TVSIL_NORMAL, hImages)
	ENDIF

	RETURN hCtr
END FUNCTION
'
' ##########################
' #####  WinXAni_Play  #####
' ##########################
' Starts playing an animation control.
' hAni = the animation control to play
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXAni_Play (hAni)
	SetLastError (0)
	IFZ hAni THEN RETURN $$FALSE		' fail
'
' From: zero-based index of the frame where playing begins
' To  : -1 means end with the last frame in the AVI clip
'
	IF SendMessageA (hAni, $$ACM_PLAY, -1, MAKELONG(0,-1)) THEN RETURN $$TRUE		' success
END FUNCTION
'
' ##########################
' #####  WinXAni_Stop  #####
' ##########################
' Stops playing an animation control.
' hAni = the animation control to stop playing
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXAni_Stop (hAni)
	SetLastError (0)
	IFZ hAni THEN RETURN $$FALSE		' fail
	IF SendMessageA (hAni, $$ACM_STOP, 0, 0) THEN RETURN $$TRUE		' success
END FUNCTION
'
' ####################################
' #####  WinXAttachAccelerators  #####
' ####################################
' Attaches an accelerator table to a window.
' hWnd = window to add the accelerator table to
' hAccel = accelerator table handle
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXAttachAccelerators (hWnd, hAccel)
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG bOK				' $$TRUE for success

	bOK = $$FALSE

	SELECT CASE hWnd
		CASE 0

		CASE ELSE
			IFZ hAccel THEN EXIT SELECT

			'get the binding
			bOK = Get_the_binding (hWnd, @idBinding, @binding)
			IF bOK THEN
				' and update the binding
				binding.hAccelTable = hAccel
				bOK = binding_update (idBinding, binding)
				IFF bOK THEN
					msg$ = "WinX-WinXAttachAccelerators: Can't update the binding"
					WinXDialog_Error (@msg$, @"WinX-Run-time Error", 2)		' Alert
					EXIT SELECT
				ENDIF
			ENDIF

	END SELECT

	RETURN bOK

END FUNCTION
'
' #########################################
' #####  WinXAutoSizer_GetMainSeries  #####
' #########################################
' Gets the id of the main auto-sizer series (vertical) for a window.
' hWnd = the window to get the series for
' returns the id (index) of the main auto-sizer series, or -1 on fail
'
' Note: The main series is vertical.
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
'	WinXDialog_Error (@msg$, @title$, severity)
'
FUNCTION WinXAutoSizer_GetMainSeries (hWnd)
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG series
'
' 0.6.0.4-new+++
	IFZ hWnd THEN
		hWnd = GetActiveWindow ()
	ENDIF
' 0.6.0.4-new===
'
	IFZ hWnd THEN RETURN -1		' fail
	'get the binding
	IF Get_the_binding (hWnd, @idBinding, @binding) THEN
		series = binding.autoSizerInfo
	ENDIF
	IF series < -1 THEN
		series = -1		' not an index
	ENDIF
	RETURN series

END FUNCTION
'
' ###################################
' #####  WinXAutoSizer_SetInfo  #####
' ###################################
' Sets information needed for auto-sizing your controls.
' hCtr = the handle of the window/control to resize
' series = the series to place the control in
'          -1 for the parent's series
' space = the space from the previous control
' size = the size of this control
' x, y, w, h = the size and position of the control on the current window
' flags = a set of $$SIZER flags
' returns $$TRUE on success, or $$FALSE on fail
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
FUNCTION WinXAutoSizer_SetInfo (hCtr, series, DOUBLE space, DOUBLE size, DOUBLE x, DOUBLE y, DOUBLE w, DOUBLE h, flags)

	SHARED	SIZELISTHEAD	autoSizerInfoUM[]		' for the auto-sizing direction

	BINDING			binding
	XLONG		idBinding		' binding id
	AUTOSIZERINFO	sizer_block
	SPLITTERINFO splitter_block
	RECT parentRect
	RECT minRect
	RECT	rect

	XLONG style				' control style
	XLONG hParent			' parent control
	XLONG idBlock			' the id of the auto-sizer information block
	XLONG slot
	XLONG bOK					' $$TRUE for success

	SetLastError (0)
	bOK = $$FALSE

	IF series < 0 THEN
		'get the binding of the parent window
		hParent = GetParent(hCtr)
		IFF Get_the_binding (hParent, @idBinding, @binding) THEN RETURN $$FALSE

		series = binding.autoSizerInfo
	ENDIF

	' associate the info
	sizer_block.hWnd = hCtr
	sizer_block.space = space
	sizer_block.size = size
	sizer_block.x = x
	sizer_block.y = y
	sizer_block.w = w
	sizer_block.h = h
	sizer_block.flags = flags

	'register the auto-sizer block
	idBlock = GetPropA (sizer_block.hWnd, &"autoSizerInfoBlock")
	IF idBlock > 0 THEN
		' update an old auto-sizer block
		bOK = autoSizerInfo_update (series, idBlock - 1, sizer_block)
	ELSE
		'make a new auto-sizer block
		slot = autoSizerInfo_add (series, sizer_block)
		IF slot < 0 THEN
			' not an index!
			msg$ = "WinX-WinXAutoSizer_SetInfo: Can't add the auto-sizer's information"
			WinXDialog_Error (@msg$, @"WinX-Internal Error", 2)
			RETURN $$FALSE
		ENDIF
		idBlock = slot + 1
		SetLastError (0)
		IFZ SetPropA (sizer_block.hWnd, &"autoSizerInfoBlock", idBlock) THEN
			RETURN $$FALSE
		ELSE
			bOK = $$TRUE
		ENDIF

		'make a new splitter if we need one
		IF sizer_block.flags AND $$SIZER_SPLITTER THEN
			splitter_block.group = series
			splitter_block.id = idBlock - 1
			splitter_block.direction = autoSizerInfoUM[series].direction

			autoSizerInfo_get (series, idBlock - 1, @sizer_block)
			sizer_block.hSplitter = CreateWindowExA (0, &"WinXSplitterClass", 0, $$WS_CHILD OR $$WS_VISIBLE OR $$WS_CLIPSIBLINGS, _
				0, 0, 0, 0, GetParent(sizer_block.hWnd), 0, GetModuleHandleA (0), SPLITTERINFO_New (@splitter_block))
			autoSizerInfo_update (series, idBlock - 1, sizer_block)
		ENDIF
	ENDIF

	'refresh the control
	GetClientRect (sizer_block.hWnd, &rect)
	sizeWindow (sizer_block.hWnd, rect.right - rect.left, rect.bottom - rect.top)

	RETURN bOK

END FUNCTION
'
' #########################################
' #####  WinXAutoSizer_SetSimpleInfo  #####
' #########################################
' A simplified version of WinXAutoSizer_SetInfo().
'
' Usage:
'	space# = 0.03		' space (3%)
'	size# = 1.0		' size (100%)
'	WinXAutoSizer_SetSimpleInfo (#childControl, WinXTabs_GetAutosizerSeries (#tabsControl, 0), space#, size#, 0)
'
FUNCTION WinXAutoSizer_SetSimpleInfo (hWnd, series, DOUBLE space, DOUBLE size, flags)
	RETURN WinXAutoSizer_SetInfo (hWnd, series, space, size, 0, 0, 1, 1, flags)
END FUNCTION
'
' #################################
' #####  WinXButton_GetCheck  #####
' #################################
' Gets the check state of a check or radio button.
' hButton = the handle of the button to get the check state for
' returns $$TRUE if the button is checked, $$FALSE otherwise
FUNCTION WinXButton_GetCheck (hButton)
	SetLastError (0)
	IFZ hButton THEN RETURN $$FALSE		' fail
	SELECT CASE SendMessageA (hButton, $$BM_GETCHECK, 0, 0)
		CASE $$BST_CHECKED
			RETURN $$TRUE
	END SELECT
END FUNCTION
'
' #################################
' #####  WinXButton_SetCheck  #####
' #################################
' Sets the check state of a check or radio button.
' hButton = the handle of the button to set the check state for
' checked = $$TRUE to check the button, $$FALSE to uncheck it
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXButton_SetCheck (hButton, checked)
	XLONG state
	SetLastError (0)
	IFZ hButton THEN RETURN $$FALSE		' fail
	IF checked THEN
		state = $$BST_CHECKED
	ELSE
		state = $$BST_UNCHECKED
	ENDIF
	SendMessageA (hButton, $$BM_SETCHECK, state, 0)
	RETURN $$TRUE		' success
END FUNCTION
'
' #######################################
' #####  WinXCalendar_GetSelection  #####
' #######################################
' Gets the selection in a calendar control.
' hCal = the handle of the calendard control
' start = the variable to store the start of the selection range
' end = the variable to store the end of the selection range
' returns $$TRUE on success, or $$FALSE on fail
'
' Usage:
'	SYSTEMTIME time
'
'	bOK = WinXCalendar_GetSelection (hCal, @time)
'	IFF bOK THEN
'		msg$ = "WinXCalendar_GetSelection: Can't get the selection in a calendar control"
'		XstAlert (@msg$)
'		RETURN $$TRUE ' error
'	ENDIF
'
FUNCTION WinXCalendar_GetSelection (hCal, SYSTEMTIME time)
	XLONG timeSize
'
' 0.6.0.2-old---
'	IFZ SendMessageA (hCal, $$MCM_GETCURSEL, 0, &time) THEN RETURN $$FALSE ELSE RETURN $$TRUE
' 0.6.0.2-old===
' 0.6.0.2-new+++
	SetLastError (0)
	IF hCal THEN
		timeSize = SIZE(SYSTEMTIME)
		IF SendMessageA (hCal, $$MCM_GETCURSEL, timeSize, &time) THEN
			RETURN $$TRUE		' success
		ELSE
			msg$ = "WinX-WinXCalendar_GetSelection: Can't get the selected date"
			GuiTellApiError (@msg$)
		ENDIF
	ENDIF
' 0.6.0.2-new===
'
END FUNCTION
'
' #######################################
' #####  WinXCalendar_SetSelection  #####
' #######################################
' Sets the selection in a calendar control.
' hCal = the handle of the calendard control
' start = the start of the selection range
' end = the end of the selection range
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXCalendar_SetSelection (hCal, SYSTEMTIME time)
	SetLastError (0)
	IFZ hCal THEN RETURN $$FALSE		' fail
	IF SendMessageA (hCal, $$MCM_SETCURSEL, 0, &time) THEN
		RETURN $$TRUE		' success
	ELSE
		msg$ = "WinX-WinXCalendar_SetSelection: Can't set a selection in the calendatr"
		GuiTellApiError (@msg$)
	ENDIF
END FUNCTION
'
' #########################
' #####  WinXCleanUp  #####
' #########################
' WinX Optional Clean-up.
' Graciously stops a running WinX GUI app.
'
FUNCTION WinXCleanUp ()

	SHARED STRING g_bReentry		' ensure WinX() is entered only one time
	SHARED g_hClipMem		' global memory for clipboard operations
	SHARED g_drag_image		' image list for the dragging effect

	SetLastError (0)
'
' Free global allocated memory.
'
	' global memory needed for clipboard operations
	IF g_hClipMem THEN GlobalFree (g_hClipMem)
	g_hClipMem = 0		' don't free twice
'
' Delete the image list created by CreateDragImage().
'
	IF g_drag_image THEN ImageList_Destroy (g_drag_image)
	g_drag_image = 0

	CleanUp ()		' GUI clean-up
	g_bReentry = ""		' allow again re-entry

END FUNCTION
'
' #######################
' #####  WinXClear  #####
' #######################
' Clears all the graphics in a window.
' hWnd = the handle of the window to clear
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXClear (hWnd)
	BINDING			binding
	XLONG		idBinding		' binding id
	RECT	rect

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE		' fail

	SetLastError (0)
	GetClientRect (hWnd, &rect)
	binding.hUpdateRegion = CreateRectRgn (0, 0, rect.right + 2, rect.bottom + 2)
	binding_update (idBinding, binding)

	RETURN autoDraw_clear (binding.autoDrawInfo)
END FUNCTION
'
' ###############################
' #####  WinXClip_GetImage  #####
' ###############################
' Gets an image from the clipboard.
' returns the handle of the bitmap, or 0 on fail
FUNCTION WinXClip_GetImage ()
	BITMAPINFOHEADER bmi
	XLONG hImage		' the handle of the new bitmap
	XLONG hClipData		' = GetClipboardData ($$CF_DIB)
	XLONG hClip			' handle of the clipboard data
	XLONG pGlobalMem		' = GlobalLock (g_hClipMem)
	XLONG hDC				' the handle of the compatible context
	XLONG hOld			' = SelectObject (hDC, hImage)
	XLONG height		' = ABS (bmi.biHeight)

	XLONG running_ptr				' running pointer

	SetLastError (0)

	hImage = 0

	hClipData = 0
	hClip = OpenClipboard (0)		' open the clipboard
	SELECT CASE hClip
		CASE 0		' clipboard unavailable

		CASE ELSE
			hClipData = GetClipboardData ($$CF_DIB)
			IFZ hClipData THEN EXIT SELECT

			pGlobalMem = GlobalLock (hClipData)
			IFZ pGlobalMem THEN EXIT SELECT

			RtlMoveMemory (&bmi, pGlobalMem, ULONGAT(pGlobalMem))
			hImage = WinXDraw_CreateImage (bmi.biWidth, bmi.biHeight)
			hDC = CreateCompatibleDC (0)
			hOld = SelectObject (hDC, hImage)

			height = ABS (bmi.biHeight)
			running_ptr = pGlobalMem + SIZE(BITMAPINFOHEADER)

			SELECT CASE bmi.biBitCount
				CASE 1 : running_ptr = running_ptr + 8
				CASE 4 : running_ptr = running_ptr + 64
				CASE 8 : running_ptr = running_ptr + 1024
				CASE 16, 24, 32
					SELECT CASE bmi.biCompression
						CASE $$BI_RGB
						CASE $$BI_BITFIELDS
							running_ptr = running_ptr + 12
					END SELECT
			END SELECT
			'
			'PRINT "WinXClip_GetImage: bmi.biBitCount ="; bmi.biBitCount
			'
			SetDIBitsToDevice (hDC, 0, 0, bmi.biWidth, height, 0, 0, 0, height, running_ptr, pGlobalMem, $$DIB_RGB_COLORS)

			SelectObject (hDC, hOld)
			DeleteDC (hDC)
			hDC = 0

	END SELECT

	IF hClipData THEN
		GlobalUnlock (hClipData)
		hClipData = 0
	ENDIF

	IF hClip THEN
		CloseClipboard ()
		hClip = 0
	ENDIF

	RETURN hImage

END FUNCTION
'
' ################################
' #####  WinXClip_GetString  #####
' ################################
' Gets a string from the clipboard.
' returns the string or an empty string on fail
FUNCTION WinXClip_GetString$ ()
	XLONG hClipData			' handle of the clipboard data
	XLONG pGlobalMem			' = GlobalLock (hClipData)

	SetLastError (0)
	IFZ OpenClipboard (0) THEN RETURN ""

	hClipData = GetClipboardData ($$CF_TEXT)
	pGlobalMem = GlobalLock (hClipData)
	ret$ = CSTRING$(pGlobalMem)
	GlobalUnlock (hClipData)
	CloseClipboard ()

	RETURN ret$

END FUNCTION
'
' ##############################
' #####  WinXClip_IsImage  #####
' ##############################
' Checks to see if the clipboard contains an image.
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXClip_IsImage ()
	SetLastError (0)
	IF IsClipboardFormatAvailable ($$CF_DIB) THEN
		RETURN $$TRUE		' clipboard contains an image
	ELSE
		msg$ = "WinX-WinXClip_IsImage: Can't check if clipboard contains an image"
		GuiTellApiError (@msg$)
	ENDIF
END FUNCTION
'
' ###############################
' #####  WinXClip_IsString  #####
' ###############################
' Checks to see if the clipboard contains a string.
' returns $$TRUE only if the clipboard contains a string
FUNCTION WinXClip_IsString ()
	SetLastError (0)
	IF IsClipboardFormatAvailable ($$CF_TEXT) THEN
		RETURN $$TRUE		' clipboard contains a string
	ELSE
		msg$ = "WinX-WinXClip_IsString: Can't check if clipboard contains a string"
		GuiTellApiError (@msg$)
	ENDIF
END FUNCTION
'
' ###############################
' #####  WinXClip_PutImage  #####
' ###############################
' Copies an image to the clipboad.
' hImage = the handle of the image to add to the clipboard
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXClip_PutImage (hImage)
	SHARED g_hClipMem		' to copy to the clipboard

	BITMAPINFOHEADER bmi
	DIBSECTION ds
	BITMAP bitmap		' BITMAP structure
	XLONG cbBits		' bit count of the DIB section
	XLONG hClip			' = OpenClipboard (0)
	XLONG hClipData			' = GlobalLock (hClipData)
	XLONG pGlobalMem
	XLONG bOK				' $$TRUE for success

	SetLastError (0)
	bOK = $$FALSE

	hClip = 0

	SELECT CASE hImage
		CASE 0

		CASE ELSE
			IFZ GetObjectA (hImage, SIZE(DIBSECTION), &bitmap) THEN EXIT SELECT

			hClip = OpenClipboard (0)
			IFZ hClip THEN EXIT SELECT

			IF g_hClipMem THEN
				' GL-07dec11-avoid memory leak:
				' Release any used global memory block,
				' prior to allocating a new global memory block.
				GlobalFree (g_hClipMem)
				g_hClipMem = 0
			ENDIF
			EmptyClipboard ()

			' allocate a new global memory block.
			cbBits = ds.dsBm.height * ((ds.dsBm.width * ds.dsBm.bitsPixel + 31) \ 32)
			g_hClipMem = GlobalAlloc ($$GMEM_MOVEABLE OR $$GMEM_ZEROINIT, SIZE(BITMAPINFOHEADER) + cbBits)
			IFZ g_hClipMem THEN EXIT SELECT

			pGlobalMem = GlobalLock (g_hClipMem)
			RtlMoveMemory (pGlobalMem, &ds.dsBmih, SIZE(BITMAPINFOHEADER))
			RtlMoveMemory (pGlobalMem + SIZE(BITMAPINFOHEADER), ds.dsBm.bits, cbBits)
			GlobalUnlock (g_hClipMem)		' don't send locked memory to clipboard

			' send memory to the clipboard
			hClipData = SetClipboardData ($$CF_DIB, g_hClipMem)
			IF hClipData THEN bOK = $$TRUE		' success

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
' Copies a string to the clipboard.
' Stri$ = The string to copy
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXClip_PutString (Stri$)
	SHARED g_hClipMem		' to copy to the clipboard
	XLONG pGlobalMem			' = GlobalLock (g_hClipMem)

	SetLastError (0)
	IFZ OpenClipboard (0) THEN RETURN $$FALSE
	EmptyClipboard ()

	g_hClipMem = GlobalAlloc ($$GMEM_MOVEABLE OR $$GMEM_ZEROINIT, LEN (Stri$) + 1)
	pGlobalMem = GlobalLock (g_hClipMem)
	RtlMoveMemory (pGlobalMem, &Stri$, LEN (Stri$))
	GlobalUnlock (g_hClipMem)

	SetClipboardData ($$CF_TEXT, g_hClipMem)
	CloseClipboard ()

	RETURN $$TRUE		' success

END FUNCTION
'
' ##################################
' #####  WinXComboBox_AddItem  #####
' ##################################
' Adds a new item to a combo box.
' hCombo = the handle of the combo box
' index = the index to insert the item at, use -1 to add to the end
' indent = the number of indents to place the item at
' item$ = the item text
' iImage = the index to the image, ignored if this combo box doesn't have images
' iSelImage = the index of the image displayed when this item is selected
' returns the index of the new item, or -1 on fail
FUNCTION WinXComboBox_AddItem (hCombo, index, indent, item$, iImage, iSelImage)
	COMBOBOXEXITEM cbexi		' extended combo box structure

	cbexi.mask = $$CBEIF_IMAGE OR $$CBEIF_INDENT OR $$CBEIF_SELECTEDIMAGE OR $$CBEIF_TEXT
	cbexi.iItem = index
	cbexi.iImage = iImage
	cbexi.iSelectedImage = iSelImage
	cbexi.iIndent = indent

	cbexi.pszText = &item$
	cbexi.cchTextMax = LEN (item$)

	RETURN SendMessageA (hCombo, $$CBEM_INSERTITEM, 0, &cbexi)
END FUNCTION
'
' ################################
' #####  WinXComboBox_Clear  #####
' ################################
' Clears out the combo box's contents.
' and resets the content of its edit control.
' hCombo = the handle of the combo box
FUNCTION WinXComboBox_Clear (hCombo)
	SetLastError (0)
	IF hCombo THEN
		SendMessageA (hCombo, $$CB_RESETCONTENT, 0, 0)
		RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' #######################################
' #####  WinXComboBox_GetEditText$  #####
' #######################################
' Gets the text in the edit control of a combo box.
' hCombo = the handle of the combo box
' returns the text, or an empty string on fail
'
' Usage:
'	text$ = WinXComboBox_GetEditText$ (hCombo)		' get the text in the edit control
'
FUNCTION WinXComboBox_GetEditText$ (hCombo)
	XLONG hEdit				' the handle of the edit control

	IFZ hCombo THEN RETURN ""		' fail
'
' Gets the handle to the edit control portion of a ComboBoxEx control. A
' ComboBoxEx control uses an edit box when it is set to the $$CBS_DROPDOWN
' style.
'
	hEdit = SendMessageA (hCombo, $$CBEM_GETEDITCONTROL, 0, 0)
	IF hEdit THEN
		RETURN WinXGetText$ (hEdit)
	ENDIF
END FUNCTION
'
' ###################################
' #####  WinXComboBox_GetItem$  #####
' ###################################
' Gets the text of a combo box item.
' hCombo = the handle of the combo box
' index = the zero-based index of the item to get
'         or -1 to retrieve the item displayed in the edit control.
' returns the text of the item, or an empty string on fail
FUNCTION WinXComboBox_GetItem$ (hCombo, index)
	COMBOBOXEXITEM cbexi		' extended combo box structure

	SetLastError (0)
	IF hCombo THEN
		cbexi.mask = $$CBEIF_TEXT
		cbexi.iItem = index

		cbexi.cchTextMax = 4095
		item$ = NULL$ (cbexi.cchTextMax + 1)
		cbexi.pszText = &item$

		IF SendMessageA (hCombo, $$CBEM_GETITEM, 0, &cbexi) THEN
			RETURN CSTRING$(cbexi.pszText)
		ENDIF
	ENDIF
END FUNCTION
'
' #######################################
' #####  WinXComboBox_GetSelection  #####
' #######################################
' Gets the index of the currently selected item in a combo box.
' hCombo = the handle of the combo box
' returns the index of the currently selected item
'         or $$CB_ERR on fail
'
' Usage:
'	indexSel = WinXComboBox_GetSelection (hCombo)		' get the index of the selected item
'	IF indexSel >= 0 THEN
'		item$ = WinXComboBox_GetItem$ (hCombo, indexSel)
'	ENDIF
'
FUNCTION WinXComboBox_GetSelection (hCombo)
	SetLastError (0)
	IFZ hCombo THEN RETURN $$CB_ERR		' fail
	RETURN SendMessageA (hCombo, $$CB_GETCURSEL, 0, 0)
END FUNCTION
'
' #####################################
' #####  WinXComboBox_RemoveItem  #####
' #####################################
' removes an item from a combobox
' hCombo = the handle of the combo box
' index = the zero-based index of the item to delete
' returns the number of items remaining in the list, or $$CB_ERR on fail
FUNCTION WinXComboBox_RemoveItem (hCombo, index)
	IFZ hCombo THEN RETURN $$CB_ERR		' fail
	RETURN SendMessageA (hCombo, $$CBEM_DELETEITEM, index, 0)
END FUNCTION
'
' ######################################
' #####  WinXComboBox_SetEditText  #####
' ######################################
' Sets the text in the edit control for a combo box.
' hCombo = the handle of the combo box
' STRING text = the text to put in the control
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXComboBox_SetEditText (hCombo, STRING text)
	XLONG hEdit				' the handle of the edit control

	IFZ hCombo THEN RETURN $$FALSE		' fail
	hEdit = SendMessageA (hCombo, $$CBEM_GETEDITCONTROL, 0, 0)
	IFZ hEdit THEN RETURN $$FALSE		' fail
	WinXSetText (hCombo, text)
	RETURN $$TRUE
END FUNCTION
'
' #######################################
' #####  WinXComboBox_SetSelection  #####
' #######################################
' Selects an item in a combo box.
' hCombo = the handle of the combo box
' index = the index of the item to select,
'         -1 to deselect everything.
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXComboBox_SetSelection (hCombo, index)
	IFZ hCombo THEN RETURN $$FALSE		' fail
	IF (SendMessageA (hCombo, $$CB_SETCURSEL, index, 0) = $$CB_ERR) && (index != -1) THEN
		RETURN $$FALSE		' fail
	ELSE
		RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' ###################################
' #####  WinXCtr_Adjust_height  #####
' ###################################
'
' Changes the control's height to reflect its window's new height.
'
' hWnd = the handle of the parent window
'
' Window's Arguments
' ==================
' win_initH = the initial height
' winHeight = the current height
' bMenu     = $$TRUE to account for the menubar's height
'
' Control's Arguments
' ===================
' idCtr = control id
' w_init = width
' h_init	= height
'
' returns new_h, the new control's height
'
FUNCTION WinXCtr_Adjust_height (hWnd, win_initH, winHeight, bMenu, idCtr, w_init, h_init, @new_h)

	XLONG hCtr		' handle of the control
	XLONG corr_h		' correction of the height

	SELECT CASE hWnd
		CASE 0
			msg$ = "WinX-WinXCtr_Adjust_height: null window handle"
			XstAlert (@msg$)
			'
		CASE ELSE
			hCtr = GetDlgItem (hWnd, idCtr)		' get the handle of the control
			IFZ hCtr THEN
				msg$ = "WinX-WinXCtr_Adjust_height: null handle"
				XstAlert (@msg$)
				EXIT SELECT
			ENDIF
			'
			' tie the control's bottom to its window's bottom
			corr_h = win_initH - h_init
			corr_h = corr_h - GetSystemMetrics ($$SM_CYCAPTION)		' height of window caption

			' account for the menubar's height
			IF bMenu THEN
				corr_h = corr_h - GetSystemMetrics ($$SM_CYMENU)		' height of single-line menu
			ENDIF

			corr_h = corr_h - (2 * GetSystemMetrics ($$SM_CYFRAME))		' height of bottom window frame
			new_h = winHeight - corr_h
			'
			' resize the control
			' dragged by the variation of window's height
			' MoveWindow (hCtr, ?, ?, w_init, h_init, 1)
			SetWindowPos (hCtr, $$HWND_TOP, 0, 0, w_init, new_h, $$SWP_NOMOVE)
			'
	END SELECT

END FUNCTION
'
' #################################
' #####  WinXCtr_Adjust_size  #####
' #################################
'
' Resizes the control width and the height
' to reflect its window's new width and height.
'
' hWnd = the handle of the parent window
'
' Window's Arguments
' ==================
' win_initW = the initial width
' winWidth = the current width
'
' win_initH = the initial height
' winHeight = the current height
' bMenu     = $$TRUE to account for the menubar's height
'
' Control's Arguments
' ===================
' idCtr = control id
' x_init = left position
' y_init = top 	position
'
' returns:
' new_w = the new control's width
' new_h = the new control's height
'
FUNCTION WinXCtr_Adjust_size (hWnd, win_initW, win_initH, winWidth, winHeight, bMenu, idCtr, x_init, y_init, w_init, h_init, @new_w, @new_h)

	XLONG hCtr		' handle of the control
	XLONG corr_w		' correction of the width
	XLONG corr_h		' correction of the height

	SELECT CASE hWnd
		CASE 0
			msg$ = "WinX-WinXCtr_Adjust_size: null window handle"
			XstAlert (@msg$)
			'
		CASE ELSE
			hCtr = GetDlgItem (hWnd, idCtr)		' get the handle of the control
			IFZ hCtr THEN
				msg$ = "WinX-WinXCtr_Adjust_size: null handle"
				XstAlert (@msg$)
				EXIT SELECT
			ENDIF
			'
			' tie the control's right margin to its window's right margin
			corr_w = win_initW - w_init
			corr_w = corr_w - (2 * GetSystemMetrics ($$SM_CXFRAME))		' width of right window frame
			new_w = winWidth - corr_w
			'
			' tie the control's bottom to its window's bottom
			corr_h = win_initH - h_init
			corr_h = corr_h - GetSystemMetrics ($$SM_CYCAPTION)		' height of window caption

			' account for the menubar's height
			IF bMenu THEN
				corr_h = corr_h - GetSystemMetrics ($$SM_CYMENU)		' height of single-line menu
			ENDIF

			corr_h = corr_h - (2 * GetSystemMetrics ($$SM_CYFRAME))		' height of bottom window frame
			new_h = winHeight - corr_h
			'
			' resize the control
			' dragged by the variation of window's size
			' MoveWindow (hCtr, ?, ?, w_init, w_init, 1)
			SetWindowPos (hCtr, $$HWND_TOP, 0, 0, new_w, new_h, $$SWP_NOMOVE)
			'
	END SELECT

END FUNCTION
'
' ##################################
' #####  WinXCtr_Adjust_width  #####
' ##################################
'
' Changes the control's width to reflect its window's new width.
'
' hWnd = the handle of the parent window
'
' Window's Arguments
' ==================
' win_initW = the initial width
' winWidth = the current width
'
' Control's Arguments
' ===================
' idCtr = control id
' w_init = width
' h_init	= height
'
' returns new_w, the new control's width
'
FUNCTION WinXCtr_Adjust_width (hWnd, win_initW, winWidth, idCtr, w_init, h_init, @new_w)

	XLONG hCtr		' handle of the control
	XLONG corr_right		' correction of the width

	SELECT CASE hWnd
		CASE 0
			msg$ = "WinX-WinXCtr_Adjust_width: null window handle"
			XstAlert (@msg$)
			'
		CASE ELSE
			hCtr = GetDlgItem (hWnd, idCtr)		' get the handle of the control
			IFZ hCtr THEN
				msg$ = "WinX-WinXCtr_Adjust_width: null handle"
				XstAlert (@msg$)
				EXIT SELECT
			ENDIF
			'
			' tie the control's right margin to its window's right margin
			corr_right = win_initW - w_init
			corr_right = corr_right - GetSystemMetrics ($$SM_CXFRAME)		' width of the RIGHT window frame
			'
			new_w = winWidth - corr_right
			'
			' adjust the control's width
			' dragged by the variation of window's width
			' MoveWindow (hCtr, ?, ?, w_init, h_init, 0)
			SetWindowPos (hCtr, $$HWND_TOP, 0, 0, new_w, h_init, $$SWP_NOMOVE)
			'
	END SELECT

END FUNCTION
'
' #########################################
' #####  WinXCtr_Slide_left_or_right  #####
' #########################################
'
' Slides left or right the control by tighing
' the control's left position to its window's width.
'
' hWnd = the handle of the parent window
'
' Window's Arguments
' ==================
' win_initW = the initial width
' winWidth = the current width
'
' Control's Arguments
' ===================
' idCtr = control id
' x_init = left position
' y_init = top 	position
'
' returns new_x, the new control's left position
'
FUNCTION WinXCtr_Slide_left_or_right (hWnd, win_initW, winWidth, idCtr, x_init, y_init, @new_x)

	XLONG hCtr							' handle of the control
	XLONG corr_x		' correction of the left position

	SELECT CASE hWnd
		CASE 0
			msg$ = "WinX-WinXCtr_Slide_left_or_right: null window handle"
			XstAlert (@msg$)
			'
		CASE ELSE
			hCtr = GetDlgItem (hWnd, idCtr)		' get the handle of the control
			IFZ hCtr THEN
				msg$ = "WinX-WinXCtr_Slide_left_or_right: null handle"
				XstAlert (@msg$)
				EXIT SELECT
			ENDIF
			'
			' tie control's left position to its window's width
			corr_x = win_initW - x_init
			corr_x = corr_x - GetSystemMetrics ($$SM_CXFRAME)		' width of right window frame
			new_x = winWidth - corr_x
			'
			' slide the control left or right
			' dragged by the changes of window's width
			' MoveWindow (hCtr, x_init, y_init, ?, ?, 0)
			SetWindowPos (hCtr, $$HWND_TOP, new_x, y_init, 0, 0, $$SWP_NOSIZE)
			'
	END SELECT

END FUNCTION
'
' ######################################
' #####  WinXCtr_Slide_up_or_down  #####
' ######################################
'
' Slides up or down the control by tighing
' the control's top position to its window's height.
'
' hWnd = the handle of the parent window
'
' Window's Arguments
' ==================
' win_initH = the initial height
' winHeight = the current height
' bMenu     = $$TRUE to account for the menubar's height
'
' Control's Arguments
' ===================
' idCtr = control id
' x_init = left position
' y_init = top 	position
'
' returns new_y, the new control's top position
'
FUNCTION WinXCtr_Slide_up_or_down (hWnd, win_initH, winHeight, bMenu, idCtr, x_init, y_init, @new_y)

	XLONG hCtr		' handle of the control
	XLONG corr_y		' correction of the top position

	SELECT CASE hWnd
		CASE 0
			msg$ = "WinX-WinXCtr_Slide_up_or_down: null window handle"
			XstAlert (@msg$)
			'
		CASE ELSE
			hCtr = GetDlgItem (hWnd, idCtr)		' get the handle of the control
			IFZ hCtr THEN
				msg$ = "WinX-WinXCtr_Slide_up_or_down: null handle"
				XstAlert (@msg$)
				EXIT SELECT
			ENDIF
			'
			' tie the control's top to its window's bottom
			corr_y = win_initH - y_init
			corr_y = corr_y - GetSystemMetrics ($$SM_CYCAPTION)		' height of window caption

			' account for the menubar's height
			IF bMenu THEN
				corr_y = corr_y - GetSystemMetrics ($$SM_CYMENU)		' height of single-line menu
			ENDIF

			corr_y = corr_y - (2 * GetSystemMetrics ($$SM_CYFRAME))		' height of bottom window frame
			new_y = winHeight - corr_y
			'
			' slide the control up or down
			' dragged by the changes of window's height
			' MoveWindow (hCtr, x_init, new_y, ?, ?, 0)
			SetWindowPos (hCtr, $$HWND_TOP, x_init, new_y, 0, 0, $$SWP_NOSIZE)
			'
	END SELECT

END FUNCTION
'
' ##############################
' #####  WinXDialog_Error  #####
' ##############################
' Displays an error dialog box.
' STRING message = the message to display
' STRING title = the title of the message box
' severity = severity of the error
' 0 = debug, 1 = warning, 2 = error, 3 = unrecoverable error
' returns $$TRUE or abort if unrecoverable error.
'
' Usage:
'	title$ = "Action"
'	IF bOK THEN
'		severity = 0		' information
'		msg$ = "OK!"
'	ELSE
'		severity = 2		' error
'		msg$ = "Error!"
'	ENDIF
'	WinXDialog_Error (@msg$, @title$, severity)
'
FUNCTION WinXDialog_Error (STRING message, STRING title, severity)
	XLONG icon			' the severity icon
	XLONG hWnd			' the handle of the active window
	XLONG mret			' return value of User answer

	IF severity < 0 THEN severity = 0
	IF severity > 3 THEN severity = 3

	icon = 0
	SELECT CASE severity
		CASE 0 : icon = $$MB_ICONINFORMATION		' = $$MB_ICONASTERISK
		CASE 1 : icon = $$MB_ICONWARNING		' = $$MB_ICONEXCLAMATION
		CASE 2 : icon = $$MB_ICONERROR		' = $$MB_ICONHAND
		CASE 3 : icon = $$MB_ICONSTOP		' = $$MB_ICONHAND
	END SELECT
	IFZ hWnd THEN
		hWnd = GetActiveWindow ()
	ENDIF
	IFZ title THEN title = "Alert"

	MessageBoxA (hWnd, &message, &title, $$MB_OK OR icon)
'
' 0.6.0.2-old---
'	IF severity = 3 THEN QUIT(0)
' 0.6.0.2-old===
' 0.6.0.2-new+++
	IF severity = 3 THEN
		' Unrecoverable error => Abort Program?
		message = message + "\r\nDo you want to abort this program?"
'		-- XstAbend (@message)
		title = "Unrecoverable Error"
		mret = WinXDialog_Question (hWnd, @message, @title, $$FALSE, 1)		' default to the 'No' button
		IF mret = $$IDYES THEN
			' abort is confirmed
			WinXCleanUp ()		' optional clean-up
			QUIT (0)		' abort
		ENDIF
		RETURN $$FALSE
	ENDIF
' 0.6.0.2-new===
'
	RETURN $$TRUE

END FUNCTION
'
' ##################################
' #####  WinXDialog_OpenFile$  #####
' ##################################
' Displays an Open File Dialog.
' hOwner = the handle of the window to own this dialog
' title$ = the title for the dialog
' extensions$ = a string containing the file extensions the dialog supports
' initialName$ = the filename to initialize the dialog with
' multiSelect = $$TRUE to enable selection of multiple items, otherwise $$FALSE
' returns the opened file(s) or the empty string on error or cancel.
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
	OPENFILENAME ofn
	XLONG ret				' win32 api return value (0 for fail)
	XLONG pos				' character position
	XLONG slash			' position of $$PathSlash$
	XLONG dot				' position of the dot sign
	XLONG count			' counter
	XLONG running_ptr				' running pointer, starts with ofn.lpstrFile

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
	initialName$ = TRIM$(initialName$)
	IFZ initialName$ THEN
		XstGetCurrentDirectory (@initialName$)
		initialName$ = initialName$ + $$PathSlash$ + "*.*"
	ENDIF
'
' Ensure Windows' path slashes.
'
	pos = INSTR (initialName$, "/")
	DO WHILE pos
		initialName${pos - 1} = '\\'
		pos = INSTR (initialName$, "/", pos + 1)
	LOOP
'
' debug+++
'msg$ = "WinXDialog_OpenFile$: initialName$ = " + initialName$
'WinXDialog_Error (@msg$, @"WinX-Information", 0)
' debug===
'
	SELECT CASE TRUE
		CASE RIGHT$ (initialName$) = $$PathSlash$		' GL-15dec08-initialName$ is a directory
			initDir$ = initialName$
			'
		CASE RIGHT$ (initialName$) = ":"		' GL-14nov11-initialName$ is a drive
			initDir$ = initialName$
			'
		CASE ELSE
'
' 0.6.0.2-old---
' Handle initialName$ = ".\\images\\*.bmp".
'
'			XstDecomposePathname (initialName$, @initDir$, "", @initFN$, "", @initExt$)
' 0.6.0.2-old===
' 0.6.0.2-new+++
			slash = RINSTR (initialName$, $$PathSlash$)
			IFZ slash THEN
				initDir$ = initialName$
			ELSE
				initDir$ = LEFT$ (initialName$, slash)
			ENDIF
			dot = INSTR (initialName$, ".", slash + 1)
			IFZ dot THEN
				initFN$ = STRING_Extract$ (initialName$, slash + 1, LEN (initialName$))
				initExt$ = ""
			ELSE
				IF (slash + 1) = dot THEN
					initFN$ = "*"
				ELSE
					initFN$ = STRING_Extract$ (initialName$, slash + 1, dot - 1)
				ENDIF
				initExt$ = STRING_Extract$ (initialName$, dot, LEN (initialName$))		' initExt$ = <.ext>
			ENDIF
' 0.6.0.2-new===
'
	END SELECT
'
' debug+++
'msg$ = "WinXDialog_OpenFile$: initFN$ = <" + initFN$ + ">, initExt$ = <" + initExt$ + ">"
'WinXDialog_Error (@msg$, @"WinX-Information", 0)
' debug===
'
	' compute ofn.lpstrInitialDir
	initDir$ = TRIM$(initDir$)
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
	fileFilter$ = TRIM$(extensions$)
	IF RIGHT$ (fileFilter$) <> "|" THEN fileFilter$ = fileFilter$ + "|"
'
' replace all separators "|" by the zero-character
'
	pos = INSTR (fileFilter$, "|")
	DO WHILE pos > 0
		fileFilter${pos - 1} = 0
		pos = INSTR (fileFilter$, "|", pos + 1)
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
'WinXDialog_Error (@msg$, @"WinX-Information", 0)
' debug===
'
	path$ = initFN$ + initExt$

	' allocate the returned buffer
	IF LEN (path$) >= $$MAX_PATH THEN
		szBuf$ = LEFT$ (path$, $$MAX_PATH)		' truncate path$
	ELSE
		szBuf$ = path$ + NULL$ ($$MAX_PATH - LEN (path$) + 1)		' pad path$
	ENDIF

	ofn.lpstrFile = &szBuf$
	ofn.nMaxFile = LEN (szBuf$)
'
' debug+++
'msg$ = "WinXDialog_OpenFile$: szBuf$ = " + szBuf$
'WinXDialog_Error (@msg$, @"WinX-Information", 0)
' debug===
'
	IF title$ THEN ofn.lpstrTitle = &title$		' dialog title

	' set dialog flags
	ofn.flags = $$OFN_FILEMUSTEXIST OR $$OFN_EXPLORER

	IF multiSelect THEN
		ofn.flags = ofn.flags OR $$OFN_ALLOWMULTISELECT
	ENDIF
'
' GL-28oct09-old---
'	' readOnly allows to open "Read Only" (no lock) the selected file(s).
'	IF readOnly THEN
'		ofn.flags = ofn.flags OR $$OFN_READONLY		' show the checkbox "Read Only" (initially checked)
'	ELSE
'		ofn.flags = ofn.flags OR $$OFN_HIDEREADONLY
'	ENDIF
' GL-28oct09-old===
' GL-28oct09-new+++
	' allow to open "Read Only" (no lock) the selected file(s)
	ofn.flags = ofn.flags OR $$OFN_READONLY		' show the checkbox "Read Only" (initially checked)
' GL-28oct09-new===
'
	ofn.lpstrDefExt = &initExt$

	IFZ hOwner THEN
		ofn.hwndOwner = GetActiveWindow ()
	ELSE
		ofn.hwndOwner = hOwner
	ENDIF
	ofn.hInstance = GetModuleHandleA (0)

	ofn.lStructSize = SIZE(OPENFILENAME)		' length of the structure (in bytes)
	SetLastError (0)
	ret = GetOpenFileNameA (&ofn)		' fire off dialog
'
' 0.6.0.2-new+++
	IFZ ret THEN
		caption$ = "WinXDialog_OpenFile$: Windows' Open File Error"
		GuiTellDialogError (hOwner, caption$)
		RETURN ""		' fail
	ENDIF
' 0.6.0.2-new===
'
	' build r_selFiles$, a list of selected files, separated by ";"
	IFF multiSelect THEN
		opened$ = CSTRING$(ofn.lpstrFile)
		opened$ = TRIM$(opened$)
		r_selFiles$ = opened$
	ELSE
		' opened file loop
		r_selFiles$ = ""
		running_ptr = ofn.lpstrFile
		DO WHILE UBYTEAT (running_ptr)		' list loop
			opened$ = ""
			DO		' opened file name loop
				opened$ = opened$ + CHR$ (UBYTEAT (running_ptr))
				INC running_ptr
			LOOP WHILE UBYTEAT (running_ptr)

			opened$ = TRIM$(opened$)
			IFZ r_selFiles$ THEN
				r_selFiles$ = opened$
			ELSE
				r_selFiles$ = r_selFiles$ + ";" + opened$
			ENDIF
			INC running_ptr		' skip nul terminator
		LOOP
	ENDIF

	RETURN r_selFiles$

END FUNCTION
'
' #################################
' #####  WinXDialog_Question  #####
' #################################
' Displays a dialog asking the User a question
' hOwner = the handle of the owner window or 0 for none
' text$ = the question
' title$ = the dialog box title
' cancel = $$TRUE to enable the cancel button
' defaultButton = the zero-based index of the default button
' returns the id of the button the User selected
'
' Usage:
'FUNCTION winMain_OnClose (hWnd)
'
'	title$ = PROGRAM$ (0) + ".exe - Exit"
'	msg$ = "Are you sure you want to quit the program?"
'	mret = WinXDialog_Question (hWnd, msg$, title$, $$FALSE, 0)		' default to the 'Yes' button
'	IF mret = $$IDNO THEN RETURN 1		' quit is canceled
'
'	' quit application
'	PostQuitMessage ($$WM_QUIT)
'	RETURN 0		' quit is confirmed
'
'END FUNCTION
'
FUNCTION WinXDialog_Question (hOwner, msg$, title$, cancel, defaultButton)
	XLONG flags				' buttons Yes/No[/Cancel] style
	XLONG mret			' return value of User answer

	SetLastError (0)
	IF cancel THEN
		flags = $$MB_YESNOCANCEL
	ELSE
		flags = $$MB_YESNO
	ENDIF
	SELECT CASE defaultButton
'		CASE 0 : flags = flags OR $$MB_DEFBUTTON1		' default button is 'Yes'
		CASE 1 : flags = flags OR $$MB_DEFBUTTON2		' default button is 'No'
		CASE 2
			IF cancel THEN
				flags = flags OR $$MB_DEFBUTTON3		' default button is 'Cancel'
			ENDIF
	END SELECT
	flags = flags OR $$MB_ICONQUESTION

	IFZ hOwner THEN
		hOwner = GetActiveWindow ()
	ENDIF

	IFZ title$ THEN title$ = "Question"

	mret = MessageBoxA (hOwner, &msg$, &title$, flags)
	RETURN mret
END FUNCTION
'
' ##################################
' #####  WinXDialog_SaveFile$  #####
' ##################################
' Displays a Save File Dialog.
' hOwner = the parent window's handle
' title$ = the title of the dialog box
' extensions$ = a string listing the supported extensions
' initialName$ = the name to initialize the dialog with
' overwritePrompt = $$TRUE to warn the User when they are about to overwrite a file, $$FALSE otherwise
' returns the bachup file, or the empty string on error or cancel.
FUNCTION WinXDialog_SaveFile$ (hOwner, title$, extensions$, initialName$, overwritePrompt)
	OPENFILENAME ofn
	XLONG filterState
	XLONG cChar						' character counter
	XLONG pos							' character position
	XLONG posFirst				' position of the 1st separator '|'
	XLONG posLast
	XLONG posSemiColumn		' position of an eventual extensions list separator ';'
	XLONG ret							' win32 api return value (0 for fail)

	SetLastError (0)
'
' set file filter fileFilter$ with argument extensions$
' i.e.: extensions$ = "Image Files (*.bmp, *.jpg)|*.bmp;*.jpg"
' .                 ==> fileFilter$ = "Image Files (*.bmp, *.jpg)0*.bmp;*.jpg00"
'
	fileFilter$ = TRIM$(extensions$)

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
	DO WHILE pos > 0
		SELECT CASE filterState
			CASE 1 : filterState = 2		' skip the filter description
				'
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
					'
					IF (posSemiColumn > 0) && (posSemiColumn < posLast) THEN
						' extension list, separator is ';'
						cChar = posSemiColumn - posFirst		' i.e. "|*.ext1;*.ext2;...|"
					ELSE
						' single extension
						cChar = posLast - posFirst		' i.e. "|*.ext1|"
					ENDIF
					IF cChar > 0 THEN
						' extract the default extension from the pattern (it's the 1st of the list)
						defExt$ = MID$ (fileFilter$, posFirst, cChar)		' clip up to the separator (';' or '|')
						' remove the leading dot from the extension
						pos = INSTR (defExt$, ".")
						IF (pos > 0) THEN defExt$ = LCLIP$ (defExt$, pos)
					ENDIF
				ENDIF
				'
				filterState = 1		' switch to the description
				'
		END SELECT
		'
		fileFilter${pos - 1} = 0		' replace '|' by zero-character
		pos = INSTR (fileFilter$, "|", pos + 1)		' position of the next separator '|'
	LOOP

	ofn.lpstrFilter = &fileFilter$

	' allocate the returned buffer
	IF LEN (initialName$) >= $$MAX_PATH THEN
		szBuf$ = LEFT$ (initialName$, $$MAX_PATH + 1)		' truncate initialName$
	ELSE
		szBuf$ = initialName$ + NULL$ ($$MAX_PATH - LEN (initialName$) + 1)		' pad initialName$
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
	ofn.hInstance = GetModuleHandleA (0)
	ofn.lStructSize = SIZE(OPENFILENAME)

	SetLastError (0)
	ret = GetSaveFileNameA (&ofn)
'
' 0.6.0.2-new+++
	IFZ ret THEN
		caption$ = "WinXDialog_SaveFile$: Windows' Save File Error"
		GuiTellDialogError (hOwner, caption$)
		RETURN ""		' fail
	ENDIF
' 0.6.0.2-new===
'
	r_savedPath$ = CSTRING$(ofn.lpstrFile)
	RETURN r_savedPath$

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
'	Arg1        = hWnd : The handle of the window to display
' Return      = $$TRUE if the window was previously visible.
' Remarks     = This function should be called after all the child controls have been added to the window.  It calls the sizing function, which is either the registered callback function or the auto-sizer.
'	See Also    =
'	Examples    = WinXDisplay (#hMain)
'	*/
FUNCTION WinXDisplay (hWnd)
	XLONG bPreviouslyVisible
	RECT	rect
	XLONG ret				' win32 api return value (0 for fail)

	bPreviouslyVisible = $$FALSE

	IFZ hWnd THEN
		hWnd = GetActiveWindow ()
	ENDIF

	SetLastError (0)
	IF hWnd THEN
		' refresh the window
		GetClientRect (hWnd, &rect)
		sizeWindow (hWnd, rect.right - rect.left, rect.bottom - rect.top)

		SetLastError (0)
		ret = ShowWindow (hWnd, $$SW_SHOWNORMAL)		' $$SW_SHOW is reserved to WinXShow
		IF ret THEN
			bPreviouslyVisible = $$TRUE
		ELSE
			msg$ = "WinX-WinXDisplay: Can't display the window"
			GuiTellApiError (@msg$)
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
' Description = Receives and handles messages sent to it from the system in reaction to User interactions and system events
' Function    = WinXDoEvents ()
' ArgCount    = 0
' Return      = $$FALSE on receiving a QUIT message or $$TRUE on error
' Remarks     = This function doesn't return until the window is destroyed or a QUIT message is received.
'	See Also    =
'	Examples    = WinXDoEvents () ' event loop
'	*/
FUNCTION WinXDoEvents ()
	BINDING			binding
	XLONG		idBinding		' binding id

	MSG msg		' will be sent to the active window callback function when an event occurs
	XLONG ret				' win32 api return value (0 for fail)
	XLONG hWnd			' the handle of the active window
	XLONG bOK				' $$TRUE for success
	XLONG hAccel		' the handle for the active accelerator table
	XLONG bDispatch	' to deal with window messages
'
' Main Message Loop
' =================
' Supervise system messages until
' - the User decides to leave the application (RETURN $$FALSE)
' - an error occurred (returns bErr: $$TRUE on error)
'
	DO		' the message loop
		' retrieve next message from queue
		ret = GetMessageA (&msg, 0, 0, 0)
		SELECT CASE ret
			'CASE 0 : RETURN msg.wParam		' received a $$WM_QUIT message
			CASE  0 : RETURN $$FALSE		' received a $$WM_QUIT message
			CASE -1 : RETURN $$TRUE			' error
			CASE ELSE
				'-hWnd = XLONGAT(&msg)
				hWnd = GetActiveWindow ()

				'get the binding
				bOK = Get_the_binding (hWnd, @idBinding, @binding)
				'
				' Process accelerator keys for menu commands.
				'
				ret = 0
				' retrieve current window's acceleration table
				hAccel = 0
				IF bOK THEN
					' acceleration table
					hAccel = binding.hAccelTable
				ENDIF

				ret = 0
				IF hAccel THEN
					' "translate" the accelerator keys
					ret = TranslateAcceleratorA (hWnd, hAccel, &msg)
				ENDIF

				' Deal with window messages.
				bDispatch = $$FALSE
				IFZ ret THEN
					IFF binding.useDialogInterface THEN
						bDispatch = $$TRUE
					ELSE
						IF (!IsWindow (hWnd)) || (!IsDialogMessageA (hWnd, &msg)) THEN		' send only non-dialog messages
							bDispatch = $$TRUE
						ENDIF
					ENDIF
				ENDIF

				IF bDispatch THEN
					' send only non-dialog messages
					' translate virtual-key messages into character messages
					' ex.: SHIFT + a is translated as "A"
					TranslateMessage (&msg)

					' send message to the window callback
					DispatchMessageA (&msg)
				ENDIF

		END SELECT
	LOOP		' forever

END FUNCTION
'
' #########################
' #####  WinXDrawArc  #####
' #########################
' Draws an arc.
' returns the id of record, or 0 on fail
FUNCTION WinXDrawArc (hWnd, hPen, x1, y1, x2, y2, DOUBLE theta1, DOUBLE theta2)
	AUTODRAWRECORD record
	BINDING			binding
	XLONG		idBinding		' binding id
	LONGDOUBLE theta_1_normal
	LONGDOUBLE theta_2_normal

	XLONG halfW			' half width
	XLONG halfH			' half height
	XLONG idDraw		' the id of the auto-draw info block

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN 0		' fail

	halfW = (x2 - x1) / 2
	halfH = (y2 - y1) / 2

	' normalise the angles
	theta_1_normal = LONGDOUBLE (theta1)
	theta_2_normal = LONGDOUBLE (theta2)

	theta_1_normal = theta_1_normal - (INT (theta_1_normal / $$TWOPI) * $$TWOPI)
	theta_2_normal = theta_2_normal - (INT (theta_2_normal / $$TWOPI) * $$TWOPI)

	SELECT CASE theta_1_normal
		CASE 0
			a1# = halfW
			o1# = 0
		CASE $$PIDIV2
			a1# = 0
			o1# = halfH
		CASE $$PI
			a1# = - halfW
			o1# = 0
		CASE $$PI3DIV2
			a1# = 0
			o1# = - halfH
		CASE ELSE
			IF theta_1_normal + $$PIDIV2 > $$PI THEN a1# = - halfW ELSE a1# = halfW
			o1# = a1# * LongDoubleTangent (theta_1_normal)
			IF ABS (o1#) > halfH THEN
				IF theta_1_normal > $$PI THEN o1# = - halfH ELSE o1# = halfH
				a1# = o1# / LongDoubleTangent (theta_1_normal)
			ENDIF
	END SELECT

	SELECT CASE theta_2_normal
		CASE 0
			a2# = halfW
			o2# = 0
		CASE $$PIDIV2
			a2# = 0
			o2# = halfH
		CASE $$PI
			a2# = - halfW
			o2# = 0
		CASE $$PI3DIV2
			a2# = 0
			o2# = - halfH
		CASE ELSE
			IF theta_2_normal + $$PIDIV2 > $$PI THEN a2# = - halfW ELSE a2# = halfW
			o2# = a2# * LongDoubleTangent (theta_2_normal)
			IF ABS (o2#) > halfH THEN
				IF theta_2_normal > $$PI THEN o2# = - halfH ELSE o2# = halfH
				a2# = o2# / LongDoubleTangent (theta_2_normal)
			ENDIF
	END SELECT

	record.hPen = hPen
	record.hUpdateRegion = CreateRectRgn (MIN (x1, x2) - 10, MIN (y1, y2) - 10, MAX (x1, x2) + 10, MAX (y1, y2) + 10)
	record.rectControl.x1 = x1
	record.rectControl.y1 = y1
	record.rectControl.x2 = x2
	record.rectControl.y2 = y2
	record.rectControl.xC1 = a1# + x1 + halfW
	record.rectControl.yC1 = y1 + halfH - o1#
	record.rectControl.xC2 = a2# + x1 + halfW
	record.rectControl.yC2 = y1 + halfH - o2#

	record.draw = &drawArc ()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	' and update the binding
	binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw

END FUNCTION
'
' ############################
' #####  WinXDrawBezier  #####
' ############################
' Draws a bezier spline.
FUNCTION WinXDrawBezier (hWnd, hPen, x1, y1, x2, y2, xC1, yC1, xC2, yC2)
	AUTODRAWRECORD record
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG idDraw		' the id of the auto-draw info block

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN 0		' fail

	record.hPen = hPen
	record.hUpdateRegion = CreateRectRgn (MIN (x1, x2) - 10, MIN (y1, y2) - 10, MAX (x1, x2) + 10, MAX (y1, y2) + 10)
	record.rectControl.x1 = x1
	record.rectControl.y1 = y1
	record.rectControl.x2 = x2
	record.rectControl.y2 = y2
	record.rectControl.xC1 = xC1
	record.rectControl.yC1 = yC1
	record.rectControl.xC2 = xC2
	record.rectControl.yC2 = yC2

	record.draw = &drawBezier ()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	' and update the binding
	binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw

END FUNCTION
'
' #############################
' #####  WinXDrawEllipse  #####
' #############################
' Draws an ellipse.
FUNCTION WinXDrawEllipse (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD record
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG idDraw		' the id of the auto-draw info block
	XLONG hBrush		' the handle of the solid brush

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN 0		' fail
'
' GL-MISSING???
'	hBrush = CreateSolidBrush (codeRGB)
' GL-MISSING===
'
	record.hPen = hPen
	record.hUpdateRegion = CreateRectRgn (MIN (x1, x2) - 10, MIN (y1, y2) - 10, MAX (x1, x2) + 10, MAX (y1, y2) + 10)
	record.hBrush = hBrush
	record.rect.x1 = x1
	record.rect.y1 = y1
	record.rect.x2 = x2
	record.rect.y2 = y2

	record.draw = &drawEllipseNoFill ()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	' and update the binding
	binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw

END FUNCTION
'
' ################################
' #####  WinXDrawFilledArea  #####
' ################################
' Fills an enclosed area with a brush.
FUNCTION WinXDrawFilledArea (hWnd, hBrush, colBound, x, y)
	AUTODRAWRECORD record
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG idDraw		' the id of the auto-draw info block
	RECT	rect

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	GetWindowRect (hWnd, &rect)
	record.hUpdateRegion = CreateRectRgn (rect.left, rect.top, rect.right, rect.bottom)
	record.hBrush = hBrush
	record.simpleFill.x = x
	record.simpleFill.y = y
	record.simpleFill.col = colBound

	record.draw = &drawFill ()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	' and update the binding
	binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw

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
	AUTODRAWRECORD record
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG idDraw			' the id of the auto-draw info block

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN 0		' fail

	record.hUpdateRegion = CreateRectRgn (MIN (x1, x2) - 10, MIN (y1, y2) - 10, MAX (x1, x2) + 10, MAX (y1, y2) + 10)
	record.hPen = hPen
	record.hBrush = hBrush
	record.rect.x1 = x1
	record.rect.y1 = y1
	record.rect.x2 = x2
	record.rect.y2 = y2

	record.draw = &drawEllipse ()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	' and update the binding
	binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw

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
	AUTODRAWRECORD record
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG idDraw			' the id of the auto-draw info block

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	record.hUpdateRegion = CreateRectRgn (MIN (x1, x2) - 10, MIN (y1, y2) - 10, MAX (x1, x2) + 10, MAX (y1, y2) + 10)
	record.hPen = hPen
	record.hBrush = hBrush
	record.rect.x1 = x1
	record.rect.y1 = y1
	record.rect.x2 = x2
	record.rect.y2 = y2

	record.draw = &drawRect ()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	' and update the binding
	binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw

END FUNCTION
'
' ###########################
' #####  WinXDrawImage  #####
' ###########################
' Draws an image.
' hWnd = the handle of the window to draw on
' hImage = the handle of the image to draw
' x, y, w, h = the x, h, w, and h of the bitmap to blit
' xSrc, ySrc = the x, y coordinates on the image to blit from
' blend = $$TRUE if the image has been pre-multiplied for alpha blending
' (as long as alpha was pre-multiplied, alpha is preserved)
' returns the id of the operation, or 0 on fail
FUNCTION WinXDrawImage (hWnd, hImage, x, y, w, h, xSrc, ySrc, blend)
	AUTODRAWRECORD record
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG idDraw			' the id of the auto-draw info block

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	record.hUpdateRegion = CreateRectRgn (x - 1, y - 1, x + w + 2, y + h + 2)
	record.image.x = x
	record.image.y = y
	record.image.w = w
	record.image.h = h
	record.image.xSrc = xSrc
	record.image.ySrc = ySrc
	record.image.hImage = hImage
	record.image.blend = blend

	record.draw = &drawImage ()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	' and update the binding
	binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw

END FUNCTION
'
' ##########################
' #####  WinXDrawLine  #####
' ##########################
' Draws a line
' hWnd = the handle of the window to draw to
' hPen = the handle of the pen to draw the line with
' x1, y1, x2, y2 = the coordinates of the line
' returns the id of the line
FUNCTION WinXDrawLine (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD record
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG idDraw			' the id of the auto-draw info block

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	record.hPen = hPen
	record.hUpdateRegion = CreateRectRgn (MIN (x1, x2) - 10, MIN (y1, y2) - 10, MAX (x1, x2) + 10, MAX (y1, y2) + 10)
	record.rect.x1 = x1
	record.rect.y1 = y1
	record.rect.x2 = x2
	record.rect.y2 = y2

	record.draw = &drawLine ()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	' and update the binding
	binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw

END FUNCTION
'
' ##########################
' #####  WinXDrawRect  #####
' ##########################
' Draws a rectangle.
FUNCTION WinXDrawRect (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD record
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG idDraw			' the id of the auto-draw info block

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN 0

	record.hUpdateRegion = CreateRectRgn (MIN (x1, x2) - 10, MIN (y1, y2) - 10, MAX (x1, x2) + 10, MAX (y1, y2) + 10)
	record.hPen = hPen
	record.rect.x1 = x1
	record.rect.y1 = y1
	record.rect.x2 = x2
	record.rect.y2 = y2

	record.draw = &drawRectNoFill ()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	' and update the binding
	binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw

END FUNCTION
'
' ##########################
' #####  WinXDrawText  #####
' ##########################
' Draws some text on a window.
' hWnd = the handle of the window
' hFont = the handle of the font
' text = the text to print
' x, y = the coordintates to print the text at
' backCol, forCol = the colors for the text
' returns the handle (index) of the element, or -1 on fail
FUNCTION WinXDrawText (hWnd, hFont, STRING text, x, y, backCol, forCol)
	AUTODRAWRECORD record
	BINDING			binding
	TEXTMETRIC tm
	SIZEAPI size
	XLONG		idBinding		' binding id
	XLONG idDraw			' the id of the auto-draw info block
	XLONG hDC					' the handle of the context

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN 0		' fail

	hDC = CreateCompatibleDC (0)
	SelectObject (hDC, hFont)
	GetTextExtentPoint32A (hDC, &text, LEN (text), &size)
	DeleteDC (hDC)
	hDC = 0

	SetLastError (0)
	record.hUpdateRegion = CreateRectRgn (x - 1, y - 1, x + size.cx + 1, y + size.cy + 1)
	record.hFont = hFont
	record.text.x = x
	record.text.y = y
	record.text.iString = STRING_New (text)
	record.text.forColor = forCol
	record.text.backColor = backCol

	record.draw = &drawText ()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	' and update the binding
	binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw

END FUNCTION
'
' ############################
' #####  WinXDraw_Clear  #####
' ############################
' Clears all the graphics in a window
' hWnd = the handle of the window to clear
' returns $$TRUE on success, or $$FALSE on fail
' Note: Legacy wrapper to WinXClear().
FUNCTION WinXDraw_Clear (hWnd)
	RETURN WinXClear (hWnd)
END FUNCTION
'
' ################################
' #####  WinXDraw_CopyImage  #####
' ################################
' Generates a copy of an image, preserving alpha channel.
' hImage =  the handle of the image to copy
' returns the handle of the copy, or 0 on fail
FUNCTION WinXDraw_CopyImage (hImage)
	XLONG hBmpRet			' the handle of the copy
	BITMAP bmpSrc		' BITMAP structure source
	BITMAP bmpDst		' BITMAP structure destination

	SetLastError (0)
	hBmpRet = 0

	IF GetObjectA (hImage, SIZE(BITMAP), &bmpSrc) THEN
		hBmpRet = WinXDraw_CreateImage (bmpSrc.width, bmpSrc.height)
		IF hBmpRet THEN
			IF GetObjectA (hBmpRet, SIZE(BITMAP), &bmpDst) THEN
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
' Creates a new bitmap image.
' w, h = the width and height for the new image
' returns the handle of the DIB section representing the image, or 0 on fail
FUNCTION WinXDraw_CreateImage (w, h)
	BITMAPINFOHEADER bmih
	XLONG hDIBsection				' the handle of the DIB section representing the image
	XLONG bits				' bit count

	SetLastError (0)

	bmih.biSize = SIZE(BITMAPINFOHEADER)
	bmih.biWidth = w
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
' Deletes an image.
' hImage = the image to delete
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXDraw_DeleteImage (hImage)
	SetLastError (0)
	IF hImage THEN
		IF DeleteObject (hImage) THEN
			RETURN $$TRUE		' success
		ENDIF
	ENDIF
END FUNCTION
'
' ###############################
' #####  WinXDraw_GetColor  #####
' ###############################
' Displays a dialog box allowing the User to select an RGB color.
' initialRGB = the color to initialize the dialog box with
' returns the color in RGB format the User selected, or 0 on fail or cancel
' Note: Legacy wrapper to WinXDraw_GetColour().
FUNCTION WinXDraw_GetColor (hOwner, initialRGB)
	RETURN WinXDraw_GetColour (hOwner, initialRGB)
END FUNCTION
'
' ################################
' #####  WinXDraw_GetColour  #####
' ################################
' Displays a dialog box allowing the User to select a color.
' initialRGB = the colour to initialize the dialog box with
' returns the color the User selected.
'
' Usage:
' new_color = WinXDraw_GetColour (#winMain, color)
' IFZ new_color THEN
' 	' User canceled
' ENDIF
'
FUNCTION WinXDraw_GetColour (hOwner, initialRGB)
	SHARED g_customColors[]
	CHOOSECOLOR colorPicker
	XLONG r_codeRGB
	XLONG i				' running index
	XLONG ret

	IFZ g_customColors[] THEN
		' First time enter: Initialize the custom colors.
		DIM g_customColors[15]
		GOSUB Init_g_customColors
	ENDIF

	colorPicker.lpCustColors = &g_customColors[]

	' set initial text colour
	colorPicker.rgbResult = initialRGB

	' $$Black = 0, $$White = RGB (0xFF, 0xFF, 0xFF)
	IF colorPicker.rgbResult > $$White THEN
		' invalid RGB color
		colorPicker.rgbResult = $$White
	ENDIF

	colorPicker.hwndOwner = hOwner
	IFZ colorPicker.hwndOwner THEN
		colorPicker.hwndOwner = GetActiveWindow ()
	ENDIF
	colorPicker.flags = $$CC_RGBINIT
	colorPicker.lStructSize = SIZE(CHOOSECOLOR)

	SetLastError (0)
	ret = ChooseColorA (&colorPicker)
	IF ret THEN
		r_codeRGB = colorPicker.rgbResult		' User clicked button OK
	ELSE
		caption$ = "WinXDraw_GetColour: Color Picker Error"
		GuiTellDialogError (hOwner, caption$)
	ENDIF

	RETURN r_codeRGB
'
' Initialize the custom colors.
'
SUB Init_g_customColors
'
' 0.6.0.2-old---
'	FOR i = 0 TO 15
'		g_customColors[i] = $$White
'	NEXT i
' 0.6.0.2-old===
' 0.6.0.2-new+++
	INC	i	:	g_customColors[i]	=	$$LightBlue			-	RGB	(0,	0,	50)		'	less	Blue	=>	lighter
	INC	i	:	g_customColors[i]	=	$$MediumBlue		-	RGB	(0,	0,	50)		'	less	Blue	=>	lighter

	INC	i	:	g_customColors[i]	=	$$MediumGreen		-	RGB	(0,	50,	0)		'	less	Green	=>	lighter
	INC	i	:	g_customColors[i]	=	$$MediumCyan		-	RGB	(0,	50,	0)		'	less	Green	=>	lighter

	INC	i	:	g_customColors[i]	=	$$MediumRed			-	RGB	(50,	0,	0)	'	less	Red		=>	lighter
	INC	i	:	g_customColors[i]	=	$$MediumMagenta	-	RGB	(50,	0,	0)	'	less	Red		=>	lighter

	INC	i	:	g_customColors[i]	=	$$BrightYellow	-	RGB	(50,	50,	0)	'	less	Blue	and	Green			=>	lighter
	INC	i	:	g_customColors[i]	=	$$MediumGrey		-	RGB	(50,	50,	50)	'	less	Blue,	Green	and	Red	=>	lighter
	INC	i	:	g_customColors[i]	=	$$MediumSteel		-	RGB	(50,	50,	50)	'	less	Blue,	Green	and	Red	=>	lighter

	INC	i	:	g_customColors[i]	=	$$BrightOrange	-	RGB	(50,	0,	0)	'	less	Red	=>	lighter
	INC	i	:	g_customColors[i]	=	$$Aqua
	INC	i	:	g_customColors[i]	=	$$MediumViolet	-	RGB	(50,	0,	50)	'	less	Blue	and	Red	=>	lighter
	INC	i	:	g_customColors[i]	=	$$Violet				-	RGB	(50,	0,	50)	'	less	Blue	and	Red	=>	lighter
	INC	i	:	g_customColors[i]	=	$$DarkViolet		-	RGB	(50,	0,	50)	'	less	Blue	and	Red	=>	lighter
' 0.6.0.2-new===
'
END SUB

END FUNCTION
'
' ####################################
' #####  WinXDraw_GetFontDialog  #####
' ####################################
' Displays the get font dialog box.
' hOwner = the owner of the dialog
' r_font = the LOGFONT structure to initialize the dialog and store the output
' r_codeRGB = the color of the returned font,
'             eventualy used as initial text color.
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXDraw_GetFontDialog (hOwner, LOGFONT r_font, @r_codeRGB)
	CHOOSEFONT fontPicker
	XLONG ret				' win32 api return value (0 for fail)
	XLONG bOK				' $$TRUE for success

	SetLastError (0)
	bOK = $$FALSE

	' set initial text color
	fontPicker.rgbColors = r_codeRGB

	' $$Black = 0, $$White = RGB (0xFF, 0xFF, 0xFF)
	IF fontPicker.rgbColors > $$White THEN
		' invalid RGB color
		fontPicker.rgbColors = $$White
	ENDIF

	fontPicker.hInstance = GetModuleHandleA (0)
	fontPicker.lpLogFont = &r_font		' logical font structure
'
' - $$CF_EFFECTS            : allows to select strikeout, underline, and color options
' - $$CF_SCREENFONTS        : causes dialog to show up
' - $$CF_INITTOLOGFONTSTRUCT: initial settings shows up when the dialog appears
'
	fontPicker.flags = $$CF_EFFECTS OR $$CF_SCREENFONTS OR $$CF_INITTOLOGFONTSTRUCT

	IFZ hOwner THEN
		fontPicker.hwndOwner = GetActiveWindow ()
	ELSE
		fontPicker.hwndOwner = hOwner
	ENDIF
	fontPicker.lStructSize = SIZE(CHOOSEFONT)
'
' -------------------------------------------------------------------
' create a Font dialog box that enables the User to choose attributes
' for a logical font; these attributes include a typeface name, style
' (bold, italic, or regular), point size, effects (underline,
' strikeout, and text color), and a script (or character set)
' -------------------------------------------------------------------
'
	r_codeRGB = 0
	SetLastError (0)
	ret = ChooseFontA (&fontPicker)
	IFZ ret THEN
		caption$ = "WinXDraw_GetFontDialog: Windows' Font Picker Error"
		GuiTellDialogError (hOwner, caption$)
	ELSE
		fontName$ = TRIM$(r_font.faceName)
		IF fontName$ THEN
			' returned font's height
			'r_font.height = ABS (r_font.height)
			IF r_font.height < 0 THEN
				r_font.height = - r_font.height
			ENDIF
			r_codeRGB = fontPicker.rgbColors		' returned text color
		ENDIF
		bOK = $$TRUE
	ENDIF

	RETURN bOK

END FUNCTION
'
' ####################################
' #####  WinXDraw_GetFontHeight  #####
' ####################################
' Gets the height of a specified font.
FUNCTION WinXDraw_GetFontHeight (hFont, @ascent, @descent)
	TEXTMETRIC tm
	XLONG hDC		' the handle of the compatible context

	ascent = 0
	descent = 0

	SetLastError (0)
	IFZ hFont THEN RETURN 0		' fail

	hDC = CreateCompatibleDC (0)
	IFZ hDC THEN RETURN 0		' fail

	SelectObject (hDC, hFont)
	GetTextMetricsA (hDC, &tm)
	DeleteDC (hDC)
	hDC = 0

	ascent = tm.ascent
	descent = tm.descent
	RETURN tm.height

END FUNCTION
'
' ######################################
' #####  WinXDraw_GetImageChannel  #####
' ######################################
' Retrieves on of the channels of a WinX image.
' hImage =  the handle of the image
' channel = the channel if, 0 for blue, 1 for green, 2 for red, 3 for alpha
' data[] =  the UBYTE array to store the channel data
' returns $$TRUE on success, dimensions data[] appropriately;
'      or $$FALSE on fail
FUNCTION WinXDraw_GetImageChannel (hImage, channel, UBYTE data[])
	BITMAP bitmap		' BITMAP structure
	ULONG pixel
	ULONG ulong_val

	ULONG downshift
	XLONG i				' running index
	XLONG iMax		' upper index

	IF channel < 0 || channel > 3 THEN RETURN $$FALSE
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bitmap) THEN RETURN $$FALSE

	downshift = channel << 3

	iMax = (bitmap.width * bitmap.height) - 1
	DIM data[iMax]
	FOR i = 0 TO iMax
		ulong_val = i << 2
		pixel = ULONGAT(bitmap.bits, ulong_val)
		data[i] = UBYTE ((pixel >> downshift) AND 0x000000FF)
	NEXT i

	RETURN $$TRUE

END FUNCTION
'
' ###################################
' #####  WinXDraw_GetImageInfo  #####
' ###################################
' Gets information about an image.
' hImage = the handle of the image to get info on
' w, h = the width and height of the image
' pBits = the pointer to the bits.  They are arranged row first with the last row at the top of the file
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXDraw_GetImageInfo (hImage, @w, @h, @pBits)
	BITMAP bitmap		' BITMAP structure
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bitmap) THEN RETURN $$FALSE

	w = bitmap.width
	h = bitmap.height
	pBits = bitmap.bits
	RETURN $$TRUE
END FUNCTION
'
' ####################################
' #####  WinXDraw_GetImagePixel  #####
' ####################################
' Gets a pixel on WinX image.
' hImage =  the handle of the image
' x, y = the x and y coordinates of the pixel
' returns the RGBA color at the point: pointRGBA
FUNCTION RGBA WinXDraw_GetImagePixel (hImage, x, y)
	BITMAP bitmap		' BITMAP structure
	RGBA pointRGBA		' (empty on enter)

	IF hImage THEN
		IF GetObjectA (hImage, SIZE(BITMAP), &bitmap) THEN
			IF (x >= 0) && (x < bitmap.width) && (y >= 0) && (y < bitmap.height) THEN
				ULONGAT(&pointRGBA) = ULONGAT(bitmap.bits, ((bitmap.height - 1 - y) * bitmap.width + x) << 2)
			ENDIF
		ENDIF
	ENDIF

	RETURN pointRGBA

END FUNCTION
'
' ###################################
' #####  WinXDraw_GetTextWidth  #####
' ###################################
' Gets the width of a string using a specified font.
' hFont = the font to use
'  (0 for the default font)
' text = the string to get the length for
' maxWidth = the maximum width available for the text,
'            set to -1 if there is no maximum width
'
' returns the width of the text in pixels, or the number of characters in the string that can be displayed
' at a max width of maxWidth if the width of the text exceeds maxWidth.
' If maxWidth is exceeded the return is < 0.
FUNCTION WinXDraw_GetTextWidth (hFont, STRING text, maxWidth)

	XLONG hDC					' the handle of the context
	SIZEAPI size
	XLONG fit				' LEN (text) <= fit
	XLONG text_width			' width of the text in pixels

	text_width = 0

	IFZ hFont THEN
		hFont = GetStockObject ($$DEFAULT_GUI_FONT)
	ENDIF

	SetLastError (0)
	hDC = CreateCompatibleDC (0)
	IFZ hDC THEN
		msg$ = "WinX-WinXDraw_GetTextWidth: Can't create compatible DC"
		GuiTellApiError (@msg$)
	ELSE
		SelectObject (hDC, hFont)
		GetTextExtentExPointA (hDC, &text, LEN(text), maxWidth, &fit, 0, &size)
		DeleteDC (hDC)
		hDC = 0

		' maxWidth = -1 => no maximum text_width
		IF (maxWidth = -1) || (fit >= LEN (text)) THEN
			text_width = size.cx
'			msg$ = "WinX-WinXDraw_GetTextWidth: size.cx = " + STR$ (size.cx)
		ELSE
			text_width = -fit
'
' (GL: Had to see fit with my own eyes
' to accept -fit as valid)
'
'			msg$ = "WinX-WinXDraw_GetTextWidth: -fit = " + STR$ (-fit)
		ENDIF
'		WinXDialog_Error (@msg$, @"WinX-Debug", 0)
	ENDIF

	RETURN text_width

END FUNCTION
'
' ################################
' #####  WinXDraw_LoadImage  #####
' ################################
' Loads an image from disk.
' fileName = the name of the file
' fileType = the type of file
' returns the handle of the image, or 0 on fail
FUNCTION WinXDraw_LoadImage (STRING fileName, fileType)
	XLONG hBmpRet		' the handle of the image
	BITMAPINFOHEADER bmih
	BITMAPFILEHEADER bmfh
	BITMAP bitmap		' BITMAP structure

	XLONG hBmpTmp		' the handle of the bitmap

	XLONG hSrc			' = CreateCompatibleDC (0)
	XLONG hOldSrc		' = SelectObject (hSrc, hBmpTmp)

	XLONG hDst			' = CreateCompatibleDC (0)
	XLONG hOldDst		' = SelectObject (hDst, hBitmap)

	hBmpRet = 0

	SetLastError (0)
	SELECT CASE fileType
		CASE $$FILETYPE_WINBMP
			IFZ fileName THEN EXIT SELECT		' fail

			' first, load the bitmap
			hBmpTmp = LoadImageA (0, &fileName, $$IMAGE_BITMAP, 0, 0, $$LR_DEFAULTCOLOR OR $$LR_CREATEDIBSECTION OR $$LR_LOADFROMFILE)

			'now copy it to a standard format
			GetObjectA (hBmpTmp, SIZE(BITMAP), &bitmap)
			hBmpRet = WinXDraw_CreateImage (bitmap.width, bitmap.height)
			IFZ hBmpRet THEN EXIT SELECT		' fail

			hSrc = CreateCompatibleDC (0)
			hDst = CreateCompatibleDC (0)
			hOldSrc = SelectObject (hSrc, hBmpTmp)
			hOldDst = SelectObject (hDst, hBmpRet)
			BitBlt (hDst, 0, 0, bitmap.width, bitmap.height, hSrc, 0, 0, $$SRCCOPY)
			SelectObject (hSrc, hOldSrc)
			SelectObject (hDst, hOldDst)
			DeleteDC (hDst)
			DeleteDC (hSrc)
			DeleteObject (hBmpTmp)

	END SELECT

	RETURN hBmpRet
END FUNCTION
'
' ##################################
' #####  WinXDraw_MakeLogFont  #####
' ##################################
' Creates a new logical font structure, which can be used to create a real font.
' font = the name of the font to use
' height = the height of the font in pixels
' flags = a set of flags describing the style of the font
' returns the logical font
FUNCTION LOGFONT WinXDraw_MakeLogFont (STRING font, height, flags)
	LOGFONT r_font		' returned logical font

	SetLastError (0)

	r_font.height = height
	r_font.width = 0

	IF flags AND $$FONT_BOLD THEN
		r_font.weight = $$FW_BOLD
	ELSE
		r_font.weight = $$FW_NORMAL
	ENDIF

	IF flags AND $$FONT_ITALIC    THEN r_font.italic    = 1 ELSE r_font.italic    = 0
	IF flags AND $$FONT_UNDERLINE THEN r_font.underline = 1 ELSE r_font.underline = 0
	IF flags AND $$FONT_STRIKEOUT THEN r_font.strikeOut = 1 ELSE r_font.strikeOut = 0

	r_font.charSet = $$DEFAULT_CHARSET
	r_font.outPrecision = $$OUT_DEFAULT_PRECIS
	r_font.clipPrecision = $$CLIP_DEFAULT_PRECIS
	r_font.quality = $$DEFAULT_QUALITY
	r_font.pitchAndFamily = $$DEFAULT_PITCH OR $$FF_DONTCARE

	' ensure a nul-terminated font name
	r_font.faceName = LEFT$ (font, SIZE(r_font.faceName)-1)

	RETURN r_font

END FUNCTION
'
' #####################################
' #####  WinXDraw_PixelsPerPoint  #####
' #####################################
' Gets the conversion factor between screen pixels
' and points.
FUNCTION DOUBLE WinXDraw_PixelsPerPoint ()

	DOUBLE pointHeight
	XLONG hDC		' the handle of the Desktop context

	SetLastError (0)
	pointHeight = 0

	hDC = GetDC (GetDesktopWindow ())		'  GetDC requires ReleaseDC
	IF hDC THEN
		pointHeight = DOUBLE (GetDeviceCaps (hDC, $$LOGPIXELSY)) / 72.0
		ReleaseDC (GetDesktopWindow (), hDC)		'  release Device Context hDC
	ENDIF

	RETURN pointHeight

END FUNCTION
'
' #######################################
' #####  WinXDraw_PremultiplyImage  #####
' #######################################
' Pre-multiplies an image with its alpha channel
' in preparation for alpha blending.
' hImage =  the image to pre-multiply
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXDraw_PremultiplyImage (hImage)
	BITMAP bitmap		' BITMAP structure
	RGBA rgba
	ULONG ulong_val

	XLONG i				' running index
	XLONG maxPixel		' upper index

	IFZ GetObjectA (hImage, SIZE(BITMAP), &bitmap) RETURN $$FALSE

	maxPixel = (bitmap.width * bitmap.height) - 1
	FOR i = 0 TO maxPixel
		'get pixel
		ulong_val = i << 2
		ULONGAT(&rgba) = ULONGAT(bitmap.bits, ulong_val)

		rgba.blue  = UBYTE ((XLONG (rgba.blue)  * XLONG (rgba.alpha)) \ 255)
		rgba.green = UBYTE ((XLONG (rgba.green) * XLONG (rgba.alpha)) \ 255)
		rgba.red   = UBYTE ((XLONG (rgba.red)   * XLONG (rgba.alpha)) \ 255)

		ULONGAT(bitmap.bits, ulong_val) = ULONGAT(&rgba)
	NEXT i

	RETURN $$TRUE

END FUNCTION
'
' ###################################
' #####  WinXDraw_ResizeBitmap  #####
' ###################################
' Resize an image cleanly using bicubic interpolation
' hImage = the handle of the source image
' w, h = the width and height for the new image
' returns the handle of the resized image, or 0 on fail
FUNCTION WinXDraw_ResizeImage (hImage, w, h)
	XLONG hBmpRet		' the handle of the resized image
	BITMAP bmpSrc		' BITMAP structure source
	XLONG hdcSrc		' the handle of the source context
	XLONG hOldSrc		' = SelectObject (hdcSrc, hImage)

	BITMAP bmpDst		' BITMAP structure destination
	XLONG hdcDest		' the handle of the destination context
	XLONG hOldDest	' = SelectObject (hdcDest, hBitmap)

	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmpSrc) THEN RETURN 0
	hBmpRet = WinXDraw_CreateImage (w, h)
	IFZ hBmpRet THEN RETURN 0		' fail
	IFZ GetObjectA (hBmpRet, SIZE(BITMAP), &bmpDst) THEN RETURN 0

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

	RETURN hBmpRet

END FUNCTION
'
' #################################
' #####  WinXDraw_SaveBitmap  #####
' #################################
' Saves an image to a file on disk.
' hImage = the image to save
' fileName = the name for the file
' fileType =  the format in which to save the file
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXDraw_SaveImage (hImage, STRING fileName, fileType)
	BITMAPINFOHEADER bmih
	BITMAPFILEHEADER bmfh
	BITMAP bitmap		' BITMAP structure
	XLONG fileNumber		' file handle

	SELECT CASE fileType
		CASE $$FILETYPE_WINBMP
			IFZ GetObjectA (hImage, SIZE(BITMAP), &bitmap) THEN RETURN $$FALSE
			fileNumber = OPEN (fileName, $$WRNEW)
			IF fileNumber < 0 THEN RETURN $$FALSE

			bmfh.bfType = 0x4D42
			bmfh.bfSize = SIZE(BITMAPFILEHEADER) + SIZE(BITMAPINFOHEADER) + (bitmap.widthBytes * bitmap.height)
			bmfh.bfOffBits = SIZE(BITMAPFILEHEADER) + SIZE(BITMAPINFOHEADER)

			bmih.biSize = SIZE(BITMAPINFOHEADER)
			bmih.biWidth = bitmap.width
			bmih.biHeight = bitmap.height
			bmih.biPlanes = bitmap.planes
			bmih.biBitCount = bitmap.bitsPixel
			bmih.biCompression = $$BI_RGB

			WRITE[fileNumber], bmfh
			WRITE[fileNumber], bmih
			XstBinWrite (fileNumber, bitmap.bits, bitmap.widthBytes * bitmap.height)
			CLOSE (fileNumber)

			RETURN $$TRUE		' success
	END SELECT

	RETURN $$FALSE

END FUNCTION
'
' #######################################
' #####  WinXDraw_SetConstantAlpha  #####
' #######################################
' Sets the transparency of an image to a constant value.
' hImage = the handle of the image
' alpha = the constant alpha
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXDraw_SetConstantAlpha (hImage, DOUBLE alpha)
	BITMAP bitmap		' BITMAP structure
	ULONG ulong_Alpha
	ULONG ulong_val

	XLONG i				' running index
	XLONG maxPixel		' upper index

	IF alpha < 0 || alpha > 1 THEN RETURN $$FALSE
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bitmap) THEN RETURN $$FALSE

	ulong_Alpha = ULONG (alpha * 255.0) << 24

	maxPixel = bitmap.width * bitmap.height - 1
	FOR i = 0 TO maxPixel
		ulong_val = i << 2
		ULONGAT(bitmap.bits, ulong_val) = (ULONGAT(bitmap.bits, ulong_val) AND 0x00FFFFFFFF) OR ulong_Alpha
	NEXT i

	RETURN $$TRUE

END FUNCTION
'
' ######################################
' #####  WinXDraw_SetImageChannel  #####
' ######################################
' Sets one of the channels of a WinX image.
' hImage = the handle of the image
' channel = the channel id, 0 for blue, 1 for green, 2 for red, 3 for alpha
' data[] = the channel data, a single dimensional UBYTE array containing the channel data
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXDraw_SetImageChannel (hImage, channel, UBYTE data[])
	BITMAP bitmap		' BITMAP structure
	ULONG ulong_val
	ULONG upshift
	XLONG mask
	XLONG bOK		' $$TRUE for success

	XLONG i				' running index
	XLONG maxPixel		' upper index

	bOK = $$FALSE

	SELECT CASE channel
		CASE 0, 1, 2, 3
			IFZ GetObjectA (hImage, SIZE(BITMAP), &bitmap) THEN RETURN $$FALSE

			upshift = channel << 3
			mask = NOT (255 << upshift)

			maxPixel = (bitmap.width * bitmap.height) - 1
			IF maxPixel <> UBOUND(data[]) THEN RETURN $$FALSE

			FOR i = 0 TO maxPixel
				ulong_val = i << 2
				ULONGAT(bitmap.bits, ulong_val) = (ULONGAT(bitmap.bits, ulong_val) AND mask) OR ULONG (data[i]) << upshift
			NEXT i

			bOK = $$TRUE

	END SELECT

	RETURN bOK

END FUNCTION
'
' ####################################
' #####  WinXDraw_SetImagePixel  #####
' ####################################
' Sets a pixel on a WinX image.
' hImage = the handle of the image
' x, y = the coordinates of the pixel
' codeRGB = the color for the pixel
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXDraw_SetImagePixel (hImage, x, y, codeRGB)
	BITMAP bitmap		' BITMAP structure

	IFZ GetObjectA (hImage, SIZE(BITMAP), &bitmap) THEN RETURN $$FALSE
	IF x < 0 || x >= bitmap.width || y < 0 || y >= bitmap.height THEN RETURN $$FALSE
	ULONGAT(bitmap.bits, ((bitmap.height - 1 - y) * bitmap.width + x) << 2) = codeRGB

	RETURN $$TRUE		' success

END FUNCTION
'
' ###############################
' #####  WinXDraw_Snapshot  #####
' ###############################
' Takes a snapshot of a WinX window and stores the result in an image.
' hWnd = the window to photograph
' x, y = the x and y coordinates of the upper left hand corner of the picture
' hImage = the image to store the result
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXDraw_Snapshot (hWnd, x, y, hImage)
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG hDC					' the handle of the compatible context
	XLONG hOld				' = SelectObject (hDC, hImage)

	SetLastError (0)
	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	hDC = CreateCompatibleDC (0)
	hOld = SelectObject (hDC, hImage)
	autoDraw_draw(hDC, binding.autoDrawInfo, x, y)
	SelectObject (hDC, hOld)
	DeleteDC (hDC)

	RETURN $$TRUE		' success

END FUNCTION
'
' ###########################
' #####  WinXDraw_Undo  #####
' ###########################
' Undoes a drawing operation.
' idDraw = the id of the operation
' returns $$TRUE on success, or $$FALSE on fail
' Note: Legacy wrapper to WinXUndo ().
FUNCTION WinXDraw_Undo (hWnd, idDraw)
	RETURN WinXUndo (hWnd, idDraw)
END FUNCTION
'
' #######################################
' #####  WinXEnableDialogInterface  #####
' #######################################
' Enables or disables the dialog interface.
' hWnd = the handle of the window to enable or disable the dialog interface for
' enable = $$TRUE to enable the dialog interface, otherwise $$FALSE
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXEnableDialogInterface (hWnd, enable)
	BINDING			binding
	XLONG		idBinding		' binding id

	SetLastError (0)

	'get the binding
	IF Get_the_binding (hWnd, @idBinding, @binding) THEN
		IF enable THEN
			binding.useDialogInterface = $$TRUE
		ELSE
			binding.useDialogInterface = $$FALSE
		ENDIF
'
'		IF binding.useDialogInterface THEN
'			' enable dialog interface => set $$WS_POPUPWINDOW
'			WinXSetStyle (hWnd, $$WS_POPUPWINDOW, 0, $$WS_OVERLAPPED, 0)
'		ELSE
'			' disable dialog interface => set $$WS_OVERLAPPED
'			WinXSetStyle (hWnd, $$WS_OVERLAPPED, 0, $$WS_POPUPWINDOW, 0)
'		ENDIF
'
		RETURN binding_update (idBinding, binding)
	ENDIF

END FUNCTION
'
' #############################
' #####  WinXGetMousePos  #####
' #############################
' Gets the mouse position.
' hWnd = the handle of the window to get the coordinates relative to, 0 for the active window
' x = the variable to store the mouse x position
' y = the variable to store the mouse y position
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXGetMousePos (hWnd, @x, @y)
	POINT pt
	x = 0
	y = 0
'
' 0.6.0.2-new+++
	IFZ hWnd THEN
		hWnd = GetActiveWindow ()
	ENDIF
' 0.6.0.2-new===
'
	GetCursorPos (&pt)
	IF hWnd THEN ScreenToClient (hWnd, &pt)
	x = pt.x : y = pt.y
	RETURN $$TRUE

END FUNCTION
'
' ##############################
' #####  WinXGetPlacement  #####
' ##############################
' Gets the window placement.
' hWnd = the handle of the window
' minMax = the variable to store the minimised/maximised state
' restored = the variable to store the restored position and size
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXGetPlacement (hWnd, @minMax, RECT restored)
	WINDOWPLACEMENT wp

	wp.length = SIZE(WINDOWPLACEMENT)
	IFZ GetWindowPlacement (hWnd, &wp) THEN RETURN $$FALSE

	restored = wp.rcNormalPosition
	minMax = wp.showCmd

	RETURN $$TRUE

END FUNCTION
'
' ##########################
' #####  WinXGetText$  #####
' ##########################
' Gets the text from a window or a control.
' hWnd = the handle of the window/control
' returns a string containing the text
FUNCTION WinXGetText$ (hWnd)
	XLONG cChar		' character count
'
' TRICKY! nMaxCount holds the maximum number
' of characters to copy to the buffer,
' including the nul terminator.
'
	XLONG nMaxCount

	cChar = GetWindowTextLengthA (hWnd)

	nMaxCount = cChar + 1
	szBuf$ = NULL$ (nMaxCount)
	GetWindowTextA (hWnd, &szBuf$, nMaxCount)
	RETURN CSTRING$(&szBuf$)

END FUNCTION
'
' ################################
' #####  WinXGetUseableRect  #####
' ################################
' Gets a rect describing the usable protion of a window's client area,
' that is, the portion not obscured with a toolbar or status bar.
' hWnd = the handle of the window to get the rect for
' rectUseable = the variable to hold the RECT structure
' returns $$TRUE on success, or $$FALSE on fail
' ------------------------------------------------------------
' In conformance with conventions for the RECT structure, the
' bottom-right coordinates of the returned rectangle are
' exclusive. In other words, the pixel at (right, bottom) lies
' immediately outside the rectangle.
' ------------------------------------------------------------
'
' eg bOK = WinXGetUseableRect (hWnd, @rect)
'
FUNCTION WinXGetUseableRect (hWnd, RECT rectUseable)
	BINDING			binding
	XLONG		idBinding		' binding id
	RECT client_rect

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	GetClientRect (hWnd, &rectUseable)
	IF binding.hBar THEN
		GetClientRect (binding.hBar, &client_rect)
		rectUseable.top = rectUseable.top + (client_rect.bottom - client_rect.top) + 2
	ENDIF

	IF binding.hStatus THEN
		GetClientRect (binding.hStatus, &client_rect)
		rectUseable.bottom = rectUseable.bottom - (client_rect.bottom - client_rect.top)
	ENDIF

	RETURN $$TRUE

END FUNCTION
'
' #############################################
' #####  WinXGroupBox_GetAutosizerSeries  #####
' #############################################
' Gets the auto-sizer series for a group box.
' hGB = the handle of the group box
' returns the group box's series, or -1 on fail
'
' Usage:
'	group_series = WinXGroupBox_GetAutosizerSeries (#myGroup)
'
FUNCTION WinXGroupBox_GetAutosizerSeries (hGB)
	XLONG group_series		' the group box's series

	group_series = -1		' Not A Series

	SetLastError (0)
	IF hGB THEN
		group_series = GetPropA (hGB, &"WinXAutoSizerSeries")
		IF group_series < 1 THEN
			' The main series = 0 => group_series is at least = 1.
			group_series = -1		' fail
		ENDIF
	ENDIF

	RETURN group_series

END FUNCTION
'
' ######################
' #####  WinXHide  #####
' ######################
' Hides a window or a control.
' hWnd = the handle of the control or window to hide
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXHide (hWnd)
	XLONG ret				' win32 api return value (0 for fail)

	SetLastError (0)
	IF hWnd THEN
		ret = ShowWindow (hWnd, $$SW_HIDE)
		IF ret THEN
			RETURN $$TRUE		' success
		ELSE
			msg$ = "WinX-WinXHide: Can't hide the window"
			GuiTellApiError (@msg$)
		ENDIF
	ENDIF

END FUNCTION
'
' ###########################
' #####  WinXIsKeyDown  #####
' ###########################
' Checks to see if a key is pressed.
' key = the ascii code of the key or a virt_key code for special keys
' returns $$TRUE if the key is pressed or $$FALSE if it is not
FUNCTION WinXIsKeyDown (key)
'
' Have to check the high order bit, and since GetKeyState() returns a short,
' that might not be where you expected it.
'
	SetLastError (0)
	IF key THEN
		IF GetKeyState (key) AND 0x8000 THEN
			RETURN $$TRUE		' a key was pressed
		ENDIF
	ENDIF
END FUNCTION
'
' ################################
' #####  WinXIsMousePressed  #####
' ################################
' Checks to see if a mouse button is pressed.
' button = a MBT constant
' returns $$TRUE if the button is pressed, $$FALSE if it is not
FUNCTION WinXIsMousePressed (button)
	XLONG virt_key		' virtual key

	SetLastError (0)
	virt_key = 0

	'we need to take into account the possibility that the mouse buttons are swapped
	IF GetSystemMetrics ($$SM_SWAPBUTTON) THEN
		' the mouse buttons are swapped
		SELECT CASE button
			CASE $$MBT_LEFT   : virt_key = $$VK_RBUTTON
			CASE $$MBT_MIDDLE : virt_key = $$VK_MBUTTON
			CASE $$MBT_RIGHT  : virt_key = $$VK_LBUTTON
		END SELECT
	ELSE
		SELECT CASE button
			CASE $$MBT_LEFT   : virt_key = $$VK_LBUTTON
			CASE $$MBT_MIDDLE : virt_key = $$VK_MBUTTON
			CASE $$MBT_RIGHT  : virt_key = $$VK_RBUTTON
		END SELECT
	ENDIF

	IF virt_key THEN
		IF GetAsyncKeyState (virt_key) THEN
			RETURN $$TRUE		' the button is pressed
		ENDIF
	ENDIF

END FUNCTION
'
' ##########################
' #####  WinXKillFont  #####
' ##########################
'
' Releases a logical font.
' r_hFont = handle to the logical font, reset on deletion.
' returns bOK: $$TRUE on success
'
FUNCTION WinXKillFont (@r_hFont)

	SHARED hFontDefault		' current program default font

	SetLastError (0)

	IF r_hFont THEN
		IF r_hFont <> hFontDefault THEN
			' avoid deleting the standard font
			DeleteObject (r_hFont)		' free memory space
		ENDIF
	ELSE
		msg$ = "WinX-WinXKillFont: Ignore a NULL font handle"
		WinXDialog_Error (msg$, "WinX-Debug", 0)		' information
		RETURN		' fail
	ENDIF

	r_hFont = 0
	RETURN $$TRUE		' OK!

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
	XLONG style
	XLONG wMsg
	XLONG after

	SetLastError (0)
	IFZ hListBox THEN RETURN $$LB_ERR		' fail

	style = GetWindowLongA (hListBox, $$GWL_STYLE)
	IF style AND $$LBS_SORT THEN
		wMsg = $$LB_ADDSTRING
		after = 0		' last
	ELSE
		wMsg = $$LB_INSERTSTRING
		after = index
	ENDIF
	RETURN SendMessageA (hListBox, wMsg, after, &Item$)

END FUNCTION
'
' ########################################
' #####  WinXListBox_EnableDragging  #####
' ########################################
' Enables dragging on a list box;
' make sure to register the onDrag callback as well.
' hListBox = the handle of the list box to enable dragging on
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXListBox_EnableDragging (hListBox)
	SHARED DLM_MESSAGE

	SetLastError (0)
	IF hListBox THEN
		IF MakeDragList (hListBox) THEN
			DLM_MESSAGE = RegisterWindowMessageA (&$$DRAGLISTMSGSTRING)
			RETURN $$TRUE
		ENDIF
	ENDIF
END FUNCTION
'
' ##################################
' #####  WinXListBox_GetIndex  #####
' ##################################
' Gets the index of a particular string.
' hListBox = the handle of the list box containing the string
' Item$ = the string to search for
' returns the index of the item, or -1 on fail
FUNCTION WinXListBox_GetIndex (hListBox, Item$)
	XLONG pos				' running position

	pos = -1

	DO
		pos = SendMessageA (hListBox, $$LB_FINDSTRING, pos, &Item$)
		IF pos = $$LB_ERR THEN RETURN -1
	LOOP WHILE SendMessageA (hListBox, $$LB_GETTEXTLEN, pos, 0) > LEN (Item$)

	RETURN pos
END FUNCTION
'
' ##################################
' #####  WinXListBox_GetItem$  #####
' ##################################
' Gets a list box item.
' hListBox = the handle of the list box to get the item from
' index = the index of the item to get
' returns the string of the item, or an empty string on fail
FUNCTION WinXListBox_GetItem$ (hListBox, index)
	IFZ hListBox THEN RETURN ""		' fail
	szBuf$ = NULL$ (SendMessageA (hListBox, $$LB_GETTEXTLEN, index, 0) + 2)

	SendMessageA (hListBox, $$LB_GETTEXT, index, &szBuf$)

	RETURN CSTRING$(&szBuf$)
END FUNCTION
'
' ###########################################
' #####  WinXListBox_GetSelectionArray  #####
' ###########################################
' Gets the selected items in a list box.
' hListBox = the list box to get the items from
' indexList[] = the array in which to store the indecies of selected items
' returns the number of selected items, 0 on fail
FUNCTION WinXListBox_GetSelectionArray (hListBox, indexList[])
	XLONG select_count		' the number of selected items
	XLONG index

	select_count = 0

	SELECT CASE hListBox
		CASE 0		' fail

		CASE ELSE
			IF GetWindowLongA (hListBox, $$GWL_STYLE) AND $$LBS_EXTENDEDSEL THEN
				' multiple selections
				select_count = SendMessageA (hListBox, $$LB_GETSELCOUNT, 0, 0)
				IFZ select_count THEN EXIT SELECT		' fail

				DIM indexList[select_count - 1]
				SendMessageA (hListBox, $$LB_GETSELITEMS, select_count, &indexList[0])
			ELSE
				' single selection
				index = SendMessageA (hListBox, $$LB_GETCURSEL, 0, 0)
				IF index = $$LB_ERR THEN EXIT SELECT		' fail

				select_count = 1
				DIM indexList[0]
				indexList[0] = index
			ENDIF

	END SELECT

	IFZ select_count THEN
		' empty the index list
		DIM indexList[]
	ENDIF
	RETURN select_count

END FUNCTION
'
' ####################################
' #####  WinXListBox_RemoveItem  #####
' ####################################
' Removes an item from a list box.
' hListBox = the list box to remove from
' index = the index of the item to remove, -1 to remove the last item
' returns the number of strings remaining in the list or $$LB_ERR if index is out of range.
'
' Usage:
'	ret = WinXListBox_RemoveItem (hListBox, index)
'	IF ret < 0 THEN
'		msg$ = "WinXListBox_RemoveItem: Can't remove item at index " + STRING$ (index)
'		GuiTellApiError (@msg$)
'	ENDIF
'
FUNCTION WinXListBox_RemoveItem (hListBox, index)
	IFZ hListBox THEN RETURN $$LB_ERR		' fail
	IF index < 0 THEN index = SendMessageA (hListBox, $$LB_GETCOUNT, 0, 0) - 1
	RETURN SendMessageA (hListBox, $$LB_DELETESTRING, index, 0)
END FUNCTION
'
' ##################################
' #####  WinXListBox_SetCaret  #####
' ##################################
' Sets the caret item for a list box.
' hListBox = the handle of the list box to set the caret for
' item = the item to move the caret to
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXListBox_SetCaret (hListBox, item)
	IFZ hListBox THEN RETURN $$FALSE		' fail
	IF SendMessageA (hListBox, $$LB_SETCARETINDEX, item, $$FALSE) = $$LB_ERR THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ###########################################
' #####  WinXListBox_SetSelectionArray  #####
' ###########################################
' Sets the selection on a list box
' hListBox = the handle of the list box to set the selection for
' indexList[] = an array of item indexes to select
' returns $$TRUE on success, or $$FALSE on fail
'
' Usage:
'	' select the first item (index = 0)
'	DIM indexList[0]
'	WinXListBox_SetSelectionArray (#dlgMRU_lstMRU, @indexList[])
'
FUNCTION WinXListBox_SetSelectionArray (hListBox, indexList[])
	XLONG bErr		' $$TRUE for error
	XLONG i				' running index

	IFZ hListBox THEN RETURN $$FALSE		' fail
	IF GetWindowLongA (hListBox, $$GWL_STYLE) AND $$LBS_EXTENDEDSEL THEN
		' first, deselect everything
		SendMessageA (hListBox, $$LB_SETSEL, $$FALSE, -1)

		bErr = $$FALSE
		FOR i = 0 TO UBOUND(indexList[])
			IF SendMessageA (hListBox, $$LB_SETSEL, $$TRUE, indexList[i]) = $$LB_ERR THEN
				bErr = $$TRUE
			ENDIF
		NEXT i

		IF bErr THEN RETURN $$FALSE
	ELSE
		IFZ UBOUND(indexList[]) THEN
			IF (SendMessageA (hListBox, $$LB_SETCURSEL, indexList[0], 0) = -1) && (indexList[0] != -1) THEN
				RETURN $$FALSE		' fail
			ENDIF
		ELSE
			RETURN $$FALSE		' fail
		ENDIF
	ENDIF

	RETURN $$TRUE		' success

END FUNCTION
'
' ####################################
' #####  WinXListView_AddColumn  #####
' ####################################
' Adds a column to a list view for use in report view.
' iColumn = the zero-based index for the new column
' wColumn = the width of the column
' label = the label for the column
' numSubItem = the one-based subscript of the sub item the column displays
' returns the index to the column, or -1 on fail
FUNCTION WinXListView_AddColumn (hLV, iColumn, wColumn, STRING label, numSubItem)
	LV_COLUMN lvCol

	IFZ hLV THEN RETURN -1		' fail
	lvCol.mask = $$LVCF_FMT OR $$LVCF_ORDER OR $$LVCF_SUBITEM OR $$LVCF_TEXT OR $$LVCF_WIDTH
	lvCol.fmt = $$LVCFMT_LEFT
	lvCol.cx = wColumn
	lvCol.pszText = &label
	lvCol.iSubItem = numSubItem
	lvCol.iOrder = iColumn
	RETURN SendMessageA (hLV, $$LVM_INSERTCOLUMN, iColumn, &lvCol)
END FUNCTION
'
' ##################################
' #####  WinXListView_AddItem  #####
' ##################################
' Adds a new item to a list view.
' iItem = the index at which to insert the item, -1 to add to the end of the list
' list$ = the label for the main item plus the sub-items
'         as: "label\0subItem1\0subItem2...",
'         or: "label|subItem1|subItem2...".
' iIcon = the index to the icon/image, or -1 if this item has no icon
' returns the index of the new item, or -1 on fail
'
' Usage:
'	list$ = "Item 1 \0E \0A \05"
'	indexAdd = WinXListView_AddItem (hLV, -1, list$, -1)		' add last
'	IF indexAdd < 0 THEN
'		msg$ = "WinXListView_AddItem: Can't add listview item '" + list$ + "'"
'		GuiTellApiError (@msg$)
'	ENDIF
'
FUNCTION WinXListView_AddItem (hLV, iItem, list$, iIcon)

	LV_ITEM lvi

	XLONG r_index
	XLONG i
	XLONG upp
	XLONG count
	XLONG ret				' win32 api return value (0 for fail)

	SetLastError (0)
	r_index = -1		' not an index

	SELECT CASE hLV
		CASE 0

		CASE ELSE
			source$ = TRIM$(list$)
			IFZ source$ THEN EXIT SELECT

			' Replace all embedded zero-characters by separator "|".
			FOR i = LEN (source$) - 1 TO 0 STEP -1
				IFZ source${i} THEN source${i} = '|'
			NEXT i

			' Extract the values separated by | from source$
			' and place each of them in text$[].
			IFZ INSTR (source$, "|") THEN
				DIM text$[0]
				text$[0] = source$
			ELSE
				XstParseStringToStringArray (@source$, "|", @text$[])
			ENDIF

			' Set the listvew item.
			lvi.mask = $$LVIF_TEXT
			IF iIcon >= 0 THEN lvi.mask = lvi.mask OR $$LVIF_IMAGE

			count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
			IF iItem >= 0 && iItem < count THEN
				lvi.iItem = iItem
			ELSE
				lvi.iItem = count
			ENDIF

			' insert item and set the first sub-item
			lvi.iSubItem = 0
			lvi.pszText = &text$[0]
			lvi.iImage = iIcon

			SetLastError (0)
			r_index = SendMessageA (hLV, $$LVM_INSERTITEM, 0, &lvi)
			IF r_index < 0 THEN
				msg$ = "WinX-WinXListView_AddItem: Can't insert item '" + source$ + "', index = " + STRING$ (lvi.iItem)
				GuiTellApiError (@msg$)
				EXIT SELECT		' fail
			ENDIF

			' set the other sub-items
			upp = UBOUND(text$[])
			FOR i = 1 TO upp		' skip 1st listvew item
				lvi.mask = $$LVIF_TEXT
				lvi.iItem = r_index
				lvi.iSubItem = i
				lvi.pszText = &text$[i]
				SetLastError (0)
				ret = SendMessageA (hLV, $$LVM_SETITEM, 0, &lvi)
				IFZ ret THEN
					msg$ = "WinX-WinXListView_AddItem: Can't set sub-item" + STR$ (i) + ", value '" + text$[i] + "'"
					GuiTellApiError (@msg$)
				ENDIF
			NEXT i

	END SELECT

	RETURN r_index

END FUNCTION
'
' #######################################
' #####  WinXListView_DeleteColumn  #####
' #######################################
' Deletes a column in a list view.
' iColumn = the zero-based index of the column to delete
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXListView_DeleteColumn (hLV, iColumn)
	IFZ hLV THEN RETURN $$FALSE		' fail
	IF SendMessageA (hLV, $$LVM_DELETECOLUMN, iColumn, 0) THEN
		RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' #####################################
' #####  WinXListView_DeleteItem  #####
' #####################################
' Deletes an item from a list view.
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXListView_DeleteItem (hLV, iItem)
	IFZ hLV THEN RETURN $$FALSE		' fail
	IF SendMessageA (hLV, $$LVM_DELETEITEM, iItem, 0) THEN
		RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' ###########################################
' #####  WinXListView_GetItemFromPoint  #####
' ###########################################
' Gets a listview item given its coordinates.
' hLV = the list view control to get the item from
' x, y = the x and y coordinates to find the item at
' returns the index of the item, or -1 on fail
FUNCTION WinXListView_GetItemFromPoint (hLV, x, y)
	LVHITTESTINFO lvHit

	IFZ hLV THEN RETURN -1		' fail
	lvHit.pt.x = x
	lvHit.pt.y = y
	RETURN SendMessageA (hLV, $$LVM_HITTEST, 0, &lvHit)
END FUNCTION
'
' ######################################
' #####  WinXListView_GetItemText  #####
' ######################################
' Gets the text for a listview item.
' hLV = the handle of the list view control
' iItem = the zero-based index of the item
' cSubItems = the number of sub items to get
' text$[] = the array to store the result
' returns $$TRUE on success, or $$FALSE on fail
'
' Usage:
'	retrieve the first 2 columns of the 1st item
'	bOK = WinXListView_GetItemText (hLV, 0, 1, @aSubItem$[])
'
FUNCTION WinXListView_GetItemText (hLV, iItem, cSubItems, @text$[])
	LV_ITEM lvi		' listview item
	XLONG i				' running index

	DIM text$[cSubItems]
	FOR i = 0 TO cSubItems
		lvi.mask = $$LVIF_TEXT
		lvi.iItem = iItem
		lvi.iSubItem = i

		lvi.cchTextMax = 4095
		szBuf$ = NULL$ (lvi.cchTextMax)
		lvi.pszText = &szBuf$

		IFF SendMessageA (hLV, $$LVM_GETITEM, iItem, &lvi) THEN RETURN $$FALSE
		text$[i] = CSTRING$(&szBuf$)
	NEXT i

	RETURN $$TRUE

END FUNCTION
'
' ############################################
' #####  WinXListView_GetSelectionArray  #####
' ############################################
' Gets all the selected items in a list view control.
' hLV = the list view to get the items from
' indexList[] = the array in which to store the indecies of selected items
' returns the number of selected items, 0 on fail
'
' Usage:
'	select_count = WinXListView_GetSelectionArray (hLV, @indexList[])		' get the selected item(s)
'
FUNCTION WinXListView_GetSelectionArray (hLV, indexList[])
	XLONG select_count		' selected item count
	XLONG slot		' indexList[slot]

	XLONG i				' running index
	XLONG maxItem		' upper index

	select_count = 0

	SetLastError (0)
	SELECT CASE hLV
		CASE 0		' fail

		CASE ELSE
			select_count = SendMessageA (hLV, $$LVM_GETSELECTEDCOUNT, 0, 0)
			IF select_count <= 0 THEN EXIT SELECT		' fail

			DIM indexList[select_count - 1]
			maxItem = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0) - 1

			slot = 0
			'now iterate over all the items to locate the selected ones
			FOR i = 0 TO maxItem
				IF SendMessageA (hLV, $$LVM_GETITEMSTATE, i, $$LVIS_SELECTED) THEN
					indexList[slot] = i
					INC slot
				ENDIF
			NEXT i

	END SELECT

	IFZ select_count THEN
		' empty the index list
		DIM indexList[]
	ENDIF
	RETURN select_count

END FUNCTION
'
' ######################################
' #####  WinXListView_SetItemText  #####
' ######################################
' Sets new text for a listview item.
' iItem = the zero-based index of the item, numSubItem = 0 the one-based subscript of the sub-item or 0 if setting the main item
' returns $$TRUE on success, or $$FALSE on fail
'
' Usage:
'	bOK = WinXListView_SetItemText (hLV, iItem, 3, sub_text$)		' set new sub-item's text for an item
'	IFF bOK THEN		' fail
'		msg$ = "WinXListView_SetItemText: Can't set 4th sub-item's text for item at index " + STRING$ (iItem)
'		GuiTellApiError (msg$)
'	ENDIF
'
FUNCTION WinXListView_SetItemText (hLV, iItem, numSubItem, STRING newText)
	LV_ITEM lvi		' listview item
	XLONG ret			' win32 api return value (0 for fail)

	SetLastError (0)
	IFZ hLV THEN RETURN $$FALSE		' fail
	lvi.mask = $$LVIF_TEXT
	lvi.iItem = iItem
	IF numSubItem < 0 THEN
		lvi.iSubItem = 0		' first item
	ELSE
		lvi.iSubItem = numSubItem
	ENDIF
	lvi.pszText = &newText

	' set the sub-item's text for item at index iItem
	ret = SendMessageA (hLV, $$LVM_SETITEMTEXT, iItem, &lvi)
	IF ret THEN
		RETURN $$TRUE		' success
	ELSE
		msg$ = "WinX-WinXListView_SetItemText: Can't set the sub-item's text for item at index " + STRING$ (iItem)
		GuiTellApiError (@msg$)
	ENDIF

END FUNCTION
'
' ############################################
' #####  WinXListView_SetSelectionArray  #####
' ############################################
' Sets the selection in a list view.
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXListView_SetSelectionArray (hLV, indexList[])
	LV_ITEM lvi		' listview item
	XLONG i				' running index
	XLONG iMax		' upper index

	SetLastError (0)
	IFZ hLV THEN RETURN $$FALSE		' fail

	iMax = UBOUND(indexList[])
	FOR i = 0 TO iMax
		lvi.mask = $$LVIF_STATE
		lvi.iItem = indexList[i]
		lvi.state = $$LVIS_SELECTED
		lvi.stateMask = $$LVIS_SELECTED
		IFZ SendMessageA (hLV, $$LVM_SETITEM, 0, &lvi) THEN RETURN $$FALSE
	NEXT i

	RETURN $$TRUE

END FUNCTION
'
' ##################################
' #####  WinXListView_SetView  #####
' ##################################
' Sets the view of a list view.
' hLV = the handle of the list view
' view = the view to set
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXListView_SetView (hLV, view)
	XLONG style				' list view style

	IFZ hLV THEN RETURN $$FALSE		' fail
	style = GetWindowLongA (hLV, $$GWL_STYLE)
	style = (style AND NOT ($$LVS_ICON OR $$LVS_SMALLICON OR $$LVS_LIST OR $$LVS_REPORT)) OR view
	SetWindowLongA (hLV, $$GWL_STYLE, style)
END FUNCTION
'
' ###############################
' #####  WinXListView_Sort  #####
' ###############################
' Sorts the items in a list view.
' hLV = the list view control to sort
' iCol = the zero-based index of the column to sort by
' decreasing = $$TRUE to sort descending instead of ascending
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXListView_Sort (hLV, iCol, decreasing)
	SHARED g_lvs_column_index
	SHARED g_lvs_decreasing
	XLONG ret		' win32 api return value (0 for fail)

	SetLastError (0)
	IF hLV THEN
		g_lvs_column_index = iCol
		IF decreasing THEN
			g_lvs_decreasing = $$TRUE
		ELSE
			g_lvs_decreasing = $$FALSE
		ENDIF
		ret = SendMessageA (hLV, $$LVM_SORTITEMSEX, hLV, &CompareLVItems ())
		IF ret THEN
			RETURN $$TRUE		' success
		ENDIF
	ENDIF

END FUNCTION
'
' ###################################
' #####  WinXMakeFilterString$  #####
' ###################################
' Makes a filter string for WinXDialog_OpenFile$() or WinXDialog_SaveFile$().
' file_filter$ = a file filter using | as a separator
' returns a filter string using \0 as a separator.
'
' Usage:
' 1.File filter using | as a separator
'	file_filter$ = "Xblite Sources (*.x*)|*.x;*.xl;*.xbl;*.xxx|M4 Files (*.m4)|*.m4"
'	extensions$ = WinXMakeFilterString$ (file_filter$)
'
' 2.File filter using \0 as a separator
'	extensions$ == "Xblite Sources (*.x*)\0*.x;*.xl;*.xbl;*.xxx\0M4 Files (*.m4)\0*.m4\0\0"
'	extensions$ = WinXMakeFilterString$ (file_filter$)
'
FUNCTION WinXMakeFilterString$ (file_filter$)

	XLONG pos				' running position

	$sep$ = "|"
	$double_sep$ = "||"

	IFZ INSTR (file_filter$, $sep$) THEN RETURN file_filter$
'
' Check if the User provided with 2 trailing separators;
' if not, make sure there are 2 trailing separators.
'
	IF RIGHT$ (file_filter$, 2) = $double_sep$ THEN
		extensions$ = file_filter$		' Perfect! 2 trailing separators
	ELSE
		IF RIGHT$ (file_filter$) = $sep$ THEN
			extensions$ = file_filter$ + $sep$		' append the missing trailing separator
		ELSE
			extensions$ = file_filter$ + $double_sep$		' append 2 trailing separators
		ENDIF
	ENDIF
'
' Replace all | by nul-characters.
'
	pos = 0
	DO
		pos = INSTR (extensions$, $sep$, pos + 1)
		IFZ pos THEN EXIT DO
		extensions${pos - 1} = 0
	LOOP

	RETURN extensions$

END FUNCTION
'
' #############################
' #####  WinXMenu_Attach  #####
' #############################
' Attach a sub-menu to another menu.
' subMenu = the sub-menu to attach
' newParent = the new parent menu
' idMenu = the id to attach to
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXMenu_Attach (subMenu, newParent, idMenu)
	MENUITEMINFO	mii
	XLONG ret		' win32 api return value (0 for fail)

	SetLastError (0)

	IF subMenu THEN
		IF newParent THEN
			mii.fMask = $$MIIM_SUBMENU
			mii.hSubMenu = subMenu
			mii.cbSize = SIZE (MENUITEMINFO)

			' attach sub-menu idMenu to menu newParent
			ret = SetMenuItemInfoA (newParent, idMenu, $$FALSE, &mii)
			IF ret THEN
				RETURN $$TRUE		' success
			ENDIF
		ENDIF
	ENDIF

END FUNCTION
'
' ########################
' #####  WinXNewACL  #####
' ########################
' Creates a new security attributes structure.
' ssd$ = a string describing the ACL, 0 for null
' inherit = $$TRUE if these attributes can be inherited, otherwise $$FALSE
' returns the structure holding the security attributes
FUNCTION SECURITY_ATTRIBUTES WinXNewACL (ssd$, inherit)
	SECURITY_ATTRIBUTES r_secAttr		' returned security attributes
	SECURITY_ATTRIBUTES secAttr_empty

	XLONG args[3]
	XLONG ret				' win32 api return value (0 for fail)

	r_secAttr.length = SIZE(SECURITY_ATTRIBUTES)
	IF inherit THEN r_secAttr.inherit = 1

	ret = 0

	IF ssd$ THEN
'
' 0.6.0.2-old---
'		ConvertStringSecurityDescriptorToSecurityDescriptorA (&ssd$, $$SDDL_REVISION_1, &r_secAttr.securityDescriptor, 0)
' 0.6.0.2-old===
' 0.6.0.2-new+++
		funcName$ = "ConvertStringSecurityDescriptorToSecurityDescriptorA"
		dllName$ = "advapi32.dec"

		args[0] = &ssd$
		args[1] = $$SDDL_REVISION_1
		args[2] = &r_secAttr.securityDescriptor
		args[3] = 0
		ret = XstCall (funcName$, dllName$, @args[])
' 0.6.0.2-new===
'
	ENDIF

	IFZ ret THEN
		msg$ = "WinX-WinXNewACL: Can't set the structure holding the security attributes"
		WinXDialog_Error (@msg$, @"WinX-Alert", 2)
		r_secAttr = secAttr_empty
	ENDIF

	RETURN r_secAttr

END FUNCTION
'
' ####################################
' #####  WinXNewAutoSizerSeries  #####
' ####################################
' Adds a new auto-sizer series.
' direction = $$DIR_VERT or $$DIR_HORIZ
' returns the handle (index) of the new auto-sizer series, or -1 on fail
FUNCTION WinXNewAutoSizerSeries (direction)
	RETURN autoSizerInfo_addGroup (direction)
END FUNCTION
'
' ################################
' #####  WinXNewChildWindow  #####
' ################################
' Creates a new child window.
' returns the handle of the new child window
FUNCTION WinXNewChildWindow (hParent, STRING title, style, exStyle, idCtr)
	SHARED		g_hInst
	BINDING			binding
	XLONG		idBinding		' binding id
	LINKEDLIST autoDraw
	XLONG hWnd				' the handle of the new child window
	XLONG dwStyle					' window style

	SetLastError (0)

	dwStyle = style OR $$WS_VISIBLE OR $$WS_CHILD

	'make the window
	hWnd = CreateWindowExA (exStyle, &$$MAIN_CLASS$, &title, dwStyle, 0, 0, 0, 0, hParent, idCtr, g_hInst, 0)
	IFZ hWnd THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$TRUE)

	'make a binding
'	binding.hChildWnd = hWnd
	binding.hWnd = hWnd
	dwStyle = $$WS_POPUP OR $$TTS_NOPREFIX OR $$TTS_ALWAYSTIP
	IFZ g_hInst THEN
		g_hInst = GetModuleHandleA (0)
	ENDIF

	binding.hToolTips = CreateWindowExA (0, &$$TOOLTIPS_CLASS, 0, dwStyle, _
		$$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, hWnd, 0, g_hInst, 0)

	binding.msgHandlers = handler_addGroup ()
	LinkedList_Init (@autoDraw)
	binding.autoDrawInfo = LINKEDLIST_New (autoDraw)
	binding.autoSizerInfo = autoSizerInfo_addGroup ($$DIR_VERT)		' index

	SetWindowLongA (hWnd, $$GWL_USERDATA, binding_add (binding))

	'and we're done
	RETURN hWnd

END FUNCTION
'
' #########################
' #####  WinXNewFont  #####
' #########################
'
' Creates a logical font.
' fontName$ = name of the font
' pointSize = size of the font in points
' weight    = weight of the font as $$FW_THIN,...
' bItalic   = $$TRUE for italic characters
' bUnderL   = $$TRUE for underlined characters
' bStrike   = $$TRUE for striken-out characters
' returns the handle to the new font, or 0 on fail
'
FUNCTION WinXNewFont (fontName$, pointSize, weight, bItalic, bUnderL, bStrike)
	XLONG r_hFont		' the handle to the new font
	XLONG hFontToClone
	LOGFONT logFont
	XLONG bytes			' number of bytes stored into the buffer
	XLONG pointH		' character height is specified (in points)
	XLONG hDC				' the handle of the compatible context
	XLONG bErr			' $$TRUE for error

	SetLastError (0)
	r_hFont = 0

	' check fontName$ not empty
	fontName$ = TRIM$ (fontName$)
	IFZ fontName$ THEN
		msg$ = "WinX-WinXNewFont: empty font face"
		WinXDialog_Error (msg$, "WinX-Internal Error", 2)
		RETURN		' fail
	ENDIF

	' hFontToClone provides with a well-formed font structure
	SetLastError (0)
	hFontToClone = GetStockObject ($$DEFAULT_GUI_FONT)		' get a font to clone
	IFZ hFontToClone THEN
		msg$ = "WinX-WinXNewFont: Can't get a font to clone"
		bErr = GuiTellApiError (msg$)
		IFF bErr THEN WinXDialog_Error (msg$, "WinX-Internal Error", 2)
		RETURN		' invalid handle
	ENDIF

	bytes = 0		' number of bytes stored into the buffer
	bErr = $$FALSE
	SetLastError (0)
	bytes = GetObjectA (hFontToClone, SIZE(LOGFONT), &logFont)		' fill allocated structure logFont
	IF bytes <= 0 THEN
		msg$ = "WinX-WinXNewFont: Can't fill allocated structure logFont"
		bErr = GuiTellApiError (msg$)
		IFF bErr THEN WinXDialog_Error (msg$, "WinX-Internal Error", 2)
		RETURN
	ENDIF

	' release the cloned font
	DeleteObject (hFontToClone)		' free memory space
	hFontToClone = 0

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
		hDC = GetDC ($$HWND_DESKTOP)		' get a handle to the desktop context
		IFZ hDC THEN
			msg$ = "WinX-WinXNewFont: Can't get a handle to the desktop context"
			bErr = GuiTellApiError (msg$)
			IFF bErr THEN WinXDialog_Error (msg$, "WinX-Internal Error", 2)
			RETURN		' invalid handle
		ENDIF
		'
		' Windows expects the font height to be in pixels and negative
		logFont.height = MulDiv (pointH, GetDeviceCaps (hDC, $$LOGPIXELSY), -72)
		ReleaseDC ($$HWND_DESKTOP, hDC)		' release the handle to the desktop context
	ENDIF

	SELECT CASE weight
		CASE $$FW_THIN, $$FW_EXTRALIGHT, $$FW_LIGHT, $$FW_NORMAL, $$FW_MEDIUM, _
		     $$FW_SEMIBOLD, $$FW_BOLD, $$FW_EXTRABOLD, $$FW_HEAVY, $$FW_DONTCARE
			logFont.weight = weight
		CASE ELSE
			logFont.weight = $$FW_NORMAL
	END SELECT

	IF bItalic THEN logFont.italic    = 1 ELSE logFont.italic    = 0
	IF bUnderL THEN logFont.underline = 1 ELSE logFont.underline = 0
	IF bStrike THEN logFont.strikeOut = 1 ELSE logFont.strikeOut = 0

	SetLastError (0)
	r_hFont = CreateFontIndirectA (&logFont)		' create logical font r_hFont
	IFZ r_hFont THEN
		msg$ = "WinX-WinXNewFont: Can't create logical font r_hFont"
		bErr = GuiTellApiError (msg$)
		IFF bErr THEN WinXDialog_Error (msg$, "WinX-Internal Error", 2)
		RETURN
	ENDIF

	RETURN r_hFont

END FUNCTION
'
' #########################
' #####  WinXNewMenu  #####
' #########################
' Generates a new menu
' menuList$ = a string representing the menu.  Items are separated by commas,
'  two commas in a row indicate a separator.  Use & to specify hotkeys and && for &.
' firstID = the id of the first item, the other ids are assigned sequentially
' isPopup = $$TRUE if this is a popup menu else $$FALSE
' returns the handle of the new menu, or 0 on fail
FUNCTION WinXNewMenu (menuList$, firstID, isPopup)
	XLONG r_hMenu		' the handle of the new menu
	XLONG idMenu

	XLONG cSep		' the number of separators
	XLONG flags
	XLONG errNum		' last error code
	XLONG bErr			' $$TRUE for error
	XLONG ret				' win32 api return value (0 for fail)

	XLONG i				' running index
	XLONG iMax		' upper index
'
' Parse the string.
'
' 0.6.0.2-old---
'	XstParseStringToStringArray (menuList$, ",", @items$[])
' 0.6.0.2-old===
' 0.6.0.2-new+++
	SetLastError (0)
	r_hMenu = 0

	menuList$ = TRIM$(menuList$)
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
		XstParseStringToStringArray (menuList$, ",", @itemList$[])
	ENDIF
' 0.6.0.2-new===
'
	msg$ = "WinX-WinXNewMenu: Can't create "
	IF isPopup THEN
		msg$ = msg$ + "popup menu"
		r_hMenu = CreatePopupMenu ()
	ELSE
		msg$ = msg$ + "dropdown menu"
		r_hMenu = CreateMenu ()
	ENDIF

	IFZ r_hMenu THEN
		msg$ = "WinX-WinXNewMenu: Can't create the sub-menu"
		GuiTellApiError (@msg$)
		RETURN 0		' fail
	ENDIF

	'now write the menu items
	idMenu = firstID

	iMax = UBOUND(itemList$[])
	FOR i = 0 TO iMax
		IFZ TRIM$(itemList$[i]) THEN
			AppendMenuA (r_hMenu, $$MF_SEPARATOR, 0, 0)		' separator
		ELSE
			SetLastError (0)
			ret = AppendMenuA (r_hMenu, $$MF_STRING OR $$MF_ENABLED, idMenu, &itemList$[i])		' menu option
			IFZ ret THEN
				msg$ = "WinX-WinXNewMenu: Can't add menu option" + STR$ (idMenu) + " " + itemList$[i]
				GuiTellApiError (@msg$)
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
' Generates a new toolbar.
' wButton = The width of a button image in pixels
' hButton = the height of a button image in pixels
' nButtons = the number of buttons images
' hBmpButtons = the handle of a bitmap containing the button images
' hBmpGray = the appearance of the buttons when disabled, or 0 for default
' hBmpHot = the appearance of the buttons when the mouse is over them, or 0 for default
' transparentRGB = the color to use as transparent
' toolTips = $$TRUE to enable tool tips, $$FALSE to disable them
'(customisable = $$TRUE if this toolbar can be customised.)
'  !!THIS FEATURE IS NOT IMPLEMENTED YET, USE $$FALSE FOR THIS PARAMETER!!
' returns the handle of the new toolbar, or 0 on fail
'
' Usage:
' --------------------------------------------------------------------------
'
' First Example
' =============
'
'	' load the 3 image lists
'	hBmpButtons = LoadBitmapA (hInst, &"toolbarImg")			' normal image list
'	hBmpHot     = LoadBitmapA (hInst, &"toolbarHotImg")		' hot image list (if any in RC file)
'	hBmpGray    = LoadBitmapA (hInst, &"toolbarDisImg")		' disabled image list (if any)
'
'	transparentRGB = RGB (0xFF, 0, 0xFF)		' color code for transparency
'
'	#tbrMain = WinXNewToolbar (16, 16, 9, hBmpButtons, hBmpGray, hBmpHot, transparentRGB, $$TRUE, $$FALSE)
'
' Second Example
' ==============
'
'	' creating toolbar $$tbrMain
'	image$ = "vixen_toolbarImg"
'	SetLastError (0)
'	hBmpButtons = LoadBitmapA (hInst, &image$)
'	IFZ hBmpButtons THEN
'		msg$ = "LoadBitmapA: Can't load image vixen_toolbar.bmp from the resource"
'		GuiTellApiError (@msg$)
'	ENDIF
'	transparentRGB = RGB (0xFF, 0, 0xFF)		' color code for transparency ($$LightMagenta)
'	nButtons = 9
'	'
'	' Create toolbar $$tbrMain.
'	'
'	' hot image list and disabled image list not provided
'	#tbrMain = WapiNewToolbar (16, 16, nButtons, hBmpButtons, 0, 0, transparentRGB, $$TRUE, $$FALSE)
'	IFZ #tbrMain THEN
'		msg$ = "WndProc-winMain_Create: Can't create tool bar $$tbrMain"
'		bErr = GuiTellApiError (@msg$)
'		IFF bErr THEN WapiDialog_Error (@msg$, @title$, 2)		' Alert
'	ENDIF
' --------------------------------------------------------------------------
'
FUNCTION WinXNewToolbar (wButton, hButton, nButtons, hBmpButtons, hBmpGray, hBmpHot, transparentRGB, toolTips, customisable)

	XLONG hilButtons
	XLONG hilGray
	XLONG hilHot

	XLONG pixelRGB
	XLONG w					' width
	XLONG hDC				' the handle of the Desktop context
	XLONG hMem			' = CreateCompatibleDC (hDC)
	XLONG hSource		' = CreateCompatibleDC (hDC)
	XLONG hblankS		' = SelectObject (hSource, hBmpButtons)
	XLONG hBmpMask	' = CreateCompatibleBitmap (hSource, w, hButton)
	XLONG hblankM		' = SelectObject (hMem, hBmpMask)

	XLONG x				' running index
	XLONG y				' running index

	XLONG codeRGB		' RGB color format 0x808080
	XLONG red
	XLONG green
	XLONG blue

	SetLastError (0)
	IFZ hBmpButtons THEN RETURN 0

	w = wButton * nButtons

	'make image lists
	hilButtons = ImageList_Create (wButton, hButton, $$ILC_COLOR24 OR $$ILC_MASK, nButtons, 0)
	hilGray    = ImageList_Create (wButton, hButton, $$ILC_COLOR24 OR $$ILC_MASK, nButtons, 0)
	hilHot     = ImageList_Create (wButton, hButton, $$ILC_COLOR24 OR $$ILC_MASK, nButtons, 0)

	'make 2 memory DCs for image manipulations
	hDC = GetDC (GetDesktopWindow ())
	hMem = CreateCompatibleDC (hDC)
	hSource = CreateCompatibleDC (hDC)
	ReleaseDC (GetDesktopWindow (), hDC)
	hDC = 0

	'make a mask for the normal buttons
	hblankS = SelectObject (hSource, hBmpButtons)
	hBmpMask = CreateCompatibleBitmap (hSource, w, hButton)
	hblankM = SelectObject (hMem, hBmpMask)
	BitBlt (hMem, 0, 0, w, hButton, hSource, 0, 0, $$SRCCOPY)
	GOSUB makeMask
	hBmpButtons = SelectObject (hSource, hblankS)
	hBmpMask = SelectObject (hMem, hblankM)

	'Add to the image list
	ImageList_Add (hilButtons, hBmpButtons, hBmpMask)

	'now let's do the gray buttons
	IFZ hBmpGray THEN
		'generate hBmpGray
		hblankS = SelectObject (hSource, hBmpMask)
		hBmpGray = CreateCompatibleBitmap (hSource, w, hButton)
		hblankM = SelectObject (hMem, hBmpGray)
		FOR y = 0 TO (hButton - 1)
			FOR x = 0 TO (w - 1)
				codeRGB = GetPixel (hSource, x, y)
				IFZ codeRGB THEN SetPixel (hMem, x, y, 0x808080)
			NEXT x
		NEXT y
	ELSE
		'generate a mask
		hblankS = SelectObject (hSource, hBmpGray)
		hblankM = SelectObject (hMem, hBmpMask)
		BitBlt (hMem, 0, 0, w, hButton, hSource, 0, 0, $$SRCCOPY)
		GOSUB makeMask
	ENDIF

	SelectObject (hSource, hblankS)
	SelectObject (hMem, hblankM)
	ImageList_Add (hilGray, hBmpGray, hBmpMask)

	'and finally, the hot buttons
	IFZ hBmpHot THEN
		'generate a brighter version of hBmpButtons
'		hBmpHot = hBmpButtons
		hblankS = SelectObject (hSource, hBmpButtons)
		'hBmpHot = CopyImage (hBmpButtons, $$IMAGE_BITMAP, w, hButton, 0)
		hBmpHot = CreateCompatibleBitmap (hSource, w, hButton)
		hblankM = SelectObject (hMem, hBmpHot)
		FOR y = 0 TO (hButton - 1)
			FOR x = 0 TO (w - 1)
				codeRGB = GetPixel (hSource, x, y)

				red = (codeRGB AND 0x000000FF)
				IF red < 215 THEN
					red = red + 40		'red+((0xFF-red)\3)
				ENDIF

				green = (codeRGB AND 0x0000FF00) >> 8
				IF green < 215 THEN
					green = green + 40		'green+((0xFF-green)\3)
				ENDIF

				blue = (codeRGB AND 0x00FF0000) >> 16
				IF blue < 215 THEN
					blue = blue + 40		'blue+((0xFF-blue)\3)
				ENDIF

				codeRGB = red OR (green << 8) OR (blue << 16)
				SetPixel (hMem, x, y, codeRGB)
			NEXT x
		NEXT y
	ELSE
		'generate a mask
		hblankS = SelectObject (hSource, hBmpHot)
		hblankM = SelectObject (hMem, hBmpMask)
		BitBlt (hMem, 0, 0, w, hButton, hSource, 0, 0, $$SRCCOPY)
		GOSUB makeMask
	ENDIF

	SelectObject (hSource, hblankS)
	SelectObject (hMem, hblankM)

	ImageList_Add (hilHot, hBmpHot, hBmpMask)

	'ok, now clean up
	DeleteObject (hBmpMask)
	IF hBmpGray THEN DeleteObject (hBmpGray)
	DeleteDC (hMem)
	DeleteDC (hSource)
'
' Finally, make the toolbar and
' return the handle of the toolbar.
'
	RETURN WinXNewToolbarUsingIls (hilButtons, hilGray, hilHot, toolTips, customisable)

	SUB makeMask
		FOR y = 0 TO (hButton - 1)
			FOR x = 0 TO (w - 1)
				'get source's pixel
				codeRGB = GetPixel (hSource, x, y)
				IF codeRGB = transparentRGB THEN
					' replace transparency by $$White
					SetPixel (hSource, x, y, $$White)
					pixelRGB = $$White
				ELSE
					' the target's pixel is $$Black
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
' Makes a new toolbar using the specified image lists.
' hilButtons = the image list for the buttons
' hilGray = the images to be displayed when the buttons are disabled
' hilHot = the images to be displayed on mouse over
' toolTips = $$TRUE to enable tooltips control
' customisable = $$TRUE to enable customisation
' returns the handle of the toolbar, or 0 on fail
FUNCTION WinXNewToolbarUsingIls (hilButtons, hilGray, hilHot, toolTips, customisable)
	XLONG style				' toolbar style
	XLONG hToolbar		' the handle of the new toolbar

	SetLastError (0)
'
' style
' $$TBSTYLE_FLAT     : Flat toolbar
' $$TBSTYLE_LIST     : bitmap+text
' $$TBSTYLE_TOOLTIPS : Add tooltips
'
	style = $$TBSTYLE_FLAT OR $$TBSTYLE_LIST
	IF toolTips THEN
		style = style OR $$TBSTYLE_TOOLTIPS
	ENDIF
'
' 0.6.0.2-old---
'	IF customisable THEN
'		style = style OR $$CCS_ADJUSTABLE
'		SetPropA (hToolbar, &"customisationData", tbbd_addGroup ())
'	ELSE
'		SetPropA (hToolbar, &"customisationData", -1)
'	ENDIF
' 0.6.0.2-old===
'
	hToolbar = CreateWindowExA (0, &$$TOOLBARCLASSNAME, 0, style, 0, 0, 0, 0, 0, 0, GetModuleHandleA (0), 0)
	IFZ hToolbar THEN RETURN 0		' fail

	SendMessageA (hToolbar, $$TB_SETEXTENDEDSTYLE, 0, $$TBSTYLE_EX_MIXEDBUTTONS OR $$TBSTYLE_EX_DOUBLEBUFFER OR $$TBSTYLE_EX_DRAWDDARROWS)
	SendMessageA (hToolbar, $$TB_SETIMAGELIST, 0, hilButtons)
	SendMessageA (hToolbar, $$TB_SETHOTIMAGELIST, 0, hilHot)
	SendMessageA (hToolbar, $$TB_SETDISABLEDIMAGELIST, 0, hilGray)
	SendMessageA (hToolbar, $$TB_BUTTONSTRUCTSIZE, SIZE(TBBUTTON), 0)

	RETURN hToolbar

END FUNCTION
'
' ###########################
' #####  WinXNewWindow  #####
' ###########################
'	/*
'	[WinXNewWindow]
' Description = Creates a new window.
' Function    = hWnd = WinXNewWindow (hOwner, title$, x, y, w, h, simpleStyle, exStyle, icon, menu)
' ArgCount    = 10
'	Arg1				= hOwner : The parent of the new window
'	Arg2        = titleBar$ : The title bar for the new window
'	Arg3        = x : the x position for the new window, -1 for centre
'	Arg4        = y : the y position for the new window, -1 for centre
'	Arg5        = w : the width of the client area of the new window
'	Arg6        = h : the height of the client area of the new window
'	Arg7        = simpleStyle : a simple style constant
'	Arg8        = exStyle : an extended window style, look up CreateWindowEx in the win32 developer's guide for a list of extended styles
'	Arg9        = icon : the handle of the icon for the window, 0 for default
'	Arg10			= menu : the handle of the menu for the window, 0 for no menu
' Return      = The handle of the new window, or 0 on fail
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
FUNCTION WinXNewWindow (hOwner, STRING title, x, y, w, h, simpleStyle, exStyle, icon, menu)

	SHARED		g_hInst		' handle of current module
	SHARED		g_hWinXIcon		' WinX application icon
'
' .minW = GetSystemMetrics ($$SM_CXMINIMIZED)
' .minH = GetSystemMetrics ($$SM_CYMINIMIZED)
' .maxW = GetSystemMetrics ($$SM_CXSCREEN)
' .maxH = GetSystemMetrics ($$SM_CYSCREEN)
'
	BINDING			binding
	XLONG		idBinding		' binding id
	RECT	rect
	LINKEDLIST autoDraw

	XLONG dwStyle					' window style
	XLONG window_handle		' the handle of the new window

	XLONG winLeft			' left position of the window
	XLONG winTop			' top position of the window
	XLONG winWidth		' width of the window
	XLONG winHeight		' height of the window

	XLONG fMenu			' = 1 => this window has a menubar
	XLONG ret				' win32 api return value (0 for fail)

	IFZ g_hInst THEN
		'get the handle of current module
		g_hInst = GetModuleHandleA (0)
	ENDIF

	winLeft = x
	winTop = y
'
' GL-30sep24-old---
'	binding.minW = GetSystemMetrics ($$SM_CXMINIMIZED)
' GL-30sep24-old===
' GL-30sep24-new+++
	' Width of rectangle into which minimised windows must fit
	binding.minW = 0		' no minimum width
' GL-30sep24-new===
'
	IF w > binding.minW THEN
		winWidth = w
	ELSE
		winWidth = binding.minW
	ENDIF

	' Height of rectangle into which minimised windows must fit
	binding.minH = GetSystemMetrics ($$SM_CYMINIMIZED)

	IF h > binding.minH THEN
		winHeight = h
	ELSE
		winHeight = binding.minH
	ENDIF
'
' Take the desired size and position of our client area,
' and calculate the necessary window position and size to create that client size.
'
	' Set the size...
	rect.right = winWidth
	rect.bottom = winHeight

	' ...but not the position.
	rect.left = 0
	rect.top = 0
'
' Menus are not technically part of the client area,
' so it must be taken into consideration.
'
	IFZ menu THEN
		fMenu = 0
	ELSE
		fMenu = 1
	ENDIF

	' adjust the size
	AdjustWindowRectEx (&rect, dwStyle, fMenu, exStyle)

	' store the window adjusted width and height
	winWidth = rect.right - rect.left		' width of the window
	winHeight = rect.bottom - rect.top		' height of the window
'
' GL-09jun24-new+++
	IF menu THEN
		winHeight = winHeight - GetSystemMetrics ($$SM_CYMENU)		 ' Height of single-line menu
	ENDIF
' GL-09jun24-new===
'
	binding.maxW = GetSystemMetrics ($$SM_CXSCREEN)

	IF winLeft < 0 THEN
		' negative value => Center horizontally the window
		winLeft = (binding.maxW - winWidth) / 2
	ENDIF

	binding.maxH = GetSystemMetrics ($$SM_CYSCREEN)

	IF winTop < 0 THEN
		' negative value => Place vertically the window mid-height
		winTop = (binding.maxH - winHeight) / 2
	ENDIF

	dwStyle = XWSStoWS (simpleStyle)
'
' Create the window and use the result as the handle.
'
	SetLastError (0)
	window_handle = CreateWindowExA (exStyle, &$$MAIN_CLASS$, &title, dwStyle, _
		winLeft, winTop, winWidth, winHeight, _
		hOwner, menu, g_hInst, 0)

	IFZ window_handle THEN
		msg$ = "WinX-WinXNewWindow: Can't create the window, window class WinXMainClass"
		WinXDialog_Error (@msg$, @"WinX-Alert", 2)
		RETURN		' fail
	ENDIF

	'now add the icon
'
' 0.6.0.2-new+++
	IFZ icon THEN
		' use WinX Icon when the passed icon is NULL
		icon = g_hWinXIcon
	ENDIF
' 0.6.0.2-new===
'
	IF icon THEN
		SendMessageA (window_handle, $$WM_SETICON, $$ICON_BIG, icon)
		SendMessageA (window_handle, $$WM_SETICON, $$ICON_SMALL, icon)
	ENDIF
'
' 0.6.0.2-new+++
	IF menu THEN
		' activate the menubar
		SetLastError (0)
		ret = SetMenu (window_handle, menu)		' activate the menubar
		IFZ ret THEN
			msg$ = "WinX-WinXNewWindow: Can't activate the menubar"
			WinXDialog_Error (@msg$, @"WinX-Alert", 2)
		ENDIF
	ENDIF
' 0.6.0.2-new===
'
' Fill the binding record.
' =======================
'
	'make a binding
	binding.hWnd = window_handle
	binding.hToolTips = CreateWindowExA (0, &$$TOOLTIPS_CLASS, 0, $$WS_POPUP OR $$TTS_NOPREFIX OR $$TTS_ALWAYSTIP, _
		$$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, window_handle, 0, g_hInst, 0)

	' allocate the window's message handler
	binding.msgHandlers = handler_addGroup ()

	' allocate the window's auto-draw
	LinkedList_Init (@autoDraw)
	binding.autoDrawInfo = LINKEDLIST_New (autoDraw)

	' allocate the window's main series (vertical)
	' (retrieved with WinXAutoSizer_GetMainSeries).
	binding.autoSizerInfo = autoSizerInfo_addGroup ($$DIR_VERT)

	' store the binding id in class data area
'
' 0.6.0.2-old---
'	SetWindowLongA (window_handle, $$GWL_USERDATA, binding_add(binding))
' 0.6.0.2-old===
' 0.6.0.2-new+++
	idBinding = binding_add (binding)
	IF idBinding > 0 THEN
		SetWindowLongA (window_handle, $$GWL_USERDATA, idBinding)
	ELSE
		idBinding = 0
		msg$ = "WinX-WinXNewWindow: Can't add binding to the new window"
		msg$ = msg$ + "\r\n" + title
		WinXDialog_Error (@msg$, @"WinX-Internal Error", 2)
	ENDIF
' 0.6.0.2-new===
'
	'and we're done
	RETURN window_handle

END FUNCTION
'
' #######################################
' #####  WinXPrint_DevUnitsPerInch  #####
' #######################################
' Computes the number of device units in an inch.
' w, h = variables to store the width and height
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXPrint_DevUnitsPerInch (hPrinter, @w, @h)

	SetLastError (0)
	w = 0
	h = 0
	IF hPrinter THEN
		w = GetDeviceCaps (hPrinter, $$LOGPIXELSX)
		h = GetDeviceCaps (hPrinter, $$LOGPIXELSY)
		IF (w > 0) && (h > 0) THEN
			RETURN $$TRUE		' success
		ENDIF
	ENDIF

END FUNCTION
'
' ############################
' #####  WinXPrint_Done  #####
' ############################
' Finishes printing.
' hPrinter =  the handle of the printer
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXPrint_Done (hPrinter)
	SHARED	PRINTINFO	printInfo

	SetLastError (0)
	IF hPrinter THEN
		EndDoc (hPrinter)
		DeleteDC (hPrinter)
		DestroyWindow (printInfo.hCancelDlg)
		printInfo.continuePrinting = $$FALSE
		RETURN $$TRUE		' success
	ENDIF

END FUNCTION
'
' ########################################
' #####  WinXPrint_LogUnitsPerPoint  #####
' ########################################
' Gets the conversion factor between logical units
' and points.
FUNCTION DOUBLE WinXPrint_LogUnitsPerPoint (hPrinter, cyLog, cyPhys)
	DOUBLE logical_unit
	DOUBLE pointHeight
'
'	RETURN (DOUBLE(GetDeviceCaps (hPrinter, $$LOGPIXELSY))*DOUBLE(cyLog))/(72.0*DOUBLE(cyPhys))
'
	SetLastError (0)
	pointHeight = 0
	IF hPrinter THEN
		logical_unit = DOUBLE (GetDeviceCaps (hPrinter, $$LOGPIXELSY))
		pointHeight = (logical_unit * cyLog) / (72.0 * cyPhys)
	ENDIF
	RETURN pointHeight
END FUNCTION
'
' ############################
' #####  WinXPrint_Page  #####
' ############################
' Prints a single page.
' hPrinter = the handle of the printer
' hWnd = the handle of the window to print
' x, y, cxLog, cyLog = the coordinates, width and height of the rectangle on the window to print
' cxPhys, cyPhys = the width and height of that rectangle in printer units
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXPrint_Page (hPrinter, hWnd, x, y, cxLog, cyLog, cxPhys, cyPhys, pageNum, pageCount)
	SHARED	PRINTINFO	printInfo
'	AUTODRAWRECORD record
	BINDING			binding
	XLONG		idBinding		' binding id
	RECT	rect
	XLONG hRgn		' = CreateRectRgnIndirect (&rect)

	SetLastError (0)
	IFZ hPrinter THEN RETURN $$FALSE		' fail

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	'get the clipping rect for the printer
	rect.left = (GetDeviceCaps (hPrinter, $$LOGPIXELSX) * printInfo.marginLeft) \ 1000
	rect.right = GetDeviceCaps (hPrinter, $$PHYSICALWIDTH) - (GetDeviceCaps (hPrinter, $$LOGPIXELSX) * printInfo.marginRight) \ 1000 + 1
	rect.top = (GetDeviceCaps (hPrinter, $$LOGPIXELSY) * printInfo.marginTop) \ 1000
	rect.bottom = GetDeviceCaps (hPrinter, $$PHYSICALHEIGHT) - (GetDeviceCaps (hPrinter, $$LOGPIXELSY) * printInfo.marginBottom) \ 1000 + 1

	' set up clipping
	hRgn = CreateRectRgnIndirect (&rect)
	SelectClipRgn (hPrinter, hRgn)
	DeleteObject (hRgn)

	' set up the scaling
	SetMapMode (hPrinter, $$MM_ANISOTROPIC)
	SetWindowOrgEx (hPrinter, 0, 0, 0)
	SetWindowExtEx (hPrinter, cxLog, cyLog, 0)
	SetViewportOrgEx (hPrinter, rect.left, rect.top, 0)
	SetViewportExtEx (hPrinter, cxPhys, cyPhys, 0)
	SetStretchBltMode (hPrinter, $$HALFTONE)

	' set the text in the cancel dialog
	text$ = "Printing page " + STRING$ (pageNum) + " of " + STRING$ (pageCount) + "..."
	WinXSetText (GetDlgItem (printInfo.hCancelDlg, $$DLGCANCEL_ST_PAGE), @text$)

	' play the auto-draw info into the printer
	StartPage (hPrinter)
	autoDraw_draw (hPrinter, binding.autoDrawInfo, x, y)
	IF EndPage (hPrinter) > 0 THEN
		RETURN $$TRUE		' success
	ENDIF
END FUNCTION
'
' #################################
' #####  WinXPrint_PageSetup  #####
' #################################
' Displays a page setup dialog box to the User and
' updates the print parameters according to the result.
' hOwner = the handle of the window that owns the dialog
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXPrint_PageSetup (hOwner)
	SHARED	PRINTINFO	printInfo
	PAGESETUPDLG pageSetupDlg
	UBYTE localeInfo[3]

	SetLastError (0)
	pageSetupDlg.lStructSize = SIZE(PAGESETUPDLG)
	pageSetupDlg.hwndOwner = hOwner
	IFZ pageSetupDlg.hwndOwner THEN
		pageSetupDlg.hwndOwner = GetActiveWindow ()
	ENDIF

	pageSetupDlg.hDevMode = printInfo.hDevMode
	pageSetupDlg.hDevNames = printInfo.hDevNames
	pageSetupDlg.flags = $$PSD_DEFAULTMINMARGINS OR $$PSD_MARGINS
	pageSetupDlg.rtMargin.left = printInfo.marginLeft
	pageSetupDlg.rtMargin.right = printInfo.marginRight
	pageSetupDlg.rtMargin.top = printInfo.marginTop
	pageSetupDlg.rtMargin.bottom = printInfo.marginBottom

	GetLocaleInfoA ($$LOCALE_USER_DEFAULT, $$LOCALE_IMEASURE, &localeInfo[], SIZE(localeInfo[]))
	IF (localeInfo[0] = '0') THEN
		' the User prefers the metric system, so convert the units
		pageSetupDlg.rtMargin.left = XLONG (DOUBLE (pageSetupDlg.rtMargin.left) * 2.54)
		pageSetupDlg.rtMargin.right = XLONG (DOUBLE (pageSetupDlg.rtMargin.right) * 2.54)
		pageSetupDlg.rtMargin.top = XLONG (DOUBLE (pageSetupDlg.rtMargin.top) * 2.54)
		pageSetupDlg.rtMargin.bottom = XLONG (DOUBLE (pageSetupDlg.rtMargin.bottom) * 2.54)
	ENDIF

	IF PageSetupDlgA (&pageSetupDlg) THEN
		printInfo.marginLeft = pageSetupDlg.rtMargin.left
		printInfo.marginRight = pageSetupDlg.rtMargin.right
		printInfo.marginTop = pageSetupDlg.rtMargin.top
		printInfo.marginBottom = pageSetupDlg.rtMargin.bottom
		IFZ printInfo.hDevMode THEN printInfo.hDevMode = pageSetupDlg.hDevMode
		IFZ printInfo.hDevNames THEN printInfo.hDevNames = pageSetupDlg.hDevNames
		IF pageSetupDlg.flags AND $$PSD_INHUNDREDTHSOFMILLIMETERS THEN
			printInfo.marginLeft = XLONG (DOUBLE (printInfo.marginLeft) / 2.54)
			printInfo.marginRight = XLONG (DOUBLE (printInfo.marginRight) / 2.54)
			printInfo.marginTop = XLONG (DOUBLE (printInfo.marginTop) / 2.54)
			printInfo.marginBottom = XLONG (DOUBLE (printInfo.marginBottom) / 2.54)
		ENDIF
		RETURN $$TRUE		' success
	ENDIF

END FUNCTION
'
' #############################
' #####  WinXPrint_Start  #####
' #############################
' Optionally displays a print settings dialog box
' then starts printing.
' minPage = the minimum page the User can select
' maxPage = the maximum page the User can select
' rangeMin = the initial minimum page, 0 for selection.  The User may change this value
' rangeMax = the initial maximum page, -1 for all pages.  The User may change this value
' cxPhys = the number of device pixels accross - the margins
' cyPhys = the number of device units vertically - the margins
' showDialog = $$TRUE to display a dialog or $$FALSE to use defaults
' hOwner = the handle of the window that owns the print settins dialog box or 0 for none
' returns the handle of the printer, or 0 on fail
FUNCTION WinXPrint_Start (minPage, maxPage, @rangeMin, @rangeMax, @cxPhys, @cyPhys, fileName$, showDialog, hOwner)
	SHARED	PRINTINFO	printInfo
	PRINTDLG printDlg
	DOCINFO docInfo
	XLONG hDC				' the handle of the print dialog context
	XLONG pDevMode	' pointer the DEVMODE structure
	XLONG i					' running index

	SetLastError (0)

	' First, get a DC
	IF showDialog THEN
		printDlg.lStructSize = SIZE(PRINTDLG)
		printDlg.hwndOwner = hOwner
		IFZ printDlg.hwndOwner THEN
			printDlg.hwndOwner = GetActiveWindow ()
		ENDIF

		printDlg.hDevMode = printInfo.hDevMode
		printDlg.hDevNames = printInfo.hDevNames
		printDlg.flags = printInfo.printSetupFlags OR $$PD_RETURNDC OR $$PD_USEDEVMODECOPIESANDCOLLATE
		IFZ rangeMin THEN
			printDlg.flags = printDlg.flags OR $$PD_SELECTION
			printDlg.nFromPage = minPage
			printDlg.nToPage = maxPage
		ELSE
			printDlg.flags = printDlg.flags OR $$PD_NOSELECTION
			IF rangeMax < 0 THEN
				printDlg.nFromPage = minPage
				printDlg.nToPage = maxPage
			ELSE
				printDlg.flags = printDlg.flags OR $$PD_PAGENUMS
				printDlg.nFromPage = rangeMin
				printDlg.nToPage = rangeMax
			ENDIF
		ENDIF

		printDlg.nMinPage = minPage
		printDlg.nMaxPage = maxPage

		IF PrintDlgA (&printDlg) THEN
			IFZ printInfo.hDevMode THEN printInfo.hDevMode = printDlg.hDevMode
			IFZ printInfo.hDevNames THEN printInfo.hDevNames = printDlg.hDevNames
			printInfo.printSetupFlags = printDlg.flags
			IF printDlg.flags AND $$PD_PAGENUMS THEN
				rangeMin = printDlg.nFromPage		'range
				rangeMax = printDlg.nToPage
			ELSE
				IF printDlg.flags AND $$PD_SELECTION THEN
					rangeMin = 0		'selection
				ELSE
					rangeMax = -1		'all pages
				ENDIF
			ENDIF
			hDC = printDlg.hdc
		ELSE
			RETURN 0
		ENDIF
	ELSE
		IFZ printInfo.hDevMode THEN
			' Get a DEVMODE structure for the default printer in the default configuration
			printDlg.lStructSize = SIZE(PRINTDLG)
			printDlg.hDevMode = 0
			printDlg.hDevNames = 0
			printDlg.flags = $$PD_USEDEVMODECOPIESANDCOLLATE OR $$PD_RETURNDEFAULT
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
				ULONGAT(&devName$, i) = ULONGAT(pDevMode, i)
			NEXT i
			hDC = CreateDCA (0, &devName$, 0, pDevMode)
		ENDIF
		GlobalUnlock (printInfo.hDevMode)

		IFZ hDC THEN RETURN 0
	ENDIF

	' OK, we have a DC.  Now let's get the physical sizes
	cxPhys = GetDeviceCaps (hDC, $$PHYSICALWIDTH) - (GetDeviceCaps (hDC, $$LOGPIXELSX) * (printInfo.marginLeft + printInfo.marginRight)) \ 1000
	cyPhys = GetDeviceCaps (hDC, $$PHYSICALHEIGHT) - (GetDeviceCaps (hDC, $$LOGPIXELSY) * (printInfo.marginTop + printInfo.marginBottom)) \ 1000

	' Sort out an abort proc
	title$ = "Printing " + fileName$
	printInfo.hCancelDlg = WinXNewWindow (0, @title$, -1, -1, 300, 70, $$XWSS_POPUP, 0, 0, 0)
	MoveWindow (WinXAddStatic (printInfo.hCancelDlg, "Preparing to print", 0, $$SS_CENTER, $$DLGCANCEL_ST_PAGE), 0, 8, 300, 24, $$TRUE)
	MoveWindow (WinXAddButton (printInfo.hCancelDlg, "Cancel", 0, $$IDCANCEL), 110, 30, 80, 25, $$TRUE)
	WinXDisplay (printInfo.hCancelDlg)
	SetAbortProc (hDC, &printAbortProc ())
	printInfo.continuePrinting = $$TRUE

	' Now we can start the printing
	docInfo.size = SIZE(DOCINFO)
	docInfo.docName = &fileName$
	StartDocA (hDC, &docInfo)

	RETURN hDC
END FUNCTION
'
' #####################################
' #####  WinXProgress_SetMarquee  #####
' #####################################
' Enables or disables marquee mode.
' hProg = the progress bar
' enable = $$TRUE to enable marquee mode, $$FALSE to disable
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXProgress_SetMarquee (hProg, enable)

	SetLastError (0)
	IF hProg THEN
		IF enable THEN
			SetWindowLongA (hProg, $$GWL_STYLE, GetWindowLongA (hProg, $$GWL_STYLE) OR $$PBS_MARQUEE)
			SendMessageA (hProg, $$PBM_SETMARQUEE, $$TRUE, 50)
		ELSE
			SetWindowLongA (hProg, $$GWL_STYLE, GetWindowLongA (hProg, $$GWL_STYLE) AND NOT $$PBS_MARQUEE)
			SendMessageA (hProg, $$PBM_SETMARQUEE, $$FALSE, 50)
		ENDIF
		RETURN $$TRUE		' success
	ENDIF

END FUNCTION
'
' #################################
' #####  WinXProgress_SetPos  #####
' #################################
' Sets the position of a progress bar.
' hProg = the handle of the progress bar
' pos = proportion of progress bar to shade
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXProgress_SetPos (hProg, DOUBLE pos)
	SetLastError (0)
	IF hProg THEN
		SendMessageA (hProg, $$PBM_SETPOS, (1000 * pos), 0)
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
' Function    = WinXRegControlSizer (hWnd, FUNCADDR onSize)
' ArgCount    = 2
'	Arg1        = hWnd : The window to register the callback function for
'	Arg2        = onSize : The address of the callback function
' Return      = $$TRUE on success or $$FALSE on error
' Remarks     = This function allows you to use your own control sizing code instead of the default \n
'WinX auto-sizer.  You will have to resize all controls, including status bars and toolbars, if you use \n
'this callback function.  The callback function has two XLONG parameters, w and h.
'	See Also    =
'	Examples    = WinXRegControlSizer (#hMain, &customSizer())
'	*/
FUNCTION WinXRegControlSizer (hWnd, FUNCADDR onSize)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE		' fail

	' set the function
	binding.dimControls = onSize
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ###################################
' #####  WinXRegMessageHandler  #####
' ###################################
'	/*
'	[WinXRegMessageHandler]
' Description = Registers a message handler callback function
' Function    = WinXRegMessageHandler (hWnd, msg, FUNCADDR msgHandler)
' ArgCount    = 3
'	Arg1        = hWnd : The window to register the callback function for
'	Arg2        = wMsg : The message the callback processes
'	Arg3        = msgHandler : The address of the callback function
' Return      = $$TRUE on success or $$FALSE on error
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
FUNCTION WinXRegMessageHandler (hWnd, wMsg, FUNCADDR msgHandler)
	BINDING			binding
	XLONG		idBinding		' binding id
	MSGHANDLER handler

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE		' fail

	' prepare the handler
	handler.msg = wMsg
	handler.handler = msgHandler

	' and add it
	IF handler_add (binding.msgHandlers, handler) < 0 THEN RETURN $$FALSE

	RETURN $$TRUE
END FUNCTION
'
' #####################################
' #####  WinXRegOnCalendarSelect  #####
' #####################################
' Registers an onCalendarSelect callback function.
' hWnd = the handle of the window to set the callback function for
' onCalendarSelect = the address of the callback
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnCalendarSelect (hWnd, FUNCADDR onCalendarSelect)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onCalendarSelect = onCalendarSelect
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ###########################
' #####  WinXRegOnChar  #####
' ###########################
' Registers an onChar callback function.
' hWnd = the handle of the window to register the callback function for
' onChar = the address of the callback function
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnChar (hWnd, FUNCADDR onChar)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onChar = onChar
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' #################################
' #####  WinXRegOnClipChange  #####
' #################################
' Registers an onClipChange callback function for when the clipboard changes.
' hWnd = the handle of the window
' onFocusChange = the address of the callback
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnClipChange (hWnd, FUNCADDR onClipChange)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.hWndNextClipViewer = SetClipboardViewer (hWnd)

	binding.onClipChange = onClipChange
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ############################
' #####  WinXRegOnClose  #####
' ############################
' Registers an onClose callback of a window.
FUNCTION WinXRegOnClose (hWnd, FUNCADDR onClose)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onClose = onClose
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ##################################
' #####  WinXRegOnColumnClick  #####
' ##################################
' Registers an onColumnClick callback function for a list view control.
' hWnd = the window to register the callback function for
' onColumnClick = the address of the callback function
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnColumnClick (hWnd, FUNCADDR onColumnClick)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onColumnClick = onColumnClick
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ##############################
' #####  WinXRegOnCommand  #####
' ##############################
' Registers an onCommand callback function.
' hWnd = the window to register
' onCommand = the function to process commands
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnCommand (hWnd, FUNCADDR onCommand)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onCommand = onCommand
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ###########################
' #####  WinXRegOnDrag  #####
' ###########################
' Registers an onDrag callback function.
' hWnd = the window to register the callback function for
' onDrag = the address of the callback function
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnDrag (hWnd, FUNCADDR onDrag)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onDrag = onDrag
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ################################
' #####  WinXRegOnDropFiles  #####
' ################################
' Registers an onDropFiles callback function for a window.
' hWnd = the window to register the callback function for
' onDropFiles = the address of the callback function
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnDropFiles (hWnd, FUNCADDR onDropFiles)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	DragAcceptFiles (hWnd, $$TRUE)
	binding.onDropFiles = onDropFiles
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' #################################
' #####  WinXRegOnEnterLeave  #####
' #################################
' Registers an onEnterLeave callback function.
' hWnd = the handle of the window to register the callback function for
' onEnterLeave = the address of the callback function
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnEnterLeave (hWnd, FUNCADDR onEnterLeave)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onEnterLeave = onEnterLeave
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ##################################
' #####  WinXRegOnFocusChange  #####
' ##################################
' Registers an onFocusChange callback function for when the focus changes.
' hWnd = the handle of the window
' onFocusChange = the callback function
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnFocusChange (hWnd, FUNCADDR onFocusChange)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onFocusChange = onFocusChange
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ###########################
' #####  WinXRegOnItem  #####
' ###########################
' Registers an onItem callback function for a list view.
' hWnd = the window to register the message for
' onItem = the address of the callback function
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnItem (hWnd, FUNCADDR onItem)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onItem = onItem
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ##############################
' #####  WinXRegOnKeyDown  #####
' ##############################
' Registers an onKeyDown callback function.
' hWnd = the handle of the window to register the callback function for
' onKeyDown = the address of the onKeyDown callback function
' returns $$TRUE on success, or $$FALSE on fail
'
' Usage:
'	addrProc = &winAbout_OnKeyDown ()		' handles message $$WM_KEYDOWN
'	WinXRegOnKeyDown (#winAbout, addrProc)
'
FUNCTION WinXRegOnKeyDown (hWnd, FUNCADDR onKeyDown)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onKeyDown = onKeyDown
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ############################
' #####  WinXRegOnKeyUp  #####
' ############################
' Registers an onKeyUp callback function.
' hWnd = the handle of the window to register the callback function for
' onKeyUp = the address of the callback function
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnKeyUp (hWnd, FUNCADDR onKeyUp)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onKeyUp = onKeyUp
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ################################
' #####  WinXRegOnLabelEdit  #####
' ################################
' Registers an onLabelEdit callback function.
' hWnd = the window to register the callback function for
' onLabelEdit = the address of the callback function
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnLabelEdit (hWnd, FUNCADDR onLabelEdit)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onLabelEdit = onLabelEdit
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ################################
' #####  WinXRegOnMouseDown  #####
' ################################
' Registers an onMouseDown callback function for when the mouse is pressed
' hWnd = the handle of the window
' onMouseDown = the function to call when the mouse is pressed
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnMouseDown (hWnd, FUNCADDR onMouseDown)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onMouseDown = onMouseDown
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ################################
' #####  WinXRegOnMouseMove  #####
' ################################
' Registers an onMouseMove callback function for when the mouse is moved
' hWnd = the handle of the window
' onMouseMove = the function to call when the mouse moves
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnMouseMove (hWnd, FUNCADDR onMouseMove)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onMouseMove = onMouseMove
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ##############################
' #####  WinXRegOnMouseUp  #####
' ##############################
' Registers an onMouseUp callback function for when the mouse is released
' hWnd = the handle of the window
' onMouseUp = the function to call when the mouse is released
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnMouseUp (hWnd, FUNCADDR onMouseUp)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onMouseUp = onMouseUp
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' #################################
' #####  WinXRegOnMouseWheel  #####
' #################################
' Registers an onMouseWheel callback function for when the mouse wheel is rotated
' hWnd = the handle of the window
' onMouseWheel = the function to call when the mouse wheel is rotated
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnMouseWheel (hWnd, FUNCADDR onMouseWheel)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onMouseWheel = onMouseWheel
	RETURN binding_update (idBinding, binding)
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
'	Arg1        = hWnd : The handle of the window to register the callback function for
'	Arg2        = onPaint : The address of the function to use for the callback
' Return      = $$TRUE on success, or $$FALSE on fail
' Remarks     = The callback function must take a single XLONG parameter called \n
'hdc, this parameter is the handle of the device context to draw on. \n
'If you register this callback, auto-draw is disabled.\n
'	See Also    =
'	Examples    = WinXRegOnPaint (#hMain, &onPaint())
'	*/
FUNCTION WinXRegOnPaint (hWnd, FUNCADDR onPaint)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	' set the paint function
	binding.paint = onPaint
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' #############################
' #####  WinXRegOnScroll  #####
' #############################
' Registers an onScroll callback function.
' hWnd = the handle of the window to register the callback function for
' onScroll = the address of the callback function
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnScroll (hWnd, FUNCADDR onScroll)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onScroll = onScroll
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' #################################
' #####  WinXRegOnTrackerPos  #####
' #################################
' Registers an onTrackerPos callback function.
' hWnd = the handle of the window to register the callback function for
' onTrackerPos = the address of the callback function
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegOnTrackerPos (hWnd, FUNCADDR onTrackerPos)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.onTrackerPos = onTrackerPos
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ##################################
' #####  WinXRegistry_ReadBin  #####
' ##################################
' Reads binary data from the registry.
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' createOnFail = $$TRUE to create the key if it doesn't exist.  Assigns result to the key
' sa = the security attributes for the key if it is created
' result$ = the binary data read from the registry
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegistry_ReadBin (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
	XLONG pSA				' = &sa
	XLONG bOK				' $$TRUE for success
	XLONG zeroOK		' = 0 => OK!

	XLONG hSubKey
	XLONG disposition
	XLONG type
	XLONG cbSize

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	' IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ OR $$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ OR $$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		GOSUB QueryVariable
		RegCloseKey (hSubKey)
	ELSE
		' IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ OR $$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ OR $$KEY_WRITE, pSA, &hSubKey, &disposition)
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
' returns $$TRUE on success, or $$FALSE on fail
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
' Reads an integer from the registry.
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' createOnFail = $$TRUE to create the key if it doesn't exist.  Assigns result to the key
' sa = the security attributes for the key if it is created
' result = the integer read from the registry
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegistry_ReadInt (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result)
	XLONG bOK				' $$TRUE for success
	XLONG zeroOK		' = 0 => OK!
	XLONG pSA				' = &sa

	XLONG four
	XLONG hSubKey
	XLONG type
	XLONG disposition

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	four = 4

	' IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ OR $$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ OR $$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		' IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result, &four) = $$ERROR_SUCCESS THEN
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
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ OR $$KEY_WRITE, pSA, &hSubKey, &disposition)
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
' Reads a string from the registry.
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' createOnFail = $$TRUE to create the key if it doesn't exist.  Assigns result to the key
' sa = the security attributes for the key if it is created
' result$ = the string read from the registry
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegistry_ReadString (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
	XLONG bOK				' $$TRUE for success
	XLONG zeroOK		' = 0 => OK!
	XLONG pSA				' = &sa

	XLONG hSubKey
	XLONG disposition
	XLONG type
	XLONG cbSize

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	'IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ OR $$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ OR $$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		GOSUB QueryVariable
		RegCloseKey (hSubKey)
	ENDIF

	IFF bOK THEN
		'IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ OR $$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ OR $$KEY_WRITE, pSA, &hSubKey, &disposition)
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
' returns $$TRUE on success, or $$FALSE on fail
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
' Writes binary data into the registry.
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' createOnFail = $$TRUE to create the key if it doesn't exist.  Assigns result to the key
' sa = the security attributes for the key if it is created
' szBuf$ = the binary data to write into the registry
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegistry_WriteBin (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, szBuf$)
	XLONG pSA				' = &sa
	XLONG bOK				' $$TRUE for success
	XLONG zeroOK		' = 0 => OK!

	XLONG hSubKey
	XLONG disposition

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ OR $$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &szBuf$, LEN (szBuf$))
		IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
		RegCloseKey (hSubKey)
	ELSE
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ OR $$KEY_WRITE, pSA, &hSubKey, &disposition)
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
' Writes an integer into the registry.
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' sa = the security attributes for the key if it is created
' int = the integer to write into the registry
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegistry_WriteInt (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, int)
	XLONG pSA				' = &sa
	XLONG bOK				' $$TRUE for success
	XLONG zeroOK		' = 0 => OK!

	XLONG hSubKey
	XLONG integer
	XLONG disposition

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ OR $$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &integer, 4)
		IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
		RegCloseKey (hSubKey)
	ELSE
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ OR $$KEY_WRITE, pSA, &hSubKey, &disposition)
		IFZ zeroOK THEN		' (0 is for success)
			zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &integer, 4)
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
' Writes a string into the registry.
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' createOnFail = $$TRUE to create the key if it doesn't exist.  Assigns result to the key
' sa = the security attributes for the key if it is created
' szBuf$ = the string to write into the registry
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXRegistry_WriteString (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, szBuf$)
	XLONG pSA				' = &sa
	XLONG bOK				' $$TRUE for success
	XLONG zeroOK		' = 0 => OK!

	XLONG hSubKey
	XLONG disposition

	SetLastError (0)
	bOK = $$FALSE

	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	zeroOK = RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ OR $$KEY_WRITE, &hSubKey)
	IFZ zeroOK THEN		' (0 is for success)
		zeroOK = RegSetValueExA (hSubKey, &value$, 0, $$REG_SZ, &szBuf$, LEN (szBuf$))
		IFZ zeroOK THEN bOK = $$TRUE		' (0 is for success)
		RegCloseKey (hSubKey)
	ELSE
		zeroOK = RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ OR $$KEY_WRITE, pSA, &hSubKey, &disposition)
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
' Gets the scrolling position of a window.
' hWnd = the handle of the window
' direction = the scrolling direction
' pos = the variable to store the scrolling position
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXScroll_GetPos (hWnd, direction, @pos)
	SCROLLINFO si
	XLONG typeBar		' status bar type

	si.cbSize = SIZE(SCROLLINFO)
	si.fMask = $$SIF_POS
	SELECT CASE direction
		CASE $$DIR_HORIZ : typeBar = $$SB_HORZ
		CASE $$DIR_VERT : typeBar = $$SB_VERT
	END SELECT
	GetScrollInfo (hWnd, typeBar, &si)
	pos = si.nPos

	RETURN $$TRUE

END FUNCTION
'
' ###############################
' #####  WinXScroll_Scroll  #####
' ###############################
' hWnd = the handle of the window to scroll
' direction = the direction to scroll in
' unitType = the type of unit to scroll by
' scrollDirection = + to scroll up, - to scroll down
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXScroll_Scroll (hWnd, direction, unitType, scrollingDirection)

	' SendMessageA (hWnd, wMsg, wParam, 0)
	XLONG wMsg		' Windows message
	XLONG wParam

	XLONG scroll
	XLONG scroll_max

	IFZ hWnd THEN RETURN $$FALSE
	IFZ scrollingDirection THEN RETURN $$FALSE

	SELECT CASE direction
		CASE $$DIR_HORIZ : wMsg = $$WM_HSCROLL
		CASE $$DIR_VERT : wMsg = $$WM_VSCROLL
		CASE ELSE
			RETURN $$FALSE
	END SELECT

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

	' scroll scrollingDirection times
	scroll_max = ABS (scrollingDirection)

	FOR scroll = 1 TO scroll_max
		SendMessageA (hWnd, wMsg, wParam, 0)
	NEXT scroll

	RETURN $$TRUE		' success

END FUNCTION
'
' ################################
' #####  WinXScroll_SetPage  #####
' ################################
' Sets the page size mapping function.
' hWnd = the handle of the window containing the scroll bar
' direction = the direction of the scrollbar to set the info for
' mul = the number to multiply the window width/height by to get the page width/height
' constant = the constant to add to the page width/height
' scrollUnit = the number of units to scroll by when the arrows are clicked
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXScroll_SetPage (hWnd, direction, DOUBLE mul, constant, scrollUnit)
	BINDING			binding
	XLONG		idBinding		' binding id
	RECT	rect
	SCROLLINFO si
	XLONG typeBar			' status bar type

	XLONG cyhscroll		' = GetSystemMetrics ($$SM_CYHSCROLL)
	XLONG cxvscroll		' = GetSystemMetrics ($$SM_CXVSCROLL)

	XLONG width
	XLONG height

	SetLastError (0)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE		' fail

	GetClientRect (hWnd, &rect)

	si.cbSize = SIZE(SCROLLINFO)
	si.fMask = $$SIF_PAGE OR $$SIF_DISABLENOSCROLL

	SELECT CASE direction AND 0x00000003
		CASE $$DIR_HORIZ
			typeBar = $$SB_HORZ
			binding.hScrollPageM = mul
			binding.hScrollPageC = constant
			binding.hScrollUnit = scrollUnit

			cyhscroll = GetSystemMetrics ($$SM_CYHSCROLL)		' Height of arrow bitmap on horizontal scroll bar
			width = rect.right - rect.left + cyhscroll
			si.nPage = (width * mul) + constant

		CASE $$DIR_VERT
			typeBar = $$SB_VERT
			binding.vScrollPageM = mul
			binding.vScrollPageC = constant
			binding.vScrollUnit = scrollUnit

			cxvscroll = GetSystemMetrics ($$SM_CXVSCROLL)		' Width of arrow bitmap on vertical scroll bar
			height = rect.bottom - rect.top + cxvscroll
			si.nPage = (height * mul) + constant

		CASE ELSE
			RETURN $$FALSE		' fail

	END SELECT
	SetScrollInfo (hWnd, typeBar, &si, $$TRUE)

	' and update the binding
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ###############################
' #####  WinXScroll_SetPos  #####
' ###############################
' Sets the scrolling position of a window.
' hWnd = the handle of the window
' direction = the scrolling direction
' pos = the new scrolling position
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXScroll_SetPos (hWnd, direction, pos)
	SCROLLINFO si
	XLONG typeBar		' status bar type

	SetLastError (0)

	si.cbSize = SIZE(SCROLLINFO)
	si.fMask = $$SIF_POS
	si.nPos = pos

	' clear flag $$DIR_REVERSE of direction
	SELECT CASE direction AND 0x00000003
		CASE $$DIR_HORIZ : typeBar = $$SB_HORZ
		CASE $$DIR_VERT  : typeBar = $$SB_VERT
		CASE ELSE
			RETURN $$FALSE
	END SELECT
	SetScrollInfo (hWnd, typeBar, &si, 1)

	RETURN $$TRUE		' success

END FUNCTION
'
' #################################
' #####  WinXScroll_SetRange  #####
' #################################
' Sets the range the scrollbar moves through.
' hWnd = the handle of the window the scrollbar belongs to
' direction = the direction of the scrollbar
' min = the minimum value of the range
' max = the maximum value of the range
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXScroll_SetRange (hWnd, direction, min, max)
	SCROLLINFO si
	RECT	rect
	XLONG typeBar		' status bar type

	SELECT CASE direction AND 0x00000003
		CASE $$DIR_HORIZ
			typeBar = $$SB_HORZ
		CASE $$DIR_VERT
			typeBar = $$SB_VERT
		CASE ELSE
			RETURN $$FALSE
	END SELECT

	si.cbSize = SIZE(SCROLLINFO)
	si.fMask = $$SIF_RANGE OR $$SIF_DISABLENOSCROLL
	si.nMin = min
	si.nMax = max

	SetScrollInfo (hWnd, typeBar, &si, $$TRUE)		' redraw

	'refresh the window
	GetClientRect (hWnd, &rect)
	sizeWindow (hWnd, rect.right, rect.bottom)

	RETURN $$TRUE		' success

END FUNCTION
'
' #############################
' #####  WinXScroll_Show  #####
' #############################
' Hides or displays the scrollbars for a window.
' hWnd = the handle of the window to set the scrollbars for
' horiz = $$TRUE to enable the horizontal scrollbar, $$FALSE otherwise
' vert = $$TRUE to enable the vertical scrollbar, $$FALSE otherwise
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXScroll_Show (hWnd, horiz, vert)
	XLONG style				' scrollbar style

	style = GetWindowLongA (hWnd, $$GWL_STYLE)
	IF horiz THEN
		style = style OR $$WS_HSCROLL
	ELSE
		style = style AND NOT $$WS_HSCROLL
	ENDIF
	IF vert THEN
		style = style OR $$WS_VSCROLL
	ELSE
		style = style AND NOT $$WS_VSCROLL
	ENDIF
	SetWindowLongA (hWnd, $$GWL_STYLE, style)
	SetWindowPos (hWnd, 0, 0, 0, 0, 0, $$SWP_NOMOVE OR $$SWP_NOSIZE OR $$SWP_NOZORDER OR $$SWP_FRAMECHANGED)

	RETURN $$TRUE		' success

END FUNCTION
'
' ###############################
' #####  WinXScroll_Update  #####
' ###############################
' Updates the client area of a window after a scroll.
' hWnd = the handle of the window to scroll
' deltaX = the distance to scroll horizontally
' deltaY = the distance to scroll vertically
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXScroll_Update (hWnd, deltaX, deltaY)
	RECT	rect

	GetClientRect (hWnd, &rect)

	ScrollWindowEx (hWnd, deltaX, deltaY, 0, &rect, 0, 0, $$SW_ERASE OR $$SW_INVALIDATE)
	RETURN $$TRUE

END FUNCTION
'
' ###########################
' #####  WinXSetCursor  #####
' ###########################
' Sets a window's cursor.
' hWnd = the handle of the window
' hCursor = the cursor
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXSetCursor (hWnd, hCursor)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	binding.hCursor = hCursor
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' #########################
' #####  WinXSetFont  #####
' #########################
' Sets the font for a control.
' hCtr = the handle of the control
' hFont = the handle of the font
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXSetFont (hCtr, hFont)

	IF hCtr THEN
		IFZ hFont THEN
			hFont = GetStockObject ($$DEFAULT_GUI_FONT)
		ENDIF
		SendMessageA (hCtr, $$WM_SETFONT, hFont, $$TRUE)
		RETURN $$TRUE
	ENDIF

END FUNCTION
'
' ############################
' #####  WinXSetMinSize  #####
' ############################
'
' Sets the minimum size for a window.
' hWnd = the window's handle
' min_width = the minimum width
' min_height = the minimum height of the client area
' returns $$TRUE if updated, or $$FALSE otherwise
'
FUNCTION WinXSetMinSize (hWnd, min_width, min_height)

	BINDING binding
	XLONG idBinding		' binding id
	XLONG bUpdated

	XLONG corr_w
	XLONG corr_h

	bUpdated = $$FALSE

	SELECT CASE hWnd
		CASE 0

		CASE ELSE
			' get the binding
			IFF Get_the_binding (hWnd, @idBinding, @binding) THEN EXIT SELECT		' fail

			IF min_width > 0 THEN
				binding.minW = min_width
				bUpdated = $$TRUE
			ENDIF

			IF min_height > 0 THEN
				binding.minH = min_height
				bUpdated = $$TRUE
			ENDIF

			IF bUpdated THEN
				' and update the binding
				bUpdated = binding_update (idBinding, binding)
			ENDIF

	END SELECT

	RETURN bUpdated

END FUNCTION
'
' ##############################
' #####  WinXSetPlacement  #####
' ##############################
' Sets the window placement.
' hWnd = the handle of the window
' minMax = minimised/maximised state, can be null in which case no changes are made
' restored = the restored position and size, can be null in which case not changes are made
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXSetPlacement (hWnd, minMax, RECT restored)

	WINDOWPLACEMENT wp
	RECT	rect
	XLONG bOK				' $$TRUE for success

	bOK = $$FALSE

	wp.length = SIZE(WINDOWPLACEMENT)
	IFZ GetWindowPlacement (hWnd, &wp) THEN RETURN $$FALSE

	IF wp.showCmd THEN wp.showCmd = minMax
	IF (restored.left OR restored.right OR restored.top OR restored.bottom) THEN wp.rcNormalPosition = restored

	IF SetWindowPlacement (hWnd, &wp) THEN
		bOK = $$TRUE		' success
	ENDIF

	GetClientRect (hWnd, &rect)
	sizeWindow (hWnd, (rect.right - rect.left), (rect.bottom - rect.top))

	RETURN bOK

END FUNCTION
'
' ##########################
' #####  WinXSetStyle  #####
' ##########################
' Changes the window styles of a window or a control.
' hWnd = the handle of the window the change the style of
' addStyle = the styles to add
' addEx = the extended styles to add
' subStyle = the styles to remove
' subEx = the extended styles to remove
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXSetStyle (hWnd, addStyle, addEx, subStyle, subEx)
	XLONG bOK				' $$TRUE for success
	XLONG ret				' win32 api return value (0 for fail)
'
' Window Style.
'
	XLONG styleUpdate			' = GetWindowLongA (hWnd, $$GWL_STYLE)
	XLONG styleOld				' old style
	XLONG styleNew				' new style

	XLONG state				' = 1: if $$ES_READONLY in addStyle => read only
'
' Extended Style.
'
	XLONG exStyleUpdate		' = GetWindowLongA (hWnd, $$GWL_EXSTYLE)
	XLONG exStyleNew			' new extended style

	XLONG sizeBuf		' size of the buffer

	SetLastError (0)

	IFZ hWnd THEN RETURN

	bOK = $$TRUE		' assume success

	SELECT CASE TRUE
		CASE addStyle = subStyle
			' do nothing

		CASE ELSE
			styleOld = GetWindowLongA (hWnd, $$GWL_STYLE)
			styleNew = styleOld

			' 1.Subtract before Adding
			IF subStyle THEN
				IF styleNew THEN
					IF styleNew = subStyle THEN
						styleNew = 0
					ELSE
						styleNew = styleNew & (~subStyle)		' clear the style to "subtract"
					ENDIF
				ENDIF
			ENDIF

			' 2.Add after Subtracting
			IFZ styleNew THEN
				styleNew = addStyle
			ELSE
				IF addStyle THEN
					styleNew = styleNew OR addStyle
				ENDIF
			ENDIF

			' styleUpdate the control only for a styleOld change
			IF styleNew = styleOld THEN EXIT SELECT

			SetWindowLongA (hWnd, $$GWL_STYLE, styleNew)

			' GL-18mar12-add or remove $$ES_READONLY flag with:
			' SendMessageA (handle, $$EM_SETREADONLY, On/off, 0)
			state = -1
			IF addStyle & $$ES_READONLY THEN state = 1		' if $$ES_READONLY in addStyle => read only
			IF subStyle & $$ES_READONLY THEN state = 0		' if $$ES_READONLY in subStyle => unprotected

			IF state >= 0 THEN SendMessageA (hWnd, $$EM_SETREADONLY, state, 0)

			' check styleUpdate
			styleUpdate = GetWindowLongA (hWnd, $$GWL_STYLE)
			IF styleUpdate <> styleNew THEN bOK = $$FALSE		' fail

	END SELECT

	SELECT CASE TRUE
		CASE addEx = subEx
			' do nothing

		CASE ELSE
			exStyleUpdate = GetWindowLongA (hWnd, $$GWL_EXSTYLE)
			exStyleNew = exStyleUpdate

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

			' 2.Add after Subtracting
			SELECT CASE 0
				CASE addEx		' nothing to add
				CASE exStyleNew : exStyleNew = addEx
				CASE ELSE : exStyleNew = exStyleNew OR addEx
			END SELECT

			' styleUpdate the control only for a exStyleUpdate change
			IF exStyleNew = exStyleUpdate THEN EXIT SELECT

			' list view's extended styleNew mask is set using:
			' SendMessageA (handle, $$LVM_SETEXTENDEDLISTVIEWSTYLE, ...
			sizeBuf = 128
			szBuf$ = NULL$ (sizeBuf)
			ret = GetClassNameA (hWnd, &szBuf$, sizeBuf)
			className$ = TRIM$(CSTRING$(&szBuf$))
			SELECT CASE className$
				CASE $$WC_LISTVIEW
					SendMessageA (hWnd, $$LVM_SETEXTENDEDLISTVIEWSTYLE, 0, exStyleNew)
					styleUpdate = SendMessageA (hWnd, $$LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)

				CASE $$WC_TABCONTROL
					SendMessageA (hWnd, $$TB_SETEXTENDEDSTYLE, 0, exStyleNew)
					styleUpdate = SendMessageA (hWnd, $$TB_GETEXTENDEDSTYLE, 0, 0)

				CASE ELSE
					SetWindowLongA (hWnd, $$GWL_EXSTYLE, exStyleNew)
					styleUpdate = GetWindowLongA (hWnd, $$GWL_EXSTYLE)

			END SELECT

			' check styleUpdate
			IF styleUpdate <> exStyleNew THEN bOK = $$FALSE		' fail

	END SELECT

	RETURN bOK

END FUNCTION
'
' #########################
' #####  WinXSetText  #####
' #########################
' Sets the text for a window/control.
' hWnd = the handle of the window/control
' text = the text to set
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXSetText (hWnd, STRING text)

	IFZ SetWindowTextA (hWnd, &text) THEN RETURN $$FALSE ELSE RETURN $$TRUE

END FUNCTION
'
' ################################
' #####  WinXSetWindowColor  #####
' ################################
' Changes the window background color.
' hWnd = the window to change the color for
' backRGB = the new background color
' returns $$TRUE on success, or $$FALSE on fail
' Note: Legacy wrapper to WinXSetWindowColour ().
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
'
' Changes the window background colour.
' hWnd = the window to change the colour for
' backRGB = the new background colour
' returns $$TRUE on success, or $$FALSE on fail
'
' Usage:
'	codeRGB = RGB (240, 240, 240)		' very light grey
'	WinXSetWindowColour (#winMain, codeRGB)
'
FUNCTION WinXSetWindowColour (hWnd, backRGB)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	IF binding.backCol THEN
		DeleteObject (binding.backCol)
		binding.backCol = 0
	ENDIF
	binding.backCol = CreateSolidBrush (backRGB)

	RETURN binding_update (idBinding, binding)

END FUNCTION
'
' ##################################
' #####  WinXSetWindowToolbar  #####
' ##################################
' Sets the window's toolbar.
' hWnd = the window to set
' hToolbar = the toolbar to use
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXSetWindowToolbar (hWnd, hToolbar)
	BINDING			binding
	XLONG		idBinding		' binding id

	IFZ hToolbar THEN RETURN $$FALSE

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	' set the toolbar parent
	SetParent (hToolbar, hWnd)

	' set the toolbar style
	SetWindowLongA (hToolbar, $$GWL_STYLE, GetWindowLongA (hToolbar, $$GWL_STYLE) OR $$WS_CHILD OR $$WS_VISIBLE OR $$CCS_TOP)

	SendMessageA (hToolbar, $$TB_SETPARENT, hWnd, 0)

	' and update the binding
	binding.hBar = hToolbar

	RETURN binding_update (idBinding, binding)

END FUNCTION
'
' ######################
' #####  WinXShow  #####
' ######################
' Shows a previously hidden window or control.
' hWnd = the handle of the control or window to show
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXShow (hWnd)
	IFZ hWnd THEN RETURN $$FALSE		' fail
	ShowWindow (hWnd, $$SW_SHOW)
	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXSplitter_GetPos  #####
' #################################
' Gets the current position of a splitter control.
' series = the series to which the splitter belongs
' hCtr = the control the splitter is attached to
' position = the variable to store the position of the splitter
' docked = the variable to store the docking state, $$TRUE when docked else $$FALSE
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXSplitter_GetPos (series, hCtr, @position, @docked)
	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]

	SPLITTERINFO splitter_block
	XLONG bFound		' $$TRUE: found
	XLONG i		' running index
	XLONG idSplitter		' id of the splitter
	XLONG bOK

	position = 0
	docked = $$FALSE
	bOK = $$FALSE

	SELECT CASE hCtr
		CASE 0
			msg$ = "WinX-WinXSplitter_GetPos: Null control handle"
			WinXDialog_Error (@msg$, @"WinX-Information", 0)

		CASE ELSE
			IF (series < 0) || (series > UBOUND (autoSizerInfoUM[])) THEN EXIT SELECT		' fail

			IFF autoSizerInfoUM[series].inUse THEN EXIT SELECT		' fail

			' Walk the list until we find the auto-draw block we need
			bFound = $$FALSE
			i = autoSizerInfoUM[series].iHead
			DO WHILE i > -1
				IF autoSizerInfo[series, i].hWnd = hCtr THEN
					bFound = $$TRUE
					EXIT DO
				ENDIF
				i = autoSizerInfo[series, i].nextItem
			LOOP

			IFF bFound THEN EXIT SELECT		' fail

			idSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
			bOK = SPLITTERINFO_Get (idSplitter, @splitter_block)
			IF bOK THEN
				' success
				IFZ splitter_block.docked THEN
					docked = $$FALSE		' 0 if not docked
					position = autoSizerInfo[series, i].size		' splitter block size
				ELSE
					docked = $$TRUE
					position = splitter_block.docked		' old position when docked
				ENDIF
			ENDIF

	END SELECT

	RETURN bOK

END FUNCTION
'
' #################################
' #####  WinXSplitter_SetPos  #####
' #################################
' Sets the current position of a splitter control.
' series = the series to which the splitter belongs
' hCtr = the control the splitter is attached to
' position = the new position for the splitter
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXSplitter_SetPos (series, hCtr, position, docked)
	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]

	XLONG bFound	' $$TRUE: found
	XLONG i				' running index

	SPLITTERINFO splitter_block
	RECT	rect
	XLONG idSplitter		' id of the splitter

	IFF series >= 0 && series <= UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[series].inUse THEN RETURN $$FALSE

	' Walk the list until we find the auto-sizer block we need
	bFound = $$FALSE
	i = autoSizerInfoUM[series].iHead
	DO WHILE i > -1
		IF autoSizerInfo[series, i].hWnd = hCtr THEN
			bFound = $$TRUE
			EXIT DO
		ENDIF
		i = autoSizerInfo[series, i].nextItem
	LOOP

	IFF bFound THEN RETURN $$FALSE

	idSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (idSplitter, @splitter_block)

	IF docked THEN
		autoSizerInfo[series, i].size = 8
		splitter_block.docked = position
	ELSE
		autoSizerInfo[series, i].size = position
		splitter_block.docked = 0
	ENDIF

	SPLITTERINFO_Update (idSplitter, splitter_block)

	GetClientRect (GetParent(hCtr), &rect)
	sizeWindow (GetParent(hCtr), (rect.right - rect.left), (rect.bottom - rect.top))

	RETURN $$TRUE

END FUNCTION
'
' ########################################
' #####  WinXSplitter_SetProperties  #####
' ########################################
' Sets splitter info.
' series = the series the control is located in
' hCtr = the handle of the control
' min = the minimum size of the control
' max = the maximum size of the control
' dock = $$TRUE to allow docking - else $$FALSE
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXSplitter_SetProperties (series, hCtr, min, max, dock)
	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]

	SPLITTERINFO splitter_block
	XLONG idSplitter		' id of the splitter
	XLONG bFound				' $$TRUE: found
	XLONG i							' running index

	IFF series >= 0 && series <= UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[series].inUse THEN RETURN $$FALSE

	' Walk the list until we find the auto-draw block we need
	bFound = $$FALSE
	i = autoSizerInfoUM[series].iHead
	DO WHILE i > -1
		IF autoSizerInfo[series, i].hWnd = hCtr THEN
			bFound = $$TRUE
			EXIT DO
		ENDIF
		i = autoSizerInfo[series, i].nextItem
	LOOP

	IFF bFound THEN RETURN $$FALSE

	idSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (idSplitter, @splitter_block)
	splitter_block.min = min
	splitter_block.max = max

	IF dock THEN
		IF autoSizerInfoUM[series].direction AND $$DIR_REVERSE THEN
			splitter_block.dock = $$DOCK_BACKWARD
		ELSE
			splitter_block.dock = $$DOCK_FORWARD
		ENDIF
	ELSE
		splitter_block.dock = $$DOCK_DISABLED
	ENDIF

	SPLITTERINFO_Update (idSplitter, splitter_block)

	RETURN $$TRUE

END FUNCTION
'
' #################################
' #####  WinXStatus_GetText$  #####
' #################################
' Retrieves the text from a status bar.
' hWnd = the window containing the status bar
' part = the part to get the text from
' returns the status text from the specified part of the status bar, or the empty string on fail
FUNCTION WinXStatus_GetText$ (hWnd, part)
	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG sizeBuf			' size of the buffer

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN ""

	IF part > binding.statusParts THEN RETURN ""

	sizeBuf = SendMessageA (binding.hStatus, $$SB_GETTEXTLENGTH, part, 0)
	ret$ = NULL$ (sizeBuf + 1)
	SendMessageA (binding.hStatus, $$SB_GETTEXT, part, &ret$)

	RETURN CSTRING$(&ret$)

END FUNCTION
'
' ################################
' #####  WinXStatus_SetText  #####
' ################################
' Sets the text in a status bar.
' hWnd = the window containing the status bar
' part = the partition to set the text for, zero-based
' text = the text to set the status to
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXStatus_SetText (hWnd, part, STRING text)
	BINDING			binding
	XLONG		idBinding		' binding id

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE		' fail

	IF part > binding.statusParts THEN RETURN $$FALSE		' fail

	SendMessageA (binding.hStatus, $$SB_SETTEXT, part, &text)
	RETURN $$TRUE		' success

END FUNCTION
'
' #############################
' #####  WinXTabs_AddTab  #####
' #############################
' Adds a new tab to a tabs control.
' hTabs = the handle of the tabs control
' label = the label for the new tab
' insertAfter = the index to insert at, -1 for to append
' returns the index of the new tab, or -1 on fail
FUNCTION WinXTabs_AddTab (hTabs, STRING label, insertAfter)
	TC_ITEM tci		' tabs control structure

	tci.mask = $$TCIF_PARAM OR $$TCIF_TEXT
	tci.pszText = &label
	tci.cchTextMax = LEN (label)
'
' (GL: autoSizerInfo_addGroup returns an index compatible with tci.lParam)
'
	tci.lParam = autoSizerInfo_addGroup ($$DIR_VERT)

	IF insertAfter < 0 THEN insertAfter = SendMessageA (hTabs, $$TCM_GETITEMCOUNT, 0, 0)

	RETURN SendMessageA (hTabs, $$TCM_INSERTITEM, insertAfter, &tci)

END FUNCTION
'
' ################################
' #####  WinXTabs_DeleteTab  #####
' ################################
' Deletes a tab in a tabs control
' hTabs = the handle the tabs control
' iTab = the index of the tab to delete
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXTabs_DeleteTab (hTabs, iTab)

	RETURN SendMessageA (hTabs, $$TCM_DELETEITEM, iTab, 0)

END FUNCTION
'
' ########################################
' #####  WinXTab_GetAutosizerSeries  #####
' ########################################
' Gets the auto-sizer series for a tabs control.
' hTabs = the tabs control
' iTab = the index of the tab to get the auto-sizer series for
' returns the id (index) of the auto-sizer series, or -1 on fail
FUNCTION WinXTabs_GetAutosizerSeries (hTabs, iTab)
	TC_ITEM tci		' tabs control structure

	tci.mask = $$TCIF_PARAM
	IFF SendMessageA (hTabs, $$TCM_GETITEM, iTab, &tci) THEN
		RETURN -1		' fail
	ENDIF

	RETURN tci.lParam

END FUNCTION
'
' ####################################
' #####  WinXTabs_GetCurrentTab  #####
' ####################################
' Gets the index of the currently selected tab.
' hTabs = the handle of the tabs control
' returns the index of the currently selected tab
FUNCTION WinXTabs_GetCurrentTab (hTabs)

	RETURN SendMessageA (hTabs, $$TCM_GETCURSEL, 0, 0)

END FUNCTION
'
' ####################################
' #####  WinXTabs_SetCurrentTab  #####
' ####################################
' Sets the current tab.
' hTabs = the tabs control
' iTab = the index of the new current tab
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXTabs_SetCurrentTab (hTabs, iTab)
	XLONG bOK				' $$TRUE for success
	XLONG ret				' win32 api return value (0 for fail)
	XLONG count			' = SendMessageA (hTabs, $$TCM_GETITEMCOUNT, 0, 0)

	SetLastError (0)
	bOK = $$FALSE

	IF hTabs THEN
		count = SendMessageA (hTabs, $$TCM_GETITEMCOUNT, 0, 0)
		IF count > 0 THEN
			IF iTab < 0 THEN iTab = 0		' select first tabstrip
			IF iTab >= count THEN iTab = count - 1		' select last tabstrip

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
' Gets the time from a Date/Time Picker control.
' hDTP = the handle of the control
' time = the structure to store the time
' r_timeValid = $$TRUE only if the returned time is valid
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXTimePicker_GetTime (hDTP, SYSTEMTIME time, @r_timeValid)
	XLONG bOK				' $$TRUE for success

	SetLastError (0)
	bOK = $$TRUE
	r_timeValid = $$FALSE		' invalid

	SELECT CASE SendMessageA (hDTP, $$DTM_GETSYSTEMTIME, 0, &time)
		CASE $$GDT_VALID
			r_timeValid = $$TRUE		' valid

		CASE $$GDT_ERROR
			bOK = $$FALSE
			msg$ = "WinX-WinXTimePicker_GetTime: Can't get the time from Date/Time picker"
			WinXDialog_Error (@msg$, @"WinX-Alert", 2)

	END SELECT

	RETURN bOK

END FUNCTION
'
' ####################################
' #####  WinXTimePicker_SetTime  #####
' ####################################
' Sets the time for a Date/Time Picker control.
' hDTP = the handle of the control
' time = the time to set the control to
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXTimePicker_SetTime (hDTP, SYSTEMTIME time, timeValid)
	XLONG ret				' win32 api return value (0 for fail)
	XLONG wParam
	XLONG lParam
	XLONG bErr			' $$TRUE for error

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
			RETURN $$TRUE		' success
		ELSE
			msg$ = "WinX-WinXTimePicker_SetTime$: Can't set the time for a Date/Time Picker control"
			bErr = GuiTellApiError (@msg$)
			IFF bErr THEN WinXDialog_Error (@msg$, @"WinX-Alert", 2)
		ENDIF
	ENDIF

END FUNCTION
'
' ###################################
' #####  WinXToolbar_AddButton  #####
' ###################################
' Adds a button to a toolbar.
' hToolbar = the toolbar to add the button to
' commandId = the id for the button
' iImage = the index of the image to use for the button
' tooltipText = the text to use for the tooltip
' optional = $$TRUE if this button is optional, otherwise $$FALSE
'  !!THIS FEATURE IS NOT YET IMPLEMENTED, YOU SHOULD SET THIS PARAMETER TO $$FALSE!!
' moveable = $$TRUE if the button can be move, otherwise $$FALSE
'  !!THIS FEATURE IS NOT YET IMPLEMENTED, YOU SHOULD SET THIS PARAMETER TO $$FALSE!!
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXToolbar_AddButton (hToolbar, commandId, iImage, STRING tooltipText, optional, moveable)
	TBBUTTON bt

	bt.iBitmap = iImage
	bt.idCommand = commandId
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_AUTOSIZE OR $$BTNS_BUTTON
	bt.iString = &tooltipText

	RETURN SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)

END FUNCTION
'
' ####################################
' #####  WinXToolbar_AddControl  #####
' ####################################
' Adds a control to a toolbar control.
' hToolbar = the handle of the tool bar to add the control to
' hControl = the handle of the control
' w = the width of the control in the tool bar, the control will be resized to the height of the tool bar and this width
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXToolbar_AddControl (hToolbar, hControl, w)
	TBBUTTON bt
	RECT	rect2
	XLONG count

	bt.iBitmap = w + 4
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_SEP

	count = SendMessageA (hToolbar, $$TB_BUTTONCOUNT, 0, 0)
	SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	SendMessageA (hToolbar, $$TB_GETITEMRECT, count, &rect2)

	MoveWindow (hControl, (rect2.left + 2), rect2.top, w, (rect2.bottom - rect2.top), $$TRUE)

	SetParent (hControl, hToolbar)

	RETURN $$TRUE		' success

END FUNCTION
'
' ######################################
' #####  WinXToolbar_AddSeparator  #####
' ######################################
' Adds a separator to a toolbar.
' hToolbar = the toolbar to add the separator to
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXToolbar_AddSeparator (hToolbar)
	TBBUTTON bt

	bt.iBitmap = 4
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_SEP

	RETURN SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)

END FUNCTION
'
' #########################################
' #####  WinXToolbar_AddToggleButton  #####
' #########################################
' Adds a toggle button to a toolbar.
' hToolbar = the handle of the toolbar
' commandId = the command constant the button will generate
' iImage = the zero-based index of the image for this button
' tooltipText = the text for this button's tooltip
' mutex = $$TRUE if this toggle is mutually exclusive, ie. only one from a group can be toggled at a time
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXToolbar_AddToggleButton (hToolbar, commandId, iImage, STRING tooltipText, mutex, optional, moveable)
	TBBUTTON bt

	bt.iBitmap = iImage
	bt.idCommand = commandId
	bt.fsState = $$TBSTATE_ENABLED

	IF mutex THEN
		bt.fsStyle = $$BTNS_CHECKGROUP
	ELSE
		bt.fsStyle = $$BTNS_CHECK
	ENDIF

	bt.fsStyle = bt.fsStyle OR $$BTNS_AUTOSIZE

	bt.iString = &tooltipText

	RETURN SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)

END FUNCTION
'
' ######################################
' #####  WinXToolbar_EnableButton  #####
' ######################################
' Enables or disables a toolbar button.
' hToolbar = the handle of the toolbar on which the button resides
' idButton = the command id of the button
' enable = $$TRUE to enable the button, $$FALSE to disable
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXToolbar_EnableButton (hToolbar, idButton, enable)

	RETURN SendMessageA (hToolbar, $$TB_ENABLEBUTTON, idButton, enable)

END FUNCTION
'
' ######################################
' #####  WinXToolbar_ToggleButton  #####
' ######################################
' Toggles a toolbar button.
' hToolbar = the handle of the toolbar on which the button resides
' idButton = the command id of the button
' on = $$TRUE to toggle the button on, $$FALSE to toggle the button off
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXToolbar_ToggleButton (hToolbar, idButton, on)

	XLONG state

	SetLastError (0)
	IF hToolbar THEN
		state = SendMessageA (hToolbar, $$TB_GETSTATE, idButton, 0)
		IF on THEN
			state = state OR $$TBSTATE_CHECKED
		ELSE
			' clear the state to "subtract"
			state = state AND NOT ($$TBSTATE_CHECKED)
		ENDIF

		SendMessageA (hToolbar, $$TB_SETSTATE, idButton, state)
	ENDIF

END FUNCTION
'
' ################################
' #####  WinXTracker_GetPos  #####
' ################################
' Gets the position of the slider in a tracker bar.
' hTracker = the handle of the tracker
' returns the position of the slider
FUNCTION WinXTracker_GetPos (hTracker)

	SetLastError (0)
	IF hTracker THEN
		RETURN SendMessageA (hTracker, $$TBM_GETPOS, 0, 0)
	ENDIF

END FUNCTION
'
' ###################################
' #####  WinXTracker_SetLabels  #####
' ###################################
' Sets the labels for the start and end of a track bar.
' hTracker = the handle of the tracker control
' leftLabel = the label for the left of the tracker
' rightLabel = the label for the right of the tracker
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXTracker_SetLabels (hTracker, STRING leftLabel, STRING rightLabel)
	SIZEAPI left
	SIZEAPI right

	XLONG hLeft				' = SendMessageA (hTracker, $$TBM_GETBUDDY, $$TRUE, 0)
	XLONG hRight			' = SendMessageA (hTracker, $$TBM_GETBUDDY, $$FALSE, 0)
	XLONG hParent			' parent control of the tracker

	XLONG hdcMem		' the handle of the compatible context

	SetLastError (0)
	IFZ hTracker THEN RETURN $$FALSE

	' first, get any existing labels
	hLeft = SendMessageA (hTracker, $$TBM_GETBUDDY, $$TRUE, 0)
	hRight = SendMessageA (hTracker, $$TBM_GETBUDDY, $$FALSE, 0)

	IF hLeft THEN DestroyWindow (hLeft)
	IF hRight THEN DestroyWindow (hRight)

	' we need to get the width and height of the strings
	hdcMem = CreateCompatibleDC (0)
	SelectObject (hdcMem, GetStockObject ($$DEFAULT_GUI_FONT))
	GetTextExtentPoint32A (hdcMem, &leftLabel, LEN (leftLabel), &left)
	GetTextExtentPoint32A (hdcMem, &rightLabel, LEN (rightLabel), &right)
	DeleteDC (hdcMem)
	hdcMem = 0

	'now create the windows
	hParent = GetParent(hTracker)

	hLeft = WinXAddStatic (hParent, leftLabel, 0, $$SS_CENTER, 1)
	MoveWindow (hLeft, 0, 0, (left.cx + 4), (left.cy + 4), $$TRUE)		' repaint

	hRight = WinXAddStatic (hParent, rightLabel, 0, $$SS_CENTER, 1)
	MoveWindow (hRight, 0, 0, (right.cx + 4), (right.cy + 4), $$TRUE)		' repaint

	' and set them
	SendMessageA (hTracker, $$TBM_SETBUDDY, $$TRUE, hLeft)
	SendMessageA (hTracker, $$TBM_SETBUDDY, $$FALSE, hRight)

	RETURN $$TRUE		' success

END FUNCTION
'
' ################################
' #####  WinXTracker_SetPos  #####
' ################################
' Sets the position of the slider in a track bar.
' hTracker = the handle of the tracker
' newPos = the new position of the slider
' returns $$TRUE on success, or $$FALSE on fail
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
' Sets the range for a track bar.
' hTracker = the control to set the range for
' min = the minimum value for the tracker
' max = the maximum value for the tracker
' ticks = the number of units per tick
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXTracker_SetRange (hTracker, USHORT min, USHORT max, ticks)

	SetLastError (0)
	IF hTracker THEN
		SendMessageA (hTracker, $$TBM_SETRANGE, $$TRUE, MAKELONG (min, max))
		SendMessageA (hTracker, $$TBM_SETTICFREQ, ticks, 0)
		RETURN $$TRUE		' success
	ENDIF

END FUNCTION
'
' #####################################
' #####  WinXTracker_SetSelRange  #####
' #####################################
' Sets the selection range for a track bar.
' hTracker = the handle of the tracker
' start = the start of the selection
' end  = the end of the selection
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXTracker_SetSelRange (hTracker, USHORT start, USHORT end)

	SetLastError (0)
	IF hTracker THEN
		SendMessageA (hTracker, $$TBM_SETSEL, $$TRUE, MAKELONG (start, end))
		RETURN $$TRUE		' success
	ENDIF

END FUNCTION
'
' ##################################
' #####  WinXListView_AddItem  #####
' ##################################
' Adds a new item to a list view.
' iItem = the index at which to insert the item, -1 to add to the end of the list
' item = the label for the main item plus the sub-items
'        as: "label\0subItem1\0subItem2...",
'        or: "label|subItem1|subItem2...".
' iIcon = the index to the icon/image or -1 if this item has no icon
' returns the index of the new item, or -1 on fail
'
' Usage:
'	item$ = "Item 1|E|A|5"		' (silly example of listview item)
'	indexAdd = WinXListView_AddItem (hLV, -1, item$, -1)		' add last
'	IF indexAdd < 0 THEN
'		msg$ = "WinXListView_AddItem: Can't add listview item '" + item$ + "'"
'		XstAlert (@msg$)
'	ENDIF
'
FUNCTION WinXTreeView_AddItem (hTV, hParent, hNodeAfter, iImage, iImageSelect, label$)

	TV_INSERTSTRUCT tvis
	TV_ITEM tvi
	XLONG r_hNode

	SetLastError (0)
	r_hNode = 0

	IF hTV THEN
		IFZ hParent THEN
			hParent = $$TVI_ROOT
			hNodeAfter = $$TVI_LAST
		ENDIF
		tvi.mask = $$TVIF_TEXT OR $$TVIF_IMAGE OR $$TVIF_SELECTEDIMAGE OR $$TVIF_PARAM
		tvi.pszText = &label$
		tvi.cchTextMax = LEN (label$)

		tvi.iImage = iImage
		tvi.iSelectedImage = iImageSelect
		tvi.lParam = 0		' no data

		tvis.hParent = hParent
		tvis.hInsertAfter = hNodeAfter
		tvis.item = tvi

		SetLastError (0)
		r_hNode = SendMessageA (hTV, $$TVM_INSERTITEM, 0, &tvis)
		IFZ r_hNode THEN
			msg$ = "WinX-WinXTreeView_AddItem: Can't add new treeview node " + label$
			GuiTellApiError (@msg$)
		ENDIF
	ENDIF

	RETURN r_hNode

END FUNCTION
'
' ###################################
' #####  WinXTreeView_MoveItem  #####
' ###################################
' Move an item and it's children
' hTV = the hnalde to the tree vire control
' hParentItem = The parent of the item to move this item to
' hItemInsertAfter = The item that will come before this item
' hNode = the item to move
' returns the new handle of the item
FUNCTION WinXTreeView_CopyItem (hTV, hParentItem, hItemInsertAfter, hNode)

	TV_ITEM tvi
	TV_INSERTSTRUCT tvis
	XLONG child			' tree view child item
	XLONG prevChild			' previous child item

	tvi.mask = $$TVIF_CHILDREN OR $$TVIF_HANDLE OR $$TVIF_IMAGE OR $$TVIF_PARAM OR $$TVIF_SELECTEDIMAGE OR $$TVIF_STATE OR $$TVIF_TEXT
	tvi.hItem = hNode
	szBuf$ = NULL$ (512)
	tvi.pszText = &szBuf$
	tvi.cchTextMax = 512
	tvi.stateMask = 0xFFFFFFFF
	SendMessageA (hTV, $$TVM_GETITEM, 0, &tvi)
	tvis.hParent = hParentItem
	tvis.hInsertAfter = hItemInsertAfter
	tvis.item = tvi
	tvis.item.mask = $$TVIF_IMAGE OR $$TVIF_PARAM OR $$TVIF_SELECTEDIMAGE OR $$TVIF_STATE OR $$TVIF_TEXT
	tvis.item.cChildren = 0
	tvis.item.hItem = SendMessageA (hTV, $$TVM_INSERTITEM, 0, &tvis)

	IF tvi.cChildren THEN
		child = WinXTreeView_GetChildItem (hTV, hNode)
		WinXTreeView_CopyItem (hTV, tvis.item.hItem, $$TVI_FIRST, child)
		prevChild = child
		child = WinXTreeView_GetNextItem (hTV, prevChild)
		DO WHILE child
			WinXTreeView_CopyItem (hTV, tvis.item.hItem, prevChild, child)
			prevChild = child
			child = WinXTreeView_GetNextItem (hTV, prevChild)
		LOOP
	ENDIF

	RETURN tvis.item.hItem

END FUNCTION
'
' #####################################
' #####  WinXTreeView_DeleteItem  #####
' #####################################
' Delete an item, including all children.
' hTV = the handle of the tree view
' hNode = the handle of the item to delete
' returns $$TRUE on success or $$FALSE
FUNCTION WinXTreeView_DeleteItem (hTV, hNode)

	RETURN SendMessageA (hTV, $$TVM_DELETEITEM, 0, hNode)

END FUNCTION
'
' #######################################
' #####  WinXTreeView_GetChildItem  #####
' #######################################
'	/*
'	[WinXTreeView_GetChildItem]
' Description = Gets the first child of a tree view control node.
' Function    = WinXTreeView_GetChildItem
' ArgCount    = 2
'	Arg1        = hTV: the handle of the tree view control
'	Arg2        = hNode: the node to get the first child from
' Return      = Returns the handle of the child item, or 0 on fail
' Remarks     = Uses API call: hChild = SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_CHILD, hNode)
'	See Also    =
'	Examples    = hChild = WinXTreeView_GetChildItem (hTV, hNode)
'	*/
FUNCTION WinXTreeView_GetChildItem (hTV, hNode)

	SetLastError (0)
	IF hTV THEN
		RETURN SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_CHILD, hNode)
	ENDIF

END FUNCTION
'
' ###########################################
' #####  WinXTreeView_GetItemFromPoint  #####
' ###########################################
'	/*
'	[WinXTreeView_GetItemFromPoint]
' Description = Gets a tree view control node given its coordinates.
' Function    = WinXTreeView_GetItemFromPoint
' ArgCount    = 3
'	Arg1        = hTV: the handle of the tree view control to get the item from
'	Arg2        = x: the x coordinate
'	Arg3        = y: the y coordinate
' Return      = returns a tree view control node handle, or 0 on fail
' Remarks     = Uses API call: index = SendMessageA (hTV, $$TVM_HITTEST, 0, &tvHit)
'	See Also    =
'	Examples    = hNode = WinXTreeView_GetItemFromPoint (hTV, x, y)
'	*/
FUNCTION WinXTreeView_GetItemFromPoint (hTV, x, y)

	TV_HITTESTINFO tvHit

	tvHit.pt.x = x
	tvHit.pt.y = y
	RETURN SendMessageA (hTV, $$TVM_HITTEST, 0, &tvHit)

END FUNCTION
'
' ########################################
' #####  WinXTreeView_GetItemLabel$  #####
' ########################################
' Gets the label from a tree view item.
' hTV = the handle of the tree view
' hNode = the item to get the label from
' returns the item label or "" on fail
FUNCTION WinXTreeView_GetItemLabel$ (hTV, hNode)
	TVITEM tvi

	szBuf$ = NULL$ (256)
	tvi.mask = $$TVIF_HANDLE OR $$TVIF_TEXT
	tvi.hItem = hNode
	tvi.pszText = &szBuf$
	tvi.cchTextMax = 255
	IFF SendMessageA (hTV, $$TVM_GETITEM, 0, &tvi) THEN RETURN ""

	RETURN CSTRING$(&szBuf$)

END FUNCTION
'
' ######################################
' #####  WinXTreeView_GetNextItem  #####
' ######################################
' Gets the next item in the tree view.
' hTV = the handle of the tree view
' hNode = the handle of the item to start from
' returns the handle of the next item or 0 on error
FUNCTION WinXTreeView_GetNextItem (hTV, hNode)

	RETURN SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_NEXT, hNode)

END FUNCTION
'
' ########################################
' #####  WinXTreeView_GetParentItem  #####
' ########################################
' Gets the parent of an item in a tree view
' hTV = the handle ot the tree view
' hNode = the item to get the parent of
' returns the handle of the parent, or $$TVI_ROOT if hNode has no hParent.
FUNCTION WinXTreeView_GetParentItem (hTV, hNode)

	RETURN SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_PARENT, hNode)

END FUNCTION
'
' ##########################################
' #####  WinXTreeView_GetPreviousItem  #####
' ##########################################
' Gets the item that comes before a tree view item
' hTV = the handle of the tree view
' returns the handle of the previous item or 0 on error
FUNCTION WinXTreeView_GetPreviousItem (hTV, hNode)

	RETURN SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_PREVIOUS, hNode)

END FUNCTION
'
' #######################################
' #####  WinXTreeView_GetSelection  #####
' #######################################
' Gets the current selection from a tree view control.
' hTV = the tree view control
' returns the handle of the selected item
FUNCTION WinXTreeView_GetSelection (hTV)

	RETURN SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_CARET, 0)

END FUNCTION
'
' #######################################
' #####  WinXTreeView_SetItemLabel  #####
' #######################################
'	/*
'	[WinXTreeView_SetItemLabel]
' Description = Sets the label attribute of the passed tree view control node.
' Function    = WinXTreeView_SetItemLabel()
' ArgCount    = 3
'	Arg1        = hTV: the handle of the tree view control
'	Arg2        = hNode: the handle of the node to set the selection to, 0 to remove selection
'	Arg3        = STRING newLabel: the new text
' Return      = $$TRUE on success, or $$FALSE on fail
' Remarks     = Uses API call: ret = SendMessageA (hTV, $$TVM_SETITEM, 0, &tvi)
'	See Also    = All functions prefixed by WinXTreeView_
'	Examples    = bOK = WinXTreeView_SetItemLabel (hTV, hNode, newLabel$)
'	*/
FUNCTION WinXTreeView_SetItemLabel (hTV, hNode, STRING newLabel)

	TVITEM tvi

	tvi.mask = $$TVIF_HANDLE OR $$TVIF_TEXT
	tvi.hItem = hNode
	tvi.pszText = &newLabel
	tvi.cchTextMax = LEN (newLabel)

	RETURN SendMessageA (hTV, $$TVM_SETITEM, 0, &tvi)

END FUNCTION
'
' #######################################
' #####  WinXTreeView_SetSelection  #####
' #######################################
' Sets the selection for a tree view control
' hTV = handle of the new tree view
' hNode = handle of the new item to set the selection to, 0 to remove selection
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXTreeView_SetSelection (hTV, hNode)

	RETURN SendMessageA (hTV, $$TVM_SELECTITEM, $$TVGN_CARET, hNode)

END FUNCTION
'
' ######################
' #####  WinXUndo  #####
' ######################
' Undoes a drawing operation.
' idDraw = the id (index) of the block of the operation
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXUndo (hWnd, idDraw)

	AUTODRAWRECORD record
	BINDING			binding
	XLONG		idBinding		' binding id
	LINKEDLIST autoDraw
	XLONG bOK				' $$TRUE for success

	SetLastError (0)
	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

'	LINKEDLIST_Get (binding.autoDrawInfo, @autoDraw)
'	LinkedList_GetItem (autoDraw, idDraw, @idDraw)

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
' 0.6.0.2-old===
' 0.6.0.2-new+++
	IF record.text.iString THEN
		STRING_Delete (record.text.iString)
		record.text.iString = 0
	ENDIF
' 0.6.0.2-new===
'
	AUTODRAWRECORD_Update (idDraw, record)

'	LinkedList_DeleteItem (@autoDraw, idDraw)
'	LINKEDLIST_Update (binding.autoDrawInfo, @autoDraw)

	' and update the binding
	bOK = binding_update (idBinding, binding)

	RETURN bOK

END FUNCTION
'
' ########################
' #####  WinXUpdate  #####
' ########################
' Updates the specified window.
' hWnd = the handle of the window
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION WinXUpdate (hWnd)
	BINDING			binding
	XLONG		idBinding		' binding id
	RECT	rect

	SetLastError (0)
	'WinXGetUseableRect (hWnd, @rect)
	'InvalidateRect (hWnd, &rect, $$TRUE)

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

'	PRINT binding.hUpdateRegion
	InvalidateRgn (hWnd, binding.hUpdateRegion, $$TRUE)
	DeleteObject (binding.hUpdateRegion)
	binding.hUpdateRegion = 0
	RETURN binding_update (idBinding, binding)

END FUNCTION
'
' ##########################
' #####  WinXVersion$  #####
' ##########################
'	/*
'	[WinXVersion$]
' Description = Gets library WinX current version.
' Function    = WinXVersion$()
' ArgCount    = 0
' Return      = WinX current version
'	Examples    = version$ = WinXVersion$ ()
'	*/
FUNCTION WinXVersion$ ()

	version$ = VERSION$ (0)
	RETURN (version$)

END FUNCTION
'
' ##############################
' #####  cancelDlgOnClose  #####
' ##############################
' onClose callback function for the cancel printing dialog box.
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
' onCommand callback function for the cancel printing dialog box.
FUNCTION cancelDlgOnCommand (id, code, hWnd)
	SHARED	PRINTINFO	printInfo

	SetLastError (0)
	IF printInfo.hCancelDlg THEN
		SELECT CASE id
			CASE $$IDCANCEL		' cancel button
				SendMessageA (printInfo.hCancelDlg, $$WM_CLOSE, 0, 0)
		END SELECT
	ENDIF

END FUNCTION
'
' ###########################
' #####  initPrintInfo  #####
' ###########################
FUNCTION initPrintInfo ()
	SHARED	PRINTINFO	printInfo
	PAGESETUPDLG pageSetupDlg

	'pageSetupDlg.lStructSize = SIZE(PAGESETUPDLG)
	'pageSetupDlg.flags = $$PSD_DEFAULTMINMARGINS OR $$PSD_RETURNDEFAULT
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

END FUNCTION
'
' ############################
' #####  printAbortProc  #####
' ############################
' Abort proc for printing.
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
'
' 0.6.0.2-new+++
		' If the message is $$WM_QUIT, exit the WHILE loop
		IF msg.message = $$WM_QUIT THEN EXIT DO
' 0.6.0.2-new===
'
	LOOP

	RETURN printInfo.continuePrinting

END FUNCTION
'
' Deletes a AUTODRAWRECORD item from AUTODRAWRECORD Pool.
' id = id of the AUTODRAWRECORD item to delete
' returns bOK: $$TRUE on success
'
' Usage:
' bOK = AUTODRAWRECORD_Delete (AUTODRAWRECORD_id)
' IFF bOK THEN
' 	msg$ = "AUTODRAWRECORD_Delete: Can't delete the AUTODRAWRECORD item of id = " + STRING$ (AUTODRAWRECORD_id)
' 	PRINT msg$
' ENDIF
'
FUNCTION AUTODRAWRECORD_Delete (id)
	SHARED AUTODRAWRECORD AUTODRAWRECORDarray[]
	SHARED SBYTE AUTODRAWRECORDarrayUM[]

	AUTODRAWRECORD null_item
	XLONG slot		' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(AUTODRAWRECORDarrayUM[])) THEN
		AUTODRAWRECORDarray[slot] = null_item
		AUTODRAWRECORDarrayUM[slot] = $$FALSE
		bOK = $$TRUE
	ENDIF

	RETURN bOK

END FUNCTION
'
' Gets a AUTODRAWRECORD item from the AUTODRAWRECORD Pool.
' id = id of the AUTODRAWRECORD item to get
' item = returned item
' returns bOK: $$TRUE on success
'
' Usage:
' bOK = AUTODRAWRECORD_Get (AUTODRAWRECORD_id, @AUTODRAWRECORD_item)
' IFF bOK THEN
' 	msg$ = "AUTODRAWRECORD_Get: Can't get the AUTODRAWRECORD item of id = " + STRING$ (AUTODRAWRECORD_id)
' 	PRINT msg$
' ENDIF
'
FUNCTION AUTODRAWRECORD_Get (id, AUTODRAWRECORD item)
	SHARED AUTODRAWRECORD AUTODRAWRECORDarray[]
	SHARED SBYTE AUTODRAWRECORDarrayUM[]

	AUTODRAWRECORD null_item
	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(AUTODRAWRECORDarrayUM[])) THEN
		IF AUTODRAWRECORDarrayUM[slot] THEN
			item = AUTODRAWRECORDarray[slot]
			bOK = $$TRUE
		ENDIF
	ENDIF
	IFF bOK THEN
		item = null_item
	ENDIF
	RETURN bOK

END FUNCTION
'
' Initializes the AUTODRAWRECORD Pool.
'
FUNCTION AUTODRAWRECORD_Init ()
	SHARED AUTODRAWRECORD AUTODRAWRECORDarray[]		' array of AUTODRAWRECORD items
	SHARED SBYTE AUTODRAWRECORDarrayUM[]		' usage map so we can see which AUTODRAWRECORDarray[] elements are in use

	XLONG slot		' array index

	AUTODRAWRECORD null_item

	IFZ AUTODRAWRECORDarray[] THEN
		DIM AUTODRAWRECORDarray[7]
		DIM AUTODRAWRECORDarrayUM[7]
	ENDIF
	FOR slot = UBOUND(AUTODRAWRECORDarrayUM[]) TO 0 STEP -1
		AUTODRAWRECORDarray[slot] = null_item
		AUTODRAWRECORDarrayUM[slot] = $$FALSE
	NEXT slot

END FUNCTION
'
' Adds a new AUTODRAWRECORD item to AUTODRAWRECORD Pool.
' returns the new AUTODRAWRECORD item id, 0 on fail
'
' Usage:
' AUTODRAWRECORD_id = AUTODRAWRECORD_New (AUTODRAWRECORD_item)
' IFZ AUTODRAWRECORD_id THEN
' msg$ = "AUTODRAWRECORD_New: Can't add a new item to AUTODRAWRECORD Pool"
' PRINT msg$
' ENDIF
'
FUNCTION AUTODRAWRECORD_New (AUTODRAWRECORD item)
	SHARED AUTODRAWRECORD AUTODRAWRECORDarray[]
	SHARED SBYTE AUTODRAWRECORDarrayUM[]

	AUTODRAWRECORD null_item
	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index

	IFZ AUTODRAWRECORDarrayUM[] THEN AUTODRAWRECORD_Init ()

	slot = -1		' not an index

	' look for a blank slot
	upper_slot = UBOUND(AUTODRAWRECORDarrayUM[])
	FOR i = 0 TO upper_slot
		IFF AUTODRAWRECORDarrayUM[i] THEN
			' reuse this open slot
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	' allocate more memory if needed
	IF slot < 0 THEN
		' no open slots found => add a bunch of new open slots
		slot = upper_slot + 1

		' expand both AUTODRAWRECORDarray[] and AUTODRAWRECORDarrayUM[]
		upper_slot = (2 * slot) + 3
		REDIM AUTODRAWRECORDarray[upper_slot]
		REDIM AUTODRAWRECORDarrayUM[upper_slot]

		' reset the leftover of AUTODRAWRECORD items
		FOR i = slot TO upper_slot
			AUTODRAWRECORDarray[i] = null_item
		NEXT i
	ENDIF

	IF slot >= 0 THEN
		AUTODRAWRECORDarray[slot] = item
		AUTODRAWRECORDarrayUM[slot] = $$TRUE
	ENDIF

	RETURN (slot + 1)

END FUNCTION
'
' Updates an existing AUTODRAWRECORD item.
' id = id of the AUTODRAWRECORD item to update
' item = the new AUTODRAWRECORD item's data
' returns bOK: $$TRUE on success
'
' Usage:
' bOK = AUTODRAWRECORD_Update (AUTODRAWRECORD_id, AUTODRAWRECORD_item)
' IFF bOK THEN
' 	msg$ = "AUTODRAWRECORD_Update: Can't update the AUTODRAWRECORD item of id = " + STRING$ (AUTODRAWRECORD_id)
' 	PRINT msg$
' ENDIF
'
FUNCTION AUTODRAWRECORD_Update (id, AUTODRAWRECORD item)
	SHARED AUTODRAWRECORD AUTODRAWRECORDarray[]
	SHARED SBYTE AUTODRAWRECORDarrayUM[]

	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(AUTODRAWRECORDarrayUM[])) THEN
		IF AUTODRAWRECORDarrayUM[slot] THEN
			AUTODRAWRECORDarray[slot] = item
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK

END FUNCTION
'
' A wrapper for the misdefined AlphaBlend function.
'
FUNCTION ApiAlphaBlend (hdcDest, nXOriginDest, nYOrigDest, nWidthDest, nHeightDest, hdcSrc, nXOriginSrc, nYOriginSrc, nWidthSrc, nHeightSrc, BLENDFUNCTION blendFunction)
	XLONG args[10]
	XLONG ret				' win32 api return value (0 for fail)

	SetLastError (0)

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
	args[10] = XLONGAT(&blendFunction)

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
	RETURN XstCall ("LBItemFromPt", "comctl32.dll", @args[])

END FUNCTION
'
' #####################
' #####  CleanUp  #####
' #####################
'
' Program Clean-Up on Exit.
' This is where you clean up any resources that need to be deallocated.
'
FUNCTION CleanUp ()

	SHARED STRING g_bReentry					' ensure WinX() is re-entered next time
	SHARED g_hInst						' handle of current module
	SHARED g_hClipMem					' global memory for clipboard operations
	SHARED g_drag_image				' image list for the dragging effect
	SHARED BINDING bindings[]
	XLONG idBinding			' binding id

	XLONG window_handle[]	' local copy of the array of active windows
	XLONG slot					' array index
	XLONG upper_slot		' upper slot

	XLONG bDebugMode		' $$TRUE for DEBUG mode
	XLONG bErr					' $$TRUE for error
	XLONG ret						' win32 api return value (0 for fail)

	IFZ g_hInst THEN
		g_hInst = GetModuleHandleA (0)
	ENDIF
'
' Free global allocated memory.
'
	' global memory needed for clipboard operations
	IF g_hClipMem THEN GlobalFree (g_hClipMem)
	g_hClipMem = 0		' don't free twice
'
' Delete the image list created by CreateDragImage().
'
	IF g_drag_image THEN ImageList_Destroy (g_drag_image)
	g_drag_image = 0

	upper_slot = UBOUND (bindings[])
	SELECT CASE upper_slot
		CASE -1
			' the binding array is empty

		CASE ELSE
			'
			' 1.Preserve the window handles when they are still available.
			'
			DIM window_handle[upper_slot]

			FOR slot = 0 TO upper_slot
				' preserve the window's handle
				window_handle[slot] = bindings[slot].hWnd

				' hide the window to prevent from crashing
				ShowWindow (window_handle[slot], $$SW_HIDE)
			NEXT slot
			'
			' 2.Destroy backwards all the windows
			' to destroy the main window last.
			'
			FOR slot = upper_slot TO 0 STEP -1
				Delete_the_binding (idBinding)

				IFZ window_handle[slot] THEN DO NEXT

				' $$WM_DESTROY causes the deletion of corresponding binding
				SetLastError (0)
				ret = DestroyWindow (window_handle[slot])
				IFZ ret THEN
					msg$ = "WinX-CleanUp: Can't destroy window, index = " + STRING$ (slot)
					bErr = GuiTellApiError (@msg$)
					IFF bErr THEN WinXDialog_Error (@msg$, @ "WinX-Alert", 2)
				ENDIF

				window_handle[slot] = 0
			NEXT slot

	END SELECT
'
' 3.Unregister WinX window class.
'
	' unregister window class $$MAIN_CLASS$
'	bDebugMode = $$TRUE			' DEBUG mode
	bDebugMode = $$FALSE		' normal mode

	IFF bDebugMode THEN
		UnregisterWinClass (@$$MAIN_CLASS$, $$FALSE, "")
	ELSE
		' error logging
		sDebugText$ = "WinX-CleanUp: Unregister window class '" + $$MAIN_CLASS$ + "'"
		UnregisterWinClass (@$$MAIN_CLASS$, bDebugMode, sDebugText$)
	ENDIF

	' reset the window bindings
	DIM bindings[]

	g_bReentry = ""		' allow again re-entry

END FUNCTION
'
' ############################
' #####  CompareLVItems  #####
' ############################
' Compares two listview items.
FUNCTION CompareLVItems (item1, item2, hLV)
	SHARED g_lvs_column_index
	SHARED g_lvs_decreasing

	LV_ITEM lvi			' listview item
	XLONG ret				' win32 api return value (0 for fail)
	XLONG index			' running listview item index
	XLONG iChar			' running character index
	XLONG last_char	' = MIN (LEN (a$), LEN (b$)) (include zero-terminator)

	SetLastError (0)
	lvi.mask = $$LVIF_TEXT
	lvi.iSubItem = g_lvs_column_index AND 0x7FFFFFFF
'
' first item
'
	lvi.cchTextMax = 1023
	szBuf$ = NULL$ (lvi.cchTextMax)
	lvi.pszText = &szBuf$
	lvi.iItem = item1

	SendMessageA (hLV, $$LVM_GETITEM, item1, &lvi)
	a$ = CSTRING$(&szBuf$)
'
' second item
'
	lvi.cchTextMax = 1023
	szBuf$ = NULL$ (lvi.cchTextMax)
	lvi.pszText = &szBuf$
	lvi.iItem = item2

	SendMessageA (hLV, $$LVM_GETITEM, item2, &lvi)
	b$ = CSTRING$(&szBuf$)

	szBuf$ = ""

	ret = 0
	last_char = MIN (LEN (a$), LEN (b$))		' include zero-terminator
	FOR iChar = 0 TO last_char
		IF a${iChar} < b${iChar} THEN
			ret = -1
			EXIT FOR
		ENDIF
		IF a${iChar} > b${iChar} THEN
			ret = 1
			EXIT FOR
		ENDIF
	NEXT iChar

	IF ret = 0 THEN
		IF UBOUND(a$) < UBOUND(b$) THEN ret = -1
		IF UBOUND(a$) > UBOUND(b$) THEN ret =  1
	ENDIF

	IF g_lvs_decreasing THEN
		RETURN (-ret)
	ELSE
		RETURN ret
	ENDIF

END FUNCTION
'
' ################################
' #####  Delete_the_binding  #####
' ################################
' Deletes a binding from the binding table.
' "overloading" binding_delete
' idBinding = id of the binding to delete
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION Delete_the_binding (idBinding)
	BINDING			binding
	LINKEDLIST autoDraw
	XLONG bOK				' $$TRUE for success

	bOK = binding_get (idBinding, @binding)

	SELECT CASE bOK
		CASE $$TRUE
			IFZ binding.hWnd THEN EXIT SELECT		' fail

			' destroy accelerator table
			IF binding.hAccelTable THEN DestroyAcceleratorTable (binding.hAccelTable)
			binding.hAccelTable = 0

			' delete the auto-draw info
			autoDraw_clear (binding.autoDrawInfo)
			LINKEDLIST_Get (binding.autoDrawInfo, @autoDraw)
			LinkedList_Uninit (@autoDraw)
			LINKEDLIST_Delete (binding.autoDrawInfo)

			' delete the message handlers
			handler_deleteGroup (binding.msgHandlers)

			' delete the auto-sizer info
			autoSizerInfo_deleteGroup (binding.autoSizerInfo)

			bOK = binding_delete (idBinding)

	END SELECT

	RETURN bOK

END FUNCTION
'
' #############################
' #####  Get_the_binding  #####
' #############################
' Gets data of a binding accessed by its id
' by "overloading" binding_get.
' hWnd      = handle of the window
' idBinding = returned id of binding
' binding   = returned data
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION Get_the_binding (hWnd, @idBinding, BINDING binding)
	BINDING null_item
	XLONG bOK				' $$TRUE for success

	SetLastError (0)
	bOK = $$FALSE
	idBinding = 0

	IF hWnd THEN
		idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
		bOK = binding_get (idBinding, @binding)
	ENDIF

	IFF bOK THEN
		' binding is reset on fail
		binding = null_item
	ENDIF

	RETURN bOK

END FUNCTION
'
' #############################
' #####  GuiTellApiError  #####
' #############################
'
' Displays a WinAPI error message.
' returns bErr: $$TRUE only if an error REALLY occurred
'
' Usage:
'	SetLastError (0)
'	hImage = LoadImageA (0, &file$, $$IMAGE_BITMAP, 0, 0, $$LR_LOADFROMFILE)
'	IFZ hImage THEN
'		msg$ = "LoadImageA: Can't load Image File\r\n"
'		msg$ = msg$ + file$
'		bErr = GuiTellApiError (@msg$)
'		IF bErr THEN RETURN $$TRUE		' fail
'	ENDIF
'
FUNCTION GuiTellApiError (msg$)
	XLONG bOK				' $$TRUE for success
	XLONG errNum		' last error code
	XLONG dwFlags
	XLONG cChar			' character count
	XLONG ret				' win32 api return value (0 for fail)
	XLONG bErr			' $$TRUE for error

	STRING osName_str			' returned OS name string

	XLONG  major					' returned major version number
	XLONG  minor					' returned minor version number
	XLONG  platformId			' returned platform identification
	STRING version_str		' returned string form of version number ("4.10")
	STRING platform_str		' returned platform string ("Win32s", "Windows", or "NT")

	'get the last error code, then clear it
	errNum = GetLastError ()
	SetLastError (0)
	IFZ errNum THEN RETURN		' was OK!

	fmtMsg$ = "Last error code " + STRING$ (errNum) + ": "

	' set up FormatMessageA arguments
	dwFlags = $$FORMAT_MESSAGE_FROM_SYSTEM OR $$FORMAT_MESSAGE_IGNORE_INSERTS
	cChar = 1020
	szBuf$ = NULL$ (cChar)		' note: NULL$() appends a nul-terminator
	ret = FormatMessageA (dwFlags, 0, errNum, 0, &szBuf$, cChar, 0)
	IFZ ret THEN
		fmtMsg$ = fmtMsg$ + "(unknown)"
	ELSE
		fmtMsg$ = fmtMsg$ + CSTRING$(&szBuf$)		' works the best with FormatMessageA()
	ENDIF

	IFZ msg$ THEN msg$ = "WinX-Windows API error"
	fmtMsg$ = fmtMsg$ + "\r\n\r\n" + msg$

	'get the running OS's name and version
	bErr = XstGetOSName (@osName_str)
	IF bErr THEN
		st$ = "(unknown)"
	ELSE
		IFZ osName_str THEN osName_str = "(unknown)"
		st$ = osName_str + " ver "
		bErr = XstGetOSVersion (@major, @minor, @platformId, @version_str, @platform_str)
		IF bErr THEN
			st$ = st$ + " (unknown)"
		ELSE
			st$ = st$ + STR$ (major) + "." + STRING$ (minor) + "-" + platform_str
		ENDIF
	ENDIF
	fmtMsg$ = fmtMsg$ + "\r\n\r\nOS: " + st$
	WinXDialog_Error (@fmtMsg$, @"WinX-API Error", 2)		' Alert

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

	XLONG extErr		' last extended error code

	IFZ TRIM$(title$) THEN title$ = "WinX-Standard Dialog Error"

	' call CommDlgExtendedError to get error code
	extErr = CommDlgExtendedError ()

	SELECT CASE extErr
		CASE 0
			' fmtMsg$ = "Cancel pressed, no error"
			RETURN		' don't display fmtMsg$

		CASE $$CDERR_DIALOGFAILURE : fmtMsg$ = "Can't create the dialog box"
		CASE $$CDERR_FINDRESFAILURE : fmtMsg$ = "Resource missing"
		CASE $$CDERR_NOHINSTANCE : fmtMsg$ = "Instance handle missing"
		CASE $$CDERR_INITIALIZATION : fmtMsg$ = "Can't initialize. Possibly out of memory"
		CASE $$CDERR_NOHOOK : fmtMsg$ = "Hook procedure missing"
		CASE $$CDERR_LOCKRESFAILURE : fmtMsg$ = "Can't lock a resource"
		CASE $$CDERR_NOTEMPLATE : fmtMsg$ = "Template missing"
		CASE $$CDERR_LOADRESFAILURE : fmtMsg$ = "Can't load a resource"
		CASE $$CDERR_STRUCTSIZE : fmtMsg$ = "Internal error - invalid struct size"
		CASE $$CDERR_LOADSTRFAILURE : fmtMsg$ = "Can't load a string"
		CASE $$CDERR_MEMALLOCFAILURE : fmtMsg$ = "Can't allocate memory for internal dialog structures"
		CASE $$CDERR_MEMLOCKFAILURE : fmtMsg$ = "Can't lock memory"

		CASE ELSE : fmtMsg$ = "Unknown error code"
	END SELECT

	fmtMsg$ = "GuiTellDialogError: Last error code " + STRING$ (extErr) + ": " + fmtMsg$
	WinXDialog_Error (@fmtMsg$, @"WinX-API Error", 2)		' Alert

	RETURN $$TRUE		' an error really occurred!

END FUNCTION
'
' #############################
' #####  GuiTellRunError  #####
' #############################
'
' Displays a run-time error message.
' returns $$TRUE only if an error really occurred
'
' Usage:
' errNum = ERROR ($$FALSE)		' reset any prior run-time error
' fileNumber = OPEN (fileName$, $$WRNEW)
' IF fileNumber < 1 THEN
' msg$ = "OPEN: Can't open file\r\n"
' msg$ = msg$ + fileName$
' GuiTellRunError (@msg$)
' ENDIF
'
FUNCTION GuiTellRunError (msg$)

	XLONG errNum		' last error code
	XLONG bErr		' $$TRUE for error

	errNum = ERROR ($$FALSE)		' reset any prior run-time error on entry
	IFZ errNum THEN
		bErr = $$FALSE		' was OK!
	ELSE
		bErr = $$TRUE		' an error really occurred!

		fmtMsg$ = "Error code " + STRING$ (errNum) + ", " + ERROR$ (errNum)

		IFZ msg$ THEN msg$ = "WinX-XBLite Library Error"
		fmtMsg$ = fmtMsg$ + "\r\n\r\n" + msg$
		WinXDialog_Error (@fmtMsg$, @"WinX-Run-time Error", 2)		' Alert
	ENDIF

	RETURN bErr

END FUNCTION
'
' Deletes a LINKEDLIST item from LINKEDLIST Pool.
' id = id of the LINKEDLIST item to delete
' returns bOK: $$TRUE on success
'
' Usage:
'	bOK = LINKEDLIST_Delete (id)
'	IFF bOK THEN
'		msg$ = "LINKEDLIST_Delete: Can't delete the LINKEDLIST item of id = " + STRING$ (id)
'		PRINT msg$
'	ENDIF
'
FUNCTION LINKEDLIST_Delete (id)
	SHARED LINKEDLIST LINKEDLISTarray[]
	SHARED SBYTE LINKEDLISTarrayUM[]

	LINKEDLIST null_item
	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(LINKEDLISTarrayUM[])) THEN
		LINKEDLISTarray[slot] = null_item
		LINKEDLISTarrayUM[slot] = $$FALSE
		bOK = $$TRUE
	ENDIF

	RETURN bOK

END FUNCTION
'
' Gets a LINKEDLIST item from the LINKEDLIST Pool.
' id = id of the LINKEDLIST item to get
' item = returned item
' returns bOK: $$TRUE on success
'
' Usage:
' bOK = LINKEDLIST_Get (id, @item)
' IFF bOK THEN
' 	msg$ = "LINKEDLIST_Get: Can't get the LINKEDLIST item of id = " + STRING$ (id)
' 	PRINT msg$
' ENDIF
'
FUNCTION LINKEDLIST_Get (id, LINKEDLIST item)
	SHARED LINKEDLIST LINKEDLISTarray[]
	SHARED SBYTE LINKEDLISTarrayUM[]

	LINKEDLIST null_item
	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(LINKEDLISTarrayUM[])) THEN
		IF LINKEDLISTarrayUM[slot] THEN
			item = LINKEDLISTarray[slot]
			bOK = $$TRUE
		ENDIF
	ENDIF
	IFF bOK THEN
		item = null_item
	ENDIF
	RETURN bOK

END FUNCTION
'
' Initializes the LINKEDLIST Pool.
'
FUNCTION LINKEDLIST_Init ()
	SHARED LINKEDLIST LINKEDLISTarray[]		' array of LINKEDLIST items
	SHARED SBYTE LINKEDLISTarrayUM[]		' usage map so we can see which LINKEDLISTarray[] elements are in use

	XLONG slot		' array index

	LINKEDLIST null_item

	IFZ LINKEDLISTarray[] THEN
		DIM LINKEDLISTarray[7]
		DIM LINKEDLISTarrayUM[7]
	ENDIF
	FOR slot = UBOUND(LINKEDLISTarrayUM[]) TO 0 STEP -1
		LINKEDLISTarray[slot] = null_item
		LINKEDLISTarrayUM[slot] = $$FALSE
	NEXT slot

END FUNCTION
'
' Adds a new LINKEDLIST item to LINKEDLIST Pool.
' returns the new LINKEDLIST item id, 0 on fail
'
' Usage:
' id = LINKEDLIST_New (item)
' IFZ id THEN
' 	msg$ = "LINKEDLIST_New: Can't add a new item to LINKEDLIST Pool"
' 	PRINT msg$
' ENDIF
'
FUNCTION LINKEDLIST_New (LINKEDLIST item)
	SHARED LINKEDLIST LINKEDLISTarray[]
	SHARED SBYTE LINKEDLISTarrayUM[]

	LINKEDLIST null_item
	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index

	IFZ LINKEDLISTarrayUM[] THEN LINKEDLIST_Init ()

	slot = -1		' not an index

	' look for a blank slot
	upper_slot = UBOUND(LINKEDLISTarrayUM[])
	FOR i = 0 TO upper_slot
		IFF LINKEDLISTarrayUM[i] THEN
			' reuse this open slot
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	' allocate more memory if needed
	IF slot < 0 THEN
		' no open slots found => add a bunch of new open slots
		slot = upper_slot + 1

		' expand both LINKEDLISTarray[] and LINKEDLISTarrayUM[]
		upper_slot = (2 * slot) + 3
		REDIM LINKEDLISTarray[upper_slot]
		REDIM LINKEDLISTarrayUM[upper_slot]

		' reset the leftover of LINKEDLIST items
		FOR i = slot TO upper_slot
			LINKEDLISTarray[i] = null_item
		NEXT i
	ENDIF

	IF slot >= 0 THEN
		LINKEDLISTarray[slot] = item
		LINKEDLISTarrayUM[slot] = $$TRUE
	ENDIF

	RETURN (slot + 1)

END FUNCTION
'
' Updates an existing LINKEDLIST item.
' id = id of the LINKEDLIST item to update
' item = the new LINKEDLIST item's data
' returns bOK: $$TRUE on success
'
' Usage:
' bOK = LINKEDLIST_Update (id, item)
' IFF bOK THEN
' 	msg$ = "LINKEDLIST_Update: Can't update the LINKEDLIST item of id = " + STRING$ (id)
' 	PRINT msg$
' ENDIF
'
FUNCTION LINKEDLIST_Update (id, LINKEDLIST item)
	SHARED LINKEDLIST LINKEDLISTarray[]
	SHARED SBYTE LINKEDLISTarrayUM[]

	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(LINKEDLISTarrayUM[])) THEN
		IF LINKEDLISTarrayUM[slot] THEN
			LINKEDLISTarray[slot] = item
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK

END FUNCTION
'
' Deletes a LINKEDNODE item from LINKEDNODE Pool.
' id = id of the LINKEDNODE item to delete
' returns bOK: $$TRUE on success
'
' Usage:
'	bOK = LINKEDNODE_Delete (id)
'	IFF bOK THEN
'		msg$ = "LINKEDNODE_Delete: Can't delete the LINKEDNODE item of id = " + STRING$ (id)
'		PRINT msg$
'	ENDIF
'
FUNCTION LINKEDNODE_Delete (id)
	SHARED LINKEDNODE LINKEDNODEarray[]
	SHARED SBYTE LINKEDNODEarrayUM[]

	LINKEDNODE null_item
	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index
	XLONG bOK					' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(LINKEDNODEarrayUM[])) THEN
		LINKEDNODEarray[slot] = null_item
		LINKEDNODEarrayUM[slot] = $$FALSE
		bOK = $$TRUE
	ENDIF

	RETURN bOK

END FUNCTION
'
' Gets a LINKEDNODE item from the LINKEDNODE Pool.
' id = id of the LINKEDNODE item to get
' item = returned item
' returns bOK: $$TRUE on success
'
' Usage:
' bOK = LINKEDNODE_Get (id, @item)
' IFF bOK THEN
' 	msg$ = "LINKEDNODE_Get: Can't get the LINKEDNODE item of id = " + STRING$ (id)
' 	PRINT msg$
' ENDIF
'
FUNCTION LINKEDNODE_Get (id, LINKEDNODE item)
	SHARED LINKEDNODE LINKEDNODEarray[]
	SHARED SBYTE LINKEDNODEarrayUM[]

	LINKEDNODE null_item
	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(LINKEDNODEarrayUM[])) THEN
		IF LINKEDNODEarrayUM[slot] THEN
			item = LINKEDNODEarray[slot]
			bOK = $$TRUE
		ENDIF
	ENDIF
	IFF bOK THEN
		item = null_item
	ENDIF
	RETURN bOK

END FUNCTION
'
' Initializes the LINKEDNODE Pool.
'
FUNCTION LINKEDNODE_Init ()
	SHARED LINKEDNODE LINKEDNODEarray[]		' array of LINKEDNODE items
	SHARED SBYTE LINKEDNODEarrayUM[]		' usage map so we can see which LINKEDNODEarray[] elements are in use

	XLONG slot		' array index

	LINKEDNODE null_item

	IFZ LINKEDNODEarray[] THEN
		DIM LINKEDNODEarray[7]
		DIM LINKEDNODEarrayUM[7]
	ENDIF
	FOR slot = UBOUND(LINKEDNODEarrayUM[]) TO 0 STEP -1
		LINKEDNODEarray[slot] = null_item
		LINKEDNODEarrayUM[slot] = $$FALSE
	NEXT slot

END FUNCTION
'
' Adds a new LINKEDNODE item to LINKEDNODE Pool.
' returns the new LINKEDNODE item id, 0 on fail
'
' Usage:
'	id = LINKEDNODE_New (item)
'	IFZ id THEN
'		msg$ = "LINKEDNODE_New: Can't add a new item to LINKEDNODE Pool"
'		PRINT msg$
'	ENDIF
'
FUNCTION LINKEDNODE_New (LINKEDNODE item)
	SHARED LINKEDNODE LINKEDNODEarray[]
	SHARED SBYTE LINKEDNODEarrayUM[]

	LINKEDNODE null_item
	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index

	IFZ LINKEDNODEarrayUM[] THEN LINKEDNODE_Init ()

	slot = -1		' not an index

	' look for a blank slot
	upper_slot = UBOUND(LINKEDNODEarrayUM[])
	FOR i = 0 TO upper_slot
		IFF LINKEDNODEarrayUM[i] THEN
			' reuse this open slot
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	' allocate more memory if needed
	IF slot < 0 THEN
		' no open slots found => add a bunch of new open slots
		slot = upper_slot + 1

		' expand both LINKEDNODEarray[] and LINKEDNODEarrayUM[]
		upper_slot = (2 * slot) + 3
		REDIM LINKEDNODEarray[upper_slot]
		REDIM LINKEDNODEarrayUM[upper_slot]

		' reset the leftover of LINKEDNODE items
		FOR i = slot TO upper_slot
			LINKEDNODEarray[i] = null_item
		NEXT i
	ENDIF

	IF slot >= 0 THEN
		LINKEDNODEarray[slot] = item
		LINKEDNODEarrayUM[slot] = $$TRUE
	ENDIF

	RETURN (slot + 1)

END FUNCTION
'
' Updates an existing LINKEDNODE item.
' id = id of the LINKEDNODE item to update
' item = the new LINKEDNODE item's data
' returns bOK: $$TRUE on success
'
' Usage:
'	bOK = LINKEDNODE_Update (id, item)
'	IFF bOK THEN
'		msg$ = "LINKEDNODE_Update: Can't update the LINKEDNODE item of id = " + STRING$ (id)
'		PRINT msg$
'	ENDIF
'
FUNCTION LINKEDNODE_Update (id, LINKEDNODE item)
	SHARED LINKEDNODE LINKEDNODEarray[]
	SHARED SBYTE LINKEDNODEarrayUM[]

	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(LINKEDNODEarrayUM[])) THEN
		IF LINKEDNODEarrayUM[slot] THEN
			LINKEDNODEarray[slot] = item
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK

END FUNCTION
'
' Deletes a LINKEDWALK item from LINKEDWALK Pool.
' id = id of the LINKEDWALK item to delete
' returns bOK: $$TRUE on success
'
' Usage:
'	bOK = LINKEDWALK_Delete (id)
'	IFF bOK THEN
'		msg$ = "LINKEDWALK_Delete: Can't delete the LINKEDWALK item of id = " + STRING$ (id)
'		PRINT msg$
'	ENDIF
'
FUNCTION LINKEDWALK_Delete (id)
	SHARED LINKEDWALK LINKEDWALKarray[]
	SHARED SBYTE LINKEDWALKarrayUM[]

	LINKEDWALK null_item
	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index
	XLONG bOK					' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(LINKEDWALKarrayUM[])) THEN
		LINKEDWALKarray[slot] = null_item
		LINKEDWALKarrayUM[slot] = $$FALSE
		bOK = $$TRUE
	ENDIF

	RETURN bOK

END FUNCTION
'
' Gets a LINKEDWALK item from the LINKEDWALK Pool.
' id = id of the LINKEDWALK item to get
' item = returned item
' returns bOK: $$TRUE on success
'
' Usage:
' bOK = LINKEDWALK_Get (id, @item)
' IFF bOK THEN
' 	msg$ = "LINKEDWALK_Get: Can't get the LINKEDWALK item of id = " + STRING$ (id)
' 	PRINT msg$
' ENDIF
'
FUNCTION LINKEDWALK_Get (id, LINKEDWALK item)
	SHARED LINKEDWALK LINKEDWALKarray[]
	SHARED SBYTE LINKEDWALKarrayUM[]

	LINKEDWALK null_item
	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(LINKEDWALKarrayUM[])) THEN
		IF LINKEDWALKarrayUM[slot] THEN
			item = LINKEDWALKarray[slot]
			bOK = $$TRUE
		ENDIF
	ENDIF
	IFF bOK THEN
		item = null_item
	ENDIF
	RETURN bOK

END FUNCTION
'
' Initializes the LINKEDWALK Pool.
'
FUNCTION LINKEDWALK_Init ()
	SHARED LINKEDWALK LINKEDWALKarray[]		' array of LINKEDWALK items
	SHARED SBYTE LINKEDWALKarrayUM[]		' usage map so we can see which LINKEDWALKarray[] elements are in use

	XLONG slot		' array index

	LINKEDWALK null_item

	IFZ LINKEDWALKarray[] THEN
		DIM LINKEDWALKarray[7]
		DIM LINKEDWALKarrayUM[7]
	ENDIF
	FOR slot = UBOUND(LINKEDWALKarrayUM[]) TO 0 STEP -1
		LINKEDWALKarray[slot] = null_item
		LINKEDWALKarrayUM[slot] = $$FALSE
	NEXT slot

END FUNCTION
'
' Adds a new LINKEDWALK item to LINKEDWALK Pool.
' returns the new LINKEDWALK item id, 0 on fail
'
' Usage:
'	id = LINKEDWALK_New (item)
'	IFZ id THEN
'		msg$ = "LINKEDWALK_New: Can't add a new item to LINKEDWALK Pool"
'		PRINT msg$
'	ENDIF
'
FUNCTION LINKEDWALK_New (LINKEDWALK item)
	SHARED LINKEDWALK LINKEDWALKarray[]
	SHARED SBYTE LINKEDWALKarrayUM[]

	LINKEDWALK null_item
	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index

	IFZ LINKEDWALKarrayUM[] THEN LINKEDWALK_Init ()

	slot = -1		' not an index

	' look for a blank slot
	upper_slot = UBOUND(LINKEDWALKarrayUM[])
	FOR i = 0 TO upper_slot
		IFF LINKEDWALKarrayUM[i] THEN
			' reuse this open slot
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	' allocate more memory if needed
	IF slot < 0 THEN
		' no open slots found => add a bunch of new open slots
		slot = upper_slot + 1

		' expand both LINKEDWALKarray[] and LINKEDWALKarrayUM[]
		upper_slot = (2 * slot) + 3
		REDIM LINKEDWALKarray[upper_slot]
		REDIM LINKEDWALKarrayUM[upper_slot]

		' reset the leftover of LINKEDWALK items
		FOR i = slot TO upper_slot
			LINKEDWALKarray[i] = null_item
		NEXT i
	ENDIF

	IF slot >= 0 THEN
		LINKEDWALKarray[slot] = item
		LINKEDWALKarrayUM[slot] = $$TRUE
	ENDIF

	RETURN (slot + 1)

END FUNCTION
'
' Updates an existing LINKEDWALK item.
' id = id of the LINKEDWALK item to update
' item = the new LINKEDWALK item's data
' returns bOK: $$TRUE on success
'
' Usage:
'	bOK = LINKEDWALK_Update (id, item)
'	IFF bOK THEN
'		msg$ = "LINKEDWALK_Update: Can't update the LINKEDWALK item of id = " + STRING$ (id)
'		PRINT msg$
'	ENDIF
'
FUNCTION LINKEDWALK_Update (id, LINKEDWALK item)
	SHARED LINKEDWALK LINKEDWALKarray[]
	SHARED SBYTE LINKEDWALKarrayUM[]

	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(LINKEDWALKarrayUM[])) THEN
		IF LINKEDWALKarrayUM[slot] THEN
			LINKEDWALKarray[slot] = item
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK

END FUNCTION
'
' ###############################
' #####  LinkedList_Append  #####
' ###############################
' Appends an item to a linked list.
' list = the linked list to append to
' iData = the data to append to the linked list
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION LinkedList_Append (LINKEDLIST list, iData)
	LINKEDNODE tail
	LINKEDNODE new

	IFF LINKEDNODE_Get (list.iTail, @tail) THEN RETURN $$FALSE		' fail
	new.iData = iData
	new.iNext = 0
	tail.iNext = LINKEDNODE_New (new)
	LINKEDNODE_Update (list.iTail, @tail)

	list.iTail = tail.iNext
	INC list.cItems

	RETURN $$TRUE		' success

END FUNCTION
'
' ##################################
' #####  LinkedList_DeleteAll  #####
' ##################################
' Deletes every item in a linked list.
' list = the list to delete the items from
' returns $$TRUE on success, or $$FALSE on fail.
FUNCTION LinkedList_DeleteAll (LINKEDLIST list)
	LINKEDNODE currNode		' current node

	XLONG iCurrNode		' index of the current node

	' Get the head
	IFF LINKEDNODE_Get (list.iHead, @currNode) THEN RETURN $$FALSE		' fail

	DO WHILE currNode.iNext
		' Get the next node
		iCurrNode = currNode.iNext
		IFF LINKEDNODE_Get (iCurrNode, @currNode) THEN RETURN $$FALSE		' fail

		' Process this node
		IFF LINKEDNODE_Delete (iCurrNode) THEN RETURN $$FALSE		' fail
	LOOP

	' Update the head node
	LINKEDNODE_Get (list.iHead, @currNode)
	currNode.iNext = 0
	LINKEDNODE_Update (list.iHead, currNode)

	list.iTail = list.iHead
	list.cItems = 0
	RETURN $$TRUE		' success

END FUNCTION
'
' ###################################
' #####  LinkedList_DeleteThis  #####
' ###################################
' Deletes the item LinkedList_Walk just returned.
' hWalk = the walk handle
' list = the list the walk is associated with.  Need this to change item count
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION LinkedList_DeleteThis (hWalk, LINKEDLIST list)
	LINKEDNODE currNode		' current node
	LINKEDWALK walk

	IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN $$FALSE		' fail
	IF walk.iPrev < 0 THEN
		IFF LINKEDNODE_Get (walk.first, @currNode) THEN RETURN $$FALSE		' fail
		currNode.iNext = walk.iNext
		IFF LINKEDNODE_Update (walk.first, currNode) THEN RETURN $$FALSE		' fail
	ELSE
		IFF LINKEDNODE_Get (walk.iPrev, @currNode) THEN RETURN $$FALSE		' fail
		currNode.iNext = walk.iNext
		IFF LINKEDNODE_Update (walk.iPrev, currNode) THEN RETURN $$FALSE		' fail
	ENDIF

	IFF LINKEDNODE_Delete (walk.iCurrentNode) THEN RETURN $$FALSE		' fail
	DEC list.cItems

	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  LinkedList_EndWalk  #####
' ################################
' Closes a walk handle.
' hWalk = the walk handle of close
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION LinkedList_EndWalk (hWalk)
	RETURN LINKEDWALK_Delete (hWalk)
END FUNCTION
'
' #############################
' #####  LinkedList_Init  #####
' #############################
' Initializes a linked list.
' list = the linked list structure to initialize
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION LinkedList_Init (LINKEDLIST list)
	LINKEDNODE head

	head.iData = 0
	head.iNext = 0

	list.iHead = LINKEDNODE_New (head)
	list.iTail = list.iHead
	list.cItems = 0
	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  LinkedList_StartWalk  #####
' ##################################
' Initializes a walk of a linked list.
' list = the list to walk
' returns a walk handle which you must pass to subsequent calls to LinkedList_Walk and LinkedList_EndWalk,
'				  or 0 on fail
FUNCTION LinkedList_StartWalk (LINKEDLIST list)
	LINKEDNODE currNode		' current node
	LINKEDWALK walk

	IFF LINKEDNODE_Get (list.iHead, @currNode) THEN RETURN 0
	walk.first = list.iHead
	walk.iPrev = list.iHead
	walk.iCurrentNode = -1
	walk.iNext = currNode.iNext
	walk.last = list.iTail

	RETURN LINKEDWALK_New (walk)

END FUNCTION
'
' ###############################
' #####  LinkedList_Uninit  #####
' ###############################
' Uninitializes a linked list.
' (Call if you are about to delete a linked list)
'
' list = the linkedlist to delete
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION LinkedList_Uninit (LINKEDLIST list)

	IFF LinkedList_DeleteAll (@list) THEN RETURN $$FALSE		' fail
	IFF LINKEDNODE_Delete (list.iHead) THEN RETURN $$FALSE		' fail
	list.iHead = 0
	list.iTail = 0
	RETURN $$TRUE		' success

END FUNCTION
'
' #############################
' #####  LinkedList_Walk  #####
' #############################
' Gets the next data item in a linked list.
' hWalk = the walk handle generated with the LinkedList_StartWalk call
' iData = the variable to store the data
' returns $$TRUE if iData is valid,
'      or $$FALSE if the walk is complete or there is an error
FUNCTION LinkedList_Walk (hWalk, @iData)
	LINKEDNODE currNode		' current node
	LINKEDWALK walk

	IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN $$FALSE		' fail
	' PRINT "> ";walk.iPrev, walk.iCurrentNode, walk.iNext

	IFF LINKEDNODE_Get (walk.iNext, @currNode) THEN RETURN $$FALSE		' fail

	iData = currNode.iData
	walk.iPrev = walk.iCurrentNode
	walk.iCurrentNode = walk.iNext
	walk.iNext = currNode.iNext
	IFF LINKEDWALK_Update (hWalk, @walk) THEN RETURN $$FALSE		' fail

	RETURN $$TRUE		' success

END FUNCTION
'
'
' ##################################
' #####  LongDoubleTangent ()  #####
' ##################################
'
' 96-bit IEEE Long Double Precision Precision Floating Point Tangent routine.
' returns Tangent of angle by FPU instructions
FUNCTION LONGDOUBLE LongDoubleTangent (LONGDOUBLE x)		' Tangent of angle x

	LONGDOUBLE ret

	ret = 0

ASM fld t[LongDoubleTangent.x]		; load input value (radians)
ASM fptan
'
' Need to check for completion of fptan.
' If not complete will only be 1 value on stack
' if complete, will also push 1 onto stack.
'
ASM fstsw ax
ASM fwait
ASM and ax, 0000010000000000b		; extract C2
ASM test ax, ax
ASM jnz > LongDoubleTangent_Bad

ASM fxch		; remove the unwanted 1
ASM fstp t[LongDoubleTangent.ret]		; store the return value (radians)

	ret = ret * 1		' just in case
	RETURN ret

ASM LongDoubleTangent_Bad:
	ret = 0
	RETURN ret

END FUNCTION
'
'
' Deletes a splitter info block from splitter info blocks.
' id = id of the splitter info block to delete
' returns bOK: $$TRUE on success
'
' Usage:
' bOK = SPLITTERINFO_Delete (idBlock)
' IFF bOK THEN
' 	msg$ = "SPLITTERINFO_Delete: Can't delete the splitter info block of id = " + STRING$ (idBlock)
' 	PRINT msg$
' ENDIF
'
FUNCTION SPLITTERINFO_Delete (idBlock)
	SHARED SPLITTERINFO SPLITTERINFOarray[]
	SHARED SBYTE SPLITTERINFOarrayUM[]

	SPLITTERINFO null_item
	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index
	XLONG bOK					' $$TRUE for success

	bOK = $$FALSE
	slot = idBlock - 1
	IF (slot >= 0) && (slot <= UBOUND(SPLITTERINFOarrayUM[])) THEN
		SPLITTERINFOarray[slot] = null_item
		SPLITTERINFOarrayUM[slot] = $$FALSE
		bOK = $$TRUE
	ENDIF

	RETURN bOK

END FUNCTION
'
' Gets a splitter info block from the splitter info blocks.
' idBlock = id of the splitter info block to get
' item = returned item
' returns bOK: $$TRUE on success
'
' Usage:
' bOK = SPLITTERINFO_Get (idBlock, @splitter_block)
' IFF bOK THEN
' 	msg$ = "SPLITTERINFO_Get: Can't get the splitter_block of id = " + STRING$ (idBlock)
' 	PRINT msg$
' ENDIF
'
FUNCTION SPLITTERINFO_Get (idBlock, SPLITTERINFO splitter_block)
	SHARED SPLITTERINFO SPLITTERINFOarray[]
	SHARED SBYTE SPLITTERINFOarrayUM[]

	SPLITTERINFO null_item
	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = idBlock - 1
	IF (slot >= 0) && (slot <= UBOUND(SPLITTERINFOarrayUM[])) THEN
		IF SPLITTERINFOarrayUM[slot] THEN
			splitter_block = SPLITTERINFOarray[slot]
			bOK = $$TRUE
		ENDIF
	ENDIF
	IFF bOK THEN
		splitter_block = null_item
	ENDIF
	RETURN bOK

END FUNCTION
'
' Initializes the splitter info blocks.
'
FUNCTION SPLITTERINFO_Init ()
	SHARED SPLITTERINFO SPLITTERINFOarray[]		' array of SPLITTERINFO items
	SHARED SBYTE SPLITTERINFOarrayUM[]		' usage map so we can see which SPLITTERINFOarray[] elements are in use

	XLONG slot		' array index
	SPLITTERINFO null_item

	IFZ SPLITTERINFOarray[] THEN
		DIM SPLITTERINFOarray[7]
		DIM SPLITTERINFOarrayUM[7]
	ENDIF
	FOR slot = UBOUND(SPLITTERINFOarrayUM[]) TO 0 STEP -1
		SPLITTERINFOarray[slot] = null_item
		SPLITTERINFOarrayUM[slot] = $$FALSE
	NEXT slot

END FUNCTION
'
' Adds a new splitter_block to splitter info blocks.
' returns the new splitter_block id, 0 on fail
'
' Usage:
' idBlock = SPLITTERINFO_New (splitter_block)
' IFZ idBlock THEN
' 	msg$ = "SPLITTERINFO_New: Can't add a new item to splitter info blocks"
' 	PRINT msg$
' ENDIF
'
FUNCTION SPLITTERINFO_New (SPLITTERINFO splitter_block)
	SHARED SPLITTERINFO SPLITTERINFOarray[]
	SHARED SBYTE SPLITTERINFOarrayUM[]

	SPLITTERINFO null_item
	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index

	IFZ SPLITTERINFOarrayUM[] THEN SPLITTERINFO_Init ()

	slot = -1		' not an index

	' look for a blank slot
	upper_slot = UBOUND(SPLITTERINFOarrayUM[])
	FOR i = 0 TO upper_slot
		IFF SPLITTERINFOarrayUM[i] THEN
			' reuse this open slot
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	' allocate more memory if needed
	IF slot < 0 THEN
		' no open slots found => add a bunch of new open slots
		slot = upper_slot + 1

		' expand both SPLITTERINFOarray[] and SPLITTERINFOarrayUM[]
		upper_slot = (2 * slot) + 3
		REDIM SPLITTERINFOarray[upper_slot]
		REDIM SPLITTERINFOarrayUM[upper_slot]

		' reset the leftover of SPLITTERINFO items
		FOR i = slot TO upper_slot
			SPLITTERINFOarray[i] = null_item
		NEXT i
	ENDIF

	IF slot >= 0 THEN
		SPLITTERINFOarray[slot] = splitter_block
		SPLITTERINFOarrayUM[slot] = $$TRUE
	ENDIF

	RETURN (slot + 1)

END FUNCTION
'
' Updates an existing splitter info block.
' idBlock = id of the splitter_block to update
' item = the new splitter_block's data
' returns bOK: $$TRUE on success
'
' Usage:
' bOK = SPLITTERINFO_Update (idBlock, splitter_block)
' IFF bOK THEN
' 	msg$ = "SPLITTERINFO_Update: Can't update the splitter_block of id = " + STRING$ (idBlock)
' 	PRINT msg$
' ENDIF
'
FUNCTION SPLITTERINFO_Update (idBlock, SPLITTERINFO splitter_block)
	SHARED SPLITTERINFO SPLITTERINFOarray[]
	SHARED SBYTE SPLITTERINFOarrayUM[]

	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = idBlock - 1
	IF (slot >= 0) && (slot <= UBOUND(SPLITTERINFOarrayUM[])) THEN
		IF SPLITTERINFOarrayUM[slot] THEN
			SPLITTERINFOarray[slot] = splitter_block
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK

END FUNCTION
'
' ###########################
' #####  STRING_Delete  #####
' ###########################
'
FUNCTION STRING_Delete (id)
	SHARED STRINGarray$[]
	SHARED UBYTE STRINGarrayUM[]

	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(STRINGarrayUM[])) THEN
		' clear slot STRINGarray$[slot]
		STRINGarray$[slot] = ""
		STRINGarrayUM[slot] = $$FALSE
		bOK = $$TRUE
	ENDIF
	RETURN bOK
END FUNCTION
'
' #############################
' #####  STRING_Extract$  #####
' #############################
' Extracts a sub-string from a string.
' text$    = the passed string
' beginPos = position of the first character of the sub-string
' < 1 indicates "first character"
' posEnd   = position of the last character of the sub-string
' < 1 indicates "up to the last character"
'
' Usage:
' posSepPrev = 0
' posSep = INSTR (csv$, ",")
'
' DO WHILE posSep > 1
' ' extract the next CSV field
' start = posSepPrev + 1
' end = posSep - 1
' '
' field$ = STRING_Extract$ (csv$, start, end)
' '
' ' (...)
' '
' posSepPrev = posSep
' posSep = INSTR (csv$, ",", posSep + 1)
' '
' LOOP
'
FUNCTION STRING_Extract$ (text$, beginPos, posEnd)

	XLONG length

	IF beginPos < 1 THEN beginPos = 1

	IF posEnd < beginPos THEN posEnd = LEN (text$)
	IF posEnd > LEN (text$) THEN posEnd = LEN (text$)

	IF posEnd < beginPos THEN
		ret$ = ""
	ELSE
		length = posEnd - beginPos + 1
		ret$ = TRIM$(MID$(text$, beginPos, length))
	ENDIF

	RETURN ret$

END FUNCTION
'
' Gets a stored string from the stored strings.
' id = id of the stored string to get
' STRING_item$ = returned stored string
' returns bOK: $$TRUE on success, or $$FALSE on fail
'
' Usage:
' bOK = STRING_Get (STRING_id, @STRING_item$)
' IFF bOK THEN
' 	msg$ = "STRING_Get: Can't get the stored string of ID = " + STRING$ (STRING_id)
' 	PRINT msg$
' ENDIF
'
FUNCTION STRING_Get (id, @r_item$)
	SHARED STRINGarray$[]
	SHARED UBYTE STRINGarrayUM[]

	XLONG slot		' array index
	XLONG bOK			' $$TRUE for success

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND(STRINGarrayUM[])) THEN
		IF STRINGarrayUM[slot] THEN
			' retrieve used slot STRINGarray$[slot]
			r_item$ = STRINGarray$[slot]
			IF r_item$ THEN bOK = $$TRUE
		ENDIF
	ENDIF

	IFF bOK THEN r_item$ = ""
	RETURN bOK

END FUNCTION
'
' #########################
' #####  STRING_Init  #####
' #########################
'
' Initializes the stored strings.
'
FUNCTION STRING_Init ()
	SHARED STRINGarray$[]		' array of stored strings
	SHARED UBYTE STRINGarrayUM[]		' usage map so we can see which STRINGarray$[] elements are in use

	XLONG slot				' array index

	IFZ STRINGarray$[] THEN
		DIM STRINGarray$[7]
		DIM STRINGarrayUM[7]
	ENDIF

	FOR slot = UBOUND(STRINGarrayUM[]) TO 0 STEP -1
		' clear slot STRINGarray$[slot]
		STRINGarray$[slot] = ""
		STRINGarrayUM[slot] = $$FALSE
	NEXT slot
END FUNCTION
'
' Adds a new stored string to stored strings.
' returns the new stored string ID, 0 on fail.
'
' Usage:
'	STRING_id = STRING_New (STRING_item$)
'	IFZ STRING_id THEN
'		msg$ = "STRING_New: Can't add a new stored string to stored strings " + STRING_item$
'		PRINT msg$
'	ENDIF
'
FUNCTION STRING_New (item$)
	SHARED STRINGarray$[]
	SHARED UBYTE STRINGarrayUM[]

	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index

	IFZ STRINGarrayUM[] THEN STRING_Init ()
	IFZ TRIM$(item$) THEN RETURN

	slot = -1		' not an index

	' find an open slot
	upper_slot = UBOUND(STRINGarrayUM[])
	FOR i = 0 TO upper_slot
		IFF STRINGarrayUM[i] THEN
			' reuse this open slot STRINGarray$[slot]
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	IF slot < 0 THEN
		' no open slots found => add a bunch of new open slots
		slot = upper_slot + 1

		' expand both STRINGarray$[] and STRINGarrayUM[]
		upper_slot = (slot * 2) + 1
		REDIM STRINGarray$[upper_slot]
		REDIM STRINGarrayUM[upper_slot]
	ENDIF

	IF slot >= 0 THEN
		STRINGarray$[slot] = item$
		STRINGarrayUM[slot] = $$TRUE
	ENDIF

	RETURN (slot + 1)

END FUNCTION
'
' ######################
' #####  XWSStoWS  #####
' ######################
' Convert a simplified window style to a window style.
' xwss = the simplified style
' returns a window style
FUNCTION XWSStoWS (xwss)
	XLONG dwStyle					' window style

	dwStyle = 0

	SELECT CASE xwss
		CASE $$XWSS_APP
			dwStyle = $$WS_OVERLAPPEDWINDOW
		CASE $$XWSS_APPNORESIZE
			dwStyle = $$WS_OVERLAPPED OR $$WS_CAPTION OR $$WS_SYSMENU OR $$WS_MINIMIZEBOX
		CASE $$XWSS_POPUP
			dwStyle = $$WS_POPUPWINDOW OR $$WS_CAPTION
		CASE $$XWSS_POPUPNOTITLE
			dwStyle = $$WS_POPUPWINDOW
		CASE $$XWSS_NOBORDER
			dwStyle = $$WS_POPUP
	END SELECT

	RETURN dwStyle

END FUNCTION
'
' ##########################
' #####  autoDraw_add  #####
' ##########################
' Appends an item to the auto-draw linked list.
' idList = the linked list to append to
' idDraw = the id (index) of the block to append to the linked list
' returns an index to the linked list on success, or -1 on fail
FUNCTION autoDraw_add (idList, idDraw)
	LINKEDLIST autoDraw
	XLONG bOK				' $$TRUE for success
	XLONG slot				' array index

	slot = -1		' not an index

	'get the auto-draw item
	bOK = LINKEDLIST_Get (idList, @autoDraw)
	IF bOK THEN
		LinkedList_Append (@autoDraw, idDraw)
		bOK = LINKEDLIST_Update (idList, autoDraw)
		IF bOK THEN
			IF autoDraw.cItems > 0 THEN
				' index to the linked list
				slot = autoDraw.cItems - 1
			ENDIF
		ENDIF
	ENDIF

	RETURN slot

END FUNCTION
'
' ############################
' #####  autoDraw_clear  #####
' ############################
' Clears out all the auto-draw info blocks in a group.
' group = the handler group to clear
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION autoDraw_clear (group)
	LINKEDLIST autoDraw
	AUTODRAWRECORD record
	XLONG idDraw		' id of the auto-draw info block
	XLONG hWalk			' running handle of the autoDraw's item

	IFF LINKEDLIST_Get (group, @autoDraw) THEN RETURN $$FALSE
	hWalk = LinkedList_StartWalk (autoDraw)

	DO WHILE LinkedList_Walk (hWalk, @idDraw)
		AUTODRAWRECORD_Get (idDraw, @record)
'
' 0.6.0.2-old---
'		IF record.draw = &drawText() THEN
'			STRING_Delete (record.text.iString)
'		ENDIF
' 0.6.0.2-old===
' 0.6.0.2-new+++
		IF record.text.iString THEN
			STRING_Delete (record.text.iString)
			record.text.iString = 0
		ENDIF
' 0.6.0.2-new===
'
		DeleteObject (record.hUpdateRegion)
		record.hUpdateRegion = 0		' reset the object's handle
		AUTODRAWRECORD_Delete (idDraw)
	LOOP
	LinkedList_EndWalk (hWalk)
	LinkedList_DeleteAll (@autoDraw)

	LINKEDLIST_Update (group, autoDraw)

	RETURN $$TRUE		' success

END FUNCTION
'
' ###########################
' #####  autoDraw_draw  #####
' ###########################
' Draws the auto-draw groups of records.
' hdc = the dc to draw to
' group = the handler group of records to draw
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION autoDraw_draw (hdc, group, x0, y0)
	LINKEDLIST autoDraw
	AUTODRAWRECORD record
	XLONG hPen			' the handle of the pen
	XLONG hBrush		' the handle of the solid brush
	XLONG hFont			' the handle of the logical font
	XLONG hWalk			' running handle of the autoDraw's item
	XLONG idDraw		' the id of the auto-draw info block
	XLONG bOK				' $$TRUE for success

	bOK = $$FALSE

	SELECT CASE hdc
		CASE 0

		CASE ELSE
			IFF LINKEDLIST_Get (group, @autoDraw) THEN EXIT SELECT		' fail

			hPen = 0
			hBrush = 0
			hFont = 0

			hWalk = LinkedList_StartWalk (autoDraw)
			DO WHILE LinkedList_Walk (hWalk, @idDraw)
				AUTODRAWRECORD_Get (idDraw, @record)

				' IF (record.hPen != 0) && (record.hPen != hPen) THEN
				SELECT CASE record.hPen
					CASE 0, hPen

					CASE ELSE
						hPen = record.hPen
						SelectObject (hdc, record.hPen)
				END SELECT

				' IF record.hBrush != 0 && record.hBrush != hBrush THEN
				SELECT CASE record.hBrush
					CASE 0, hBrush

					CASE ELSE
						hBrush = record.hBrush
						SelectObject (hdc, record.hBrush)
				END SELECT

				' IF record.hFont != 0 && record.hFont != hFont THEN
				SELECT CASE record.hFont
					CASE 0, hFont

					CASE ELSE
						hFont = record.hFont
						SelectObject (hdc, record.hFont)
				END SELECT

				IF record.toDelete THEN
					AUTODRAWRECORD_Delete (idDraw)
					LinkedList_DeleteThis (hWalk, @autoDraw)
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
' The auto-sizer function, resizes child windows.
' sizer_block = the auto-sizer information block
' direction = the direction parameter is one of these two values:
' - $$DIR_VERT : a vertical series
' - $$DIR_HORIZ: a horizontal series
' left = left position
' top  = top  position
' new_width = new width
' new_height = new height
' currPos = current position
FUNCTION autoSizer (AUTOSIZERINFO sizer_block, direction, left, top, new_width, new_height, currPos)

	RECT	rect
	SPLITTERINFO splitter_block
	XLONG idSplitter		' id of the splitter

	XLONG currPosNew		' new current position
	XLONG series				' the auto-sizer group

	FUNCADDR leftInfo (XLONG, XLONG)
	FUNCADDR rightInfo (XLONG, XLONG)

	XLONG rest
	XLONG h				' height

	XLONG boxX		' left position
	XLONG boxY		' top position
	XLONG boxW		' width
	XLONG boxH		' height

	IFZ sizer_block.hWnd THEN RETURN
'
' If there is an auto-sizer info block here, resize the window.
'
	' calculate the SIZE
	' first, the x, y, w and h of the box
	SELECT CASE direction AND 0x00000003
		CASE $$DIR_VERT
			IF sizer_block.space <= 1 THEN sizer_block.space = sizer_block.space * new_height

			IF sizer_block.flags AND $$SIZER_SIZERELREST THEN
				IF direction AND $$DIR_REVERSE THEN
					rest = currPos
				ELSE
					rest = new_height - currPos
				ENDIF
				IF sizer_block.size <= 1 THEN
					sizer_block.size = sizer_block.size * rest
				ELSE
					sizer_block.size = rest - sizer_block.size
				ENDIF
				sizer_block.size = sizer_block.size - sizer_block.space
			ELSE
				IF sizer_block.size <= 1 THEN sizer_block.size = sizer_block.size * new_height
			ENDIF

			IF sizer_block.x <= 1 THEN sizer_block.x = sizer_block.x * new_width
			IF sizer_block.y <= 1 THEN sizer_block.y = sizer_block.y * sizer_block.size
			IF sizer_block.w <= 1 THEN sizer_block.w = sizer_block.w * new_width
			IF sizer_block.h <= 1 THEN sizer_block.h = sizer_block.h * sizer_block.size

			boxX = left
			boxY = top + currPos + sizer_block.space
			boxW = new_width
			boxH = sizer_block.size

			IF sizer_block.flags AND $$SIZER_SPLITTER THEN
				boxH = boxH - 8
				sizer_block.h = sizer_block.h - 8

				IF direction AND $$DIR_REVERSE THEN
					h = boxY - boxH - 8
				ELSE
					h = boxY + boxH
				ENDIF
				MoveWindow (sizer_block.hSplitter, boxX, h, boxW, 8, $$FALSE)
				InvalidateRect (sizer_block.hSplitter, 0, $$TRUE)		' erase

				idSplitter = GetWindowLongA (sizer_block.hSplitter, $$GWL_USERDATA)
				SPLITTERINFO_Get (idSplitter, @splitter_block)
				IF direction AND $$DIR_REVERSE THEN
					splitter_block.maxSize = currPos - sizer_block.space
				ELSE
					splitter_block.maxSize = new_height - currPos - sizer_block.space
				ENDIF
				SPLITTERINFO_Update (idSplitter, splitter_block)
			ENDIF

			IF direction AND $$DIR_REVERSE THEN
				boxY = boxY - boxH
			ENDIF

		CASE $$DIR_HORIZ
			IF sizer_block.space <= 1 THEN
				sizer_block.space = sizer_block.space * new_width
			ENDIF

			IF sizer_block.flags AND $$SIZER_SIZERELREST THEN
				IF direction AND $$DIR_REVERSE THEN
					rest = currPos
				ELSE
					rest = new_width - currPos
				ENDIF
				IF sizer_block.size <= 1 THEN
					sizer_block.size = sizer_block.size * rest
				ELSE
					sizer_block.size = rest - sizer_block.size
				ENDIF
				sizer_block.size = sizer_block.size - sizer_block.space
			ELSE
				IF sizer_block.size <= 1 THEN
					sizer_block.size = sizer_block.size * new_width
				ENDIF
			ENDIF

			IF sizer_block.x <= 1 THEN sizer_block.x = sizer_block.x * sizer_block.size
			IF sizer_block.y <= 1 THEN sizer_block.y = sizer_block.y * new_height
			IF sizer_block.w <= 1 THEN sizer_block.w = sizer_block.w * sizer_block.size
			IF sizer_block.h <= 1 THEN sizer_block.h = sizer_block.h * new_height

			boxX = left + currPos + sizer_block.space
			boxY = top
			boxW = sizer_block.size
			boxH = new_height

			IF sizer_block.flags AND $$SIZER_SPLITTER THEN
				boxW = boxW - 8
				sizer_block.w = sizer_block.w - 8

				IF direction AND $$DIR_REVERSE THEN
					h = boxX - boxW - 8
				ELSE
					h = boxX + boxW
				ENDIF
				MoveWindow (sizer_block.hSplitter, h, boxY, 8, boxH, $$FALSE)
				InvalidateRect (sizer_block.hSplitter, 0, $$TRUE)		' erase

				idSplitter = GetWindowLongA (sizer_block.hSplitter, $$GWL_USERDATA)
				SPLITTERINFO_Get (idSplitter, @splitter_block)
				IF direction AND $$DIR_REVERSE THEN
					splitter_block.maxSize = currPos - sizer_block.space
				ELSE
					splitter_block.maxSize = new_width - currPos - sizer_block.space
				ENDIF
				SPLITTERINFO_Update (idSplitter, splitter_block)
			ENDIF

			IF direction AND $$DIR_REVERSE THEN
				boxX = boxX - boxW
			ENDIF

	END SELECT

	' adjust the width and height as necessary
	IF sizer_block.flags AND $$SIZER_WCOMPLEMENT THEN sizer_block.w = boxW - sizer_block.w
	IF sizer_block.flags AND $$SIZER_HCOMPLEMENT THEN sizer_block.h = boxH - sizer_block.h

	' adjust x and y
	IF sizer_block.x < 0 THEN
		sizer_block.x = (boxW - sizer_block.w) \ 2
	ELSE
		IF sizer_block.flags AND $$SIZER_XRELRIGHT THEN sizer_block.x = boxW - sizer_block.x
	ENDIF
	IF sizer_block.y < 0 THEN
		sizer_block.y = (boxH - sizer_block.h) \ 2
	ELSE
		IF sizer_block.flags AND $$SIZER_YRELBOTTOM THEN sizer_block.y = boxH - sizer_block.y
	ENDIF

	IF sizer_block.flags AND $$SIZER_SERIES THEN
		autoSizerInfo_sizeGroup (sizer_block.hWnd, (sizer_block.x + boxX), (sizer_block.y + boxY), sizer_block.w, sizer_block.h)
	ELSE
		' Actually size the control
		IF (sizer_block.w < 1) || (sizer_block.h < 1) THEN
			ShowWindow (sizer_block.hWnd, $$SW_HIDE)
		ELSE
			ShowWindow (sizer_block.hWnd, $$SW_SHOW)
			MoveWindow (sizer_block.hWnd, (sizer_block.x + boxX), (sizer_block.y + boxY), sizer_block.w, sizer_block.h, $$TRUE)
		ENDIF

		leftInfo = GetPropA (sizer_block.hWnd, &"WinXLeftSubSizer")
		rightInfo = GetPropA (sizer_block.hWnd, &"WinXRightSubSizer")
		IF leftInfo THEN
			series = @leftInfo (sizer_block.hWnd, &rect)
			autoSizerInfo_sizeGroup (series, (sizer_block.x + boxX + rect.left), (sizer_block.y + boxY + rect.top), (rect.right - rect.left), (rect.bottom - rect.top))
		ENDIF
		IF rightInfo THEN
			series = @rightInfo (sizer_block.hWnd, &rect)
			autoSizerInfo_sizeGroup (series, (sizer_block.x + boxX + rect.left), _
				(sizer_block.y + boxY + rect.top), (rect.right - rect.left), (rect.bottom - rect.top))
		ENDIF
	ENDIF

	IF direction AND $$DIR_REVERSE THEN
		currPosNew = currPos - sizer_block.space - sizer_block.size
	ELSE
		currPosNew = currPos + sizer_block.space + sizer_block.size
	ENDIF
	RETURN currPosNew

END FUNCTION
'
' ###############################
' #####  autoSizerInfo_add  #####
' ###############################
' Adds a new auto-sizer info block.
' sizer_block = the auto-sizer info block to add
' returns the index of the auto-sizer info block, or -1 on fail
FUNCTION autoSizerInfo_add (group, AUTOSIZERINFO sizer_block)
	SHARED AUTOSIZERINFO autoSizerInfo[]		'info for the auto-sizer
	SHARED SIZELISTHEAD autoSizerInfoUM[]

	AUTOSIZERINFO local_group[]
	XLONG slot		' array index
	XLONG upper_slot		' upper index
	XLONG i		' running index

	slot = -1		' not an index

	SELECT CASE TRUE
		CASE group < 0 || group > UBOUND(autoSizerInfoUM[])

		CASE autoSizerInfoUM[group].inUse
			upper_slot = UBOUND(autoSizerInfo[group,])
			FOR i = 0 TO upper_slot
				IFZ autoSizerInfo[group, i].hWnd THEN
					slot = i
					EXIT FOR
				ENDIF
			NEXT i

			IF slot < 0 THEN
'
' 0.6.0.2-old---
' TECHNICAL TRICK
' ===============
' GL: the deleted code can't compile -bc (bounds checking)
'
'				slot = UBOUND(autoSizerInfo[group, ])+1
'				SWAP local_group[], autoSizerInfo[group, ]
'				REDIM local_group[((UBOUND(local_group[])+1)<<1)-1]
' 0.6.0.2-old===
' 0.6.0.2-new+++
				DIM local_group[]
				SWAP local_group[], autoSizerInfo[group,]		' ie.: "local_group[] := autoSizerInfo[group, ]"
				IFZ local_group[] THEN
					DIM local_group[0]
					slot = 0
				ELSE
					slot = UBOUND(local_group[]) + 1
					upper_slot = (slot * 2) + 1
					REDIM local_group[upper_slot]
				ENDIF
' 0.6.0.2-new===
'
				SWAP local_group[], autoSizerInfo[group,]
			ENDIF

			autoSizerInfo[group, slot] = sizer_block

			autoSizerInfo[group, slot].nextItem = -1

			IF autoSizerInfoUM[group].iTail < 0 THEN
				' Make this the first item
				autoSizerInfoUM[group].iHead = slot
				autoSizerInfoUM[group].iTail = slot
				autoSizerInfo[group, slot].prevItem = -1
			ELSE
				' add this to the end of the list
				autoSizerInfo[group, slot].prevItem = autoSizerInfoUM[group].iTail
				autoSizerInfo[group, autoSizerInfoUM[group].iTail].nextItem = slot
				autoSizerInfoUM[group].iTail = slot
			ENDIF

	END SELECT

	RETURN slot

END FUNCTION
'
' ####################################
' #####  autoSizerInfo_addGroup  #####
' ####################################
' Adds a new group of auto-sizer info blocks.
' returns the index of the new group, or -1 on fail
FUNCTION autoSizerInfo_addGroup (direction)
	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]

	AUTOSIZERINFO local_group[]
	XLONG slot				' array index
	XLONG upper_slot		' upper index
	XLONG i						' running index

	' look for a blank slot
	slot = -1		' not an index
	upper_slot = UBOUND(autoSizerInfoUM[])
	FOR i = 0 TO upper_slot
		IFF autoSizerInfoUM[i].inUse THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	' allocate more memory if needed
	IF slot < 0 THEN
		slot = UBOUND(autoSizerInfoUM[]) + 1
		upper_slot = (slot * 2) + 1
		REDIM autoSizerInfoUM[upper_slot]
		REDIM autoSizerInfo[upper_slot, ]
	ENDIF

	autoSizerInfoUM[slot].inUse = $$TRUE
	autoSizerInfoUM[slot].direction = direction
	autoSizerInfoUM[slot].iHead = -1
	autoSizerInfoUM[slot].iTail = -1

	DIM local_group[0]
	SWAP local_group[], autoSizerInfo[slot, ]

	RETURN slot

END FUNCTION
'
' ##################################
' #####  autoSizerInfo_delete  #####
' ##################################
' Deletes an auto-sizer info block.
' idDraw = the id (index) of the block to delete
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION autoSizerInfo_delete (group, idDraw)
	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]
	XLONG bOK				' $$TRUE for success

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE group < 0 || group > UBOUND(autoSizerInfoUM[])
		CASE idDraw < 0 || idDraw > UBOUND(autoSizerInfo[group, ])

		CASE autoSizerInfoUM[group].inUse
			IF idDraw = autoSizerInfoUM[group].iHead THEN
				autoSizerInfoUM[group].iHead = autoSizerInfo[group, idDraw].nextItem
				autoSizerInfo[group, autoSizerInfo[group, idDraw].nextItem].prevItem = -1
				IF autoSizerInfoUM[group].iHead < 0 THEN autoSizerInfoUM[group].iTail = -1
			ELSE
				IF idDraw = autoSizerInfoUM[group].iTail THEN
					autoSizerInfo[group, autoSizerInfoUM[group].iTail].nextItem = -1
					autoSizerInfoUM[group].iTail = autoSizerInfo[group, idDraw].prevItem
					IF autoSizerInfoUM[group].iTail < 0 THEN autoSizerInfoUM[group].iHead = -1
				ELSE
					autoSizerInfo[group, autoSizerInfo[group, idDraw].nextItem].prevItem = autoSizerInfo[group, idDraw].prevItem
					autoSizerInfo[group, autoSizerInfo[group, idDraw].prevItem].nextItem = autoSizerInfo[group, idDraw].nextItem
				ENDIF
			ENDIF
			autoSizerInfoUM[group].inUse = $$FALSE
			autoSizerInfo[group, idDraw].hWnd = 0

			bOK = $$TRUE		' success

	END SELECT

	RETURN bOK

END FUNCTION
'
' #######################################
' #####  autoSizerInfo_deleteGroup  #####
' #######################################
' Deletes a group of auto-sizer info blocks.
' group = the handler group to delete
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION autoSizerInfo_deleteGroup (group)
	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]

	AUTOSIZERINFO null_item[]

	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE

	autoSizerInfoUM[group].inUse = $$FALSE
	SWAP autoSizerInfo[group, ], null_item[]

	RETURN $$TRUE

END FUNCTION
'
' ###############################
' #####  autoSizerInfo_get  #####
' ###############################
' Gets an auto-sizer info block.
' idDraw = the id (index) of the block to get
' sizer_block = the variable to store the block
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION autoSizerInfo_get (group, idDraw, AUTOSIZERINFO sizer_block)
	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]
	AUTOSIZERINFO null_item
	XLONG bOK				' $$TRUE for success

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE group < 0 || group > UBOUND(autoSizerInfoUM[])
		CASE idDraw < 0 || idDraw > UBOUND(autoSizerInfo[group, ])

		CASE autoSizerInfoUM[group].inUse
			IF autoSizerInfo[group, idDraw].hWnd THEN
				sizer_block = autoSizerInfo[group, idDraw]
				bOK = $$TRUE		' success
			ENDIF

	END SELECT

	IFF bOK THEN
		sizer_block = null_item
	ENDIF
	RETURN bOK

END FUNCTION
'
' #####################################
' #####  autoSizerInfo_showGroup  #####
' #####################################
' Hides or shows an auto-sizer group.
' group = the handler group to hide or show
' visible = $$TRUE to make the handler group visible, $$FALSE to hide them
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION autoSizerInfo_showGroup (group, visible)
	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]
	XLONG command
	XLONG idDraw		' the id of the auto-draw info block
	XLONG bOK				' $$TRUE for success

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE group < 0 || group > UBOUND(autoSizerInfoUM[])

		CASE autoSizerInfoUM[group].inUse
			IF visible THEN command = $$SW_SHOWNA ELSE command = $$SW_HIDE

			idDraw = autoSizerInfoUM[group].iHead
			DO WHILE idDraw > -1
				IF autoSizerInfo[group, idDraw].hWnd THEN
					ShowWindow (autoSizerInfo[group, idDraw].hWnd, command)
				ENDIF

				idDraw = autoSizerInfo[group, idDraw].nextItem
			LOOP

			bOK = $$TRUE		' success

	END SELECT

	RETURN bOK

END FUNCTION
'
' #####################################
' #####  autoSizerInfo_sizeGroup  #####
' #####################################
' Automatically resizes all the controls in an auto-sizer group.
' group = the handler group to resize
' w = the new width of the parent window
' h = the new height of the parent window
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION autoSizerInfo_sizeGroup (group, x0, y0, w, h)
	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]
	XLONG currPos		' current position
	XLONG idDraw		' the id of the auto-draw info block
	XLONG nNumWindows
	XLONG bOK				' $$TRUE for success

	bOK = $$FALSE

	SELECT CASE TRUE
		CASE group < 0 || group > UBOUND(autoSizerInfoUM[])

		CASE autoSizerInfoUM[group].inUse
'
' 0.6.0.2-new+++
			' compute nNumWindows for later call BeginDeferWindowPos (nNumWindows)
			nNumWindows = 0
			idDraw = autoSizerInfoUM[group].iHead
			DO WHILE idDraw > -1
				IF autoSizerInfo[group, idDraw].hWnd THEN
					INC nNumWindows
				ENDIF
				idDraw = autoSizerInfo[group, idDraw].nextItem
			LOOP
			IFZ nNumWindows THEN EXIT SELECT		' none!
' 0.6.0.2-new===
'
			currPos = 0
			IF autoSizerInfoUM[group].direction AND $$DIR_REVERSE THEN
				SELECT CASE autoSizerInfoUM[group].direction AND 0x00000003
					CASE $$DIR_HORIZ : currPos = w
					CASE $$DIR_VERT  : currPos = h
				END SELECT
			ENDIF
'
' 0.6.0.2-old---
'			#hWinPosInfo = BeginDeferWindowPos (10)
' 0.6.0.2-old===
' 0.6.0.2-new+++
			#hWinPosInfo = BeginDeferWindowPos (nNumWindows)
' 0.6.0.2-new===
'
			idDraw = autoSizerInfoUM[group].iHead
			DO WHILE idDraw > -1
				IF autoSizerInfo[group, idDraw].hWnd THEN
					currPos = autoSizer (autoSizerInfo[group, idDraw], autoSizerInfoUM[group].direction, x0, y0, w, h, currPos)
				ENDIF

				idDraw = autoSizerInfo[group, idDraw].nextItem
			LOOP

			EndDeferWindowPos (#hWinPosInfo)

			RETURN $$TRUE		' success

	END SELECT

END FUNCTION
'
' ##################################
' #####  autoSizerInfo_update  #####
' ##################################
' Updates an auto-sizer info block.
' idDraw = the id (index) of the block to update
' sizer_block = the new version of the info block
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION autoSizerInfo_update (group, idDraw, AUTOSIZERINFO sizer_block)
	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]

	SELECT CASE TRUE
		CASE group < 0 || group > UBOUND(autoSizerInfoUM[])
		CASE idDraw < 0 || idDraw > UBOUND(autoSizerInfo[group, ])

		CASE autoSizerInfoUM[group].inUse
			' must be in use
			IF autoSizerInfo[group, idDraw].hWnd THEN
				' must be active
				autoSizerInfo[group, idDraw] = sizer_block
				RETURN $$TRUE		' success
			ENDIF

	END SELECT

END FUNCTION
'
' #########################
' #####  binding_add  #####
' #########################
' Add a binding to the binding table.
' binding = the binding to add
' returns the id of the binding
FUNCTION binding_add (BINDING binding)
	SHARED BINDING bindings[]
	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index

	slot = -1		' not an index

	' look for a blank slot
	upper_slot = UBOUND(bindings[])
	FOR i = 0 TO upper_slot
		IFZ bindings[i].hWnd THEN
			' must be inactive for re-use
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	' allocate more memory if needed
	IF slot < 0 THEN
		slot = upper_slot + 1
'
' 0.6.0.2-old---
'		upper_slot = (slot * 2) + 1
' 0.6.0.2-old===
' 0.6.0.2-new+++
		' Just a few bindings => add them one by one with no fuzz
		upper_slot = slot
' 0.6.0.2-new===
'
		REDIM bindings[upper_slot]
	ENDIF

	' set the binding
	bindings[slot] = binding
	IFZ bindings[slot].hWnd THEN
		msg$ = "WinX-binding_add: Warning - the window's handle is null"
		WinXDialog_Error (@msg$, @"WinX-Information", 0)
	ENDIF

	RETURN (slot + 1)		' return an id, not an index

END FUNCTION
'
' ############################
' #####  binding_delete  #####
' ############################
' Deletes a binding from the binding table.
' id = the id of the binding to delete
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION binding_delete (id)
	SHARED BINDING bindings[]
	LINKEDLIST list

	DEC id

	IF id >= 0 && id <= UBOUND(bindings[]) THEN
		IF bindings[id].hWnd THEN
			' (must be active)
			' delete the auto-draw info
			autoDraw_clear (bindings[id].autoDrawInfo)
			LINKEDLIST_Get (bindings[id].autoDrawInfo, @list)
			LinkedList_Uninit (@list)
			LINKEDLIST_Delete (bindings[id].autoDrawInfo)

			' delete the message handlers
			handler_deleteGroup (bindings[id].msgHandlers)

			' delete the auto-sizer info
			autoSizerInfo_deleteGroup (bindings[id].autoSizerInfo)

			bindings[id].hWnd = 0		' binding is now inactive

			RETURN $$TRUE		' success
		ENDIF
	ENDIF

END FUNCTION
'
' #########################
' #####  binding_get  #####
' #########################
' Retrieves a binding.
' id = the id of the binding to get
' binding = the variable to store the binding
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION binding_get (id, BINDING binding)
	SHARED BINDING bindings[]
	BINDING null_item

	DEC id

	IF id >= 0 && id <= UBOUND(bindings[]) THEN
		IF bindings[id].hWnd THEN
			' must be an active window
			binding = bindings[id]
			RETURN $$TRUE		' success
		ENDIF
	ENDIF
	binding = null_item		' fail

END FUNCTION
'
' ############################
' #####  binding_update  #####
' ############################
' Updates a binding.
' id = the id of the binding to update
' binding = the new version of the binding
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION binding_update (id, BINDING binding)
	SHARED BINDING bindings[]

	DEC id

	IF id >= 0 && id <= UBOUND(bindings[]) THEN
		IF bindings[id].hWnd THEN
			' must be an active window
			bindings[id] = binding
			RETURN $$TRUE		' success
		ENDIF
	ENDIF

END FUNCTION
'
' #####################
' #####  drawArc  #####
' #####################
FUNCTION drawArc (hdc, AUTODRAWRECORD record, x0, y0)

	SetLastError (0)
	IF hdc THEN
		Arc (hdc, (record.rectControl.x1 - x0), (record.rectControl.y1 - y0), (record.rectControl.x2 - x0), _
			(record.rectControl.y2 - y0), (record.rectControl.xC1 - x0), (record.rectControl.yC1 - y0), _
			(record.rectControl.xC2 - x0), (record.rectControl.yC2 - y0))
	ENDIF

END FUNCTION
'
' ########################
' #####  drawBezier  #####
' ########################
FUNCTION drawBezier (hdc, AUTODRAWRECORD record, x0, y0)
	POINT pt[]

	SetLastError (0)
	IF hdc THEN
		DIM pt[3]
		pt[0].x = record.rectControl.x1 - x0
		pt[0].y = record.rectControl.y1 - y0
		pt[1].x = record.rectControl.xC1 - x0
		pt[1].y = record.rectControl.yC1 - y0
		pt[2].x = record.rectControl.xC2 - x0
		pt[2].y = record.rectControl.yC2 - y0
		pt[3].x = record.rectControl.x2 - x0
		pt[3].y = record.rectControl.y2 - y0
		PolyBezier (hdc, &pt[0], 4)
	ENDIF

END FUNCTION
'
' #########################
' #####  drawEllipse  #####
' #########################
' Draw an ellipse with GDI.
' hdc = the dc to draw on
' record = the auto-draw info block
FUNCTION drawEllipse (hdc, AUTODRAWRECORD record, x0, y0)

	SetLastError (0)
	IF hdc THEN
		Ellipse (hdc, (record.rect.x1 - x0), (record.rect.y1 - y0), (record.rect.x2 - x0), (record.rect.y2 - y0))
	ENDIF

END FUNCTION
'
' ###############################
' #####  drawEllipseNoFill  #####
' ###############################
FUNCTION drawEllipseNoFill (hdc, AUTODRAWRECORD record, x0, y0)
	XLONG xMid		' left position of the horizontal middle
	XLONG y1py0		' top position of the vertical middle

	SetLastError (0)
	IF hdc THEN
		xMid = ((record.rect.x1 + record.rect.x2) \ 2) - x0
		y1py0 = record.rect.y1 - y0
		Arc (hdc, (record.rect.x1 - x0), y1py0, (record.rect.x2 - x0), (record.rect.y2 - y0), xMid, y1py0, xMid, y1py0)
	ENDIF

END FUNCTION
'
' ######################
' #####  drawFill  #####
' ######################
FUNCTION drawFill (hdc, AUTODRAWRECORD record, x0, y0)

	SetLastError (0)
	IF hdc THEN
		ExtFloodFill (hdc, (record.simpleFill.x - x0), (record.simpleFill.y - y0), record.simpleFill.col, $$FLOODFILLBORDER)
	ENDIF

END FUNCTION
'
' #######################
' #####  drawImage  #####
' #######################
' Draws an image
FUNCTION drawImage (hdc, AUTODRAWRECORD record, x0, y0)
	BLENDFUNCTION blfn
	XLONG hdcSrc				' the handle of the compatible context
	XLONG hOld			' = SelectObject (hdcSrc, record.image.hImage)

	SetLastError (0)
	IFZ hdc THEN RETURN

	hdcSrc = CreateCompatibleDC (0)
	hOld = SelectObject (hdcSrc, record.image.hImage)
	IF record.image.blend THEN
		blfn.BlendOp = $$AC_SRC_OVER
		blfn.SourceConstantAlpha = 255
		blfn.AlphaFormat = $$AC_SRC_ALPHA
		' AlphaBlend is misdefined in headers, so call it through a wrapper
		ApiAlphaBlend (hdc, (record.image.x - x0), (record.image.y - y0), record.image.w, record.image.h, hdcSrc, _
			record.image.xSrc, record.image.ySrc, record.image.w, record.image.h, blfn)
	ELSE
		BitBlt (hdc, (record.image.x - x0), (record.image.y - y0), record.image.w, record.image.h, hdcSrc, _
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
	SetLastError (0)
	IF hdc THEN
		MoveToEx (hdc, (record.rect.x1 - x0), (record.rect.y1 - y0), 0)
		LineTo (hdc, (record.rect.x2 - x0), (record.rect.y2 - y0))
	ENDIF
END FUNCTION
'
' ######################
' #####  drawRect  #####
' ######################
' draws a rectangle
' hdc = the dc to draw on
' record = the auto-draw info block
FUNCTION drawRect (hdc, AUTODRAWRECORD record, x0, y0)
	XLONG left			' left position
	XLONG top				' top position
	XLONG width
	XLONG height

'	Rectangle (hdc, (record.rect.x1 - x0), (record.rect.y1 - y0), (record.rect.x2 - x0), (record.rect.y2 - y0))
	SetLastError (0)
	IF hdc THEN
		left = record.rect.x1 - x0
		top = record.rect.y1 - y0
		width = record.rect.x2 - x0
		height = record.rect.y2 - y0

		Rectangle (hdc, left, top, width, height)
	ENDIF

END FUNCTION
'
' ############################
' #####  drawRectNoFill  #####
' ############################
FUNCTION drawRectNoFill (hdc, AUTODRAWRECORD record, x0, y0)
	POINT pt[]

	SetLastError (0)
	IFZ hdc THEN RETURN
	DIM pt[4]
	pt[0].x = record.rect.x1 - x0
	pt[0].y = record.rect.y1 - y0
	pt[1].x = record.rect.x2 - x0
	pt[1].y = pt[0].y
	pt[2].x = pt[1].x
	pt[2].y = record.rect.y2 - y0
	pt[3].x = pt[0].x
	pt[3].y = pt[2].y
	pt[4] = pt[0]
	Polyline (hdc, &pt[0], 5)

END FUNCTION
'
' ######################
' #####  drawText  #####
' ######################
' Draws a text string.
FUNCTION drawText (hdc, AUTODRAWRECORD record, x0, y0)
	XLONG options		' ExtTextOutA()'s options

	SetLastError (0)
	IF hdc THEN
		SetTextColor (hdc, record.text.forColor)
		IF record.text.backColor < 0 THEN
			SetBkMode (hdc, $$TRANSPARENT)
		ELSE
			SetBkMode (hdc, $$OPAQUE)
			SetBkColor (hdc, record.text.backColor)
		ENDIF
		STRING_Get (record.text.iString, @text$)
		options = 0
		ExtTextOutA (hdc, (record.text.x - x0), (record.text.y - y0), options, 0, &text$, LEN (text$), 0)
	ENDIF

END FUNCTION
'
' ###################################
' #####  groupBox_SizeContents  #####
' ###################################
' Gets the viewable area for a group box.
' returns the auto-sizer series of the group box, or -1 on fail
FUNCTION groupBox_SizeContents (hGB, pRect)
	RECT	rect
	XLONG aRect		' = &rect

	SetLastError (0)
	IFZ hGB THEN RETURN -1		' fail

	aRect = &rect
	XLONGAT(&&rect) = pRect

	GetClientRect (hGB, &rect)
	rect.left = rect.left + 4
	rect.right = rect.right - 4
	rect.top = rect.top + 16
	rect.bottom = rect.bottom - 4

	XLONGAT(&&rect) = aRect

	RETURN GetPropA (hGB, &"WinXAutoSizerSeries")

END FUNCTION
'
' #########################
' #####  handler_add  #####
' #########################
' Adds a new handler to a group.
' group = the handler group to add the handler to
' handler = the handler to add
' returns the id (index) of the new handler, or -1 on fail
FUNCTION handler_add (group, MSGHANDLER handler)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED SBYTE handlersUM[]	'a usage map so we can see which groups are in use
	MSGHANDLER local_group[]		'a local version of the group
	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG bFound
	XLONG i						' running index

	slot = -1		' not an index

	SELECT CASE TRUE
		CASE handler.msg = 0
			msg$ = "WinX-handler_add: Invalid NULL handler's message"
			WinXDialog_Error (@msg$, @"WinX-Internal Error", 2)

		CASE group < 0 || group > UBOUND(handlers[])

		CASE handlersUM[group]
			upper_slot = UBOUND(handlers[group, ])

			' check if already there
			bFound = $$FALSE
			FOR i = 0 TO upper_slot
				IF handlers[group, i].msg = handler.msg THEN
					bFound = $$TRUE
					EXIT FOR
				ENDIF
			NEXT i
			IF bFound THEN EXIT SELECT

			' find a free slot
			slot = -1		' not an index
			FOR i = 0 TO upper_slot
				IFZ handlers[group, i].msg THEN
					slot = i
					handlers[group, slot] = handler
					EXIT FOR
				ENDIF
			NEXT i

			IF slot < 0 THEN		'allocate more memmory
'
' 0.6.0.2-old---
' TECHNICAL TRICK
' ===============
' GL: the deleted code can't compile -bc (bounds checking)
'
'				slot = UBOUND(handlers[group, ]) + 1
'				SWAP local_group[], handlers[group, ]
'				REDIM local_group[ ((UBOUND(local_group[]) + 1) << 1) - 1]
' 0.6.0.2-old===
' 0.6.0.2-new+++
				DIM local_group[]
				SWAP local_group[], handlers[group, ]		' ie.: "local_group[] := handlers[group, ]"
				IFZ local_group[] THEN
					DIM local_group[0]
					slot = 0
				ELSE
					slot = UBOUND(local_group[]) + 1
'
' 0.6.0.2-old---
'					upper_slot = (slot * 2) + 1
' 0.6.0.2-old===
' 0.6.0.2-new+++
					' Just a few handlers => add them one by one with no fuzz
					upper_slot = slot
' 0.6.0.2-new===
'
					REDIM local_group[upper_slot]
				ENDIF
' 0.6.0.2-new===
'
				' now finish it off
				local_group[slot] = handler

				SWAP handlers[group, ], local_group[]		' ie.: "handlers[group, ] := local_group[]"
			ENDIF

	END SELECT

	' return the id of the handler
	' (which is an index)
	RETURN slot

END FUNCTION
'
' ##############################
' #####  handler_addGroup  #####
' ##############################
' Adds a new group of handlers.
' returns the id of the handler group, or 0 on fail
FUNCTION handler_addGroup ()
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED SBYTE handlersUM[]	'a usage map so we can see which groups are in use

	XLONG slot				' array index
	XLONG upper_slot	' upper index
	XLONG i						' running index

	slot = -1		' not an index

	' look for a blank slot
	upper_slot = UBOUND(handlersUM[])
	FOR i = 0 TO upper_slot
		IFZ handlersUM[i] THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	' allocate more memory if needed
	IF slot < 0 THEN
		slot = upper_slot + 1
'
' 0.6.0.2-old---
		' upper_slot = (slot * 2) + 1
' 0.6.0.2-old===
' 0.6.0.2-new+++
		' Just a few handlers => add them one by one with no fuzz
		upper_slot = slot
' 0.6.0.2-new===
'
		REDIM handlersUM[upper_slot]
		REDIM handlers[upper_slot, ]
	ENDIF

	handlersUM[slot] = $$TRUE

	RETURN (slot + 1)		' return a group id

END FUNCTION
'
' ##########################
' #####  handler_call  #####
' ##########################
' Calls the handler for a specified message.
' group = the handler group to call from
' return_code = the variable to hold the message return value
' hwnd, wMsg, wParam, lParam = the usual definitions for these parameters
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION handler_call (group, @return_code, hWnd, wMsg, wParam, lParam)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED SBYTE handlersUM[]
	XLONG message_id	' the id (index) of the message handler

	return_code = 0

	' first, find the handler
	message_id = handler_find (group, wMsg)
	IF (message_id >= 0) && (message_id <= UBOUND(handlersUM[])) THEN
		IF handlersUM[message_id] THEN
			IF handlers[group, message_id].handler THEN
				' then call it
				return_code = @handlers[group, message_id].handler (hWnd, wMsg, wParam, lParam)
				RETURN $$TRUE
			ENDIF
		ENDIF
	ENDIF

END FUNCTION
'
' ############################
' #####  handler_delete  #####
' ############################
' Delete a single handler
' group and id = the group and id of the handler to delete
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION handler_delete (group, id)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers

	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(handlers[group, ]) THEN RETURN $$FALSE
	IF handlers[group, id].msg = 0 THEN RETURN $$FALSE

	handlers[group, id].msg = 0
	RETURN $$TRUE

END FUNCTION
'
' #################################
' #####  handler_deleteGroup  #####
' #################################
' Deletes a group of handlers.
' group = the handler group to delete
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION handler_deleteGroup (group)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED SBYTE handlersUM[]	'a usage map so we can see which handler groups are in use
	MSGHANDLER null_item[]		'a local version of the handler group

	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN $$FALSE
	IF UBOUND(handlers[group, ]) < 0 THEN RETURN -1

	handlersUM[group] = 0
	SWAP handlers[group, ], null_item[]
	RETURN $$TRUE

END FUNCTION
'
' ##########################
' #####  handler_find  #####
' ##########################
' Finds a handler in the handler group.
' group = the id of the handler group to search
' wMsg = the message to search for
' returns the id (index) of the message handler, -1 if it fails
'  to find anything and -2 if there is a bounds error
FUNCTION handler_find (group, wMsg)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	XLONG i		' running index
	XLONG iMax		' upper index
	XLONG message_id		' the id (index) of the message handler

	IF group >= 0 && group <= UBOUND(handlers[]) THEN
		message_id = -1		' fail
		iMax = UBOUND(handlers[group, ])
		FOR i = 0 TO iMax
			IF handlers[group, i].msg = wMsg THEN
				message_id = i
				EXIT FOR
			ENDIF
		NEXT i
	ELSE
		message_id = -2		' bounds error
	ENDIF

	RETURN message_id

END FUNCTION
'
' #########################
' #####  handler_get  #####
' #########################
' Retrieves a handler from the handler group.
' group and id (index) are the group and index of the handler to retrieve
' handler = the variable to store the handler
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION handler_get (group, id, MSGHANDLER handler)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers

	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(handlers[group, ]) THEN RETURN $$FALSE
	IFZ handlers[group, id].msg THEN RETURN $$FALSE

	handler = handlers[group, id]
	RETURN $$TRUE
END FUNCTION
'
' ############################
' #####  handler_update  #####
' ############################
' Updates an existing handler in the handler group.
' group and id (index) are the group and index of the handler to update
' handler is the new version of the handler
' returns $$TRUE on success, or $$FALSE on fail
FUNCTION handler_update (group, id, MSGHANDLER handler)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers

	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(handlers[group, ]) THEN RETURN $$FALSE
	IFZ handlers[group, id].msg THEN RETURN $$FALSE

	handlers[group, id] = handler
	RETURN $$TRUE

END FUNCTION
'
' #########################
' #####  mainWndProc  #####
' #########################
' The main window procedure.
' parameters and return are as usual
FUNCTION mainWndProc (hWnd, wMsg, wParam, lParam)
	SHARED g_hInst		' a valid global instance ensures proper ressource loading
	SHARED g_drag_button
	SHARED g_drag_item
	SHARED g_drag_image
	SHARED DLM_MESSAGE
	SHARED g_hClipMem		' global memory for clipboard operations

	STATIC s_dragItem
	STATIC s_lastDragItem
'
' Unused---
'	STATIC s_lastW
'	STATIC s_lastH
' Unused===
'
	PAINTSTRUCT	ps
	BINDING			binding
	XLONG		idBinding		' binding id
'
' Unused---
'	BINDING innerBinding
' Unused===
'
	MINMAXINFO mmi
	RECT	rect
	SCROLLINFO si
	DRAGLISTINFO	dli
	TV_HITTESTINFO tvHit
	POINT pt
	POINT mouseXY
	TRACKMOUSEEVENT tme

	XLONG hDC		' = BeginPaint (hWnd, &ps)
	XLONG x, y

	XLONG typeBar	' status bar type
	XLONG sbval		' status bar value
	XLONG high		'  HIWORD(word)
	XLONG low		'  LOWORD(word)

' direction = the direction is one of these two values:
' - $$DIR_VERT : a vertical series
' - $$DIR_HORIZ: a horizontal series
	XLONG direction
	XLONG scrollUnit

	XLONG ret			' win32 api return value (0 for fail)
	XLONG bOK			' $$TRUE for success

	XLONG pMmi			' = &mmi
	XLONG pNmkey		' = &nmkey
'	XLONG pNmkey		' = &nmkey

	XLONG cFiles	' file count
	XLONG cChar		' number of characters
	XLONG i				' running index
	XLONG iMax		' upper index

	XLONG xOff
	XLONG yOff

	XLONG winWidth		' = LOWORD(lParam)
	XLONG winHeight		' = HIWORD(lParam)

	XLONG curr_dragItem		' item currently dragged
	XLONG cursor
	XLONG sizeBuf

	' SLONG (32 bits) is for Win32 API
	SLONG notifyCode, idCtr, hCtr

	' Message handled with a return code.
	XLONG handled		' handled = $$TRUE => message handled
	XLONG return_code		' return code when handled = $$TRUE

	SetLastError (0)
	IFZ hWnd THEN RETURN		' fail

	' set to true if we handle the message
	handled = $$FALSE		' message NOT handled

	' mainWndProc return code
	return_code = 0

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN
		RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam)
	ENDIF

	' call any associated message handler
	IF binding.msgHandlers THEN
		bOK = handler_call (binding.msgHandlers, @ret, hWnd, wMsg, wParam, lParam)
		IF bOK THEN
			' message handled
			return_code = ret
			handled = $$TRUE
		ENDIF
	ENDIF

	'and handle the message
	SELECT CASE wMsg
		CASE $$WM_DRAWCLIPBOARD
			IF binding.hWndNextClipViewer THEN SendMessageA (binding.hWndNextClipViewer, $$WM_DRAWCLIPBOARD, wParam, lParam)
			RETURN @binding.onClipChange()

		CASE $$WM_CHANGECBCHAIN
			IF wParam = binding.hWndNextClipViewer THEN
				binding.hWndNextClipViewer = lParam
			ELSE
				IF binding.hWndNextClipViewer THEN
					SendMessageA (binding.hWndNextClipViewer, $$WM_CHANGECBCHAIN, wParam, lParam)
				ENDIF
			ENDIF

			RETURN 0
		CASE $$WM_DESTROYCLIPBOARD
			IF g_hClipMem THEN
				GlobalFree (g_hClipMem)
				g_hClipMem = 0		'prevent from freeing twice g_hClipMem
			ENDIF
			RETURN 0

		CASE $$WM_DROPFILES
			DragQueryPoint (wParam, &pt)
			cFiles = DragQueryFileA (wParam, -1, 0, 0)
			IF cFiles > 0 THEN
				iMax = cFiles - 1
				DIM fileList$[iMax]
				FOR i = 0 TO iMax
					cChar = DragQueryFileA (wParam, i, 0, 0)
					IF cChar > 0 THEN
						szBuf$ = NULL$ (cChar + 1)		' ensure a nul-terminator
						DragQueryFileA (wParam, i, &szBuf$, cChar)
						fileList$[i] = CSTRING$(&szBuf$)
					ENDIF
				NEXT i
				DragFinish (wParam)

				RETURN @binding.onDropFiles(hWnd, pt.x, pt.y, @fileList$[])
			ENDIF

			DragFinish (wParam)
			RETURN 0
		CASE $$WM_COMMAND		' User selected a command
'
' 0.6.0.2-old---
'			RETURN @binding.onCommand(LOWORD(wParam), HIWORD(wParam), lParam)
' 0.6.0.2-old===
' 0.6.0.2-new+++
'
' normal---
'			notifyCode = HIWORD(wParam)
'			idCtr = LOWORD(wParam)
' normal===
' speedy+++
			' Split wParam into its high and low parts.
ASM mov eax, d[mainWndProc.wParam]
ASM mov ebx, 65536
ASM cdq
ASM idiv ebx
ASM mov d[mainWndProc.notifyCode], eax	; = HIWORD
ASM mov d[mainWndProc.idCtr], edx	; = LOWORD
' speedy===
'
			hCtr = lParam
			'
			IF binding.onCommand THEN
				RETURN @binding.onCommand(idCtr, notifyCode, hCtr)
			ENDIF
			IF binding.useDialogInterface THEN
				' User hit escape: hide the dialog.
				SELECT CASE idCtr
					CASE $$IDCANCEL
						' handle the Escape key
						IF notifyCode = $$BN_CLICKED THEN
							ShowWindow (hWnd, $$SW_HIDE)
							RETURN 1
						ENDIF
						'
				END SELECT
			ENDIF
			RETURN 0
' 0.6.0.2-new===
'
		CASE $$WM_ERASEBKGND		' the window background must be erased
			IF binding.backCol THEN
				GetClientRect (hWnd, &rect)
				FillRect (wParam, &rect, binding.backCol)
				RETURN 0
			ELSE
				RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam)
			ENDIF
		CASE $$WM_PAINT
			hDC = BeginPaint (hWnd, &ps)

			'use auto-draw
			WinXGetUseableRect (hWnd, @rect)
'
' DELETED---
'			' Auto scroll?
'			IF binding.hScrollPageM THEN
'				GetScrollInfo (hWnd, $$SB_HORZ, &si)
'				xOff = (si.nPos-binding.hScrollPageC)\binding.hScrollPageM
'				GetScrollInfo (hWnd, $$SB_VERT, &si)
'				yOff = (si.nPos-binding.hScrollPageC)\binding.hScrollPageM
'			ENDIF
' DELETED===
'
' GL-old---
'			autoDraw_draw(hDC, binding.autoDrawInfo, xOff, yOff)
' GL-old===
' GL-new+++
			'use auto-draw
			' .autoDrawInfo is an id (>= 1)
			IF binding.autoDrawInfo > 0 THEN
				autoDraw_draw(hDC, binding.autoDrawInfo, xOff, yOff)
			ENDIF
' GL-new===
'
			IF binding.paint THEN
				return_code = @binding.paint(hWnd, hDC)
			ENDIF
			EndPaint (hWnd, &ps)

			RETURN return_code
		CASE $$WM_SIZE
			' new size of the client area
'
' normal---
'			winWidth  = LOWORD(lParam)
'			winHeight = HIWORD(lParam)
' normal===
' speedy+++
			' Split lParam into its winHeight and winWidth parts.
ASM mov eax, d[mainWndProc.lParam]
ASM mov ebx, 65536
ASM cdq
ASM idiv ebx
ASM mov d[mainWndProc.winHeight], eax; = HIWORD
ASM mov d[mainWndProc.winWidth], edx; = LOWORD
' speedy===
'
			' resize the window
			sizeWindow (hWnd, winWidth, winHeight)
			handled = $$TRUE		' message handled
		CASE $$WM_HSCROLL, $$WM_VSCROLL
			' TrackBar scrolling.
			sizeBuf = LEN ($$TRACKBAR_CLASS)
			szBuf$ = NULL$ (sizeBuf + 1)		' to preserve the nul-terminator
			GetClassNameA (lParam, &szBuf$, sizeBuf)
			szBuf$ = TRIM$(CSTRING$(&szBuf$))
			IF szBuf$ = $$TRACKBAR_CLASS THEN
				RETURN @binding.onTrackerPos(GetDlgCtrlID (lParam), SendMessageA (lParam, $$TBM_GETPOS, 0, 0))
			ENDIF

			IF wMsg = $$WM_HSCROLL THEN
				typeBar = $$SB_HORZ
				direction = $$DIR_HORIZ
				scrollUnit = binding.hScrollUnit
			ELSE
				typeBar = $$SB_VERT
				direction = $$DIR_VERT
				scrollUnit = binding.vScrollUnit
			ENDIF

			' Default scrolling.
			si.cbSize = SIZE(SCROLLINFO)
			si.fMask = $$SIF_ALL OR $$SIF_DISABLENOSCROLL
			GetScrollInfo (hWnd, typeBar, &si)

			IF si.nPage <= (si.nMax - si.nMin) THEN
'
' normal---
'				sbval = LOWORD(wParam)
' normal===
' speedy+++
ASM mov eax, d[mainWndProc.wParam]
ASM and eax, 65535
ASM mov d[mainWndProc.sbval], eax	; = LOWORD
' speedy===
'
				SELECT CASE sbval
					CASE $$SB_TOP
						si.nPos = 0
					CASE $$SB_BOTTOM
						si.nPos = si.nMax - si.nPage + 1
					CASE $$SB_LINEUP
						IF si.nPos < scrollUnit THEN si.nPos = 0 ELSE si.nPos = si.nPos - scrollUnit
					CASE $$SB_LINEDOWN
						IF si.nPos + scrollUnit > si.nMax - si.nPage + 1 THEN si.nPos = si.nMax - si.nPage + 1 ELSE si.nPos = si.nPos + scrollUnit
					CASE $$SB_PAGEUP
						IF si.nPos < si.nPage THEN si.nPos = 0 ELSE si.nPos = si.nPos - si.nPage
					CASE $$SB_PAGEDOWN
						IF si.nPos + si.nPage > (si.nMax - si.nPage + 1) THEN si.nPos = si.nMax - si.nPage + 1 ELSE si.nPos = si.nPos + si.nPage
					CASE $$SB_THUMBTRACK
						si.nPos = si.nTrackPos
				END SELECT
			ENDIF

			SetScrollInfo (hWnd, typeBar, &si, $$TRUE)
			RETURN @binding.onScroll(si.nPos, hWnd, direction)
'
' DELETED---
' This allows for mouse activation of child windows, for some reason $$WM_ACTIVATE doesn't work
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
' DELETED===
'
		CASE $$WM_SETFOCUS
			IF binding.onFocusChange THEN
				RETURN @binding.onFocusChange(hWnd, $$TRUE)
			ENDIF
		CASE $$WM_KILLFOCUS
			IF binding.onFocusChange THEN
				RETURN @binding.onFocusChange(hWnd, $$FALSE)
			ENDIF
		CASE $$WM_SETCURSOR
			IF binding.hCursor && LOWORD(lParam) = $$HTCLIENT THEN
				SetCursor (binding.hCursor)
				RETURN $$TRUE
			ENDIF
		CASE $$WM_MOUSEMOVE
'
' normal---
'			mouseXY.x = LOWORD(lParam)
'			mouseXY.y = HIWORD(lParam)
' normal===
' speedy+++
			' Split lParam into its high and low parts.
ASM mov eax, d[mainWndProc.lParam]
ASM mov ebx, 65536
ASM cdq
ASM idiv ebx
ASM mov d[mainWndProc.high], eax; = HIWORD
ASM mov d[mainWndProc.low], edx; = LOWORD
			mouseXY.x = low
			mouseXY.y = high
' speedy===
'
			IFF binding.isMouseInWindow THEN
				tme.cbSize = SIZE(tme)
				tme.dwFlags = $$TME_LEAVE
				tme.hwndTrack = hWnd
				TrackMouseEvent (&tme)
				' and update the binding
				binding.isMouseInWindow = $$TRUE
				binding_update (idBinding, binding)

				@binding.onEnterLeave(hWnd, $$TRUE)
			ENDIF

			SELECT CASE g_drag_button
				CASE $$MBT_LEFT, $$MBT_RIGHT
					GOSUB dragTreeViewItem
					IFZ return_code THEN
						cursor = $$IDC_NO
					ELSE
						cursor = $$IDC_ARROW
					ENDIF
					SetCursor (LoadCursorA (0, cursor))
					RETURN 0		' clear .onDrag() returned value
				CASE ELSE
					RETURN @binding.onMouseMove(hWnd, mouseXY.x, mouseXY.y)
			END SELECT
		CASE $$WM_MOUSELEAVE
			' and update the binding
			binding.isMouseInWindow = $$FALSE
			binding_update (idBinding, binding)

			@binding.onEnterLeave(hWnd, $$FALSE)
			RETURN 0
		CASE $$WM_LBUTTONDOWN
			' mouse's left button pressed down
'
' normal---
'			mouseXY.x = LOWORD(lParam)
'			mouseXY.y = HIWORD(lParam)
' normal===
' speedy+++
			' Split lParam into its high and low parts.
ASM mov eax, d[mainWndProc.lParam]
ASM mov ebx, 65536
ASM cdq
ASM idiv ebx
ASM mov d[mainWndProc.high], eax; = HIWORD
ASM mov d[mainWndProc.low], edx; = LOWORD
			mouseXY.x = low
			mouseXY.y = high
' speedy===
'
			RETURN @binding.onMouseDown(hWnd, $$MBT_LEFT, mouseXY.x, mouseXY.y)
		CASE $$WM_MBUTTONDOWN
			' mouse's middle button pressed down
'
' normal---
'			mouseXY.x = LOWORD(lParam)
'			mouseXY.y = HIWORD(lParam)
' normal===
' speedy+++
			' Split lParam into its high and low parts.
ASM mov eax, d[mainWndProc.lParam]
ASM mov ebx, 65536
ASM cdq
ASM idiv ebx
ASM mov d[mainWndProc.high], eax; = HIWORD
ASM mov d[mainWndProc.low], edx; = LOWORD
			mouseXY.x = low
			mouseXY.y = high
' speedy===
'
			RETURN @binding.onMouseDown(hWnd, $$MBT_MIDDLE, mouseXY.x, mouseXY.y)
		CASE $$WM_RBUTTONDOWN
			' mouse's right button pressed down
'
' normal---
'			mouseXY.x = LOWORD(lParam)
'			mouseXY.y = HIWORD(lParam)
' normal===
' speedy+++
			' Split lParam into its high and low parts.
ASM mov eax, d[mainWndProc.lParam]
ASM mov ebx, 65536
ASM cdq
ASM idiv ebx
ASM mov d[mainWndProc.high], eax; = HIWORD
ASM mov d[mainWndProc.low], edx; = LOWORD
			mouseXY.x = low
			mouseXY.y = high
' speedy===
'
			RETURN @binding.onMouseDown(hWnd, $$MBT_RIGHT, mouseXY.x, mouseXY.y)
		CASE $$WM_LBUTTONUP
			' mouse's left button released
'
' normal---
'			mouseXY.x = LOWORD(lParam)
'			mouseXY.y = HIWORD(lParam)
' normal===
' speedy+++
			' Split lParam into its high and low parts.
ASM mov eax, d[mainWndProc.lParam]
ASM mov ebx, 65536
ASM cdq
ASM idiv ebx
ASM mov d[mainWndProc.high], eax; = HIWORD
ASM mov d[mainWndProc.low], edx; = LOWORD
			mouseXY.x = low
			mouseXY.y = high
' speedy===
'
			IF g_drag_button = $$MBT_LEFT THEN
				' dragged with mouse's left button
				GOSUB dragTreeViewItem
				' g_drag_item == tvHit.hItem
				@binding.onDrag(GetDlgCtrlID (tvHit.hItem), $$DRAG_DONE, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
				GOSUB endDragTreeViewItem
				RETURN 0
			ELSE
				' dragged with mouse's right button
				RETURN @binding.onMouseUp(hWnd, $$MBT_LEFT, mouseXY.x, mouseXY.y)
			ENDIF
		CASE $$WM_MBUTTONUP
			' dragged with mouse's middle button
'
' normal---
'			mouseXY.x = LOWORD(lParam)
'			mouseXY.y = HIWORD(lParam)
' normal===
' speedy+++
			' Split lParam into its high and low parts.
ASM mov eax, d[mainWndProc.lParam]
ASM mov ebx, 65536
ASM cdq
ASM idiv ebx
ASM mov d[mainWndProc.high], eax; = HIWORD
ASM mov d[mainWndProc.low], edx; = LOWORD
			mouseXY.x = low
			mouseXY.y = high
' speedy===
'
			RETURN @binding.onMouseUp(hWnd, $$MBT_MIDDLE, mouseXY.x, mouseXY.y)
		CASE $$WM_RBUTTONUP
			' dragged with mouse's right button
'
' normal---
'			mouseXY.x = LOWORD(lParam)
'			mouseXY.y = HIWORD(lParam)
' normal===
' speedy+++
			' Split lParam into its high and low parts.
ASM mov eax, d[mainWndProc.lParam]
ASM mov ebx, 65536
ASM cdq
ASM idiv ebx
ASM mov d[mainWndProc.high], eax; = HIWORD
ASM mov d[mainWndProc.low], edx; = LOWORD
			mouseXY.x = low
			mouseXY.y = high
' speedy===
'
			IF g_drag_button = $$MBT_LEFT THEN
				GOSUB dragTreeViewItem
				' g_drag_item == tvHit.hItem
				@binding.onDrag(GetDlgCtrlID (tvHit.hItem), $$DRAG_DONE, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
				GOSUB endDragTreeViewItem
				RETURN 0
			ELSE
				RETURN @binding.onMouseUp(hWnd, $$MBT_RIGHT, mouseXY.x, mouseXY.y)
			ENDIF
		CASE $$WM_MOUSEWHEEL
'
' normal---
'			mouseXY.x = LOWORD(lParam)
'			mouseXY.y = HIWORD(lParam)
' normal===
' speedy+++
			' Split lParam into its high and low parts.
ASM mov eax, d[mainWndProc.lParam]
ASM mov ebx, 65536
ASM cdq
ASM idiv ebx
ASM mov d[mainWndProc.high], eax	; = HIWORD
ASM mov d[mainWndProc.low], edx	; = LOWORD
			mouseXY.x = low
			mouseXY.y = high
' speedy===
'
' MESSAGE BROKEN---
' This message is broken.  It gets passed to active window rather than the window under the mouse
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
				RETURN @binding.onMouseWheel(hWnd, HIWORD(wParam), mouseXY.x, mouseXY.y)
' kept===
' -------------------------------------------------------
'			ELSE
'				IF innerBinding.onMouseWheel THEN
'					RETURN @innerBinding.onMouseWheel(hChild, HIWORD(wParam), LOWORD(lParam), HIWORD(lParam))
'				ELSE
'					RETURN @binding.onMouseWheel(hWnd, HIWORD(wParam), LOWORD(lParam), HIWORD(lParam))
'				END IF
'			END IF
' MESSAGE BROKEN===
'
		CASE $$WM_KEYDOWN
			RETURN @binding.onKeyDown(hWnd, wParam)
		CASE $$WM_KEYUP
			RETURN @binding.onKeyUp(hWnd, wParam)
		CASE $$WM_CHAR
			RETURN @binding.onChar(hWnd, wParam)

		CASE DLM_MESSAGE
			IF DLM_MESSAGE THEN
				RtlMoveMemory (&dli, lParam, SIZE(DRAGLISTINFO))
				SELECT CASE dli.uNotification
					CASE $$DL_BEGINDRAG
						curr_dragItem = ApiLBItemFromPt (dli.hWnd, dli.ptCursor.x, dli.ptCursor.y, $$TRUE)
						WinXListBox_AddItem (dli.hWnd, -1, " ")
						RETURN @binding.onDrag(wParam, $$DRAG_START, curr_dragItem, dli.ptCursor.x, dli.ptCursor.y)
					CASE $$DL_CANCELDRAG
						IF binding.onDrag THEN
							@binding.onDrag(wParam, $$DRAG_DONE, -1, dli.ptCursor.x, dli.ptCursor.y)
						ENDIF
						WinXListBox_RemoveItem (dli.hWnd, -1)
						RETURN 0

					CASE $$DL_DRAGGING
						curr_dragItem = ApiLBItemFromPt (dli.hWnd, dli.ptCursor.x, dli.ptCursor.y, $$TRUE)
						IF curr_dragItem >= 0 THEN
							IF @binding.onDrag(wParam, $$DRAG_DRAGGING, curr_dragItem, dli.ptCursor.x, dli.ptCursor.y) THEN
								IF curr_dragItem != s_dragItem THEN
									' Start dragging.
									SendMessageA (dli.hWnd, $$LB_GETITEMRECT, curr_dragItem, &rect)
									InvalidateRect (dli.hWnd, 0, $$TRUE)		' erase
									UpdateWindow (dli.hWnd)
									hDC = GetDC (dli.hWnd)

									'draw insert bar
									MoveToEx (hDC, rect.left + 1, rect.top - 1, 0)
									LineTo (hDC, rect.right - 1, rect.top - 1)

									MoveToEx (hDC, rect.left + 1, rect.top, 0)
									LineTo (hDC, rect.right - 1, rect.top)

									MoveToEx (hDC, rect.left + 1, rect.top - 3, 0)
									LineTo (hDC, rect.left + 1, rect.top + 3)

									MoveToEx (hDC, rect.left + 2, rect.top - 2, 0)
									LineTo (hDC, rect.left + 2, rect.top + 2)

									MoveToEx (hDC, rect.right - 2, rect.top - 3, 0)
									LineTo (hDC, rect.right - 2, rect.top + 3)

									MoveToEx (hDC, rect.right - 3, rect.top - 2, 0)
									LineTo (hDC, rect.right - 3, rect.top + 2)

									ReleaseDC (dli.hWnd, hDC)
									s_dragItem = curr_dragItem
								ENDIF
								RETURN $$DL_MOVECURSOR
							ELSE
								IF curr_dragItem != s_dragItem THEN
									InvalidateRect (dli.hWnd, 0, $$TRUE)
									s_dragItem = curr_dragItem
								ENDIF
								RETURN $$DL_STOPCURSOR
							ENDIF
						ELSE
							IF curr_dragItem != s_dragItem THEN
								InvalidateRect (dli.hWnd, 0, $$TRUE)
								s_dragItem = -1
							ENDIF
							RETURN $$DL_STOPCURSOR
						ENDIF

					CASE $$DL_DROPPED
						InvalidateRect (dli.hWnd, 0, $$TRUE)
						curr_dragItem = ApiLBItemFromPt (dli.hWnd, dli.ptCursor.x, dli.ptCursor.y, $$TRUE)
						IFF @binding.onDrag(wParam, $$DRAG_DRAGGING, curr_dragItem, dli.ptCursor.x, dli.ptCursor.y) THEN curr_dragItem = -1
						@binding.onDrag(wParam, $$DRAG_DONE, curr_dragItem, dli.ptCursor.x, dli.ptCursor.y)
						WinXListBox_RemoveItem (dli.hWnd, -1)

				END SELECT
			ENDIF
			handled = $$TRUE		' message handled

		CASE $$WM_GETMINMAXINFO
			pMmi = &mmi
			XLONGAT(&&mmi) = lParam
			mmi.ptMinTrackSize.x = binding.minW
			mmi.ptMinTrackSize.y = binding.minH
			XLONGAT(&&mmi) = pMmi
			handled = $$TRUE		' message handled

		CASE $$WM_PARENTNOTIFY
'
' normal---
'			SELECT CASE LOWORD(wParam)
' normal===
' speedy+++
			' Split wParam into its high and low parts.
ASM mov eax, d[mainWndProc.wParam]
ASM and eax, 65535 ; clear HIWORD
ASM mov d[mainWndProc.low], eax	; = LOWORD
			SELECT CASE low
' speedy===
'
				CASE $$WM_DESTROY		' parent is being destroyed
					'free the auto-sizer block if there is one
					autoSizerInfo_delete (binding.autoSizerInfo, GetPropA (lParam, &"autoSizerInfoBlock") - 1)
			END SELECT
			handled = $$TRUE		' message handled

		CASE $$WM_NOTIFY		' notification message
'
' 0.6.0.2-old---
'			RETURN onNotify (hWnd, wParam, lParam, binding)
' 0.6.0.2-old===
			ret = onNotify (hWnd, wParam, lParam, binding)
			IF ret THEN
				handled = $$TRUE		' message handled
				return_code = ret
			ENDIF
' 0.6.0.2-new+++
'
		CASE $$WM_TIMER
			SELECT CASE wParam
				CASE -1
					IF s_lastDragItem = s_dragItem THEN
						ImageList_DragShowNolock ($$FALSE)
						SendMessageA (g_drag_item, $$TVM_EXPAND, $$TVE_EXPAND, s_dragItem)
						ImageList_DragShowNolock ($$TRUE)
					ENDIF
					KillTimer (hWnd, -1)
			END SELECT
			RETURN 0

		CASE $$WM_CLOSE		' closed by User
'
' 0.6.0.2-old---
'			IFZ binding.onClose THEN
'				DestroyWindow (hWnd)
'				PostQuitMessage($$WM_QUIT)		' quit program
'			ELSE
'				RETURN @binding.onClose(hWnd)
'			ENDIF
' 0.6.0.2-old===
' 0.6.0.2-new+++
			' Assume that $$WM_CLOSE is NOT confirmed.
			ret = 0

			IF binding.onCommand THEN
				' First chance to cancel closing:
				' a non-zero return code will cancel WinX default closing.
'
' ======================================================
' GL-03apr15-Note:
' User closed the window, the parameters passed to .onCommand()
' inform the calling application:
' 1.idCtr == 0 => the window is concerned
' 2.notifyCode == $$WM_CLOSE
' 3.hWnd is passed to spare a "hWnd = GetActiveWindow ()"
' ======================================================
'
				ret = @binding.onCommand(0, $$WM_CLOSE, hWnd)
				' ret <> 0 => $$WM_CLOSE was confirmed by .onCommand().
			ENDIF

			IFZ ret THEN
				IF binding.onClose THEN
					' Second chance to cancel closing:
					' a non-zero return code will cancel WinX default closing.
					ret = @binding.onClose(hWnd)
					' ret <> 0 => $$WM_CLOSE was confirmed by .onClose().
				ENDIF
			ENDIF

			IF ret THEN
				' $$WM_CLOSE was confirmed either by .onCommand() or by .onClose().
				handled = $$TRUE		' message handled

				IF idBinding = 1 THEN
					' User destroyed the main window to exit application
					'DestroyWindow (hWnd)		' trigger $$WM_DESTROY on active window
					WinXCleanUp ()		' GUI clean-up
					PostQuitMessage ($$WM_QUIT)		' quit program
				ENDIF
			ENDIF
' 0.6.0.2-new===
'
		CASE $$WM_DESTROY		' being destroyed
'
' 0.6.0.3-new+++
			ShowWindow (hWnd, $$SW_HIDE)
' 0.6.0.3-new===
'
			ChangeClipboardChain (hWnd, binding.hWndNextClipViewer)

			'clear the binding
			Delete_the_binding (idBinding)
			handled = $$TRUE		' message handled
	END SELECT

	IF handled THEN
		' message handled with an eventual return code
		RETURN return_code
	ELSE
		RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam)		' message not handled
	ENDIF

	SUB dragTreeViewItem
		tvHit.pt.x = LOWORD(lParam)
		tvHit.pt.y = HIWORD(lParam)
		ClientToScreen (hWnd, &tvHit.pt)
		pt = tvHit.pt

		GetWindowRect (g_drag_item, &rect)
		tvHit.pt.x = tvHit.pt.x - rect.left
		tvHit.pt.y = tvHit.pt.y - rect.top

		SendMessageA (g_drag_item, $$TVM_HITTEST, 0, &tvHit)

		IF tvHit.hItem != s_dragItem THEN
			ImageList_DragShowNolock ($$FALSE)
			SendMessageA (g_drag_item, $$TVM_SELECTITEM, $$TVGN_DROPHILITE, tvHit.hItem)
			ImageList_DragShowNolock ($$TRUE)
			s_dragItem = tvHit.hItem
		ENDIF

		IF WinXTreeView_GetChildItem (g_drag_item, tvHit.hItem) THEN
			SetTimer (hWnd, -1, 400, 0)
			s_lastDragItem = s_dragItem
		ENDIF

		ret = @binding.onDrag(GetDlgCtrlID (g_drag_item), $$DRAG_DRAGGING, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
		IF ret THEN
			handled = $$TRUE		' message handled
			return_code = ret
		ENDIF
		ImageList_DragMove (pt.x, pt.y)
	END SUB
'
'Ends drag operation.
'
	SUB endDragTreeViewItem
		IF g_drag_button THEN
			g_drag_button = 0		' reset the global dragging indicator to a non-dragging state
			IF g_drag_image THEN
				ImageList_EndDrag ()		' inform image list that dragging has stopped
				ImageList_Destroy (g_drag_image)
				g_drag_image = 0
			ENDIF
			ReleaseCapture ()		' release the mouse capture
			SendMessageA (g_drag_item, $$TVM_SELECTITEM, $$TVGN_DROPHILITE, 0)
		ENDIF
	END SUB
END FUNCTION		' mainWndProc
'
' ######################
' #####  onNotify  #####
' ######################
' Handles notify messages.
FUNCTION onNotify (hWnd, wParam, lParam, BINDING binding)
	SHARED g_drag_button
	SHARED g_drag_item
	SHARED g_drag_image

	XLONG		idBinding		' binding id
	NMHDR nmhdr
	TV_DISPINFO nmtvdi
	NM_TREEVIEW nmtv
	LV_DISPINFO nmlvdi
	NMKEY nmkey
	NM_LISTVIEW nmlv
	NMSELCHANGE nmsc
	RECT	rect
	SYSTEMTIME sysTime		' for message $$MCN_SELCHANGE

	XLONG pNmhdr		' = &nmhdr
	XLONG pNmsc			' = &nmsc
	XLONG pNmkey		' = &nmkey
	XLONG pNmtvdi		' = &nmtvdi
	XLONG pNmtv			' = &nmtv
	XLONG pNmlv			' = &nmlv
	XLONG pNmlvdi		' = &nmlvdi

	XLONG width
	XLONG height

	XLONG hDCtv			' = GetDC (nmtv.hdr.hwndFrom)
	XLONG mDC				' = CreateCompatibleDC (hDCtv)
	XLONG hBitmap		' handle of the bitmap
	XLONG hEmpty		' = SelectObject (mDC, hBitmap)

	XLONG currTab			' selected tab of the tabs control
	XLONG maxTab			' upper index
	XLONG i						' running index

	XLONG hLV					' handle of a list view
	XLONG hTV					' handle of a tree view

	' SLONG (32 bits) is for Win32 API
	SLONG notifyCode, idCtr, hCtr
	XLONG return_code		' return code when handled = $$TRUE
	XLONG ret

	SetLastError (0)
	IFZ hWnd THEN RETURN 0		' fail
	IFZ lParam THEN RETURN 0		' fail

	return_code = 0		' not handled

	pNmhdr = &nmhdr
	XLONGAT(&&nmhdr) = lParam

	SELECT CASE nmhdr.code
		CASE $$NM_CLICK, $$NM_DBLCLK, $$NM_RCLICK, $$NM_RDBLCLK, $$NM_RETURN, $$NM_HOVER
			return_code = @binding.onItem(nmhdr.idFrom, nmhdr.code, 0)
		CASE $$NM_KEYDOWN
			IF binding.onItem THEN
				pNmkey = &nmkey
				XLONGAT(&&nmkey) = lParam
				return_code = @binding.onItem(nmhdr.idFrom, nmhdr.code, nmkey.nVKey)
				XLONGAT(&&nmkey) = pNmkey
			ENDIF
'
' 0.6.0.2-old---
'		CASE $$MCN_SELECT
'			pNmsc = &nmsc
'			XLONGAT(&&nmsc) = lParam
'			return_code = @binding.onCalendarSelect (nmhdr.idFrom, nmsc.stSelStart)
'			XLONGAT(&&nmsc) = pNmsc
' 0.6.0.2-old===
' 0.6.0.2-new+++
		CASE $$MCN_SELECT, $$MCN_SELCHANGE
			IFZ binding.onCalendarSelect THEN EXIT SELECT
			pNmsc = &nmsc
			XLONGAT(&&nmsc) = lParam
			IF notifyCode = $$MCN_SELECT THEN
				sysTime = nmsc.stSelStart
			ELSE
				SendMessageA (nmsc.hdr.hwndFrom, $$MCM_GETCURSEL, SIZE(SYSTEMTIME), &sysTime)
			ENDIF
			return_code = @binding.onCalendarSelect (nmhdr.idFrom, sysTime)
			XLONGAT(&&nmsc) = pNmsc
' 0.6.0.2-new===
'
		CASE $$TVN_BEGINLABELEDIT		'  sent as notification
			' the program sent a message $$TVM_EDITLABEL
			IF binding.onLabelEdit THEN
				pNmtvdi = &nmtvdi
				XLONGAT(&&nmtvdi) = lParam
				' .onLabelEdit(idCtr, edit_const, edit_item, newLabel$)
				ret = @binding.onLabelEdit(nmtvdi.hdr.idFrom, $$EDIT_START, nmtvdi.item.hItem, "")
				IFZ ret THEN
					return_code = 1		' message handled
				ENDIF
				XLONGAT(&&nmtvdi) = pNmtvdi
			ENDIF
		CASE $$TVN_ENDLABELEDIT
			IFZ binding.onLabelEdit THEN EXIT SELECT
			pNmtvdi = &nmtvdi
			XLONGAT(&&nmtvdi) = lParam
'
' 0.6.0.2-old---
'			return_code = @binding.onLabelEdit(nmtvdi.hdr.idFrom, $$EDIT_DONE, nmtvdi.item.hItem, CSTRING$(nmtvdi.item.pszText))
' 0.6.0.2-old===
' 0.6.0.2-new+++
			newLabel$ = CSTRING$(nmtvdi.item.pszText)
			IFZ binding.onLabelEdit THEN
				hTV = GetDlgItem (hWnd, nmtvdi.hdr.idFrom)
				WinXTreeView_SetItemLabel (hTV, nmtvdi.item.hItem, newLabel$)		' update label
			ELSE
				' .onLabelEdit(idCtr, edit_const, edit_item, newLabel$)
				return_code = @binding.onLabelEdit(nmtvdi.hdr.idFrom, $$EDIT_DONE, nmtvdi.item.hItem, newLabel$)
			ENDIF
' 0.6.0.2-new===
'
			XLONGAT(&&nmtvdi) = pNmtvdi
		CASE $$TVN_BEGINDRAG, $$TVN_BEGINRDRAG
			IFZ binding.onDrag THEN EXIT SELECT
			' begin the notify trap
			pNmtv = &nmtv
			XLONGAT(&&nmtv) = lParam
			IF @binding.onDrag(nmtv.hdr.idFrom, $$DRAG_START, nmtv.itemNew.hItem, nmtv.ptDrag.x, nmtv.ptDrag.y) THEN
				g_drag_item = nmtv.hdr.hwndFrom

				SELECT CASE nmhdr.code
					CASE $$TVN_BEGINDRAG	: g_drag_button = $$MBT_LEFT
					CASE $$TVN_BEGINRDRAG	: g_drag_button = $$MBT_RIGHT
				END SELECT

				XLONGAT(&rect) = nmtv.itemNew.hItem
				SendMessageA (nmtv.hdr.hwndFrom, $$TVM_GETITEMRECT, $$TRUE, &rect)
				rect.left = rect.left - SendMessageA (nmtv.hdr.hwndFrom, $$TVM_GETINDENT, 0, 0)

				' create the dragging image
				width = rect.right - rect.left
				height = rect.bottom - rect.top

				hDCtv = GetDC (nmtv.hdr.hwndFrom)		'  Note: GetDC will require ReleaseDC

				'get a compatible bitmap hBitmap
				mDC = CreateCompatibleDC (hDCtv)
				hBitmap = CreateCompatibleBitmap (hDCtv, width, height)

				' save the default compatible bitmap hEmpty
				hEmpty = SelectObject (mDC, hBitmap)

				BitBlt (mDC, 0, 0, width, height, hDCtv, rect.left, rect.top, $$SRCCOPY)

				' restore the default compatible bitmap hEmpty
				SelectObject (mDC, hEmpty)

				' release Compatible Device Context mDC
				DeleteDC (mDC)
				mDC = 0

				' release Device Context hDCtv
				ReleaseDC (nmtv.hdr.hwndFrom, hDCtv)
				hDCtv = 0

				g_drag_image = ImageList_Create (width, height, $$ILC_COLOR32 OR $$ILC_MASK, 1, 0)
				ImageList_AddMasked (g_drag_image, hBitmap, $$White)

				ImageList_BeginDrag (g_drag_image, 0, nmtv.ptDrag.x - rect.left, nmtv.ptDrag.y - rect.top)
				ImageList_DragEnter (GetDesktopWindow (), rect.left, rect.top)

				SetCapture (hWnd)		' snap mouse & window
			ENDIF
			XLONGAT(&&nmtv) = pNmtv
'
' 0.6.0.2-new+++
		CASE $$LVN_ITEMCHANGED, $$TVN_SELCHANGED
			RETURN @binding.onItem(nmhdr.idFrom, nmhdr.code, lParam)
' 0.6.0.2-new===
'
		CASE $$TCN_SELCHANGE
			IFZ nmhdr.hwndFrom THEN EXIT SELECT
			currTab = SendMessageA (nmhdr.hwndFrom, $$TCM_GETCURSEL, 0, 0)

			' hide first all the tabs
			maxTab = SendMessageA (nmhdr.hwndFrom, $$TCM_GETITEMCOUNT, 0, 0) - 1
			FOR i = 0 TO maxTab
				autoSizerInfo_showGroup (WinXTabs_GetAutosizerSeries (nmhdr.hwndFrom, i), $$FALSE)
			NEXT i

			' only current tab is visible
			autoSizerInfo_showGroup (WinXTabs_GetAutosizerSeries (nmhdr.hwndFrom, currTab), $$TRUE)

			' refresh the parent window
			GetClientRect (GetParent(nmhdr.hwndFrom), &rect)
			sizeWindow (GetParent(nmhdr.hwndFrom), rect.right - rect.left, rect.bottom - rect.top)

			RETURN @binding.onItem(nmhdr.idFrom, $$TCN_SELCHANGE, currTab)
'
' 0.6.0.2-new+++
		CASE $$LVN_ITEMCHANGED, $$TVN_SELCHANGED
			IF binding.onItem THEN
				RETURN @binding.onItem(nmhdr.idFrom, nmhdr.code, lParam)
			ENDIF
' 0.6.0.2-new===
'
		CASE $$LVN_COLUMNCLICK
			IF binding.onColumnClick THEN
				pNmlv = &nmlv		' list view structure
				XLONGAT(&&nmlv) = lParam
				return_code = @binding.onColumnClick(nmhdr.idFrom, nmlv.iSubItem)
				XLONGAT(&&nmlv) = pNmlv
			ENDIF
		CASE $$LVN_BEGINLABELEDIT		'  sent as notification
			' the program sent a message $$LVM_EDITLABEL
			IFZ binding.onLabelEdit THEN EXIT SELECT
			pNmlvdi = &nmlvdi
			XLONGAT(&&nmlvdi) = lParam
			' .onLabelEdit(idCtr, edit_const, edit_item, edit_sub_item, newLabel$)
			ret = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_START, nmlvdi.item.iItem, "")
			IFZ ret THEN
				' message handled
				return_code = 1
			ENDIF
			XLONGAT(&&nmlvdi) = pNmlvdi
		CASE $$LVN_ENDLABELEDIT
			IFZ binding.onLabelEdit THEN EXIT SELECT
			pNmlvdi = &nmlvdi
			XLONGAT(&&nmlvdi) = lParam
'
' 0.6.0.2-old---
'			return_code = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_DONE, nmlvdi.item.iItem, CSTRING$(nmlvdi.item.pszText))
' 0.6.0.2-old===
' 0.6.0.2-new+++
			newText$ = CSTRING$(nmlvdi.item.pszText)
			IFZ binding.onLabelEdit THEN
				hLV = GetDlgItem (hWnd, nmlvdi.hdr.idFrom)
				WinXListView_SetItemText (hLV, nmlvdi.item.iItem, nmlvdi.item.iSubItem, newText$)		' update text
			ELSE
				' .onLabelEdit(idCtr, edit_const, edit_item, edit_sub_item, newLabel$)
				return_code = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_DONE, nmlvdi.item.iItem, newText$)
			ENDIF
' 0.6.0.2-new===
'
			XLONGAT(&&nmlvdi) = pNmlvdi
	END SELECT		' notifyCode

	XLONGAT(&&nmhdr) = pNmhdr
	RETURN return_code
END FUNCTION
'
' ########################
' #####  sizeWindow  #####
' ########################
' Resizes a window.
' hWnd = handle of the window to resize
' winWidth and winHeight = the new width and height
' returns nothing of interest
FUNCTION sizeWindow (hWnd, winWidth, winHeight)
	STATIC maxX

	BINDING			binding
	XLONG		idBinding		' binding id
	XLONG style				' window style

	SCROLLINFO si
	RECT	rect

	XLONG parts[]			' status bar's parts
	XLONG i						' running index

	XLONG xoff
	XLONG yoff

	'get the binding
	IFF Get_the_binding (hWnd, @idBinding, @binding) THEN RETURN $$FALSE

	' now handle the bar
	IF winWidth > maxX THEN
		SendMessageA (binding.hBar, $$WM_SIZE, 0, 0)
		maxX = winWidth
	ENDIF

	'handle the status bar
	' first, resize the partitions
	DIM parts[binding.statusParts]
	FOR i = 0 TO binding.statusParts
		parts[i] = ((i + 1) * winWidth) / (binding.statusParts + 1)
	NEXT i
	SendMessageA (binding.hStatus, $$WM_SIZE, 0, 0)
	SendMessageA (binding.hStatus, $$SB_SETPARTS, binding.statusParts + 1, &parts[0])

	'and the scroll bars
	xoff = 0
	yoff = 0

	style = GetWindowLongA (hWnd, $$GWL_STYLE)

	SELECT CASE ALL TRUE
		CASE style AND $$WS_HSCROLL
			si.cbSize = SIZE(SCROLLINFO)
			si.fMask = $$SIF_PAGE OR $$SIF_DISABLENOSCROLL
			si.nPage = (winWidth * binding.hScrollPageM) + binding.hScrollPageC
			SetScrollInfo (hWnd, $$SB_HORZ, &si, $$TRUE)

			si.fMask = $$SIF_POS
			GetScrollInfo (hWnd, $$SB_HORZ, &si)
			xoff = si.nPos

		CASE style AND $$WS_VSCROLL
			si.cbSize = SIZE(SCROLLINFO)
			si.fMask = $$SIF_PAGE OR $$SIF_DISABLENOSCROLL
			si.nPage = (winHeight * binding.vScrollPageM) + binding.vScrollPageC
			SetScrollInfo (hWnd, $$SB_VERT, &si, $$TRUE)

			si.fMask = $$SIF_POS
			GetScrollInfo (hWnd, $$SB_VERT, &si)
			yoff = si.nPos
	END SELECT

	'use the auto-sizer
	WinXGetUseableRect (hWnd, @rect)
	autoSizerInfo_sizeGroup (binding.autoSizerInfo, rect.left - xoff, rect.top - yoff, rect.right - rect.left, rect.bottom - rect.top)

	@binding.onScroll(xoff, hWnd, $$DIR_HORIZ)
	@binding.onScroll(yoff, hWnd, $$DIR_VERT)

	'InvalidateRect (hWnd, 0, $$FALSE)

	RETURN @binding.dimControls(hWnd, winWidth, winHeight)

END FUNCTION
'
' ##########################
' #####  splitterProc  #####
' ##########################
' Window procedure for WinX Splitters.
' wMsg = Windows message
FUNCTION splitterProc (hSplitter, wMsg, wParam, lParam)

	STATIC dragging
	STATIC POINT mousePos
	STATIC inDock
	STATIC mouseIn
	STATIC POINT vertex[]

	AUTOSIZERINFO	sizer_block
	SPLITTERINFO splitter_block
	RECT	rect
	RECT dock
	PAINTSTRUCT	ps
	TRACKMOUSEEVENT tme
	POINT newMousePos
	POINT pt

	XLONG ret				' win32 api return value (0 for fail)
	XLONG hParent		' parent control
	XLONG hDC				' the handle of the desktop context
	XLONG i					' running index
	XLONG state			' state to draw
	XLONG cursor		' LoadCursorA (0, cursor)

	XLONG hShadPen				' = CreatePen ($$PS_SOLID, 1, GetSysColor($$COLOR_3DSHADOW))
	XLONG hBlackPen				' = CreatePen ($$PS_SOLID, 1, 0x000000)
	XLONG hBlackBrush			' = CreateSolidBrush (0x000000)
	XLONG hHighlightBrush	' = CreateSolidBrush (GetSysColor($$COLOR_HIGHLIGHT))
'
'	delta = newMousePos.x - mousePos.x		' horizontal
'	delta = newMousePos.y - mousePos.y		' vertical
'
	XLONG delta

	SetLastError (0)
	SPLITTERINFO_Get (GetWindowLongA (hSplitter, $$GWL_USERDATA), @splitter_block)

	SELECT CASE wMsg
		CASE $$WM_CREATE
			'lParam format = iSlitterInfo
			SetWindowLongA (hSplitter, $$GWL_USERDATA, XLONGAT(lParam))
			mouseIn = 0

			DIM vertex[2]
		CASE $$WM_PAINT
			hDC = BeginPaint (hSplitter, &ps)

			hShadPen = CreatePen ($$PS_SOLID, 1, GetSysColor($$COLOR_3DSHADOW))
			hBlackPen = CreatePen ($$PS_SOLID, 1, 0x000000)
			hBlackBrush = CreateSolidBrush (0x000000)
			hHighlightBrush = CreateSolidBrush (GetSysColor($$COLOR_HIGHLIGHT))
			SelectObject (hDC, hShadPen)

			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hSplitter, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN FillRect (hDC, &dock, hHighlightBrush)

			' clear flag $$DIR_REVERSE of direction
			SELECT CASE splitter_block.direction AND 0x00000003
				CASE $$DIR_VERT
					SELECT CASE TRUE
						CASE $$DOCK_DISABLED
						CASE ((splitter_block.dock = $$DOCK_FORWARD)  && (splitter_block.docked = 0)) || _
							 ((splitter_block.dock = $$DOCK_BACKWARD) && (splitter_block.docked > 0))
							GOSUB DrawVert
							' Draw arrows
							SelectObject (hDC, hBlackPen)
							SelectObject (hDC, hBlackBrush)
							vertex[0].x = 3 + dock.left
							vertex[0].y = 5 + dock.top
							vertex[1].x = 9 + dock.left
							vertex[1].y = 5 + dock.top
							vertex[2].x = 6 + dock.left
							vertex[2].y = 2 + dock.top
							Polygon (hDC, &vertex[0], 3)
							vertex[0].x = 3 + dock.left + 107
							vertex[0].y = 5 + dock.top
							vertex[1].x = 9 + dock.left + 107
							vertex[1].y = 5 + dock.top
							vertex[2].x = 6 + dock.left + 107
							vertex[2].y = 2 + dock.top
							Polygon (hDC, &vertex[0], 3)
						CASE ((splitter_block.dock = $$DOCK_BACKWARD) && (splitter_block.docked = 0)) || _
							 ((splitter_block.dock = $$DOCK_FORWARD)  && (splitter_block.docked > 0))
							GOSUB DrawVert
							' Draw arrows
							SelectObject (hDC, hBlackPen)
							SelectObject (hDC, hBlackBrush)
							vertex[0].x = 3 + dock.left
							vertex[0].y = 2 + dock.top
							vertex[1].x = 9 + dock.left
							vertex[1].y = 2 + dock.top
							vertex[2].x = 6 + dock.left
							vertex[2].y = 5 + dock.top
							Polygon (hDC, &vertex[0], 3)
							vertex[0].x = 3 + dock.left + 107
							vertex[0].y = 2 + dock.top
							vertex[1].x = 9 + dock.left + 107
							vertex[1].y = 2 + dock.top
							vertex[2].x = 6 + dock.left + 107
							vertex[2].y = 5 + dock.top
							Polygon (hDC, &vertex[0], 3)
					END SELECT
				CASE $$DIR_HORIZ
					SELECT CASE TRUE
						CASE $$DOCK_DISABLED
						CASE ((splitter_block.dock = $$DOCK_FORWARD)  && (splitter_block.docked = 0)) || _
							 ((splitter_block.dock = $$DOCK_BACKWARD) && (splitter_block.docked > 0))
							GOSUB DrawHoriz
							' Draw arrows
							SelectObject (hDC, hBlackPen)
							SelectObject (hDC, hBlackBrush)
							vertex[0].x = 5 + dock.left
							vertex[0].y = 3 + dock.top
							vertex[1].x = 2 + dock.left
							vertex[1].y = 6 + dock.top
							vertex[2].x = 5 + dock.left
							vertex[2].y = 9 + dock.top
							Polygon (hDC, &vertex[0], 3)
							vertex[0].x = 5 + dock.left
							vertex[0].y = 3 + dock.top + 107
							vertex[1].x = 2 + dock.left
							vertex[1].y = 6 + dock.top + 107
							vertex[2].x = 5 + dock.left
							vertex[2].y = 9 + dock.top + 107
							Polygon (hDC, &vertex[0], 3)
						CASE ((splitter_block.dock = $$DOCK_BACKWARD) && (splitter_block.docked = 0)) || _
							 ((splitter_block.dock = $$DOCK_FORWARD)  && (splitter_block.docked > 0))
							GOSUB DrawHoriz
							' Draw arrows
							SelectObject (hDC, hBlackPen)
							SelectObject (hDC, hBlackBrush)
							vertex[0].x = 2 + dock.left
							vertex[0].y = 3 + dock.top
							vertex[1].x = 5 + dock.left
							vertex[1].y = 6 + dock.top
							vertex[2].x = 2 + dock.left
							vertex[2].y = 9 + dock.top
							Polygon (hDC, &vertex[0], 3)
							vertex[0].x = 2 + dock.left
							vertex[0].y = 3 + dock.top + 107
							vertex[1].x = 5 + dock.left
							vertex[1].y = 6 + dock.top + 107
							vertex[2].x = 2 + dock.left
							vertex[2].y = 9 + dock.top + 107
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
			IFF PtInRect (&dock, pt.x, pt.y) || splitter_block.docked THEN
				SetCapture (hSplitter)
				dragging = $$TRUE
				mousePos.x = LOWORD(lParam)
				mousePos.y = HIWORD(lParam)
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
					InvalidateRect (hSplitter, 0, $$TRUE)		' erase
				ENDIF
				inDock = $$TRUE
			ELSE
				IF inDock THEN
					'GOSUB SetSizeCursor
					InvalidateRect (hSplitter, 0, $$TRUE)		' erase
				ENDIF
				inDock = $$FALSE
			ENDIF

			IFF mouseIn THEN
				GetCursorPos (&pt)
				ScreenToClient (hSplitter, &pt)
				IF PtInRect (&dock, pt.x, pt.y) THEN
					SetCursor (LoadCursorA (0, $$IDC_HAND))
					InvalidateRect (hSplitter, 0, $$TRUE)		' erase
					inDock = $$TRUE
				ELSE
					GOSUB SetSizeCursor
					inDock = $$FALSE
				ENDIF

				tme.cbSize = SIZE(tme)
				tme.dwFlags = $$TME_LEAVE
				tme.hwndTrack = hSplitter
				TrackMouseEvent (&tme)
				mouseIn = $$TRUE
			ENDIF

			IF dragging THEN
'
' 0.6.0.2-new+++
				IF splitter_block.group <= 0 THEN RETURN
				IF splitter_block.id < 0 THEN RETURN
' 0.6.0.2-new===
'
				newMousePos.x = LOWORD(lParam)
				newMousePos.y = HIWORD(lParam)
				ClientToScreen (hSplitter, &newMousePos)
				'
				'PRINT mouseX, newMouseX, mouseY, newMouseY
				'
				autoSizerInfo_get (splitter_block.group, splitter_block.id, @sizer_block)

				' clear flag $$DIR_REVERSE of direction
				SELECT CASE splitter_block.direction AND 0x00000003
					CASE $$DIR_HORIZ
						delta = newMousePos.x - mousePos.x
					CASE $$DIR_VERT
						delta = newMousePos.y - mousePos.y
				END SELECT

				IFZ delta THEN RETURN 0		' fail

				IF splitter_block.direction AND $$DIR_REVERSE THEN
					sizer_block.size = sizer_block.size - delta
					IF splitter_block.min && sizer_block.size < splitter_block.min THEN
						sizer_block.size = splitter_block.min
					ELSE
						IF (splitter_block.max > 0) && (sizer_block.size > splitter_block.max) THEN sizer_block.size = splitter_block.max
					ENDIF
				ELSE
					sizer_block.size = sizer_block.size + delta
					IF (splitter_block.max > 0) && (sizer_block.size > splitter_block.max) THEN
						sizer_block.size = splitter_block.max
					ELSE
						IF splitter_block.min && sizer_block.size < splitter_block.min THEN sizer_block.size = splitter_block.min
					ENDIF
				ENDIF

				IF sizer_block.size < 8 THEN
					sizer_block.size = 8
				ELSE
					IF sizer_block.size > splitter_block.maxSize THEN sizer_block.size = splitter_block.maxSize
				ENDIF

				autoSizerInfo_update (splitter_block.group, splitter_block.id, sizer_block)

				' refresh the parent window
				hParent = GetParent(hSplitter)
				GetClientRect (hParent, &rect)
				sizeWindow (hParent, rect.right - rect.left, rect.bottom - rect.top)

				mousePos = newMousePos
			ENDIF
			RETURN 0
		CASE $$WM_LBUTTONUP
			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hSplitter, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
'
' 0.6.0.2-new+++
				IF splitter_block.group <= 0 THEN RETURN
				IF splitter_block.id < 0 THEN RETURN
' 0.6.0.2-new===
'
				IF splitter_block.docked THEN
					autoSizerInfo_get (splitter_block.group, splitter_block.id, @sizer_block)
					sizer_block.size = splitter_block.docked
					splitter_block.docked = 0

					SPLITTERINFO_Update (GetWindowLongA (hSplitter, $$GWL_USERDATA), splitter_block)

					autoSizerInfo_update (splitter_block.group, splitter_block.id, sizer_block)

					' refresh the parent window
					hParent = GetParent(hSplitter)
					GetClientRect (hParent, &rect)
					sizeWindow (hParent, rect.right - rect.left, rect.bottom - rect.top)
				ELSE
					autoSizerInfo_get (splitter_block.group, splitter_block.id, @sizer_block)
					splitter_block.docked = sizer_block.size
					sizer_block.size = 8

					SPLITTERINFO_Update (GetWindowLongA (hSplitter, $$GWL_USERDATA), splitter_block)

					autoSizerInfo_update (splitter_block.group, splitter_block.id, sizer_block)

					' refresh the parent window
					hParent = GetParent(hSplitter)
					GetClientRect (hParent, &rect)
					sizeWindow (hParent, rect.right - rect.left, rect.bottom - rect.top)
				ENDIF
			ELSE
				dragging = $$FALSE
				ReleaseCapture ()
			ENDIF
			RETURN 0
		CASE $$WM_MOUSELEAVE
			InvalidateRect (hSplitter, 0, $$TRUE)		' erase
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
					SetPixel (hDC, dock.left + i, 3, GetSysColor($$COLOR_3DHILIGHT))
					INC state
				CASE 1
					SetPixel (hDC, dock.left + i, 4, GetSysColor($$COLOR_3DSHADOW))
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
					SetPixel (hDC, 3, i + dock.top, GetSysColor($$COLOR_3DHILIGHT))
					INC state
				CASE 1
					SetPixel (hDC, 4, i + dock.top, GetSysColor($$COLOR_3DSHADOW))
					INC state
				CASE 2
					state = 0
			END SELECT
		NEXT i
	END SUB

	SUB GetRect
		IF splitter_block.dock = $$DOCK_DISABLED THEN
			dock.left = 0
			dock.right = 0
			dock.bottom = 0
			dock.top = 0
		ELSE
			'get the client rectangle of WinX splitter
			SetLastError (0)
			ret = GetClientRect (hSplitter, &rect)
			IFZ ret THEN
				msg$ = "WinX-splitterProc: Can't get the client rectangle of the window"
				GuiTellApiError (@msg$)
			ELSE
				' clear flag $$DIR_REVERSE of direction
				SELECT CASE splitter_block.direction AND 0x00000003
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
		' clear flag $$DIR_REVERSE of direction
		SELECT CASE splitter_block.direction AND 0x00000003
			CASE $$DIR_HORIZ
				cursor = $$IDC_SIZEWE		' vertical bar (West/East)
			CASE $$DIR_VERT
				cursor = $$IDC_SIZENS		' horizontal bar (North/South)
			CASE ELSE
				EXIT SUB
		END SELECT
		SetCursor (LoadCursorA (0, cursor))
	END SUB
END FUNCTION
'
' ###############################
' #####  tabs_SizeContents  #####
' ###############################
' Resizes a tabs control.
' hTabs = tabs control
' pRect = pointer to a RECT structure
' returns the auto-sizer series used to resize, or -1 on fail
FUNCTION tabs_SizeContents (hTabs, pRect)
	XLONG series		' the auto-sizer group
	XLONG ret				' win32 api return value (0 for fail)

	SetLastError (0)
	series = -1		' not an index
	IF hTabs THEN
		IF pRect THEN
			ret = GetClientRect (hTabs, pRect)
			IF ret THEN
				SetLastError (0)
				SendMessageA (hTabs, $$TCM_ADJUSTRECT, 0, pRect)
				series = WinXTabs_GetAutosizerSeries (hTabs, WinXTabs_GetCurrentTab (hTabs))
				IF series < -1 THEN series = -1		' not an index
			ELSE
				msg$ = "WinX-tabs_SizeContents: Can't get the rectangle of the tabs control"
				GuiTellApiError (@msg$)
			ENDIF
		ENDIF
	ENDIF
	RETURN series

END FUNCTION
'
' ################################
' #####  UnregisterWinClass  #####
' ################################
'
' Unregisters a window class.
' returns bOK; $$TRUE for success
'
FUNCTION UnregisterWinClass (STRING window_class, bDebugMode, STRING DebugText)

	SHARED hInst		' handle of current module

	XLONG hWndFound	' actual window that happens to belong the the preview class
	XLONG window_count	' window count

	XLONG bErr			' $$TRUE for error
	XLONG ret				' win32 api return value (0 for fail)
	XLONG errNum		' win32 api last error CODE
	XLONG bOK				' $$TRUE for success
'
' UnregisterClassA: Handled win32 api return codes.
'
	$ERROR_CLASS_DOES_NOT_EXIST = 1411
	$ERROR_CLASS_HAS_WINDOWS		= 1412

	IFZ hInst THEN
		' (unlikely!)
		hInst = GetModuleHandleA (0)		' get the handle of current module
	ENDIF
'
' Unregister window class window_class.
'
	SetLastError (0)
	ret = UnregisterClassA (&window_class, hInst)
	IF ret THEN RETURN $$TRUE		' success
'
' FAIL: get the last error CODE
'
	SELECT CASE GetLastError ()
		CASE $ERROR_CLASS_HAS_WINDOWS

		CASE $ERROR_CLASS_DOES_NOT_EXIST
			RETURN $$TRUE		' success

		CASE ELSE
'
' GL-29sep24-new+++
			IF bDebugMode THEN
				' alert the user
				msg$ = DebugText + "\r\nUnregisterWinClass: Can't unregister window class '" + window_class + "'"
				GOSUB Alert_the_user
			ENDIF
' GL-29sep24-new+++
'
		RETURN $$FALSE		' fail

	END SELECT
'
' Check that there are still active windows in the window class
' and destroy any such window.
'
	window_count = 0
	hWndFound = FindWindowA (&window_class, 0)
	DO WHILE hWndFound
		INC window_count
		IF window_count > 100 THEN
			IF bDebugMode THEN
				' alert the user
				msg$ = DebugText + "\r\nUnregisterWinClass: Found more than a hundred(!) windows in window class '" + window_class + "'"
				XstAlert (@msg$)
			ENDIF

			EXIT DO
		ENDIF

		' hide the window
		SetLastError (0)
		ret = ShowWindow (hWndFound, $$SW_HIDE)
		IFZ ret THEN
'
' GL-29sep24-new+++
			IF bDebugMode THEN
				' alert the user
				msg$ = DebugText + "\r\nUnregisterWinClass: Can't hide this active window"
				GOSUB Alert_the_user
			ENDIF
' GL-29sep24-new+++
'
		ENDIF

		SetLastError (0)
		ret = DestroyWindow (hWndFound)
		IFZ ret THEN
'
' GL-29sep24-new+++
			IF bDebugMode THEN
				' alert the user
				msg$ = DebugText + "\r\nUnregisterWinClass: Window destroying failed"
				GOSUB Alert_the_user
			ENDIF
'			EXIT DO
' GL-29sep24-new+++
'
		ENDIF

		hWndFound = FindWindowA (&window_class, 0)
	LOOP
'
' Retry unregistering window class window_class.
'
	UnregisterClassA (&window_class, hInst)
	RETURN $$TRUE		' GL-What else to do?

SUB Alert_the_user

	errNum = GetLastError ()
	last_error_code$ = STRING$ (errNum)

	bErr = GuiTellApiError (@msg$)
	IFF bErr THEN
		msg$ = msg$ + $$CRLF$ + "(last error code " + last_error_code$ + ")"
		XstAlert (@msg$)
	ENDIF

END SUB

END FUNCTION

END PROGRAM
