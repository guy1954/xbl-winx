'
' ***** Testing and Validations *****
'
' C:/xblite/MyProgs/WinXsamples/animation/animate.x OK!
' C:/xblite/MyProgs/WinXsamples/bars/bars.x OK!
' C:/xblite/MyProgs/WinXsamples/calendar/calendar.x OK!
' C:/xblite/MyProgs/WinXsamples/clipboard/clipboard.x OK!
' C:/xblite/MyProgs/WinXsamples/combo boxes/combo.x OK!
' C:/xblite/MyProgs/WinXsamples/dragListBox/dragList.x OK!
' C:/xblite/MyProgs/WinXsamples/drawing/drawing.x OK!
' C:/xblite/MyProgs/WinXsamples/DrawLines/DrawLines.x OK!
' C:/xblite/MyProgs/WinXsamples/FunctionMover/functionMover.x Crashes on button Up only for functions 3 and 4!
' C:/xblite/MyProgs/WinXsamples/groups/groups.x OK!
' C:/xblite/MyProgs/WinXsamples/images/images.x OK!
' C:/xblite/MyProgs/WinXsamples/listview/listview.x OK!
' C:/xblite/MyProgs/WinXsamples/LV_mult_sel/listview.x OK!
' C:/xblite/MyProgs/WinXsamples/palette/palette.x OK!
' C:/xblite/MyProgs/WinXsamples/printing/printing.x OK!
' C:/xblite/MyProgs/WinXsamples/scrolling/scrolling.x OK!
' C:/xblite/MyProgs/WinXsamples/splitter/splitterInfo.x OK!
' C:/xblite/MyProgs/WinXsamples/tabs/tabs.x OK!
' C:/xblite/MyProgs/WinXsamples/text/text.x OK!
' C:/xblite/MyProgs/WinXsamples/treeview/treeview.x OK!
'
'
' ####################
' #####  PROLOG  #####
' ####################
'
PROGRAM	"WinX"
VERSION "0.6.0.4"		' GL-10oct22
'CONSOLE
' Needs the M4 macro preprocessor.
'
' WinX - *The* GUI library for XBLite
' Copyright (c) LGPL Callum Lowcay 2007-2008.
' Evolutions 2008-2009 Guy Lonne.
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
' WinX.dll: the Windows API made easy!
'
' WinX.x is a Windows GUI library for XBLite.
' WinX.dll is easy to use, with a comprehensive set of functions and is
' perfect to experiment GUI programming with quick prototypes.
'
' Author: Callum Lowcay
' Admin.: Guy Lonne, e-mail: <guy1954@users.sourceforge.net>
'
'
' ***** Notes *****
'
' Notes from Guy Lonne
' ====================
'
' I often generate (without saving the project) my applications with viXen
' set to "WinX generation" to get a feeling of the look of my GUI
' application.
'
' WinAPI programming in XBLite is mainly done by sending messages to the
' OS thru the routine SendMessageA. Only practice gives a good command of
' this technique: the more you put it to use, the easier it gets.
'
' But even a steady practice did not bring me comfort: since I like to
' perform meticulous run-time error checking, I do not call SendMessageA
' directly. I used instead wrappers to the SendMessageA calls that ensure
' careful check of the API returned code. Out of habit, I started to
' externalise these wrappers into GUI libraries. Lucky for me, Callum
' Lowcay developed in XBLite a ready-to-use open-source GUI library:
' WinX.x.
'
' If I am satisfied by the appearance of the generated application, I
' might then switch back to WinAPI generation, knowing that it is a step
' backwards: I will need additional coding just to get the same
' functionalities.
'
' NOTE 1: Code bloat.
' ======
'
' Some FUNCTIONs found their way in WinX.dll from viXen, against Callum's
' recommendation, who wanted to keep WinX lightweight.
' However, my rational to add them here is:
' 1.they were interesting enough to be shared among Xbliters
' 2.they were fully tested by using viXen
' 3.I use them in my tool production:
' - viXen     : XBLite GUI designer
' - XblCockpit: application launcher
' - SortSource: Sort PROGRAM's FUNCTIONs
' - U16toWide : Converter To Wide String WinAPI
' .             (tool for converting to UTF-18 the ANSI WinAPIs within
' .             an XBLite source program, which I used on WinX.x to create WinU16.x)
' 4.viXen version 2.00 will be a WinU16 GUI application.
'
'
' NOTE 2: WinX's FUNCTIONs RETURNs bOK, not bErr.
' ======
'
' Contrary to the XBasic/XBLite convention of RETURNing an error flag bErr,
' WinX RETURNs bOK, which IMHO is more "application-friendly":
' I read better a code that does not negate its test conditions.
'
' As a for instance, compare:
'' Check if file$ exists:
' bErr = XstFileExists (file$)
' IFF bErr THEN      ' file$ exists
'
' to:
'' Check if directory dir$ exists:
' IF WinXDir_Exists (dir$) THEN      ' directory dir$ exists
'
' This is paramount for system routines to allow for easy error checking.
' I thing that XBasic's is a good design decision. However, it is less
' appropriate for applications development. Priority to the job to perform,
' error checking only second. This is why WinX is ported to UNICODE with
' the same "RETURN bOK".
'
' How to Re-build WinX
' ====================
'
' 1. All functions are prefixed by "WinX"
' 2. Use SHIFT+F9 to compile
' 3. Use F10 to build WinX.dll
' 4. Use compiler switch -m4
'
'
' ***** Versions *****
'
' Contributor:
'     Callum Lowcay (original version 0.6.0.1)
'
'0.4.2 New Controls:
'- WinX Splitter: Splitter controls that works with Auto Sizer
'- List View Support (no dragging yet)
'
'New Functions:
'- WinXDrawEllipse
'
'New Auto Draw functions
'- WinXDrawRect
'- WinXDrawBezier
'- WinXDrawArc
'- WinXDrawFilledArea
'- WinXRegOnClose        : Callback to trap window close event
'- WinXSetSimpleSizerInfo: Simplified Auto Sizer registration
'- WinXAddListView
'
'List View support functions
'- WinXListView_SetView
'- WinXListView_AddColumn
'- WinXListView_DeleteColumn
'- WinXListView_AddItem
'- WinXListView_DeleteItem
'- WinXListView_GetSelection
'- WinXListView_SetSelection
'- WinXListView_SetItemText
'
'Changed Functions:
'- WinXSetAutosizerInfo: Now supports reverse series (right to left)
'
'Bug Fixes:
'- Scroll Bars not updating under Win2K and WinXP with classic skin
'- Direct LBItemFromPt calls removed
'- Fixed WinXOpenFile$ multiselect bugs
'- Possibly others
'
'0.5 New Functions:
'- WinXDraw_MakeLogFont Font and text management
'- WinXDraw_GetFontDialog
'- WinXDraw_GetTextWidth
'- WinXPixelsPerPoint
'- WinXDrawText
'- WinXDraw_GetColour Colour dialog
'- WinXDraw_CreateImage
'
'Image support
'- WinXDraw_LoadImage
'- WinXDraw_DeleteImage
'- WinXDraw_Snapshot
'- WinXDraw_SaveImage
'- WinXDraw_ResizeImage
'- WinXDraw_SetImagePixel
'- WinXDraw_GetImagePixel
'- WinXDraw_SetConstantAlpha
'- WinXDraw_SetImageChannel
'- WinXDraw_GetImageChannel
'- WinXDraw_GetImageInfo
'- WinXDraw_CopyImage
'- WinXDraw_PremultiplyImage
'- WinXDrawImage
'- WinXPrint
'
'Start Printing support
'- WinXLogUnitsPerPoint
'- WinXDevUnitsPerInch
'- WinXPrint_PageSetup
'- WinXPrint_Page
'- WinXPrint_Done
'
'Bug Fixes
'- WinXSaveFile$ didn't append default extension
'
'0.5.0.1 Bug Fixes:
'- WinXOpenFile$ and WinXSaveFile$, fixed the initial filename parameter
'
'0.6 Bug Fixes:
'- Major changes to the internal implementation of AutoDraw eliminating serious crashing bugs
'- Removal of bugs preventing multiple windows
'- Fixed WinXDraw_GetImageInfo (it didn't work at all)
'- Changes to AutoDraw and AutoSizer to reduce flicker
'- numerous other bug fixes New Features
'- Splitter docking
'- Clipboard
'- Registry access
'- Increased window customisation, set background colour, cursor, font (for some controls)
'- New dialog boxes: message, question
'- New ListView and TreeView functions
'
'New Controls:
'- Calendar
'- Date/Time Picker
'
'Functions with new parameters:
'- WinXNewWindow
'- WinXMakeMenu (also renamed to WinXNewMenu)
'
'Renamed Functions:
'The renames are intended to make the WinX API more logical and consistent.
'Hopefully this will be the last time I need to do a large scale rename.
'
'+-------------------------------------------------------+
'| Old Name                | New Name                    |
'|-------------------------|-----------------------------|
'| WinXSetControlText      | WinXSetText                 |
'| WinXGetControlText$     | WinXGetText$                |
'| WinXSetAutosizerInfo    | WinXAutoSizer_SetInfo       |
'| WinXMakeMenu            | WinXNewMenu                 |
'| WinXAttachSubMenu       | WinXMenu_Attach             |
'| WinXMakeToolbar         | WinXNewToolbar              |
'| WinXMakeToolbarUsingIls | WinXNewToolbarUsingIls      |
'| WinXOpenFile$           | WinXDialog_OpenFile$        |
'| WinXSaveFile$           | WinXDialog_SaveFile$        |
'| WinXMakeAutoSizerSeries | WinXNewAutoSizerSeries      |
'| WinXErrorBox            | WinXDialog_Error            |
'| WinXSetSimpleSizerInfo  | WinXAutoSizer_SetSimpleInfo |
'| WinXPixelsPerPoint      | WinXDraw_PixelsPerPoint     |
'| WinXLogUnitsPerPoint    | WinXPrint_LogUnitsPerPoint  |
'| WinXDevUnitsPerInch     | WinXPrint_DevUnitsPerInch   |
'| WinXGetMainSeries       | WinXAutoSizer_GetMainSeries |
'+-------------------------------------------------------+
'
'New Functions:
'- WinXNewChildWindow (parent, STRING title, style, exStyle, id)
'- WinXRegOnFocusChange (hWnd, FUNCADDR onFocusChange)
'- WinXSetWindowColour (hWnd, colour)
'- WinXListView_GetItemText (hLV, iItem, cSubItems, @text$[])
'- WinXDialog_Message (hWnd, text, iIcon, hMod)
'- WinXDialog_Question (hWnd, text, cancel, defaultButton)
'- WinXSplitter_SetProperties (series, hCtrl, min, max, dock)
'- WinXRegistry_ReadInt (hKey, subKey, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result)
'- WinXRegistry_ReadString (hKey, subKey, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
'- WinXRegistry_ReadBin (hKey, subKey, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
'- WinXRegistry_WriteInt (hKey, subKey, SECURITY_ATTRIBUTES sa, int)
'- WinXRegistry_WriteString (hKey, subKey, SECURITY_ATTRIBUTES sa, buffer$)
'- WinXRegistry_WriteBin (hKey, subKey, SECURITY_ATTRIBUTES sa, buffer$)
'- WinXAddAccelerator (ACCEL @accel[], cmd, key, control, alt, shift)
'- WinXSplitter_GetPos (series, hCtrl, @position, @docked)
'- WinXSplitter_SetPos (series, hCtrl, position, docked) WinXClip_IsString ()
'- WinXClip_PutString (Stri$) WinXClip_GetString$ ()
'- WinXRegOnClipChange (hWnd, FUNCADDR onClipChange)
'- SECURITY_ATTRIBUTES WinXNewACL (ssd$, inherit)
'- WinXSetCursor (hWnd, hCursor)
'- WinXScroll_GetPos (hWnd, direction, @pos)
'- WinXScroll_SetPos (hWnd, direction, pos)
'- WinXRegOnItem (hWnd, FUNCADDR onItem)
'- WinXRegOnColumnClick (hWnd, FUNCADDR onColumnClick)
'- WinXRegOnEnterLeave (hWnd, FUNCADDR onEnterLeave)
'- WinXListView_GetItemFromPoint (hLV, x, y)
'- WinXListView_Sort (hLV, iCol, desc)
'- WinXTreeView_GetItemFromPoint (hTreeView, x, y)
'- WinXGetPlacement (hWnd, @minMax, RECT @restored)
'- WinXSetPlacement (hWnd, minMax, RECT restored)
'- WinXGetMousePos (hWnd, @x, @y)
'- WinXAddCalendar (parent, @monthsX, @monthsY, id)
'- WinXCalendar_SetSelection (hCal, SYSTEMTIME time)
'- WinXCalendar_GetSelection (hCal, SYSTEMTIME @time)
'- WinXRegOnCalendarSelect (hWnd, FUNCADDR onCalendarSelect)
'- WinXAddTimePicker (parent, format, SYSTEMTIME initialTime, timeValid, id)
'- WinXTimePicker_SetTime (hDTP, SYSTEMTIME time, timeValid)
'- WinXTimePicker_GetTime (hDTP, SYSTEMTIME @time, @timeValid)
'- WinXSetFont (hCtrl, hFont)
'- WinXClip_IsImage ()
'- WinXClip_GetImage ()
'- WinXClip_PutImage (hImage)
'- WinXRegOnDropFiles (hWnd, FUNCADDR onDrag)
'- WinXDraw_GetFontHeight (hFont, @ascent, @descenct)
'
'0.6.0.1 Bug Fixes:
'- Bug in WinXDrawImage which miscalculated update region
'
'
' Contributor:
'     Guy "GL" Lonne (evolutions after version 0.6.0.1)
'
'0.6.0.1-Callum Lowcay-Original version.
'         GL-Made some text changes:
' ".firstItem"	:= ".iHead"
' ".lastItem"	:= ".iTail"
' ".forColor"	:= ".forColour"
' ".backColor"	:= ".backColour"
' "colour"	:= "color"
' "customColours["	:= "#CustomColors["
' "$$DOCK_FORWARD"	:= "$$DOCK_FORWARD"
' "FUNCTION"	:= "FUNCTION"
' "Seperator"	:= "Separator"
'
'0.6.0.2-GL-10sep08-added hideReadOnly argument to WinXDialog_OpenFile$.
'        GL-28oct09-REVERTED to show again the check box "Read Only"
'        to allow to open "Read Only" (no lock) the selected file(s).
'
'0.6.0.2-GL-10sep08 New Functions:
'
' Up-Down Control (Spinner)
'- WinXAddSpinner: create a new spinner control
'
'- WinXPath_Trim$       : trim a file path
'- WinXMakeFilterString$: make a filter string
'
' Wrappers
'- WinXSetWindowColour: wrapper to WinXSetWindowColor
'- WinXDraw_GetColour : wrapper to WinXDraw_GetColor
'- WinXAddCheckBox    : wrapper to WinXAddCheckButton
'- WinXDraw_Clear     : wrapper to WinXClear
'
'0.6.0.3-GL-10nov08-corrected function WinXListBox_GetSelection,
'- replaced wMsg by $$LB_GETSELITEMS since wMsg was not set and would be zero.
'
'0.6.0.4-GL-10sep08-added the new functions
' Accelerators
'- WinXAddAcceleratorTable: create an accelerator table
'- WinXAttachAccelerator  : attach accelerator table to window
'
'- WinXVersion$: retrieve WinX's current version
'
'
' ##############################
' #####  Import Libraries  #####
' ##############################
'
' XBLite headers
'
' DLL build+++
'	-- The following IMPORTs are needed for a DLL build.
	IMPORT "xst"		' XBLite Standard Library
	IMPORT "xsx"		' XBLite Standard eXtended Library
'	IMPORT "xio"		' console library
	IMPORT "xma"		' XBLite Math Library (Sin/Asin/Sinh/Asinh/Log/Exp/Sqrt...)
	IMPORT "adt"		' Callum's Abstract Data Types library
' DLL build~~~
'
' The above is commented for a static build:
' Static build---
'	-- The following IMPORTs are needed for a static build.
'	IMPORT "xst_s.lib"
'	IMPORT "xsx_s.lib"
''	IMPORT "xio_s.lib"
'	IMPORT "xma_s.lib"
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
'
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
	XLONG			.hWnd						'handle to the window this binds to, when 0, this binding record is not in use
	XLONG			.backCol				'window background color
	XLONG			.hStatus				'handle to the status bar, if there is one
	XLONG			.statusParts		'the upper index of partitions in the status bar
	XLONG			.msgHandlers		'index into an array of arrays of message handlers
' .minW and .minH = the minimum width and height of the window rectangle
	XLONG			.minW
	XLONG			.minH
' .maxW and .maxH = the maximum width and height of the window rectangle
	XLONG			.maxW
	XLONG			.maxH
	XLONG			.autoDrawInfo		'information for the auto-draw (id >= 1)
	XLONG			.autoSizerInfo	'information for the auto-sizer (valid: binding.autoSizerInfo >= 0)
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
'Callback Handlers
	FUNCADDR	.paint (XLONG, XLONG)	'hWnd, hDC : paint the window
	FUNCADDR	.dimControls (XLONG, XLONG, XLONG)	'hWnd, w, h : dimension the controls
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
	FUNCADDR	.onItem(XLONG, XLONG, XLONG)		' idCtr, event, parameter (virtualKey for NM_KEYDOWN)
	FUNCADDR	.onColumnClick(XLONG, XLONG)		' idCtr, iColumn
	FUNCADDR	.onCalendarSelect(XLONG, SYSTEMTIME)	' idCtr, time
	FUNCADDR	.onDropFiles(XLONG, XLONG, XLONG, STRING[])		' hWnd, x, y, @fileList$[]
'
'new in 0.6.0.4
	XLONG			.hAccelTable		' handle to the window's accelerator table

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
	XLONG			.group
	XLONG			.id			'actually, it's an index
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
' ***********************************
' *****  BLOCK EXPORT (part 1)  *****
' ***********************************
EXPORT
'
' WinX - A Win32 abstraction for XBLite.
' (C) Callum Lowcay 2007-2008 - Licensed under the GNU LGPL
' Evolutions: Guy Lonne 2008-2009.
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
$$XWSS_APP          = 0x00000000
$$XWSS_APPNORESIZE  = 0x00000001
$$XWSS_POPUP        = 0x00000002
$$XWSS_POPUPNOTITLE = 0x00000003
$$XWSS_NOBORDER     = 0x00000004

'mouse buttons
$$MBT_LEFT   = 1
$$MBT_MIDDLE = 2
$$MBT_RIGHT	 = 3

'font styles
$$FONT_BOLD      = 0x00000001
$$FONT_ITALIC    = 0x00000002
$$FONT_UNDERLINE = 0x00000004
$$FONT_STRIKEOUT = 0x00000008

'file types
$$FILETYPE_WINBMP = 1

$$MAIN_CLASS$ = "WinXMainClass"

'WinX auto-sizer flags (autoSizerBlock.flags)
'$$SIZER_FLAGS_NONE  = 0x0
$$SIZER_SIZERELREST = 0x00000001
$$SIZER_XRELRIGHT   = 0x00000002
$$SIZER_YRELBOTTOM  = 0x00000004
$$SIZER_SERIES      = 0x00000008
$$SIZER_WCOMPLEMENT = 0x00000010
$$SIZER_HCOMPLEMENT = 0x00000020
$$SIZER_SPLITTER    = 0x00000040
'
' WinX's splitter class name
$$WINX_SPLITTER_CLASS$ = "WinXSplitterClass"
'
'WinX splitter flags
' 0.6.0.2-$$CONTROL			= 0
$$DIR_VERT    = 1
$$DIR_HORIZ   = 2
$$DIR_REVERSE = 0x80000000
'
$$UNIT_LINE = 0
$$UNIT_PAGE = 1
$$UNIT_END  = 2
'
'Drag and Drop Operations
'drag states
$$DRAG_START    = 0
$$DRAG_DRAGGING = 1
$$DRAG_DONE     = 2
'
'edit states
$$EDIT_START = 0
$$EDIT_DONE  = 1
'
$$CHANNEL_RED   = 2
$$CHANNEL_GREEN	= 1
$$CHANNEL_BLUE	= 0
$$CHANNEL_ALPHA	= 3
'
$$ACL_REG_STANDARD = "D:(A;OICI;GRKRKW;;;WD)(A;OICI;GAKA;;;BA)"
'
'new in 0.6.0.1
$$AutoSizer$ = "WinXAutoSizerSeries"
$$AutoSizerInfo$ = "autoSizerInfoBlock"

$$LeftSubSizer$		= "WinXLeftSubSizer"
$$RightSubSizer$	= "WinXRightSubSizer"
'
'
' *************************
' *****   FUNCTIONS   *****
' *************************
'
DECLARE FUNCTION WinX () ' To be called first

DECLARE FUNCTION WinXNewWindow (hOwner, titleBar$, x, y, w, h, simpleStyle, exStyle, icon, menu)
DECLARE FUNCTION WinXRegOnPaint (hWnd, FUNCADDR FnOnPaint) ' handles message WM_PAINT
DECLARE FUNCTION WinXDisplay (hWnd)
DECLARE FUNCTION WinXDoEvents (passed_accel) ' process events
DECLARE FUNCTION WinXRegMessageHandler (hWnd, wMsg, FUNCADDR FnMsgHandler)
DECLARE FUNCTION WinXRegControlSizer (hWnd, FUNCADDR FnOnSize)
DECLARE FUNCTION WinXAddButton (parent, text$, hImage, id) ' add push button
DECLARE FUNCTION WinXSetText (hwnd, text$) ' set the text of a window or control
DECLARE FUNCTION WinXGetText$ (hwnd) ' get the text from a window or control
DECLARE FUNCTION WinXHide (hwnd) ' hide a window or control
DECLARE FUNCTION WinXShow (hwnd) ' show a window or control
DECLARE FUNCTION WinXAddStatic (parent, text$, hImage, style, id) ' add text box
DECLARE FUNCTION WinXAddEdit (parent, text$, style, id) ' add edit control
DECLARE FUNCTION WinXAutoSizer_SetInfo (hWnd, series, space#, size#, xx#, yy#, ww#, hh#, flags) ' auto-sizer group setup
DECLARE FUNCTION WinXSetMinSize (hWnd, w, h) ' set minimum width and height of the window
DECLARE FUNCTION WinXRegOnCommand (hWnd, FUNCADDR FnOnCommand) ' handles message WM_COMMAND

END EXPORT

DECLARE FUNCTION ApiLBItemFromPt (hLB, x, y, bAutoScroll)
DECLARE FUNCTION ApiAlphaBlend (hdcDest, nXOriginDest, nYOrigDest, nWidthDest, nHeightDest, hdcSrc, nXOriginSrc, nYOriginSrc, nWidthSrc, nHeightSrc, BLENDFUNCTION blendFunction)

DECLARE FUNCTION mainWndProc (hWnd, wMsg, wParam, lParam)
DECLARE FUNCTION splitterProc (hSplitter, wMsg, wParam, lParam) ' WinX's splitter callback function
DECLARE FUNCTION onNotify (hWnd, wParam, lParam, BINDING binding)
DECLARE FUNCTION sizeWindow (hWnd, new_width, new_height) ' resize the window
DECLARE FUNCTION autoSizer (AUTOSIZERINFO autoSizerBlock, direction, x0, y0, w, h, currPos) ' the auto-sizer function, resizes child windows
DECLARE FUNCTION XWSStoWS (xwss)

EXPORT

'callback functions for internal dialogs
DECLARE FUNCTION cancelDlgOnClose (hWnd) ' onClose callback for the cancel printing dialog box
DECLARE FUNCTION cancelDlgOnCommand (id, code, hWnd) ' onCommand callback for the cancel printing dialog box
DECLARE FUNCTION printAbortProc (hDC, nCode)

END EXPORT
'
'
'These functions abstract away access to the arrays
'
' Window/Dialog Binding
DECLARE FUNCTION binding_add (BINDING binding) ' add a new window binding
DECLARE FUNCTION binding_delete (id) ' delete window binding
DECLARE FUNCTION binding_get (id, BINDING @binding) ' get window binding
DECLARE FUNCTION binding_update (id, BINDING binding) ' update window binding
'
' Message Handlers
DECLARE FUNCTION handler_add (group, MSGHANDLER FnMsgHandler)
DECLARE FUNCTION handler_get (group, index, MSGHANDLER @FnMsgHandler)
DECLARE FUNCTION handler_update (group, index, MSGHANDLER FnMsgHandler)
DECLARE FUNCTION handler_delete (group, index)

DECLARE FUNCTION handler_call (group, @ret_value, hWnd, wMsg, wParam, lParam)
DECLARE FUNCTION handler_find (group, wMsg)

DECLARE FUNCTION handler_addGroup ()
DECLARE FUNCTION handler_deleteGroup (group)
'
' Auto-Sizer
DECLARE FUNCTION autoSizerInfo_add (group, AUTOSIZERINFO autoSizerBlock)
DECLARE FUNCTION autoSizerInfo_delete (group, id)
DECLARE FUNCTION autoSizerInfo_get (group, id, AUTOSIZERINFO @autoSizerBlock)
DECLARE FUNCTION autoSizerInfo_update (group, id, AUTOSIZERINFO autoSizerBlock)

DECLARE FUNCTION autoSizerInfo_addGroup (direction)
DECLARE FUNCTION autoSizerInfo_deleteGroup (group)
DECLARE FUNCTION autoSizerInfo_sizeGroup (group, x0, y0, w, h)
DECLARE FUNCTION autoSizerInfo_showGroup (group, visible)
'
' Auto-Draw
DECLARE FUNCTION autoDraw_clear (group)
DECLARE FUNCTION autoDraw_draw (hDC, group, x0, y0)
DECLARE FUNCTION autoDraw_add (iList, idDraw)

DECLARE FUNCTION initPrintInfo ()
'
' Auto-Draw Records
DeclareAccess(AUTODRAWRECORD)
'
' Generic Linked List
DeclareAccess(LINKEDLIST)
'
' WinX's Splitter
DeclareAccess(SPLITTERINFO)

DECLARE FUNCTION drawLine (hDC, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawEllipse (hDC, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawRect (hDC, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawEllipseNoFill (hDC, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawRectNoFill (hDC, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawArc (hDC, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawFill (hDC, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawBezier (hDC, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawText (hDC, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION drawImage (hDC, AUTODRAWRECORD record, x0, y0)

DECLARE FUNCTION sizeTabsContents (hTabs, pRect)
DECLARE FUNCTION sizeGroupBoxContents (hGB, pRect)
DECLARE FUNCTION CompareLVItems (item1, item2, hLV)
'
'
' ***********************************
' *****  BLOCK EXPORT (part 2)  *****
' ***********************************
EXPORT

DECLARE FUNCTION WinXDrawLine (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXClear (hWnd) ' clear all the graphics in a window
DECLARE FUNCTION WinXUpdate (hWnd)
DECLARE FUNCTION WinXDrawFilledEllipse (hWnd, hPen, hBrush, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawFilledRect (hWnd, hPen, hBrush, x1, y1, x2, y2)
DECLARE FUNCTION WinXNewMenu (menuList$, firstID, isPopup)
DECLARE FUNCTION WinXMenu_Attach (subMenu, newParent, idMenu)
DECLARE FUNCTION WinXAddStatusBar (parent, initialStatus$, id) ' add status bar
DECLARE FUNCTION WinXStatus_SetText (hWnd, part, text$)
DECLARE FUNCTION WinXStatus_GetText$ (hWnd, part)
DECLARE FUNCTION WinXRegOnMouseMove (hWnd, FUNCADDR FnOnMouseMove)
DECLARE FUNCTION WinXRegOnMouseDown (hWnd, FUNCADDR FnOnMouseDown)
DECLARE FUNCTION WinXRegOnMouseWheel (hWnd, FUNCADDR FnOnMouseWheel)
DECLARE FUNCTION WinXRegOnMouseUp (hWnd, FUNCADDR FnOnMouseUp)
DECLARE FUNCTION WinXNewToolbar (wButton, hButton, nButtons, hBmpButtons, hBmpDis, hBmpHot, transparentRGB, toolTips, customisable)
DECLARE FUNCTION WinXToolbar_AddButton (hToolbar, commandId, iImage, toolTipText$, optional, moveable)
DECLARE FUNCTION WinXSetWindowToolbar (hWnd, hToolbar)
DECLARE FUNCTION WinXAddTooltip (hCtr, toolTipText$) ' add tooltips to control
DECLARE FUNCTION WinXGetUseableRect (hWnd, RECT @rect) ' get the useable portion the client area
DECLARE FUNCTION WinXNewToolbarUsingIls (hilNor, hilDis, hilHot, toolTips, customisable)
DECLARE FUNCTION WinXUndo (hWnd, idDraw) ' undo a drawing operation
'new in 0.3
DECLARE FUNCTION WinXRegOnKeyDown (hWnd, FUNCADDR FnOnKeyDown) ' handles message WM_KEYDOWN
DECLARE FUNCTION WinXRegOnKeyUp (hWnd, FUNCADDR FnOnKeyUp) ' handles message WM_KEYUP
DECLARE FUNCTION WinXRegOnChar (hWnd, FUNCADDR FnOnChar)
'
' Keyboard
DECLARE FUNCTION WinXIsKeyDown (key)
'
' Mouse
DECLARE FUNCTION WinXIsMousePressed (button)

DECLARE FUNCTION WinXAddControl (parent, class$, text$, style, exStyle, id) ' add custom control
DECLARE FUNCTION WinXAddListBox (parent, sort, multiSelect, id) ' add list box control
DECLARE FUNCTION WinXAddComboBox (parent, listHeight, canEdit, images, id) ' add combo box
'
' List Box
DECLARE FUNCTION WinXListBox_AddItem (hListBox, index, item$)
DECLARE FUNCTION WinXListBox_RemoveItem (hListBox, index)
DECLARE FUNCTION WinXListBox_GetSelection (hListBox, @indexList[]) ' get all selected items in the list box
DECLARE FUNCTION WinXListBox_GetIndex (hListBox, searchFor$)
DECLARE FUNCTION WinXListBox_SetSelection (hListBox, indexList[]) ' multi-select listbox items
'
' Open/Save File Dialogs
DECLARE FUNCTION WinXDialog_OpenFile$ (hOwner, title$, extensions$, initialName$, multiSelect) ' File Open Dialog
DECLARE FUNCTION WinXDialog_SaveFile$ (hOwner, title$, extensions$, initialName$, overwritePrompt) ' File Save Dialog

DECLARE FUNCTION WinXListBox_GetItem$ (hListBox, index) ' get the text of listbox item
'
' Combo Box
DECLARE FUNCTION WinXComboBox_AddItem (hCombo, index, indent, item$, iImage, iSelImage)
DECLARE FUNCTION WinXComboBox_RemoveItem (hCombo, index)
DECLARE FUNCTION WinXComboBox_GetSelection (hCombo)
DECLARE FUNCTION WinXComboBox_SetSelection (hCombo, index)
DECLARE FUNCTION WinXComboBox_GetItem$ (hCombo, index)

DECLARE FUNCTION WinXNewAutoSizerSeries (direction)
'new in 0.4
DECLARE FUNCTION WinXAddCheckButton (parent, text$, isFirst, pushlike, id) ' add check button
DECLARE FUNCTION WinXAddRadioButton (parent, text$, isFirst, pushlike, id) ' add radio button
DECLARE FUNCTION WinXButton_SetCheck (hButton, checked) ' set check state
DECLARE FUNCTION WinXButton_GetCheck (hButton) ' get check state
DECLARE FUNCTION WinXAddTreeView (parent, hImages, editable, draggable, id) ' add treeview
DECLARE FUNCTION WinXAddProgressBar (parent, smooth, id) ' add progress bar
DECLARE FUNCTION WinXAddTrackBar (parent, enableSelection, posToolTip, id) ' add track bar
DECLARE FUNCTION WinXAddTabs (parent, multiline, id) ' add tabstip control
DECLARE FUNCTION WinXAddAnimation (parent, file$, id) ' add animation file

DECLARE FUNCTION WinXRegOnDrag (hWnd, FUNCADDR FnOnDrag)
DECLARE FUNCTION WinXListBox_EnableDragging (hListBox)
DECLARE FUNCTION WinXAutoSizer_GetMainSeries (hWnd) ' get window's main series
DECLARE FUNCTION WinXDialog_Error (text$, title$, severity) ' display an error dialog box
DECLARE FUNCTION WinXProgress_SetPos (hProg, DOUBLE pos)
DECLARE FUNCTION WinXProgress_SetMarquee (hProg, enable)
DECLARE FUNCTION WinXRegOnScroll (hWnd, FUNCADDR FnOnScroll)
DECLARE FUNCTION WinXScroll_Show (hWnd, horiz, vert)
DECLARE FUNCTION WinXScroll_SetRange (hWnd, direction, min, max)
DECLARE FUNCTION WinXScroll_SetPage (hWnd, direction, DOUBLE mul, constant, scrollUnit)
DECLARE FUNCTION WinXRegOnTrackerPos (hWnd, FUNCADDR FnOnTrackerPos)
DECLARE FUNCTION WinXTracker_GetPos (hTracker)
DECLARE FUNCTION WinXTracker_SetPos (hTracker, newPos)
DECLARE FUNCTION WinXTracker_SetRange (hTracker, USHORT min, USHORT max, ticks)
DECLARE FUNCTION WinXTracker_SetSelRange (hTracker, USHORT start, USHORT end)
DECLARE FUNCTION WinXTracker_SetLabels (hTracker, leftLabel$, rightLabel$)
DECLARE FUNCTION WinXScroll_Update (hWnd, deltaX, deltaY)
DECLARE FUNCTION WinXScroll_Scroll (hWnd, direction, unitType, scrollingDirection)
DECLARE FUNCTION WinXEnableDialogInterface (hWnd, enable) ' enable/disable a dialog-type interface
'
' Animation
DECLARE FUNCTION WinXAni_Play (hAni) ' start playing the animation
DECLARE FUNCTION WinXAni_Stop (hAni) ' stop playing the animation
'
' List Box
DECLARE FUNCTION WinXListBox_SetCaret (hListBox, index)

DECLARE FUNCTION WinXSetStyle (hWnd, add, addEx, sub, subEx) ' set style and extended style
'
' Tree View
DECLARE FUNCTION WinXTreeView_AddItem (hTreeView, parent, hNodeAfter, iImage, iImageSelect, item$)
DECLARE FUNCTION WinXTreeView_GetNextItem (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_GetChildItem (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_GetParentItem (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_GetPreviousItem (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_DeleteItem (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_GetSelection (hTreeView)
DECLARE FUNCTION WinXTreeView_SetSelection (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_GetItemLabel$ (hTreeView, hNode)
DECLARE FUNCTION WinXTreeView_SetItemLabel (hTreeView, hNode, label$)
DECLARE FUNCTION WinXRegOnLabelEdit (hWnd, FUNCADDR FnOnLabelEdit)
DECLARE FUNCTION WinXTreeView_CopyItem (hTreeView, hNodeParent, hNodeAfter, hNode)
'
' Tabs Control
DECLARE FUNCTION WinXTabs_AddTab (hTabs, label$, index)
DECLARE FUNCTION WinXTabs_DeleteTab (hTabs, iTab)
DECLARE FUNCTION WinXTabs_GetAutosizerSeries (hTabs, iTab)
DECLARE FUNCTION WinXTabs_GetCurrentTab (hTabs)
DECLARE FUNCTION WinXTabs_SetCurrentTab (hTabs, iTab)
'
' Tool Bar
DECLARE FUNCTION WinXToolbar_AddToggleButton (hToolbar, commandId, iImage, toolTipText$, mutex, optional, moveable)
DECLARE FUNCTION WinXToolbar_AddSeparator (hToolbar)
DECLARE FUNCTION WinXToolbar_AddControl (hToolbar, hControl, w)
DECLARE FUNCTION WinXToolbar_EnableButton (hToolbar, iButton, enable)
DECLARE FUNCTION WinXToolbar_ToggleButton (hToolbar, iButton, on)
'new in 0.4.1.0
DECLARE FUNCTION WinXComboBox_GetEditText$ (hCombo)
DECLARE FUNCTION WinXComboBox_SetEditText (hCombo, text$)
DECLARE FUNCTION WinXAddGroupBox (parent, text$, id) ' add group box
DECLARE FUNCTION WinXGroupBox_GetAutosizerSeries (hGB)
'new in 0.4.2.0
DECLARE FUNCTION WinXDrawEllipse (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawRect (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawBezier (hWnd, hPen, x1, y1, x2, y2, xC1, yC1, xC2, yC2)
DECLARE FUNCTION WinXDrawArc (hWnd, hPen, x1, y1, x2, y2, DOUBLE theta1, DOUBLE theta2)
DECLARE FUNCTION WinXDrawFilledArea (hWnd, hBrush, colBound, x, y)
DECLARE FUNCTION WinXRegOnClose (hWnd, FUNCADDR FnOnClose) ' handles message WM_CLOSE
DECLARE FUNCTION WinXAutoSizer_SetSimpleInfo (hWnd, series, space#, size#, flags) ' simplified series setup
'
' List View
DECLARE FUNCTION WinXAddListView (parent, hilLargeIcons, hilSmallIcons, editable, view, id) ' add list view control
DECLARE FUNCTION WinXListView_SetView (hLV, view)
DECLARE FUNCTION WinXListView_AddColumn (hLV, iColumn, wColumn, label$, numSubItem) ' add a column to listview for use in report view
DECLARE FUNCTION WinXListView_DeleteColumn (hLV, iColumn)
DECLARE FUNCTION WinXListView_AddItem (hLV, iItem, item$, iIcon) ' add a new item to a list view
DECLARE FUNCTION WinXListView_DeleteItem (hLV, iItem)
DECLARE FUNCTION WinXListView_GetSelection (hLV, @indexList[]) ' get selected item(s) in a list view
DECLARE FUNCTION WinXListView_SetSelection (hLV, indexList[]) ' multi-select these items
DECLARE FUNCTION WinXListView_SetItemText (hLV, iItem, iSubItem, newText$) ' set new item/sub-item's text
'
'new in 0.5
DECLARE FUNCTION LOGFONT WinXDraw_MakeLogFont (font$, height, style)
DECLARE FUNCTION WinXDraw_GetFontDialog (hOwner, LOGFONT @logFont, @fontRGB) ' Font Picker
DECLARE FUNCTION WinXDraw_GetTextWidth (hFont, text$, maxWidth)
DECLARE FUNCTION DOUBLE WinXDraw_PixelsPerPoint ()
DECLARE FUNCTION WinXDrawText (hWnd, hFont, text$, x, y, backRGB, forRGB)
DECLARE FUNCTION WinXDraw_GetColor (hOwner, initialRGB) ' Colour Picker
DECLARE FUNCTION WinXDraw_CreateImage (w, h)
DECLARE FUNCTION WinXDraw_LoadImage (fileName$, fileType)
DECLARE FUNCTION WinXDraw_DeleteImage (hImage)
DECLARE FUNCTION WinXDraw_Snapshot (hWnd, x, y, hImage)
DECLARE FUNCTION WinXDraw_SaveImage (hImage, fileName$, fileType)
DECLARE FUNCTION WinXDraw_ResizeImage (hImage, w, h)
DECLARE FUNCTION WinXDraw_SetImagePixel (hImage, x, y, pixelRGB)
DECLARE FUNCTION RGBA WinXDraw_GetImagePixel (hImage, x, y)
DECLARE FUNCTION WinXDraw_SetConstantAlpha (hImage, DOUBLE alpha)
DECLARE FUNCTION WinXDraw_SetImageChannel (hImage, channel, UBYTE @data[])
DECLARE FUNCTION WinXDraw_GetImageChannel (hImage, channel, UBYTE @data[])
DECLARE FUNCTION WinXDraw_GetImageInfo (hImage, @w, @h, @pBits)
DECLARE FUNCTION WinXDraw_CopyImage (hImage)
DECLARE FUNCTION WinXDraw_PremultiplyImage (hImage)
DECLARE FUNCTION WinXDrawImage (hWnd, hImage, x, y, w, h, xSrc, ySrc, blend)
DECLARE FUNCTION WinXPrint_Start (minPage, maxPage, @rangeMin, @rangeMax, @cxPhys, @cyPhys, fileName$, showDialog, hOwner)
DECLARE FUNCTION DOUBLE WinXPrint_LogUnitsPerPoint (hPrinter, cyLog, cyPhys)
DECLARE FUNCTION WinXPrint_DevUnitsPerInch (hPrinter, @w, @h)
DECLARE FUNCTION WinXPrint_PageSetup (hOwner)
DECLARE FUNCTION WinXPrint_Page (hPrinter, hWnd, x, y, cxLog, cyLog, cxPhys, cyPhys, pageNum, pageCount)
DECLARE FUNCTION WinXPrint_Done (hPrinter) ' reset the printer context
'new in 0.6
DECLARE FUNCTION WinXNewChildWindow (parent, title$, style, exStyle, id)
DECLARE FUNCTION WinXRegOnFocusChange (hWnd, FUNCADDR FnOnFocusChange)
DECLARE FUNCTION WinXSetWindowColor (hWnd, backRGB)
DECLARE FUNCTION WinXListView_GetItemText (hLV, iItem, uppSubItem, @aSubItem$[])
DECLARE FUNCTION WinXDialog_Message (hOwner, msg$, title$, iIcon, hMod) ' display message dialog box
DECLARE FUNCTION WinXDialog_Question (hOwner, msg$, title$, cancel, defaultButton) ' display a dialog asking the user a question
DECLARE FUNCTION WinXSplitter_SetProperties (series, hCtr, min, max, dock)
DECLARE FUNCTION WinXRegistry_ReadInt (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result)
DECLARE FUNCTION WinXRegistry_ReadString (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
DECLARE FUNCTION WinXRegistry_ReadBin (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
DECLARE FUNCTION WinXRegistry_WriteInt (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, int)
DECLARE FUNCTION WinXRegistry_WriteString (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, buffer$)
DECLARE FUNCTION WinXRegistry_WriteBin (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, buffer$)
DECLARE FUNCTION WinXAddAccelerator (ACCEL @accel[], cmd, key, control, alt, shift) ' add accelerator key
DECLARE FUNCTION WinXSplitter_GetPos (series, hCtr, @position, @docked)
DECLARE FUNCTION WinXSplitter_SetPos (series, hCtr, position, docked)
DECLARE FUNCTION WinXClip_IsString ()
DECLARE FUNCTION WinXClip_PutString (Stri$)
DECLARE FUNCTION WinXClip_GetString$ ()
DECLARE FUNCTION WinXRegOnClipChange (hWnd, FUNCADDR FnOnClipChange)
DECLARE FUNCTION SECURITY_ATTRIBUTES WinXNewACL (ssd$, inherit)
DECLARE FUNCTION WinXSetCursor (hWnd, hCursor)
DECLARE FUNCTION WinXScroll_GetPos (hWnd, direction, @pos)
DECLARE FUNCTION WinXScroll_SetPos (hWnd, direction, pos)
DECLARE FUNCTION WinXRegOnItem (hWnd, FUNCADDR FnOnItem)
DECLARE FUNCTION WinXRegOnColumnClick (hWnd, FUNCADDR FnOnColumnClick)
DECLARE FUNCTION WinXRegOnEnterLeave (hWnd, FUNCADDR FnOnEnterLeave)
'
' List View
DECLARE FUNCTION WinXListView_GetItemFromPoint (hLV, x, y)
DECLARE FUNCTION WinXListView_Sort (hLV, iCol, decreasing)
'
' Tree View
DECLARE FUNCTION WinXTreeView_GetItemFromPoint (hTreeView, x, y)

DECLARE FUNCTION WinXGetPlacement (hWnd, @minMax, RECT @restored)
DECLARE FUNCTION WinXSetPlacement (hWnd, minMax, RECT restored)
DECLARE FUNCTION WinXGetMousePos (hWnd, @x, @y)
DECLARE FUNCTION WinXAddCalendar (parent, @monthsX, @monthsY, id) ' add calendar control
DECLARE FUNCTION WinXCalendar_SetSelection (hCal, SYSTEMTIME time)
DECLARE FUNCTION WinXCalendar_GetSelection (hCal, SYSTEMTIME @time)
DECLARE FUNCTION WinXRegOnCalendarSelect (hWnd, FUNCADDR FnOnCalendarSelect) ' handles message MCN_SELCHANGE notifyCode
DECLARE FUNCTION WinXAddTimePicker (parent, format, SYSTEMTIME initialTime, timeValid, id) ' add time picker control
DECLARE FUNCTION WinXTimePicker_SetTime (hDTP, SYSTEMTIME time, timeValid) ' set the time for a Date/Time Picker control
DECLARE FUNCTION WinXTimePicker_GetTime (hDTP, SYSTEMTIME @time, @timeValid) ' get time from a Date/Time Picker control

' Font
DECLARE FUNCTION WinXNewFont (fontName$, pointSize, weight, bItalic, bUnderline, bStrikeOut) ' create a logical font
DECLARE FUNCTION WinXSetFont (hCtr, hFont) ' apply font to control
DECLARE FUNCTION WinXSetFontAndRedraw (hCtr, hFont, bRedraw) ' apply font to control, eventually redraw it

DECLARE FUNCTION WinXClip_IsImage ()
DECLARE FUNCTION WinXClip_GetImage ()
DECLARE FUNCTION WinXClip_PutImage (hImage)
DECLARE FUNCTION WinXRegOnDropFiles (hWnd, FUNCADDR FnOnDrag)
DECLARE FUNCTION WinXDraw_GetFontHeight (hFont, @ascent, @descenct)

END EXPORT
'
'
' ***********************************
' *****  BLOCK EXPORT (part 3)  *****
' ***********************************
EXPORT
'
'new in 0.6.0.4
' Accelerators
DECLARE FUNCTION WinXAddAcceleratorTable (ACCEL @accel[]) ' create an accelerator table
DECLARE FUNCTION WinXAttachAccelerators (hWnd, hAccel) ' attach accelerator table to window
'
' Up-Down Control (Spinner)
DECLARE FUNCTION WinXAddSpinner (parent, hBuddy, buddy_x, buddy_y, buddy_w, buddy_h, uppVal, lowVal, curVal, id) ' create a new spinner control

DECLARE FUNCTION WinXPath_Trim$ (path$) ' trim a file path
DECLARE FUNCTION WinXMakeFilterString$ (file_filter$) ' make a filter string

DECLARE FUNCTION WinXCleanUp () ' optional cleanup
'
' Version
DECLARE FUNCTION WinXVersion$ () ' retrieve WinX's current version
'
' Wrappers
DECLARE FUNCTION WinXSetWindowColour (hWnd, backRGB)
DECLARE FUNCTION WinXDraw_GetColour (hOwner, initialRGB) ' Colour Picker
DECLARE FUNCTION WinXAddCheckBox (parent, text$, isFirst, pushlike, id)
DECLARE FUNCTION WinXDraw_Clear (hWnd)

END EXPORT
'
'new in 0.6.0.2
DECLARE FUNCTION GuiTellApiError (msg$) ' display a WinAPI error message
DECLARE FUNCTION GuiTellDialogError (hOwner, title$) ' display a dialog error message
DECLARE FUNCTION GuiTellRunError (msg$) ' display a run-time error message
'
'
' ######################
' #####  WinX ()  #####
' ######################
'	/*
'	[WinX]
' Description = Initializes the WinX library.
' Function    = WinX ()
' ArgCount    = 0
'	Return      = $$FALSE on success, else $$TRUE on fail.
' Remarks     = Sometimes this gets called automatically.  If your program crashes as soon as you call WinXNewWindow then WinX has not been initialized properly.
'	See Also    =
'	Examples    = IFF WinX () THEN QUIT(0)
'	*/
FUNCTION WinX ()

	SHARED		SBYTE #bReentry
	SHARED		hWinXIcon		' WinX's Icon
	SHARED		BINDING	bindings[]			'a simple array of bindings

	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		SBYTE handlersUM[]	'a usage map so we can see which groups are in use

	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]

	SHARED		AUTODRAWRECORD	autoDrawInfo[]	'info for the auto-draw
	SHARED		DRAWLISTHEAD autoDrawInfoUM[]

	SHARED TBBUTTONDATA tbbd[]	' info for toolbar customisation
	SHARED tbbdUM[]

	INITCOMMONCONTROLSEX	iccex		' information for extended common controls classes
	WNDCLASSEX wcex		' extended window class
	OSVERSIONINFOEX os		' to tweack widgets depending on Windows version

	SetLastError (0)
	IF #bReentry THEN RETURN $$FALSE		' already initialized!
'
' Uncomment this for a static build.
' Static build---
'	Xst ()		' initialize Standard Library
'	Xsx ()		' initialize Standard eXtended Library
''	Xio ()		' Console input/ouput library
'	Xma ()		' initialize Math Library
' Static build~~~
'
	DIM tbbd[0]
	DIM tbbdUM[0]
'
' GL-17feb20-old---
'	GetVersionExA (&os)		' BAD!
' GL-17feb20-old~~~
' GL-17feb20-new+++
	os.dwOSVersionInfoSize = SIZE (OSVERSIONINFOEX)
	SetLastError (0)
	ret = GetVersionExA (&os)
	IFZ ret THEN
		msg$ = "WinX: Can't identify the current Operating System"
		GuiTellApiError (msg$)
		os.dwMajorVersion = 5		' unlikely fail: default to Windows XP
	ENDIF
' GL-17feb20-new~~~
'
	ADT ()		' initialize the Abstract Data Types Library

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

	STRING_Init ()		' STRING Pool initialization
	SPLITTERINFO_Init ()		' WinX's splitter initialization
	LINKEDLIST_Init ()		' generic list initialization
	AUTODRAWRECORD_Init ()		' auto-draw initialization

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
' GL-04mar09-don't bother error checking!
'	IFF InitCommonControlsEx (&iccex) THEN RETURN $$TRUE ' fail
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	InitCommonControlsEx (&iccex)
' 0.6.0.2-new~~~
'
' Retrieve WinX's Icon from WinX.dll
' to set wcex.hIcon with it.
'
	hWinXIcon = 0
	hLib = LoadLibraryA (&"WinX.dll")
	IF hLib THEN
'
' 0.6.0.1-new+++
		' Make sure that WinX.RC file contains the statement:
		' "WinXIcon ICON WinX.ico"
		hWinXIcon = LoadIconA (hLib, &"WinXIcon")
		IFZ hWinXIcon THEN
			msg$ = "WinX: WinX's Icon is null"
			WinXDialog_Error (msg$, "WinX-Debug", 2)
		ENDIF
' 0.6.0.1-new~~~
'
		FreeLibrary (hLib)
		hLib = 0
	ENDIF

	'register WinX's main window class
	wcex.style					= $$CS_PARENTDC
	wcex.lpfnWndProc		= &mainWndProc()
	wcex.lpszMenuName = 0
	wcex.cbClsExtra = 0		' no extra bytes after the window class
	wcex.cbWndExtra = 4		' space for the index to a BINDING structure
	wcex.hInstance			= GetModuleHandleA(0)
	wcex.hIcon					= hWinXIcon
	wcex.hCursor				= LoadCursorA (0, $$IDC_ARROW)
'
' 0.6.0.2-old---
'	wcex.hbrBackground	= $$COLOR_BTNFACE + 1		' GetStockObject ($$GRAY_BRUSH)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	IF os.dwMajorVersion <= 5 THEN
		' up to Windows XP
		wcex.hbrBackground = $$COLOR_BTNFACE + 1		' GetStockObject ($$GRAY_BRUSH)
	ELSE
		wcex.hbrBackground = $$COLOR_WINDOW
	ENDIF
' 0.6.0.2-new~~~
'
	wcex.lpszClassName	= &$$MAIN_CLASS$
	wcex.cbSize = SIZE (WNDCLASSEX)

	ret = RegisterClassExA (&wcex)
	IFZ ret THEN RETURN $$TRUE		' fail

	'register WinX splitter class
	wcex.style					= $$CS_PARENTDC
	wcex.lpfnWndProc		= &splitterProc()		' WinX splitter callback function
	wcex.lpszMenuName = 0
	wcex.cbClsExtra			= 0		' no extra bytes after the window class
	wcex.cbWndExtra			= 4		' space for the index to a SPLITTERINFO structure
	wcex.hInstance			= GetModuleHandleA(0)
	wcex.hIcon					= 0
	wcex.hCursor				= 0
'
' 0.6.0.2-old---
'	wcex.hbrBackground	= $$COLOR_BTNFACE + 1
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	IF os.dwMajorVersion <= 5 THEN
		' up to Windows XP
		wcex.hbrBackground = $$COLOR_BTNFACE + 1		' GetStockObject ($$GRAY_BRUSH)
	ELSE
		wcex.hbrBackground = $$COLOR_WINDOW
	ENDIF
' 0.6.0.2-new~~~
'
	wcex.lpszClassName	= &$$WINX_SPLITTER_CLASS$
	wcex.cbSize = SIZE (WNDCLASSEX)

	ret = RegisterClassExA (&wcex)
'
' 0.6.0.2-old---
' GL-don't bother error checking!
'	IFZ ret THEN RETURN $$TRUE		' fail
' 0.6.0.2-new~~~
'
'	' display WinX's current version
'	msg$ = "Using library WinX v" + WinXVersion$ ()
'	WinXDialog_Error (msg$, "WinX-Debug", 0)
'
	#bReentry = $$TRUE		' protect for reentry
	RETURN $$FALSE		' success

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
' Arg1				= hOwner : The parent of the new window
' Arg2				= titleBar$ : The title bar for the new window
' Arg3				= x : the x position for the new window, -1 for centre
' Arg4				= y : the y position for the new window, -1 for centre
' Arg5				= w : the width of the client area of the new window
' Arg6				= h : the height of the client area of the new window
' Arg7				= simpleStyle : a simple style constant
' Arg8				= exStyle : an extended window style, look up CreateWindowEx in the win32 developer's guide for a list of extended styles
' Arg9				= hIcon : the handle to the icon for the window, 0 for default
' Arg10			= menu : the handle to the menu for the window, 0 for no menu
' Return      = The handle to the new window or 0 on fail
' Remarks     = Simple style constants:<dl>\n
'<dt>$$XWSS_APP</dt><dd>A standard window</dd>\n
'<dt>$$XWSS_APPNORESIZE</dt><dd>Same as the standard window, but cannot be resized or maximised</dd>\n
'<dt>$$XWSS_POPUP</dt><dd>A popup window, cannot be minimised</dd>\n
'<dt>$$XWSS_POPUPNOTITLE</dt><dd>A popup window with no title bar</dd>\n
'<dt>$$XWSS_NOBORDER</dt><dd>A window with no border, useful for full screen apps</dd></dl>
' See Also    =
'	Examples    = 'Make a simple window<br/>\n
' WinXNewWindow (0, "My window", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)
'	*/
FUNCTION WinXNewWindow (hOwner, titleBar$, x, y, w, h, simpleStyle, exStyle, hIcon, menu)

	SHARED hWinXIcon		' WinX's Icon

	BINDING binding
	RECT	rect
	LINKEDLIST autoDraw

	winLeft = x
	winTop = y
	winWidth = w
	winHeight = h

	dwStyle = XWSStoWS(simpleStyle)
'
' 0.6.0.2-old---
' Don't adjust the client area: the dimensions of the window
' are the dimensions for its outside rectangle.
'
'	rect.left = 0
'	rect.right = winWidth
'	rect.top = 0
'	rect.bottom = winHeight
'	IFZ menu THEN fMenu = 0 ELSE fMenu = 1
'
'	AdjustWindowRectEx (&rect, dwStyle, fMenu, exStyle)
'
'	IF winLeft < 0 THEN
'		screenWidth  = GetSystemMetrics ($$SM_CXSCREEN)
'		winLeft = (screenWidth - (rect.right-rect.left))/2
'	ENDIF
'
'	IF winTop < 0 THEN
'		screenHeight = GetSystemMetrics ($$SM_CYSCREEN)
'		winTop = (screenHeight - (rect.bottom-rect.top))/2
'	ENDIF
'
'	hWnd = CreateWindowExA (exStyle, &$$MAIN_CLASS$, &title, style, winLeft, winTop, _
'	rect.right-rect.left, rect.bottom-rect.top, hOwner, menu, GetModuleHandleA(0), 0)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	cxminimized = GetSystemMetrics ($$SM_CXMINIMIZED)		' Width of rectangle into which minimised windows must fit
	IF winWidth < cxminimized THEN winWidth = cxminimized

	cyminimized = GetSystemMetrics ($$SM_CYMINIMIZED)		' Height of rectangle into which minimised windows must fit
	IF winHeight < cyminimized THEN winHeight = cyminimized

	IF winLeft < 0 THEN
		' center the window
		screenWidth = GetSystemMetrics ($$SM_CXSCREEN)
		winLeft = (screenWidth - winWidth)/2
	ENDIF

	IF winTop < 0 THEN
		' place the window mid-height
		screenHeight = GetSystemMetrics ($$SM_CYSCREEN)
		winTop = (screenHeight - winHeight)/2
	ENDIF
' 0.6.0.2-new~~~
'
	binding.hWnd = CreateWindowExA (exStyle, &$$MAIN_CLASS$, &titleBar$, dwStyle, winLeft, winTop, winWidth, winHeight, _
	hOwner, menu, GetModuleHandleA(0), 0)

	SELECT CASE binding.hWnd
		CASE 0
			'
		CASE ELSE
			'now add the icon
			IFZ hIcon THEN
				' use WinX's Icon when the passed hIcon is NULL
				hIcon = hWinXIcon
			ENDIF
'
' 0.6.0.2-old---
'			IF hIcon THEN
'				SendMessageA (binding.hWnd, $$WM_SETICON, $$ICON_BIG  , hIcon)
'				SendMessageA (binding.hWnd, $$WM_SETICON, $$ICON_SMALL, hIcon)
'			ENDIF
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			DIM arr[1]
			arr[0] = $$ICON_BIG
			arr[1] = $$ICON_SMALL
			FOR i = 0 TO 1
				SetLastError (0)
				ret = SendMessageA (binding.hWnd, $$WM_SETICON, arr[i], hIcon)
				IFZ ret THEN
					msg$ = "WinXNewWindow: Can't set the window icon"
					GuiTellApiError (msg$)
				ENDIF
			NEXT i
' 0.6.0.2-new~~~
'
' 0.6.0.2-new+++
			IF menu THEN
				'activate the menubar
				SetLastError (0)
				ret = SetMenu (binding.hWnd, menu)		' activate the menubar
				IFZ ret THEN
					msg$ = "WinXNewWindow: Can't activate the menubar"
					GuiTellApiError (msg$)
				ENDIF
			ENDIF
' 0.6.0.2-new~~~
'
' Fill the binding record.
'
			dwStyle = $$WS_POPUP OR $$TTS_NOPREFIX OR $$TTS_ALWAYSTIP
			binding.hToolTips = CreateWindowExA (0, &$$TOOLTIPS_CLASS, 0, dwStyle, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, binding.hWnd, 0, GetModuleHandleA (0), 0)
			'
			'allocate a message handler
			binding.msgHandlers = handler_addGroup ()
			'
			'allocate an auto-draw list
			LinkedList_Init (@autoDraw)
			binding.autoDrawInfo = LINKEDLIST_New (autoDraw)
			'
			'allocate the main series (vertical)
			binding.autoSizerInfo = autoSizerInfo_addGroup ($$DIR_VERT)
'
' 0.6.0.1-old---
'			'store the binding id in class data area
'			SetWindowLongA (binding.hWnd, $$GWL_USERDATA, binding_add(binding))
' 0.6.0.1-old~~~
' 0.6.0.1-new+++
			'store the binding id in class data area
			idBinding = binding_add (binding)
			IF idBinding > 0 THEN
				SetWindowLongA (binding.hWnd, $$GWL_USERDATA, idBinding)
			ELSE
				idBinding = 0
				msg$ = "WinXNewWindow: Can't add binding to the new window"
				WinXDialog_Error (msg$, "WinX-Debug", 2)
			ENDIF
' 0.6.0.1-new~~~
'
	END SELECT

	'and we're done
	RETURN binding.hWnd
END FUNCTION
'
' ############################
' #####  WinXRegOnPaint  #####
' ############################
'	/*
'	[WinXRegOnPaint]
' Description = Registers a callback function to process painting events.
' Function    = WinXRegOnPaint (hWnd, FUNCADDR FnOnPaint)
' ArgCount    = 2
'	Arg1        = hWnd : The handle to the window to register the callback for
' Arg2				= FnOnPaint : The address of the function to use for the callback
'	Return      = $$TRUE on success or $$FALSE on fail
' Remarks     = The callback function must take a single XLONG parameter called \n
'hDC, this parameter is the handle to the device context to draw on. \n
'If you register this callback function, auto-draw is disabled.\n
'	See Also    =
'	Examples    = WinXRegOnPaint (#hMain, &onPaint())
'	*/
FUNCTION WinXRegOnPaint (hWnd, FUNCADDR FnOnPaint)
	BINDING binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	'set the paint function
	binding.paint = FnOnPaint
	bOK = binding_update (idBinding, binding)

	RETURN bOK
END FUNCTION
'
' #########################
' #####  WinXDisplay  #####
' #########################
'	/*
'	[WinXDisplay]
' Description = Displays a window for the first time.
' Function    = WinXDisplay (hWnd)
' ArgCount    = 1
'	Arg1        = hWnd : The handle to the window to display
' Return      = $$TRUE if the window was previously visible.
' Remarks     = This function should be called after all the child controls have been added to the window.  It calls the sizing function, which is either the registered callback function or the auto-sizer.
'	See Also    =
'	Examples    = WinXDisplay (#hMain)
'	*/
FUNCTION WinXDisplay (hWnd)
	RECT rect

	IFZ hWnd THEN
		hWnd = GetActiveWindow ()
	ENDIF

	bPreviouslyVisible = $$FALSE
	IFZ hWnd THEN RETURN $$FALSE		' fail

	'refresh the window
	GetClientRect (hWnd, &rect)

	'resize the window
	sizeWindow (hWnd, rect.right-rect.left, rect.bottom-rect.top)

	ret = ShowWindow (hWnd, $$SW_SHOWNORMAL)
	IF ret THEN
		bPreviouslyVisible = $$TRUE
	ENDIF

	RETURN bPreviouslyVisible		' success
END FUNCTION
'
' ##########################
' #####  WinXDoEvents  #####
' ##########################
'	/*
'	[WinXDoEvents]
' Description = Processes events.
' Function    = WinXDoEvents (hAccel)
' ArgCount    = 1
' Arg1        = passed_accel : The handle to a table of keyboard accelerators (also known as keyboard shortcuts).  Use 0 if you don't want to process keyboard accelerators
' Return      = $$FALSE on receiving a QUIT message or $$TRUE on error.
' Remarks     = This function doesn't return until the window is destroyed or a QUIT message is received.
' See Also    =
'	Examples    = WinXDoEvents (0)
'	*/
FUNCTION WinXDoEvents (passed_accel)

	BINDING binding
	MSG msg		' will be sent to window callback function when an event occurs
'
' Main Message Loop
' =================
' Supervise system messages until
' - the User decides to leave the application (RETURN $$FALSE)
' - an error occurred (RETURN $$TRUE)
'
	DO		' the message loop
		' retrieve next message from queue
		ret = GetMessageA (&msg, 0, 0, 0)
		SELECT CASE ret
			CASE  0 : RETURN $$FALSE		' received a QUIT message
			CASE -1 : RETURN $$TRUE			' error
			CASE ELSE
				' deal with window messages
				hWnd = GetActiveWindow ()
				IFZ hWnd THEN DO DO		' fail
				'
				ret = 0
				' retrieve current window's acceleration table
				hAccel = 0
				'
				'get the binding
				idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
				bOK =  binding_get (idBinding, @binding)
				IF bOK THEN
					' default to the passed acceleration table (if any)
					IF binding.hAccelTable THEN
						' retrieve current window's acceleration table
						hAccel = binding.hAccelTable
					ELSE
						hAccel = passed_accel
					ENDIF
				ENDIF
				'
				IF hAccel THEN
					ret = TranslateAcceleratorA (hWnd, hAccel, &msg)
				ENDIF
				'
				IFZ ret THEN
					IF (!IsWindow (hWnd)) || (!IsDialogMessageA (hWnd, &msg)) THEN
						' send only non-dialog messages
						' translate virtual-key messages into character messages
						' ex.: SHIFT + a is translated as "A"
						TranslateMessage (&msg)
						'
						' send message to window callback function
						DispatchMessageA (&msg)
					ENDIF
				ENDIF
				'
		END SELECT
	LOOP		' forever

END FUNCTION
'
' ###################################
' #####  WinXRegMessageHandler  #####
' ###################################
'	/*
'	[WinXRegMessageHandler]
' Description = Registers a message handler callback function.
' Function    = WinXRegMessageHandler (hWnd, wMsg, FUNCADDR FnMsgHandler)
' ArgCount    = 3
'	Arg1        = hWnd : The window to register the callback for
' Arg2				= wMsg : The message the callback function processes
' Arg3				= FnMsgHandler : The address of the callback function
'	Return      = $$TRUE on success or $$FALSE on fail
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

	IFZ hWnd THEN RETURN $$FALSE		' fail
	IFZ wMsg THEN RETURN $$FALSE		' fail
	IFZ FnMsgHandler THEN RETURN $$FALSE		' fail

	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	'prepare the handler
	handler.msg = wMsg
	handler.handler = FnMsgHandler

	'and add it
	IF handler_add(binding.msgHandlers,handler) < 0 THEN RETURN $$FALSE

	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXRegControlSizer  #####
' #################################
'	/*
'	[WinXRegControlSizer]
' Description = Registers a callback function to handle the sizing of controls.
' Function    = WinXRegControlSizer (hWnd, FUNCADDR FnOnSize)
' ArgCount    = 2
'	Arg1        = hWnd : The window to register the callback for
' Arg2				= FnOnSize : The address of the callback function
'	Return      = $$TRUE on success or $$FALSE on fail
' Remarks     = This function allows you to use your own control sizing code instead of the default \n
'WinX auto-sizer.  You will have to resize all controls, including status bars and toolbars, if you use \n
'this callback function.  The callback function has two XLONG parameters, w and h.
'	See Also    =
'	Examples    = WinXRegControlSizer (#hMain, &customSizer())
'	*/
FUNCTION WinXRegControlSizer (hWnd, FUNCADDR FnOnSize)
	BINDING			binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	'set the function
	binding.dimControls = FnOnSize
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ###########################
' #####  WinXAddButton  #####
' ###########################
'	/*
'	[WinXAddButton]
' Description = Creates a new button and adds it to the specified window.
' Function    = hButton = WinXAddButton (parent, text$, hImage, id)
' ArgCount    = 4
'	Arg1        = parent : The parent window to contain this control
' Arg2				= text$ : The text the button will display. If hImage is not 0, this is either "bitmap" or "icon" depending on whether hImage is a handle to a bitmap or an icon
' Arg3				= hImage : If this is an image button this parameter is the handle to the image, otherwise it must be 0
' Arg4				= id : The unique id for this button
'	Return      = $$TRUE on success or $$FALSE on fail
' Remarks     = To create a button that contains a text label, hImage must be 0. \n
' To create a button with an image, load either a bitmap or an icon using the standard gdi functions. \n
' Set the hImage parameter to the handle gdi gives you and the text$ parameter to either "bitmap" or "icon" \n
' Depending on what kind of image you loaded.
'	See Also    =
'	Examples    = 'Define constants to identify the buttons<br/>\n
' $$IDBUTTON1 = 100<br/>$$IDBUTTON2 = 101<br/>\n
'  'Make a button with a text label<br/>\n
'  hButton = WinXAddButton (#hMain, "Click me!", 0, $$IDBUTTON1)</br>\n
'  'Make a button with a bitmap (which in this case is included in the resource file of your program)<br/>\n
'  hBmp = LoadBitmapA (GetModuleHandleA(0), &"bitmapForButton2")<br/>\n
'  hButton2 = WinXAddButton (#hMain, "bitmap", hBmp, $$IDBUTTON2)<br/>
'	*/
FUNCTION WinXAddButton (parent, text$, hImage, id)
	'set the style
	style = $$BS_PUSHBUTTON
	imageType = 0
	IF hImage THEN
		SELECT CASE LCASE$ (text$)
			CASE "icon"
				style = style OR $$BS_ICON
				imageType = $$IMAGE_ICON
			CASE "bitmap"
				style = style OR $$BS_BITMAP
				imageType = $$IMAGE_BITMAP
		END SELECT
	ENDIF

	'make the window
	hButton = CreateWindowExA (0, &$$BUTTON, &text$, style|$$WS_TABSTOP|$$WS_GROUP|$$WS_CHILD|$$WS_VISIBLE, _
	0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hButton THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hButton, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	'add the image
	IF hImage THEN
		IF hButton THEN
			'add the image
			SetLastError (0)
			ret = SendMessageA (hButton, $$BM_SETIMAGE, imageType, hImage)
			IFZ ret THEN WinXSetText (hButton, "err " + text$)		' fail
		ENDIF
	ENDIF

	'and we're done
	RETURN hButton
END FUNCTION
'
' #########################
' #####  WinXSetText  #####
' #########################
' Sets the text of a window or control.
' hwnd  = the handle to the window or control
' text$ = the text to set
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetText (hwnd, text$)
	SetLastError (0)
	IFZ hwnd THEN RETURN $$FALSE		' fail
	ret = SetWindowTextA (hwnd, &text$)
	IFZ ret THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ##########################
' #####  WinXGetText$  #####
' ##########################
' Gets the text from a window or control.
' hwnd = the handle to the window or control
' returns a string containing the text
FUNCTION WinXGetText$ (hwnd)
	SetLastError (0)
	IFZ hwnd THEN RETURN ""		' fail
	cChar = GetWindowTextLengthA (hwnd)		' get character count
	IF cChar <= 0 THEN RETURN ""		' fail

	sizeBuf = cChar + 1		' 1 output byte per input character + the nul-terminator
	szBuf$ = NULL$ (sizeBuf)		' NULL$() adds a nul-terminator

	SetLastError (0)
	ret = GetWindowTextA (hwnd, &szBuf$, sizeBuf)		' get the text
	IFZ ret THEN RETURN ""		' fail

	'-ret$ = LEFT$ (szBuf$, ret)
	ret$ = CSTRING$ (&szBuf$)
	RETURN ret$		' success
END FUNCTION
'
' ######################
' #####  WinXHide  #####
' ######################
' Hides a window or control.
' hwnd = the handle to the control or window to hide
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXHide (hwnd)
	SetLastError (0)
	IFZ hwnd THEN
		hwnd = GetActiveWindow ()
	ENDIF
	IFZ hwnd THEN RETURN $$FALSE		' fail
	ShowWindow (hwnd, $$SW_HIDE)
	RETURN $$TRUE		' success
END FUNCTION
'
' ######################
' #####  WinXShow  #####
' ######################
' Shows a previously hidden window or control
' hwnd = the handle to the control or window to show
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXShow (hwnd)
	SetLastError (0)
	IFZ hwnd THEN
		hwnd = GetActiveWindow ()
	ENDIF
	IFZ hwnd THEN RETURN $$FALSE		' fail
	ShowWindow (hwnd, $$SW_SHOW)
	RETURN $$TRUE		' success
END FUNCTION
'
' ###########################
' #####  WinXAddStatic  #####
' ###########################
' Creates a new static control
' and adds it to specified window.
' parent = the parent window to add this control to
' text$  = the text for the static control
' hImage = the image to use, or 0 if no image
' flags  = additional style flags of static control
' id     = the unique id for this control
' returns a handle to the new static control or 0 on fail
FUNCTION WinXAddStatic (parent, text$, hImage, flags, id)
	' set the style
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

	'make the window
	hCtr = CreateWindowExA (0, &"static", &text$, style|$$WS_TABSTOP|$$WS_CHILD|$$WS_VISIBLE, _
	0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	IF hImage THEN
		'add the image
		SetLastError (0)
		ret = SendMessageA (hCtr, $$STM_SETIMAGE, imageType, hImage)
		IFZ ret THEN
			WinXSetText (hCtr, "err " + text$)
			msg$ = "WinXAddStatic: Can't set " + text$ + " to static" + STR$ (id)
			GuiTellApiError (msg$)
		ENDIF
	ENDIF

	'and we're done
	RETURN hCtr
END FUNCTION
'
' #########################
' #####  WinXAddEdit  #####
' #########################
' Creates a new edit control
' and adds it to specified window.
' parent = the parent window
' text$  = the initial text to display in the control
' flags  = additional style flags of the control
' id     = the unique id for this control
' returns a handle to the new edit control or 0 on fail
FUNCTION WinXAddEdit (parent, text$, flags, id)
	style = flags		' passed style flags
	style = style OR $$WS_TABSTOP OR $$WS_BORDER '| $$WS_GROUP
	IF style AND $$ES_MULTILINE THEN
		' multiline edit box
		style = style|$$WS_VSCROLL|$$WS_HSCROLL
	ENDIF

	'make the window
	hCtr = CreateWindowExA ($$WS_EX_CLIENTEDGE, &"edit", &text$, style|$$WS_TABSTOP|$$WS_GROUP|$$WS_BORDER|$$WS_CHILD|$$WS_VISIBLE, _
	0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hCtr THEN RETURN 0		' fail

	'give it a nice font
	SendMessageA (hCtr, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	RETURN hCtr
END FUNCTION
'
' ###################################
' #####  WinXAutoSizer_SetInfo  #####
' ###################################
' Sets info for the auto-sizer to use when sizing your controls.
' hwnd   = the handle to the window or control to resize
' series = the series to place the control in
'          -1 for parent's series
' space  = the space from the previous control
' size   = the size of this control
' x, y, w, h = the size and position of the control on the current window
' flags  = a set of $$SIZER flags
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'	space# = 0.00	' first control (0%)
'	size# = 1.00	' the size of this control (100%)
'	x# = 0.00			' left margin (0%)
'	y# = 0.00			' top margin (0%)
'	w# = 0.98			' width (98%)
'	h# = 0.98			' height (98%)
'	flags = 0
'	WinXAutoSizer_SetInfo (hTreeView, -1, space#, size#, x#, y#, w#, h#, flags)
'
FUNCTION WinXAutoSizer_SetInfo (hwnd, series, DOUBLE space, DOUBLE size, DOUBLE x, DOUBLE y, DOUBLE w, DOUBLE h, flags)
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	BINDING	binding
	AUTOSIZERINFO	autoSizerBlock
	SPLITTERINFO splitterInfo
	RECT parentRect
	RECT minRect
	RECT rect

	SetLastError (0)
	IFZ hwnd THEN RETURN $$FALSE		' fail

	IF series < 0 THEN
		'get the parent window
		parent = GetParent (hwnd)
		IFF binding_get (GetWindowLongA (parent, $$GWL_USERDATA), @binding) THEN RETURN $$FALSE
		series = binding.autoSizerInfo
	ENDIF

	'associate the info
	autoSizerBlock.hWnd = hwnd
	autoSizerBlock.space = space
	autoSizerBlock.size = size
	autoSizerBlock.x = x
	autoSizerBlock.y = y
	autoSizerBlock.w = w
	autoSizerBlock.h = h
	autoSizerBlock.flags = flags

	'register the block
	idBlock = GetPropA (hwnd, &$$AutoSizerInfo$)

	IFZ idBlock THEN
		'make a new block
		idBlock = autoSizerInfo_add (series, autoSizerBlock)+1
		IFF idBlock THEN
			RETURN $$FALSE		' fail
		ENDIF
		IFZ SetPropA (hwnd, &$$AutoSizerInfo$, idBlock) THEN
			RETURN $$FALSE		' fail
		ELSE
			bOK = $$TRUE
		ENDIF

		'make a splitter if we need one
		IF autoSizerBlock.flags AND $$SIZER_SPLITTER THEN
			splitterInfo.group = series
			splitterInfo.id = idBlock-1
			splitterInfo.direction = autoSizerInfoUM[series].direction

			autoSizerInfo_get (series, idBlock-1, @autoSizerBlock)
			autoSizerBlock.hSplitter = CreateWindowExA (0, &$$WINX_SPLITTER_CLASS$, 0, $$WS_CHILD|$$WS_VISIBLE|$$WS_CLIPSIBLINGS, _
			0, 0, 0, 0, GetParent(hwnd), 0, GetModuleHandleA (0), SPLITTERINFO_New (@splitterInfo))
			autoSizerInfo_update (series, idBlock-1, autoSizerBlock)
		ENDIF

	ELSE
		'update the old one
		bOK = autoSizerInfo_update (series, idBlock-1, autoSizerBlock)
	ENDIF

	GetClientRect (hwnd, &rect)
	sizeWindow (hwnd, rect.right-rect.left, rect.bottom-rect.top)		' resize the window

	RETURN bOK
END FUNCTION
'
' ############################
' #####  WinXSetMinSize  #####
' ############################
' Sets the minimum size for a window.
' hWnd = the window handle
' winWidth and winHeight = the minimum width and height of the window rectangle
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetMinSize (hWnd, winWidth, winHeight)
	BINDING			binding
	RECT rect

	SetLastError (0)
	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail
'
' 0.6.0.2-old---
' Don't adjust the client area: the dimensions of the window
' are the dimensions for its outside rectangle.
'
'	' only adjusts the right and bottom values
'	rect.right = winWidth
'	rect.bottom = winHeight
'	AdjustWindowRectEx (&rect, GetWindowLongA (hWnd, $$GWL_STYLE), GetMenu (hWnd), GetWindowLongA (hWnd, $$GWL_EXSTYLE))
'	binding.minW = rect.right-rect.left
'	binding.minH = rect.bottom-rect.top
' 0.6.0.2-old~~~
' 0.6.0.2-new---
	' minimum width of the window
	IF winWidth > 0 THEN
		cxminimized = GetSystemMetrics ($$SM_CXMINIMIZED)		' Width of rectangle into which minimised windows must fit
		IF winWidth >= cxminimized THEN
			binding.minW = winWidth
			'msg$ = "WinXSetMinSize: binding.minW =" + STR$ (binding.minW)
			'WinXDialog_Error (msg$, "WinX-Debug", 0)		' information
		ENDIF
	ENDIF

	' minimum height of the window
	IF winHeight > 0 THEN
		winHeight = winHeight
		cyminimized = GetSystemMetrics ($$SM_CYMINIMIZED)		' Height of rectangle into which minimised windows must fit
		IF winHeight >= cyminimized THEN
			binding.minH = winHeight
			'msg$ = "WinXSetMinSize: binding.minH =" + STR$ (binding.minH)
			'WinXDialog_Error (msg$, "WinX-Debug", 0)		' information
		ENDIF
	ENDIF
' 0.6.0.2-new~~~
'
	bOK = binding_update (idBinding, binding)

	RETURN bOK
END FUNCTION
'
' ##############################
' #####  WinXRegOnCommand  #####
' ##############################
' Registers the .onCommand callback function.
' hWnd = the window to register
' FnOnCommand = the function to process commands
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnCommand (hWnd, FUNCADDR FnOnCommand)
	BINDING			binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onCommand = FnOnCommand
	bOK = binding_update (idBinding, binding)

	RETURN bOK
END FUNCTION
'
' #############################
' #####  ApiLBItemFromPt  #####
' #############################
'
' A wrapper for the troublesome WinAPI LBItemFromPt().
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
' ###########################
' #####  ApiAlphaBlend  #####
' ###########################
'
'A wrapper for the misdefined WinAPI AlphaBlend().
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
	args[10] = XLONGAT(&blendFunction)

	ret = XstCall ("AlphaBlend", "msimg32.dll", @args[])
	RETURN ret

END FUNCTION
'
' #########################
' #####  mainWndProc  #####
' #########################
' The main window procedure.
' parameters and return are as usual
FUNCTION mainWndProc (hWnd, wMsg, wParam, lParam)
'
' GL-Unecessary---
'	SHARED #drag_button
'	SHARED #drag_hwnd
'	SHARED #drag_image
' GL-Unecessary~~~
'
	SHARED DLM_MESSAGE
	SHARED hClipMem		' global memory for clipboard operations

	STATIC dragItem
	STATIC lastDragItem
	STATIC lastW
	STATIC lastH
	PAINTSTRUCT	ps
	BINDING binding

	XLONG MBT_const		' = $$MBT_LEFT...
'
' Unused---
'	BINDING innerBinding
' Unused~~~
'
	MINMAXINFO mmi
	RECT rect
	SCROLLINFO si
	DRAGLISTINFO	dli
	TV_HITTESTINFO tvHit
	POINT pt
	POINT mouseXY
	TRACKMOUSEEVENT tme

	XLONG notifyCode, id, hCtr

	' Message handled with a return code.
	XLONG handled		' handled = $$TRUE => message handled
	XLONG ret		' return code when handled = $$TRUE
	XLONG x, y

	SetLastError (0)

	'set to true if we handle the message
	handled = $$FALSE		' Windows message NOT handled

	' mainWndProc()'s return value
	ret = 0

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN
		RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam)
	ENDIF
'
' Call first any associated message handler,
'
	IF binding.msgHandlers THEN
		bOK = handler_call (binding.msgHandlers, @ret_value, hWnd, wMsg, wParam, lParam)
		IF bOK THEN
			' handled by the message handler
			handled = $$TRUE
			ret = ret_value
		ENDIF
	ENDIF
'
' and handle the message.
'
	SELECT CASE wMsg
		CASE $$WM_DRAWCLIPBOARD
			IF binding.hWndNextClipViewer THEN
				SendMessageA (binding.hWndNextClipViewer, $$WM_DRAWCLIPBOARD, wParam, lParam)
			ENDIF
			RETURN @binding.onClipChange ()
			'
		CASE $$WM_CHANGECBCHAIN
			IF wParam = binding.hWndNextClipViewer THEN
				binding.hWndNextClipViewer = lParam
			ELSE
				IF binding.hWndNextClipViewer THEN
					SendMessageA (binding.hWndNextClipViewer, $$WM_CHANGECBCHAIN, wParam, lParam)
				ENDIF
			ENDIF
			RETURN 0
			'
		CASE $$WM_DESTROYCLIPBOARD
			IF hClipMem THEN
				GlobalFree (hClipMem)
				hClipMem = 0		'prevent from freeing twice hClipMem
			ENDIF
			RETURN 0
			'
		CASE $$WM_DROPFILES
			DragQueryPoint (wParam, &pt)
			'
			cFiles = DragQueryFileA (wParam, -1, 0, 0)
			IF cFiles > 0 THEN
				upp = cFiles - 1
				DIM fileList$[upp]
				FOR i = 0 TO upp
					cChar = DragQueryFileA (wParam, i, 0, 0)
					IF cChar > 0 THEN
						szBuf$ = NULL$ (cChar)		' NULL$$() adds a nul-terminator
						DragQueryFileA (wParam, i, &szBuf$, cChar)
						fileList$[i] = CSTRING$ (&szBuf$)
					ENDIF
				NEXT i
				DragFinish (wParam)
				'
				RETURN @binding.onDropFiles (hWnd, pt.x, pt.y, @fileList$[])
			ENDIF
			'
			DragFinish (wParam)
			RETURN 0
			'
		CASE $$WM_COMMAND		' User selected a command
'
' 0.6.0.2-old---
'			RETURN @binding.onCommand(LOWORD(wParam), HIWORD(wParam), lParam)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			id = LOWORD (wParam)
			notifyCode = HIWORD (wParam)
			'
			IF binding.onCommand THEN
				RETURN @binding.onCommand (id, notifyCode, lParam)
			ENDIF
			IF binding.useDialogInterface THEN
				SELECT CASE id
					CASE $$IDCANCEL
						' handle the Escape key
						IF notifyCode = $$BN_CLICKED THEN
							ShowWindow (hWnd, $$SW_HIDE)
							RETURN 1
						ENDIF
						'
				END SELECT
			ENDIF
			'
			RETURN 0
' 0.6.0.2-new~~~
'
		CASE $$WM_ERASEBKGND		' the window background must be erased
			IF binding.backCol THEN
				SetLastError (0)
				ret = GetClientRect (hWnd, &rect)
				IF ret THEN
					' Erase the background by filling
					' the rectangle using the binding.backCol brush.
					FillRect (wParam, &rect, binding.backCol)
					RETURN 0
				ELSE
					msg$ = "mainWndProc: Can't get the client rectangle of the window"
					GuiTellApiError (msg$)
				ENDIF
			ENDIF
			'
		CASE $$WM_PAINT
			hDC = BeginPaint (hWnd, &ps)
			IFZ hDC THEN EXIT SELECT		'just in case!
			'
			'use auto-draw
			WinXGetUseableRect (hWnd, @rect)
'
' DELETED---
			' Auto scroll?
'			IF binding.hScrollPageM THEN
'				GetScrollInfo (hWnd, $$SB_HORZ, &si)
'				xOff = (si.nPos-binding.hScrollPageC)\binding.hScrollPageM
'				GetScrollInfo (hWnd, $$SB_VERT, &si)
'				yOff = (si.nPos-binding.hScrollPageC)\binding.hScrollPageM
'			ENDIF
' DELETED~~~
'
' GL-old---
'			autoDraw_draw(hDC, binding.autoDrawInfo, xOff, yOff)
' GL-old~~~
' GL-new+++
			'use auto-draw
			' .autoDrawInfo is an id (>= 1)
			IF binding.autoDrawInfo > 0 THEN
				autoDraw_draw(hDC, binding.autoDrawInfo, xOff, yOff)
			ENDIF
' GL-new~~~
'
			IF binding.paint THEN
				ret = @binding.paint(hWnd, hDC)
			ENDIF
			'
			EndPaint (hWnd, &ps)
			RETURN ret
			'
		CASE $$WM_SIZE
'
' 0.6.0.2-old---
'			w = LOWORD (lParam)
'			h = HIWORD (lParam)
' 0.6.0.2-old~~~
' 0.6.0.2-new---
			bErr = $$FALSE
			SetLastError (0)
			ret = GetWindowRect (hWnd, &rect)		' get size and position of the window
			IFZ ret THEN
				msg$ = "mainWndProc: Can't get size and position of the window"
				bErr = GuiTellApiError (msg$)
				IF bErr THEN RETURN		' invalid handle
			ENDIF
			'
			winWidth  = rect.right - rect.left
			winHeight = rect.bottom - rect.top
			'
			'get the binding
			idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
			IFF binding_get (idBinding, @binding) THEN RETURN 0		' fail
			bResize = $$FALSE
			' ( binding.minW, binding.minH ) = minimum width and height of the window
			IF winWidth < binding.minW THEN
				' increase above the minimum width
				winWidth = binding.minW
				bResize = $$TRUE
			ENDIF
			'
			IF winHeight < binding.minH THEN
				' increase above the minimum height
				winHeight = binding.minH
				bResize = $$TRUE
			ENDIF
			'
			IF bResize THEN
				SetWindowPos (hWnd, $$HWND_TOP, 0, 0, winWidth, winHeight, $$SWP_NOMOVE)
			ENDIF
			'
			sizeWindow (hWnd, winWidth, winHeight)		' resize the window
' 0.6.0.2-new~~~
'
			handled = $$TRUE
			'
		CASE $$WM_HSCROLL,$$WM_VSCROLL
			'TrackBar scrolling.
			cChar = LEN($$TRACKBAR_CLASS)
			buffer$ = NULL$(cChar+1)		' ensure always a nul-terminator
			'
			GetClassNameA (lParam, &buffer$, cChar)
			buffer$ = TRIM$(CSTRING$(&buffer$))
			IF LCASE$ (buffer$) = LCASE$ ($$TRACKBAR_CLASS) THEN
				RETURN @binding.onTrackerPos (GetDlgCtrlID (lParam), SendMessageA (lParam, $$TBM_GETPOS, 0, 0))
			ENDIF
			'
			'Default scrolling.
			sbval = LOWORD(wParam)
			IF wMsg = $$WM_HSCROLL THEN
				typeBar = $$SB_HORZ
				dir = $$DIR_HORIZ
				scrollUnit = binding.hScrollUnit
			ELSE
				typeBar = $$SB_VERT
				dir = $$DIR_VERT
				scrollUnit = binding.vScrollUnit
			ENDIF
			'
			si.cbSize = SIZE(SCROLLINFO)
			si.fMask = $$SIF_ALL|$$SIF_DISABLENOSCROLL
			GetScrollInfo (hWnd, typeBar, &si)
			'
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
			'
			SetScrollInfo (hWnd, typeBar, &si, 1)
			RETURN @binding.onScroll(si.nPos, hWnd, dir)
'
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
'
		CASE $$WM_SETFOCUS
			IF binding.onFocusChange THEN RETURN @binding.onFocusChange(hWnd, $$TRUE)
			'
		CASE $$WM_KILLFOCUS
			IF binding.onFocusChange THEN RETURN @binding.onFocusChange(hWnd, $$FALSE)
			'
		CASE $$WM_SETCURSOR
			IF binding.hCursor THEN
				IF LOWORD(lParam) = $$HTCLIENT THEN
					SetCursor (binding.hCursor)
					RETURN $$TRUE
				ENDIF
			ENDIF
			'
		CASE $$WM_MOUSEMOVE
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			'
			IFF binding.isMouseInWindow THEN
				tme.cbSize = SIZE(tme)
				tme.dwFlags = $$TME_LEAVE
				tme.hwndTrack = hWnd
				TrackMouseEvent (&tme)
				binding.isMouseInWindow = $$TRUE
				bOK = binding_update (idBinding, binding)
				'
				@binding.onEnterLeave (hWnd, $$TRUE)
			ENDIF
			'
			SELECT CASE #drag_button
				CASE $$MBT_LEFT, $$MBT_RIGHT
					GOSUB dragTreeViewItem
					IFZ ret THEN
						cursor = $$IDC_NO
					ELSE
						cursor = $$IDC_ARROW
					ENDIF
					SetCursor (LoadCursorA (0, cursor))
					ret = 0
					'
				CASE ELSE
					ret = @binding.onMouseMove(hWnd, mouseXY.x, mouseXY.y)
					'
			END SELECT
			'
			RETURN ret
			'
		CASE $$WM_MOUSELEAVE
			binding.isMouseInWindow = $$FALSE
			bOK = binding_update (idBinding, binding)
			IF binding.onEnterLeave THEN
				RETURN @binding.onEnterLeave (hWnd, $$FALSE)
			ENDIF
			RETURN 0
			'
		CASE $$WM_LBUTTONDOWN
			'mouse's left button pressed down
			IF binding.onMouseDown THEN
				MBT_const = $$MBT_LEFT
				mouseXY.x = LOWORD(lParam)
				mouseXY.y = HIWORD(lParam)
				RETURN @binding.onMouseDown(hWnd, MBT_const, LOWORD(lParam), HIWORD(lParam))
			ENDIF
			RETURN 0
			'
		CASE $$WM_MBUTTONDOWN
			'mouse's middle button pressed down
			IF binding.onMouseDown THEN
				MBT_const = $$MBT_MIDDLE
				mouseXY.x = LOWORD(lParam)
				mouseXY.y = HIWORD(lParam)
				RETURN @binding.onMouseDown(hWnd, MBT_const, LOWORD(lParam), HIWORD(lParam))
			ENDIF
			RETURN 0
			'
		CASE $$WM_RBUTTONDOWN
			'mouse's right button pressed down
			IF binding.onMouseDown THEN
				MBT_const = $$MBT_RIGHT
				mouseXY.x = LOWORD(lParam)
				mouseXY.y = HIWORD(lParam)
				RETURN @binding.onMouseDown(hWnd, MBT_const, LOWORD(lParam), HIWORD(lParam))
			ENDIF
			RETURN 0
			'
		CASE $$WM_LBUTTONUP
			'mouse's left button released
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			IF #drag_button = $$MBT_LEFT THEN
				'dragged with mouse's left button
				GOSUB dragTreeViewItem
				'
				' #drag_hwnd == tvHit.hItem
				IF binding.onDrag THEN
					@binding.onDrag(GetDlgCtrlID (#drag_hwnd), $$DRAG_DONE, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
				ENDIF
				GOSUB endDragTreeViewItem
			ELSE
				'dragged with mouse's right button
				IF binding.onMouseUp THEN
					RETURN @binding.onMouseUp(hWnd, $$MBT_LEFT,LOWORD(lParam), HIWORD(lParam))
				ENDIF
			ENDIF
			RETURN 0
			'
		CASE $$WM_MBUTTONUP
			'dragged with mouse's middle button
			IF binding.onMouseUp THEN
				mouseXY.x = LOWORD(lParam)
				mouseXY.y = HIWORD(lParam)
				RETURN @binding.onMouseUp(hWnd, $$MBT_MIDDLE, LOWORD(lParam), HIWORD(lParam))
			ENDIF
			RETURN 0
			'
		CASE $$WM_RBUTTONUP
			'dragged with mouse's right button
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			IF #drag_button = $$MBT_LEFT THEN
				GOSUB dragTreeViewItem
				IF binding.onDrag THEN
					' #drag_hwnd == tvHit.hItem
					@binding.onDrag(GetDlgCtrlID (#drag_hwnd), $$DRAG_DONE, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
				ENDIF
				GOSUB endDragTreeViewItem
			ELSE
				IF binding.onMouseUp THEN
					RETURN @binding.onMouseUp(hWnd, $$MBT_RIGHT, LOWORD(lParam), HIWORD(lParam))
				ENDIF
			ENDIF
			RETURN 0
			'
		CASE $$WM_MOUSEWHEEL
'
' BROKEN---
' This message is broken.  It gets passed to active window rather than the window under the mouse
' ----------------------
' kept+++
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
' kept~~~
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
' kept~~~
' -------------------------------------------------------
'			ELSE
'				IF innerBinding.onMouseWheel THEN
'					RETURN @innerBinding.onMouseWheel(hChild, HIWORD(wParam), LOWORD(lParam), HIWORD(lParam))
'				ELSE
'					RETURN @binding.onMouseWheel(hWnd, HIWORD(wParam), LOWORD(lParam), HIWORD(lParam))
'				END IF
'			END IF
' BROKEN~~~
'
		CASE $$WM_KEYDOWN
			RETURN @binding.onKeyDown(hWnd, wParam)
			'
		CASE $$WM_KEYUP
			RETURN @binding.onKeyUp(hWnd, wParam)
			'
		CASE $$WM_CHAR
			RETURN @binding.onChar(hWnd, wParam)
			'
		CASE DLM_MESSAGE
			IF DLM_MESSAGE THEN
				RtlMoveMemory (&dli, lParam, SIZE(DRAGLISTINFO))
				'
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
								IF item != dragItem THEN
									SendMessageA (dli.hWnd, $$LB_GETITEMRECT, item, &rect)
									InvalidateRect (dli.hWnd, 0, 1)		' erase
									UpdateWindow (dli.hWnd)
									hDC = GetDC (dli.hWnd)
									'
									'draw insert bar
									MoveToEx (hDC, rect.left+1, rect.top-1, 0)
									LineTo (hDC, rect.right-1, rect.top-1)
									'
									MoveToEx (hDC, rect.left+1, rect.top, 0)
									LineTo (hDC, rect.right-1, rect.top)
									'
									MoveToEx (hDC, rect.left+1, rect.top-3, 0)
									LineTo (hDC, rect.left+1, rect.top+3)
									'
									MoveToEx (hDC, rect.left+2, rect.top-2, 0)
									LineTo (hDC, rect.left+2, rect.top+2)
									'
									MoveToEx (hDC, rect.right-2, rect.top-3, 0)
									LineTo (hDC, rect.right-2, rect.top+3)
									'
									MoveToEx (hDC, rect.right-3, rect.top-2, 0)
									LineTo (hDC, rect.right-3, rect.top+2)
									'
									ReleaseDC (dli.hWnd, hDC)
									dragItem = item
								ENDIF
								'
								RETURN $$DL_MOVECURSOR
							ELSE
								IF item != dragItem THEN
									InvalidateRect (dli.hWnd, 0, $$TRUE)
									dragItem = item
								ENDIF
								RETURN $$DL_STOPCURSOR
							ENDIF
						ELSE
							IF item != dragItem THEN
								InvalidateRect (dli.hWnd, 0, $$TRUE)
								dragItem = -1
							ENDIF
							RETURN $$DL_STOPCURSOR
						ENDIF
						'
					CASE $$DL_DROPPED
						InvalidateRect (dli.hWnd, 0, 1)		' erase
						IF binding.onDrag THEN
							item = ApiLBItemFromPt (dli.hWnd, dli.ptCursor.x, dli.ptCursor.y, 1)
							IFF @binding.onDrag(wParam, $$DRAG_DRAGGING, item, dli.ptCursor.x, dli.ptCursor.y) THEN
								item = -1
							ENDIF
							@binding.onDrag(wParam, $$DRAG_DONE, item, dli.ptCursor.x, dli.ptCursor.y)
						ENDIF
						' GL?-@binding.onDrag(wParam, $$DRAG_DONE, item, dli.ptCursor.x, dli.ptCursor.y)
						WinXListBox_RemoveItem (dli.hWnd, -1)
						'
				END SELECT
			ENDIF
			handled = $$TRUE
			'
		CASE $$WM_GETMINMAXINFO
			pMmi = &mmi
			ULONGAT(&&mmi) = lParam
			mmi.ptMinTrackSize.x = binding.minW
			mmi.ptMinTrackSize.y = binding.minH
			ULONGAT(&&mmi) = pMmi
			handled = $$TRUE		' handled
			'
		CASE $$WM_PARENTNOTIFY
			SELECT CASE LOWORD(wParam)
				CASE $$WM_DESTROY
'
' GL-old---
'					'free the auto-sizer block if there is one
'					autoSizerInfo_delete (binding.autoSizerInfo, GetPropA (lParam, &$$AutoSizerInfo$)-1)
' GL-old~~~
' GL-new+++
					'free the auto-sizer block if there is one
					idBlock = GetPropA (lParam, &$$AutoSizerInfo$)
					IF idBlock > 0 THEN
						autoSizerInfo_delete (binding.autoSizerInfo, idBlock - 1)
					ENDIF
' GL-new~~~
'
			END SELECT
			handled = $$TRUE
			'
		CASE $$WM_NOTIFY		' notification message
'
' 0.6.0.2-old---
'			RETURN onNotify (hWnd, wParam, lParam, binding)
' 0.6.0.2-old~~~
			ret = onNotify (hWnd, wParam, lParam, binding)
			IF ret THEN handled = $$TRUE
' 0.6.0.2-new+++
'
		CASE $$WM_TIMER
			SELECT CASE wParam
				CASE -1
					IF lastDragItem = dragItem THEN
						ImageList_DragShowNolock ($$FALSE)
						SendMessageA (#drag_hwnd, $$TVM_EXPAND, $$TVE_EXPAND, dragItem)
						ImageList_DragShowNolock ($$TRUE)
					ENDIF
					KillTimer (hWnd, -1)
			END SELECT
			'
			RETURN 0
			'
		CASE $$WM_CLOSE		' closed by user
'
' 0.6.0.1-old---
'			IFZ binding.onClose THEN
'				DestroyWindow (hWnd)
'				PostQuitMessage(0)
'			ELSE
'				RETURN @binding.onClose (hWnd)
'			ENDIF
' 0.6.0.1-old~~~
' 0.6.0.1-new+++
'FUNCTION FnOnClose (hWnd)
'	' Make sure the user really wanted to quit
'	IF MessageBoxA (hWnd, &"Really quit?", &"Question", $$MB_YESNO|$$MB_ICONQUESTION) = $$IDNO THEN
'		RETURN 1		' exit program is canceled
'	ENDIF
'END FUNCTION
			ret = 0
			IF binding.onClose THEN
				' ret <> 0 => message WM_CLOSE is handled
				ret = @binding.onClose (hWnd)
			ENDIF
			'
			IFZ ret THEN
				GOSUB DestroyCurrentWindow
				PostQuitMessage($$WM_QUIT)		' quit program
			ENDIF
			'
			handled = $$TRUE
			RETURN ret
' 0.6.0.1-new~~~
'
		CASE $$WM_DESTROY		' being destroyed
			GOSUB DestroyCurrentWindow
			handled = $$TRUE
			'
	END SELECT

	IF handled THEN
		RETURN ret
	ELSE
		RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam)
	ENDIF
'
' MDI???
'		IF MDI THEN
'			' Pass the message to the default MDI procedure
'			RETURN DefMDIChildProcA (hWnd, wMsg, wParam, lParam)
'		ELSE
'			RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam)
'		ENDIF
'	ENDIF
' MDI~~~
'
	SUB DestroyCurrentWindow
		ShowWindow (hWnd, $$SW_HIDE)
		ChangeClipboardChain (hWnd, binding.hWndNextClipViewer)
		binding_delete (idBinding)		'clear the binding
	END SUB

	SUB dragTreeViewItem
		tvHit.pt.x = LOWORD(lParam)
		tvHit.pt.y = HIWORD(lParam)
		ClientToScreen (hWnd, &tvHit.pt)
		pt = tvHit.pt

		GetWindowRect (#drag_hwnd, &rect)
		tvHit.pt.x = tvHit.pt.x - rect.left
		tvHit.pt.y = tvHit.pt.y - rect.top

		SendMessageA (#drag_hwnd, $$TVM_HITTEST, 0, &tvHit)

		IF tvHit.hItem != dragItem THEN
			ImageList_DragShowNolock ($$FALSE)
			SendMessageA (#drag_hwnd, $$TVM_SELECTITEM, $$TVGN_DROPHILITE, tvHit.hItem)
			ImageList_DragShowNolock (1)
			dragItem = tvHit.hItem
		ENDIF

		IF WinXTreeView_GetChildItem (#drag_hwnd, tvHit.hItem) THEN
			SetTimer (hWnd, -1, 400, 0)
			lastDragItem = dragItem
		ENDIF

		ret = @binding.onDrag(GetDlgCtrlID (#drag_hwnd), $$DRAG_DRAGGING, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
		ImageList_DragMove (pt.x, pt.y)
	END SUB
'
'Ends drag operation.
'
	SUB endDragTreeViewItem
		IFZ #drag_button THEN EXIT SUB		' drag operation already ended
		'
		#drag_button = 0		' reset the global dragging indicator to a non-dragging state
		IF #drag_image THEN
			ImageList_EndDrag ()		' inform image list that dragging has stopped
			ImageList_Destroy (#drag_image)
			#drag_image = 0
		ENDIF
		ReleaseCapture ()		' release the mouse capture
		SendMessageA (#drag_hwnd, $$TVM_SELECTITEM, $$TVGN_DROPHILITE, 0)
	END SUB

END FUNCTION		' mainWndProc
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

	AUTOSIZERINFO autoSizerBlock
	SPLITTERINFO splitterInfo
	RECT rect
	RECT dock
	PAINTSTRUCT ps
	TRACKMOUSEEVENT tme
	POINT newMousePos
	POINT pt
	STATIC POINT vertex[]

	SetLastError (0)
	SPLITTERINFO_Get (GetWindowLongA (hSplitter, $$GWL_USERDATA), @splitterInfo)

	SELECT CASE wMsg
		CASE $$WM_CREATE
			'lParam format = iSlitterInfo
			SetWindowLongA (hSplitter, $$GWL_USERDATA, XLONGAT(lParam))
			mouseIn = 0
			'
			DIM vertex[2]
			'
		CASE $$WM_PAINT
			hDC = BeginPaint (hSplitter, &ps)
			'
			hShadPen = CreatePen ($$PS_SOLID, 1, GetSysColor ($$COLOR_3DSHADOW))
			hBlackPen = CreatePen ($$PS_SOLID, 1, 0x000000)
			hBlackBrush = CreateSolidBrush (0x000000)
			hHighlightBrush = CreateSolidBrush (GetSysColor($$COLOR_HIGHLIGHT))
			SelectObject (hDC, hShadPen)
			'
			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hSplitter, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN FillRect (hDC, &dock, hHighlightBrush)
			'
			' clear flag $$DIR_REVERSE of direction
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
			'
			DeleteObject (hShadPen)
			DeleteObject (hBlackPen)
			DeleteObject (hBlackBrush)
			'
			EndPaint (hSplitter, &ps)
			'
			RETURN 0
			'
		CASE $$WM_LBUTTONDOWN
			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hSplitter, &pt)
			IFF PtInRect (&dock, pt.x, pt.y) || splitterInfo.docked THEN
				SetCapture (hSplitter)
				dragging = $$TRUE
				mousePos.x = LOWORD(lParam)
				mousePos.y = HIWORD(lParam)
				ClientToScreen (hSplitter, &mousePos)
			ENDIF
			'
			RETURN 0
			'
		CASE $$WM_SETCURSOR
			GOSUB GetRect
			'
			GetCursorPos (&pt)
			ScreenToClient (hSplitter, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
				SetCursor (LoadCursorA (0, $$IDC_HAND))
			ELSE
				GOSUB SetSizeCursor
			ENDIF
			'
			RETURN $$TRUE		' fail
			'
		CASE $$WM_MOUSEMOVE
			GOSUB GetRect
			'
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
			'
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
				'
				tme.cbSize = SIZE(tme)
				tme.dwFlags = $$TME_LEAVE
				tme.hwndTrack = hSplitter
				TrackMouseEvent (&tme)
				mouseIn = $$TRUE
			ENDIF
			'
			IF dragging THEN
				newMousePos.x = LOWORD(lParam)
				newMousePos.y = HIWORD(lParam)
				ClientToScreen (hSplitter, &newMousePos)
				'
				'PRINT mouseX, newMouseX, mouseY, newMouseY
				'
				autoSizerInfo_get (splitterInfo.group, splitterInfo.id, @autoSizerBlock)
				'
				' clear flag $$DIR_REVERSE of direction
				SELECT CASE splitterInfo.direction AND 0x00000003
					CASE $$DIR_HORIZ
						delta = newMousePos.x - mousePos.x
					CASE $$DIR_VERT
						delta = newMousePos.y - mousePos.y
				END SELECT
				'
				IFZ delta THEN RETURN 0		' fail
				IF splitterInfo.direction AND $$DIR_REVERSE THEN
					autoSizerBlock.size = autoSizerBlock.size-delta
					IF splitterInfo.min && autoSizerBlock.size < splitterInfo.min THEN
						autoSizerBlock.size = splitterInfo.min
					ELSE
						IF (splitterInfo.max > 0) && (autoSizerBlock.size > splitterInfo.max) THEN autoSizerBlock.size = splitterInfo.max
					ENDIF
				ELSE
					autoSizerBlock.size = autoSizerBlock.size+delta
					IF (splitterInfo.max > 0) && (autoSizerBlock.size > splitterInfo.max) THEN
						autoSizerBlock.size = splitterInfo.max
					ELSE
						IF splitterInfo.min && autoSizerBlock.size < splitterInfo.min THEN autoSizerBlock.size = splitterInfo.min
					ENDIF
				ENDIF
				'
				IF autoSizerBlock.size < 8 THEN
					autoSizerBlock.size = 8
				ELSE
					IF autoSizerBlock.size > splitterInfo.maxSize THEN autoSizerBlock.size = splitterInfo.maxSize
				ENDIF
				'
				autoSizerInfo_update (splitterInfo.group, splitterInfo.id, autoSizerBlock)
				'
				'refresh the parent window
				parent = GetParent (hSplitter)
				GetClientRect (parent, &rect)
				sizeWindow (parent, rect.right-rect.left, rect.bottom-rect.top)		' resize the parent window
				'
				mousePos = newMousePos
			ENDIF
			'
			RETURN 0
			'
		CASE $$WM_LBUTTONUP
			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hSplitter, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
				IF splitterInfo.docked THEN
					autoSizerInfo_get (splitterInfo.group, splitterInfo.id, @autoSizerBlock)
					autoSizerBlock.size = splitterInfo.docked
					splitterInfo.docked = 0
					'
					SPLITTERINFO_Update (GetWindowLongA (hSplitter, $$GWL_USERDATA), splitterInfo)
					'
					autoSizerInfo_update (splitterInfo.group, splitterInfo.id, autoSizerBlock)
					'
					'refresh the parent window
					parent = GetParent (hSplitter)
					GetClientRect (parent, &rect)
					sizeWindow (parent, rect.right-rect.left, rect.bottom-rect.top)		' resize the parent window
				ELSE
					autoSizerInfo_get (splitterInfo.group, splitterInfo.id, @autoSizerBlock)
					splitterInfo.docked = autoSizerBlock.size
					autoSizerBlock.size = 8
					'
					SPLITTERINFO_Update (GetWindowLongA (hSplitter, $$GWL_USERDATA), splitterInfo)
					'
					autoSizerInfo_update (splitterInfo.group, splitterInfo.id, autoSizerBlock)
					'
					'refresh the parent window
					parent = GetParent (hSplitter)
					GetClientRect (parent, &rect)
					sizeWindow (parent, rect.right-rect.left, rect.bottom-rect.top)		' resize the parent window
				ENDIF
			ELSE
				dragging = $$FALSE
				ReleaseCapture ()
			ENDIF
			'
			RETURN 0
			'
		CASE $$WM_MOUSELEAVE
			InvalidateRect (hSplitter, 0, 1)		' erase
			mouseIn = $$FALSE
			'
			RETURN 0
			'
		CASE $$WM_DESTROY
			SPLITTERINFO_Delete (GetWindowLongA (hSplitter, $$GWL_USERDATA))
			RETURN 0
			'
		CASE ELSE
			RETURN DefWindowProcA (hSplitter, wMsg, wParam, lParam)
			'
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
				' clear flag $$DIR_REVERSE of direction
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
		' clear flag $$DIR_REVERSE of direction
		SELECT CASE splitterInfo.direction AND 0x00000003
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
' ######################
' #####  onNotify  #####
' ######################
' Handles notify messages.
FUNCTION onNotify (hWnd, wParam, lParam, BINDING binding)
'
'	SHARED #drag_button
'	SHARED #drag_hwnd
'	SHARED #drag_image
'
	NMHDR nmhdr
	TV_DISPINFO nmtvdi
	NM_TREEVIEW nmtv
	LV_DISPINFO nmlvdi
	NMKEY nmkey
	NM_LISTVIEW nmlv
	NMSELCHANGE nmsc
	RECT rect
	SYSTEMTIME sysTime		' for message MCN_SELCHANGE

	XLONG ret		' return code when handled = $$TRUE

	ULONG pNmhdr		' pointer to nmhdr
	ULONG pNmkey		' pointer to nmkey
	ULONG pNmsc		' pointer to nmsc
	ULONG pNmtvdi		' pointer to nmtvdi
	ULONG pNmtv		' pointer to nmtv
	ULONG pNmlv		' pointer to nmlv
	ULONG pNmlvdi		' pointer to nmlvdi

	SetLastError (0)
	IFZ hWnd THEN RETURN 0		' fail
	IFZ lParam THEN RETURN 0		' fail

	ret = 0		' not handled

	pNmhdr = &nmhdr
	ULONGAT(&&nmhdr) = lParam		' lParam is an address

	SELECT CASE nmhdr.code
		CASE $$NM_CLICK, $$NM_DBLCLK, $$NM_RCLICK, $$NM_RDBLCLK, $$NM_RETURN, $$NM_HOVER
			ret = @binding.onItem (nmhdr.idFrom, nmhdr.code, 0)
		CASE $$NM_KEYDOWN
			IF binding.onItem THEN
				pNmkey = &nmkey
				ULONGAT(&&nmkey) = lParam		' address
				ret = @binding.onItem (nmhdr.idFrom, nmhdr.code, nmkey.nVKey)
				ULONGAT(&&nmkey) = pNmkey
			ENDIF
'
' 0.6.0.2-old---
'		CASE $$MCN_SELECT
'			pNmsc = &nmsc
'			ULONGAT(&&nmsc) = lParam		' address
'			ret = @binding.onCalendarSelect (nmhdr.idFrom, nmsc.stSelStart)
'			ULONGAT(&&nmsc) = pNmsc
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
		CASE $$MCN_SELECT, $$MCN_SELCHANGE
			IF binding.onCalendarSelect THEN
				pNmsc = &nmsc
				ULONGAT(&&nmsc) = lParam		' address
				IF notifyCode = $$MCN_SELECT THEN
					sysTime = nmsc.stSelStart
				ELSE
					SendMessageA (nmsc.hdr.hwndFrom, $$MCM_GETCURSEL, SIZE (SYSTEMTIME), &sysTime)
				ENDIF
				ret = @binding.onCalendarSelect (nmhdr.idFrom, sysTime)
				ULONGAT(&&nmsc) = pNmsc
			ENDIF
' 0.6.0.2-new~~~
'
		CASE $$TVN_BEGINLABELEDIT		'  sent as notification
			' the program sent a message TVM_EDITLABEL
			IF binding.onLabelEdit THEN
				pNmtvdi = &nmtvdi
				ULONGAT(&&nmtvdi) = lParam		' address
				'.onLabelEdit(id, edit_const, edit_item, newLabel$)
				ret_value = @binding.onLabelEdit(nmtvdi.hdr.idFrom, $$EDIT_START, nmtvdi.item.hItem, "")
				IFZ ret_value THEN
					ret = 1		' handled
					ULONGAT(&&nmtvdi) = pNmtvdi
				ENDIF
			ENDIF
		CASE $$TVN_ENDLABELEDIT
			pNmtvdi = &nmtvdi
			ULONGAT(&&nmtvdi) = lParam		' address
'
' 0.6.0.2-old---
'			ret = @binding.onLabelEdit(nmtvdi.hdr.idFrom, $$EDIT_DONE, nmtvdi.item.hItem, CSTRING$(nmtvdi.item.pszText))
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			newLabel$ = CSTRING$ (nmtvdi.item.pszText)
			IFZ binding.onLabelEdit THEN
				hTreeView = GetDlgItem (hWnd, nmtvdi.hdr.idFrom)
				WinXTreeView_SetItemLabel (hTreeView, nmtvdi.item.hItem, newLabel$)		' update label
			ELSE
				' .onLabelEdit(id, edit_const, edit_item, newLabel$)
				ret = @binding.onLabelEdit (nmtvdi.hdr.idFrom, $$EDIT_DONE, nmtvdi.item.hItem, newLabel$)
			ENDIF
' 0.6.0.2-new~~~
'
			ULONGAT(&&nmtvdi) = pNmtvdi
			'
		CASE $$TVN_BEGINDRAG,$$TVN_BEGINRDRAG
			'begin the notify trap
			pNmtv = &nmtv
			ULONGAT(&&nmtv) = lParam		' address
			IF @binding.onDrag(nmtv.hdr.idFrom, $$DRAG_START, nmtv.itemNew.hItem, nmtv.ptDrag.x, nmtv.ptDrag.y) THEN
				#drag_hwnd = nmtv.hdr.hwndFrom
				'
				SELECT CASE nmhdr.code
					CASE $$TVN_BEGINDRAG	: #drag_button = $$MBT_LEFT
					CASE $$TVN_BEGINRDRAG	: #drag_button = $$MBT_RIGHT
				END SELECT
				'
				ULONGAT(&rect) = nmtv.itemNew.hItem
				SendMessageA (nmtv.hdr.hwndFrom, $$TVM_GETITEMRECT, $$TRUE, &rect)
				rect.left = rect.left-SendMessageA (nmtv.hdr.hwndFrom, $$TVM_GETINDENT, 0, 0)
				'
				'create the dragging image
				w = rect.right-rect.left
				h = rect.bottom-rect.top
				'
				hDCtv = GetDC (nmtv.hdr.hwndFrom)     '  GetDC requires ReleaseDC
				'
				' get a compatible bitmap hBmp
				mDC = CreateCompatibleDC (hDCtv)
				hBmp = CreateCompatibleBitmap (hDCtv, w, h)
				hEmpty = SelectObject (mDC, hBmp)		' save the default compatible bitmap hEmpty
				'
				BitBlt (mDC, 0, 0, w, h, hDCtv, rect.left, rect.top, $$SRCCOPY)
				'
				SelectObject (mDC, hEmpty)		' restore the default compatible bitmap hEmpty
				DeleteDC (mDC)
				mDC = 0     '  release Compatible Device Context mDC
				'
				ReleaseDC (nmtv.hdr.hwndFrom, hDCtv)
				hDCtv = 0     '  release Device Context hDCtv
				'
				#drag_image = ImageList_Create (w, h, $$ILC_COLOR32|$$ILC_MASK, 1, 0)
				ImageList_AddMasked (#drag_image, hBmp, 0x00FFFFFF)
				'
				ImageList_BeginDrag (#drag_image, 0, nmtv.ptDrag.x-rect.left, nmtv.ptDrag.y-rect.top)
				ImageList_DragEnter (GetDesktopWindow (), rect.left, rect.top)
				'
				SetCapture (hWnd)		' snap mouse & window
			ENDIF
			ULONGAT(&&nmtv) = pNmtv		' address
'
' 0.6.0.2-new+++
		CASE $$LVN_ITEMCHANGED, $$TVN_SELCHANGED
			RETURN @binding.onItem (nmhdr.idFrom, nmhdr.code, lParam)
' 0.6.0.2-new~~~
'
		CASE $$TCN_SELCHANGE
			IF nmhdr.hwndFrom THEN
				currTab = SendMessageA (nmhdr.hwndFrom, $$TCM_GETCURSEL, 0, 0)
				'
				'hide first all the tabs
				maxTab = SendMessageA (nmhdr.hwndFrom, $$TCM_GETITEMCOUNT, 0, 0)-1
				FOR i = 0 TO maxTab
					autoSizerInfo_showGroup (WinXTabs_GetAutosizerSeries (nmhdr.hwndFrom, i), $$FALSE)
				NEXT i
				'
				'only current tab is visible
				autoSizerInfo_showGroup (WinXTabs_GetAutosizerSeries (nmhdr.hwndFrom, currTab), $$TRUE)
				'
				'refresh the parent window
				GetClientRect (GetParent(nmhdr.hwndFrom), &rect)
				sizeWindow (GetParent(nmhdr.hwndFrom), rect.right-rect.left, rect.bottom-rect.top)		' resize the parent window
				'
				RETURN @binding.onItem (nmhdr.idFrom, $$TCN_SELCHANGE, currTab)
			ENDIF
'
' 0.6.0.2-new+++
		CASE $$LVN_ITEMCHANGED, $$TVN_SELCHANGED
			RETURN @binding.onItem (nmhdr.idFrom, nmhdr.code, lParam)
' 0.6.0.2-new~~~
'
		CASE $$LVN_COLUMNCLICK
			IF binding.onColumnClick THEN
				pNmlv = &nmlv		' list view structure
				ULONGAT(&&nmlv) = lParam		' address
				ret = @binding.onColumnClick (nmhdr.idFrom, nmlv.iSubItem)
				ULONGAT(&&nmlv) = pNmlv		' address
			ENDIF
			'
		CASE $$LVN_BEGINLABELEDIT		'  sent as notification
			' the program sent a message LVM_EDITLABEL
			IF binding.onLabelEdit THEN
				pNmlvdi = &nmlvdi
				ULONGAT(&&nmlvdi) = lParam		' address
				'.onLabelEdit (id, edit_const, edit_item, edit_sub_item, newLabel$)
				ret_value = @binding.onLabelEdit (nmlvdi.hdr.idFrom, $$EDIT_START, nmlvdi.item.iItem, "")
				IFZ ret_value THEN
					ret = 1		' handled
				ENDIF
				ULONGAT(&&nmlvdi) = pNmlvdi		' address
			ENDIF
			'
		CASE $$LVN_ENDLABELEDIT
			pNmlvdi = &nmlvdi
			ULONGAT(&&nmlvdi) = lParam		' address
'
' 0.6.0.2-old---
'			ret = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_DONE, nmlvdi.item.iItem, CSTRING$(nmlvdi.item.pszText))
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			newText$ = CSTRING$ (nmlvdi.item.pszText)
			IFZ binding.onLabelEdit THEN
				hLV = GetDlgItem (hWnd, nmlvdi.hdr.idFrom)
				WinXListView_SetItemText (hLV, nmlvdi.item.iItem, nmlvdi.item.iSubItem, newText$)		' update text
			ELSE
				'.onLabelEdit (id, edit_const, edit_item, edit_sub_item, newLabel$)
				ret = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_DONE, nmlvdi.item.iItem, newText$)
			ENDIF
' 0.6.0.2-new~~~
'
			ULONGAT(&&nmlvdi) = pNmlvdi		' address
			'
	END SELECT		' notifyCode

	ULONGAT(&&nmhdr) = pNmhdr		' address
	RETURN ret
END FUNCTION
'
' ########################
' #####  sizeWindow  #####
' ########################
' Resizes a window.
' hWnd = handle to the window to resize
' new_width and new_height = the new width and height
' returns nothing of interest
FUNCTION sizeWindow (hWnd, new_width, new_height)
'
' 0.6.0.2-old---
'	STATIC maxX
' 0.6.0.2-old~~~
'
	BINDING	binding
	SCROLLINFO si
'	WINDOWPLACEMENT WinPla
	RECT rect
	RECT tmpRect

	SetLastError (0)
	ret = 0

	SELECT CASE hWnd
		CASE 0
			'
		CASE ELSE
			'get the binding
			idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
			bOK = binding_get (idBinding, @binding)
			IFF bOK THEN EXIT SELECT		' no window binding yet
			'
			winWidth = new_width
			winHeight = new_height
'
' 0.6.0.2-old---
'			'now handle the bar
'			IF winWidth > maxX THEN
'				SendMessageA (binding.hBar, $$WM_SIZE, wParam, lParam)
'				maxX = new_width
'			ENDIF
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
			' ( binding.minW, binding.minH ) = minimum width and height of the window
			IF binding.minW > 0 THEN
				IF winWidth < binding.minW THEN
					' increase above the minimum width
					winWidth = binding.minW
				ENDIF
			ENDIF
			'
			IF binding.minH > 0 THEN
				IF winHeight < binding.minH THEN
					' increase above the minimum height
					winHeight = binding.minH
				ENDIF
			ENDIF
			'
			menu = GetMenu (hWnd)
			IF menu THEN
				'account for the menubar height
				winHeight = winHeight - GetSystemMetrics ($$SM_CYMENU)		' height of single-line menu
			ENDIF
			'
			IF binding.hBar THEN
				'now handle the toolbar
				' -SendMessageA (binding.hBar, $$WM_SIZE, wParam, lParam)
				GetClientRect (binding.hBar, &rect)
				height = rect.bottom - rect.top
				SendMessageA (binding.hBar, $$WM_SIZE, winWidth, height)
			ENDIF
' 0.6.0.2-new~~~
'
			IF binding.hStatus THEN
				'handle the status bar
				'first, resize the partitions
				DIM parts[binding.statusParts]
				FOR i = 0 TO binding.statusParts
					parts[i] = ((i+1)*winWidth)/(binding.statusParts+1)
				NEXT i
				SendMessageA (binding.hStatus, $$WM_SIZE, wParam, lParam)
				SendMessageA (binding.hStatus, $$SB_SETPARTS, binding.statusParts+1, &parts[0])
			ENDIF

			'and the scroll bars
			xoff = 0
			yoff = 0

			style = GetWindowLongA (hWnd, $$GWL_STYLE)
			SELECT CASE ALL TRUE
				CASE style AND $$WS_HSCROLL
					si.cbSize = SIZE(SCROLLINFO)
					si.fMask = $$SIF_PAGE|$$SIF_DISABLENOSCROLL
					si.nPage = winWidth*binding.hScrollPageM+binding.hScrollPageC
					SetScrollInfo (hWnd, $$SB_HORZ, &si, $$TRUE)
					'
					si.fMask = $$SIF_POS
					GetScrollInfo (hWnd, $$SB_HORZ, &si)
					xoff = si.nPos
				CASE style AND $$WS_VSCROLL
					si.cbSize = SIZE(SCROLLINFO)
					si.fMask = $$SIF_PAGE|$$SIF_DISABLENOSCROLL
					si.nPage = winHeight*binding.vScrollPageM+binding.vScrollPageC
					SetScrollInfo (hWnd, $$SB_VERT, &si, $$TRUE)
					'
					si.fMask = $$SIF_POS
					GetScrollInfo (hWnd, $$SB_VERT, &si)
					yoff = si.nPos
					'
			END SELECT

			IF binding.autoSizerInfo >= 0 THEN
				'use the auto-sizer
				WinXGetUseableRect (hWnd, @rect)
				autoSizerInfo_sizeGroup (binding.autoSizerInfo, rect.left-xoff, rect.top-yoff, rect.right-rect.left, rect.bottom-rect.top)
			ENDIF

			@binding.onScroll(xoff, hWnd, $$DIR_HORIZ)
			@binding.onScroll(yoff, hWnd, $$DIR_VERT)

			ret = 0
			IF binding.dimControls THEN
				ret = @binding.dimControls(hWnd, winWidth, winHeight)
			ENDIF
			'InvalidateRect (hWnd, 0, $$FALSE)

	END SELECT

	RETURN ret
END FUNCTION
'
' #######################
' #####  autoSizer  #####
' #######################
' The auto-sizer function, resizes child windows.
' returns the new current position or 0 on fail
FUNCTION autoSizer (AUTOSIZERINFO	autoSizerBlock, direction, x0, y0, nw, nh, currPos)
	RECT rect
	SPLITTERINFO splitterInfo
	FUNCADDR leftInfo (XLONG, XLONG)
	FUNCADDR rightInfo (XLONG, XLONG)

	IFZ autoSizerBlock.hWnd THEN RETURN 0		' fail
'
' If there is an auto-sizer block here, resize the window.
'
	'calculate the SIZE
	'first, the x, y, w and h of the box

	' clear flag $$DIR_REVERSE of direction
	SELECT CASE direction AND 0x00000003
		CASE $$DIR_VERT
			IF autoSizerBlock.space <= 1 THEN autoSizerBlock.space = autoSizerBlock.space*nh
			'
			IF autoSizerBlock.flags AND $$SIZER_SIZERELREST THEN
				IF direction AND $$DIR_REVERSE THEN rest = currPos ELSE rest = nh-currPos
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size*rest ELSE autoSizerBlock.size = rest-autoSizerBlock.size
				autoSizerBlock.size = autoSizerBlock.size-autoSizerBlock.space
			ELSE
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size*nh
			ENDIF
			'
			IF autoSizerBlock.x <= 1 THEN autoSizerBlock.x = autoSizerBlock.x*nw
			IF autoSizerBlock.y <= 1 THEN autoSizerBlock.y = autoSizerBlock.y*autoSizerBlock.size
			IF autoSizerBlock.w <= 1 THEN autoSizerBlock.w = autoSizerBlock.w*nw
			IF autoSizerBlock.h <= 1 THEN autoSizerBlock.h = autoSizerBlock.h*autoSizerBlock.size
			'
			boxX = x0
			boxY = y0+currPos+autoSizerBlock.space
			boxW = nw
			boxH = autoSizerBlock.size
			'
			IF autoSizerBlock.flags AND $$SIZER_SPLITTER THEN
				boxH = boxH-8
				autoSizerBlock.h = autoSizerBlock.h - 8
				'
				IF direction AND $$DIR_REVERSE THEN h = boxY-boxH-8 ELSE h = boxY+boxH
				MoveWindow (autoSizerBlock.hSplitter, boxX, h, boxW, 8, $$FALSE)
				InvalidateRect (autoSizerBlock.hSplitter, 0, 1)		' erase
				'
				iSplitter = GetWindowLongA (autoSizerBlock.hSplitter, $$GWL_USERDATA)
				SPLITTERINFO_Get (iSplitter, @splitterInfo)
				IF direction AND $$DIR_REVERSE THEN splitterInfo.maxSize = currPos-autoSizerBlock.space ELSE splitterInfo.maxSize = nh-currPos-autoSizerBlock.space
				SPLITTERINFO_Update (iSplitter, splitterInfo)
			ENDIF
			'
			IF direction AND $$DIR_REVERSE THEN boxY = boxY-boxH
			'
		CASE $$DIR_HORIZ
			IF autoSizerBlock.space <= 1 THEN autoSizerBlock.space = autoSizerBlock.space*nw
			'
			IF autoSizerBlock.flags AND $$SIZER_SIZERELREST THEN
				IF direction AND $$DIR_REVERSE THEN rest = currPos ELSE rest = nw-currPos
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size*rest ELSE autoSizerBlock.size = rest-autoSizerBlock.size
				autoSizerBlock.size = autoSizerBlock.size-autoSizerBlock.space
			ELSE
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size*nw
			ENDIF
			'
			IF autoSizerBlock.x <= 1 THEN autoSizerBlock.x = autoSizerBlock.x*autoSizerBlock.size
			IF autoSizerBlock.y <= 1 THEN autoSizerBlock.y = autoSizerBlock.y*nh
			IF autoSizerBlock.w <= 1 THEN autoSizerBlock.w = autoSizerBlock.w*autoSizerBlock.size
			IF autoSizerBlock.h <= 1 THEN autoSizerBlock.h = autoSizerBlock.h*nh
			'
			boxX = x0+currPos+autoSizerBlock.space
			boxY = y0
			boxW = autoSizerBlock.size
			boxH = nh
			'
			IF autoSizerBlock.flags AND $$SIZER_SPLITTER THEN
				boxW = boxW-8
				autoSizerBlock.w = autoSizerBlock.w - 8
				'
				IF direction AND $$DIR_REVERSE THEN h = boxX-boxW-8 ELSE h = boxX+boxW
				MoveWindow (autoSizerBlock.hSplitter, h, boxY, 8, boxH, $$FALSE)
				InvalidateRect (autoSizerBlock.hSplitter, 0, 1)		' erase
				'
				iSplitter = GetWindowLongA (autoSizerBlock.hSplitter, $$GWL_USERDATA)
				SPLITTERINFO_Get (iSplitter, @splitterInfo)
				IF direction AND $$DIR_REVERSE THEN splitterInfo.maxSize = currPos-autoSizerBlock.space ELSE splitterInfo.maxSize = nw-currPos-autoSizerBlock.space
				SPLITTERINFO_Update (iSplitter, splitterInfo)
			ENDIF
			'
			IF direction AND $$DIR_REVERSE THEN boxX = boxX-boxW
			'
	END SELECT

	'adjust the width and height as necessary
	IF autoSizerBlock.flags AND $$SIZER_WCOMPLEMENT THEN autoSizerBlock.w = boxW-autoSizerBlock.w
	IF autoSizerBlock.flags AND $$SIZER_HCOMPLEMENT THEN autoSizerBlock.h = boxH-autoSizerBlock.h

	'adjust x and y
	IF autoSizerBlock.x < 0 THEN
		autoSizerBlock.x = (boxW-autoSizerBlock.w)\2
	ELSE
		IF autoSizerBlock.flags AND $$SIZER_XRELRIGHT THEN autoSizerBlock.x = boxW-autoSizerBlock.x
	ENDIF
	IF autoSizerBlock.y < 0 THEN
		autoSizerBlock.y = (boxH-autoSizerBlock.h)\2
	ELSE
		IF autoSizerBlock.flags AND $$SIZER_YRELBOTTOM THEN autoSizerBlock.y = boxH-autoSizerBlock.y
	ENDIF

	IF autoSizerBlock.flags AND $$SIZER_SERIES THEN
		autoSizerInfo_sizeGroup (autoSizerBlock.hWnd, autoSizerBlock.x+boxX, autoSizerBlock.y+boxY, autoSizerBlock.w, autoSizerBlock.h)
	ELSE
		' Actually size the control
		IF (autoSizerBlock.w<1) || (autoSizerBlock.h<1) THEN
			ShowWindow (autoSizerBlock.hWnd, $$SW_HIDE)
		ELSE
			ShowWindow (autoSizerBlock.hWnd, $$SW_SHOW)
			MoveWindow (autoSizerBlock.hWnd, autoSizerBlock.x+boxX, autoSizerBlock.y+boxY, autoSizerBlock.w, autoSizerBlock.h, $$TRUE)
		ENDIF

		leftInfo = GetPropA (autoSizerBlock.hWnd, &$$LeftSubSizer$)
		rightInfo = GetPropA (autoSizerBlock.hWnd, &$$RightSubSizer$)
		IF leftInfo THEN
			series = @leftInfo(autoSizerBlock.hWnd, &rect)
			autoSizerInfo_sizeGroup (series, autoSizerBlock.x+boxX+rect.left, autoSizerBlock.y+boxY+rect.top, (rect.right-rect.left), (rect.bottom-rect.top))
		ENDIF
		IF rightInfo THEN
			series = @rightInfo(autoSizerBlock.hWnd, &rect)
			autoSizerInfo_sizeGroup (series, autoSizerBlock.x+boxX+rect.left, _
			autoSizerBlock.y+boxY+rect.top, (rect.right-rect.left), (rect.bottom-rect.top))
		ENDIF
	ENDIF

	IF direction AND $$DIR_REVERSE THEN
		currPosNew = currPos-autoSizerBlock.space-autoSizerBlock.size
	ELSE
		currPosNew = currPos+autoSizerBlock.space+autoSizerBlock.size
	ENDIF
	RETURN currPosNew

END FUNCTION
'
' ######################
' #####  XWSStoWS  #####
' ######################
' Convert a simplified window style to a window style
' xwss = the simplified style
' returns a ws.
FUNCTION XWSStoWS (xwss)
	ret = 0
	SELECT CASE xwss
		CASE $$XWSS_APP
			ret = $$WS_OVERLAPPEDWINDOW
		CASE $$XWSS_APPNORESIZE
			ret =$$WS_OVERLAPPED|$$WS_CAPTION|$$WS_SYSMENU|$$WS_MINIMIZEBOX
		CASE $$XWSS_POPUP
			ret = $$WS_POPUPWINDOW|$$WS_CAPTION
		CASE $$XWSS_POPUPNOTITLE
			ret = $$WS_POPUPWINDOW
		CASE $$XWSS_NOBORDER
			ret = $$WS_POPUP
	END SELECT
	RETURN ret
END FUNCTION
'
' ##############################
' #####  cancelDlgOnClose  #####
' ##############################
' The onClose callback function for the cancel printing dialog box.
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
' The onCommand callback function for the cancel printing dialog box.
FUNCTION cancelDlgOnCommand (id, code, hWnd)
	SHARED	PRINTINFO	printInfo

	SetLastError (0)
	IFZ printInfo.hCancelDlg THEN RETURN 0		' fail
	SELECT CASE id
		CASE $$IDCANCEL		' cancel button
			SendMessageA (printInfo.hCancelDlg, $$WM_CLOSE, 0, 0)
			RETURN 1		' success
	END SELECT
END FUNCTION
'
' ############################
' #####  printAbortProc  #####
' ############################
' Abort proc for printing.
' (hDC, nCode are unused!)
FUNCTION printAbortProc (hDC, nCode)
	SHARED	PRINTINFO	printInfo
	MSG msg

	SetLastError (0)
	IFZ printInfo.hCancelDlg THEN RETURN 0		' fail

	' Check to see if any messages are waiting in the queue
	DO WHILE PeekMessageA (&msg, 0, 0, 0, $$PM_REMOVE)
		IFZ IsDialogMessageA (printInfo.hCancelDlg, &msg) THEN
			' Translate the message and dispatch it to WindowProc()
			TranslateMessage (&msg)
			DispatchMessageA (&msg)
		ENDIF
'
' 0.6.0.2-new+++
		' If the message is WM_QUIT, exit the WHILE loop
		IF msg.message = $$WM_QUIT THEN EXIT DO
' 0.6.0.2-new~~~
'
	LOOP

	RETURN printInfo.continuePrinting
END FUNCTION
'
' Window/Dialog Binding
' =====================
'
' #########################
' #####  binding_add  #####
' #########################
' Add a binding to the binding table.
' binding = the binding to add
' returns the id of the binding
FUNCTION binding_add (BINDING binding)
	SHARED		BINDING	bindings[]

	'look for a blank slot
	slot = -1		' not an index
	upper_slot = UBOUND(bindings[])
	FOR i = 0 TO upper_slot
		IFZ bindings[i].hWnd THEN
			' must be inactive for reuse
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	'allocate more memory if needed
	IF slot < 0 THEN
		slot = upper_slot + 1
'
' 0.6.0.2-old---
'		upper_slot = slot + slot + 1		' generous re-allocation!
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
		' Just a few bindings => add them one by one with no fuzz
		upper_slot = slot
' 0.6.0.2-new~~~
'
		REDIM bindings[upper_slot]
	ENDIF

	'set the binding
	bindings[slot] = binding
'
' debug+++
	IFZ bindings[slot].hWnd THEN
		msg$ = "binding_add: Warning - the window handle is null"
		WinXDialog_Error (msg$, "WinX-Debug", 2)
	ENDIF
' debug~~~
'
	RETURN (slot + 1)		' return an id
END FUNCTION
'
' ############################
' #####  binding_delete  #####
' ############################
' Deletes a binding from the binding table.
' id = the id of the binding to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION binding_delete (id)
	SHARED		BINDING	bindings[]
	LINKEDLIST list

	DEC id

	IF id < 0 || id > UBOUND(bindings[]) THEN RETURN $$FALSE		' fail
	IFZ bindings[id].hWnd THEN RETURN $$FALSE		' fail

	'delete the auto-draw info
	autoDraw_clear (bindings[id].autoDrawInfo)
	LINKEDLIST_Get (bindings[id].autoDrawInfo, @list)
	LinkedList_Uninit (@list)
	LINKEDLIST_Delete (bindings[id].autoDrawInfo)

	'delete the message handlers
	handler_deleteGroup (bindings[id].msgHandlers)

	'delete the auto-sizer info
	autoSizerInfo_deleteGroup (bindings[id].autoSizerInfo)

	bindings[id].hWnd = 0
	RETURN $$TRUE		' success
END FUNCTION
'
' #########################
' #####  binding_get  #####
' #########################
' Retrieves a binding.
' id        = the id of the binding to get
' r_binding = the variable to store the binding
' returns $$TRUE on success or $$FALSE on fail
FUNCTION binding_get (id, BINDING r_binding)
	SHARED		BINDING	bindings[]
	BINDING null_item
	DEC id

	r_binding = null_item		' reset returned binding
	IF id < 0 || id > UBOUND(bindings[]) THEN RETURN $$FALSE		' fail
	IFZ bindings[id].hWnd THEN RETURN $$FALSE		' fail

	r_binding = bindings[id]
	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  binding_update  #####
' ############################
' Updates a binding.
' id      = the id of the binding to update
' binding = the new version of the binding
' returns $$TRUE on success or $$FALSE on fail
FUNCTION binding_update (id, BINDING binding)
	SHARED		BINDING	bindings[]

	bOK = $$FALSE
	slot = id - 1
	SELECT CASE TRUE
		CASE slot >= 0 && slot <= UBOUND (bindings[])
			IFZ bindings[slot].hWnd THEN
				msg$ = "binding_update: Warning - the window handle is null"
				WinXDialog_Error (msg$, "WinX-Debug", 0)
			ENDIF
			bindings[slot] = binding
			bOK = $$TRUE		' success
			'
	END SELECT
	RETURN bOK

END FUNCTION
'
' #########################
' #####  handler_add  #####
' #########################
' Adds a new handler to a group.
' group   = the index of the group to add the handler to
' handler = the handler to add
' returns the index of the new handler or -1 on fail
FUNCTION handler_add (group, MSGHANDLER handler)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		SBYTE handlersUM[]	'a usage map so we can see which groups are in use
	MSGHANDLER	local_group[]	'a local version of the group

	'bounds checking
	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN -1
'
' 0.6.0.1-old---
'	IF handlersUM THEN RETURN -1
' 0.6.0.1-old~~~
' 0.6.0.1-new+++
	IFF handlersUM[group] THEN RETURN -1		' inactive
' 0.6.0.1-new~~~
'
	'find a free slot
	slot = -1		' not an index
	upper_slot = UBOUND(handlers[group,])
	FOR i = 0 TO upper_slot
		IFZ handlers[group,i].msg THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	IF slot < 0 THEN
		'allocate more memory
		slot = upper_slot + 1
		upper_slot = slot + slot + 1		' generous re-allocation!
		SWAP local_group[], handlers[group,]
		REDIM local_group[upper_slot]
		SWAP local_group[], handlers[group,]
	ENDIF

	'now finish it off
	handlers[group,slot] = handler
	RETURN slot
END FUNCTION
'
' #########################
' #####  handler_get  #####
' #########################
' Retrieve a handler from the handler array.
' group and id are the group and id of the handler to retreive
' handler = the variable to store the handler
' returns $$TRUE on success or $$FALSE on fail
FUNCTION handler_get (group, id, MSGHANDLER handler)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers

	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(handlers[group,]) THEN RETURN $$FALSE
	IFZ handlers[group,id].msg THEN RETURN $$FALSE

	handler = handlers[group, id]
	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  handler_update  #####
' ############################
' Updates an existing handler
' group and id are the group and id of the handler to update
' handler is the new version of the handler
' returns $$TRUE on success or $$FALSE on fail
FUNCTION handler_update (group, id, MSGHANDLER handler)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers

	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(handlers[group,]) THEN RETURN $$FALSE
	IFZ handlers[group,id].msg THEN RETURN $$FALSE

	handlers[group, id] = handler
	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  handler_delete  #####
' ############################
' Delete a single handler
' group and id = the group and id of the handler to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION handler_delete (group, id)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers

	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(handlers[group,]) THEN RETURN $$FALSE
	IF handlers[group,id].msg = 0 THEN RETURN $$FALSE

	handlers[group, id].msg = 0
	RETURN $$TRUE		' success
END FUNCTION
'
' ##########################
' #####  handler_call  #####
' ##########################
' Calls the handler for a specified message.
' group = the index of the group to call from
' ret   = the variable to hold the message return value
' hwnd, msg, wParam, lParam = the usual definitions for these parameters
' returns $$TRUE on success or $$FALSE on fail
FUNCTION handler_call (group, ret, hWnd, msg, wParam, lParam)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers

	'first, find the handler
	id = handler_find (group, msg)

	IF id < 0 THEN RETURN $$FALSE

	'then call it
	ret = @handlers[group, id].handler(hWnd, msg, wParam, lParam)

	RETURN $$TRUE		' success
END FUNCTION
'
' ##########################
' #####  handler_find  #####
' ##########################
' Locates a handler in the handler array.
' group = the index of the group to search
' wMsg  = the message to search for
' returns the id of the message handler, -1 if it fails
'  to find anything and -2 if there is a bounds error
FUNCTION handler_find (group, wMsg)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers

	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN -2

	i = 0
	iMax = UBOUND(handlers[group,])
	IF i > iMax THEN RETURN -1
	DO UNTIL handlers[group,i].msg = wMsg
		INC i
		IF i > iMax THEN RETURN -1
	LOOP

	RETURN i
END FUNCTION
'
' ##############################
' #####  handler_addGroup  #####
' ##############################
' Adds a new group of message handlers.
' returns the id of the group or 0 on fail
FUNCTION handler_addGroup ()
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		SBYTE handlersUM[]	'a usage map so we can see which groups are in use

	'find a free slot
	slot = -1		' not an index
	upper_slot = UBOUND(handlersUM[])
	FOR i = 0 TO upper_slot
		IFZ handlersUM[i] THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	'allocate more memory if needed
	IF slot < 0 THEN
		slot = upper_slot + 1
		upper_slot = slot + slot + 1		' generous re-allocation!
		REDIM handlersUM[upper_slot]
		REDIM handlers[upper_slot,]
	ENDIF

	handlersUM[slot] = $$TRUE

'	???RETURN slot
	RETURN (slot + 1)		' return an id

END FUNCTION
'
' #################################
' #####  handler_deleteGroup  #####
' #################################
' Deletes a group of message handlers.
' group = the index of the group to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION handler_deleteGroup (group)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		SBYTE handlersUM[]	'a usage map so we can see which groups are in use
	MSGHANDLER	null_item[]	'a local version of the group

	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN $$FALSE		' fail
	IF UBOUND(handlers[group,]) < 0 THEN RETURN $$FALSE		' fail
'
' Delete group.
'
	handlersUM[group] = $$FALSE

	DIM  null_item[]
	SWAP null_item[], handlers[group,]

	RETURN $$TRUE		' success
END FUNCTION
'
' ###############################
' #####  autoSizerInfo_add  #####
' ###############################
' Adds a new auto-sizer block.
' group          = the index of the group
' autoSizerBlock = the auto-sizer block to add
' returns the index of the auto-sizer block or -1 on fail
FUNCTION autoSizerInfo_add (group, AUTOSIZERINFO autoSizerBlock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	AUTOSIZERINFO local_group[]	'a local version of the group

	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN -1
	IFF autoSizerInfoUM[group].inUse THEN RETURN -1

	'find a free slot
	slot = -1
	upper_slot = UBOUND(autoSizerInfo[group,])
	FOR i = 0 TO upper_slot
		IFZ autoSizerInfo[group,i].hWnd THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	IF slot < 0 THEN
		'allocate more memory
		slot = upper_slot + 1
		upper_slot = slot + slot + 1		' generous re-allocation!
		DIM  local_group[]
		SWAP local_group[], autoSizerInfo[group,]
		REDIM local_group[upper_slot]
		SWAP local_group[], autoSizerInfo[group,]
	ENDIF

	autoSizerInfo[group, slot] = autoSizerBlock

	autoSizerInfo[group, slot].nextItem = -1

	IF autoSizerInfoUM[group].iTail < 0 THEN
		'Make this the first item
		autoSizerInfoUM[group].iHead = slot
		autoSizerInfoUM[group].iTail = slot
		autoSizerInfo[group,slot].prevItem = -1
	ELSE
		'add to the end of the list
		autoSizerInfo[group,slot].prevItem = autoSizerInfoUM[group].iTail
		autoSizerInfo[group, autoSizerInfoUM[group].iTail].nextItem = slot
		autoSizerInfoUM[group].iTail = slot
	ENDIF

	RETURN slot
END FUNCTION
'
' ##################################
' #####  autoSizerInfo_delete  #####
' ##################################
' Deletes an auto-sizer block.
' group = the index of the group
' id    = the index of the auto-sizer block to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_delete (group, id)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[group].inUse THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(autoSizerInfo[group,]) THEN RETURN $$FALSE
	IFZ autoSizerInfo[group, id].hWnd THEN RETURN $$FALSE

	autoSizerInfo[group, id].hWnd = 0

	IF id = autoSizerInfoUM[group].iHead THEN
		autoSizerInfoUM[group].iHead = autoSizerInfo[group, id].nextItem
		autoSizerInfo[group, autoSizerInfo[group, id].nextItem].prevItem = -1
		IF autoSizerInfoUM[group].iHead < 0 THEN autoSizerInfoUM[group].iTail = -1
	ELSE
		IF id = autoSizerInfoUM[group].iTail THEN
			autoSizerInfo[group, autoSizerInfoUM[group].iTail].nextItem = -1
			autoSizerInfoUM[group].iTail = autoSizerInfo[group, id].prevItem
			IF autoSizerInfoUM[group].iTail < 0 THEN autoSizerInfoUM[group].iHead = -1
		ELSE
			autoSizerInfo[group, autoSizerInfo[group,id].nextItem].prevItem = autoSizerInfo[group,id].prevItem
			autoSizerInfo[group, autoSizerInfo[group,id].prevItem].nextItem = autoSizerInfo[group,id].nextItem
		ENDIF
	ENDIF

	RETURN $$TRUE		' success
END FUNCTION
'
' ###############################
' #####  autoSizerInfo_get  #####
' ###############################
' Gets an auto-sizer block.
' group          = the index of the group
' id             = the id of the record to get
' autoSizerBlock = the variable to store the record
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_get (group, id, AUTOSIZERINFO autoSizerBlock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[group].inUse THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(autoSizerInfo[group,]) THEN RETURN $$FALSE
	IFZ autoSizerInfo[group,id].hWnd THEN RETURN $$FALSE

	autoSizerBlock = autoSizerInfo[group, id]
	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  autoSizerInfo_update  #####
' ##################################
' Updates an auto-sizer block.
' group          = the index of the group
' id             = the block to update
' autoSizerBlock = the new version of the info record
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_update (group, id, AUTOSIZERINFO autoSizerBlock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[group].inUse THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(autoSizerInfo[group,]) THEN RETURN $$FALSE
	IFZ autoSizerInfo[group,id].hWnd THEN RETURN $$FALSE

	autoSizerInfo[group,id] = autoSizerBlock
	RETURN $$TRUE		' success
END FUNCTION
'
' ####################################
' #####  autoSizerInfo_addGroup  #####
' ####################################
' Adds a new group of auto-sizer blocks.
' direction = $$DIR_VERT for WM_VSCROLL, $$DIR_HORIZ for WM_HSCROLL, OR'ed with $$DIR_REVERSE for reverse
' returns the index of the new group or -1 on fail
FUNCTION autoSizerInfo_addGroup (direction)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	AUTOSIZERINFO local_group[]

	'find a free slot
	slot = -1		' not an index
	upper_slot = UBOUND(autoSizerInfoUM[])
	FOR i = 0 TO upper_slot
		IFF autoSizerInfoUM[i].inUse THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	IF slot < 0 THEN
		'allocate more memory
		slot = upper_slot + 1
		upper_slot = slot + slot + 1		' generous re-allocation!
		REDIM autoSizerInfoUM[upper_slot]
		REDIM autoSizerInfo[upper_slot,]
	ENDIF

	autoSizerInfoUM[slot].inUse = $$TRUE
	autoSizerInfoUM[slot].direction = direction
	autoSizerInfoUM[slot].iHead = -1
	autoSizerInfoUM[slot].iTail = -1

	DIM  local_group[7]		' generous allocation!
	SWAP local_group[], autoSizerInfo[slot,]

	RETURN slot
END FUNCTION
'
' #######################################
' #####  autoSizerInfo_deleteGroup  #####
' #######################################
' Deletes a group of auto-sizer blocks.
' group = the index of the group to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_deleteGroup (group)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	AUTOSIZERINFO null_item[]

	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
'
' Reset autoSizerInfo[group,].
'
	autoSizerInfoUM[group].inUse = $$FALSE

	DIM  null_item[]
	SWAP null_item[], autoSizerInfo[group,]

	RETURN $$TRUE		' success
END FUNCTION
'
' #####################################
' #####  autoSizerInfo_sizeGroup  #####
' #####################################
' Automatically resizes all the controls in an auto-sizer group.
' group      = the index of the group to resize
' new_width  = the new width of the parent window
' new_height = the new height of the parent window
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_sizeGroup (group, x0, y0, new_width, new_height)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[group].inUse THEN RETURN $$FALSE

	IF autoSizerInfoUM[group].direction AND $$DIR_REVERSE THEN
		SELECT CASE autoSizerInfoUM[group].direction AND 0x00000003
			CASE $$DIR_HORIZ
				currPos = new_width
			CASE $$DIR_VERT
				currPos = new_height
		END SELECT
	ELSE
		currPos = 0
	ENDIF

	#hWinPosInfo = BeginDeferWindowPos (10)
	i = autoSizerInfoUM[group].iHead
	DO WHILE i > -1
		IF autoSizerInfo[group, i].hWnd THEN
			currPos = autoSizer (autoSizerInfo[group,i], autoSizerInfoUM[group].direction, x0, y0, new_width, new_height, currPos)
		ENDIF

		i = autoSizerInfo[group, i].nextItem
	LOOP
	EndDeferWindowPos (#hWinPosInfo)

	RETURN $$TRUE		' success
END FUNCTION
'
' #####################################
' #####  autoSizerInfo_showGroup  #####
' #####################################
' Hides or shows an auto-sizer group.
' group = the index of the group to hide or show
' visible = $$TRUE to make the group visible, $$FALSE to hide them
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_showGroup (group, visible)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[group].inUse THEN RETURN $$FALSE

	IF visible THEN command = $$SW_SHOWNA ELSE command = $$SW_HIDE

	i = autoSizerInfoUM[group].iHead
	DO WHILE i > -1
		IF autoSizerInfo[group, i].hWnd THEN
			ShowWindow (autoSizerInfo[group, i].hWnd, command)
		ENDIF

		i = autoSizerInfo[group, i].nextItem
	LOOP

	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  autoDraw_clear  #####
' ############################
' Clears out all the auto-draw records in a group.
' group = the index of the group to clear
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoDraw_clear (group)
	LINKEDLIST list
	AUTODRAWRECORD record

	IF group < 0 THEN RETURN $$FALSE		' fail

	IFF LINKEDLIST_Get (group, @list) THEN RETURN $$FALSE
	hWalk = LinkedList_StartWalk (list)
	DO WHILE LinkedList_Walk (hWalk, @iData)
		AUTODRAWRECORD_Get (iData, @record)
		IF record.draw = &drawText() THEN STRING_Delete (record.text.iString)
		DeleteObject(record.hUpdateRegion)
		AUTODRAWRECORD_Delete (iData)
	LOOP
	LinkedList_EndWalk (hWalk)
	LinkedList_DeleteAll (@list)

	LINKEDLIST_Update (group, list)

	RETURN $$TRUE		' success
END FUNCTION
'
' ###########################
' #####  autoDraw_draw  #####
' ###########################
' Draws a group of auto-draw records.
' hDC = the dc to draw to
' group = the index of the group of records to draw
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoDraw_draw (hDC, group, x0, y0)
	LINKEDLIST autoDraw
	AUTODRAWRECORD record

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hDC
		CASE 0
			'
		CASE ELSE
			IFF LINKEDLIST_Get (group, @autoDraw) THEN EXIT SELECT
			'
			hPen = 0
			hBrush = 0
			hFont = 0
			'
			hWalk = LinkedList_StartWalk (autoDraw)
			DO WHILE LinkedList_Walk (hWalk, @iData)
				AUTODRAWRECORD_Get (iData, @record)
				'
				SELECT CASE record.hPen
					CASE 0, hPen
						'
					CASE ELSE
						'IF record.hPen <> 0 && record.hPen <> hPen THEN
						hPen = record.hPen
						SelectObject (hDC, hPen)
				END SELECT
				'
				SELECT CASE record.hBrush
					CASE 0, hBrush
						'
					CASE ELSE
						' IF record.hBrush != 0 && record.hBrush != hBrush THEN
						hBrush = record.hBrush
						SelectObject (hDC, hBrush)
				END SELECT
				'
				SELECT CASE record.hFont
					CASE 0, hFont
						'
					CASE ELSE
						'IF record.hFont != 0 && record.hFont != hFont THEN
						hFont = record.hFont
						SelectObject (hDC, hFont)
				END SELECT
				'
				IF record.toDelete THEN
'
' GL-31oct19-Note+++
' WinXClear is supposed to clear all the graphics in a window;
' code for "erase previously displayed text" missing here?
' (see my note in text.x demo)
' GL-31oct19-Note~~~
'
					AUTODRAWRECORD_Delete (iData)
					LinkedList_DeleteThis (hWalk, @autoDraw)
				ELSE
					@record.draw (hDC, record, x0, y0)
				ENDIF
			LOOP
			LinkedList_EndWalk (hWalk)
			'
			bOK = $$TRUE		' success
			'
	END SELECT

	RETURN bOK

END FUNCTION
'
' ##########################
' #####  autoDraw_add  #####
' ##########################
' Appends an item to the auto-draw linked list.
' iList  = the linked list to append to
' idDraw = the data to append to the linked list
' returns an index to the linked list on success or -1 on fail
FUNCTION autoDraw_add (iList, idDraw)
	LINKEDLIST autoDraw

	linked_list_index = -1		' not an index

	' get the auto-draw item
	bOK = LINKEDLIST_Get (iList, @autoDraw)
	IFF bOK THEN RETURN -1		' fail

	LinkedList_Append (@autoDraw, idDraw)

	bOK = LINKEDLIST_Update (iList, autoDraw)
	IFF bOK THEN RETURN -1		' fail

	IF autoDraw.cItems > 0 THEN
		' index to the linked list
		linked_list_index = autoDraw.cItems - 1
	ELSE
		linked_list_index = -1
	ENDIF
	RETURN linked_list_index
END FUNCTION
'
' ###########################
' #####  initPrintInfo  #####
' ###########################
FUNCTION initPrintInfo ()
	SHARED	PRINTINFO	printInfo
	PAGESETUPDLG pageSetupDlg

	'pageSetupDlg.lStructSize = SIZE(PAGESETUPDLG)
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
END FUNCTION
'
' Auto-Draw Records
DefineAccess(AUTODRAWRECORD)
'
' Generic Linked List
DefineAccess(LINKEDLIST)
'
' WinX's Splitter
DefineAccess(SPLITTERINFO)
'
' ######################
' #####  drawLine  #####
' ######################
' Draws a line.
' hDC = the dc to draw the line on
' record = the record containing info for the line
FUNCTION drawLine (hDC, AUTODRAWRECORD record, x0, y0)
	SetLastError (0)
	IFZ hDC THEN RETURN $$FALSE		' fail
	MoveToEx (hDC, record.rect.x1-x0, record.rect.y1-y0, 0)
	LineTo (hDC, record.rect.x2-x0, record.rect.y2-y0)
	RETURN $$TRUE		' success
END FUNCTION
'
' #########################
' #####  drawEllipse  #####
' #########################
' Draws an ellipse.
' hDC = the dc to draw on
' record = the draw record
FUNCTION drawEllipse (hDC, AUTODRAWRECORD record, x0, y0)
	SetLastError (0)
	IFZ hDC THEN RETURN $$FALSE		' fail
	Ellipse (hDC, record.rect.x1-x0, record.rect.y1-y0, record.rect.x2-x0, record.rect.y2-y0)
	RETURN $$TRUE		' success
END FUNCTION
'
' ######################
' #####  drawRect  #####
' ######################
' draws a rectangle.
' hDC = the dc to draw on
' record = the draw record
FUNCTION drawRect (hDC, AUTODRAWRECORD record, x0, y0)
	SetLastError (0)
	IFZ hDC THEN RETURN $$FALSE		' fail
	x = record.rect.x1-x0
	y = record.rect.y1-y0
	w = record.rect.x2-x0
	h = record.rect.y2-y0
	Rectangle (hDC, x, y, w, h)
	RETURN $$TRUE		' success
END FUNCTION
'
' ###############################
' #####  drawEllipseNoFill  #####
' ###############################
FUNCTION drawEllipseNoFill (hDC, AUTODRAWRECORD record, x0, y0)
	SetLastError (0)
	IFZ hDC THEN RETURN $$FALSE		' fail
	xMid = (record.rect.x1+record.rect.x2)\2-x0
	y1py0 = record.rect.y1-y0
	Arc (hDC, record.rect.x1-x0, y1py0, record.rect.x2-x0, record.rect.y2-y0, xMid, y1py0, xMid, y1py0)
	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  drawRectNoFill  #####
' ############################
FUNCTION drawRectNoFill (hDC, AUTODRAWRECORD record, x0, y0)
	POINT pt[]

	SetLastError (0)
	IFZ hDC THEN RETURN $$FALSE		' fail

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

	Polyline (hDC, &pt[0], 5)
	RETURN $$TRUE		' success
END FUNCTION
'
' #####################
' #####  drawArc  #####
' #####################
FUNCTION drawArc (hDC, AUTODRAWRECORD record, x0, y0)
	SetLastError (0)
	IFZ hDC THEN RETURN $$FALSE		' fail
	Arc (hDC, record.rectControl.x1-x0, record.rectControl.y1-y0, record.rectControl.x2-x0, _
	record.rectControl.y2-y0, record.rectControl.xC1-x0, record.rectControl.yC1-y0, _
	record.rectControl.xC2-x0, record.rectControl.yC2-y0)
	RETURN $$TRUE		' success
END FUNCTION
'
' ######################
' #####  drawFill  #####
' ######################
FUNCTION drawFill (hDC, AUTODRAWRECORD record, x0, y0)
	SetLastError (0)
	IFZ hDC THEN RETURN $$FALSE		' fail
	ExtFloodFill (hDC, record.simpleFill.x-x0, record.simpleFill.y-y0, record.simpleFill.col, $$FLOODFILLBORDER)
	RETURN $$TRUE		' success
END FUNCTION
'
' ########################
' #####  drawBezier  #####
' ########################
FUNCTION drawBezier (hDC, AUTODRAWRECORD record, x0, y0)
	POINT pt[]

	SetLastError (0)
	IFZ hDC THEN RETURN $$FALSE		' fail

	DIM pt[3]
	pt[0].x = record.rectControl.x1  -x0
	pt[0].y = record.rectControl.y1  -y0
	pt[1].x = record.rectControl.xC1 -x0
	pt[1].y = record.rectControl.yC1 -y0
	pt[2].x = record.rectControl.xC2 -x0
	pt[2].y = record.rectControl.yC2 -y0
	pt[3].x = record.rectControl.x2  -x0
	pt[3].y = record.rectControl.y2  -y0

	PolyBezier (hDC, &pt[0], 4)
	RETURN $$TRUE		' success

END FUNCTION
'
' ######################
' #####  drawText  #####
' ######################
' Draws a text string
FUNCTION drawText (hDC, AUTODRAWRECORD record, x0, y0)

	SetLastError (0)
	IFZ hDC THEN RETURN $$FALSE		' fail

	SetTextColor (hDC, record.text.forColor)
	IF record.text.backColor = -1 THEN
		' codeRGB == -1 => $$TRANSPARENT
		SetBkMode (hDC, $$TRANSPARENT)
	ELSE
		SetBkMode (hDC, $$OPAQUE)
		SetBkColor (hDC, record.text.backColor)
	ENDIF
	STRING_Get (record.text.iString, @stri$)
	ExtTextOutA (hDC, record.text.x-x0, record.text.y-y0, options, 0, &stri$, LEN(stri$), 0)
	RETURN $$TRUE		' success
END FUNCTION
'
' #######################
' #####  drawImage  #####
' #######################
' Draws an image.
FUNCTION drawImage (hDC, AUTODRAWRECORD record, x0, y0)
	BLENDFUNCTION blfn

	SetLastError (0)
	IFZ hDC THEN RETURN $$FALSE		' fail

	hdcSrc = CreateCompatibleDC (0)
	hOld = SelectObject (hdcSrc, record.image.hImage)
	IF record.image.blend THEN
		blfn.BlendOp = $$AC_SRC_OVER
		blfn.SourceConstantAlpha = 255
		blfn.AlphaFormat = $$AC_SRC_ALPHA
		'AlphaBlend is misdefined in headers, so call it through a wrapper
		ApiAlphaBlend (hDC, record.image.x-x0, record.image.y-y0, record.image.w, record.image.h, hdcSrc, _
		record.image.xSrc, record.image.ySrc, record.image.w, record.image.h, blfn)
	ELSE
		BitBlt (hDC, record.image.x-x0, record.image.y-y0, record.image.w, record.image.h, hdcSrc, _
		record.image.xSrc, record.image.ySrc, $$SRCCOPY)
	ENDIF
	SelectObject (hdcSrc, hOld)
	RETURN $$TRUE		' success
END FUNCTION
'
' ###############################
' #####  sizeTabsContents  #####
' ###############################
' Resizes a tabstrip.
' hTabs = tabs control
' pRect = pointer to a RECT structure
' returns the auto-sizer series or -1 on fail
FUNCTION sizeTabsContents (hTabs, pRect)

	SetLastError (0)
	IFZ hTabs THEN RETURN -1		' fail
	IFZ pRect THEN RETURN -1		' fail

	ret = GetClientRect (hTabs, pRect)
	IFZ ret THEN RETURN -1		' fail

	SetLastError (0)
	SendMessageA (hTabs, $$TCM_ADJUSTRECT, 0, pRect)
	series = WinXTabs_GetAutosizerSeries (hTabs, WinXTabs_GetCurrentTab (hTabs))
	IF series < 0 THEN RETURN -1		' fail
	RETURN series		' success
END FUNCTION
'
' ##################################
' #####  sizeGroupBoxContents  #####
' ##################################
' Gets the viewable area for a group box.
' returns the auto-sizer series or -1 on fail
FUNCTION sizeGroupBoxContents (hGB, pRect)
	RECT rect

	SetLastError (0)
	IFZ hGB THEN RETURN -1		' fail

	aRect = &rect
	XLONGAT(&&rect) = pRect

	ret = GetClientRect (hGB, &rect)
	IFZ ret THEN RETURN -1		' fail

	rect.left = rect.left+4
	rect.right = rect.right-4
	rect.top = rect.top+16
	rect.bottom = rect.bottom-4

	XLONGAT(&&rect) = aRect

	SetLastError (0)
	group_series = GetPropA (hGB, &$$AutoSizer$)
	IF group_series < 1 THEN RETURN -1		' fail
	RETURN group_series		' success
END FUNCTION
'
' ############################
' #####  CompareLVItems  #####
' ############################
' Compares two listview items.
FUNCTION CompareLVItems (item1, item2, hLV)
'	SHARED #lvs_column_index
'	SHARED #lvs_decreasing

	LV_ITEM lvi		' listview item

	SetLastError (0)
	IFZ hLV THEN RETURN 0		' fail
'
' first item
'
	index = iItem1
	GOSUB GetItemText
	a$ = CSTRING$(&szBuf$)
'
' second item
'
	index = iItem2
	GOSUB GetItemText
	b$ = CSTRING$(&szBuf$)
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
	lvi.cchTextMax = 4095
	szBuf$ = NULL$ (lvi.cchTextMax)		' NULL$() add a nul-terminateur
	lvi.pszText = &szBuf$
	lvi.iItem = item1
	lvi.iSubItem = #lvs_column_index & 0x7FFFFFFF

	SetLastError (0)
	ret = SendMessageA (hLV, $$LVM_GETITEM, index, &lvi)
	IFZ ret THEN
		msg$ = "CompareLVItems: Can't get the data of listview item"
		GuiTellApiError (msg$)
	ENDIF

END SUB

END FUNCTION
'
' ##########################
' #####  WinXDrawLine  #####
' ##########################
' Draws a line.
' hWnd = the handle to the window to draw to
' hPen = a handle to a pen to draw the line with
' x1, y1, x2, y2 = the coordinates of the line
' returns the id of the line
FUNCTION WinXDrawLine (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

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
	bOK = binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw
END FUNCTION
'
' #######################
' #####  WinXClear  #####
' #######################
' Clears all the graphics in a window.
' hWnd = the handle to the window to clear
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClear (hWnd)
	BINDING			binding
	RECT rect

	SetLastError (0)
	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	SetLastError (0)
	ret = GetClientRect (hWnd, &rect)
	IFZ ret THEN RETURN $$FALSE		' fail

	'create a rectangular region
	binding.hUpdateRegion = CreateRectRgn (0, 0, rect.right+2, rect.bottom+2)

	bOK = binding_update (idBinding, binding)
	IFF bOK THEN RETURN $$FALSE		' fail

	bOK = autoDraw_clear (binding.autoDrawInfo)

	' rectangular region no longer needed
	DeleteObject (binding.hUpdateRegion)
	binding.hUpdateRegion = 0

	binding_update (idBinding, binding)

	IFF bOK THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success

END FUNCTION
'
' ########################
' #####  WinXUpdate  #####
' ########################
' Updates the specified window.
' hWnd = the handle to the window
FUNCTION WinXUpdate (hWnd)
	BINDING binding
	RECT rect

	SetLastError (0)
	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	'PRINT binding.hUpdateRegion
	InvalidateRgn (hWnd, binding.hUpdateRegion, $$TRUE)
	DeleteObject (binding.hUpdateRegion)
	binding.hUpdateRegion = 0
	bOK = binding_update (idBinding, binding)
	RETURN bOK

END FUNCTION
'
' #############################
' #####  WinXDrawEllipse  #####
' #############################
' Draws an ellipse.
' hWnd = the window to draw the ellipse on
' hPen and hBrush = the handles to the pen and brush to use
' x1, y1, x2, y2 = the coordinates of the ellipse
' returns the id of the ellipse
FUNCTION WinXDrawFilledEllipse (hWnd, hPen, hBrush, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

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
	bOK = binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw
END FUNCTION
'
' ##########################
' #####  WinXDrawRect  #####
' ##########################
' Draws a rectangle.
' hPen and hBrush = the handles to the pen and brush to use
' x1, y1, x2, y2 = the coordinates of the rectangle
' returns the id of the filled rectangle
FUNCTION WinXDrawFilledRect (hWnd, hPen, hBrush, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

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
	bOK = binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw
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
' returns a handle to the menu or 0 on fail
FUNCTION WinXNewMenu (menuList$, firstID, isPopup)
'
' 0.6.0.2-old---
'	'parse the string
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
'
	SetLastError (0)
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
' #############################
' #####  WinXMenu_Attach  #####
' #############################
' Attaches a sub-menu to another menu.
' subMenu   = the sub menu to attach
' newParent = the new parent menu
' idMenu    = the id to attach to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXMenu_Attach (subMenu, newParent, idMenu)
	MENUITEMINFO	mii

	SetLastError (0)
	IFZ subMenu THEN RETURN $$FALSE		' fail
	IFZ newParent THEN RETURN $$FALSE		' fail

	mii.fMask = $$MIIM_SUBMENU
	mii.hSubMenu = subMenu
	mii.cbSize = SIZE (MENUITEMINFO)

	' attach sub-menu idMenu to menu newParent
	SetLastError (0)
	ret = SetMenuItemInfoA (newParent, idMenu, 0, &mii)
	IFZ ret THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ##############################
' #####  WinXAddStatusBar  #####
' ##############################
' Creates a new status bar
' and adds it to specified window.
' hWnd           = the window to add the status bar to
' initialStatus$ = a string to initialize the status bar with.
'                  This string contains a number of strings for each panel,
'                  separated by commas
' id             = control id of the status bar
' returns a handle to the new status bar or 0 on fail
FUNCTION WinXAddStatusBar (hWnd, initialStatus$, id)
	BINDING	binding
	RECT rect

	SetLastError (0)
	'get the binding
	IFZ hWnd THEN RETURN 0		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN 0		' fail

	sbStyle = 0

	'get the parent window's style
	window_style = GetWindowLongA (hWnd, $$GWL_STYLE)
	IF (window_style AND $$WS_SIZEBOX) = $$WS_SIZEBOX THEN
		sbStyle = $$SBARS_SIZEGRIP
	ENDIF

	'make the status bar
	style = sbStyle|$$WS_CHILD|$$WS_VISIBLE
	binding.hStatus = CreateWindowExA (0, &$$STATUSCLASSNAME, 0, style, _
	0, 0, 0, 0, hWnd, id, GetModuleHandleA (0), 0)
	IFZ binding.hStatus THEN RETURN 0		' fail

	SendMessageA (binding.hStatus, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$TRUE)

	'now prepare the parts
'
' 0.6.0.2-old---
'	XstParseStringToStringArray (initialStatus$, ",", @s$[])
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
' Extract the comma separated values from initialStatus$
' and place each of them in s$[].
'
	IFZ INSTR (initialStatus$, ",") THEN
		' no comma => singleton
		DIM s$[0]
		s$[0] = initialStatus$
	ELSE
		' one or more commas => parse the comma-separated list
		errNum = ERROR ($$FALSE)		' clear any run-time error
		bErr = XstParseStringToStringArray (initialStatus$, ",", @s$[])
		IF bErr THEN
			msg$ = "WinXAddStatusBar: Can't parse " + initialStatus$
			GuiTellRunError (msg$)
			RETURN 0		' fail
		ENDIF
	ENDIF
' 0.6.0.2-new~~~
'
	'create array parts[] for holding the right edge cooordinates
	binding.statusParts = UBOUND (s$[])
	DIM parts[binding.statusParts]

	' calculate the right edge coordinate for each part, and
	' copy the coordinates to the array
	SetLastError (0)
	ret = GetClientRect (binding.hStatus, &rect)
	IFZ ret THEN
		msg$ = "WinXAddStatusBar: Can't get client rectangle of the status bar"
		GuiTellApiError (msg$)
		RETURN 0		' fail
	ENDIF

	cPart = binding.statusParts + 1		' number of right edge cooordinates
	w = rect.right - rect.left
	FOR i = 0 TO binding.statusParts
		parts[i] = ((i + 1) * w) / cPart
	NEXT i
	parts[binding.statusParts] = -1		' extend to the right edge of the window

	'set the part info
	SendMessageA (binding.hStatus, $$SB_SETPARTS, cPart, &parts[0])

	'and finally, set the text
	FOR i = 0 TO binding.statusParts
		SendMessageA (binding.hStatus, $$SB_SETTEXT, i, &s$[i])
	NEXT i

	'and update the binding
	bOK = binding_update (idBinding, binding)

	RETURN binding.hStatus

END FUNCTION
'
' ################################
' #####  WinXStatus_SetText  #####
' ################################
' Sets the text in a status bar.
' hWnd = the window containing the status bar
' part = the partition to set the text for, zero-based
' text$ = the text to set the status to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXStatus_SetText (hWnd, part, text$)
	BINDING	binding

	SetLastError (0)
	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	IF part > binding.statusParts THEN RETURN $$FALSE

	SendMessageA (binding.hStatus, $$SB_SETTEXT, part, &text$)
	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXStatus_GetText$  #####
' #################################
' Retrieves the text from a status bar.
' hWnd = the window containing the status bar
' part = the part to get the text from
' returns the status text from the specified part of the status bar, or an empty string on fail
FUNCTION WinXStatus_GetText$ (hWnd, part)
	BINDING	binding

	SetLastError (0)
	'get the binding
	IFZ hWnd THEN RETURN ""		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN ""		' fail

	IFZ binding.hStatus THEN RETURN ""		' fail
	IF part > binding.statusParts THEN RETURN ""

	cChar = SendMessageA (binding.hStatus, $$SB_GETTEXTLENGTH, part, 0)
	IF cChar > 0 THEN
		szBuf$ = NULL$ (cChar+1)		' to preserve the nul-terminator
		SetLastError (0)
		ret = SendMessageA (binding.hStatus, $$SB_GETTEXT, part, &szBuf$)
		IF ret THEN
			ret$ = CSTRING$ (&szBuf$)
			RETURN ret$
		ENDIF
	ENDIF
	RETURN ""		' fail
END FUNCTION
'
' ################################
' #####  WinXRegOnMouseMove  #####
' ################################
' Registers the .onMouseMove callback function for when the mouse is moved.
' hWnd = the handle to the window
' FnOnMouseMove = the function to call when the mouse moves
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseMove (hWnd, FUNCADDR FnOnMouseMove)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onMouseMove = FnOnMouseMove
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ################################
' #####  WinXRegOnMouseDown  #####
' ################################
' Registers the .onMouseDown callback function for when the mouse is pressed.
' hWnd = the handle to the window
' FnOnMouseDown = the function to call when the mouse is pressed
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseDown (hWnd, FUNCADDR FnOnMouseDown)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onMouseDown = FnOnMouseDown
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' #################################
' #####  WinXRegOnMouseWheel  #####
' #################################
' Registers the .onMouseWheel callback function for when the mouse wheel is rotated.
' hWnd = the handle to the window
' FnOnMouseWheel = the function to call when the mouse wheel is rotated
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseWheel (hWnd, FUNCADDR FnOnMouseWheel)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onMouseWheel = FnOnMouseWheel
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ##############################
' #####  WinXRegOnMouseUp  #####
' ##############################
' Registers the .onMouseUp callback function for when the mouse is released.
' hWnd = the handle to the window
' FnOnMouseUp = the function to call when the mouse is released
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseUp (hWnd, FUNCADDR FnOnMouseUp)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onMouseUp = FnOnMouseUp
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ############################
' #####  WinXNewToolbar  #####
' ############################
'
' Generates a new toolbar.
'
' wButton        = The width of a button image in pixels
' hButton        = the height of a button image in pixels
' nButtons       = the number of buttons images
' hBmpButtons    = a handle to the bitmap containing the button images
' hBmpDis        = the appearance of the buttons when disabled or 0 for default
' hBmpHot        = the appearance of the buttons when the mouse is over them or 0 for default
' transparentRGB = the color to use as transparent
' toolTips       = $$TRUE to enable tool tips, $$FALSE to disable them
'(customisable   = $$TRUE if this toolbar can be customised.)
'  !!THIS FEATURE IS NOT IMPLEMENTED YET, USE $$FALSE FOR THIS PARAMETER!!
'
' returns a handle to the new toolbar handle or 0 on fail
'
' Usage:
' load the 3 image lists
' hBmpButtons = LoadBitmapA (hInst, "toolbarImg")       ' normal image list
' hBmpHot     = LoadBitmapA (hInst, &"toolbarHotImg")   ' hot image list (if any in RC file)
' hBmpDis     = LoadBitmapA (hInst, &"toolbarDisImg")  ' disabled image list (if any)
' transparentRGB = RGB (0xFF, 0, 0xFF) ' color code for transparency
'
' #toolbar = WinXNewToolbar (16, 16, 9, hBmpButtons, hBmpDis, hBmpHot, transparentRGB, $$TRUE, $$FALSE)
'
FUNCTION WinXNewToolbar (wButton, hButton, nButtons, hBmpButtons, hBmpDis, hBmpHot, transparentRGB, toolTips, customisable)

	BITMAP bitMap

	' ULONG is natural for bit operands
	ULONG col
	ULONG red
	ULONG green
	ULONG blue

	DOUBLE luminance
	ULONG color

	SetLastError (0)

	IFZ hBmpButtons THEN RETURN 0		' fail

	hToolbar = 0

	' some argument checking...
	IF nButtons <= 0 THEN nButtons = 1

	' bmpWidth = wButton*nButtons
	SetLastError (0)
	ret = GetObjectA (hBmpButtons, SIZE (BITMAP), &bitMap)		' get bitmap's sizes
	SELECT CASE ret
		CASE 0
			' Too bad: using the passed height!
			SELECT CASE TRUE
				CASE hButton <= 20 : hButton = 16
				CASE hButton < 30  : hButton = 24
				CASE ELSE          : hButton = 32
			END SELECT
			wButton = hButton
			'
		CASE ELSE
			' Good: using bitmap size!
			hButton = 32
			SELECT CASE TRUE
				CASE bitMap.height <= 20 : hButton = 16
				CASE bitMap.height < 30  : hButton = 24
			END SELECT
			wButton = hButton
			'
			' save bitmap size for later use
			bmpWidth  = bitMap.width
			bmpHeight = bitMap.height
			'
			' make image lists
			flags = $$ILC_COLOR24 OR $$ILC_MASK
			hilNor = ImageList_Create (wButton, bmpHeight, flags, nButtons, 0)
			hilDis = ImageList_Create (wButton, bmpHeight, flags, nButtons, 0)
			hilHot = ImageList_Create (wButton, bmpHeight, flags, nButtons, 0)
			'
			' make 2 memory DCs for image manipulations
			hDC = GetDC (GetDesktopWindow ())     '  GetDC requires ReleaseDC
			'
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
			' secondly, the disabled buttons
			IF hBmpDis THEN
				' generate a mask
				hblankS = SelectObject (hSource, hBmpDis)
				hblankM = SelectObject (hMem, hBmpMask)
				BitBlt (hMem, 0, 0, bmpWidth, bmpHeight, hSource, 0, 0, $$SRCCOPY)
				GOSUB makeMask
			ELSE
'
' GL-26jul21-old---
'				' generate hBmpDis
'				hblankS = SelectObject (hSource, hBmpMask)
' GL-26jul21-old~~~
' GL-26jul21-new+++
' Generate a grayscaled version of hBmpButtons.
'
' To get luminance of a color, use the formula recommended by CIE (Commission Internationale de l'Eclairage):
'  L  =  0.2126 x R   +   0.7152 x G   +   0.0722 x B
' http://www.rosettacode.org/wiki/Grayscale_image
'
				' hBmpDis = hBmpButtons
				hblankS = SelectObject (hSource, hBmpButtons)
				'
				' hBmpDis = CopyImage (hBmpButtons, $$IMAGE_BITMAP, bmpWidth, bmpHeight, 0)
' GL-26jul-21-new~~~
'
				hBmpDis = CreateCompatibleBitmap (hSource, bmpWidth, bmpHeight)
				hblankM = SelectObject (hMem, hBmpDis)
				'
				upper_x = bmpWidth - 1
				upper_y = bmpHeight - 1
				FOR y = 0 TO upper_y
					FOR x = 0 TO upper_x
						col = GetPixel (hSource, x, y)
'
' GL-26jul21-old---
'						'IF col = 0x00000000 THEN SetPixel (hMem, x, y, 0x00808080)
'						IFZ col THEN SetPixel (hMem, x, y, $$MediumGrey)
' GL-26jul21-old~~~
' GL-26jul21-new+++
						' extract the red, green, blue values from the RGB color
						red = col AND 0xFF
						green = (col >> 8) AND 0xFF
						blue = (col >> 16) AND 0xFF
'
' GL-27jul21-old---
'						gray = (red + green + blue) / 3
' GL-27jul21-old~~~
' GL-27jul21-new+++
						' get luminance of a color by using the formula recommended by the CIE:
						luminance = (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
						gray = ULONG (luminance)

						' make sure gray is a valid RGB color
						gray = gray AND 0xFFFFFF
' GL-27jul21-new~~~
'
						color = gray | (gray << 8) | (gray << 16)
						SetPixel (hMem, x, y, color)
' GL-26jul21-new~~~
'
					NEXT x
				NEXT y
			ENDIF
			'
			SelectObject (hSource, hblankS)
			SelectObject (hMem, hblankM)
			'
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

				upper_x = bmpWidth - 1
				upper_y = bmpHeight - 1
				FOR y = 0 TO upper_y
					FOR x = 0 TO upper_x
						col = GetPixel (hSource, x, y)
						'
						' extract the red, green, blue values from the RGB color
						red = col AND 0xFF
						green = (col >> 8) AND 0xFF
						blue = (col >> 16) AND 0xFF
						'
						IF red < 215 THEN red = red + 40		'red+((0xFF-red)\3)
						IF green < 215 THEN green = green + 40		'green+((0xFF-green)\3)
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
			ReleaseDC (GetDesktopWindow (), hDC) : hDC = 0     '  GL-10dec19-release Device Context hDC
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
			' set the ToolBar bitmap size
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
' ###################################
' #####  WinXToolbar_AddButton  #####
' ###################################
' Adds a button to a toolbar.
' hToolbar = the toolbar to add the button to
' commandId = the id for the button
' iImage = the index of the image to use for the button
' toolTipText$ = the text to use for the tooltip
' optional = $$TRUE if this button is optional, otherwise $$FALSE
'  !!THIS FEATURE IS NOT YET IMPLEMENTED, YOU SHOULD SET THIS PARAMETER TO $$FALSE!!
' moveable = $$TRUE if the button can be move, otherwise $$FALSE
'  !!THIS FEATURE IS NOT YET IMPLEMENTED, YOU SHOULD SET THIS PARAMETER TO $$FALSE!!
'
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddButton (hToolbar, commandId, iImage, toolTipText$, optional, moveable)
	TBBUTTON bt

	SetLastError (0)
	IFZ hToolbar THEN RETURN $$FALSE		' fail

	bt.iBitmap = iImage
	bt.idCommand = commandId
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_AUTOSIZE|$$BTNS_BUTTON
	bt.iString = &toolTipText$

	ret = SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	IFZ ret THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  WinXSetWindowToolbar  #####
' ##################################
' Sets the window's toolbar.
' hWnd = the window to set
' hToolbar = the toolbar to use
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetWindowToolbar (hWnd, hToolbar)
	BINDING	binding

	SetLastError (0)
	IFZ hToolbar THEN RETURN $$FALSE		' fail

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	'set the toolbar style
	style = GetWindowLongA (hToolbar, $$GWL_STYLE)
	style = style|$$WS_CHILD|$$WS_VISIBLE|$$CCS_TOP
	SetWindowLongA (hToolbar, $$GWL_STYLE, style)

	'set the toolbar parent
	SetLastError (0)
	ret = SetParent (hToolbar, hWnd)
	IFZ ret THEN RETURN $$FALSE		' fail
	SendMessageA (hToolbar, $$TB_SETPARENT, hWnd, 0)

	'and update the binding
	binding.hBar = hToolbar
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ############################
' #####  WinXAddTooltip  #####
' ############################
' Adds a tooltip to a control.
' hControl = the handle to the control to set the tooltip for
' toolTipText$ = the text of the tooltip
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAddTooltip (hControl, toolTipText$)
	BINDING binding
	TOOLINFO ti

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hControl
		CASE 0
			'
		CASE ELSE
			toolTipText$ = TRIM$ (toolTipText$)
			IFZ toolTipText$ THEN
				msg$ = "WinXAddTooltip: no text for tooltips control"
				WinXDialog_Error (msg$, "WinX-Debug", 0)
				toolTipText$ = "(Missing)"
			ENDIF
			'
			'get the binding of the parent window
			parent = GetParent (hControl)
			IFZ parent THEN EXIT SELECT		' fail
			'
			idBinding = GetWindowLongA (parent, $$GWL_USERDATA)
			IFF binding_get (idBinding, @binding) THEN EXIT SELECT		' fail
			'
			ti.uFlags = $$TTF_SUBCLASS|$$TTF_IDISHWND
			ti.hwnd = parent
			ti.uId = hControl
			ti.lpszText = &toolTipText$
			'
			'is there any info on this control?
			fInfo = SendMessageA (binding.hToolTips, $$TTM_GETTOOLINFO, 0, &ti)
			IF fInfo THEN
				wMsg = $$TTM_UPDATETIPTEXT		' update the text
			ELSE
				wMsg = $$TTM_ADDTOOL		' make new entry
'
' 0.6.0.2-new+++
				style = $$WS_POPUP|$$TTS_NOPREFIX|$$TTS_ALWAYSTIP
				binding.hToolTips = CreateWindowExA (0, &$$TOOLTIPS_CLASS, 0, style, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, parent, 0, GetModuleHandleA (0), 0)
				IFZ binding.hToolTips THEN
					msg$ = "WinXAddTooltip: Can't add tooltips " + toolTipText$
					GuiTellApiError (msg$)
					EXIT SELECT
				ENDIF
' 0.6.0.2-new~~~
'
			ENDIF
			ti.cbSize = SIZE (TOOLINFO)
			'
			'add the tooltip text
			SetLastError (0)
			ret = SendMessageA (binding.hToolTips, wMsg, 0, &ti)
			IF ret THEN
				bOK = $$TRUE
			ELSE
				msg$ = "WinXAddTooltip: Can't add tooltips " + toolTipText$
				GuiTellApiError (msg$)
			ENDIF
			'
	END SELECT

	RETURN bOK

END FUNCTION
'
' ################################
' #####  WinXGetUseableRect  #####
' ################################
' Gets a rect describing the useable portion of a window's client area,
' that is, the portion not obscured with a toolbar or status bar.
' hWnd = the handle to the window to get the rect for
' rectUseable = the variable to hold the RECT structure
' returns $$TRUE on success or $$FALSE on fail
' ------------------------------------------------------------
' In conformance with conventions for the RECT structure, the
' bottom-right coordinates of the returned rectangle are
' exclusive. In other words, the pixel at (right, bottom) lies
' immediately outside the rectangle.
' ------------------------------------------------------------
'
' eg bOK = WinXGetUseableRect (hWnd, @rectUseable)
'
FUNCTION WinXGetUseableRect (hWnd, RECT rectUseable)
	BINDING binding
	RECT rect_null		' rectangle null
	RECT rect
'
' GL-old---
'	SetLastError (0)
'	'get the binding
'	IFZ hWnd THEN RETURN $$FALSE		' fail
'	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
'	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail
'
'	GetClientRect (hWnd, &rectUseable)
'	IF binding.hBar THEN
'		GetClientRect (binding.hBar, &rect)
'		rectUseable.top = rectUseable.top + (rect.bottom-rect.top)+2
'	ENDIF
'
'	IF binding.hStatus THEN
'		GetClientRect (binding.hStatus, &rect)
'		rectUseable.bottom = rectUseable.bottom - (rect.bottom-rect.top)
'	ENDIF
'
'	RETURN $$TRUE		' success
' GL-old~~~
' GL-new+++
	SetLastError (0)
	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	bOK = $$FALSE
	ret = GetClientRect (hWnd, &rectUseable)
	SELECT CASE ret
		CASE 0
			'
		CASE ELSE
			' 1.account for the caption's height
			rectUseable.top = rectUseable.top + GetSystemMetrics ($$SM_CYCAPTION)		' height of caption
			'
			' 2.account for the menubar's height
			menu = GetMenu (hWnd)
			IF menu THEN
				rectUseable.top = rectUseable.top + GetSystemMetrics ($$SM_CYMENU)		' height of single-line menu
			ENDIF
			'
			' 3.account for the toolbar's height
			IF binding.hBar THEN
				'toolbar
				SetLastError (0)
				ret = GetClientRect (binding.hBar, &rect)
				IF ret THEN
					rectUseable.top = rectUseable.top + rect.top - rect.bottom
				ELSE
					msg$ = "WinXGetUseableRect: Can't get the client rectangle of the toolbar"
					GuiTellApiError (msg$)
				ENDIF
			ENDIF
			'
			' 4.account for the status bar's height
			IF binding.hStatus THEN
				'status bar
				SetLastError (0)
				ret = GetClientRect (binding.hStatus, &rect)
				IF ret THEN
					rectUseable.bottom = rectUseable.bottom + rect.top - rect.bottom
				ELSE
					msg$ = "WinXGetUseableRect: Can't get the client rectangle of the status bar"
					GuiTellApiError (msg$)
				ENDIF
			ENDIF
			'
			' 5.account for a vertical scrollbar's width
			style = GetWindowLongA (hWnd, $$GWL_STYLE)
			IF style & $$WS_VSCROLL THEN
				rectUseable.right = rectUseable.right - GetSystemMetrics ($$SM_CXVSCROLL)		' width vertical scroll bar
			ENDIF
			'
			' 6.account for a horizontal scrollbar's height
			IF style & $$WS_HSCROLL THEN
				rectUseable.bottom = rectUseable.bottom - GetSystemMetrics ($$SM_CXHSCROLL)		' height horizontal scroll bar
			ENDIF
			'
			' 7.account for the window frame's width
			rectUseable.left  = rectUseable.left  + GetSystemMetrics ($$SM_CXFRAME)		' width of the window frame
			rectUseable.right = rectUseable.right - GetSystemMetrics ($$SM_CXFRAME)		' width of the window frame
			'
			bOK = $$TRUE		' success
			'
	END SELECT

	IFF bOK THEN rectUseable = rect_null		' reset the returned value

	RETURN bOK

END FUNCTION
'
' ####################################
' #####  WinXNewToolbarUsingIls  #####
' ####################################
' Makes a new toolbar using the specified image lists.
' hilNor       = the image list for the buttons
' hilDis       = the images to be displayed when the buttons are disabled
' hilHot       = the images to be displayed on mouse over
' toolTips     = $$TRUE to enable tooltips control
' customisable = $$TRUE to enable customisation
' returns the new toolbar handle or 0 on fail
FUNCTION WinXNewToolbarUsingIls (hilNor, hilDis, hilHot, toolTips, customisable)

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
	hToolbar = CreateWindowExA (0, &$$TOOLBARCLASSNAME, 0, style, 0, 0, 0, 0, 0, 0, GetModuleHandleA(0), 0)
	IFZ hToolbar THEN RETURN 0		' fail

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
END FUNCTION
'
' ######################
' #####  WinXUndo  #####
' ######################
' Undoes a drawing operation.
' idDraw = the id of the operation
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXUndo (hWnd, idDraw)
	AUTODRAWRECORD	record
	BINDING			binding
	LINKEDLIST	autoDraw

	SetLastError (0)
	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

'	LINKEDLIST_Get (binding.autoDrawInfo, @autoDraw)
'	LinkedList_GetItem (autoDraw, idDraw, @iData)
	AUTODRAWRECORD_Get (idDraw, @record)
	record.toDelete = $$TRUE
	IFZ binding.hUpdateRegion THEN
		binding.hUpdateRegion = record.hUpdateRegion
	ELSE
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
		DeleteObject(record.hUpdateRegion)
	ENDIF
'
' 0.6.0.2-old---
'	IF record.draw = &drawText() THEN STRING_Delete (record.text.iString)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	IF record.text.iString THEN
		STRING_Delete (record.text.iString)
		record.text.iString = 0
	ENDIF
' 0.6.0.2-new~~~
'
	AUTODRAWRECORD_Update (idDraw, record)
'	LinkedList_DeleteItem (@autoDraw, idDraw)
'	LINKEDLIST_Update (binding.autoDrawInfo, @autoDraw)

	bOK = binding_update (idBinding, binding)

	RETURN bOK
END FUNCTION
'
' ##############################
' #####  WinXRegOnKeyDown  #####
' ##############################
' Registers the .onKeyDown callback function.
' hWnd = the handle to the window to register the callback for
' FnOnKeyDown = the address of the .onKeyDown callback function
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'	addrProc = &winAbout_OnKeyDown ()		' handles message WM_KEYDOWN
'	WinXRegOnKeyDown (#winAbout, addrProc)
'
FUNCTION WinXRegOnKeyDown (hWnd, FUNCADDR FnOnKeyDown)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onKeyDown = FnOnKeyDown
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ############################
' #####  WinXRegOnKeyUp  #####
' ############################
' Registers the .onKeyUp callback function.
' hWnd = the handle to the window to register the callback for
' FnOnKeyUp = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnKeyUp (hWnd, FUNCADDR FnOnKeyUp)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onKeyUp = FnOnKeyUp
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ###########################
' #####  WinXRegOnChar  #####
' ###########################
' Registers the .onChar callback function.
' hWnd = the handle to the window to register the callback for
' FnOnChar = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnChar (hWnd, FUNCADDR FnOnChar)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onChar = FnOnChar
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ###########################
' #####  WinXIsKeyDown  #####
' ###########################
' Checks to see if a key is pressed.
' key = the ascii code of the key or a VK code for special keys
' returns $$TRUE if the key is pressed or $$FALSE otherwise.
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
' ################################
' #####  WinXIsMousePressed  #####
' ################################
' Checks to see if a mouse button is pressed.
' button = a MBT constant
' returns $$TRUE if the button is pressed or $$FALSE otherwise
FUNCTION WinXIsMousePressed (button)

	SetLastError (0)
	vk = 0
'
' We need to take into account the possibility
' that the mouse buttons are swapped.
'
	IF GetSystemMetrics($$SM_SWAPBUTTON) THEN
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
		SetLastError (0)
		IF GetAsyncKeyState (vk) THEN
			RETURN $$TRUE		' success
		ENDIF
	ENDIF
	RETURN $$FALSE		' fail
END FUNCTION
'
' ############################
' #####  WinXAddControl  #####
' ############################
' Creates a new custom control
' and adds it to specified window.
' parent = the window to add the control to
' class$  = the class name for the control - this will be in the control's documentation
' text$   = the initial text to appear in the control - not all controls use this parameter
' id      = the unique id to identify the control
' style   = the style of the control.  You do not have to include $$WS_CHILD or $$WS_VISIBLE
' exStyle = the extended style of the control;
'           for most controls this will be 0
' returns a handle to the new control or 0 on fail
FUNCTION WinXAddControl (parent, class$, text$, style, exStyle, id)
	SetLastError (0)
	style = style|$$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP
	hCtr = CreateWindowExA (exStyle, &class$, &text$, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	RETURN hCtr
END FUNCTION
'
' ############################
' #####  WinXAddListBox  #####
' ############################
' Creates a new list box control
' and adds it to specified window.
' parent      = the handle to the parent window
' sort        = $$TRUE if listbox is sorted (increasing)
' multiSelect = $$TRUE if the list box can have multiple selections
' id          = the control id for the list box
' returns a handle to the new listbox or 0 on fail
FUNCTION WinXAddListBox (parent, sort, multiSelect, id)

	SetLastError (0)
	style = $$WS_CHILD|$$WS_VISIBLE
'
' $$LBS_STANDARD is a combination of $$LBS_SORT, $$LBS_NOTIFY, $$WS_VSCROLL, and $$WS_BORDER
' $$LBS_SORT  : Sort items increasing
' $$LBS_NOTIFY: enables $$WM_COMMAND's notification code ($$LBN_SELCHANGE)
' $$WS_VSCROLL: Vertical   Scroll Bar
'
	style = style|$$LBS_STANDARD		' Warning: does not allow dragNdrop

	IFZ sort THEN
		style = style AND (NOT $$LBS_SORT)		' don't sort items increasing
	ENDIF

	IF multiSelect THEN
		' $$LBS_EXTENDEDSEL: Multiple selections
		style = style|$$LBS_EXTENDEDSEL
	ENDIF
'
' $$WS_HSCROLL    : Horizontal Scroll Bar
' $$LBS_HASSTRINGS: Items are strings
'
	style = style|$$WS_HSCROLL|$$LBS_HASSTRINGS

	hListBox = CreateWindowExA (0, &"LISTBOX", 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hListBox THEN RETURN 0		' fail
	SendMessageA (hListBox, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	RETURN hListBox
END FUNCTION
'
' #############################
' #####  WinXAddComboBox  #####
' #############################
' Creates a new extended combo box
' and adds it to specified window.
' parent  = the parent window for the combo box
' canEdit = $$TRUE if the user can enter their own item in the edit box
' images  = if this combo box displays images with items, this is the handle to an image list, else 0
' id      = the id for the control
' returns a handle to the new combo box or 0 on fail
FUNCTION WinXAddComboBox (parent, listHeight, canEdit, images, id)
	SetLastError (0)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP
	IF canEdit THEN
		' $$CBS_DROPDOWN     : Editable Drop Down List
		style = style|$$CBS_DROPDOWN
	ELSE
		' $$CBS_DROPDOWNLIST : Non-editable Drop Down List
		style = style|$$CBS_DROPDOWNLIST
	ENDIF

	hCombo = CreateWindowExA (0, &$$WC_COMBOBOXEX, 0, style, 0, 0, 0, listHeight+22, parent, id, GetModuleHandleA (0), 0)
	IFZ hCombo THEN RETURN 0		' fail

	IF images THEN
		SetLastError (0)
		SendMessageA (hCombo, $$CBEM_SETIMAGELIST, 0, images)
	ENDIF
	RETURN hCombo
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
' ####################################
' #####  WinXListBox_RemoveItem  #####
' ####################################
' Removes an item from a list box control.
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
	IFZ hListBox THEN RETURN 0		' fail
	IF index < 0 THEN
		index = SendMessageA (hListBox, $$LB_GETCOUNT, 0, 0) - 1
	ENDIF
	SetLastError (0)
	r_count = SendMessageA (hListBox, $$LB_DELETESTRING, index, 0)
	RETURN r_count
END FUNCTION
'
' ######################################
' #####  WinXListBox_GetSelection  #####
' ######################################
' Gets the selected item(s) in a list box control.
' hListBox = list box to get the items from
' r_indexList[] = array to place the indexes of selected items into
' returns the number of selected items or 0 if fail
'
' Usage:
'	cSel = WinXListBox_GetSelection (hListBox, @indexList[])
'	IFZ cSel THEN XstAlert ("No selected items")
'
FUNCTION WinXListBox_GetSelection (hListBox, r_indexList[])
	SetLastError (0)
	cSelItems = 0

	SELECT CASE hListBox
		CASE 0
			'
		CASE ELSE
			style = GetWindowLongA (hListBox, $$GWL_STYLE)
			IF style AND $$LBS_EXTENDEDSEL THEN
				' multiple selections
				cSelItems = SendMessageA (hListBox, $$LB_GETSELCOUNT, 0, 0)
				IF cSelItems > 0 THEN
					DIM r_indexList[cSelItems - 1]
					SendMessageA (hListBox, $$LB_GETSELITEMS, cSelItems, &r_indexList[0])
				ENDIF
			ELSE
				' single selection
				selItem = SendMessageA (hListBox, $$LB_GETCURSEL, 0, 0)
				IF selItem >= 0 THEN
					DIM r_indexList[0]
					r_indexList[0] = selItem
					cSelItems = 1
				ENDIF
			ENDIF
			'
	END SELECT

	IF cSelItems <= 0 THEN
		cSelItems = 0		' just in case
		DIM r_indexList[]		' reset the returned array
	ENDIF

	RETURN cSelItems

END FUNCTION
'
' ##################################
' #####  WinXListBox_GetIndex  #####
' ##################################
' Gets the index of a particular string.
' hListBox = the handle to the list box containing the string
' searchFor$ = the string to search for
' Returns the index of the item or -1 on fail.
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
' ######################################
' #####  WinXListBox_SetSelection  #####
' ######################################
' Sets the selection on a list box control.
' hListBox = the handle to the list box to set the selection for
' indexList[] = an array of item indexes to select
' returns $$TRUE on success or $$FALSE on fail
'
' notes:
' - indexList[i] > count - 1 (last): no selection
' - idx < 0: idx = -1 (unselect for single selection)
'
FUNCTION WinXListBox_SetSelection (hListBox, indexList[])

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hListBox
		CASE 0
			'
		CASE ELSE
			IFZ indexList[] THEN EXIT SELECT		' empty array
			'
			count = SendMessageA (hListBox, $$LB_GETCOUNT, 0, 0)
			IFZ count THEN EXIT SELECT
			'
			style = GetWindowLongA (hListBox, $$GWL_STYLE)
			IF style AND $$LBS_EXTENDEDSEL THEN
				' Multiple Selections
				'
				' first, unselect everything
				SetLastError (0)
				SendMessageA (hListBox, $$LB_SETSEL, $$FALSE, -1)
				'
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
				' Single Selection
				IF indexList[0] < 0 THEN indexList[0] = -1		' unselect
				'
				SetLastError (0)
				ret = SendMessageA (hListBox, $$LB_SETCURSEL, indexList[0], 0)
				IF ret <> -1 THEN
					' the list box is scrolled, if necessary, to bring the selected item into view
					SetLastError (0)
					SendMessageA (hListBox, $$LB_SETTOPINDEX, indexList[0], 0)
					bOK = $$TRUE
				ENDIF
			ENDIF
			'
	END SELECT

	RETURN bOK

END FUNCTION
'
' ##################################
' #####  WinXDialog_OpenFile$  #####
' ##################################
' Displays an Open File Dialog.
' hOwner = the handle to the window to own this dialog
' title$ = the title for the dialog
' extensions$ = a string containing the file extensions the dialog supports
' initialName$ = the filename to initialize the dialog with
' multiSelect = $$TRUE to enable selection of multiple items, otherwise $$FALSE
' returns the opened file or an empty string on error or cancel
'
' Demo in WinXsamples: functionMover.x
' $$FILTERSTRING$ = "XBlite source files (*.x)\0*.x\0All Files (*.*)\0*.*\0\0"
' fileName$ = WinXDialog_OpenFile$ (#hMain, "Select an XBlite source file", $$FILTERSTRING$, "", $$FALSE)
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
	initialName$ = WinXPath_Trim$ (initialName$)
	IFZ initialName$ THEN
		XstGetCurrentDirectory (@initialName$)
		initialName$ = initialName$ + $$PathSlash$ + "*.*"
	ENDIF
'
' debug+++
'msg$ = "WinXDialog_OpenFile$: initialName$ = " + initialName$
'WinXDialog_Error (msg$, "WinX-Debug", 0)
' debug~~~
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
' 0.6.0.2-old~~~
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
' 0.6.0.2-new~~~
'
	END SELECT
'
' debug+++
'msg$ = "WinXDialog_OpenFile$: initFN$ = <" + initFN$ + ">, initExt$ = <" + initExt$ + ">"
'WinXDialog_Error (msg$, "WinX-Debug", 0)
' debug~~~
'
	' compute ofn.lpstrInitialDir
	initDir$ = WinXPath_Trim$ (initDir$)
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
'WinXDialog_Error (msg$, "WinX-Debug", 0)
' debug~~~
'
	path$ = initFN$ + initExt$

	' allocate the returned buffer
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
'WinXDialog_Error (msg$, "WinX-Debug", 0)
' debug~~~
'
	IF title$ THEN ofn.lpstrTitle = &title$		' dialog title

	' set dialog flags
	ofn.flags = $$OFN_FILEMUSTEXIST|$$OFN_EXPLORER

	IF multiSelect THEN
		ofn.flags = ofn.flags|$$OFN_ALLOWMULTISELECT
	ENDIF
'
' GL-28oct09-old---
'	' readOnly allows to open "Read Only" (no lock) the selected file(s).
'	IF readOnly THEN
'		ofn.flags = ofn.flags|$$OFN_READONLY		' show the checkbox "Read Only" (initially checked)
'	ELSE
'		ofn.flags = ofn.flags|$$OFN_HIDEREADONLY
'	ENDIF
' GL-28oct09-old~~~
' GL-28oct09-new+++
	' allow to open "Read Only" (no lock) the selected file(s)
	ofn.flags = ofn.flags|$$OFN_READONLY		' show the checkbox "Read Only" (initially checked)
' GL-28oct09-new~~~
'
	ofn.lpstrDefExt = &initExt$

	ofn.hwndOwner = hOwner
	IFZ ofn.hwndOwner THEN
		ofn.hwndOwner = GetActiveWindow ()
	ENDIF
	ofn.hInstance = GetModuleHandleA(0)

	ofn.lStructSize = SIZE (OPENFILENAME)		' length of the structure (in bytes)
	SetLastError (0)
	ret = GetOpenFileNameA (&ofn)		' fire off dialog
'
' 0.6.0.2-new+++
	IFZ ret THEN
		caption$ = "WinXDialog_OpenFile$: Windows' Open File Error"
		GuiTellDialogError (hOwner, caption$)
		RETURN ""		' fail
	ENDIF
' 0.6.0.2-new~~~
'
	' build r_selFiles$, a list of selected files, separated by ";"
	IFF multiSelect THEN
		opened$ = CSTRING$ (ofn.lpstrFile)
		opened$ = WinXPath_Trim$ (opened$)
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

			opened$ = WinXPath_Trim$ (opened$)
			IFZ r_selFiles$ THEN
				r_selFiles$ = opened$
			ELSE
				r_selFiles$ = r_selFiles$ + ";" + opened$
			ENDIF
			INC p		' skip nul-terminator
		LOOP
	ENDIF

	RETURN r_selFiles$

END FUNCTION
'
' ##################################
' #####  WinXDialog_SaveFile$  #####
' ##################################
' Displays a Save File Dialog.
' hOwner       = the handle to the parent window
' title$       = the title of the dialog box
' extensions$  = a string listing the supported extensions
' initialName$ = the name to initialize the dialog with
' overwritePrompt = $$TRUE to warn the user when they are about to overwrite a file, $$FALSE otherwise
' returns the name of the bachup file or an empty string on error or cancel
FUNCTION WinXDialog_SaveFile$ (hOwner, title$, extensions$, initialName$, overwritePrompt)
	OPENFILENAME ofn

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
' use the first extension as a default--------------vvv
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
					posFirst = pos		' position of the first separator '|'
					posLast = INSTR (fileFilter$, "|", posFirst)		' position of the 2nd separator '|'
					posSemiColumn = INSTR (fileFilter$, ";", posFirst)		' position of an eventual extensions list separator ';'
					'
					IF (posSemiColumn > 0) && (posSemiColumn < posLast) THEN
						' extension list, separator is ';'
						cCh = posSemiColumn - posFirst		' i.e. "|*.ext1;*.ext2;...|"
					ELSE
						' single extension
						cCh = posLast - posFirst		' i.e. "|*.ext1|"
					ENDIF
					IF cCh > 0 THEN
						' extract the default extension from the pattern (it's the first of the list)
						defExt$ = MID$ (fileFilter$, posFirst, cCh)		' clip up to the separator (';' or '|')
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
	ofn.hInstance = GetModuleHandleA(0)
	ofn.lStructSize = SIZE (OPENFILENAME)

	SetLastError (0)
	ret = GetSaveFileNameA (&ofn)
'
' 0.6.0.2-new+++
	IFZ ret THEN
		caption$ = "WinXDialog_SaveFile$: Windows' Save File Error"
		GuiTellDialogError (hOwner, caption$)
		RETURN ""		' fail
	ENDIF
' 0.6.0.2-new~~~
'
	r_savedPath$ = CSTRING$ (ofn.lpstrFile)
	RETURN r_savedPath$

END FUNCTION
'
' ##################################
' #####  WinXListBox_GetItem$  #####
' ##################################
' Gets a list box item.
' hListBox = the handle to the list box to get the item from
' index = the index of the item to get
' returns the string of the item or an empty string on fail
FUNCTION WinXListBox_GetItem$ (hListBox, index)

	SetLastError (0)
	IFZ hListBox THEN RETURN ""		' fail
	IF index < 0 THEN RETURN ""		' fail

	cChar = SendMessageA (hListBox, $$LB_GETTEXTLEN, index, 0)
	IF cChar > 0 THEN
		szBuf$ = NULL$ (cChar)
		SetLastError (0)
		cChar = SendMessageA (hListBox, $$LB_GETTEXT, index, &szBuf$)
		IF cChar > 0 THEN
			RETURN CSTRING$ (&szBuf$)
		ENDIF
	ENDIF
	RETURN ""		' fail
END FUNCTION
'
' ##################################
' #####  WinXComboBox_AddItem  #####
' ##################################
' Adds a new item to a combo box.
' hCombo = the handle to the combo box
' index = the index to insert the item at, use -1 to add to the end
' indent = the number of indents to place the item at
' item$ = the item text
' iImage = the index to the image, ignored if this combo box doesn't have images
' iSelImage = the index of the image displayed when this item is selected
' returns the index of the new item or -1 on fail
FUNCTION WinXComboBox_AddItem (hCombo, index, indent, item$, iImage, iSelImage)
	COMBOBOXEXITEM cbexi		' extended combo box structure

	SetLastError (0)
	IFZ hCombo THEN RETURN -1		' fail

	cbexi.mask = $$CBEIF_IMAGE|$$CBEIF_INDENT|$$CBEIF_SELECTEDIMAGE|$$CBEIF_TEXT
	IF index < 0 THEN
		cbexi.iItem = -1		' add to the end
	ELSE
		cbexi.iItem = index
	ENDIF
	cbexi.pszText = &item$
	cbexi.cchTextMax = LEN(item$)

	cbexi.iImage = iImage
	cbexi.iSelectedImage = iSelImage
	cbexi.iIndent = indent

	SetLastError (0)
	r_index = SendMessageA (hCombo, $$CBEM_INSERTITEM, 0, &cbexi)
	IF r_index < 0 THEN RETURN -1		' fail
	RETURN r_index
END FUNCTION
'
' #####################################
' #####  WinXComboBox_RemoveItem  #####
' #####################################
' Removes an item from a combo box.
' hCombo = the handle to the combo box
' index  = the zero-based index of the item to remove
' returns the number of items remaining in the list, or $$CB_ERR on fail
FUNCTION WinXComboBox_RemoveItem (hCombo, index)
	SetLastError (0)
	IFZ hCombo THEN RETURN $$CB_ERR		' fail
	r_number_left = SendMessageA (hCombo, $$CBEM_DELETEITEM, index, 0)
	RETURN r_number_left
END FUNCTION
'
' #######################################
' #####  WinXComboBox_GetSelection  #####
' #######################################
' Gets the current selection in a combo box.
' hCombo = the handle to the combo box
' returns the index of the currently selected item
'         or $$CB_ERR on fail
'
' Usage:
'	indexSel = WinXComboBox_GetSelection (hCombo)		' get current selection index
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
' #######################################
' #####  WinXComboBox_SetSelection  #####
' #######################################
' Selects an item in a combo box.
' hCombo = the handle to the combo box
' index  = the index of the item to select,
'          -1 to deselect everything.
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXComboBox_SetSelection (hCombo, index)
'
' 0.6.0.2-old---
'	IF (index < -1) THEN index = -1		' unselect
'	IFF (SendMessageA (hCombo, $$CB_SETCURSEL, index, 0) = $$CB_ERR) && (index != -1) THEN
'		RETURN $$TRUE		' success
'	ENDIF
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	SetLastError (0)
	IFZ hCombo THEN RETURN $$FALSE		' fail

	IF index < 0 THEN
		' unselect
		SendMessageA (hCombo, $$CB_SETCURSEL, -1, 0)		' unselect everything
	ELSE
		' select combo box item
		ret = SendMessageA (hCombo, $$CB_SETCURSEL, index, 0)
		IF ret = $$CB_ERR THEN RETURN $$FALSE		' fail
	ENDIF

	RETURN $$TRUE		' success
' 0.6.0.2-new~~~
'
END FUNCTION
'
' ###################################
' #####  WinXComboBox_GetItem$  #####
' ###################################
' Gets the text of a combo box item.
' hCombo = the handle to the combo box
' index  = the zero-based index of the item to get
'          or -1 to retrieve the item displayed in the edit control.
' returns the text of the item, or an empty string on fail
FUNCTION WinXComboBox_GetItem$ (hCombo, index)
	COMBOBOXEXITEM cbexi		' extended combo box structure

	SetLastError (0)
	IFZ hCombo THEN RETURN ""		' fail

	IF index < 0 THEN
		' retrieve the item displayed in the edit control
		index = -1
	ENDIF
	cbexi.mask = $$CBEIF_TEXT
	cbexi.iItem = index

	cbexi.cchTextMax = 4095
	szBuf$ = NULL$ (cbexi.cchTextMax)
	cbexi.pszText = &szBuf$

	SetLastError (0)
	ret = SendMessageA (hCombo, $$CBEM_GETITEM, 0, &cbexi)
	IFZ ret THEN RETURN ""		' fail
	ret$ = CSTRING$(cbexi.pszText)
	RETURN ret$
END FUNCTION
'
' ####################################
' #####  WinXNewAutoSizerSeries  #####
' ####################################
' Adds a new auto-sizer series.
' direction = $$DIR_VERT for WM_VSCROLL, $$DIR_HORIZ for WM_HSCROLL,
'             OR'ed with $$DIR_REVERSE for reverse
' returns the index of the new auto-sizer series or -1 on fail
FUNCTION WinXNewAutoSizerSeries (direction)
	series = autoSizerInfo_addGroup (direction)
	RETURN series
END FUNCTION
'
' ################################
' #####  WinXAddCheckButton  #####
' ################################
' Adds a new check button control.
' parent   = the handle to the parent window
' text$    = the text of the check control
' isFirst  = $$TRUE if this is the first check button in the group, otherwise $$FALSE
' pushlike = $TRUE if the button is to be displayed as a pushbutton
' id       = the unique id for this control
' returns a handle to the new check button or 0 on fail
FUNCTION WinXAddCheckButton (parent, text$, isFirst, pushlike, id)
	SetLastError (0)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP|$$BS_AUTOCHECKBOX
	IF isFirst  THEN style = style|$$WS_GROUP
	IF pushlike THEN style = style|$$BS_PUSHLIKE
	hCheck = CreateWindowExA (0, &$$BUTTON, &text$, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hCheck THEN RETURN 0		' fail
	SendMessageA (hCheck, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	RETURN hCheck
END FUNCTION
'
' ################################
' #####  WinXAddRadioButton  #####
' ################################
' Adds a new radio button control.
' parent   = the handle to the parent window
' text$    = the text of radio button
' isFirst  = $$TRUE if this is the first radio button in the group, otherwise $$FALSE
' pushlike = $$TRUE if the button is to be displayed as a pushbutton
' id       = the unique id constant for the radio button
' returns a handle to the new radio button or 0 on fail
FUNCTION WinXAddRadioButton (parent, text$, isFirst, pushlike, id)
	SetLastError (0)
'
' GL-My bug---
' Radio button group does not work!
'
'	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP|$$BS_AUTORADIOBUTTON
' GL-My bug~~~
'
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$BS_AUTORADIOBUTTON
	IF isFirst  THEN style = style|$$WS_GROUP
	IF pushlike THEN style = style|$$BS_PUSHLIKE
	hRadio = CreateWindowExA (0, &$$BUTTON, &text$, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hRadio THEN RETURN 0		' fail
	SendMessageA (hRadio, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	RETURN hRadio
END FUNCTION
'
' #################################
' #####  WinXButton_SetCheck  #####
' #################################
' Sets the check state of a check or radio button.
' hButton = the handle to the button to set the check state for
' checked = $$TRUE to check the button, $$FALSE to uncheck it
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXButton_SetCheck (hButton, checked)
	SetLastError (0)
	IFZ hButton THEN RETURN $$FALSE		' fail
	IF checked THEN
		status = $$BST_CHECKED
	ELSE
		status = $$BST_UNCHECKED
	ENDIF
	ret = SendMessageA (hButton, $$BM_SETCHECK, status, 0)
	IFZ ret THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXButton_GetCheck  #####
' #################################
' Gets the check state of a check or radio button.
' hButton = the handle to the button to get the check state for
' returns $$TRUE if the button is checked or $$FALSE otherwise
FUNCTION WinXButton_GetCheck (hButton)
	SetLastError (0)
	IFZ hButton THEN RETURN $$FALSE		' fail
	state = SendMessageA (hButton, $$BM_GETCHECK, 0, 0)
	IF state AND $$BST_CHECKED THEN
	 	checked = $$TRUE		' checked
	 ELSE
		checked = $$FALSE		' unchecked
	ENDIF
	RETURN checked
END FUNCTION
'
' #############################
' #####  WinXAddTreeView  #####
' #############################
' Creates a new tree view control and adds it to specified window.
' parent = the handle to the parent window
' editable = $$TRUE to enable label editing
' draggable = $$TRUE to enable dragging
' id = the unique id constant for this control
' returns a handle to the new tree view control or 0 on fail
FUNCTION WinXAddTreeView (parent, hImages, editable, draggable, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP
'
' $$TVS_LINESATROOT : Lines at root
' $$TVS_HASLINES    : |--lines
' $$TVS_HASBUTTONS  : [-]/[+]
'
	style = style|$$TVS_HASBUTTONS|$$TVS_HASLINES|$$TVS_LINESATROOT

	IFF draggable THEN style = style|$$TVS_DISABLEDRAGDROP
	IF editable   THEN style = style|$$TVS_EDITLABELS

	SetLastError (0)
	hTreeView = CreateWindowExA (0, &$$WC_TREEVIEW, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hTreeView THEN RETURN 0		' fail

	SendMessageA (hTreeView, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	IF hImages THEN
		'attach the image list to tree view
		SetLastError (0)
		SendMessageA (hTreeView, $$TVM_SETIMAGELIST, $$TVSIL_NORMAL, hImages)
	ENDIF
	RETURN hTreeView
END FUNCTION
'
' ################################
' #####  WinXAddProgressBar  #####
' ################################
' Creates a new progress bar control
' and adds it to specified window.
' parent = the handle to the parent window
' smooth = $$TRUE if the progress bar is not to be segmented
' id = the unique id constant for this control
' returns a handle to the progress bar or 0 on fail
FUNCTION WinXAddProgressBar (parent, smooth, id)
	XLONG minMax	' = MAKELONG (0, 1000)

	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP
	IF smooth THEN style = style|$$PBS_SMOOTH
	hProg = CreateWindowExA (0, &$$PROGRESS_CLASS, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hProg THEN RETURN 0		' fail

	' set the minimum and maximum values for the progress bar
	minMax = MAKELONG (0, 1000)
	SendMessageA (hProg, $$PBM_SETRANGE, 0, minMax)
	RETURN hProg
END FUNCTION
'
' #############################
' #####  WinXAddTrackBar  #####
' #############################
' Creates a new track bar control
' and adds it to specified window.
' parent = the parent window for the trackbar
' enableSelection = $$TRUE to enable selections in the track bar
' posToolTip = $$TRUE to enable a tooltip which displays the position of the slider
' id = the unique id constant of this trackbar
' returns a handle to the new track bar or 0 on fail
FUNCTION WinXAddTrackBar (parent, enableSelection, posToolTip, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP|$$TBS_AUTOTICKS
	IF enableSelection THEN style = style|$$TBS_ENABLESELRANGE
	IF posToolTip      THEN style = style|$$TBS_TOOLTIPS

	hTracker = CreateWindowExA (0, &$$TRACKBAR_CLASS, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hTracker THEN RETURN 0		' fail
	SendMessageA (hTracker, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$TRUE)
	RETURN hTracker
END FUNCTION
'
' #########################
' #####  WinXAddTabs  #####
' #########################
' Creates a new tabs control
' and adds it to specified window.
' parent = the handle to the parent window
' multiline = $$TRUE if this is a multiline control
' id = the unique id for this control
' returns a handle to the new tabs control or 0 on fail
FUNCTION WinXAddTabs (parent, multiline, id)

	SetLastError (0)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP
'
' both tabs and parent controls must have the $$WS_CLIPSIBLINGS window style
' $$WS_CLIPSIBLINGS : Clip Sibling Area
' $$TCS_HOTTRACK    : Hot track
'
	style = style|$$TCS_HOTTRACK|$$WS_CLIPSIBLINGS

	IF multiline THEN style = style|$$TCS_MULTILINE

	hTabs = CreateWindowExA (0, &$$WC_TABCONTROL, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hTabs THEN RETURN 0		' fail
	SendMessageA (hTabs, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$TRUE)
'
' Add $$WS_CLIPSIBLINGS style to the parent if missing.
'
	parent_style = GetWindowLongA (parent, $$GWL_STYLE)
	IFZ parent_style AND $$WS_CLIPSIBLINGS THEN
		parent_style = parent_style|$$WS_CLIPSIBLINGS
		SetWindowLongA (parent, $$GWL_STYLE, parent_style)
	ENDIF

	SetPropA (hTabs, &$$LeftSubSizer$, &sizeTabsContents())
'
' 0.6.0.2-needed?
'	series = autoSizerInfo_addGroup ($$DIR_VERT)
'	SetPropA (hTabs, &$$AutoSizer$, series)
'	IF series < 0 THEN
'		msg$ = "WinXAddTabs: Can't add auto-sizer to tabs control" + STR$ (id)
'		XstAlert (msg$)
'	ENDIF
' 0.6.0.2-new~~~
'
	RETURN hTabs

END FUNCTION
'
' ##############################
' #####  WinXAddAnimation  #####
' ##############################
' Creates a new animation control
' and adds it to specified window.
' parent = the handle to the parent window
' file$  = the animation file to play
' id     = the unique id for this control
' returns a handle to the new animation control or 0 on fail
FUNCTION WinXAddAnimation (parent, file$, id)

	SetLastError (0)
	hAni = CreateWindowExA (0, &"SysAnimate32", 0, $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP| _
				$$ACS_CENTER, 0, 0, 0, 0, parent, id, _
				GetModuleHandleA (0), 0)
	IFZ hAni THEN RETURN 0		' fail
	IF file$ THEN
		SetLastError (0)
		SendMessageA (hAni, $$ACM_OPENA, 0, &file$)
	ENDIF
	RETURN hAni

END FUNCTION
'
' ###########################
' #####  WinXRegOnDrag  #####
' ###########################
' Registers the .onDrag callback function.
' hWnd = the window to register the callback for
' FnOnDrag = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnDrag (hWnd, FUNCADDR FnOnDrag)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onDrag = FnOnDrag
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ########################################
' #####  WinXListBox_EnableDragging  #####
' ########################################
' Enables dragging on a list box control;
' (make sure to register .onDrag callback function as well).
'
' hListBox = the handle to the list box to enable dragging on
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListBox_EnableDragging (hListBox)
	SHARED DLM_MESSAGE

	SetLastError (0)
	IFZ hListBox THEN RETURN $$FALSE		' fail
'
' GL-old---
'	IFZ MakeDragList (hListBox) RETURN $$FALSE
'	DLM_MESSAGE = RegisterWindowMessageA (&$$DRAGLISTMSGSTRING)
' GL-old~~~
' GL-new+++
	style = GetWindowLongA (hListBox, $$GWL_STYLE)
	IF style AND $$LBS_EXTENDEDSEL THEN
		msg$ = "WinXListBox_EnableDragging-Drag is invalid for a multi-selection listbox"
		WinXDialog_Error (msg$, "WinX-Debug", 0)
	ENDIF

	SetLastError (0)
	IF MakeDragList (hListBox) THEN
		DLM_MESSAGE = RegisterWindowMessageA (&$$DRAGLISTMSGSTRING)
		IFZ DLM_MESSAGE THEN RETURN $$FALSE		' fail
	ENDIF
' GL-new~~~
'
	RETURN $$TRUE		' success
END FUNCTION
'
' #########################################
' #####  WinXAutoSizer_GetMainSeries  #####
' #########################################
' Gets the id of the main auto-sizer series for a window.
' hWnd = the window to get the series for
' returns the index of the main auto-sizer series,
'         or -1 on fail
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
'	WinXDialog_Error (msg$, title$, severity)
'
FUNCTION WinXAutoSizer_GetMainSeries (hWnd)
	BINDING binding

	IFZ hWnd THEN
		hWnd = GetActiveWindow ()
	ENDIF

	'get the binding
	IFZ hWnd THEN RETURN -1		' fail
	IFF binding_get (GetWindowLongA (hWnd, $$GWL_USERDATA), @binding) THEN RETURN -1		' fail

	main_series = binding.autoSizerInfo
	IF main_series < -1 THEN
		main_series = -1		' not an index
	ENDIF
	RETURN main_series
END FUNCTION
'
' ##############################
' #####  WinXDialog_Error  #####
' ##############################
' Displays an error dialog box.
' msg$     = the message to display
' title$   = the title of the message box
' severity = severity of the error
'            0 = debug, 1 = warning, 2 = error, 3 = unrecoverable error
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
		CASE 0 : icon = $$MB_ICONINFORMATION		' = $$MB_ICONASTERISK
		CASE 1 : icon = $$MB_ICONWARNING		' = $$MB_ICONEXCLAMATION
		CASE 2 : icon = $$MB_ICONERROR		' = $$MB_ICONHAND
		CASE 3 : icon = $$MB_ICONSTOP		' = $$MB_ICONHAND
	END SELECT

	hWnd = GetActiveWindow ()
	IFZ title$ THEN title$ = "Alert"

	MessageBoxA (hWnd, &msg$, &title$, $$MB_OK|icon)
'
' 0.6.0.2-old---
'	IF severity = 3 THEN QUIT(0)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	IF severity = 3 THEN
		' Unrecoverable error => Abort Program?
		msg$ = msg$ + "\r\nDo you want to abort this program?"
'		XstAbend (msg$)
		title$ = "Unrecoverable Error"
		mret = WinXDialog_Question (#winMain, msg$, title$, $$FALSE, 1)		' default to the 'No' button
		IF mret = $$IDYES THEN
			' abort is confirmed
			WinXCleanUp ()		' optional cleanup
			QUIT (0)		' abort
		ENDIF
		RETURN $$FALSE
	ENDIF
' 0.6.0.2-new~~~
'
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXProgress_SetPos  #####
' #################################
' Sets the position of a progress bar.
' hProg = the handle to the progress bar
' pos = proportion of progress bar to shade
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXProgress_SetPos (hProg, DOUBLE pos)
	SetLastError (0)
	IFZ hProg THEN RETURN $$FALSE		' fail
	SendMessageA (hProg, $$PBM_SETPOS, 1000*pos, 0)
	RETURN $$TRUE		' success
END FUNCTION
'
' #####################################
' #####  WinXProgress_SetMarquee  #####
' #####################################
' Enables or disables marquee mode.
' hProg = the progress bar
' enable = $$TRUE to enable marquee mode, $$FALSE to disable
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXProgress_SetMarquee (hProg, enable)
	SetLastError (0)
	IFZ hProg THEN RETURN $$FALSE		' fail
	styleOld = GetWindowLongA (hProg, $$GWL_STYLE)
	IF enable THEN
		style = styleOld OR $$PBS_MARQUEE
		fEnable = 1
	ELSE
		style = styleOld AND (NOT $$PBS_MARQUEE)
		fEnable = 0
	ENDIF
	SetWindowLongA (hProg, $$GWL_STYLE, style)
	SendMessageA (hProg, $$PBM_SETMARQUEE, fEnable, 50)
	RETURN $$TRUE		' success
END FUNCTION
'
' #############################
' #####  WinXRegOnScroll  #####
' #############################
' Registers the .onScroll callback function.
' hWnd = the handle to the window to register the callback for
' FnOnScroll = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnScroll (hWnd, FUNCADDR FnOnScroll)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onScroll = FnOnScroll
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' #############################
' #####  WinXScroll_Show  #####
' #############################
' Hides or displays the scrollbars for a window.
' hWnd = the handle to the window to set the scrollbars for
' horiz = $$TRUE to enable the horizontal scrollbar, $$FALSE otherwise
' vert = $$TRUE to enable the vertical scrollbar, $$FALSE otherwise
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXScroll_Show (hWnd, horiz, vert)

	SetLastError (0)
	IFZ hWnd THEN RETURN $$FALSE		' fail
	style = GetWindowLongA (hWnd, $$GWL_STYLE)
	IF horiz THEN style = style|$$WS_HSCROLL ELSE style = style AND NOT $$WS_HSCROLL
	IF vert  THEN style = style|$$WS_VSCROLL ELSE style = style AND NOT $$WS_VSCROLL
	SetWindowLongA (hWnd, $$GWL_STYLE, style)
	SetWindowPos (hWnd, 0, 0, 0, 0, 0, $$SWP_NOMOVE|$$SWP_NOSIZE|$$SWP_NOZORDER|$$SWP_FRAMECHANGED)
	RETURN $$TRUE		' success

END FUNCTION
'
' #################################
' #####  WinXScroll_SetRange  #####
' #################################
' Sets the range the scrollbar moves through.
' hWnd = the handle to the window the scrollbar belongs to
' direction = the direction of the scrollbar
' min = the minimum value of the range
' max = the maximum value of the range
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXScroll_SetRange (hWnd, direction, min, max)
	SCROLLINFO si
	RECT rect

	SetLastError (0)
	IFZ hWnd THEN RETURN $$FALSE		' fail

	' clear flag $$DIR_REVERSE of direction
	SELECT CASE direction AND 0x00000003
		CASE $$DIR_HORIZ
			typeBar = $$SB_HORZ
		CASE $$DIR_VERT
			typeBar = $$SB_VERT
		CASE ELSE
			RETURN $$FALSE
	END SELECT

	si.cbSize	= SIZE(SCROLLINFO)
	si.fMask	= $$SIF_RANGE|$$SIF_DISABLENOSCROLL
	si.nMin		= min
	si.nMax		= max

	SetScrollInfo (hWnd, typeBar, &si, 1)		' redraw

	GetClientRect (hWnd, &rect)
	sizeWindow (hWnd, rect.right, rect.bottom)		' resize the  window

	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXScroll_SetPage  #####
' ################################
' Sets the page size mapping function.
' hWnd = the handle to the window containing the scroll bar
' direction = the direction of the scrollbar to set the info for
' mul = the number to multiply the window width/height by to get the page width/height
' constant = the constant to add to the page width/height
' scrollUnit = the number of units to scroll by when the arrows are clicked
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXScroll_SetPage (hWnd, direction, DOUBLE mul, constant, scrollUnit)
	BINDING	binding
	RECT rect
	SCROLLINFO si

	SetLastError (0)

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	SetLastError (0)
	ret = GetClientRect (hWnd, &rect)
	IFZ ret THEN
		msg$ = "WinXScroll_SetPage: Can't get the client rectangle of the window"
		GuiTellApiError (msg$)
		RETURN $$FALSE		' fail
	ENDIF

	si.cbSize = SIZE(SCROLLINFO)
	si.fMask = $$SIF_PAGE|$$SIF_DISABLENOSCROLL

	' clear flag $$DIR_REVERSE of direction
	SELECT CASE direction AND 0x00000003
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

	bOK = binding_update (idBinding, binding)
	SetScrollInfo (hWnd, typeBar, &si, 1)		' redraw

	RETURN bOK
END FUNCTION
'
' #################################
' #####  WinXRegOnTrackerPos  #####
' #################################
' Registers the .onTrackerPos callback function.
' hWnd = the handle of the window to register the callback for
' FnOnTrackerPos = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnTrackerPos (hWnd, FUNCADDR FnOnTrackerPos)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onTrackerPos = FnOnTrackerPos
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ################################
' #####  WinXTracker_GetPos  #####
' ################################
' Gets the position of the slider in a tracker bar control.
' hTracker = the handle to the tracker
' returns the position of the slider or 0 on fail
FUNCTION WinXTracker_GetPos (hTracker)
	SetLastError (0)
	IFZ hTracker THEN RETURN 0		' fail
	RETURN SendMessageA (hTracker, $$TBM_GETPOS, 0, 0)
END FUNCTION
'
' ################################
' #####  WinXTracker_SetPos  #####
' ################################
' Sets the position of the slider in a trackbar control.
' hTracker = the handle to the tracker
' newPos = the new position of the slider
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTracker_SetPos (hTracker, newPos)
	SetLastError (0)
	IFZ hTracker THEN RETURN $$FALSE		' fail
	SendMessageA (hTracker, $$TBM_SETPOS, $$TRUE, newPos)
	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  WinXTracker_SetRange  #####
' ##################################
' Sets the range for a trackbar control.
' hTracker = the control to set the range for
' min = the minimum value for the tracker
' max = the maximum value for the tracker
' ticks = the number of units per tick
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTracker_SetRange (hTracker, USHORT min, USHORT max, ticks)
	SetLastError (0)
	IFZ hTracker THEN RETURN $$FALSE		' fail
	SendMessageA (hTracker, $$TBM_SETRANGE, 1, MAKELONG(min, max))
	SendMessageA (hTracker, $$TBM_SETTICFREQ, ticks, 0)
	RETURN $$TRUE		' success
END FUNCTION
'
' #####################################
' #####  WinXTracker_SetSelRange  #####
' #####################################
' Sets the selection range for a tracker control.
' hTracker = the handle to the tracker
' start = the start of the selection
' end  = the end of the selection
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTracker_SetSelRange (hTracker, USHORT start, USHORT end)
	SetLastError (0)
	IFZ hTracker THEN RETURN $$FALSE		' fail
	SendMessageA (hTracker, $$TBM_SETSEL, 1, MAKELONG(start, end))
	RETURN $$TRUE		' success
END FUNCTION
'
' ###################################
' #####  WinXTracker_SetLabels  #####
' ###################################
' Sets the labels for the start and end of a trackbar control.
' hTracker = the handle to the tracker control
' leftLabel = the label for the left of the tracker
' rightLabel = the label for the right of the tracker
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTracker_SetLabels (hTracker, STRING leftLabel, STRING rightLabel)
	SIZEAPI left
	SIZEAPI right

	SetLastError (0)
	IFZ hTracker THEN RETURN $$FALSE		'fail

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
	hdcMem = 0

	'now create the windows
	parent = GetParent (hTracker)
	hLeft = WinXAddStatic (parent, leftLabel, 0, $$SS_CENTER, 1)
	hRight = WinXAddStatic (parent, rightLabel, 0, $$SS_CENTER, 1)
	MoveWindow (hLeft, 0, 0, left.cx+4, left.cy+4, 1)		' repaint
	MoveWindow (hRight, 0, 0, right.cx+4, right.cy+4, 1)		' repaint

	'and set them
	SendMessageA (hTracker, $$TBM_SETBUDDY, $$TRUE, hLeft)
	SendMessageA (hTracker, $$TBM_SETBUDDY, $$FALSE, hRight)

	RETURN $$TRUE		' success
END FUNCTION
'
' ###############################
' #####  WinXScroll_Update  #####
' ###############################
' Updates the client area of a window after a scroll.
' hWnd = the handle to the window to scroll
' deltaX = the distance to scroll horizontally
' deltaY = the distance to scroll vertically
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXScroll_Update (hWnd, deltaX, deltaY)
	RECT rect

	SetLastError (0)
	IFZ hWnd THEN RETURN $$FALSE		' fail
	ret = GetClientRect (hWnd, &rect)
	IFZ ret THEN
		msg$ = "WinXScroll_Update: Can't get the client rectangle of the window"
		GuiTellApiError (msg$)
	ENDIF

	SetLastError (0)
	ScrollWindowEx (hWnd, deltaX, deltaY, 0, &rect, 0, 0, $$SW_ERASE|$$SW_INVALIDATE)
	RETURN $$TRUE		' success
END FUNCTION
'
' ###############################
' #####  WinXScroll_Scroll  #####
' ###############################
' hWnd = the handle to the window to scroll
' direction = the direction to scroll in
' unitType = the type of unit to scroll by
' scrollDirection = + to scroll up, - to scroll down
' returns $$TRUE on success or $$FALSE on fail
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
	i = ABS(scrollingDirection)
	IF i THEN
		' clear flag $$DIR_REVERSE of direction
		SELECT CASE direction AND 0x00000003
			CASE $$DIR_HORIZ : wMsg = $$WM_HSCROLL
			CASE $$DIR_VERT  : wMsg = $$WM_VSCROLL
		END SELECT
	ENDIF

	IF wMsg THEN
		'scroll i times
		FOR j = 1 TO i
			SendMessageA (hWnd, wMsg, wParam, 0)
		NEXT j
		RETURN $$TRUE		' success
	ENDIF

END FUNCTION
'
' #######################################
' #####  WinXEnableDialogInterface  #####
' #######################################
' Enables or disables the dialog interface.
' hWnd = the handle to the window to enable or disable the dialog interface for
' enable = $$TRUE to enable the dialog interface, otherwise $$FALSE
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXEnableDialogInterface (hWnd, enable)
	BINDING	binding

	SetLastError (0)
	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

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
	RETURN bOK
END FUNCTION
'
' ##########################
' #####  WinXAni_Play  #####
' ##########################
' Starts playing an animation control.
' hAni = the animation control to play
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAni_Play (hAni)
	SetLastError (0)
	IFZ hAni THEN RETURN $$FALSE		' fail
	wFrom = 0		' zero-based index of the frame where playing begins
	wTo = -1		' -1 means end with the last frame in the AVI clip
	lParam = MAKELONG (wFrom, wTo)
	ret = SendMessageA (hAni, $$ACM_PLAY, -1, lParam)
	IFZ ret THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ##########################
' #####  WinXAni_Stop  #####
' ##########################
' Stops playing an animation control.
' hAni = the animation control to stop playing
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAni_Stop (hAni)
	SetLastError (0)
	IFZ hAni THEN RETURN $$FALSE		' fail
	IFZ SendMessageA (hAni, $$ACM_STOP, 0, 0) THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  WinXListBox_SetCaret  #####
' ##################################
' Sets the caret item for a list box control.
' hListBox = the handle to the list box to set the caret for
' item     = the item to move the caret to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListBox_SetCaret (hListBox, item)
	SetLastError (0)
	IFZ hListBox THEN RETURN $$FALSE		' fail
	IF $$LB_ERR == SendMessageA (hListBox, $$LB_SETCARETINDEX, item, $$FALSE) THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ##########################
' #####  WinXSetStyle  #####
' ##########################
' Changes the window style of a window or a control.
' hwnd     = the handle to the window or control the change the style of
' styleAdd = the styles to add
' addEx    = the extended styles to add
' styleSub = the styles to remove
' subEx    = the extended styles to remove
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetStyle (hwnd, styleAdd, addEx, styleSub, subEx)

	SetLastError (0)
	IFZ hwnd THEN RETURN $$FALSE		' fail

	bOK = $$TRUE		' assume success

	SELECT CASE TRUE
		CASE styleAdd = styleSub
			' do nothing
			'
		CASE ELSE
			styleOld = GetWindowLongA (hwnd, $$GWL_STYLE)
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
			SetWindowLongA (hwnd, $$GWL_STYLE, styleNew)
			'
			' GL-18mar12-add or remove $$ES_READONLY flag with:
			' SendMessageA (handle, $$EM_SETREADONLY, On/off, 0)
			state = -1
			IF styleAdd & $$ES_READONLY THEN state = 1		' if $$ES_READONLY in styleAdd => read only
			IF styleSub & $$ES_READONLY THEN state = 0		' if $$ES_READONLY in styleSub => unprotected
			'
			IF state >= 0 THEN SendMessageA (hwnd, $$EM_SETREADONLY, state, 0)
			'
			' check update
			update = GetWindowLongA (hwnd, $$GWL_STYLE)
			IF update <> styleNew THEN bOK = $$FALSE		' fail
			'
	END SELECT

	SELECT CASE TRUE
		CASE addEx = subEx
			' do nothing
			'
		CASE ELSE
			exStyleOld = GetWindowLongA (hwnd, $$GWL_EXSTYLE)
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
			' list view control's extended styleNew mask is set using:
			' SendMessageA (handle, $$LVM_SETEXTENDEDLISTVIEWSTYLE, ...
			sizeBuf = 128
			szBuf$ = NULL$ (sizeBuf)
			ret = GetClassNameA (hwnd, &szBuf$, sizeBuf)
			class$ = TRIM$ (CSTRING$ (&szBuf$))
			SELECT CASE class$
				CASE $$WC_LISTVIEW
					SendMessageA (hwnd, $$LVM_SETEXTENDEDLISTVIEWSTYLE, 0, exStyleNew)
					update = SendMessageA (hwnd, $$LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
					'
				CASE $$WC_TABCONTROL
					SendMessageA (hwnd, $$TB_SETEXTENDEDSTYLE, 0, exStyleNew)
					update = SendMessageA (hwnd, $$TB_GETEXTENDEDSTYLE, 0, 0)
					'
				CASE ELSE
					SetWindowLongA (hwnd, $$GWL_EXSTYLE, exStyleNew)
					update = GetWindowLongA (hwnd, $$GWL_EXSTYLE)
					'
			END SELECT
			'
			' check update
			IF update <> exStyleNew THEN bOK = $$FALSE		' fail
			'
	END SELECT

	RETURN bOK

END FUNCTION
'
' ##################################
' #####  WinXTreeView_AddItem  #####
' ##################################
' Adds an item to a tree view control.
' hTreeView  = the handle to the tree view control to add the item to
' parent     = The parent item, 0 or $$TVI_ROOT for root
' hNodeAfter = The node to insert after, can be $$TVI_FIRST or $$TVI_LAST
' iImage     = the index of the image for this item
' iImageSel  = the index of the image to use when the item is expanded
' label$     = the text for the item
' returns a handle to the item or 0 on fail
'
' Usage:
' hNodeAdd = WinXTreeView_AddItem (hTreeView, hTree_root, $$TVI_LAST, 5, 4, label$)		' add last
' IF hNodeAdd < 0 THEN
'		msg$ = "WinXTreeView_AddItem: Can't add treeview item '" + label$ + "'"
'		XstAlert (msg$)
' ENDIF
'
FUNCTION WinXTreeView_AddItem (hTreeView, parent, hNodeAfter, iImage, iImageSelect, label$)
	TV_INSERTSTRUCT tvis
	TV_ITEM tvi

	SetLastError (0)
	IFZ hTreeView THEN RETURN 0		' fail
	IFZ parent THEN
		parent = $$TVI_ROOT
		hNodeAfter = $$TVI_LAST
	ENDIF

	tvis.hParent = parent
	tvis.hInsertAfter = hNodeAfter

	tvi.mask = $$TVIF_IMAGE|$$TVIF_SELECTEDIMAGE|$$TVIF_TEXT|$$TVIF_PARAM
	tvi.pszText = &label$
	tvi.cchTextMax = LEN(label$)
	tvi.iImage = iImage
	tvi.iSelectedImage = iImageSelect
	tvi.lParam = 0		' no data

	tvis.item = tvi

	SetLastError (0)
	r_hNode = SendMessageA (hTreeView, $$TVM_INSERTITEM, 0, &tvis)
	RETURN r_hNode
END FUNCTION
'
' ######################################
' #####  WinXTreeView_GetNextItem  #####
' ######################################
' Gets the next item in the tree view
' hTreeView = the handle to the tree view
' hItem = the handle to the item to start from
' returns a handle to the next item or 0 on fail
FUNCTION WinXTreeView_GetNextItem (hTreeView, hItem)
	IFZ hTreeView THEN RETURN 0		' fail
	RETURN SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_NEXT, hItem)
END FUNCTION
'
' #######################################
' #####  WinXTreeView_GetChildItem  #####
' #######################################
' Gets the first child of an item in a tree view control.
' hTreeView = the handle to the tree view
' hNode     = the item to get the first child from
' returns a handle to the child item or 0 on fail
FUNCTION WinXTreeView_GetChildItem (hTreeView, hNode)
	SetLastError (0)
	IFZ hTreeView THEN RETURN 0		' fail
	IFZ hNode THEN
		' get a handle to the treeview root
		hNode = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_ROOT, 0)
	ENDIF
	IFZ hNode THEN RETURN $$FALSE		' fail
	SetLastError (0)
	ret = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_CHILD, hNode)
	RETURN ret
END FUNCTION
'
' ########################################
' #####  WinXTreeView_GetParentItem  #####
' ########################################
' Gets the parent of an item in a tree view.
' hTreeView = the handle to the tree view
' hNode     = the item to get the parent of
' returns a handle to the parent, or $$TVI_ROOT if hItem has no parent or 0 on fail
FUNCTION WinXTreeView_GetParentItem (hTreeView, hNode)
	SetLastError (0)
	IFZ hTreeView THEN RETURN 0		' fail
	IFZ hNode THEN RETURN 0		' fail
	ret = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_PARENT, hNode)
	RETURN ret
END FUNCTION
'
' ##########################################
' #####  WinXTreeView_GetPreviousItem  #####
' ##########################################
' Gets the item that comes before a given item.
' hTreeView = the handle to the tree view
' hNode     = the handle to the item
' returns a handle to the previous item or 0 on fail
FUNCTION WinXTreeView_GetPreviousItem (hTreeView, hNode)
	SetLastError (0)
	IFZ hTreeView THEN RETURN 0		' fail
	IFZ hNode THEN RETURN 0		' fail
	ret = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_PREVIOUS, hNode)
	RETURN ret
END FUNCTION
'
' #####################################
' #####  WinXTreeView_DeleteItem  #####
' #####################################
' Delete an item, including all children.
' hTreeView = the handle to the tree view
' hNode     = the handle to the item to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTreeView_DeleteItem (hTreeView, hNode)
	SetLastError (0)
	IFZ hTreeView THEN RETURN $$FALSE		' fail
	IFZ hNode THEN RETURN $$FALSE		' fail
	ret = SendMessageA (hTreeView, $$TVM_DELETEITEM, 0, hNode)
	IFZ ret THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' #######################################
' #####  WinXTreeView_GetSelection  #####
' #######################################
' Gets the current selection from a tree view control.
' hTreeView = the tree view control
' returns a handle to the selected item or 0 on fail
FUNCTION WinXTreeView_GetSelection (hTreeView)
	SetLastError (0)
	IFZ hTreeView THEN RETURN 0		' fail
	hNode = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_CARET, hItem)
	IFZ hNode THEN RETURN 0		' fail
	RETURN hNode		' success
END FUNCTION
'
' #######################################
' #####  WinXTreeView_SetSelection  #####
' #######################################
' Sets the selection for a tree view control.
' hTreeView = the handle to the tree view
' hNode     = the handle to the item to set the selection to, 0 to remove selection
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTreeView_SetSelection (hTreeView, hNode)
	SetLastError (0)
	IFZ hTreeView THEN RETURN $$FALSE		' fail
	IFZ hNode THEN
		' get a handle to the treeview root
		hNode = SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_ROOT, 0)
	ENDIF
	IFZ hNode THEN RETURN $$FALSE		' fail
	SetLastError (0)
	ret = SendMessageA (hTreeView, $$TVM_SELECTITEM, $$TVGN_CARET, hNode)
	IFZ ret THEN RETURN $$FALSE		' fail
	SetFocus (hTreeView)
	RETURN $$TRUE		' success
END FUNCTION
'
' ########################################
' #####  WinXTreeView_GetItemLabel$  #####
' ########################################
' Gets the label from a treeview item.
' hTreeView = the handle to the treeview
' hNode     = the item to get the label from
' returns the item label or "" on fail
FUNCTION WinXTreeView_GetItemLabel$ (hTreeView, hNode)
	TVITEM tvi

	SetLastError (0)
	IFZ hTreeView THEN RETURN ""		' fail

	tvi.mask = $$TVIF_HANDLE|$$TVIF_TEXT
	tvi.hItem = hNode
	tvi.cchTextMax = 255
	buffer$ = NULL$(tvi.cchTextMax+1)		' ensure always a nul-terminator
	tvi.pszText = &buffer$
	ret = SendMessageA (hTreeView, $$TVM_GETITEM, 0, &tvi)
	IFZ ret THEN RETURN ""		' fail
	ret$ = CSTRING$(tvi.pszText)
	RETURN ret$
END FUNCTION
'
' #######################################
' #####  WinXTreeView_SetItemLabel  #####
' #######################################
' Sets the label attribute for a treeview item.
' hTreeView = the handle to the tree view control
' hNode     = the item to set the label for
' newLabel$ = the new label
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTreeView_SetItemLabel (hTreeView, hNode, newLabel$)
	TVITEM tvi

	SetLastError (0)
	IFZ hTreeView THEN RETURN $$FALSE		' fail

	tvi.mask = $$TVIF_HANDLE|$$TVIF_TEXT
	tvi.hItem = hNode
	tvi.pszText = &newLabel$
	tvi.cchTextMax = LEN(newLabel$)

	ret = SendMessageA (hTreeView, $$TVM_SETITEM, 0, &tvi)
	IFZ ret THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXRegOnLabelEdit  #####
' ################################
' Registers the .onLabelEdit callback function.
' hWnd          = the window to register the callback for
' FnOnLabelEdit = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnLabelEdit (hWnd, FUNCADDR FnOnLabelEdit)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onLabelEdit = FnOnLabelEdit
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ###################################
' #####  WinXTreeView_CopyItem  #####
' ###################################
' Copies a treeview item and its children.
' hTreeView   = the handle to the tree view control
' hNodeParent = The parent of the item to move this item to
' hNodeAfter  = The item that will come before this item
' hNodeToMove = the item to move
' returns the new handle to the copied item or 0 on fail
FUNCTION WinXTreeView_CopyItem (hTreeView, hNodeParent, hNodeAfter, hNodeToMove)
	TV_ITEM tvi
	TV_INSERTSTRUCT tvis
	XLONG new_handle		' handle to the copied item

	SetLastError (0)
	IFZ hTreeView THEN RETURN 0		' fail
	IFZ hNodeToMove THEN RETURN 0		' fail

	'get item hNodeToMove
	tvi.mask = $$TVIF_CHILDREN|$$TVIF_HANDLE|$$TVIF_IMAGE|$$TVIF_PARAM|$$TVIF_SELECTEDIMAGE|$$TVIF_STATE|$$TVIF_TEXT
	tvi.hItem = hNodeToMove
	tvi.cchTextMax = 512
	buffer$ = NULL$(tvi.cchTextMax+1)		' ensure always a nul-terminator
	tvi.pszText = &buffer$
	tvi.stateMask = 0xFFFFFFFF

	SetLastError (0)
	ret = SendMessageA (hTreeView, $$TVM_GETITEM, 0, &tvi)
	IFZ ret THEN
		msg$ = "WinXTreeView_CopyItem: Can't get item at node " + STRING$ (hNodeToMove)
		GuiTellApiError (msg$)
		RETURN 0		' fail
	ENDIF

	' insert node
	tvis.hParent = hNodeParent
	tvis.hInsertAfter = hNodeAfter
	tvis.item = tvi
	tvis.item.mask = $$TVIF_IMAGE|$$TVIF_PARAM|$$TVIF_SELECTEDIMAGE|$$TVIF_STATE|$$TVIF_TEXT
	tvis.item.cChildren = 0

	SetLastError (0)
'	tvis.item.hItem = SendMessageA (hTreeView, $$TVM_INSERTITEM, 0, &tvis)
	new_handle = SendMessageA (hTreeView, $$TVM_INSERTITEM, 0, &tvis)
	IFZ new_handle THEN
		msg$ = "WinXTreeView_CopyItem: Can't insert item after node " + STRING$ (hNodeAfter)
		GuiTellApiError (msg$)
		RETURN 0		' fail
	ENDIF

	IF tvi.cChildren > 0 THEN
		prevChild = $$TVI_FIRST
		child = WinXTreeView_GetChildItem (hTreeView, hNodeToMove)
		DO WHILE child
			WinXTreeView_CopyItem (hTreeView, new_handle, prevChild, child)
			prevChild = child
			child = WinXTreeView_GetNextItem (hTreeView, prevChild)
		LOOP
	ENDIF

	' return the handle to the copied item
	RETURN new_handle

END FUNCTION
'
' #############################
' #####  WinXTabs_AddTab  #####
' #############################
' Adds a new tab to a tabs control.
' hTabs       = the handle to the tabs control
' label$      = the label for the new tab
' insertAfter = the index to insert at, -1 for to append
' returns the index of the new tab or -1 on fail
FUNCTION WinXTabs_AddTab (hTabs, label$, insertAfter)
	TC_ITEM tci		' tabs control structure

	SetLastError (0)
	IFZ hTabs THEN RETURN -1		' fail

	tci.mask = $$TCIF_PARAM|$$TCIF_TEXT
	tci.pszText = &label$
	tci.cchTextMax = LEN(label$)
	tci.lParam = autoSizerInfo_addGroup ($$DIR_VERT)		' (GL: autoSizerInfo_addGroup returns an index compatible with tci.lParam)

	IF insertAfter < 0 THEN
		index = SendMessageA (hTabs, $$TCM_GETITEMCOUNT, 0, 0)
	ELSE
		index = insertAfter
	ENDIF

	SetLastError (0)
	r_index = SendMessageA (hTabs, $$TCM_INSERTITEM, index, &tci)
	IF r_index < 0 THEN RETURN -1		' fail
	RETURN r_index		' success
END FUNCTION
'
' ################################
' #####  WinXTabs_DeleteTab  #####
' ################################
' Deletes a tab in a tabs control.
' hTabs = the handle the tabs control
' iTab = the index of the tab to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTabs_DeleteTab (hTabs, iTab)
	SetLastError (0)
	IFZ hTabs THEN RETURN $$FALSE		' fail
	ret = SendMessageA (hTabs, $$TCM_DELETEITEM, iTab, 0)
	IF ret THEN RETURN $$TRUE		' success
END FUNCTION
'
' ########################################
' #####  WinXTab_GetAutosizerSeries  #####
' ########################################
' Gets the auto-sizer series for a tab.
' hTabs = the tabs control
' iTab = the index of the tab to get the auto-sizer series for
' returns the index of the auto-sizer series or -1 on fail
FUNCTION WinXTabs_GetAutosizerSeries (hTabs, iTab)
	TC_ITEM tci		' tabs control structure

	SetLastError (0)
	IFZ hTabs THEN RETURN -1		' fail
	tci.mask = $$TCIF_PARAM
	ret = SendMessageA (hTabs, $$TCM_GETITEM, iTab, &tci)
	IFZ ret THEN RETURN -1		' fail
	series = tci.lParam
	IF series < -1 THEN series = -1		' no series
	RETURN series
END FUNCTION
'
' ####################################
' #####  WinXTabs_GetCurrentTab  #####
' ####################################
' Gets the index of the currently selected tab.
' hTabs = the handle to the tabs control
' returns the index of the currently selected tab
FUNCTION WinXTabs_GetCurrentTab (hTabs)
	SetLastError (0)
	IFZ hTabs THEN RETURN -1		' fail
	RETURN SendMessageA (hTabs, $$TCM_GETCURSEL, 0, 0)
END FUNCTION
'
' ####################################
' #####  WinXTabs_SetCurrentTab  #####
' ####################################
' Sets the current tab.
' hTabs = the tabs control
' iTab = the index of the new current tab
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTabs_SetCurrentTab (hTabs, iTab)

	SetLastError (0)
	IFZ hTabs THEN RETURN $$FALSE		' fail
	count = SendMessageA (hTabs, $$TCM_GETITEMCOUNT, 0, 0)
	IF count > 0 THEN
		uppTab = count - 1
		'
		IF iTab < 0 THEN iTab = 0		' select first tabstrip
		IF iTab > uppTab THEN iTab = uppTab		' select last tabstrip
		'
		ret = SendMessageA (hTabs, $$TCM_SETCURSEL, iTab, 0)
		IFZ ret THEN RETURN $$FALSE		' fail
	ENDIF
	RETURN $$TRUE		' success

END FUNCTION
'
' #########################################
' #####  WinXToolbar_AddToggleButton  #####
' #########################################
' Adds a toggle button to a toolbar.
' hToolbar     = the handle to the toolbar
' commandId    = the command constant the button will generate
' iImage       = the zero-based index of the image for this button
' toolTipText$ = the text for this button's tooltip
' mutex        = $$TRUE if this toggle is mutually exclusive, ie. only one from a group can be toggled at a time
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddToggleButton (hToolbar, commandId, iImage, toolTipText$, mutex, optional, moveable)
	TBBUTTON bt

	SetLastError (0)
	IFZ hToolbar THEN RETURN $$FALSE		' fail

	bt.iBitmap = iImage
	bt.idCommand = commandId
	bt.fsState = $$TBSTATE_ENABLED
	bt.iString = &toolTipText$

	IF mutex THEN
		bt.fsStyle = $$BTNS_CHECKGROUP
	ELSE
		bt.fsStyle = $$BTNS_CHECK
	ENDIF
	bt.fsStyle = bt.fsStyle|$$BTNS_AUTOSIZE

	SetLastError (0)
	ret = SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	IFZ ret THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ######################################
' #####  WinXToolbar_AddSeparator  #####
' ######################################
' Adds a button separator to a toolbar.
' hToolbar = the toolbar to add the separator to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddSeparator (hToolbar)
	TBBUTTON bt

	IFZ hToolbar THEN RETURN $$FALSE		' fail

	bt.iBitmap = 4
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_SEP

	ret = SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	IF ret THEN RETURN $$TRUE		' success
END FUNCTION
'
' ####################################
' #####  WinXToolbar_AddControl  #####
' ####################################
' Adds a control to a toolbar control.
' hToolbar = the handle to the toolbar to add the control to
' hControl = the handle to the control
' w = the width of the control in the toolbar, the control will be resized to the height of the toolbar and this width
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddControl (hToolbar, hControl, w)
	TBBUTTON bt
	RECT rect2

	SetLastError (0)
	IFZ hToolbar THEN RETURN $$FALSE		' fail

	bt.iBitmap = w+4
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_SEP

	iControl = SendMessageA (hToolbar, $$TB_BUTTONCOUNT, 0, 0)
	SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	SendMessageA (hToolbar, $$TB_GETITEMRECT, iControl, &rect2)

	MoveWindow (hControl, rect2.left+2, rect2.top, w, rect2.bottom-rect2.top, $$TRUE)

	SetParent (hControl, hToolbar)

	RETURN $$TRUE		' success
END FUNCTION
'
' ######################################
' #####  WinXToolbar_EnableButton  #####
' ######################################
' Enables or disables a toolbar button.
' hToolbar = the handle to the toolbar on which the button resides
' idButton = the command id of the button
' enable = $$TRUE to enable the button, $$FALSE to disable
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_EnableButton (hToolbar, idButton, enable)
	SetLastError (0)
	IFZ hToolbar THEN RETURN $$FALSE		' fail
'
' GL-old---
'	RETURN SendMessageA (hToolbar, $$TB_ENABLEBUTTON, idButton, enable)
' GL-old~~~
' GL-new+++
	IF enable THEN
		fEnable = 1
	ELSE
		fEnable = 0
	ENDIF
	SetLastError (0)
	ret = SendMessageA (hToolbar, $$TB_ENABLEBUTTON, idButton, fEnable)
	IF ret THEN RETURN $$TRUE		' success
	RETURN $$FALSE		' fail
' GL-new~~~
'
END FUNCTION
'
' ######################################
' #####  WinXToolbar_ToggleButton  #####
' ######################################
' Toggles a toolbar button.
' hToolbar = the handle to the toolbar on which the button resides
' idButton = the command id of the button
' on = $$TRUE to toggle the button on, $$FALSE to toggle the button off
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_ToggleButton (hToolbar, idButton, on)
	SetLastError (0)
	IFZ hToolbar THEN RETURN $$FALSE		' fail
	state = SendMessageA (hToolbar, $$TB_GETSTATE, idButton, 0)
	IF on THEN state = state|$$TBSTATE_CHECKED ELSE state = state AND NOT ($$TBSTATE_CHECKED)
	SendMessageA (hToolbar, $$TB_SETSTATE, idButton, state)
	RETURN $$TRUE		' success
END FUNCTION
'
' #######################################
' #####  WinXComboBox_GetEditText$  #####
' #######################################
' Gets the text in the edit control of a combo box.
' hCombo = the handle to the combo box
' returns the text or an empty string on fail
FUNCTION WinXComboBox_GetEditText$ (hCombo)
	SetLastError (0)
	IFZ hCombo THEN RETURN ""		' fail
	hEdit = SendMessageA (hCombo, $$CBEM_GETEDITCONTROL, 0, 0)
	IFZ hEdit THEN RETURN ""		' fail
	text$ = WinXGetText$ (hEdit)
	RETURN text$		' success
END FUNCTION
'
' ######################################
' #####  WinXComboBox_SetEditText  #####
' ######################################
' Sets the text in the edit control for a combo box.
' hCombo = the handle to the combo box
' text$  = the text to put in the control
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXComboBox_SetEditText (hCombo, text$)
	SetLastError (0)
	IFZ hCombo THEN RETURN $$FALSE		' fail
	hEdit = SendMessageA (hCombo, $$CBEM_GETEDITCONTROL, 0, 0)
	IFZ hEdit THEN RETURN $$FALSE		' fail
'
' 0.6.0.1-old---
'	WinXSetText (hCombo, text$)
' 0.6.0.1-old~~~
' 0.6.0.1-new+++
	WinXSetText (hEdit, text$)
' 0.6.0.1-new~~~
'
	SetLastError (0)		' reset any error code
	RETURN $$TRUE		' success
END FUNCTION
'
' #############################
' #####  WinXAddGroupBox  #####
' #############################
' Creates a new group box
' and adds it to the specified window.
' parent = the parent window
' text$  = the label for the group box
' id     = the unique id for this control
' returns a handle to the new group box or 0 on fail
FUNCTION WinXAddGroupBox (parent, text$, id)
	SetLastError (0)
	style = $$WS_CHILD|$$WS_VISIBLE|$$BS_GROUPBOX
	hGB = CreateWindowExA (0, &$$BUTTON, &text$, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hGB THEN RETURN 0		' fail
	SendMessageA (hGB, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	SetPropA (hGB, &$$LeftSubSizer$, &sizeGroupBoxContents())
'
' GL-10oct22-old---
'	SetPropA (hGB, &$$AutoSizer$, autoSizerInfo_addGroup ($$DIR_VERT))
' GL-10oct22-old~~~
' GL-10oct22-new+++
	' add an auto-sizer to group box
	series = autoSizerInfo_addGroup ($$DIR_VERT)
	SetPropA (hGB, &$$AutoSizer$, series)
	IF series < 0 THEN
		msg$ = "WinXAddGroupBox: Can't add auto-sizer to group box, series = " + STRING$ (series)
		WinXDialog_Error (msg$, "WinX-Debug", 2)
	ENDIF
' GL-10oct22-new~~~
'
	RETURN hGB
END FUNCTION
'
' #############################################
' #####  WinXGroupBox_GetAutosizerSeries  #####
' #############################################
' Gets the auto-sizer series for a group box.
' hGB = the handle to the group box
' returns the group box's series or -1 on fail
'
' Usage:
'	group_series = WinXGroupBox_GetAutosizerSeries (#myGroup)
'
FUNCTION WinXGroupBox_GetAutosizerSeries (hGB)
	SetLastError (0)
	IFZ hGB THEN RETURN -1		' fail
	ret = GetPropA (hGB, &$$AutoSizer$)
	IFZ ret THEN RETURN -1		' fail
	RETURN ret		' success
END FUNCTION
'
' #############################
' #####  WinXDrawEllipse  #####
' #############################
' Draws an ellipse.
' returns the id of the drawn ellipse or 0 on fail
FUNCTION WinXDrawEllipse (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFZ hWnd THEN RETURN 0		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN 0		' fail

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
	bOK = binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw
END FUNCTION
'
' ##########################
' #####  WinXDrawRect  #####
' ##########################
' Draws a rectangle.
' returns the id of the drawn rectangle or 0 on fail
FUNCTION WinXDrawRect (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFZ hWnd THEN RETURN 0		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN 0		' fail

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
	bOK = binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw
END FUNCTION
'
' ############################
' #####  WinXDrawBezier  #####
' ############################
' Draws a bezier spline.
' returns the id of the drawn bezier spline or 0 on fail
FUNCTION WinXDrawBezier (hWnd, hPen, x1, y1, x2, y2, xC1, yC1, xC2, yC2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFZ hWnd THEN RETURN 0		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN 0		' fail

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
	bOK = binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw
END FUNCTION
'
' #########################
' #####  WinXDrawArc  #####
' #########################
' Draws an arc.
' returns the id of the draw operation or 0 on fail
FUNCTION WinXDrawArc (hWnd, hPen, x1, y1, x2, y2, DOUBLE theta1, DOUBLE theta2)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFZ hWnd THEN RETURN 0		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN 0		' fail

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
	bOK = binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw
END FUNCTION
'
' ################################
' #####  WinXDrawFilledArea  #####
' ################################
' Fills an enclosed area with a brush.
' returns the id of the drawn filled area or 0 on fail
FUNCTION WinXDrawFilledArea (hWnd, hBrush, colBound, x, y)
	AUTODRAWRECORD	record
	BINDING			binding
	RECT rect

	SetLastError (0)

	'get the binding
	IFZ hWnd THEN RETURN 0		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN 0		' fail

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
	bOK = binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw
END FUNCTION
'
' ############################
' #####  WinXRegOnClose  #####
' ############################
' Registers the .onClose callback function.
FUNCTION WinXRegOnClose (hWnd, FUNCADDR FnOnClose)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onClose = FnOnClose
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' #########################################
' #####  WinXAutoSizer_SetSimpleInfo  #####
' #########################################
' A simplified version of WinXAutoSizer_SetInfo.
'
' Usage:
'	space# = 0.03		' space (3%)
'	size# = 1.0		' size (100%)
'	WinXAutoSizer_SetSimpleInfo (#childControl, WinXTabs_GetAutosizerSeries (#tabsControl, 0), space#, size#, 0)
'
FUNCTION WinXAutoSizer_SetSimpleInfo (hWnd, series, DOUBLE space, DOUBLE size, flags)
'
' 0.6.0.2-old---
'	RETURN WinXAutoSizer_SetInfo (hWnd, series, space, size, 0, 0, 1, 1, flags)
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	SetLastError (0)
	bOK = $$FALSE
	IF hWnd THEN
		' left and top margins: 0%
		x# = 0.0		' left margin (0%)
		y# = 0.0		' top margin (0%)

		' width and height: 100%
		w# = 1.0		' width (100%)
		h# = 1.0		' height (100%)

		bOK = WinXAutoSizer_SetInfo (hWnd, series, space, size, x#, y#, w#, h#, flags)
	ENDIF
	RETURN bOK
' 0.6.0.2-new~~~
'
END FUNCTION
'
' #############################
' #####  WinXAddListView  #####
' #############################
' Creates a new list view control
' and adds it to specified window.
' editable = $$TRUE to enable label editing
' view is a view constant ($$LVS_LIST (default), $$LVS_REPORT, $$LVS_ICON, $$LVS_SMALLICON)
' returns a handle to the new list view control or 0 on fail
FUNCTION WinXAddListView (parent, hilLargeIcons, hilSmallIcons, editable, view, id)
	SetLastError (0)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP
'
' 0.6.0.1-old---
'	style = style|view
' 0.6.0.1-old~~~
' 0.6.0.1-new+++
'
' Defined as a zero view constant (!), $$LVS_ICON makes the list view control go berserk!
'
	IF view <> $$LVS_ICON THEN
		style = style | view
	ENDIF
' 0.6.0.1-new~~~
'
	IF editable THEN style = style|$$LVS_EDITLABELS

	hLV = CreateWindowExA (0, &$$WC_LISTVIEW, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hLV THEN RETURN 0		' fail
	SendMessageA (hLV, $$LVM_SETIMAGELIST, $$LVSIL_NORMAL, hilLargeIcons)
	SendMessageA (hLV, $$LVM_SETIMAGELIST, $$LVSIL_SMALL, hilSmallIcons)
	SendMessageA (hLV, $$LVM_SETEXTENDEDLISTVIEWSTYLE, $$LVS_EX_FULLROWSELECT|$$LVS_EX_LABELTIP, $$LVS_EX_FULLROWSELECT|$$LVS_EX_LABELTIP)
	RETURN hLV
END FUNCTION
'
' ##################################
' #####  WinXListView_SetView  #####
' ##################################
' Sets the view of a list view control.
' hLV = the handle to the control
' view = the view to set
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_SetView (hLV, view)
	SetLastError (0)
	IFZ hLV THEN RETURN $$FALSE		' fail
	style = GetWindowLongA (hLV, $$GWL_STYLE)
	style = (style AND NOT($$LVS_ICON|$$LVS_SMALLICON|$$LVS_LIST|$$LVS_REPORT)) OR view
	SetWindowLongA (hLV, $$GWL_STYLE, style)
END FUNCTION
'
' ####################################
' #####  WinXListView_AddColumn  #####
' ####################################
' Adds a column to a list view control
' for use in reportview control.
' iColumn    = the zero-based index for the new column
' wColumn    = the width of the column
' label = the label for the column
' numSubItem = the 1-based subscript of the sub item the column displays
' returns the index to the new column or -1 on fail
FUNCTION WinXListView_AddColumn (hLV, iColumn, wColumn, STRING label, numSubItem)
	LV_COLUMN lvCol

	SetLastError (0)
	IFZ hLV THEN RETURN -1		' fail
'
' GL-10oct22-old---
'	lvCol.mask = $$LVCF_FMT OR $$LVCF_ORDER OR $$LVCF_SUBITEM OR $$LVCF_TEXT OR $$LVCF_WIDTH
' GL-10oct22-old~~~
' GL-10oct22-new+++
	lvCol.mask = $$LVCF_FMT OR $$LVCF_WIDTH OR $$LVCF_TEXT OR $$LVCF_SUBITEM		' OR $$LVCF_ORDER?
' GL-10oct22-new~~~
'
	lvCol.fmt = $$LVCFMT_LEFT
	lvCol.cx = wColumn
	lvCol.pszText = &label
'
' GL-10oct22-new+++
	lvCol.cchTextMax = LEN (label)
' GL-10oct22-new~~~
'
	lvCol.iOrder = numSubItem
	lvCol.iSubItem = iColumn		' specifies the index of subitem associated with column
'
' GL-10oct22-old---
'	RETURN SendMessageA (hLV, $$LVM_INSERTCOLUMN, iColumn, &lvCol)
' GL-10oct22-old~~~
' GL-10oct22-new+++
	ret = SendMessageA (hLV, $$LVM_INSERTCOLUMN, iColumn, &lvCol)
	IF ret >= 0 THEN RETURN ret		' success
	RETURN -1		' fail
' GL-10oct22-new~~~
'
END FUNCTION
'
' #######################################
' #####  WinXListView_DeleteColumn  #####
' #######################################
' Deletes a column in a list view control.
' iColumn = the zero-based index of the column to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_DeleteColumn (hLV, iColumn)
	IFZ hLV THEN RETURN $$FALSE		' fail
	IFZ SendMessageA (hLV, $$LVM_DELETECOLUMN, iColumn, 0) THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  WinXListView_AddItem  #####
' ##################################
' Adds a new item to a list view control.
' iItem = the index at which to insert the item, -1 to add to the end of the list
' item$ = the label for the main item plus the sub-items
'         as: "label\0subItem1\0subItem2...",
'         or: "label|subItem1|subItem2...".
' iIcon = the index to the icon/image or -1 if this item has no icon
' returns the index of the new item or -1 on fail
'
' Usage:
'	item$ = "Item 1|E|A|5"
'	indexAdd = WinXListView_AddItem (hLV, -1, item$, -1)		' add last
'	IF indexAdd < 0 THEN
'		msg$ = "WinXListView_AddItem: Can't add list view item '" + item$ + "'"
'		XstAlert (msg$)
'	ENDIF
'
FUNCTION WinXListView_AddItem (hLV, iItem, item$, iIcon)

	LV_ITEM lvi

	SetLastError (0)
	indexAdd = -1		' not an index

	SELECT CASE hLV
		CASE 0
			'
		CASE ELSE
			source$ = TRIM$ (item$)
			IFZ source$ THEN EXIT SELECT	' fail
			'
			' Replace all embedded zero-characters by separator "|".
			FOR i = LEN (source$) - 1 TO 0 STEP -1
				IFZ source${i} THEN source${i} = '|'
			NEXT i
			'
			' Extract the values separated by | from source$
			' and place each of them in s$[].
			' - source$   : The source string to parse.
			' - delimiter$: The delimiting character(s).
			' - s$[]      : Returned string array.
			'
			delimiter$ = "|"
			IFZ INSTR (source$, delimiter$) THEN
				DIM s$[0]
				s$[0] = source$
			ELSE
				errNum = ERROR ($$FALSE)
				bErr = XstParseStringToStringArray (source$, delimiter$, @s$[])
				IF bErr THEN
					msg$ = "WinXListView_AddItem: Can't parse <" + source$ + ">"
					GuiTellRunError (msg$)
					EXIT SELECT		' fail
				ENDIF
			ENDIF
			'
			' Set the listview item.
			lvi.mask = $$LVIF_TEXT
			IF iIcon >= 0 THEN lvi.mask = lvi.mask OR $$LVIF_IMAGE
			'
			count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
			IF iItem >= 0 && iItem < count THEN
				lvi.iItem = iItem
			ELSE
				lvi.iItem = count
			ENDIF
			'
			' insert item and set the first sub-item
			lvi.iSubItem = 0
			lvi.pszText = &s$[0]
			lvi.iImage = iIcon
			'
			SetLastError (0)
			indexAdd = SendMessageA (hLV, $$LVM_INSERTITEM, 0, &lvi)
			IF indexAdd < 0 THEN
				msg$ = "WinXListView_AddItem: Can't insert item <" + source$ + ">, index: " + STRING$ (lvi.iItem)
				GuiTellApiError (msg$)
				EXIT SELECT		' fail
			ENDIF
			'
			' set the other sub-items
			upp = UBOUND (s$[])
			FOR i = 1 TO upp		' ignore the first listview item
				lvi.mask = $$LVIF_TEXT
				lvi.iItem = indexAdd
				lvi.iSubItem = i
				lvi.pszText = &s$[i]
				SetLastError (0)
				ret = SendMessageA (hLV, $$LVM_SETITEM, 0, &lvi)
				IFZ ret THEN
					msg$ = "WinXListView_AddItem: Can't set subitem" + STR$ (i) + ", value <" + s$[i] + ">"
					GuiTellApiError (msg$)
				ENDIF
			NEXT i
			'
	END SELECT

	RETURN indexAdd

END FUNCTION
'
' #####################################
' #####  WinXListView_DeleteItem  #####
' #####################################
' Deletes an item from a list view control.
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_DeleteItem (hLV, iItem)
	SetLastError (0)
	IFZ hLV THEN RETURN $$FALSE		' fail
	IFZ SendMessageA (hLV, $$LVM_DELETEITEM, iItem, 0) THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' #######################################
' #####  WinXListView_GetSelection  #####
' #######################################
' Gets all the selected items in a list view control.
' indexList[] = the array in which to store the indecies of selected items
' returns the number of selected items
' Usage:
'	cSelItems = WinXListView_GetSelection (hLV, @indexList[])		' get the selected item(s)
'
FUNCTION WinXListView_GetSelection (hLV, indexList[])

	SetLastError (0)
	IFZ hLV THEN RETURN 0		' fail

	cSelItems = SendMessageA (hLV, $$LVM_GETSELECTEDCOUNT, 0, 0)
	IF cSelItems <= 0 THEN RETURN 0		' fail

	DIM indexList[cSelItems-1]
	maxItem = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)-1

	slot = 0
	'now iterate over all the items to locate the selected ones
	FOR i = 0 TO maxItem
		IF SendMessageA (hLV, $$LVM_GETITEMSTATE, i, $$LVIS_SELECTED) THEN
			indexList[slot] = i
			INC slot
		ENDIF
	NEXT i

	RETURN cSelItems
END FUNCTION
'
' #######################################
' #####  WinXListView_SetSelection  #####
' #######################################
' Sets one or several selections in a list view control.
' hLV = a handle to the list view
' indexList[] = the array in which are stored the indecies of selected items
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'	DIM indexList[1]		' select the third and 4th items
'	indexList[0] = 2
'	indexList[1] = 3
'	bOK = WinXListView_SetSelection (hLV, @indexList[])
'
FUNCTION WinXListView_SetSelection (hLV, indexList[])
	LV_ITEM lvi		' listview item

	SetLastError (0)
	IFZ hLV THEN RETURN $$FALSE		' fail

	upp = UBOUND(indexList[])
	FOR i = 0 TO upp
		lvi.mask = $$LVIF_STATE
		lvi.iItem = indexList[i]
		lvi.state = $$LVIS_SELECTED
		lvi.stateMask = $$LVIS_SELECTED
		IFZ SendMessageA (hLV, $$LVM_SETITEM, 0, &lvi) THEN RETURN $$FALSE
	NEXT i

	RETURN $$TRUE		' success
END FUNCTION
'
' ######################################
' #####  WinXListView_SetItemText  #####
' ######################################
' Sets new text for a listview item.
' hLV      = a handle to the list view
' iItem    = the zero-based index of the item
' iSubItem = 0 the 1 based index of the sub-item or 0 if setting the main item
' newText  = new sub-item's text
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'	bOK = WinXListView_SetItemText (hLV, iItem, 3, sub_text$)		' set new sub-item's text for an item
'	IFF bOK THEN		' fail
'		msg$ = "WinXListView_SetItemText: Can't set 4th sub-item's text for item at index " + STRING$ (iItem)
'		XstAlert (msg$)
'	ENDIF
'
FUNCTION WinXListView_SetItemText (hLV, iItem, iSubItem, STRING newText)
	LV_ITEM lvi		' listview item

	SetLastError (0)
	IFZ hLV THEN RETURN $$FALSE		' fail
	lvi.mask = $$LVIF_TEXT
	lvi.iItem = iItem
	lvi.iSubItem = iSubItem
	lvi.pszText = &newText
	IFZ SendMessageA (hLV, $$LVM_SETITEMTEXT, iItem, &lvi) THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  WinXDraw_MakeLogFont  #####
' ##################################
' Creates a new logical font structure, which can be used to create a real font.
' STRING font = the name of the font to use
' height = the height of the font in pixels
' style = a set of flags describing the style of the font
' returns the new logical font
FUNCTION LOGFONT WinXDraw_MakeLogFont (STRING font, height, style)
	LOGFONT ret

	ret.height = height
	ret.width = 0
	IF style AND $$FONT_BOLD THEN ret.weight = $$FW_BOLD ELSE ret.weight = $$FW_NORMAL
	IF style AND $$FONT_ITALIC THEN ret.italic = $$TRUE ELSE ret.italic = $$FALSE
	IF style AND $$FONT_UNDERLINE THEN ret.underline = $$TRUE ELSE ret.underline = $$FALSE
	IF style AND $$FONT_STRIKEOUT THEN ret.strikeOut = $$TRUE ELSE ret.strikeOut = $$FALSE
	ret.charSet = $$DEFAULT_CHARSET
	ret.outPrecision = $$OUT_DEFAULT_PRECIS
	ret.clipPrecision = $$CLIP_DEFAULT_PRECIS
	ret.quality = $$DEFAULT_QUALITY
	ret.pitchAndFamily = $$DEFAULT_PITCH|$$FF_DONTCARE
	ret.faceName = NULL$(32)
	ret.faceName = LEFT$(font, 31)

	RETURN ret
END FUNCTION
'
' ####################################
' #####  WinXDraw_GetFontDialog  #####
' ####################################
' Displays the get font dialog box.
' hOwner = the owner of the dialog
' logFont = the LOGFONT to store initialize the dialog and store the output
' r_codeRGB = the color of the returned font
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_GetFontDialog (hOwner, LOGFONT logFont, @r_codeRGB)
	CHOOSEFONT chf

	SetLastError (0)
	bOK = $$FALSE
	chf.lStructSize = SIZE(CHOOSEFONT)
	chf.hwndOwner = hOwner
	chf.lpLogFont = &logFont

	' - $$CF_EFFECTS            : allows to select strikeout, underline, and color options
	' - $$CF_SCREENFONTS        : causes dialog to show up
	' - $$CF_INITTOLOGFONTSTRUCT: initial settings shows up when the dialog appears
	chf.flags = $$CF_EFFECTS|$$CF_SCREENFONTS|$$CF_INITTOLOGFONTSTRUCT

	chf.rgbColors = r_codeRGB
'
' -------------------------------------------------------------------
' create a Font dialog box that enables the user to choose attributes
' for a logical font; these attributes include a typeface name, style
' (bold, italic, or regular), point size, effects (underline,
' strikeout, and text color), and a script (or character set)
' -------------------------------------------------------------------
'
	ret = ChooseFontA (&chf)
	IF ret THEN
		fontName$ = TRIM$ (logFont.faceName)
		IFZ fontName$ THEN
			r_codeRGB = 0
		ELSE
			logFont.height = ABS(logFont.height)
			r_codeRGB = chf.rgbColors		' returned text color
		ENDIF
		bOK = $$TRUE
	ENDIF

	RETURN bOK
END FUNCTION
'
' ###################################
' #####  WinXDraw_GetTextWidth  #####
' ###################################
' Gets the width of a string using a specified font.
' hFont = the font to use
'  (0 for the default font)
' text$ = the string to get the length for
' maxWidth = the maximum width available for the text,
'            set to -1 if there is no maximum width
'
' returns the width of the text in pixels, or the number of characters in the string that can be displayed
' at a max width of maxWidth if the width of the text exceeds maxWidth.
' If maxWidth is exceeded the return is < 0.
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
		DeleteDC (hDC)
		hDC = 0

		' maxWidth == -1 for no maximum width
		IF (maxWidth = -1) || (fit >= LEN (text$)) THEN
			width = size.cx
			'msg$ = "WinXDraw_GetTextWidth: size.cx = " + STR$ (size.cx)
		ELSE
			width = -fit
			'msg$ = "WinXDraw_GetTextWidth: -fit = " + STR$ (-fit)
		ENDIF
		'WinXDialog_Error (msg$, "WinX-Debug", 0)
	ENDIF

	RETURN width

END FUNCTION
'
' #####################################
' #####  WinXDraw_PixelsPerPoint  #####
' #####################################
' Gets the conversion factor between screen pixels
' and points.
FUNCTION DOUBLE WinXDraw_PixelsPerPoint ()
	DOUBLE cvtHeight

	SetLastError (0)
	cvtHeight = 0

	hDC = GetDC (GetDesktopWindow ())     '  GetDC requires ReleaseDC
	IF hDC THEN
		cvtHeight = DOUBLE (GetDeviceCaps (hDC, $$LOGPIXELSY)) / 72.0
		ReleaseDC (GetDesktopWindow (), hDC)     '  release Device Context hDC
	ENDIF

	RETURN cvtHeight
END FUNCTION
'
' ##########################
' #####  WinXDrawText  #####
' ##########################
' Draws some text on a window.
' hWnd = the handle to the window
' hFont = the handle to the font
' text$ = the text to print
' x, y = the coordinates to print the text at
' backCol, forCol = the colors for the text
' returns the id of the drawn text or 0 on fail
FUNCTION WinXDrawText (hWnd, hFont, text$, x, y, backCol, forCol)
	AUTODRAWRECORD	record
	BINDING			binding
	TEXTMETRIC tm
	SIZEAPI size

	SetLastError (0)

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	hDC = CreateCompatibleDC (0)
	SelectObject (hDC, hFont)
	GetTextExtentPoint32A (hDC, &text$, LEN(text$), &size)
	DeleteDC (hDC)
	hDC = 0

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
	bOK = binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw
END FUNCTION
'
' ###############################
' #####  WinXDraw_GetColor  #####
' ###############################
' Displays a dialog box allowing the user to select a color.
' initialRGB = the color to initialize the dialog box with
' returns the color in RGB format the user selected or 0 on fail or cancel
FUNCTION WinXDraw_GetColor (hOwner, initialRGB)
	SHARED #CustomColors[]
	CHOOSECOLOR cc

	SetLastError (0)
	r_codeRGB = 0		' the new color

	IFZ #CustomColors[] THEN
		'init the custom colors
		DIM #CustomColors[15]
'
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
'
	ENDIF

	' set initial text colour
	cc.rgbResult = 0
	IF initialRGB > 0 THEN
		cc.rgbResult = initialRGB MOD (1 + RGB (0xFF, 0xFF, 0xFF))		' assign a valid RGB color
	ENDIF

	cc.hwndOwner = hOwner
	IFZ cc.hwndOwner THEN
		cc.hwndOwner = GetActiveWindow ()
	ENDIF

	cc.flags = $$CC_RGBINIT
	cc.lpCustColors = &#CustomColors[]
	cc.lStructSize = SIZE (CHOOSECOLOR)
'
' 0.6.0.1-old---
'	ChooseColorA (&cc)
' 0.6.0.1-old~~~
' 0.6.0.1-new+++
	SetLastError (0)
	ret = ChooseColorA (&cc)
	IF ret THEN
		r_codeRGB = cc.rgbResult		' User clicked button OK
	ELSE
		caption$ = "WinXDraw_GetColor: Color Picker Error"
		GuiTellDialogError (hOwner, caption$)
		RETURN 0		' fail
	ENDIF
' 0.6.0.1-new~~~
'
	RETURN r_codeRGB
END FUNCTION
'
' ##################################
' #####  WinXDraw_CreateImage  #####
' ##################################
' Creates a new bitmap image.
' w, h = the width and height for the new image
' returns a handle to a DIB section representing the image or 0 on fail
FUNCTION WinXDraw_CreateImage (w, h)
	BITMAPINFOHEADER bmih

	SetLastError (0)
	bmih.biSize = SIZE(BITMAPINFOHEADER)
	bmih.biWidth  = w
	bmih.biHeight = h
	bmih.biPlanes = 1
	bmih.biBitCount = 32
	bmih.biCompression = $$BI_RGB

	hDIBsection = CreateDIBSection (0, &bmih, $$DIB_RGB_COLORS, &bits, 0, 0)
	RETURN hDIBsection
END FUNCTION
'
' ################################
' #####  WinXDraw_LoadImage  #####
' ################################
' Loads an image from disk.
' fileName = the name of the file
' fileType = the type of file
' returns a handle to the image or 0 on fail
FUNCTION WinXDraw_LoadImage (STRING fileName, fileType)
	BITMAPINFOHEADER bmih
	BITMAPFILEHEADER bmfh
	BITMAP bmp

	SetLastError (0)
	IFZ fileName THEN RETURN 0		' fail

	SELECT CASE fileType
		CASE $$FILETYPE_WINBMP
			'first, load the bitmap
			hBmpTmp = LoadImageA (0, &fileName, $$IMAGE_BITMAP, 0, 0, $$LR_DEFAULTCOLOR|$$LR_CREATEDIBSECTION|$$LR_LOADFROMFILE)
			'now copy it to a standard format
			GetObjectA (hBmpTmp, SIZE(BITMAP), &bmp)
			hBmpRet = WinXDraw_CreateImage (bmp.width, bmp.height)
			hSrc = CreateCompatibleDC (0)
			hDst = CreateCompatibleDC (0)
			hOldSrc = SelectObject (hSrc, hBmpTmp)
			hOldDst = SelectObject (hDst, hBmpRet)
			BitBlt (hDst, 0, 0, bmp.width, bmp.height, hSrc, 0, 0, $$SRCCOPY)
			SelectObject (hSrc, hOldSrc)
			SelectObject (hDst, hOldDst)
			'
			DeleteDC (hDst)
			DeleteDC (hSrc)
			DeleteObject (hBmpTmp)
			'
			'and return
			RETURN hBmpRet
			'
	END SELECT

	RETURN 0
END FUNCTION
'
' ##################################
' #####  WinXDraw_DeleteImage  #####
' ##################################
' Deletes an image.
' hImage = the image to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_DeleteImage (hImage)
	SetLastError (0)
	IFZ hImage THEN RETURN $$FALSE		' fail
	IFZ DeleteObject (hImage) THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ###############################
' #####  WinXDraw_Snapshot  #####
' ###############################
' Takes a snapshot of a WinX window
' and stores the result in an image.
' hWnd = the window to photograph
' x, y = the x and y coordinates of the upper left hand corner of the picture
' hImage = the image to store the result
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_Snapshot (hWnd, x, y, hImage)
	BINDING			binding

	SetLastError (0)
	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	hDC = CreateCompatibleDC (0)
	hOld = SelectObject (hDC, hImage)
	autoDraw_draw (hDC, binding.autoDrawInfo, x, y)
	SelectObject (hDC, hOld)
	DeleteDC (hDC)

	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXDraw_SaveBitmap  #####
' #################################
' Saves an image to a file on disk.
' hImage    = the image to save
' fileName$ = the name for the file
' fileType  =  the format in which to save the file
' returns $$TRUE on success or $$FALSE on fail
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
			'
			IFZ fileName$ THEN EXIT SELECT
			fileNumber = OPEN (fileName$, $$WRNEW)
			IF fileNumber < 0 THEN EXIT SELECT
			'
			bmfh.bfType = 0x4D42
			bmfh.bfSize = SIZE(BITMAPFILEHEADER)+SIZE(BITMAPINFOHEADER)+(bmp.widthBytes*bmp.height)
			bmfh.bfOffBits = SIZE(BITMAPFILEHEADER)+SIZE(BITMAPINFOHEADER)
			WRITE[fileNumber], bmfh
			'
			bmih.biSize = SIZE(BITMAPINFOHEADER)
			bmih.biWidth = bmp.width
			bmih.biHeight = bmp.height
			bmih.biPlanes = bmp.planes
			bmih.biBitCount = bmp.bitsPixel
			bmih.biCompression = $$BI_RGB
			WRITE[fileNumber], bmih
			'
			XstBinWrite (fileNumber, bmp.bits, bmp.widthBytes*bmp.height)
			'
			CLOSE (fileNumber)
			fileNumber = 0
			'
			bOK = $$TRUE		' success
			'
	END SELECT

	RETURN bOK

END FUNCTION
'
' ###################################
' #####  WinXDraw_ResizeBitmap  #####
' ###################################
' Resizes an image cleanly using bicubic interpolation.
' hImage = the handle to the source image
' w, h = the width and height for the new image
' returns a handle to the resized image or 0 on fail
FUNCTION WinXDraw_ResizeImage (hImage, w, h)
	BITMAP bmpSrc
	BITMAP bmpDst

	SetLastError (0)
	hBmpRet = 0

	SELECT CASE hImage
		CASE 0
			'
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
			'
	END SELECT

	RETURN hBmpRet

END FUNCTION
'
' ####################################
' #####  WinXDraw_SetImagePixel  #####
' ####################################
' Sets a pixel on a WinX image.
' hImage = the handle to the image
' x, y = the coordinates of the pixel
' codeRGB = the color for the pixel
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_SetImagePixel (hImage, x, y, codeRGB)
	BITMAP bmp

	SetLastError (0)
	IFZ hImage THEN RETURN $$FALSE		' fail
	IF codeRGB < 0 THEN RETURN $$FALSE		' fail

	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN $$FALSE		' fail
	IF x < 0 || x >= bmp.width || y < 0 || y >= bmp.height THEN RETURN $$FALSE		' fail
'
' GL-10oct22-old---
'	codeRGB = codeRGB MOD (1 + RGB (0xFF, 0xFF, 0xFF))		' assign a valid RGB color
' GL-10oct22-old~~~
' GL-10oct22-new+++
	' make sure codeRGB is a valid RGB color
	codeRGB = codeRGB AND 0xFFFFFF
' GL-10oct22-new~~~
'
	ULONGAT(bmp.bits, ((bmp.height-1-y)*bmp.width+x)<<2) = codeRGB
	RETURN $$TRUE		' success
END FUNCTION
'
' ####################################
' #####  WinXDraw_GetImagePixel  #####
' ####################################
' Gets a pixel on WinX image.
' hImage =  the handle to the image
' x, y = the x and y coordinates of the pixel
' returns the RGBA color at the point
FUNCTION RGBA WinXDraw_GetImagePixel (hImage, x, y)
	BITMAP bmp
	RGBA pointRGBA

	SetLastError (0)
	IFZ hImage THEN RETURN $$FALSE		' fail
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN pointRGBA		' fail
	IF x < 0 || x >= bmp.width || y < 0 || y >= bmp.height THEN RETURN pointRGBA		' fail

	ULONGAT(&pointRGBA) = ULONGAT(bmp.bits, ((bmp.height-1-y)*bmp.width+x)<<2)
	RETURN pointRGBA
END FUNCTION
'
' #######################################
' #####  WinXDraw_SetConstantAlpha  #####
' #######################################
' Sets the transparency of an image to a constant value.
' hImage = the handle to the image
' alpha  = the constant alpha
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_SetConstantAlpha (hImage, DOUBLE alpha)
	BITMAP bmp
	ULONG ulongAlpha

	SetLastError (0)
	IFZ hImage THEN RETURN $$FALSE		' fail
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN $$FALSE		' fail

	SELECT CASE channel
		CASE $$CHANNEL_BLUE, $$CHANNEL_GREEN
			ulongAlpha = ULONG(alpha*255.0)<<24
			maxPixel = (bmp.width * bmp.height) - 1
			FOR i = 0 TO maxPixel
				ULONGAT (bmp.bits, i << 2) = (ULONGAT (bmp.bits, i << 2) AND 0x00FFFFFFFF) OR ulongAlpha
			NEXT i
			RETURN $$TRUE		' success
	END SELECT
	RETURN $$FALSE		' fail
END FUNCTION
'
' ######################################
' #####  WinXDraw_SetImageChannel  #####
' ######################################
' Sets one of the channels of a WinX image.
' hImage = the handle to the image
' channel = the channel id, 0 for blue, 1 for green, 2 for red, 3 for alpha
' data[] = the channel data, a single dimensional UBYTE array containing the channel data
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_SetImageChannel (hImage, channel, UBYTE data[])
	BITMAP bmp

	SetLastError (0)
	IFZ hImage THEN RETURN $$FALSE		' fail
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN $$FALSE		' fail

	SELECT CASE channel
		CASE $$CHANNEL_BLUE, $$CHANNEL_GREEN, $$CHANNEL_RED, $$CHANNEL_ALPHA
			upshift = channel<<3
			mask = NOT(255<<upshift)
			'
			maxPixel = (bmp.width*bmp.height) - 1
			IF maxPixel <> UBOUND (data[]) THEN RETURN $$FALSE
			'
			FOR i = 0 TO maxPixel
				ULONGAT (bmp.bits, i << 2) = (ULONGAT (bmp.bits, i << 2) AND mask) OR ULONG (data[i]) << upshift
			NEXT i
			RETURN $$TRUE		' success
	END SELECT
	RETURN $$FALSE		' fail
END FUNCTION
'
' ######################################
' #####  WinXDraw_GetImageChannel  #####
' ######################################
' Retrieves on of the channels of a WinX image.
' hImage   =  the handle of the image
' channel  = the channel if, 0 for blue, 1 for green, 2 for red, 3 for alpha
' r_data[] =  the UBYTE array to store the channel data
' returns $$TRUE on success, dimensions r_data[] appropriately;
'      or $$FALSE on fail
FUNCTION WinXDraw_GetImageChannel (hImage, channel, UBYTE r_data[])
	BITMAP bmp
	ULONG pixel

	SetLastError (0)
	' reset the returned array
	DIM r_data[]

	IFZ hImage THEN RETURN $$FALSE		' fail
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN $$FALSE		' fail

	SELECT CASE channel
		CASE $$CHANNEL_BLUE, $$CHANNEL_GREEN, $$CHANNEL_RED, $$CHANNEL_ALPHA
			downshift = channel<<3
			maxPixel = (bmp.width*bmp.height) - 1
			DIM r_data[maxPixel]
			FOR i = 0 TO maxPixel
				pixel = ULONGAT(bmp.bits, i<<2)
				r_data[i] = UBYTE ((pixel >> downshift) AND 0x000000FF)
			NEXT i
			RETURN $$TRUE		' success
	END SELECT
	RETURN $$FALSE		' fail
END FUNCTION
'
' ###################################
' #####  WinXDraw_GetImageInfo  #####
' ###################################
' Gets information about an image.
' hImage = the handle of the image to get info on
' w, h = the width and height of the image
' pBits = the pointer to the bits.  They are arranged row first with the last row at the top of the file
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_GetImageInfo (hImage, @w, @h, @pBits)
	BITMAP bmp

	SetLastError (0)
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN $$FALSE

	w = bmp.width
	h = bmp.height
	pBits = bmp.bits
	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXDraw_CopyImage  #####
' ################################
' Generates a copy of an image
' preserving alpha channel.
' hImage =  the handle to the image to copy
' returns a handle to the copy or 0 on fail
FUNCTION WinXDraw_CopyImage (hImage)
	BITMAP bmpSrc
	BITMAP bmpDst

	SetLastError (0)
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmpSrc)	THEN RETURN 0
	hBmpRet = WinXDraw_CreateImage (bmpSrc.width, bmpSrc.height)
	IFZ hBmpRet THEN RETURN 0
	IFZ GetObjectA (hBmpRet, SIZE(BITMAP), &bmpDst) THEN RETURN 0

	RtlMoveMemory (bmpDst.bits, bmpSrc.bits, (bmpDst.width*bmpDst.height)<<2)

	RETURN hBmpRet
END FUNCTION
'
' #######################################
' #####  WinXDraw_PremultiplyImage  #####
' #######################################
' Pre-multiplies an image with its alpha channel
' in preparation for alpha blending.
' hImage =  the image to pre-multiply
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_PremultiplyImage (hImage)
	BITMAP bmp
	RGBA rgba

	SetLastError (0)

	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) RETURN $$FALSE		' fail

	maxPixel = bmp.width*bmp.height-1
	FOR i = 0 TO maxPixel
		'get pixel
		ULONGAT(&rgba) = ULONGAT(bmp.bits, i<<2)
		rgba.blue		= UBYTE((XLONG(rgba.blue)*XLONG(rgba.alpha))\255)
		rgba.green	= UBYTE((XLONG(rgba.green)*XLONG(rgba.alpha))\255)
		rgba.red		= UBYTE((XLONG(rgba.red)*XLONG(rgba.alpha))\255)
		ULONGAT(bmp.bits, i<<2) = ULONGAT(&rgba)
	NEXT i

	RETURN $$TRUE		' success
END FUNCTION
'
' ###########################
' #####  WinXDrawImage  #####
' ###########################
' Draws an image.
' hWnd = the handle to the window to draw on
' hImage = the handle to the image to draw
' x, y, w, h = the x, h, w, and h of the bitmap to blit
' xSrc, ySrc = the x, y coordinates on the image to blit from
' blend = $$TRUE if the image has been pre-multiplied for alpha blending
' (as long as alpha was pre-multiplied, alpha is preserved)
' returns the id of the drawn image or 0 on fail
FUNCTION WinXDrawImage (hWnd, hImage, x, y, w, h, xSrc, ySrc, blend)
	AUTODRAWRECORD	record
	BINDING			binding

	SetLastError (0)

	'get the binding
	IFZ hWnd THEN RETURN 0		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN 0		' fail

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
	bOK = binding_update (idBinding, binding)

	idDraw = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, idDraw)
	RETURN idDraw
END FUNCTION
'
' #############################
' #####  WinXPrint_Start  #####
' #############################
' Optionally displays a print settings dialog box
' then starts printing.
'
' minPage = the minimum page the user can select
' maxPage = the maximum page the user can select
' rangeMin = the initial minimum page, 0 for selection.  The user may change this value
' rangeMax = the initial maximum page, -1 for all pages.  The user may change this value
' cxPhys = the number of device pixels accross - the margins
' cyPhys = the number of device units vertically - the margins
' showDialog = $$TRUE to display a dialog or $$FALSE to use defaults
' hOwner = the handle to the window that owns the print settins dialog box or 0 for none
'
' returns a handle to the printer or 0 on fail
'
FUNCTION WinXPrint_Start (minPage, maxPage, @rangeMin, @rangeMax, @cxPhys, @cyPhys, fileName$, showDialog, hOwner)
	SHARED	PRINTINFO	printInfo
	PRINTDLG printDlg
	DOCINFO docInfo

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
		printDlg.flags = printInfo.printSetupFlags|$$PD_RETURNDC|$$PD_USEDEVMODECOPIESANDCOLLATE
		IFZ rangeMin THEN
			printDlg.flags = printDlg.flags|$$PD_SELECTION
			printDlg.nFromPage = minPage
			printDlg.nToPage = maxPage
		ELSE
			printDlg.flags = printDlg.flags|$$PD_NOSELECTION
			IF rangeMax >= 0 THEN
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
			printDlg.lStructSize = SIZE(PRINTDLG)
			printDlg.hDevMode = 0
			printDlg.hDevNames = 0
			printDlg.flags = $$PD_USEDEVMODECOPIESANDCOLLATE|$$PD_RETURNDEFAULT
			PrintDlgA (&printDlg)
			printInfo.hDevMode = printDlg.hDevMode
			printInfo.hDevNames = printDlg.hDevNames
		ENDIF
		' We need a pointer to the DEVMODE structure
		pDevMode = GlobalLock (printInfo.hDevMode)
		IF pDevMode THEN
			' Get the device name safely
			devName$ = NULL$(32)
			FOR i = 0 TO 28 STEP 4
				ULONGAT(&devName$, i) = ULONGAT(pDevMode, i)
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
	docInfo.size = SIZE(DOCINFO)
	docInfo.docName = &fileName$
	StartDocA (hDC, &docInfo)

	RETURN hDC
END FUNCTION
'
' ########################################
' #####  WinXPrint_LogUnitsPerPoint  #####
' ########################################
' Gets the conversion factor between logical units
' and points.
FUNCTION DOUBLE WinXPrint_LogUnitsPerPoint (hPrinter, cyLog, cyPhys)
'
' GL-old---
'	RETURN (DOUBLE(GetDeviceCaps (hPrinter, $$LOGPIXELSY))*DOUBLE(cyLog))/(72.0*DOUBLE(cyPhys))
' GL-old~~~
'
	DOUBLE convFactor

	SetLastError (0)
	convFactor = 0
	IF hPrinter THEN
		convFactor = DOUBLE (GetDeviceCaps (hPrinter, $$LOGPIXELSY))
		convFactor = (convFactor * cyLog) / (72.0 * cyPhys)
	ENDIF
	RETURN convFactor
END FUNCTION
'
' #######################################
' #####  WinXPrint_DevUnitsPerInch  #####
' #######################################
' Computes the number of device units in an inch.
' w, h = variables to store the width and height
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXPrint_DevUnitsPerInch (hPrinter, @w, @h)
	w = GetDeviceCaps (hPrinter, $$LOGPIXELSX)
	h = GetDeviceCaps (hPrinter, $$LOGPIXELSY)
	RETURN w
END FUNCTION
'
' #################################
' #####  WinXPrint_PageSetup  #####
' #################################
' Displays a page setup dialog box to the user and
' updates the print parameters according to the result.
' hOwner = the handle to the window that owns the dialog
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXPrint_PageSetup (hOwner)
	SHARED	PRINTINFO	printInfo
	PAGESETUPDLG pageSetupDlg
	UBYTE localeInfo[3]

	SetLastError (0)
	pageSetupDlg.lStructSize = SIZE(PAGESETUPDLG)
	pageSetupDlg.hwndOwner = hOwner
'
' 0.6.0.1-new+++
	IFZ pageSetupDlg.hwndOwner THEN
		pageSetupDlg.hwndOwner = GetActiveWindow ()
	ENDIF
' 0.6.0.1-new~~~
'
	pageSetupDlg.hDevMode = printInfo.hDevMode
	pageSetupDlg.hDevNames = printInfo.hDevNames
	pageSetupDlg.flags = $$PSD_DEFAULTMINMARGINS|$$PSD_MARGINS
	pageSetupDlg.rtMargin.left = printInfo.marginLeft
	pageSetupDlg.rtMargin.right = printInfo.marginRight
	pageSetupDlg.rtMargin.top = printInfo.marginTop
	pageSetupDlg.rtMargin.bottom = printInfo.marginBottom

	GetLocaleInfoA ($$LOCALE_USER_DEFAULT, $$LOCALE_IMEASURE, &localeInfo[], SIZE (localeInfo[]))
	IF (localeInfo[0] = '0') THEN
		'The user prefers the metric system, so convert the units
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
	RETURN $$FALSE		' fail
END FUNCTION
'
' ############################
' #####  WinXPrint_Page  #####
' ############################
' Prints a single page.
' hPrinter = the handle to the printer
' hWnd = the handle to the window to print
' x, y, cxLog, cyLog = the coordinates, width and height of the rectangle on the window to print
' cxPhys, cyPhys = the width and height of that rectangle in printer units
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXPrint_Page (hPrinter, hWnd, x, y, cxLog, cyLog, cxPhys, cyPhys, pageNum, pageCount)
	SHARED	PRINTINFO	printInfo
	AUTODRAWRECORD	record
	BINDING			binding
	RECT rect

	SetLastError (0)
	IFZ hPrinter THEN RETURN $$FALSE		' fail

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

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

	'play the auto-draw info into the printer
	StartPage (hPrinter)
	autoDraw_draw (hPrinter, binding.autoDrawInfo, x, y)
	IF EndPage (hPrinter) > 0 THEN RETURN $$TRUE		' success
	RETURN $$FALSE		' fail
END FUNCTION
'
' ############################
' #####  WinXPrint_Done  #####
' ############################
' Finishes current printing operation.
' hPrinter =  the handle to the printer
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXPrint_Done (hPrinter)
	SHARED	PRINTINFO	printInfo

	SetLastError (0)
	IFZ hPrinter THEN RETURN $$FALSE		' fail
	EndDoc (hPrinter)
	DeleteDC (hPrinter)
	DestroyWindow (printInfo.hCancelDlg)
	printInfo.continuePrinting = $$FALSE
	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXNewChildWindow  #####
' ################################
' Creates a new child window (control).
FUNCTION WinXNewChildWindow (parent, STRING title, style, exStyle, id)

	BINDING binding
	LINKEDLIST autoDraw

	hChild = CreateWindowExA (exStyle, &$$MAIN_CLASS$, &title, style|$$WS_VISIBLE|$$WS_CHILD, 0, 0, 0, 0, parent, id, GetModuleHandleA(0), 0)
	IFZ hChild THEN RETURN 0		' fail

	'make a binding
	binding.hWnd = hChild
	style = $$WS_POPUP|$$TTS_NOPREFIX|$$TTS_ALWAYSTIP
	binding.hToolTips = CreateWindowExA(0, &$$TOOLTIPS_CLASS, 0, style, _
				$$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, hChild, 0, _
				GetModuleHandleA(0), 0)

	binding.msgHandlers = handler_addGroup ()
	LinkedList_Init (@autoDraw)
	binding.autoDrawInfo = LINKEDLIST_New (autoDraw)
	binding.autoSizerInfo = autoSizerInfo_addGroup ($$DIR_VERT)		' index

	SetWindowLongA (hChild, $$GWL_USERDATA, binding_add(binding))

	'and we're done
	RETURN hChild
END FUNCTION
'
' ##################################
' #####  WinXRegOnFocusChange  #####
' ##################################
' Registers the .onFocusChange callback function for when the focus changes.
' hWnd = the handle to the window
' FnOnFocusChange = the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnFocusChange (hWnd, FUNCADDR FnOnFocusChange)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onFocusChange = FnOnFocusChange
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ################################
' #####  WinXSetWindowColor  #####
' ################################
' Changes the window background color.
' hWnd = the window to change the color for
' codeRGB = the new background color
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetWindowColor (hWnd, codeRGB)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	IF binding.backCol THEN DeleteObject (binding.backCol)
	binding.backCol = CreateSolidBrush (codeRGB)
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ######################################
' #####  WinXListView_GetItemText  #####
' ######################################
' Gets the text for a listview item.
' hLV = the handle to the list view
' iItem = the zero-based index of the item
' cSubItems = the number of sub items to get
' text$[] = the array to store the result
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'	retrieve the first 2 columns of the first item
'	bOK = WinXListView_GetItemText (hLV, 0, 1, @aSubItem$[])
'
FUNCTION WinXListView_GetItemText (hLV, iItem, cSubItems, @text$[])
	LV_ITEM lvi		' listview item

	DIM text$[cSubItems]
	IFZ hLV THEN RETURN $$FALSE		' fail
	FOR i = 0 TO cSubItems
		lvi.mask = $$LVIF_TEXT
		lvi.cchTextMax = 4095
		buffer$ = NULL$(lvi.cchTextMax+1)		' ensure always a nul-terminator
		lvi.pszText = &buffer$
		lvi.iItem = iItem
		lvi.iSubItem = i

		IFZ SendMessageA (hLV, $$LVM_GETITEM, iItem, &lvi) THEN RETURN $$FALSE
		text$[i] = CSTRING$(&buffer$)
	NEXT i

	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXDialog_Message  #####
' ################################
' Displays a simple message dialog box.
' hOwner = the handle to the owner window, 0 for the active window
' text$ = the text to display
' title$ = the title for the dialog
' iIcon = the id of the icon to use
' hMod = the handle to the module from which the icon comes, 0 for this module
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDialog_Message (hOwner, text$, title$, iIcon, hMod)

	MSGBOXPARAMS mb

	mb.cbSize = SIZE(MSGBOXPARAMS)

	mb.hwndOwner = hOwner
	IFZ mb.hwndOwner THEN
		mb.hwndOwner = GetActiveWindow ()
	ENDIF

	IFZ hMod THEN
		mb.hInstance = GetModuleHandleA(0)
	ELSE
		mb.hInstance = hMod
	ENDIF

	mb.lpszText = &text$
	mb.lpszCaption = &title$
	mb.dwStyle = $$MB_OK
	IF iIcon THEN mb.dwStyle = mb.dwStyle|$$MB_USERICON
	mb.lpszIcon = iIcon

	MessageBoxIndirectA (&mb)
	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXDialog_Question  #####
' #################################
' Displays a dialog asking the user a question.
' hOwner        = the handle to the owner window or 0 for none
' text$         = text of the question
' title$        = the dialog box title
' cancel        = $$TRUE to enable the cancel button
' defaultButton = the zero-based index of the default button
' returns the id of the button the user selected
'
' Usage:
'FUNCTION winMain_OnClose (hWnd)
'
'	title$ = PROGRAM$ (0) + ".exe - Exit"
'	msg$ = "Are you sure you want to exit?"
'	mret = WinXDialog_Question (#winMain, msg$, title$, $$FALSE, 0)		' default to the 'Yes' button
'	IF mret = $$IDNO THEN RETURN 1		' quit is canceled
'
'	' quit application
'	PostQuitMessage ($$WM_QUIT)
'	RETURN 0		' quit is confirmed
'
'END FUNCTION
'
FUNCTION WinXDialog_Question (hOwner, text$, title$, cancel, defaultButton)
	IF cancel THEN
		flags = $$MB_YESNOCANCEL
	ELSE
		flags = $$MB_YESNO
	ENDIF
	SELECT CASE defaultButton
		CASE 1
			flags = flags|$$MB_DEFBUTTON2		' default button is 'No'
		CASE 2
			flags = flags|$$MB_DEFBUTTON3		' default button is 'Cancel'
	END SELECT
	flags = flags|$$MB_ICONQUESTION

	RETURN MessageBoxA (hOwner, &text$, &title$, flags)
END FUNCTION
'
' ########################################
' #####  WinXSplitter_SetProperties  #####
' ########################################
' Sets WinX's splitter info.
' series = the index of the group the control is located in
' hCtr = the handle to the control
' min = the minimum size of the control
' max = the maximum size of the control
' dock = $$TRUE to allow docking - else $$FALSE
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSplitter_SetProperties (series, hCtr, min, max, dock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	SPLITTERINFO splitterInfo

	IFF series >= 0 && series <= UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[series].inUse THEN RETURN $$FALSE

	' Walk the list until we find the auto-draw record we need
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

	iSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (iSplitter, @splitterInfo)
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

	bOK = SPLITTERINFO_Update (iSplitter, splitterInfo)

	RETURN bOK
END FUNCTION
'
' ##################################
' #####  WinXRegistry_ReadInt  #####
' ##################################
' Reads an integer from the registry.
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' sa = the security attributes for the key if it is created
' result = the integer read from the registry
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegistry_ReadInt (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result)
	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	four = 4
	ret = $$FALSE
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result, &four) = $$ERROR_SUCCESS THEN
			ret = $$TRUE
		ELSE
			IF createOnOpenFail THEN
				IF RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &result, 4) = $$ERROR_SUCCESS THEN ret = $$TRUE
			ENDIF
		ENDIF
		'
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			SELECT CASE disposition
				CASE $$REG_CREATED_NEW_KEY
					IF createOnOpenFail THEN
						IF RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &result, 4) = $$ERROR_SUCCESS THEN ret = $$TRUE
					ENDIF
				CASE $$REG_OPENED_EXISTING_KEY
					IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result, &four) = $$ERROR_SUCCESS THEN ret = $$TRUE
			END SELECT
			'
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN ret
END FUNCTION
'
' #####################################
' #####  WinXRegistry_ReadString  #####
' #####################################
' Reads a string from the registry.
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' sa = the security attributes for the key if it is created
' result$ = the string read from the registry
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegistry_ReadString (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	ret = $$FALSE
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		GOSUB QueryVariable
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			SELECT CASE disposition
				CASE $$REG_CREATED_NEW_KEY
					IF createOnOpenFail THEN
						IF RegSetValueExA (hSubKey, &value$, 0, $$REG_EXPAND_SZ, &result$, LEN(result$)+1) = $$ERROR_SUCCESS THEN ret = $$TRUE
					ENDIF
				CASE $$REG_OPENED_EXISTING_KEY
					GOSUB QueryVariable
			END SELECT
			'
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN ret
'
' Queries a value in the Registry.
' returns $$TRUE on success or $$FALSE on fail
'
	SUB QueryVariable
		IF RegQueryValueExA (hSubKey, &value$, 0, &type, 0, &cbSize) = $$ERROR_SUCCESS THEN
			IF (type = $$REG_EXPAND_SZ)||(type = $$REG_SZ)||(type = $$REG_MULTI_SZ) THEN
				result$ = NULL$(cbSize+1)		' ensure always a nul-terminator
				IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result$, &cbSize) = $$ERROR_SUCCESS THEN
					ret = $$TRUE
				ENDIF
			ENDIF
		ELSE
			IF createOnOpenFail THEN
				IF RegSetValueExA (hSubKey, &value$, 0, $$REG_EXPAND_SZ, &result$, LEN(result$)+1) = $$ERROR_SUCCESS THEN ret = $$TRUE
			ENDIF
		ENDIF
	END SUB
END FUNCTION
'
' ##################################
' #####  WinXRegistry_ReadBin  #####
' ##################################
' Reads binary data from the registry.
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' sa = the security attributes for the key if it is created
' result$ = the binary data read from the registry
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegistry_ReadBin (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	ret = $$FALSE
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		GOSUB QueryVariable
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			SELECT CASE disposition
				CASE $$REG_CREATED_NEW_KEY
					IF createOnOpenFail THEN
						IF RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &result$, LEN(result$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
					ENDIF
				CASE $$REG_OPENED_EXISTING_KEY
					GOSUB QueryVariable
			END SELECT
			'
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN ret
'
' Queries a value in the Registry.
' returns $$TRUE on success or $$FALSE on fail
'
	SUB QueryVariable
		IF RegQueryValueExA (hSubKey, &value$, 0, &type, 0, &cbSize) = $$ERROR_SUCCESS THEN
			IF (type = $$REG_BINARY) THEN
				result$ = NULL$(cbSize+1)		' ensure always a nul-terminator
				IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result$, &cbSize) = $$ERROR_SUCCESS THEN ret = $$TRUE
			ENDIF
		ELSE
			IF createOnOpenFail THEN
				IF RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &result$, LEN(result$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
			ENDIF
		ENDIF
	END SUB
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
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegistry_WriteInt (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, int)
	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	ret = $$FALSE
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		IF RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &int, 4) = $$ERROR_SUCCESS THEN ret = $$TRUE
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			IF RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &int, 4) = $$ERROR_SUCCESS THEN ret = $$TRUE
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN ret
END FUNCTION
'
' ######################################
' #####  WinXRegistry_WriteString  #####
' ######################################
' Writes a string into the registry.
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' sa = the security attributes for the key if it is created
' buffer$ = the string to write into the registry
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegistry_WriteString (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, buffer$)
	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	ret = $$FALSE
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		IF RegSetValueExA (hSubKey, &value$, 0, $$REG_SZ, &buffer$, LEN(buffer$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			IF RegSetValueExA (hSubKey, &value$, 0, $$REG_SZ, &buffer$, LEN(buffer$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN ret
END FUNCTION
'
' ###################################
' #####  WinXRegistry_WriteBin  #####
' ###################################
' Writes binary data into the registry.
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' sa = the security attributes for the key if it is created
' buffer$ = the binary data to write into the registry
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegistry_WriteBin (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, buffer$)
	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	ret = $$FALSE
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ|$$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		IF RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &buffer$, LEN(buffer$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			IF RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &buffer$, LEN(buffer$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN ret
END FUNCTION
'
' ################################
' #####  WinXAddAccelerator  #####
' ################################
' /*
' [WinXAddAccelerator]
' Description = Adds an accelerator to an accelerator array.
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
' Examples    = bOK = WinXAddAccelerator (@accel[], $$mnuFileOpen, 'O', $$TRUE, $$FALSE, $$FALSE)<br/>
' */
FUNCTION WinXAddAccelerator (ACCEL accel[], cmd, key, control, alt, shift)
	IFZ accel[] THEN
		DIM accel[0]
	ELSE
		REDIM accel[UBOUND(accel[])+1]
	ENDIF
	iAdd = UBOUND(accel[])

	accel[iAdd].fVirt = $$FVIRTKEY
	IF alt     THEN accel[iAdd].fVirt = accel[iAdd].fVirt|$$FALT
	IF control THEN accel[iAdd].fVirt = accel[iAdd].fVirt|$$FCONTROL
	IF shift   THEN accel[iAdd].fVirt = accel[iAdd].fVirt|$$FSHIFT

	accel[iAdd].key = key
	accel[iAdd].cmd = cmd

	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXSplitter_GetPos  #####
' #################################
' Gets the current position of a splitter control.
' series = the index of the group to which the splitter belongs
' hCtr = the control the splitter is attached to
' position = the variable to store the position of the splitter
' docked = the variable to store the docking state, $$TRUE when docked else $$FALSE
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSplitter_GetPos (series, hCtr, @position, @docked)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	SPLITTERINFO splitterInfo

	IFF series >= 0 && series <= UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[series].inUse THEN RETURN $$FALSE

	' Walk the list until we find the auto-draw record we need
	found = $$FALSE
	i = autoSizerInfoUM[series].iHead
	DO WHILE i > -1
		IF autoSizerInfo[series, i].hWnd = hCtr THEN
			found = $$TRUE
			EXIT DO
		ENDIF
		i = autoSizerInfo[series, i].nextItem
	LOOP

	IFF found THEN RETURN $$FALSE		' not found

	iSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
	bOK = SPLITTERINFO_Get (iSplitter, @splitterInfo)
	IFF bOK THEN RETURN $$FALSE		' fail

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
' Sets the current position of a splitter control.
' series = the index of the group to which the splitter belongs
' hCtr = the control the splitter is attached to
' position = the new position for the splitter
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSplitter_SetPos (series, hCtr, position, docked)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the auto-sizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	SPLITTERINFO splitterInfo
	RECT rect

	IFF series >= 0 && series <= UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[series].inUse THEN RETURN $$FALSE

	' Walk the list until we find the auto-sizer block we need
	found = $$FALSE
	i = autoSizerInfoUM[series].iHead
	DO WHILE i > -1
		IF autoSizerInfo[series, i].hWnd = hCtr THEN
			found = $$TRUE
			EXIT DO
		ENDIF
		i = autoSizerInfo[series, i].nextItem
	LOOP

	IFF found THEN RETURN $$FALSE		' fail

	iSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (iSplitter, @splitterInfo)

	IF docked THEN
		autoSizerInfo[series, i].size = 8
		splitterInfo.docked = position
	ELSE
		autoSizerInfo[series, i].size = position
		splitterInfo.docked = 0
	ENDIF

	bOK = SPLITTERINFO_Update (iSplitter, splitterInfo)

	GetClientRect (GetParent (hCtr), &rect)
	sizeWindow (GetParent (hCtr), rect.right-rect.left, rect.bottom-rect.top)		' resize the parent window

	RETURN bOK
END FUNCTION
'
' ###############################
' #####  WinXClip_IsString  #####
' ###############################
' Checks to see if the clipboard contains a string.
' returns $$TRUE only if the clipboard contains a string, otherwise $$FALSE.
FUNCTION WinXClip_IsString ()
	IFZ IsClipboardFormatAvailable ($$CF_TEXT) THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXClip_PutString  #####
' ################################
' Copies a string to the clipboard.
' Stri$ = The string to copy
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClip_PutString (Stri$)
	SHARED hClipMem		' to copy to the clipboard

	IFZ OpenClipboard (0) THEN RETURN $$FALSE		' fail
	EmptyClipboard ()

	hClipMem = GlobalAlloc ($$GMEM_MOVEABLE|$$GMEM_ZEROINIT, LEN(Stri$)+1)
	pMem = GlobalLock (hClipMem)
	RtlMoveMemory (pMem, &Stri$, LEN(Stri$))
	GlobalUnlock (hClipMem)

	SetClipboardData ($$CF_TEXT, hClipMem)
	CloseClipboard ()

	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXClip_GetString  #####
' ################################
' Gets a string from the clipboard.
' returns the string or an empty string on fail
FUNCTION WinXClip_GetString$ ()
	IFZ OpenClipboard (0) THEN RETURN ""

	hMem = GetClipboardData ($$CF_TEXT)
	pMem = GlobalLock (hMem)
	ret$ = CSTRING$(pMem)
	GlobalUnlock (hMem)
	CloseClipboard ()

	RETURN ret$
END FUNCTION
'
' #################################
' #####  WinXRegOnClipChange  #####
' #################################
' Registers the .onClipChange callback function for when the clipboard changes.
' hWnd = the handle to the window
' FnOnClipChange = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnClipChange (hWnd, FUNCADDR FnOnClipChange)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.hWndNextClipViewer = SetClipboardViewer (hWnd)

	binding.onClipChange = FnOnClipChange
	bOK = binding_update (idBinding, binding)
	RETURN bOK
END FUNCTION
'
' ########################
' #####  WinXNewACL  #####
' ########################
' Creates a new security attributes structure.
' ssd$ = a string describing the ACL, 0 for null
' inherit = $$TRUE if these attributes can be inherited, otherwise $$FALSE
' returns the new security attributes structure
FUNCTION SECURITY_ATTRIBUTES WinXNewACL (ssd$, inherit)
	SECURITY_ATTRIBUTES ret

	ret.length = SIZE(SECURITY_ATTRIBUTES)
	IF inherit THEN ret.inherit = 1

	IF ssd$ THEN
'
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
'
	ENDIF

	RETURN ret

END FUNCTION
'
' ###########################
' #####  WinXSetCursor  #####
' ###########################
' Sets a window's cursor.
' hWnd = the handle to the window
' hCursor = the cursor
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetCursor (hWnd, hCursor)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.hCursor = hCursor
	bOK = binding_update (idBinding, binding)
	RETURN bOK

END FUNCTION
'
' ###############################
' #####  WinXScroll_GetPos  #####
' ###############################
' Gets the scrolling position of a window.
' hWnd = the handle to the window
' direction = the scrolling direction
' pos = the variable to store the scrolling position
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXScroll_GetPos (hWnd, direction, @pos)
	SCROLLINFO si

	si.cbSize = SIZE(SCROLLINFO)
	si.fMask = $$SIF_POS
	SELECT CASE direction
		CASE $$DIR_HORIZ
			GetScrollInfo (hWnd, $$SB_HORZ, &si)
		CASE $$DIR_VERT
			GetScrollInfo (hWnd, $$SB_VERT, &si)
	END SELECT
	pos = si.nPos

	RETURN $$TRUE		' success

END FUNCTION
'
' ###############################
' #####  WinXScroll_SetPos  #####
' ###############################
' Sets the scrolling position of a window.
' hWnd = the handle to the window
' direction = the scrolling direction
' pos = the new scrolling position
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXScroll_SetPos (hWnd, direction, pos)
	SCROLLINFO si

	SetLastError (0)

	si.cbSize = SIZE(SCROLLINFO)
	si.fMask = $$SIF_POS
	si.nPos = pos

	SELECT CASE direction
		CASE $$DIR_HORIZ
			typeBar = $$SB_HORZ
		CASE ELSE
			typeBar = $$SB_VERT
	END SELECT

	SetScrollInfo (hWnd, typeBar, &si, 1)

	RETURN $$TRUE		' success

END FUNCTION
'
' ###########################
' #####  WinXRegOnItem  #####
' ###########################
' Registers the .onItem callback function for a list view control.
' hWnd = the window to register the message for
' FnOnItem = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnItem (hWnd, FUNCADDR FnOnItem)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onItem = FnOnItem
	bOK = binding_update (idBinding, binding)
	RETURN bOK

END FUNCTION
'
' ##################################
' #####  WinXRegOnColumnClick  #####
' ##################################
' Registers the .onColumnClick callback function for a list view control.
' hWnd = the window to register the callback for
' FnOnColumnClick = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnColumnClick (hWnd, FUNCADDR FnOnColumnClick)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onColumnClick = FnOnColumnClick
	bOK = binding_update (idBinding, binding)
	RETURN bOK

END FUNCTION
'
' #################################
' #####  WinXRegOnEnterLeave  #####
' #################################
' Registers the .onEnterLeave callback function.
' hWnd = the handle to the window to register the callback for
' FnOnEnterLeave = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnEnterLeave (hWnd, FUNCADDR FnOnEnterLeave)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	binding.onEnterLeave = FnOnEnterLeave
	bOK = binding_update (idBinding, binding)
	RETURN bOK

END FUNCTION
'
' ###########################################
' #####  WinXListView_GetItemFromPoint  #####
' ###########################################
' Gets a listview item given its coordinates.
' hLV = the list view to get the item from
' x, y = the x and y coordinates to find the item at
' returns the index of the item or -1 on fail
FUNCTION WinXListView_GetItemFromPoint (hLV, x, y)

	LVHITTESTINFO lvHit

	SetLastError (0)
	IFZ hLV THEN RETURN $$FALSE		' fail
	lvHit.pt.x = x
	lvHit.pt.y = y
	ret = SendMessageA (hLV, $$LVM_HITTEST, 0, &lvHit)
	IF ret THEN RETURN $$TRUE		' hit
	RETURN $$FALSE		' not hit

END FUNCTION
'
' ###############################
' #####  WinXListView_Sort  #####
' ###############################
' Sorts the items in a list view control.
' hLV = the list view control to sort
' iCol = the zero-based index of the column to sort by
' desc = $$TRUE to sort descending instead of ascending
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_Sort (hLV, iCol, desc)
'	SHARED #lvs_column_index
'	SHARED #lvs_decreasing

	IFZ hLV THEN RETURN $$FALSE		' fail
	#lvs_column_index = iCol
	#lvs_decreasing = desc
	ret = SendMessageA (hLV, $$LVM_SORTITEMSEX, hLV, &CompareLVItems())
	IF ret THEN RETURN $$TRUE		' success
	RETURN $$FALSE		' fail

END FUNCTION
'
' ###########################################
' #####  WinXTreeView_GetItemFromPoint  #####
' ###########################################
' Gets a treeview item given its coordinates.
' hTreeView = the control to get the item from
' x, y = the x and y coordinates to find the item at
' returns a handle to the item or 0 on fail
FUNCTION WinXTreeView_GetItemFromPoint (hTreeView, x, y)

	TV_HITTESTINFO tvHit

	SetLastError (0)
	IFZ hTreeView THEN RETURN 0		' fail
	tvHit.pt.x = x
	tvHit.pt.y = y

	' Find out which item (if any) the cursor is over.
	RETURN SendMessageA (hTreeView, $$TVM_HITTEST, 0, &tvHit)

END FUNCTION
'
' ##############################
' #####  WinXGetPlacement  #####
' ##############################
' Gets window placement.
' hWnd = the handle to the window
' minMax = the variable to store the minimised/maximised state
' restored = the variable to store the restored position and size
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXGetPlacement (hWnd, @minMax, RECT restored)
	WINDOWPLACEMENT wp
	RECT rect_null

	SetLastError (0)
	' reset returned params
	minMax = 0
	restored = rect_null

	IFZ hWnd THEN RETURN $$FALSE		' fail

	wp.length = SIZE(WINDOWPLACEMENT)
	IFZ GetWindowPlacement (hWnd, &wp) THEN RETURN $$FALSE

	restored = wp.rcNormalPosition
	minMax = wp.showCmd

	RETURN $$TRUE		' success

END FUNCTION
'
' ##############################
' #####  WinXSetPlacement  #####
' ##############################
' Sets window placement.
' hWnd = the handle to the window
' minMax = minimised/maximised state, can be null in which case no changes are made
' restored = the restored position and size, can be null in which case not changes are made
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetPlacement (hWnd, minMax, RECT restored)
	WINDOWPLACEMENT wp
	RECT rect

	IFZ hWnd THEN RETURN $$FALSE		' fail

	wp.length = SIZE(WINDOWPLACEMENT)
	IFZ GetWindowPlacement (hWnd, &wp) THEN RETURN $$FALSE		' fail

	IF wp.showCmd THEN wp.showCmd = minMax
	IF (restored.left|restored.right|restored.top|restored.bottom) THEN wp.rcNormalPosition = restored

	IFZ SetWindowPlacement (hWnd, &wp) THEN bOK = $$FALSE ELSE bOK = $$TRUE

	GetClientRect (hWnd, &rect)
	sizeWindow (hWnd, rect.right-rect.left, rect.bottom-rect.top)		' resize the window

	RETURN bOK

END FUNCTION
'
' #############################
' #####  WinXGetMousePos  #####
' #############################
' Gets the mouse position.
' hWnd = the handle to the window to get the coordinates relative to
'        0 for the active window
' x = the variable to store the mouse x position
' y = the variable to store the mouse y position
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXGetMousePos (hWnd, @x, @y)
'	POINTAPI pt
	POINT pt

	SetLastError (0)
	' reset returned parameters
	x = 0
	y = 0
'
' 0.6.0.2-new+++
	IFZ hWnd THEN hWnd = GetActiveWindow ()
' 0.6.0.2-new~~~
'
	SetLastError (0)
	IFZ hWnd THEN RETURN $$FALSE		' fail
	GetCursorPos (&pt)
	ScreenToClient (hWnd, &pt)
	x = pt.x
	y = pt.y
	RETURN $$TRUE		' success

END FUNCTION
'
' #############################
' #####  WinXAddCalendar  #####
' #############################
' Creates a new calendar control
' and adds it to specified window.
' monthsX = the number of months to display in the x direction, returns the width of the control
' monthsY = the number of months to display in the y direction, returns the height of the control
' id      = the unique id for this control
' returns the new calendar control handle on success or 0 on fail
FUNCTION WinXAddCalendar (parent, @monthsX, @monthsY, id)
	RECT rect

	SetLastError (0)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP
	hCal = CreateWindowExA (0, &$$MONTHCAL_CLASS, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hCal THEN RETURN 0		' fail
	SendMessageA (hCal, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	SendMessageA (hCal, $$MCM_GETMINREQRECT, 0, &rect)

	monthsX = monthsX*(rect.right-rect.left)
	monthsY = monthsY*(rect.bottom-rect.top)

	SetLastError (0)		' reset any error code
	RETURN hCal

END FUNCTION
'
' #######################################
' #####  WinXCalendar_SetSelection  #####
' #######################################
' Sets the selection in a calendar control.
' hCal = the handle to the calendard control
' start = the start of the selection range
' end = the end of the selection range
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXCalendar_SetSelection (hCal, SYSTEMTIME time)

	SetLastError (0)
	IFZ hCal THEN RETURN $$FALSE		' fail
	IFZ SendMessageA (hCal, $$MCM_SETCURSEL, 0, &time) THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success

END FUNCTION
'
' #######################################
' #####  WinXCalendar_GetSelection  #####
' #######################################
' Gets the selection in a calendar control.
' hCal = the handle to the calendard control
' start = the variable to store the start of the selection range
' end = the variable to store the end of the selection range
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'	SYSTEMTIME time
'
'	bOK = WinXCalendar_GetSelection (hCal, @time)
'	IFF bOK THEN
'		msg$ = "WinXCalendar_GetSelection: Can't get the selection in a calendar control"
'		XstAlert (msg$)
'		RETURN $$TRUE ' error
'	ENDIF
'
FUNCTION WinXCalendar_GetSelection (hCal, SYSTEMTIME time)
	SetLastError (0)
	IFZ hCal THEN RETURN $$FALSE		' fail
'
' 0.6.0.2-old---
'	IFZ SendMessageA (hCal, $$MCM_GETCURSEL, 0, &time) THEN RETURN $$FALSE ELSE RETURN $$TRUE
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	SetLastError (0)
	IF hCal THEN
		timeSize = SIZE (SYSTEMTIME)
		IF SendMessageA (hCal, $$MCM_GETCURSEL, timeSize, &time) THEN
			RETURN $$TRUE		' success
		ENDIF
	ENDIF
' 0.6.0.2-new~~~
'
END FUNCTION
'
' #####################################
' #####  WinXRegOnCalendarSelect  #####
' #####################################
' Registers the .onCalendarSelect callback function.
' hWnd = the handle to the window to set the callback for
' FnOnCalendarSelect = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnCalendarSelect (hWnd, FUNCADDR FnOnCalendarSelect)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE

	binding.onCalendarSelect = FnOnCalendarSelect
	bOK = binding_update (idBinding, binding)
	RETURN bOK

END FUNCTION
'
' ###############################
' #####  WinXAddTimePicker  #####
' ###############################
' Creates a new Date/Time Picker control
' and adds it to specified window.
' format = the format for the control, should be $$DTS_LONGDATEFORMAT, $$DTS_SHORTDATEFORMAT or $$DTS_TIMEFORMAT
' initialTime = the time to initialize the control to
' timeValid = $$TRUE if the initialTime parameter is valid
' id = the unique id for this control
' returns the new Date/Time Picker handle or 0 on fail
FUNCTION WinXAddTimePicker (parent, format, SYSTEMTIME initialTime, timeValid, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP

	' the format for the control should be $$DTS_LONGDATEFORMAT, $$DTS_SHORTDATEFORMAT or $$DTS_TIMEFORMAT
	IF (format & $$DTS_LONGDATEFORMAT) THEN
		style = style OR $$DTS_LONGDATEFORMAT
	ELSE
		IF (format & $$DTS_SHORTDATEFORMAT) THEN
			style = style OR $$DTS_SHORTDATEFORMAT
		ELSE
			IF (format & $$DTS_TIMEFORMAT) THEN
				style = style OR $$DTS_TIMEFORMAT
			ENDIF
		ENDIF
	ENDIF

	hDTP = CreateWindowExA (0, &$$DATETIMEPICK_CLASS, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	IFZ hDTP THEN RETURN 0		' fail

	SendMessageA (hDTP, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)

	IF timeValid THEN
		wParam = $$GDT_VALID
		lParam = &initialTime
	ELSE
		wParam = $$GDT_NONE
		lParam = 0
	ENDIF
	SendMessageA (hDTP, $$DTM_SETSYSTEMTIME, wParam, lParam)

	RETURN hDTP

END FUNCTION
'
' ####################################
' #####  WinXTimePicker_SetTime  #####
' ####################################
' Sets the time for a Date/Time Picker control.
' hDTP = the handle to the control
' time = the time to set the control to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTimePicker_SetTime (hDTP, SYSTEMTIME time, timeValid)
'
' 0.6.0.2-old---
'	IF timeValid THEN
'		SendMessageA (hDTP, $$DTM_SETSYSTEMTIME, $$GDT_VALID, &time)
'	ELSE
'		SendMessageA (hDTP, $$DTM_SETSYSTEMTIME, $$GDT_NONE, 0)
'	ENDIF
' 0.6.0.2-old~~~
' 0.6.0.2-new+++
	IFZ hDTP THEN RETURN $$FALSE		' fail
	IF timeValid THEN
		wParam = $$GDT_VALID
		lParam = &time
	ELSE
		wParam = $$GDT_NONE
		lParam = 0
	ENDIF
	ret = SendMessageA (hDTP, $$DTM_SETSYSTEMTIME, wParam, lParam)
	IFZ ret THEN RETURN $$FALSE		' fail

	RETURN $$TRUE		' success
' 0.6.0.2-new~~~
'
END FUNCTION
'
' #####################################
' #####  WinXTimePicker_GetTime  #####
' #####################################
' Gets the time from a Date/Time Picker control.
' hDTP = the handle to the control
' time = the structure to store the time
' timeValid = $$TRUE if the returned time is valid
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTimePicker_GetTime (hDTP, SYSTEMTIME time, @timeValid)
	timeValid = $$FALSE		' invalid
	IFZ hDTP THEN RETURN $$FALSE		' fail

	SELECT CASE SendMessageA (hDTP, $$DTM_GETSYSTEMTIME, 0, &time)
		CASE $$GDT_VALID
			timeValid = $$TRUE		' valid
	END SELECT

	RETURN $$TRUE		' success

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
' returns a handle to the new font or 0 on fail
'
FUNCTION WinXNewFont (fontName$, pointSize, weight, bItalic, bUnderL, bStrike)

	LOGFONT logFont
	XLONG bErr		' $$TRUE for fail

	SetLastError (0)
	r_hFont = 0

	' check fontName$ not empty
	fontName$ = TRIM$ (fontName$)
	IFZ fontName$ THEN
		msg$ = "WinXNewFont: empty font face"
		WinXDialog_Error (msg$, "WinX-Internal Error", 2)
		RETURN		' fail
	ENDIF

	' hFontToClone provides with a well-formed font structure
	SetLastError (0)
	hFontToClone = GetStockObject ($$DEFAULT_GUI_FONT)		' get a font to clone
	IFZ hFontToClone THEN
		msg$ = "WinXNewFont: Can't get a font to clone"
		bErr = GuiTellApiError (msg$)
		IFF bErr THEN WinXDialog_Error (msg$, "WinX-Internal Error", 2)
		RETURN		' invalid handle
	ENDIF

	bytes = 0		' number of bytes stored into the buffer
	bErr = $$FALSE
	SetLastError (0)
	bytes = GetObjectA (hFontToClone, SIZE (LOGFONT), &logFont)		' fill allocated structure logFont
	IF bytes <= 0 THEN
		msg$ = "WinXNewFont: Can't fill allocated structure logFont"
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
			msg$ = "WinXNewFont: Can't get a handle to the desktop context"
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
		msg$ = "WinXNewFont: Can't create logical font r_hFont"
		bErr = GuiTellApiError (msg$)
		IFF bErr THEN WinXDialog_Error (msg$, "WinX-Internal Error", 2)
		RETURN
	ENDIF

	RETURN r_hFont

END FUNCTION
'
' #########################
' #####  WinXSetFont  #####
' #########################
' Applies the font to a control and redraw it.
' Note: Wrapper to WinXSetFontAndRedraw.
' hCtr = a handle to the control
' hFont = a handle to the logical font
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetFont (hCtr, hFont)

	bOK = WinXSetFontAndRedraw (hCtr, hFont, $$FALSE)		' do not redraw
	RETURN bOK

END FUNCTION
'
' ##################################
' #####  WinXSetFontAndRedraw  #####
' ##################################
'
' Applies a font to control.
'
' hCtr    = a handle to the control
' hFont   = a handle to the logical font
' bRedraw = $$TRUE to redraw the control after setting the font
' returns $$TRUE on success or $$FALSE on fail
'
FUNCTION WinXSetFontAndRedraw (hCtr, hFont, bRedraw)
	SHARED hFontDefault ' standard font

	SetLastError (0)
	bOK = $$FALSE

	SELECT CASE hCtr
		CASE 0
			'
		CASE ELSE
			IFZ hFont THEN
				' create default font
				IFZ hFontDefault THEN
					hFontDefault = GetStockObject ($$ANSI_VAR_FONT)
				ENDIF
				hFont = hFontDefault
			ENDIF
			'
			IF bRedraw THEN lParam = 1 ELSE lParam = 0
			SendMessageA (hCtr, $$WM_SETFONT, hFont, lParam)		' $$WM_SETFONT does not return a value
			'
			bOK = $$TRUE
			'
	END SELECT

	RETURN bOK

END FUNCTION
'
' ##############################
' #####  WinXClip_IsImage  #####
' ##############################
' Checks to see if the clipboard contains an image.
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClip_IsImage ()

	IFZ IsClipboardFormatAvailable ($$CF_DIB) THEN RETURN $$FALSE		' fail
	RETURN $$TRUE		' success

END FUNCTION
'
' ###############################
' #####  WinXClip_GetImage  #####
' ###############################
' Gets an image from the clipboard.
' returns a handle to the bitmap or 0 on fail
FUNCTION WinXClip_GetImage ()
	BITMAPINFOHEADER bmi

	IFZ OpenClipboard (0) THEN RETURN 0		' fail

	hData = GetClipboardData ($$CF_DIB)
	IFZ hData THEN RETURN 0

	pData = GlobalLock (hData)

	RtlMoveMemory (&bmi, pData, ULONGAT(pData))
	hImage = WinXDraw_CreateImage (bmi.biWidth, bmi.biHeight)
	hDC = CreateCompatibleDC (0)
	hOld = SelectObject (hDC, hImage)

	height = ABS(bmi.biHeight)
	pBits = pData+SIZE(BITMAPINFOHEADER)
	SELECT CASE bmi.biBitCount
		CASE 1
			pBits = pBits+8
		CASE 4
			pBits = pBits+64
		CASE 8
			pBits = pBits+1024
		CASE 16, 24, 32
			SELECT CASE bmi.biCompression
				CASE $$BI_RGB
				CASE $$BI_BITFIELDS
					pBits = pBits+12
			END SELECT
	END SELECT

	PRINT bmi.biBitCount
	SetDIBitsToDevice (hDC, 0, 0, bmi.biWidth, height, 0, 0, 0, height, pBits, pData, $$DIB_RGB_COLORS)

	GlobalUnlock (hData)
	CloseClipboard ()

	SelectObject (hDC, hOld)
	DeleteDC (hDC)

	RETURN hImage

END FUNCTION
'
' ###############################
' #####  WinXClip_PutImage  #####
' ###############################
' Copies an image to the clipboad.
' hImage = the handle to the image to add to the clipboard
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClip_PutImage (hImage)
	SHARED hClipMem		' to copy to the clipboard

	BITMAPINFOHEADER bmi
	DIBSECTION ds

	IFZ hImage THEN RETURN $$FALSE		' fail
	IFZ GetObjectA (hImage, SIZE(DIBSECTION), &bmp) THEN RETURN $$FALSE		' fail

	cbBits = ds.dsBm.height*((ds.dsBm.width*ds.dsBm.bitsPixel+31)\32)

	IFZ OpenClipboard (0) THEN RETURN $$FALSE
	EmptyClipboard ()

	hClipMem = GlobalAlloc ($$GMEM_MOVEABLE|$$GMEM_ZEROINIT, SIZE(BITMAPINFOHEADER)+cbBits)
	pData = GlobalLock (hClipMem)
	RtlMoveMemory (pData, &ds.dsBmih, SIZE(BITMAPINFOHEADER))
	RtlMoveMemory (pData+SIZE(BITMAPINFOHEADER), ds.dsBm.bits, cbBits)
	GlobalUnlock (hClipMem)

	SetClipboardData ($$CF_DIB, hClipMem)
	CloseClipboard ()

	RETURN $$TRUE		' success

END FUNCTION
'
' ################################
' #####  WinXRegOnDropFiles  #####
' ################################
' Registers the .onDropFiles callback for a window.
' hWnd = the window to register the callback for
' FnOnDropFiles = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnDropFiles (hWnd, FUNCADDR FnOnDropFiles)
	BINDING	binding

	'get the binding
	IFZ hWnd THEN RETURN $$FALSE		' fail
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE		' fail

	DragAcceptFiles (hWnd, $$TRUE)
	binding.onDropFiles = FnOnDropFiles
	bOK = binding_update (idBinding, binding)
	RETURN bOK

END FUNCTION
'
' ####################################
' #####  WinXDraw_GetFontHeight  #####
' ####################################
' Gets the height of a specified font.
FUNCTION WinXDraw_GetFontHeight (hFont, @ascent, @descenct)
	TEXTMETRIC tm

	SetLastError (0)

	ascent = 0
	descent = 0
'
' GL-new+++
	IFZ hFont THEN
		' we need a font
		hFont = GetStockObject ($$SYSTEM_FIXED_FONT)
	ENDIF
' GL-new~~~
'
	IFZ hFont THEN RETURN 0		' unlikely now!

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
' #####################################
' #####  WinXAddAcceleratorTable  #####
' #####################################
'	/*
' [WinXAddAcceleratorTable]
' Description = Creates a new accelerator table for WinAPI TranslateAcceleratorA().
' Function    = WinXAddAcceleratorTable()
' ArgCount    = 1
' Arg1        = ACCEL accel[]: an array of accelerators
' Return      = the new accelerator table handle or 0 on fail
' Remarks     =
' See Also    = WinXAddAccelerator
' Examples    = hAccel = WinXAddAcceleratorTable (@accel[])
' */
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
' ####################################
' #####  WinXAttachAccelerators  #####
' ####################################
' Attaches an accelerator table to a window.
' hWnd         = window to add the accelerator table to
' passed_accel = accelerator table handle
' ===> passing a zero accelerator table's handle clears binding.hAccelTable
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAttachAccelerators (hWnd, passed_accel)
	BINDING binding

	bOK = $$FALSE
	IF hWnd THEN
		' get the binding
		idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
		bOK = binding_get (idBinding, @binding)
		IF bOK THEN
			binding.hAccelTable = passed_accel
			bOK = binding_update (idBinding, binding)
			IFF bOK THEN
				msg$ = "WinXAttachAccelerators: Attached an accelerator table to the window."
				msg$ = msg$ + "\r\nFail!"
				WinXDialog_Error (msg$, "WinX-Debug", 2)
			ENDIF
		ENDIF
	ENDIF

	RETURN bOK

END FUNCTION
'
' ############################
' #####  WinXAddSpinner  #####
' ############################
' Creates a new spinner button
' and adds it to specified window.
' parent = the handle to the parent window
' id     = unique ID constant for the spinner button
' returns the new spinner button handle or 0 on fail
FUNCTION WinXAddSpinner (parent, hBuddy, buddy_x, buddy_y, buddy_w, buddy_h, uppVal, lowVal, curVal, id)

	SetLastError (0)		' reset any prior WinAPI error
	hCtr = 0

	style = $$WS_CHILD OR $$WS_VISIBLE OR $$WS_TABSTOP

	' $$UDS_ARROWKEYS  : Arrow keys
	style = style OR $$UDS_ARROWKEYS		' arrow keys

	SELECT CASE hBuddy
		CASE 0
			SetLastError (0)		' reset any prior WinAPI error
			hCtr = CreateWindowExA (0, &$$UPDOWN_CLASS, 0, style, 0, 0, 0, 0, parent, id, _
									GetModuleHandleA(0), 0)
			IFZ hCtr THEN
				msg$ = "WinXAddSpinner: Can't create the up-down control"
				GuiTellApiError (msg$)
				RETURN 0		' fail
			ENDIF
			'
		CASE ELSE
			' buddy control
			MoveWindow (hBuddy, buddy_x, buddy_y, buddy_w, buddy_h, $$FALSE)
'
' 0.6.0.8-new+++
			' keep uppVal under 98303
			IF uppVal > 98303 THEN uppVal = 98303
' 0.6.0.8-new~~~
'
			IF uppVal < lowVal THEN
				temp = uppVal
				uppVal = lowVal
				lowVal = temp
			ENDIF
			'
			IF (curVal < lowVal) || (curVal > uppVal) THEN
				curVal = lowVal
			ENDIF
			'
			' $$UDS_SETBUDDYINT: Set buddy
			' $$UDS_ALIGNRIGHT : Align right
			' $$UDS_NOTHOUSANDS: no thousand separator
			style = style OR $$UDS_SETBUDDYINT OR $$UDS_ALIGNRIGHT OR $$UDS_NOTHOUSANDS
			'
			SetLastError (0)		' reset any prior WinAPI error
			hCtr = CreateUpDownControl (style, buddy_x, buddy_y, 15, buddy_h, parent, id, GetModuleHandleA(0), hBuddy, uppVal, lowVal, curVal)
			'
	END SELECT

	RETURN hCtr

END FUNCTION
'
' ############################
' #####  WinXPath_Trim$  #####
' ############################
'
' Trims a directory path or a file path
' and corrects the path-slashes to Windows' style.
' (dedicated TRIM$() function for file or directory paths)
'
' Note
' ====
' This function:
' 1. Trims the white-spaces
' 2. Corrects the path-slashes
'
FUNCTION WinXPath_Trim$ (path$)

	upp = UBOUND (path$)
	SELECT CASE upp
		CASE -1
			r_trimmed$ = ""
			'
		CASE ELSE
			' Find the last non-space character, its index is iLast.
			iLast = -1
			FOR i = upp TO 0 STEP -1
				SELECT CASE path${i}
					CASE ' ', '\t', '\n', ':', '*', '?', '\"', '<', '>', '|'		' invalid character
					CASE ELSE
						iLast = i
						EXIT FOR
						'
				END SELECT
			NEXT i
			IF (iLast < 0) THEN
				' empty path => return a null STRING
				r_trimmed$ = ""
				EXIT SELECT
			ENDIF
			'
			' Find the first non-space character, its index is iFirst.
			FOR i = 0 TO iLast
				SELECT CASE path${i}
					CASE ' ', '\t', '\n', ':', '*', '?', '\"', '<', '>', '|'		' invalid character
					CASE ELSE
						iFirst = i
						EXIT FOR
						'
				END SELECT
			NEXT i
			'
			' Trim off leading and trailing white spaces.
			length = iLast - iFirst + 1
			IF (length <= 0) THEN
				' empty path => return a null STRING
				r_trimmed$ = ""
				EXIT SELECT
			ENDIF
			'
			r_trimmed$ = MID$ (path$, iFirst + 1, length)
			'
			' Ensure only Windows path slashes.
			pos = INSTR (r_trimmed$, "/")		' find the first wrong path slash
			DO WHILE (pos > 0)
				r_trimmed${pos - 1} = $$PathSlash		' replace it with the Windows path slash
				pos = INSTR (r_trimmed$, "/", pos + 1)		' find the next wrong path slash
			LOOP
			'
			' Replace any double Windows path slashes by a single one.
			two_sl$ = $$PathSlash$ + $$PathSlash$
			pos = INSTR (r_trimmed$, two_sl$)
			DO WHILE (pos > 0)
				' get rid of the 2nd Windows path slash
				r_trimmed$ = LEFT$ (r_trimmed$, pos) + LCLIP$ (r_trimmed$, pos + 1)
				'
				' (Note that INSTR() restarts from the current position
				' to account for: \\\... changed to \\...)
				pos = INSTR (r_trimmed$, two_sl$, pos)
			LOOP
			'
	END SELECT

	RETURN r_trimmed$

END FUNCTION
'
' ###################################
' #####  WinXMakeFilterString$  #####
' ###################################
'
' Makes a filter string for WinXDialog_OpenFile$() or WinXDialog_SaveFile$().
' file_filter$ = a file filter using | as a separator
' returns a filter string using \0 as a separator.
'
' Usage:
' file_filter$ = "Xblite Sources (*.x*)|*.x;*.xl;*.xbl;*.xxx|M4 Files (*.m4)|*.m4"
' extensions$ = MakeFilterString$ (file_filter$)
' extensions$ == "Xblite Sources (*.x*)\0*.x;*.xl;*.xbl;*.xxx\0M4 Files (*.m4)\0*.m4\0\0"
'
FUNCTION WinXMakeFilterString$ (file_filter$)

	$sep$ = "|"
	$double_sep$ = "||"

	IFZ INSTR (file_filter$, $sep$) THEN RETURN file_filter$
'
' Check if the user provided with 2 trailing separators;
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
		pos = INSTR (extensions$, $sep$, pos+1)
		IFZ pos THEN EXIT DO
		extensions${pos-1} = 0
	LOOP

	RETURN extensions$

END FUNCTION
'
' #########################
' #####  WinXCleanUp  #####
' #########################
'
' WinX Optional Cleanup.
' Graciously stops a running WinX GUI app.
'
FUNCTION WinXCleanUp ()

	SHARED hClipMem		' global memory for clipboard operations
'	SHARED #drag_image		' image list for the dragging effect
	SHARED BINDING bindings[]
	XLONG window_handle[]		' local copy of the array of active windows

	SetLastError (0)
'
' Free global allocated memory.
'
	' global memory needed for clipboard operations
	IF hClipMem THEN GlobalFree (hClipMem)
	hClipMem = 0		' don't free twice

	' image list created by CreateDragImage()
	IF #drag_image THEN ImageList_Destroy (#drag_image)
	#drag_image = 0
'
' 1.Preserve the window handles when they are still available,
'   since WM_DESTROY causes the deletion of corresponding binding.
'
	upp = UBOUND (bindings[])
	DIM window_handle[upp]
	iAdd = -1

	hInst = GetModuleHandleA (0)
	IFZ hInst THEN
		' Unlikely!
		FOR i = 0 TO upp
			IF bindings[i].hWnd THEN
				' preserve the window handle
				INC iAdd
				window_handle[iAdd] = bindings[i].hWnd
			ENDIF
		NEXT i
	ELSE
		FOR i = 0 TO upp
			IF bindings[i].hWnd THEN
				' current window instance must also be program instance handle
				window_instance = GetWindowLongA (bindings[i].hWnd, $$GWL_HINSTANCE)
				SELECT CASE window_instance
					CASE 0, hInst
						' Same instances => preserve the window handle
						INC iAdd
						window_handle[iAdd] = bindings[i].hWnd
						'
				END SELECT
			ENDIF
		NEXT i
	ENDIF

	IF iAdd < upp THEN
		upp = iAdd
		REDIM window_handle[upp]
	ENDIF
'
' 2.Destroy backwards all the windows
' to destroy the main window last.
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
'
'	#bReentry = $$FALSE
'
END FUNCTION
'
' ##########################
' #####  WinXVersion$  #####
' ##########################
'
' Retrieves WinX's current version.
' Usage:
'	version$ = WinXVersion$ ()
'
FUNCTION WinXVersion$ ()

	version$ = VERSION$ (0)
	RETURN (version$)

END FUNCTION
'
' #################################
' #####  WinXSetWindowColour  #####
' #################################
'
' Wrapper to WinXSetWindowColor ().
'
FUNCTION WinXSetWindowColour (hWnd, backRGB)
	bOK = WinXSetWindowColor (hWnd, backRGB)
	RETURN bOK
END FUNCTION
'
' ################################
' #####  WinXDraw_GetColour  #####
' ################################
' Wraps to WinXDraw_GetColour().
FUNCTION WinXDraw_GetColour (hOwner, initialRGB)

	RETURN WinXDraw_GetColor (hOwner, initialRGB)

END FUNCTION
'
' #############################
' #####  WinXAddCheckBox  #####
' #############################
' Wraps to WinXAddCheckButton(.
FUNCTION WinXAddCheckBox (parent, text$, isFirst, pushlike, id)

	bOK = WinXAddCheckButton (parent, text$, isFirst, pushlike, id)

	RETURN bOK
END FUNCTION
'
' ############################
' #####  WinXDraw_Clear  #####
' ############################
' Wraps to WinXClear().
FUNCTION WinXDraw_Clear (hWnd)

	RETURN WinXClear (hWnd)

END FUNCTION
'
' #############################
' #####  GuiTellApiError  #####
' #############################
' Displays a WinAPI error message.
' returns bErr: $$TRUE only if an error REALLY occurred
FUNCTION GuiTellApiError (msg$)

	' get the last error code, then clear it
	errNum = GetLastError ()
	SetLastError (0)
	IFZ errNum THEN RETURN		' was OK!

	fmtMsg$ = "Last error code " + STRING$ (errNum) + ": "

	' set up FormatMessageA arguments
	dwFlags = $$FORMAT_MESSAGE_FROM_SYSTEM OR $$FORMAT_MESSAGE_IGNORE_INSERTS
	sizeBuf = 1020
	szBuf$ = NULL$ (sizeBuf)		' NULL$() always adds a nul-terminator
	ret = FormatMessageA (dwFlags, 0, errNum, 0, &szBuf$, sizeBuf, 0)
	IFZ ret THEN
		fmtMsg$ = fmtMsg$ + "(unknown)"
	ELSE
		fmtMsg$ = fmtMsg$ + CSTRING$ (&szBuf$)
	ENDIF

	IFZ msg$ THEN msg$ = "Windows API error"
	fmtMsg$ = fmtMsg$ + "\r\n\r\n" + msg$

	' get the running OS's name and version
	bErr = XstGetOSName (@osName$)
	IF bErr THEN
		st$ = "(unknown)"
	ELSE
		IFZ osName$ THEN osName$ = "(unknown)"
		st$ = osName$ + " ver "
		bErr = XstGetOSVersion (@major, @minor, @platformId, @version$, @platform$)
		IF bErr THEN
			st$ = st$ + " (unknown)"
		ELSE
			st$ = st$ + STR$ (major) + "." + STRING$ (minor) + "-" + platform$
		ENDIF
	ENDIF
	fmtMsg$ = fmtMsg$ + "\r\n\r\nOS: " + st$
	WinXDialog_Error (fmtMsg$, "WinX-API Error", 2)		' error

	RETURN $$TRUE		' an error really occurred!

END FUNCTION
'
' ################################
' #####  GuiTellDialogError  #####
' ################################
'
' Debugging function for Windows standard dialogs WinXDialog_*'s:
' calls CommDlgExtendedError to get error code
' and displays the formatted run-time error message.
'
FUNCTION GuiTellDialogError (hOwner, title$)

	IFZ TRIM$ (title$) THEN title$ = "WinX-Standard Dialog Error"

	' call CommDlgExtendedError to get error code
	extErr = CommDlgExtendedError ()

	SELECT CASE extErr
		CASE 0
			' fmtMsg$ = "Cancel pressed, no error"
			RETURN		' don't display fmtMsg$
			'
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
			'
		CASE ELSE : fmtMsg$ = "Unknown error code"
	END SELECT

	fmtMsg$ = "GuiTellDialogError: Last error code " + STRING$ (extErr) + ": " + fmtMsg$
'
' GL-10oct22-old---
'	WinXDialog_Error (fmtMsg$, "WinX-API Error", 2)		' error
' GL-10oct22-old~~~
' GL-10oct22-new+++
	IFZ hOwner THEN
		hOwner = GetActiveWindow ()
	ENDIF
	IFZ TRIM$(title$) THEN
		title$ = "WinX-Standard Dialog Error"
	ENDIF
	MessageBoxA (hOwner, &fmtMsg$, &title$, $$MB_ICONSTOP)
' GL-10oct22-new~~~
'
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
		WinXDialog_Error (fmtMsg$, "WinX-Run-time Error", 2)		' error
	ENDIF

	RETURN bErr

END FUNCTION

END PROGRAM
