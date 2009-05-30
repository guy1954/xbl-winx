'
' ####################
' #####  PROLOG  #####
' ####################
'
' WinX - *The* GUI library for XBlite
' (c) Callum Lowcay 2007-2008
' The WinX GUI library is distributed under the
' terms and conditions of the GNU LGPL, see the file COPYING_LIB
' which should be included in the WinX distribution.
'
PROGRAM	"WinX"
VERSION "0.6.0.1"
'
	IMPORT "xst"				' Standard library : required by most programs
	IMPORT "xsx_s"				' Extended standard library
	IMPORT "xma_s"
'	IMPORT "xio"				' Console input/ouput library

'	IMPORT "xst_s.lib"
'	IMPORT "xsx_s.lib"
'	IMPORT "xma_s.lib"
' IMPORT "xio_s.lib"

	IMPORT "gdi32"			' gdi32.dll
	IMPORT "msimg32"
	IMPORT "user32"		  ' user32.dll
	IMPORT "kernel32"	  ' kernel32.dll
	IMPORT "comctl32"
	IMPORT "comdlg32"
	IMPORT "advapi32"
	IMPORT "shell32"		' shell32.dll
'	IMPORT "msvcrt"		  ' msvcrt.dll
	IMPORT "ADT"

'the data type to manage bindings
TYPE BINDING
	XLONG			.hWnd						'handle to the window this binds to, when 0, this record is not in use
	XLONG			.backCol				'window background colour
	XLONG			.hStatus				'handle to the status bar, if there is one
	XLONG			.statusParts		'the number of partitions in the status bar
	XLONG			.msgHandlers		'index into an array of arrays of message handlers
	XLONG			.minW
	XLONG			.minH
	XLONG			.maxW
	XLONG			.maxH
	XLONG			.autoDrawInfo		'imformation for the auto drawer
	XLONG			.autoSizerInfo	'information for the auto sizer
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
	FUNCADDR	.paint (XLONG, XLONG)	'hWnd, hdc : paint the window
	FUNCADDR	.dimControls (XLONG, XLONG, XLONG)	'hWnd, w, h : dimension the controls
	FUNCADDR	.onCommand(XLONG, XLONG, XLONG)		'id, code, hWnd
	FUNCADDR	.onMouseMove(XLONG, XLONG, XLONG)	'hWnd, x, y
	FUNCADDR	.onMouseDown(XLONG, XLONG, XLONG, XLONG)					'hWnd, MBT const, x, y
	FUNCADDR	.onMouseUp(XLONG, XLONG, XLONG, XLONG)						'hWnd, MBT const, x, y
	FUNCADDR	.onMouseWheel(XLONG, XLONG, XLONG, XLONG)	'hWnd, delta, x, y
	FUNCADDR	.onKeyDown(XLONG, XLONG)			'hWnd, VK
	FUNCADDR	.onKeyUp(XLONG, XLONG)				'hWnd, VK
	FUNCADDR	.onChar(XLONG, XLONG)				'hWnd, char
	FUNCADDR	.onScroll(XLONG, XLONG, XLONG)	'pos, hWnd, direction
	FUNCADDR	.onTrackerPos(XLONG, XLONG)		'id, pos
	FUNCADDR	.onDrag(XLONG, XLONG, XLONG, XLONG, XLONG)	'idControl, drag const, item, x, y
	FUNCADDR	.onLabelEdit(XLONG, XLONG, XLONG, STRING)	'idControl, edit const, item, newLabel
	FUNCADDR	.onClose(XLONG)	' hWnd
	FUNCADDR	.onFocusChange(XLONG, XLONG)	' hWnd, hasFocus
	FUNCADDR	.onClipChange()	' Sent when clipboard changes
	FUNCADDR	.onEnterLeave(XLONG, XLONG)	' hWnd, mouseInWindow
	FUNCADDR	.onItem (XLONG, XLONG, XLONG)		' idControl, event, parameter
	FUNCADDR	.onColumnClick (XLONG, XLONG)		' idControl, iColumn
	FUNCADDR	.onCalendarSelect (XLONG, SYSTEMTIME)	' idcal, time
	FUNCADDR	.onDropFiles (XLONG, XLONG, XLONG, STRING[])	' hWnd, x, y, files
END TYPE
'message handler data type
TYPE MSGHANDLER
	XLONG			.msg	'when 0, this record is not in use
	FUNCADDR	.handler(XLONG, XLONG, XLONG, XLONG)
END TYPE
'Headers for grouped lists
TYPE DRAWLISTHEAD
	XLONG			.inUse
	XLONG			.firstItem
	XLONG			.lastItem
END TYPE
TYPE SIZELISTHEAD
	XLONG			.inUse
	XLONG			.firstItem
	XLONG			.lastItem
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
TYPE SPLITTERINFO
	XLONG			.group
	XLONG			.id
	XLONG			.direction
	XLONG			.maxSize
	
	XLONG			.min
	XLONG			.max
	XLONG			.dock
	XLONG			.docked	' 0 if not docked, old position when docked
END IF
$$DOCK_DISABLED	= 0
$$DOCK_FOWARD		= 1
$$DOCK_BACKWARD	= 2
'data structures for auto draw
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
	XLONG 	.xC2
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
	XLONG		.forColour
	XLONG		.backColour
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

m4_include(`accessors.m4')

'
EXPORT

'constants and structures missing from the XBlite headers, uncomment ids as neccassary
'missing from msimg32.dec
$$AC_SRC_OVER = 0x00
$$AC_SRC_ALPHA = 0x01
'missing from commctl32.dec
$$PBS_MARQUEE = 0x08
$$PBM_SETMARQUEE = 1034
$$TBSTYLE_EX_DOUBLEBUFFER = 0x00000080
$$ACS_CENTER			= 0x0001
$$ACS_TRANSPARENT	= 0x0002
$$LVM_SORTITEMSEX = 0x1051

' from user32
'$$TPM_LEFTBUTTON  = 0x0000
$$TPM_TOPALIGN        = 0x0000
$$TPM_RECURSE         = 0x0001
$$TPM_HORPOSANIMATION = 0x0400
$$TPM_HORNEGANIMATION = 0x0800
$$TPM_VERPOSANIMATION = 0x1000
$$TPM_VERNEGANIMATION = 0x2000
$$TPM_NOANIMATION     = 0x4000
$$TPM_LAYOUTRTL       = 0x8000

PACKED BITMAPFILEHEADER
  USHORT  .bfType
  ULONG   .bfSize
  USHORT  .bfReserved1
  USHORT  .bfReserved2
  ULONG   .bfOffBits
END TYPE

$$TBMF_PAD                = 0x00000001
$$TBMF_BARPAD             = 0x00000002
$$TBMF_BUTTONSPACING      = 0x00000004
$$TB_GETMETRICS           = 1125
$$TB_SETMETRICS           = 1126

TYPE TBMETRICS
	ULONG .cbSize
	ULONG .dwMask
	XLONG .cxPad
	XLONG .cyPad
	XLONG .cxBarPad
	XLONG .cyBarPad
	XLONG .cxButtonSpacing
	XLONG .cyButtonSpacing
END TYPE

$$CB_GETCOMBOBOXINFO         = 0x0164
TYPE COMBOBOXINFO
	ULONG	.cbSize
	RECT	.rcItem
	RECT	.rcButton
	ULONG	.stateButton
	XLONG	.hwndCombo
	XLONG	.hwndItem
	XLONG	.hwndList
END TYPE

'Now the WinX specific stuff
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

$$SIZER_SIZERELREST	= 0x00000001
$$SIZER_XRELRIGHT		= 0x00000002
$$SIZER_YRELBOTTOM	= 0x00000004
$$SIZER_SERIES			= 0x00000008
$$SIZER_WCOMPLEMENT	= 0x00000010
$$SIZER_HCOMPLEMENT	= 0x00000020
$$SIZER_SPLITTER		= 0x00000040

$$CONTROL			= 0
$$DIR_VERT		= 1
$$DIR_HORIZ		= 2
$$DIR_REVERSE	= 0x80000000

$$UNIT_LINE		= 0
$$UNIT_PAGE		= 1
$$UNIT_END		= 2

$$DRAG_START		= 0
$$DRAG_DRAGGING	= 1
$$DRAG_DONE			= 2

$$EDIT_START		= 0
$$EDIT_DONE			= 1

$$CHANNEL_RED		= 2
$$CHANNEL_GREEN	= 1
$$CHANNEL_BLUE	= 0
$$CHANNEL_ALPHA	= 3

$$ACL_REG_STANDARD = "D:(A;OICI;GRKRKW;;;WD)(A;OICI;GAKA;;;BA)"

DECLARE FUNCTION WinX ()
DECLARE FUNCTION WinXNewWindow (hOwner, STRING title, x, y, w, h, simpleStyle, exStyle, icon, menu)
DECLARE FUNCTION WinXRegOnPaint (hWnd, FUNCADDR onPaint)
DECLARE FUNCTION WinXDisplay (hWnd)
DECLARE FUNCTION WinXDoEvents (hAccel)
DECLARE FUNCTION WinXRegMessageHandler (hWnd, msg, FUNCADDR msgHandler)
DECLARE FUNCTION WinXRegControlSizer (hWnd, FUNCADDR controlSizer)
DECLARE FUNCTION WinXAddButton (parent, STRING title, hImage, id)
DECLARE FUNCTION WinXSetText (hWnd, STRING text)
DECLARE FUNCTION WinXGetText$ (hWnd)
DECLARE FUNCTION WinXHide (hWnd)
DECLARE FUNCTION WinXShow (hWnd)
DECLARE FUNCTION WinXAddStatic (parent, STRING title, hImage, style, id)
DECLARE FUNCTION WinXAddEdit (parent, STRING title, style, id)
DECLARE FUNCTION WinXAutoSizer_SetInfo (hWnd, series, 	DOUBLE space, DOUBLE size, DOUBLE x, DOUBLE y, DOUBLE w, DOUBLE h, flags)
DECLARE FUNCTION WinXSetMinSize (hWnd, w, h)
DECLARE FUNCTION WinXRegOnCommand (hWnd, FUNCADDR onCommand)
END EXPORT

DECLARE FUNCTION ApiLBItemFromPt (hLB, x, y, bAutoScroll)
DECLARE FUNCTION ApiAlphaBlend (hdcDest, nXOriginDest, nYOrigDest, nWidthDest, nHeightDest, hdcSrc, nXOriginSrc, nYOriginSrc, nWidthSrc, nHeightSrc, BLENDFUNCTION blendFunction)
DECLARE FUNCTION mainWndProc (hWnd, msg, wParam, lParam)
DECLARE FUNCTION splitterProc (hWnd, msg, wParam, lParam)
DECLARE FUNCTION onNotify (hWnd, wParam, lParam, BINDING binding)
DECLARE FUNCTION sizeWindow (hWnd, w, h)
DECLARE FUNCTION autoSizer (AUTOSIZERINFO	autoSizerBlock, direction, x0, y0, w, h, currPos)
DECLARE FUNCTION XWSStoWS (xwss)
'callbacks for internal dialogs
DECLARE FUNCTION cancelDlgOnClose (hWnd)
DECLARE FUNCTION cancelDlgOnCommand (id, code, hWnd)
DECLARE FUNCTION printAbortProc (hdc, nCode)
'These functions abstract away access to the arrays
DECLARE FUNCTION binding_add (BINDING binding)
DECLARE FUNCTION binding_delete (id)
DECLARE FUNCTION binding_get (id, BINDING @binding)
DECLARE FUNCTION binding_update (id, BINDING binding)
DECLARE FUNCTION handler_addGroup ()
DECLARE FUNCTION handler_add (group, MSGHANDLER handler)
DECLARE FUNCTION handler_get (group, id, MSGHANDLER @handler)
DECLARE FUNCTION handler_update (group, id, MSGHANDLER handler)
DECLARE FUNCTION handler_find (group, msg)
DECLARE FUNCTION handler_call (group, @ret, hWnd, msg, wParam, lParam)
DECLARE FUNCTION handler_delete (group, id)
DECLARE FUNCTION handler_deleteGroup (group)
DECLARE FUNCTION autoSizerInfo_addGroup (direction)
DECLARE FUNCTION autoSizerInfo_deleteGroup (group)
DECLARE FUNCTION autoSizerInfo_add (group, AUTOSIZERINFO autoSizerBlock)
DECLARE FUNCTION autoSizerInfo_delete (group, id)
DECLARE FUNCTION autoSizerInfo_get (group, id, AUTOSIZERINFO @autoSizerBlock)
DECLARE FUNCTION autoSizerInfo_update (group, id, AUTOSIZERINFO autoSizerBlock)
DECLARE FUNCTION autoSizerInfo_sizeGroup (group, x0, y0, w, h)
DECLARE FUNCTION autoSizerInfo_showGroup (group, visible)
DECLARE FUNCTION autoDraw_clear (group)
DECLARE FUNCTION autoDraw_draw (hdc, group, x0, y0)
DECLARE FUNCTION autoDraw_add (iList, iRecord)
DECLARE FUNCTION initPrintInfo ()
DeclareAccess(SPLITTERINFO)
DeclareAccess(LINKEDLIST)
DeclareAccess(AUTODRAWRECORD)

DECLARE FUNCTION VOID drawLine (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION VOID drawEllipse (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION VOID drawRect (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION VOID drawEllipseNoFill (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION VOID drawRectNoFill (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION VOID drawArc (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION VOID drawFill (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION VOID drawBezier (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION VOID drawText (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION VOID drawImage (hdc, AUTODRAWRECORD record, x0, y0)
DECLARE FUNCTION tabs_SizeContents (hTabs, pRect)
DECLARE FUNCTION groupBox_SizeContents (hGB, pRect)
DECLARE FUNCTION CompareLVItems (item1, item2, hLV)

EXPORT
DECLARE FUNCTION WinXDrawLine (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXClear (hWnd)
DECLARE FUNCTION WinXUpdate (hWnd)
DECLARE FUNCTION WinXDrawFilledEllipse (hWnd, hPen, hBrush, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawFilledRect (hWnd, hPen, hBrush, x1, y1, x2, y2)
DECLARE FUNCTION WinXNewMenu (STRING menu, firstID, isPopup)
DECLARE FUNCTION WinXMenu_Attach (subMenu, newParent, id)
DECLARE FUNCTION WinXAddStatusBar (hWnd, STRING initialStatus, id)
DECLARE FUNCTION WinXStatus_SetText (hWnd, part, STRING text)
DECLARE FUNCTION WinXStatus_GetText$ (hWnd, part)
DECLARE FUNCTION WinXRegOnMouseMove (hWnd, FUNCADDR onMouseMove)
DECLARE FUNCTION WinXRegOnMouseDown (hWnd, FUNCADDR onMouseDown)
DECLARE FUNCTION WinXRegOnMouseWheel (hWnd, FUNCADDR onMouseWheel)
DECLARE FUNCTION WinXRegOnMouseUp (hWnd, FUNCADDR onMouseUp)
DECLARE FUNCTION WinXNewToolbar (wButton, hButton, nButtons, hBmpButtons, hBmpGray, hBmpHot, rgbTrans, toolTips, customisable)
DECLARE FUNCTION WinXToolbar_AddButton (hToolbar, commandId, iImage, STRING tooltipText, optional, moveable)
DECLARE FUNCTION WinXSetWindowToolbar (hWnd, hToolbar)
DECLARE FUNCTION WinXAddTooltip (hControl, STRING tooltipText)
DECLARE FUNCTION WinXGetUseableRect (hWnd, RECT @rect)
DECLARE FUNCTION WinXNewToolbarUsingIls (hilMain, hilGray, hilHot, toolTips, customisable)
DECLARE FUNCTION WinXUndo (hWnd, id)
'new in 0.3
DECLARE FUNCTION WinXRegOnKeyDown (hWnd, FUNCADDR onKeyDown)
DECLARE FUNCTION WinXRegOnKeyUp (hWnd, FUNCADDR onKeyUp)
DECLARE FUNCTION WinXRegOnChar (hWnd, FUNCADDR onChar)
DECLARE FUNCTION WinXIsKeyDown (key)
DECLARE FUNCTION WinXIsMousePressed (button)
DECLARE FUNCTION WinXAddControl (parent, STRING class, STRING title, style, exStyle, id)
DECLARE FUNCTION WinXAddListBox (parent, sort, multiSelect, id)
DECLARE FUNCTION WinXAddComboBox (parent, listHeight, canEdit, images, id)
DECLARE FUNCTION WinXListBox_AddItem (hListBox, index, Item$)
DECLARE FUNCTION WinXListBox_RemoveItem (hListBox, index)
DECLARE FUNCTION WinXListBox_GetSelection (hListBox, @index[])
DECLARE FUNCTION WinXListBox_GetIndex (hListBox, Item$)
DECLARE FUNCTION WinXListBox_SetSelection (hListBox, index[])
DECLARE FUNCTION WinXDialog_OpenFile$ (parent, title$, extensions$, initialName$, multiSelect)
DECLARE FUNCTION WinXDialog_SaveFile$ (parent, title$, extensions$, initialName$, overwritePrompt)
DECLARE FUNCTION WinXListBox_GetItem$ (hListBox, index)
DECLARE FUNCTION WinXComboBox_AddItem (hCombo, index, indent, item$, iImage, iSelImage)
DECLARE FUNCTION WinXComboBox_RemoveItem (hCombo, index)
DECLARE FUNCTION WinXComboBox_GetSelection (hCombo)
DECLARE FUNCTION WinXComboBox_SetSelection (hCombo, index)
DECLARE FUNCTION WinXComboBox_GetItem$ (hCombo, index)
DECLARE FUNCTION WinXNewAutoSizerSeries (direction)
'new in 0.4
DECLARE FUNCTION WinXAddCheckButton (parent, STRING title, isFirst, pushlike, id)
DECLARE FUNCTION WinXAddRadioButton (parent, STRING title, isFirst, pushlike, id)
DECLARE FUNCTION WinXButton_SetCheck (hButton, checked)
DECLARE FUNCTION WinXButton_GetCheck (hButton)
DECLARE FUNCTION WinXAddTreeView (parent, hImages, editable, draggable, id)
DECLARE FUNCTION WinXAddProgressBar (parent, smooth, id)
DECLARE FUNCTION WinXAddTrackBar (parent, enableSelection, posToolTip, id)
DECLARE FUNCTION WinXAddTabs (parent, multiline, id)
DECLARE FUNCTION WinXAddAnimation (parent, STRING file, id)
DECLARE FUNCTION WinXRegOnDrag (hWnd, FUNCADDR onDrag)
DECLARE FUNCTION WinXListBox_EnableDragging (hListBox)
DECLARE FUNCTION WinXAutoSizer_GetMainSeries (hWnd)
DECLARE FUNCTION WinXDialog_Error (STRING message, STRING title, severity)
DECLARE FUNCTION WinXProgress_SetPos (hProg, DOUBLE pos)
DECLARE FUNCTION WinXProgress_SetMarquee (hProg, enable)
DECLARE FUNCTION WinXRegOnScroll (hWnd, FUNCADDR onScroll)
DECLARE FUNCTION WinXScroll_Show (hWnd, horiz, vert)
DECLARE FUNCTION WinXScroll_SetRange (hWnd, direction, min, max)
DECLARE FUNCTION WinXScroll_SetPage (hWnd, direction, DOUBLE mul, constant, scrollUnit)
DECLARE FUNCTION WinXRegOnTrackerPos (hWnd, FUNCADDR onTrackerPos)
DECLARE FUNCTION WinXTracker_GetPos (hTracker)
DECLARE FUNCTION WinXTracker_SetPos (hTracker, newPos)
DECLARE FUNCTION WinXTracker_SetRange  (hTracker, USHORT min, USHORT max, ticks)
DECLARE FUNCTION WinXTracker_SetSelRange (hTracker, USHORT start, USHORT end)
DECLARE FUNCTION WinXTracker_SetLabels (hTracker, STRING leftLabel, STRING rightLabel)
DECLARE FUNCTION WinXScroll_Update (hWnd, deltaX, deltaY)
DECLARE FUNCTION WinXScroll_Scroll (hWnd, direction, unitType, scrollingDirection)
DECLARE FUNCTION WinXEnableDialogInterface (hWnd, enable)
DECLARE FUNCTION WinXAni_Play (hAni)
DECLARE FUNCTION WinXAni_Stop (hAni)
DECLARE FUNCTION WinXListBox_SetCaret (hListBox, item)
DECLARE FUNCTION WinXSetStyle (hWnd, add, addEx, sub, subEx)
DECLARE FUNCTION WinXTreeView_AddItem (hTreeView, hParent, hInsertAfter, iImage, iImageSelect, STRING item)
DECLARE FUNCTION WinXTreeView_GetNextItem (hTreeView, hItem)
DECLARE FUNCTION WinXTreeView_GetChildItem (hTreeView, hItem)
DECLARE FUNCTION WinXTreeView_GetParentItem (hTreeView, hItem)
DECLARE FUNCTION WinXTreeView_GetPreviousItem (hTreeView, hItem)
DECLARE FUNCTION WinXTreeView_DeleteItem (hTreeView, hItem)
DECLARE FUNCTION WinXTreeView_GetSelection (hTreeView)
DECLARE FUNCTION WinXTreeView_SetSelection (hTreeView, hItem)
DECLARE FUNCTION WinXTreeView_GetItemLabel$ (hTreeView, hItem)
DECLARE FUNCTION WinXTreeView_SetItemLabel (hTreeView, hItem, STRING label)
DECLARE FUNCTION WinXRegOnLabelEdit (hWnd, FUNCADDR onLabelEdit)
DECLARE FUNCTION WinXTreeView_CopyItem (hTreeView, hParentItem, hItemInsertAfter, hItem)
DECLARE FUNCTION WinXTabs_AddTab (hTabs, STRING label, index)
DECLARE FUNCTION WinXTabs_DeleteTab (hTabs, iTab)
DECLARE FUNCTION WinXTabs_GetAutosizerSeries (hTabs, iTab)
DECLARE FUNCTION WinXTabs_GetCurrentTab (hTabs)
DECLARE FUNCTION WinXTabs_SetCurrentTab (hTabs, iTab)
DECLARE FUNCTION WinXToolbar_AddToggleButton (hToolbar, commandId, iImage, STRING tooltipText, mutex, optional, moveable)
DECLARE FUNCTION WinXToolbar_AddSeperator (hToolbar)
DECLARE FUNCTION WinXToolbar_AddControl (hToolbar, hControl, w)
DECLARE FUNCTION WinXToolbar_EnableButton (hToolbar, iButton, enable)
DECLARE FUNCTION WinXToolbar_ToggleButton (hToolbar, iButton, on)
'0.4.1
DECLARE FUNCTION WinXComboBox_GetEditText$ (hCombo)
DECLARE FUNCTION WinXComboBox_SetEditText (hCombo, STRING text)
DECLARE FUNCTION WinXAddGroupBox (parent, STRING label, id)
DECLARE FUNCTION WinXGroupBox_GetAutosizerSeries (hGB)
'new in 0.4.2
DECLARE FUNCTION WinXDrawEllipse (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawRect (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawBezier (hWnd, hPen, x1, y1, x2, y2, xC1, yC1, xC2, yC2)
DECLARE FUNCTION WinXDrawArc (hWnd, hPen, x1, y1, x2, y2, DOUBLE theta1, DOUBLE theta2)
DECLARE FUNCTION WinXDrawFilledArea (hWnd, hBrush, colBound, x, y)
DECLARE FUNCTION WinXRegOnClose (hWnd, FUNCADDR onClose)
DECLARE FUNCTION WinXAutoSizer_SetSimpleInfo (hWnd, series, DOUBLE space, DOUBLE size, flags)
DECLARE FUNCTION WinXAddListView (parent, hilLargeIcons, hilSmallIcons, editable, view, id)
DECLARE FUNCTION WinXListView_SetView (hLV, view)
DECLARE FUNCTION WinXListView_AddColumn (hLV, iColumn, wColumn, STRING label, iSubItem)
DECLARE FUNCTION WinXListView_DeleteColumn (hLV, iColumn)
DECLARE FUNCTION WinXListView_AddItem (hLV, iItem, STRING item, iIcon)
DECLARE FUNCTION WinXListView_DeleteItem (hLV, iItem)
DECLARE FUNCTION WinXListView_GetSelection (hLV, @iItems[])
DECLARE FUNCTION WinXListView_SetSelection (hLV, iItems[])
DECLARE FUNCTION WinXListView_SetItemText (hLV, iItem, iSubItem, STRING newText)
'new in 0.5
DECLARE FUNCTION LOGFONT WinXDraw_MakeLogFont (STRING font, height, style)
DECLARE FUNCTION WinXDraw_GetFontDialog (hWndOwner, LOGFONT @logFont, @colour)
DECLARE FUNCTION WinXDraw_GetTextWidth (hFont, STRING text, maxWidth)
DECLARE FUNCTION DOUBLE WinXDraw_PixelsPerPoint ()
DECLARE FUNCTION WinXDrawText (hWnd, hFont, STRING text, x, y, backCol, forCol)
DECLARE FUNCTION WinXDraw_GetColour (hWndOwner, initialColour)
DECLARE FUNCTION WinXDraw_CreateImage (w, h)
DECLARE FUNCTION WinXDraw_LoadImage (STRING fileName, fileType)
DECLARE FUNCTION WinXDraw_DeleteImage (hImage)
DECLARE FUNCTION WinXDraw_Snapshot (hWnd, x, y, hImage)
DECLARE FUNCTION WinXDraw_SaveImage (hImage, STRING fileName, fileType)
DECLARE FUNCTION WinXDraw_ResizeImage (hImage, w, h)
DECLARE FUNCTION WinXDraw_SetImagePixel (hImage, x, y, colour)
DECLARE FUNCTION RGBA WinXDraw_GetImagePixel (hImage, x, y)
DECLARE FUNCTION WinXDraw_SetConstantAlpha (hImage, DOUBLE alpha)
DECLARE FUNCTION WinXDraw_SetImageChannel (hImage, channel, UBYTE @data[])
DECLARE FUNCTION WinXDraw_GetImageChannel (hImage, channel, UBYTE @data[])
DECLARE FUNCTION WinXDraw_GetImageInfo (hImage, @w, @h, @pBits)
DECLARE FUNCTION WinXDraw_CopyImage (hImage)
DECLARE FUNCTION WinXDraw_PremultiplyImage (hImage)
DECLARE FUNCTION WinXDrawImage (hWnd, hImage, x, y, w, h, xSrc, ySrc, blend)
DECLARE FUNCTION WinXPrint_Start (minPage, maxPage, @rangeMin, @rangeMax, @cxPhys, @cyPhys, fileName$, showDialog, hWndOwner)
DECLARE FUNCTION DOUBLE WinXPrint_LogUnitsPerPoint (hPrinter, cyLog, cyPhys)
DECLARE FUNCTION WinXPrint_DevUnitsPerInch (hPrinter, @w, @h)
DECLARE FUNCTION WinXPrint_PageSetup (hWndOwner)
DECLARE FUNCTION WinXPrint_Page (hPrinter, hWnd, x, y, cxLog, cyLog, cxPhys, cyPhys, pageNum, pageCount)
DECLARE FUNCTION WinXPrint_Done (hPrinter)
'new in 0.6
DECLARE FUNCTION WinXNewChildWindow (hParent, STRING title, style, exStyle, id)
DECLARE FUNCTION WinXRegOnFocusChange (hWnd, FUNCADDR onFocusChange)
DECLARE FUNCTION WinXSetWindowColour (hWnd, colour)
DECLARE FUNCTION WinXListView_GetItemText (hLV, iItem, cSubItems, @text$[])
DECLARE FUNCTION WinXDialog_Message (hWnd, text$, title$, iIcon, hMod)
DECLARE FUNCTION WinXDialog_Question (hWnd, text$, title$, cancel, defaultButton)
DECLARE FUNCTION WinXSplitter_SetProperties (series, hCtrl, min, max, dock)
DECLARE FUNCTION WinXRegistry_ReadInt (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result)
DECLARE FUNCTION WinXRegistry_ReadString (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
DECLARE FUNCTION WinXRegistry_ReadBin (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
DECLARE FUNCTION WinXRegistry_WriteInt (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, int)
DECLARE FUNCTION WinXRegistry_WriteString (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, buffer$)
DECLARE FUNCTION WinXRegistry_WriteBin (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, buffer$)
DECLARE FUNCTION WinXAddAccelerator (ACCEL @accel[], cmd, key, control, alt, shift)
DECLARE FUNCTION WinXSplitter_GetPos (series, hCtrl, @position, @docked)
DECLARE FUNCTION WinXSplitter_SetPos (series, hCtrl, position, docked)
DECLARE FUNCTION WinXClip_IsString ()
DECLARE FUNCTION WinXClip_PutString (Stri$)
DECLARE FUNCTION WinXClip_GetString$ ()
DECLARE FUNCTION WinXRegOnClipChange (hWnd, FUNCADDR onClipChange)
DECLARE FUNCTION SECURITY_ATTRIBUTES WinXNewACL (ssd$, inherit)
DECLARE FUNCTION WinXSetCursor (hWnd, hCursor)
DECLARE FUNCTION WinXScroll_GetPos (hWnd, direction, @pos)
DECLARE FUNCTION WinXScroll_SetPos (hWnd, direction, pos)
DECLARE FUNCTION WinXRegOnItem (hWnd, FUNCADDR onItem)
DECLARE FUNCTION WinXRegOnColumnClick (hWnd, FUNCADDR onColumnClick)
DECLARE FUNCTION WinXRegOnEnterLeave (hWnd, FUNCADDR onEnterLeave)
DECLARE FUNCTION WinXListView_GetItemFromPoint (hLV, x, y)
DECLARE FUNCTION WinXListView_Sort (hLV, iCol, desc)
DECLARE FUNCTION WinXTreeView_GetItemFromPoint (hTV, x, y)
DECLARE FUNCTION WinXGetPlacement (hWnd, @minMax, RECT @restored)
DECLARE FUNCTION WinXSetPlacement (hWnd, minMax, RECT restored)
DECLARE FUNCTION WinXGetMousePos (hWnd, @x, @y)
DECLARE FUNCTION WinXAddCalendar (hParent, @monthsX, @monthsY, id)
DECLARE FUNCTION WinXCalendar_SetSelection (hCal, SYSTEMTIME time)
DECLARE FUNCTION WinXCalendar_GetSelection (hCal, SYSTEMTIME @time)
DECLARE FUNCTION WinXRegOnCalendarSelect (hWnd, FUNCADDR onCalendarSelect)
DECLARE FUNCTION WinXAddTimePicker (hParent, format, SYSTEMTIME initialTime, timeValid, id)
DECLARE FUNCTION WinXTimePicker_SetTime (hDTP, SYSTEMTIME time, timeValid)
DECLARE FUNCTION WinXTimePicker_GetTime (hDTP, SYSTEMTIME @time, @timeValid)
DECLARE FUNCTION WinXSetFont (hCtrl, hFont)
DECLARE FUNCTION WinXClip_IsImage ()
DECLARE FUNCTION WinXClip_GetImage ()
DECLARE FUNCTION WinXClip_PutImage (hImage)
DECLARE FUNCTION WinXRegOnDropFiles (hWnd, FUNCADDR onDrag)
DECLARE FUNCTION WinXDraw_GetFontHeight (hFont, @ascent, @descenct)

END EXPORT
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
'	Return      = 0 on success, else non 0.
' Remarks     = Sometimes this gets called automatically.  If your program crashes as soon as you call WinXNewWindow then WinX has not been initialised properly.
'	See Also    =
'	Examples    = IFF WinX () THEN QUIT(0)
'	*/
FUNCTION WinX ()
	SHARED		hInst
	SHARED		BINDING	bindings[]			'a simple array of bindings
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		handlersUM[]	'a usage map so we can see which groups are in use
	
	SHARED		AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED		SIZELISTHEAD autoSizerInfoUM[]
	
	SHARED		AUTODRAWRECORD	autoDrawInfo[]	'info for the auto draw
	SHARED		DRAWLISTHEAD autoDrawInfoUM[]
	
	SHARED TBBUTTONDATA tbbd[]	' info for toolbar customisation
	SHARED tbbdUM[]
	
	WNDCLASS	wc
	INITCOMMONCONTROLSEX	icc
	
	STATIC init
	
	IF init THEN RETURN 0
	
	Xst ()
	Xsx ()
	Xma ()
	
	hInst = GetModuleHandleA (0)
	
	ADT ()
	
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
	
	initPrintInfo ()
	
	icc.dwSize = SIZE(INITCOMMONCONTROLSEX)
	icc.dwICC = $$ICC_ANIMATE_CLASS|$$ICC_BAR_CLASSES|$$ICC_COOL_CLASSES|$$ICC_DATE_CLASSES| _
	$$ICC_HOTKEY_CLASS|$$ICC_LISTVIEW_CLASSES|$$ICC_TAB_CLASSES|$$ICC_TREEVIEW_CLASSES| _
	$$ICC_UPDOWN_CLASS|$$ICC_USEREX_CLASSES|$$ICC_WIN95_CLASSES
	
	IFF InitCommonControlsEx (&icc) THEN RETURN $$TRUE

	hLib = LoadLibraryA (&"WinX.dll")
	hIcon = LoadIconA (hLib, &"WinXIcon")
	FreeLibrary (hLib)

	'register window class
	wc.style					= $$CS_PARENTDC
	wc.lpfnWndProc		= &mainWndProc()
	wc.cbWndExtra			= 4
	wc.hInstance			= hInst
	wc.hIcon					= hIcon
	wc.hCursor				= LoadCursorA (0, $$IDC_ARROW)
	wc.hbrBackground	= $$COLOR_BTNFACE + 1
	wc.lpszClassName	= &"WinXMainClass"
	IFZ RegisterClassA (&wc) THEN RETURN $$TRUE
	
	wc.style					= $$CS_PARENTDC
	wc.lpfnWndProc		= &splitterProc()
	wc.cbWndExtra			= 4
	wc.hInstance			= hInst
	wc.hIcon					= 0
	wc.hCursor				= 0
	wc.hbrBackground	= $$COLOR_BTNFACE + 1
	wc.lpszClassName	= &"WinXSplitterClass"
	IFZ RegisterClassA (&wc) THEN RETURN $$TRUE
	
	init = $$TRUE
	RETURN 0
	
END FUNCTION
'
' ###########################
' #####  WinXNewWindow  #####
' ###########################
'	/*
'	[WinXNewWindow]
' Description = Initialise the WinX library
' Function    = hWnd = WinXNewWindow (STRING title, x, y, w, h, simpleStyle, exStyle, icon, menu)
' ArgCount    = 9
' Arg1				= STRING title : The title for the new window
' Arg2				= x : the x position for the new window, -1 for centre
' Arg3				= y : the y position for the new window, -1 for centre
' Arg4				= w : the width of the client area of the new window
' Arg5				= h : the height of the client area of the new window
' Arg6				= simpleStyle : a simple style constant
' Arg7				= exStyle : an extended window style, look up CreateWindowEx in the win32 developer's guide for a list of extended styles
' Arg8				= icon : the handle to the icon for the window, 0 for default
' Arg9				= menu : the handle to the menu for the window, 0 for no menu
'	Return      = The handle to the new window or 0 on fail
' Remarks     = Simple style constants:<dl>\n
'<dt>$$XWSS_APP</dt><dd>A standard window</dd>\n
'<dt>$$XWSS_APPNORESIZE</dt><dd>Same as the standard window, but cannot be resized or maximised</dd>\n
'<dt>$$XWSS_POPUP</dt><dd>A popup window, cannot be minimised</dd>\n
'<dt>$$XWSS_POPUPNOTITLE</dt><dd>A popup window with no title bar</dd>\n
'<dt>$$XWSS_NOBORDER</dt><dd>A window with no border, useful for full screen apps</dd></dl>
'	See Also    =
'	Examples    = 'Make a simple window<br/>\n
'WinXNewWindow ("My window", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)
'	*/
FUNCTION WinXNewWindow (hOwner, STRING title, x, y, w, h, simpleStyle, exStyle, icon, menu)
	SHARED		hInst
	BINDING binding
	RECT	rect
	LINKEDLIST autoDraw
	
	rect.right = w
	rect.bottom = h
	
	style = XWSStoWS(simpleStyle)
	AdjustWindowRectEx (&rect, style, menu, exStyle)
	
	IF x = -1 THEN
		screenWidth  = GetSystemMetrics ($$SM_CXSCREEN)
		x = (screenWidth - (rect.right-rect.left))/2
	END IF
	
	IF y = -1 THEN
		screenHeight = GetSystemMetrics ($$SM_CYSCREEN)
		y = (screenHeight - (rect.bottom-rect.top))/2
	END IF
	
	hWnd = CreateWindowExA (exStyle, &"WinXMainClass", &title, style, x, y, _
	rect.right-rect.left, rect.bottom-rect.top, hOwner, menu, hInst, 0)
	
	'now add the icon
	IF icon THEN 
		SendMessageA (hWnd, $$WM_SETICON, $$ICON_BIG, icon)
		SendMessageA (hWnd, $$WM_SETICON, $$ICON_SMALL, icon)
	END IF
	
	'make a binding
	binding.hWnd = hWnd
	binding.hToolTips = CreateWindowExA(0, &$$TOOLTIPS_CLASS, 0, $$WS_POPUP|$$TTS_NOPREFIX|$$TTS_ALWAYSTIP, _
											$$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, hWnd, 0, hInst, 0)
	binding.msgHandlers = handler_addGroup ()
	LinkedList_Init (@autoDraw)
	binding.autoDrawInfo = LINKEDLIST_New (autoDraw)
	
	binding.autoSizerInfo = autoSizerInfo_addGroup ($$DIR_VERT)
	
	SetWindowLongA (hWnd, $$GWL_USERDATA, binding_add(binding))
	
	'and we're done
	RETURN hWnd
END FUNCTION
'
' ################################
' #####  WinXNewChildWindow  #####
' ################################
' Creates a new control
FUNCTION WinXNewChildWindow (hParent, STRING title, style, exStyle, id)
	SHARED		hInst
	BINDING binding
	LINKEDLIST autoDraw
	
	hWnd = CreateWindowExA (exStyle, &"WinXMainClass", &title, style|$$WS_VISIBLE|$$WS_CHILD, 0, 0, 0, 0, hParent, id, hInst, 0)
	
	'make a binding
	binding.hWnd = hWnd
	binding.hToolTips = CreateWindowExA(0, &$$TOOLTIPS_CLASS, 0, $$WS_POPUP|$$TTS_NOPREFIX|$$TTS_ALWAYSTIP, _
											$$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, hWnd, 0, hInst, 0)
	binding.msgHandlers = handler_addGroup ()
	LinkedList_Init (@autoDraw)
	binding.autoDrawInfo = LINKEDLIST_New (autoDraw)
	binding.autoSizerInfo = autoSizerInfo_addGroup ($$DIR_VERT)
	
	SetWindowLongA (hWnd, $$GWL_USERDATA, binding_add(binding))
	
	'and we're done
	RETURN hWnd
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
'	Return      = $$TRUE on success or $$FALSE on fail
' Remarks     = The callback function must take a single XLONG parameter called \n
'hdc, this parameter is the handle to the device context to draw on. \n
'If you register this callback, autodraw is disabled
'	See Also    =
'	Examples    = WinXRegOnPaint (#hMain, &onPaint())
'	*/
FUNCTION WinXRegOnPaint (hWnd, FUNCADDR onPaint)
	BINDING binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	'set the paint function
	binding.paint = onPaint
	binding_update (idBinding, binding)
	
	RETURN $$TRUE
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
'	Return      = 0
' Remarks     = This function should be called after all the child controls have been added to the window.  It calls the sizing function, which is either the registered callback or the auto sizer.
'	See Also    =
'	Examples    = WinXDisplay (#hMain)
'	*/
FUNCTION WinXDisplay (hWnd)
	RECT rect
	
	GetClientRect (hWnd, &rect)
	
	sizeWindow (hWnd, rect.right-rect.left, rect.bottom-rect.top)
	
	RETURN ShowWindow (hWnd, $$SW_SHOWNORMAL)
END FUNCTION
'
' ##########################
' #####  WinXDoEvents  #####
' ##########################
'	/*
'	[WinXDoEvents]
' Description = Processes events
' Function    = WinXDisplay (hWnd)
' ArgCount    = 1
'	Arg1        = hAccel : The handle to a table of keyboard accelerators (also known as keyboard shortcuts).  Use 0 if you don't want to process keyboard accelerators
'	Return      = $$FALSE on success or $$TRUE on error
' Remarks     = This function doesn't return untill the window is destroyed.
'	See Also    =
'	Examples    = WinXDoEvents (0)
'	*/
FUNCTION WinXDoEvents (hAccel)
	BINDING binding
	MSG msg

' main message loop

	DO																			' the message loop
		ret = GetMessageA (&msg, NULL, 0, 0)	' retrieve next message from queue
		SELECT CASE ret
			CASE  0 : RETURN msg.wParam					' WM_QUIT message
			CASE -1 : RETURN $$TRUE							' error
			CASE ELSE:
				'hwnd = XLONGAT(&msg)
				hWnd = GetActiveWindow ()
				binding_get (GetWindowLongA (hWnd, $$GWL_USERDATA), @binding)
				
				IFZ TranslateAcceleratorA (hWnd, hAccel, &msg) THEN 
					IF binding.useDialogInterface THEN
						IF (!IsWindow (hWnd)) || (!IsDialogMessageA (hWnd, &msg)) THEN		' send only non-dialog messages
							TranslateMessage (&msg)
							DispatchMessageA (&msg)					' send message to window callback function WndProc()
						END IF
					ELSE
						TranslateMessage (&msg)
						DispatchMessageA (&msg)					' send message to window callback function WndProc()
					END IF
				END IF
		END SELECT
	LOOP
END FUNCTION
'
' ###################################
' #####  WinXRegMessageHandler  #####
' ###################################
'	/*
'	[WinXRegMessageHandler]
' Description = Registers a message handler callback function
' Function    = WinXRegMessageHandler (hWnd, msg, FUNCADDR func)
' ArgCount    = 3
'	Arg1        = hWnd : The window to register the callback for
' Arg2				= msg : The message the callback processes
' Arg3				= func : The address of the callback function
'	Return      = $$TRUE on success or $$FALSE on error
' Remarks     = This function is designed for developers who need custom processing of a windows message, \n
'for example, to use a custom control that sends custom messages. \n
'If you register a handler for a message WinX normally handles itself then the message handler is called \n
'first, then WinX performs the default behaviour. The callback function takes 4 XLONG parameters, hWnd, msg, \n
'wParam and lParam
'	See Also    =
'	Examples    = WinXRegMessageHandler (#hMain, $$WM_NOTIFY, &handleNotify())
'	*/
FUNCTION WinXRegMessageHandler (hWnd, msg, FUNCADDR func)
	BINDING			binding
	MSGHANDLER	handler
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	'prepare the handler
	handler.msg = msg
	handler.handler = func
	
	'and add it
	IF handler_add(binding.msgHandlers,handler) = -1 THEN RETURN $$FALSE
	
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXRegControlSizer  #####
' #################################
'	/*
'	[WinXRegControlSizer]
' Description = Registers a callback function to handle the sizing of controls
' Function    = WinXRegControlSizer (hWnd, FUNCADDR func)
' ArgCount    = 2
'	Arg1        = hWnd : The window to register the callback for
' Arg2				= func : The address of the callback function
'	Return      = $$TRUE on success or $$FALSE on error
' Remarks     = This function allows you to use your own control sizing code instead of the default \n
'WinX auto sizer.  You will have to resize all controls, including status bars and toolbars, if you use \n
'this callback.  The callback function has two XLONG parameters, w and h.
'	See Also    =
'	Examples    = WinXRegControlSizer (#hMain, &customSizer())
'	*/
FUNCTION WinXRegControlSizer (hWnd, FUNCADDR func)
	BINDING			binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	'set the function
	binding.dimControls = func
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ###########################
' #####  WinXAddButton  #####
' ###########################
'	/*
'	[WinXAddButton]
' Description = Creates a new button and adds it to the specified window
' Function    = hButton = WinXAddButton (parent, STRING title, hImage, id)
' ArgCount    = 4
'	Arg1        = parent : The parent window to contain this control
' Arg2				= title : The text the button will display. If hImage is not 0, this is either "bitmap" or "icon" depending on whether hImage is a handle to a bitmap or an icon
' Arg3				= hImage : If this is an image button this parameter is the handle to the image, otherwise it must be 0
' Arg4				= id : The unique id for this button
'	Return      = $$TRUE on success or $$FALSE on error
' Remarks     = To create a button that contains a text label, hImage must be 0. \n
' To create a button with an image, load either a bitmap or an icon using the standard gdi functions. \n
' Set the hImage parameter to the handle gdi gives you and the title parameter to either "bitmap" or "icon" \n
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
FUNCTION WinXAddButton (parent, STRING title, hImage, id)
	'get the style
	IF hImage THEN
		SELECT CASE LCASE$(title)
			CASE "icon"
				style = $$BS_PUSHBUTTON|$$BS_ICON
			CASE "bitmap"
				style = $$BS_PUSHBUTTON|$$BS_BITMAP
		END SELECT
	ELSE
		style = $$BS_PUSHBUTTON
	END IF

	'make the window
	hWnd = CreateWindowExA (0, &"button", &title, style|$$WS_TABSTOP|$$WS_GROUP|$$WS_CHILD|$$WS_VISIBLE, _
	0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	
	'give it a nice font
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	
	'add the image
	IF hImage THEN
		SELECT CASE LCASE$(title)
			CASE "icon"
				SendMessageA (hWnd, $$BM_SETIMAGE, $$IMAGE_ICON, hImage)
			CASE "bitmap"
				SendMessageA (hWnd, $$BM_SETIMAGE, $$IMAGE_BITMAP, hImage)
		END SELECT
	END IF
	
	'and we're done
	RETURN hWnd
END FUNCTION
'
' ################################
' #####  WinXSetText  #####
' ################################
' Sets the text for a control
' hWnd = the handle to the control
' text = the text to set
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetText (hWnd, STRING text)
	IFZ SetWindowTextA (hWnd, &text) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXGetText$  #####
' #################################
' Gets the text from a control
' hWnd = the handle to the control
' returns a string containing the window text
FUNCTION WinXGetText$ (hWnd)
	cc = GetWindowTextLengthA (hWnd)
	buffer$ = NULL$(cc+1)
	GetWindowTextA (hWnd, &buffer$, cc+1)
	RETURN CSTRING$(&buffer$)
END FUNCTION
'
' ######################
' #####  WinXHide  #####
' ######################
' Hides a window or control
' hWnd = the handle to the control or window to hide
' returns $$TRUE o success or $$FALSE on fail
FUNCTION WinXHide (hWnd)
	ShowWindow (hWnd, $$SW_HIDE)
	RETURN $$TRUE
END FUNCTION
'
' ######################
' #####  WinXShow  #####
' ######################
' Shows a previously hidden window or control
' hWnd = the handle to the control or window to show
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXShow (hWnd)
	ShowWindow (hWnd, $$SW_SHOW)
	RETURN $$TRUE
END FUNCTION
'
' ###########################
' #####  WinXAddStatic  #####
' ###########################
' Adds a static control to a window
' parent = the parent window to add this control to
' title = the text for the static control
' hImage = the image to use, or 0 if no image
' style = the style of the static control
' id = the unique id for this control
' returns a handle to the control or 0 on error
FUNCTION WinXAddStatic (parent, STRING title, hImage, style, id)
	'make the window
	hWnd = CreateWindowExA (0, &"static", &title, style|$$WS_TABSTOP|$$WS_CHILD|$$WS_VISIBLE, _
	0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	
	'give it a nice font
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	
	'add the image
	IF hImage THEN
		SELECT CASE LCASE$(title)
			CASE "icon"
				SendMessageA (hWnd, $$STM_SETIMAGE, $$IMAGE_ICON, hImage)
			CASE "bitmap"
				SendMessageA (hWnd, $$STM_SETIMAGE, $$IMAGE_BITMAP, hImage)
		END SELECT
	END IF
	
	'and we're done
	RETURN hWnd
END FUNCTION
'
' #########################
' #####  WinXAddEdit  #####
' #########################
' Adds a new edit control to the window
' parent = the parent window
' title = the initial text to display in the control
' style = the style of the control
' id = the unique id for this control
' returns a handle to the new edit control or 0 on fail
FUNCTION WinXAddEdit (parent, STRING title, style, id)
	'make the window
	hWnd = CreateWindowExA ($$WS_EX_CLIENTEDGE, &"edit", &title, style|$$WS_TABSTOP|$$WS_GROUP|$$WS_BORDER|$$WS_CHILD|$$WS_VISIBLE, _
	0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	
	'give it a nice font
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	
	RETURN hWnd
END FUNCTION
'
' ##################################
' #####  WinXAutoSizer_SetInfo  #####
' ##################################
' Sets info for the autosizer to use when sizing your controls
' hWnd = the handle to the window to resize
' series = the series to place the control in
' space = the space from the previous control
' size = the size of this control
' x, y, w, h = the size and position of the control on the current window
' flags = a set of $$SIZER flags
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAutoSizer_SetInfo (hWnd, series, DOUBLE space, DOUBLE size, DOUBLE x, DOUBLE y, DOUBLE w, DOUBLE h, flags)
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	
	BINDING	binding
	AUTOSIZERINFO	autoSizerBlock
	SPLITTERINFO splitterInfo
	RECT parentRect
	RECT minRect
	RECT rect
	
	IF series = -1 THEN
		'get the parent window
		parent = GetParent (hWnd)
		IFF binding_get (GetWindowLongA (parent, $$GWL_USERDATA), @binding) THEN RETURN $$FALSE
		series = binding.autoSizerInfo
	END IF
	
	'associate the info
	autoSizerBlock.hWnd = hWnd
	autoSizerBlock.space = space
	autoSizerBlock.size = size
	autoSizerBlock.x = x
	autoSizerBlock.y = y
	autoSizerBlock.w = w
	autoSizerBlock.h = h
	autoSizerBlock.flags = flags
	
	'register the block
	idBlock = GetPropA (hWnd, &"autoSizerInfoBlock")
	
	IFZ idBlock THEN
		'make a new block
		idBlock = autoSizerInfo_add (series, autoSizerBlock)+1
		IFF idBlock THEN
			RETURN $$FALSE
		END IF
		IFZ SetPropA (hWnd, &"autoSizerInfoBlock", idBlock) THEN
			RETURN $$FALSE
		ELSE
			ret = $$TRUE
		END IF
		
		'make a splitter if we need one
		IF autoSizerBlock.flags AND $$SIZER_SPLITTER THEN
			splitterInfo.group = series
			splitterInfo.id = idBlock-1
			splitterInfo.direction = autoSizerInfoUM[series].direction
			
			autoSizerInfo_get (series, idBlock-1, @autoSizerBlock)
			autoSizerBlock.hSplitter = CreateWindowExA (0, &"WinXSplitterClass", 0, $$WS_CHILD|$$WS_VISIBLE|$$WS_CLIPSIBLINGS, _
			0, 0, 0, 0, GetParent(hWnd), 0, GetModuleHandleA (0), SPLITTERINFO_New (@splitterInfo))
			autoSizerInfo_update (series, idBlock-1, autoSizerBlock)
		END IF
		
	ELSE
		'update the old one
		ret = autoSizerInfo_update (series, idBlock-1, autoSizerBlock)
	END IF
	
	GetClientRect (hWnd, &rect)
	sizeWindow (hWnd, rect.right-rect.left, rect.bottom-rect.top)
	
	RETURN ret
END FUNCTION
'
' ############################
' #####  WinXSetMinSize  #####
' ############################
' Sets the minimum size for a window
' hWnd = the window handle
' w and h = the minimum width and height of the client area
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetMinSize (hWnd, w, h)
	BINDING			binding
	RECT rect
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	rect.right = w
	rect.bottom = h
	AdjustWindowRectEx (&rect, GetWindowLongA (hWnd, $$GWL_STYLE), GetMenu (hWnd), GetWindowLongA (hWnd, $$GWL_EXSTYLE))
	
	binding.minW = rect.right-rect.left
	binding.minH = rect.bottom-rect.top
	binding_update (idBinding, binding)
	
	RETURN $$TRUE
END FUNCTION
'
' ##############################
' #####  WinXRegOnCommand  #####
' ##############################
' Registers the onCommand callback function
' hWnd = the window to register
' func = the function to process commands
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnCommand (hWnd, FUNCADDR func)
	BINDING			binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onCommand = func
	binding_update (idBinding, binding)
	
	RETURN $$TRUE	
END FUNCTION

' A wrapper for the troublesome LBItemFromPt function
FUNCTION ApiLBItemFromPt (hLB, x, y, bAutoScroll)
	XLONG args[3]
	
	args[0] = hLB
	args[1] = x
	args[2] = y
	args[3] = bAutoScroll
	item = XstCall ("LBItemFromPt", "comctl32.dll", @args[])
	
	RETURN item
END FUNCTION
'
' #########################
' #####  mainWndProc  #####
' #########################
' The main window procedure
' parameters and return are as usual
FUNCTION mainWndProc (hWnd, msg, wParam, lParam)
	SHARED tvDragButton
	SHARED tvDragging
	SHARED hIml
	SHARED DLM_MESSAGE
	SHARED hClipMem
	STATIC dragItem
	STATIC lastDragItem
	STATIC lastW
	STATIC lastH
	PAINTSTRUCT	ps
	BINDING binding
	BINDING innerBinding
	MINMAXINFO mmi
	RECT rect
	SCROLLINFO si
	DRAGLISTINFO	dli
	TV_HITTESTINFO tvht
	POINT pt
	POINT mouseXY
	TRACKMOUSEEVENT tme
	
	'set to true if we handle the message
	handled = $$FALSE
	
	'the return value
	ret = $$FALSE
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN DefWindowProcA (hWnd, msg, wParam, lParam)
	
	'call any assosiated message handler
	IF handler_call (binding.msgHandlers, @ret, hWnd, msg, wParam, lParam) THEN
		handled = $$TRUE
	END IF
	
	'and handle the message
	SELECT CASE msg
		CASE $$WM_DRAWCLIPBOARD
			IF binding.hWndNextClipViewer THEN SendMessageA (binding.hWndNextClipViewer, $$WM_DRAWCLIPBOARD, wParam, lParam)
			RETURN @binding.onClipChange ()
			
		CASE $$WM_CHANGECBCHAIN
			IF wParam = binding.hWndNextClipViewer THEN
				binding.hWndNextClipViewer = lParam
			ELSE
				IF binding.hWndNextClipViewer THEN SendMessageA (binding.hWndNextClipViewer, $$WM_CHANGECBCHAIN, wParam, lParam)
			END IF
			
			RETURN 0
		CASE $$WM_DESTROYCLIPBOARD
			IF hClipMem THEN GlobalFree (hClipMem)
			
		CASE $$WM_DROPFILES
			DragQueryPoint (wParam, &pt)
			cFiles = DragQueryFileA (wParam, -1, 0, 0)
			IF cFiles THEN
				DIM files$[cFiles-1]
				FOR i = 0 TO UBOUND(files$[])
					files$[i] = NULL$(DragQueryFileA (wParam, i, 0, 0))
					DragQueryFileA (wParam, i, &files$[i], LEN(files$[i]))
				NEXT
				DragFinish (wParam)
				
				RETURN @binding.onDropFiles (hWnd, pt.x, pt.y, @files$[])
			END IF
			
			DragFinish (wParam)
			RETURN 0
		CASE $$WM_COMMAND
			RETURN @binding.onCommand(LOWORD(wParam), HIWORD(wParam), lParam)
		CASE $$WM_ERASEBKGND
			IF binding.backCol THEN
				GetClientRect (hWnd, &rect)
				FillRect (wParam, &rect, binding.backCol)
				RETURN 0
			ELSE
				RETURN DefWindowProcA (hWnd, msg, wParam, lParam)
			END IF
		CASE $$WM_PAINT
			hDC = BeginPaint (hWnd, &ps)

			'use auto draw
			WinXGetUseableRect (hWnd, @rect)
			
			' Auto scroll?
'				IF binding.hScrollPageM THEN
'					GetScrollInfo (hWnd, $$SB_HORZ, &si)
'					xOff = (si.nPos-binding.hScrollPageC)\binding.hScrollPageM
'					GetScrollInfo (hWnd, $$SB_VERT, &si)
'					yOff = (si.nPos-binding.hScrollPageC)\binding.hScrollPageM
'				END IF
			autoDraw_draw(hDC, binding.autoDrawInfo, xOff, yOff)
			
			ret = @binding.paint(hWnd, hDC)
			
			EndPaint (hWnd, &ps)
			
			RETURN ret
		CASE $$WM_SIZE
			w = LOWORD (lParam)
			h = HIWORD (lParam)
			sizeWindow (hWnd, w, h)
			handled = $$TRUE
			
		CASE $$WM_HSCROLL,$$WM_VSCROLL
			buffer$ = NULL$(LEN($$TRACKBAR_CLASS)+1)
			GetClassNameA (lParam, &buffer$, LEN(buffer$))
			buffer$ = TRIM$(CSTRING$(&buffer$))
			IF buffer$ = $$TRACKBAR_CLASS THEN RETURN @binding.onTrackerPos (GetDlgCtrlID (lParam), SendMessageA (lParam, $$TBM_GETPOS, 0, 0))
			
			sbval = LOWORD(wParam)
			IF msg = $$WM_HSCROLL THEN
				sb = $$SB_HORZ
				dir = $$DIR_HORIZ
				scrollUnit = binding.hScrollUnit
			ELSE
				sb = $$SB_VERT
				dir = $$DIR_VERT
				scrollUnit = binding.vScrollUnit
			END IF
			
			si.cbSize = SIZE(SCROLLINFO)
			si.fMask = $$SIF_ALL|$$SIF_DISABLENOSCROLL
			GetScrollInfo (hWnd, sb, &si)
			
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
			END IF
			
			SetScrollInfo (hWnd, sb, &si, $$TRUE)
			RETURN @binding.onScroll(si.nPos, hWnd, dir)
		
		' This allows for mouse activation of child windows, for some reason WM_ACTIVATE doesn't work
		' unfortunately it interferes with label editing - hence the strange hWnd != wParam condition
		'CASE $$WM_MOUSEACTIVATE
			'IF hWnd != wParam THEN
			'	SetFocus (hWnd)
			'	RETURN $$MA_NOACTIVATE
			'END IF
			'RETURN $$MA_ACTIVATE
			'WinXGetMousePos (wParam, @x, @y)
			'hChild = wParam
			'DO WHILE hChild
			'	wParam = hChild
			'	hChild = ChildWindowFromPoint (wParam, x, y)
			'LOOP
			'IF wParam = GetFocus() THEN RETURN $$MA_NOACTIVATE
		CASE $$WM_SETFOCUS
			IF binding.onFocusChange THEN RETURN @binding.onFocusChange(hWnd, $$TRUE)
		CASE $$WM_KILLFOCUS
			IF binding.onFocusChange THEN RETURN @binding.onFocusChange(hWnd, $$FALSE)
		CASE $$WM_SETCURSOR
			IF binding.hCursor && LOWORD(lParam) = $$HTCLIENT THEN
				SetCursor (binding.hCursor)
				RETURN $$TRUE
			END IF
		CASE $$WM_MOUSEMOVE
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			
			IFF binding.isMouseInWindow THEN
				tme.cbSize = SIZE(tme)
				tme.dwFlags = $$TME_LEAVE
				tme.hwndTrack = hWnd
				TrackMouseEvent (&tme)
				binding.isMouseInWindow = $$TRUE
				binding_update (idBinding, binding)
				
				@binding.onEnterLeave (hWnd, $$TRUE)
			END IF
			
			IF (tvDragButton = $$MBT_LEFT) || (tvDragButton = $$MBT_RIGHT) THEN
				GOSUB dragTreeViewItem
				IF ret = $$FALSE THEN SetCursor (LoadCursorA (0, $$IDC_NO)) ELSE SetCursor (LoadCursorA (0, $$IDC_ARROW))
				RETURN 0
			ELSE
				RETURN @binding.onMouseMove(hWnd, LOWORD(lParam), HIWORD(lParam))
			END IF
		CASE $$WM_MOUSELEAVE
				binding.isMouseInWindow = $$FALSE
				binding_update (idBinding, binding)
				
				@binding.onEnterLeave (hWnd, $$FALSE)
			RETURN 0
		CASE $$WM_LBUTTONDOWN
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			RETURN @binding.onMouseDown(hWnd, $$MBT_LEFT, LOWORD(lParam), HIWORD(lParam))
		CASE $$WM_MBUTTONDOWN
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			RETURN @binding.onMouseDown(hWnd, $$MBT_MIDDLE, LOWORD(lParam), HIWORD(lParam))
		CASE $$WM_RBUTTONDOWN
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			RETURN @binding.onMouseDown(hWnd, $$MBT_RIGHT, LOWORD(lParam), HIWORD(lParam))
		CASE $$WM_LBUTTONUP
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			IF tvDragButton = $$MBT_LEFT THEN
				GOSUB dragTreeViewItem
				@binding.onDrag(GetDlgCtrlID (tvDragging), $$DRAG_DONE, tvht.hItem, tvht.pt.x, tvht.pt.y)
				GOSUB endDragTreeViewItem
				RETURN 0
			ELSE
				RETURN @binding.onMouseUp(hWnd, $$MBT_LEFT,LOWORD(lParam), HIWORD(lParam))
			END IF
		CASE $$WM_MBUTTONUP
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			RETURN @binding.onMouseUp(hWnd, $$MBT_MIDDLE, LOWORD(lParam), HIWORD(lParam))
		CASE $$WM_RBUTTONUP
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			IF tvDragButton = $$MBT_LEFT THEN
				GOSUB dragTreeViewItem
				@binding.onDrag(GetDlgCtrlID (tvDragging), $$DRAG_DONE, tvht.hItem, tvht.pt.x, tvht.pt.y)
				GOSUB endDragTreeViewItem
				RETURN 0
			ELSE
				RETURN @binding.onMouseUp(hWnd, $$MBT_RIGHT, LOWORD(lParam), HIWORD(lParam))
			END IF
		CASE $$WM_MOUSEWHEEL
			' This message is broken.  It gets passed to active window rather than the window under the mouse
			
'			mouseXY.x = LOWORD(lParam)
'			mouseXY.y = HIWORD(lParam)
			
'			? "-";hWnd
'			hChild = WindowFromPoint (mouseXY.x, mouseXY.y)
'			? hChild
'			ScreenToClient (hChild, &mouseXY)
'			hChild = ChildWindowFromPointEx (hChild, mouseXY.x, mouseXY.y, $$CWP_ALL)
'			? hChild
			
'			idInnerBinding = GetWindowLongA (hChild, $$GWL_USERDATA)
'			IFF binding_get (idInnerBinding, @innerBinding) THEN
				RETURN @binding.onMouseWheel(hWnd, HIWORD(wParam), LOWORD(lParam), HIWORD(lParam))
'			ELSE
'				IF innerBinding.onMouseWheel THEN
'					RETURN @innerBinding.onMouseWheel(hChild, HIWORD(wParam), LOWORD(lParam), HIWORD(lParam))
'				ELSE
'					RETURN @binding.onMouseWheel(hWnd, HIWORD(wParam), LOWORD(lParam), HIWORD(lParam))
'				END IF
'			END IF
		CASE $$WM_KEYDOWN
			RETURN @binding.onKeyDown(hWnd, wParam)
		CASE $$WM_KEYUP
			RETURN @binding.onKeyUp(hWnd, wParam)
		CASE $$WM_CHAR
			RETURN @binding.onChar(hWnd, wParam)
			
		CASE DLM_MESSAGE
			IF DLM_MESSAGE != 0 THEN
				RtlMoveMemory (&dli, lParam, SIZE(DRAGLISTINFO))
				SELECT CASE dli.uNotification
					CASE $$DL_BEGINDRAG
						item = ApiLBItemFromPt (dli.hWnd, dli.ptCursor.x, dli.ptCursor.y, $$TRUE)
						WinXListBox_AddItem (dli.hWnd, -1, " ")
						RETURN @binding.onDrag(wParam, $$DRAG_START, item, dli.ptCursor.x, dli.ptCursor.y)
					CASE $$DL_CANCELDRAG
						@binding.onDrag(wParam, $$DRAG_DONE, -1, dli.ptCursor.x, dli.ptCursor.y)
						WinXListBox_RemoveItem (dli.hWnd, -1)
					CASE $$DL_DRAGGING
						item = ApiLBItemFromPt (dli.hWnd, dli.ptCursor.x, dli.ptCursor.y, $$TRUE)
						IF item > -1 THEN
							IF @binding.onDrag(wParam, $$DRAG_DRAGGING, item, dli.ptCursor.x, dli.ptCursor.y) THEN
								IF item != dragItem THEN
									SendMessageA (dli.hWnd, $$LB_GETITEMRECT, item, &rect)
									InvalidateRect (dli.hWnd, 0, $$TRUE)
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
									dragItem = item
								END IF
								RETURN $$DL_MOVECURSOR
							ELSE
								IF item != dragItem THEN
									InvalidateRect (dli.hWnd, 0, $$TRUE)
									dragItem = item
								END IF
								RETURN $$DL_STOPCURSOR
							END IF
						ELSE
							IF item != dragItem THEN
								InvalidateRect (dli.hWnd, 0, $$TRUE)
								dragItem = -1
							END IF
							RETURN $$DL_STOPCURSOR
						END IF
					CASE $$DL_DROPPED
						InvalidateRect (dli.hWnd, 0, $$TRUE)
						item = ApiLBItemFromPt (dli.hWnd, dli.ptCursor.x, dli.ptCursor.y, $$TRUE)
						IFF @binding.onDrag(wParam, $$DRAG_DRAGGING, item, dli.ptCursor.x, dli.ptCursor.y) THEN item = -1
						@binding.onDrag(wParam, $$DRAG_DONE, item, dli.ptCursor.x, dli.ptCursor.y)
						WinXListBox_RemoveItem (dli.hWnd, -1)
				END SELECT
			END IF
			handled = $$TRUE
			
		CASE $$WM_GETMINMAXINFO
			pStruc = &mmi
			XLONGAT(&&mmi) = lParam
			mmi.ptMinTrackSize.x = binding.minW
			mmi.ptMinTrackSize.y = binding.minH
			XLONGAT(&&mmi) = pStruc
			handled = $$TRUE
			
		CASE $$WM_PARENTNOTIFY
			SELECT CASE LOWORD(wParam)
				CASE $$WM_DESTROY
					'free the auto sizer block if there is one
					autoSizerInfo_delete (binding.autoSizerInfo, GetPropA (lParam, &"autoSizerInfoBlock")-1)
			END SELECT
			handled = $$TRUE
			
		CASE $$WM_NOTIFY
			RETURN onNotify (hWnd, wParam, lParam, binding)
			
		CASE $$WM_TIMER
			SELECT CASE wParam
				CASE -1
					IF lastDragItem = dragItem THEN
						ImageList_DragShowNolock ($$FALSE)
						SendMessageA (tvDragging, $$TVM_EXPAND, $$TVE_EXPAND, dragItem)
						ImageList_DragShowNolock ($$TRUE)
					END IF
					KillTimer (hWnd, -1)
			END SELECT
			RETURN 0
			
		CASE $$WM_CLOSE
			IFZ binding.onClose THEN
				DestroyWindow (hWnd)
				PostQuitMessage(0)
			ELSE
				RETURN @binding.onClose (hWnd)
			END IF
			
		CASE $$WM_DESTROY
			ChangeClipboardChain (hWnd, binding.hWndNextClipViewer)
			'clear the binding
			binding_delete (idBinding)
			handled = $$TRUE
	END SELECT

	IF handled THEN RETURN ret ELSE RETURN DefWindowProcA (hWnd, msg, wParam, lParam)
	
	SUB dragTreeViewItem
		tvht.pt.x = LOWORD(lParam)
		tvht.pt.y = HIWORD(lParam)
		ClientToScreen (hWnd, &tvht.pt)
		pt = tvht.pt
		
		GetWindowRect (tvDragging, &rect)
		tvht.pt.x = tvht.pt.x - rect.left
		tvht.pt.y = tvht.pt.y - rect.top
		
		SendMessageA (tvDragging, $$TVM_HITTEST, 0, &tvht)
		
		IF tvht.hItem != dragItem THEN
			ImageList_DragShowNolock ($$FALSE)
			SendMessageA (tvDragging, $$TVM_SELECTITEM, $$TVGN_DROPHILITE, tvht.hItem)
			ImageList_DragShowNolock ($$TRUE)
			dragItem = tvht.hItem
		END IF
		
		IF WinXTreeView_GetChildItem (tvDragging, tvht.hItem) != 0 THEN
			SetTimer (hWnd, -1, 400, 0)
			lastDragItem = dragItem
		END IF
		
		ret = @binding.onDrag(GetDlgCtrlID (tvDragging), $$DRAG_DRAGGING, tvht.hItem, tvht.pt.x, tvht.pt.y)
		ImageList_DragMove (pt.x, pt.y)		
	END SUB
	SUB endDragTreeViewItem
		tvDragButton = 0
		ImageList_EndDrag ()
		ImageList_Destroy (hIml)
		ReleaseCapture ()
		SendMessageA (tvDragging, $$TVM_SELECTITEM, $$TVGN_DROPHILITE, 0)
	END SUB
END FUNCTION
'
' ######################
' #####  onNotify  #####
' ######################
' Handles notify messages
FUNCTION onNotify (hWnd, wParam, lParam, BINDING binding)
	SHARED tvDragButton
	SHARED tvDragging
	SHARED hIml
	NMHDR nmh
	TV_DISPINFO nmtvdi
	NM_TREEVIEW nmtv
	LV_DISPINFO nmlvdi
	NMKEY nmkey
	NM_LISTVIEW nmlv
	NMSELCHANGE nmsc
	RECT rect
	
	ret = 0
	
	pNmh = &nmh
	XLONGAT(&&nmh) = lParam

	SELECT CASE nmh.code
		CASE $$NM_CLICK, $$NM_DBLCLK, $$NM_RCLICK, $$NM_RDBLCLK, $$NM_RETURN, $$NM_HOVER
			ret = @binding.onItem (nmh.idFrom, nmh.code, 0)
		CASE $$NM_KEYDOWN
			pNmkey = &nmkey
			XLONGAT(&&nmkey) = lParam
			ret = @binding.onItem (nmh.idFrom, nmh.code, nmkey.nVKey)
			XLONGAT(&&nmkey) = pNmkey
		CASE $$MCN_SELECT
			pNmsc = &nmsc
			XLONGAT(&&nmsc) = lParam
			ret = @binding.onCalendarSelect (nmh.idFrom, nmsc.stSelStart)
			XLONGAT(&&nmsc) = pNmsc
		CASE $$TVN_BEGINLABELEDIT
			pNmtvdi = &nmtvdi
			XLONGAT(&&nmtvdi) = lParam
			ret = @binding.onLabelEdit(nmtvdi.hdr.idFrom, $$EDIT_START, nmtvdi.item.hItem, "")
			IFF ret THEN ret = $$TRUE ELSE ret = $$FALSE
			XLONGAT(&&nmtvdi) = pNmtvdi
		CASE $$TVN_ENDLABELEDIT
			pNmtvdi = &nmtvdi
			XLONGAT(&&nmtvdi) = lParam
			ret = @binding.onLabelEdit(nmtvdi.hdr.idFrom, $$EDIT_DONE, nmtvdi.item.hItem, CSTRING$(nmtvdi.item.pszText))
			XLONGAT(&&nmtvdi) = pNmtvdi
		CASE $$TVN_BEGINDRAG,$$TVN_BEGINRDRAG
			pNmtv = &nmtv
			XLONGAT(&&nmtv) = lParam
			IF @binding.onDrag(nmtv.hdr.idFrom, $$DRAG_START, nmtv.itemNew.hItem, nmtv.ptDrag.x, nmtv.ptDrag.y) THEN
				tvDragging = nmtv.hdr.hwndFrom
				
				SELECT CASE nmh.code
					CASE $$TVN_BEGINDRAG	: tvDragButton = $$MBT_LEFT
					CASE $$TVN_BEGINRDRAG	: tvDragButton = $$MBT_RIGHT
				END SELECT
				
				XLONGAT(&rect) = nmtv.itemNew.hItem
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
				
				hIml = ImageList_Create (w, h, $$ILC_COLOR32|$$ILC_MASK, 1, 0)				
				ImageList_AddMasked (hIml, hBmp, 0x00FFFFFF)
				
				ImageList_BeginDrag (hIml, 0, nmtv.ptDrag.x-rect.left, nmtv.ptDrag.y-rect.top)
				ImageList_DragEnter (GetDesktopWindow (), rect.left, rect.top)
				
				SetCapture (hWnd)
			END IF
			XLONGAT(&&nmtv) = pNmtv
		CASE $$TCN_SELCHANGE
			currTab = WinXTabs_GetCurrentTab (nmh.hwndFrom)
			maxTab = SendMessageA (nmh.hwndFrom, $$TCM_GETITEMCOUNT, 0, 0)-1
			FOR i = 0 TO maxTab
				IF i != currTab THEN
					autoSizerInfo_showGroup (WinXTabs_GetAutosizerSeries (nmh.hwndFrom, i), $$FALSE)
				ELSE
					autoSizerInfo_showGroup (WinXTabs_GetAutosizerSeries (nmh.hwndFrom, i), $$TRUE)
					GetClientRect (GetParent(nmh.hwndFrom), &rect)
					sizeWindow (GetParent(nmh.hwndFrom), rect.right-rect.left, rect.bottom-rect.top)
				END IF
			NEXT
		CASE $$LVN_COLUMNCLICK
			pNmlv = &nmlv
			XLONGAT(&&nmlv) = lParam
			ret = @binding.onColumnClick (nmh.idFrom, nmlv.iSubItem)
			XLONGAT(&&nmlv) = pNmlv
		CASE $$LVN_BEGINLABELEDIT
			pNmlvdi = &nmlvdi
			XLONGAT(&&nmlvdi) = lParam
			ret = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_START, nmlvdi.item.iItem, "")
			IFF ret THEN ret = $$TRUE ELSE ret = $$FALSE
			XLONGAT(&&nmlvdi) = pNmlvdi
		CASE $$LVN_ENDLABELEDIT
			pNmlvdi = &nmlvdi
			XLONGAT(&&nmlvdi) = lParam
			ret = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_DONE, nmlvdi.item.iItem, CSTRING$(nmlvdi.item.pszText))
			XLONGAT(&&nmlvdi) = pNmlvdi
	END SELECT
	
	XLONGAT(&&nmh) = pNmh
	RETURN ret
END FUNCTION
'
' ########################
' #####  sizeWindow  #####
' ########################
' Resizes a window
' w and h = the width and height
' returns nothing of interest
FUNCTION sizeWindow (hWnd, w, h)
	STATIC maxX
	
	BINDING	binding
	SCROLLINFO si
	RECT rect
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	'now handle the bar
	IF w > maxX THEN
		SendMessageA (binding.hBar, $$WM_SIZE, wParam, lParam)
		maxX = w
	END IF
	
	'handle the status bar
	'first, resize the partitions
	DIM parts[binding.statusParts]
	FOR i = 0 TO binding.statusParts
		parts[i] = ((i+1)*w)/(binding.statusParts+1)
	NEXT
	SendMessageA (binding.hStatus, $$WM_SIZE, wParam, lParam)
	SendMessageA (binding.hStatus, $$SB_SETPARTS, binding.statusParts+1, &parts[0])
	
	'and the scroll bars
	xoff = 0
	yoff = 0
	
	style = GetWindowLongA (hWnd, $$GWL_STYLE)
	SELECT CASE ALL TRUE
		CASE style AND $$WS_HSCROLL
			si.cbSize = SIZE(SCROLLINFO)
			si.fMask = $$SIF_PAGE|$$SIF_DISABLENOSCROLL
			si.nPage = w*binding.hScrollPageM+binding.hScrollPageC
			SetScrollInfo (hWnd, $$SB_HORZ, &si, $$TRUE)
			
			si.fMask = $$SIF_POS
			GetScrollInfo (hWnd, $$SB_HORZ, &si)
			xoff = si.nPos
		CASE style AND $$WS_VSCROLL
			si.cbSize = SIZE(SCROLLINFO)
			si.fMask = $$SIF_PAGE|$$SIF_DISABLENOSCROLL
			si.nPage = h*binding.vScrollPageM+binding.vScrollPageC
			SetScrollInfo (hWnd, $$SB_VERT, &si, $$TRUE)
			
			si.fMask = $$SIF_POS
			GetScrollInfo (hWnd, $$SB_VERT, &si)
			yoff = si.nPos
	END SELECT
	
	'use the auto sizer
	WinXGetUseableRect (hWnd, @rect)
	autoSizerInfo_sizeGroup (binding.autoSizerInfo, rect.left-xoff, rect.top-yoff, rect.right-rect.left, rect.bottom-rect.top)
	@binding.onScroll(xoff, hWnd, $$DIR_HORIZ)
	@binding.onScroll(yoff, hWnd, $$DIR_VERT)
	
	'InvalidateRect (hWnd, 0, $$FALSE)
	
	RETURN @binding.dimControls(hWnd, w, h)
END FUNCTION
'
' #######################
' #####  autoSizer  #####
' #######################
' The auto sizer function, resizes child windows
FUNCTION autoSizer (AUTOSIZERINFO	autoSizerBlock, direction, x0, y0, nw, nh, currPos)
	RECT rect
	SPLITTERINFO splitterInfo
	FUNCADDR leftInfo (XLONG, XLONG)
	FUNCADDR rightInfo (XLONG, XLONG)
	'if there is an info block, here, resize the window
	
	'calculate the SIZE
	'first, the x, y, w and h of the box
	SELECT CASE direction AND 0x00000003
		CASE $$DIR_VERT
			IF autoSizerBlock.space <= 1 THEN autoSizerBlock.space = autoSizerBlock.space*nh
			
			IF autoSizerBlock.flags AND $$SIZER_SIZERELREST THEN
				IF direction AND $$DIR_REVERSE THEN rest = currPos ELSE rest = nh-currPos
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size*rest ELSE autoSizerBlock.size = rest-autoSizerBlock.size
				autoSizerBlock.size = autoSizerBlock.size-autoSizerBlock.space
			ELSE
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size*nh
			END IF
			
			IF autoSizerBlock.x <= 1 THEN autoSizerBlock.x = autoSizerBlock.x*nw
			IF autoSizerBlock.y <= 1 THEN autoSizerBlock.y = autoSizerBlock.y*autoSizerBlock.size
			IF autoSizerBlock.w <= 1 THEN autoSizerBlock.w = autoSizerBlock.w*nw
			IF autoSizerBlock.h <= 1 THEN autoSizerBlock.h = autoSizerBlock.h*autoSizerBlock.size
			
			boxX = x0
			boxY = y0+currPos+autoSizerBlock.space
			boxW = nw
			boxH = autoSizerBlock.size
			
			IF autoSizerBlock.flags AND $$SIZER_SPLITTER THEN
				boxH = boxH-8
				autoSizerBlock.h = autoSizerBlock.h - 8
				
				IF direction AND $$DIR_REVERSE THEN h = boxY-boxH-8 ELSE h = boxY+boxH
				MoveWindow (autoSizerBlock.hSplitter, boxX, h, boxW, 8, $$FALSE)
				InvalidateRect (autoSizerBlock.hSplitter, 0, $$TRUE)
				
				iSplitter = GetWindowLongA (autoSizerBlock.hSplitter, $$GWL_USERDATA)
				SPLITTERINFO_Get (iSplitter, @splitterInfo)
				IF direction AND $$DIR_REVERSE THEN splitterInfo.maxSize = currPos-autoSizerBlock.space ELSE splitterInfo.maxSize = nh-currPos-autoSizerBlock.space
				SPLITTERINFO_Update (iSplitter, splitterInfo)
			END IF
			
			IF direction AND $$DIR_REVERSE THEN boxY = boxY-boxH
		CASE $$DIR_HORIZ
			IF autoSizerBlock.space <= 1 THEN autoSizerBlock.space = autoSizerBlock.space*nw
			
			IF autoSizerBlock.flags AND $$SIZER_SIZERELREST THEN
				IF direction AND $$DIR_REVERSE THEN rest = currPos ELSE rest = nw-currPos
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size*rest ELSE autoSizerBlock.size = rest-autoSizerBlock.size
				autoSizerBlock.size = autoSizerBlock.size-autoSizerBlock.space
			ELSE
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size*nw
			END IF
			
			IF autoSizerBlock.x <= 1 THEN autoSizerBlock.x = autoSizerBlock.x*autoSizerBlock.size
			IF autoSizerBlock.y <= 1 THEN autoSizerBlock.y = autoSizerBlock.y*nh
			IF autoSizerBlock.w <= 1 THEN autoSizerBlock.w = autoSizerBlock.w*autoSizerBlock.size
			IF autoSizerBlock.h <= 1 THEN autoSizerBlock.h = autoSizerBlock.h*nh
			boxX = x0+currPos+autoSizerBlock.space
			boxY = y0
			boxW = autoSizerBlock.size
			boxH = nh
			
			IF autoSizerBlock.flags AND $$SIZER_SPLITTER THEN
				boxW = boxW-8
				autoSizerBlock.w = autoSizerBlock.w - 8
				
				IF direction AND $$DIR_REVERSE THEN h = boxX-boxW-8 ELSE h = boxX+boxW
				MoveWindow (autoSizerBlock.hSplitter, h, boxY, 8, boxH, $$FALSE)
				InvalidateRect (autoSizerBlock.hSplitter, 0, $$TRUE)
				
				iSplitter = GetWindowLongA (autoSizerBlock.hSplitter, $$GWL_USERDATA)
				SPLITTERINFO_Get (iSplitter, @splitterInfo)
				IF direction AND $$DIR_REVERSE THEN splitterInfo.maxSize = currPos-autoSizerBlock.space ELSE splitterInfo.maxSize = nw-currPos-autoSizerBlock.space
				SPLITTERINFO_Update (iSplitter, splitterInfo)
			END IF
			
			IF direction AND $$DIR_REVERSE THEN boxX = boxX-boxW
	END SELECT
	
	'adjust the width and height as necassary
	IF autoSizerBlock.flags AND $$SIZER_WCOMPLEMENT THEN autoSizerBlock.w = boxW-autoSizerBlock.w
	IF autoSizerBlock.flags AND $$SIZER_HCOMPLEMENT THEN autoSizerBlock.h = boxH-autoSizerBlock.h
	
	'adjust x and y
	IF autoSizerBlock.x < 0 THEN
		autoSizerBlock.x = (boxW-autoSizerBlock.w)\2
	ELSE
		IF autoSizerBlock.flags AND $$SIZER_XRELRIGHT THEN autoSizerBlock.x = boxW-autoSizerBlock.x
	END IF
	IF autoSizerBlock.y < 0 THEN
		autoSizerBlock.y = (boxH-autoSizerBlock.h)\2
	ELSE
		IF autoSizerBlock.flags AND $$SIZER_YRELBOTTOM THEN autoSizerBlock.y = boxH-autoSizerBlock.y
	END IF
	
	IF autoSizerBlock.flags AND $$SIZER_SERIES THEN
		autoSizerInfo_sizeGroup (autoSizerBlock.hWnd, autoSizerBlock.x+boxX, autoSizerBlock.y+boxY, autoSizerBlock.w, autoSizerBlock.h)
	ELSE
		' Actually size the control
		IF (autoSizerBlock.w<1) || (autoSizerBlock.h<1) THEN
			ShowWindow (autoSizerBlock.hWnd, $$SW_HIDE)
		ELSE
			ShowWindow (autoSizerBlock.hWnd, $$SW_SHOW)
			MoveWindow (autoSizerBlock.hWnd, autoSizerBlock.x+boxX, autoSizerBlock.y+boxY, autoSizerBlock.w, autoSizerBlock.h, $$TRUE)
		END IF
		
		leftInfo = GetPropA (autoSizerBlock.hWnd, &"WinXLeftSubSizer")
		rightInfo = GetPropA (autoSizerBlock.hWnd, &"WinXRightSubSizer")
		IF leftInfo THEN
			series = @leftInfo(autoSizerBlock.hWnd, &rect)
			autoSizerInfo_sizeGroup (series, autoSizerBlock.x+boxX+rect.left, autoSizerBlock.y+boxY+rect.top, (rect.right-rect.left), (rect.bottom-rect.top))
		END IF
		IF rightInfo THEN
			series = @rightInfo(autoSizerBlock.hWnd, &rect)
			autoSizerInfo_sizeGroup (series, autoSizerBlock.x+boxX+rect.left, _
			autoSizerBlock.y+boxY+rect.top, (rect.right-rect.left), (rect.bottom-rect.top))
		END IF
	END IF
	
	IF direction AND $$DIR_REVERSE THEN
		RETURN currPos-autoSizerBlock.space-autoSizerBlock.size
	ELSE 
		RETURN currPos+autoSizerBlock.space+autoSizerBlock.size
	END IF
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
	FOR i = 0 TO UBOUND(bindings[])
		IFZ bindings[i].hWnd THEN
			slot = i
			EXIT FOR
		END IF
	NEXT
	
	'allocate more memory if needed
	IF slot = -1 THEN
		slot = UBOUND(bindings[])+1
		REDIM bindings[((UBOUND(bindings[])+1)<<1)-1]
	END IF
	
	'set the binding
	bindings[slot] = binding
	RETURN slot+1
END FUNCTION
'
' ############################
' #####  binding_delete  #####
' ############################
' Deletes a binding from the binding table
' id = the id of the binding to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION binding_delete (id)
	SHARED		BINDING	bindings[]
	LINKEDLIST list
	
	DEC id
	
	IF id < 0 || id > UBOUND(bindings[]) THEN RETURN $$FALSE
	IFZ bindings[id].hWnd THEN RETURN $$FALSE

	'delete the auto draw info
	autoDraw_clear (bindings[id].autoDrawInfo)
	LINKEDLIST_Get (bindings[id].autoDrawInfo, @list)
	LinkedList_Uninit (@list)
	LINKEDLIST_Delete (bindings[id].autoDrawInfo)
	'delete the message handlers
	handler_deleteGroup (bindings[id].msgHandlers)
	'delete the auto sizer info
	autoSizerInfo_deleteGroup (bindings[id].autoSizerInfo)
	
	bindings[id].hWnd = 0
	RETURN $$TRUE
END FUNCTION
'
' #########################
' #####  binding_get  #####
' #########################
' Retreives a binding
' id = the id of the binding to get
' binding = the variable to store the binding
' returns $$TRUE on success or $$FALSE on fail
FUNCTION binding_get (id, BINDING binding)
	SHARED		BINDING	bindings[]
	DEC id
	
	IF id < 0 || id > UBOUND(bindings[]) THEN RETURN $$FALSE
	IFZ bindings[id].hWnd THEN RETURN $$FALSE
	
	binding = bindings[id]
	RETURN $$TRUE
END FUNCTION
'
' ############################
' #####  binding_update  #####
' ############################
' Updates a binding
' id = the id of the binding to update
' binding = the new version of the binding
' returns $$TRUE on success or $$FALSE on fail
FUNCTION binding_update (id, BINDING binding)
	SHARED		BINDING	bindings[]
	DEC id
	
	IF id < 0 || id > UBOUND(bindings[]) THEN RETURN $$FALSE
	IFZ bindings[id].hWnd THEN RETURN $$FALSE
	
	bindings[id] = binding
	RETURN $$TRUE
END FUNCTION
'
' ##############################
' #####  handler_addGroup  #####
' ##############################
' Adds a new group of handlers
' returns the id of the group
FUNCTION handler_addGroup ()
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		handlersUM[]	'a usage map so we can see which groups are in use
	
	slot = -1
	FOR i = 0 TO UBOUND(handlersUM[])
		IFZ handlersUM[i] THEN
			slot = i
			EXIT FOR
		END IF
	NEXT
	
	IF slot = -1 THEN
		slot = UBOUND(handlersUM[])+1
		REDIM handlersUM[((UBOUND(handlersUM[])+1)<<1)-1]
		REDIM handlers[UBOUND(handlersUM[]),]
	END IF
	
	handlersUM[slot] = $$TRUE

	RETURN slot
END FUNCTION
'
' #########################
' #####  handler_add  #####
' #########################
' Add a new handler to a group
' group = the group to add the handler to
' handler = the handler to add
' returns the id of the new handler or -1 on fail
FUNCTION handler_add (group, MSGHANDLER handler)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		handlersUM[]	'a usage map so we can see which groups are in use
	MSGHANDLER	group[]	'a local version of the group
	
	'bounds checking
	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN -1
	IF  handlersUM != 0 THEN RETURN -1
	
	'find a free slot
	slot = -1
	FOR i = 0 TO UBOUND(handlers[group,])
		IF handlers[group,i].msg = 0 THEN
			slot = i
			EXIT FOR
		END IF
	NEXT
	
	IF slot = -1 THEN	'allocate more memmory
		slot = UBOUND(handlers[group,])+1
		SWAP group[], handlers[group,]
		REDIM group[((UBOUND(group[])+1)<<1)-1]
		SWAP group[], handlers[group,]
	END IF
	
	'now finish it off
	handlers[group,slot] = handler
	RETURN slot
END FUNCTION
'
' #########################
' #####  handler_get  #####
' #########################
' Retreive a handler from the handler array
' group and id are the group and id of the handler to retreive
' handler = the variable to store the handler
' returns $$TRUE on success or $$FALSE on fail
FUNCTION handler_get (group, id, MSGHANDLER handler)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	
	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(handlers[group,]) THEN RETURN $$FALSE
	IFZ handlers[group,id].msg THEN RETURN $$FALSE
	
	handler = handlers[group, id]
	RETURN $$TRUE
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
	RETURN $$TRUE
END FUNCTION
'
' ##########################
' #####  handler_find  #####
' ##########################
' Locates a handler in the handler array
' group = the group to search
' msg = the message to search for
' returns the id of the message handler, -1 if it fails 
'  to find anything and -2 if there is a bounds error
FUNCTION handler_find (group, msg)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	
	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN -2
	
	i = 0
	iMax = UBOUND(handlers[group,])
	IF i > iMax THEN RETURN -1
	DO UNTIL handlers[group,i].msg = msg
		INC i
		IF i > iMax THEN RETURN -1
	LOOP
	
	RETURN i
END FUNCTION
'
' ##########################
' #####  handler_call  #####
' ##########################
' Calls the handler for a specified message
' group = the group to call from
' ret = the variable to hold the message return value
' hwnd, msg, wParam, lParam = the usual definitions for these parameters
' returns $$TRUE on success or $$FALSE on fail
FUNCTION handler_call (group, ret, hWnd, msg, wParam, lParam)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	
	'first, find the handler
	id = handler_find (group, msg)
	
	IF id < 0 THEN RETURN $$FALSE
	
	'then call it
	ret = @handlers[group, id].handler(hWnd, msg, wParam, lParam)
	
	RETURN $$TRUE
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
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  handler_deleteGroup  #####
' #################################
' Deletes a group of handlers
' group = the group to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION handler_deleteGroup (group)
	SHARED		MSGHANDLER	handlers[]	'a 2D array of handlers
	SHARED		handlersUM[]	'a usage map so we can see which groups are in use
	MSGHANDLER	group[]	'a local version of the group
	
	IF group < 0 || group > UBOUND(handlers[]) THEN RETURN $$FALSE
	IF  UBOUND(handlers[group,]) = -1 THEN RETURN -1
	
	handlersUM[group] = 0
	SWAP group[], handlers[group,]
	RETURN $$TRUE
END FUNCTION
'
' ####################################
' #####  autoSizerInfo_addGroup  #####
' ####################################
' Adds a new group of auto sizer info blocks
' returns the if of the new group or -1 on fail
FUNCTION autoSizerInfo_addGroup (direction)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	
	AUTOSIZERINFO autoSizerInfoLocal[]
	
	slot = -1
	FOR i = 0 TO UBOUND(autoSizerInfoUM[])
		IFF autoSizerInfoUM[i].inUse THEN
			slot = i
			EXIT FOR
		END IF
	NEXT
	
	IF slot = -1 THEN
		slot = UBOUND(autoSizerInfoUM[])+1
		REDIM autoSizerInfoUM[((UBOUND(autoSizerInfoUM[])+1)<<1)-1]
		REDIM autoSizerInfo[UBOUND(autoSizerInfoUM[]),]
	END IF
	
	autoSizerInfoUM[slot].inUse = $$TRUE
	autoSizerInfoUM[slot].direction = direction
	autoSizerInfoUM[slot].firstItem = -1
	autoSizerInfoUM[slot].lastItem = -1
	
	DIM autoSizerInfoLocal[0]
	SWAP autoSizerInfoLocal[], autoSizerInfo[slot,]
	
	RETURN slot
END FUNCTION
'
' #######################################
' #####  autoSizerInfo_deleteGroup  #####
' #######################################
' Deletes a group of auto sizer info blocks
' group = the group to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_deleteGroup (group)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	
	AUTOSIZERINFO autoSizerInfoLocal[]
	
	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	
	autoSizerInfoUM[group].inUse = $$FALSE
	SWAP autoSizerInfo[group,], autoSizerInfoLocal[]
	
	RETURN $$TRUE
END FUNCTION
'
' ###############################
' #####  autoSizerInfo_add  #####
' ###############################
' Adds a new autosizer info block
' autoSizerBlock = the auto sizer block to add
' returns the id of the auto sizer block or -1 on fail
FUNCTION autoSizerInfo_add (group, AUTOSIZERINFO autoSizerBlock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	
	AUTOSIZERINFO autoSizerInfoLocal[]
	
	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN -1
	IFF autoSizerInfoUM[group].inUse THEN RETURN -1
	
	slot = -1
	FOR i = 0 TO UBOUND(autoSizerInfo[group,]) 
		IFZ autoSizerInfo[group,i].hWnd THEN
			slot = i
			EXIT FOR
		END IF
	NEXT
	
	IF slot = -1 THEN
		slot = UBOUND(autoSizerInfo[group,])+1
		SWAP autoSizerInfoLocal[], autoSizerInfo[group,]
		REDIM autoSizerInfoLocal[((UBOUND(autoSizerInfoLocal[])+1)<<1)-1]
		SWAP autoSizerInfoLocal[], autoSizerInfo[group,]
	END IF
	
	autoSizerInfo[group, slot] = autoSizerBlock

	autoSizerInfo[group, slot].nextItem = -1
	
	IF autoSizerInfoUM[group].lastItem = -1 THEN
		'Make this the first item
		autoSizerInfoUM[group].firstItem = slot
		autoSizerInfoUM[group].lastItem = slot
		autoSizerInfo[group,slot].prevItem = -1
	ELSE
		'add to the end of the list
		autoSizerInfo[group,slot].prevItem = autoSizerInfoUM[group].lastItem
		autoSizerInfo[group, autoSizerInfoUM[group].lastItem].nextItem = slot
		autoSizerInfoUM[group].lastItem = slot
	END IF
	
	RETURN slot
END FUNCTION
'
' ##################################
' #####  autoSizerInfo_delete  #####
' ##################################
' Deletes an autosizer info block
' id = the if of the auto sizer to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_delete (group, id)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	
	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[group].inUse THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(autoSizerInfo[group,]) THEN RETURN $$FALSE
	IFZ autoSizerInfo[group, id].hWnd THEN RETURN $$FALSE
	
	autoSizerInfo[group, id].hWnd = 0
	
	IF id = autoSizerInfoUM[group].firstItem THEN
		autoSizerInfoUM[group].firstItem = autoSizerInfo[group, id].nextItem
		autoSizerInfo[group, autoSizerInfo[group, id].nextItem].prevItem = -1
		IF autoSizerInfoUM[group].firstItem = -1 THEN autoSizerInfoUM[group].lastItem = -1
	ELSE
		IF id = autoSizerInfoUM[group].lastItem THEN
			autoSizerInfo[group, autoSizerInfoUM[group].lastItem].nextItem = -1
			autoSizerInfoUM[group].lastItem = autoSizerInfo[group, id].prevItem
			IF autoSizerInfoUM[group].lastItem = -1 THEN autoSizerInfoUM[group].firstItem = -1
		ELSE
			autoSizerInfo[group, autoSizerInfo[group,id].nextItem].prevItem = autoSizerInfo[group,id].prevItem
			autoSizerInfo[group, autoSizerInfo[group,id].prevItem].nextItem = autoSizerInfo[group,id].nextItem
		END IF
	END IF
	
	RETURN $$TRUE
END FUNCTION
'
' ###############################
' #####  autoSizerInfo_get  #####
' ###############################
' Get an autosizer info block
' id = the id of the block to get
' autoSizerBlock = the variable to store the block
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_get (group, id, AUTOSIZERINFO autoSizerBlock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	
	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[group].inUse THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(autoSizerInfo[group,]) THEN RETURN $$FALSE
	IFZ autoSizerInfo[group,id].hWnd THEN RETURN $$FALSE
	
	autoSizerBlock = autoSizerInfo[group, id]
	RETURN $$TRUE
END FUNCTION
'
' ##################################
' #####  autoSizerInfo_update  #####
' ##################################
' Update an autosizer info block
' id = the block to update
' autoSizerBlock = the new version of the info block
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_update (group, id, AUTOSIZERINFO autoSizerBlock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]

	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[group].inUse THEN RETURN $$FALSE
	IF id < 0 || id > UBOUND(autoSizerInfo[group,]) THEN RETURN $$FALSE
	IFZ autoSizerInfo[group,id].hWnd THEN RETURN $$FALSE
	
	autoSizerInfo[group,id] = autoSizerBlock
	RETURN $$TRUE
END FUNCTION
'
' #####################################
' #####  autoSizerInfo_sizeGroup  #####
' #####################################
' Automatically resizes all the controls in a group
' group = the group to resize
' w = the new width of the parent window
' h = the new height of the parent window
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_sizeGroup (group, x0, y0, w, h)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	
	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[group].inUse THEN RETURN $$FALSE
	
	IF autoSizerInfoUM[group].direction AND $$DIR_REVERSE THEN
		SELECT CASE autoSizerInfoUM[group].direction AND 0x00000003
			CASE $$DIR_HORIZ
				currPos = w
			CASE $$DIR_VERT
				currPos = h
		END SELECT
	ELSE
		currPos = 0
	END IF
	
	#hWinPosInfo = BeginDeferWindowPos (10)
	i = autoSizerInfoUM[group].firstItem
	DO WHILE i > -1
		IF autoSizerInfo[group, i].hWnd THEN
			currPos = autoSizer (autoSizerInfo[group,i], autoSizerInfoUM[group].direction, x0, y0, w, h, currPos)
		END IF
		
		i = autoSizerInfo[group, i].nextItem
	LOOP
	EndDeferWindowPos (#hWinPosInfo)
	
	RETURN $$TRUE
END FUNCTION
'
' #####################################
' #####  autoSizerInfo_hideGroup  #####
' #####################################
' Hides or shows an autosizer group
' group = the group to hide or show
' visible = $$TRUE to make the group visible, $$FALSE to hide them
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerInfo_showGroup (group, visible)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	
	IF group < 0 || group > UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[group].inUse THEN RETURN $$FALSE
	
	IF visible THEN command = $$SW_SHOWNA ELSE command = $$SW_HIDE
	
	i = autoSizerInfoUM[group].firstItem
	DO WHILE i > -1
		IF autoSizerInfo[group, i].hWnd THEN
			ShowWindow (autoSizerInfo[group, i].hWnd, command)
		END IF
		
		i = autoSizerInfo[group, i].nextItem
	LOOP
	
	RETURN $$TRUE
END FUNCTION
'
' ############################
' #####  autoDraw_clear  #####
' ############################
' Clears out all the records in a group
' group = the group to clear
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoDraw_clear (group)
	LINKEDLIST list
	AUTODRAWRECORD record
	
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

	RETURN $$TRUE
END FUNCTION
'
' ###########################
' #####  autodraw_draw  #####
' ###########################
' Draws the auto draw records
' hdc = the dc to draw to
' group = the group of records to draw
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoDraw_draw (hdc, group, x0, y0)
	LINKEDLIST autoDraw
	AUTODRAWRECORD record
	
	hPen = 0
	hBrush = 0
	hFont = 0
	
	IFF LINKEDLIST_Get (group, @autoDraw) THEN RETURN $$FALSE
	hWalk = LinkedList_StartWalk (autoDraw)
	DO WHILE LinkedList_Walk (hWalk, @iData)
		AUTODRAWRECORD_Get (iData, @record)
		
		IF record.hPen != 0 && record.hPen != hPen THEN
			hPen = record.hPen
			SelectObject (hdc, record.hPen)
		END IF
		IF record.hBrush != 0 && record.hBrush != hBrush THEN
			hBrush = record.hBrush
			SelectObject (hdc, record.hBrush)
		END IF
		IF record.hFont != 0 && record.hFont != hFont THEN
			hFont = record.hFont
			SelectObject (hdc, record.hFont)
		END IF
		
		IF record.toDelete THEN
			AUTODRAWRECORD_Delete (iData)
			LinkedList_DeleteThis (hWalk, @autoDraw)
		ELSE
			@record.draw (hdc, record, x0, y0)
		END IF
	LOOP
	LinkedList_EndWalk (hWalk)

	RETURN $$TRUE
END FUNCTION
'
' ######################
' #####  drawLine  #####
' ######################
' Draws a line
' hdc = the dc to draw the line on
' record = the record containing info for the line
FUNCTION VOID drawLine (hdc, AUTODRAWRECORD record, x0, y0)
	MoveToEx (hdc, record.rect.x1-x0, record.rect.y1-y0, 0)
	LineTo (hdc, record.rect.x2-x0, record.rect.y2-y0)
END FUNCTION
'
' #########################
' #####  drawEllipse  #####
' #########################
' Draw an ellipse
' hdc = the dc to draw on
' record = the draw record
FUNCTION VOID drawEllipse (hdc, AUTODRAWRECORD record, x0, y0)
	Ellipse (hdc, record.rect.x1-x0, record.rect.y1-y0, record.rect.x2-x0, record.rect.y2-y0)
END FUNCTION
'
' ######################
' #####  drawRect  #####
' ######################
' draws a rectangle
' hdc = the dc to draw on
' record = the draw record
FUNCTION VOID drawRect (hdc, AUTODRAWRECORD record, x0, y0)
	Rectangle (hdc, record.rect.x1-x0, record.rect.y1-y0, record.rect.x2-x0, record.rect.y2-y0)
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
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
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
	END IF
	binding_update (idBinding, binding)
	
	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
END FUNCTION
'
' #######################
' #####  WinXClear  #####
' #######################
' Clears all the graphics in a window
' hWnd = the handle to the window to clear
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClear (hWnd)
	BINDING			binding
	RECT rect
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	GetClientRect (hWnd, &rect)
	binding.hUpdateRegion = CreateRectRgn (0, 0, rect.right+2, rect.bottom+2)
	binding_update (idBinding, binding)
	
	RETURN autoDraw_clear (binding.autoDrawInfo)
END FUNCTION
'
' ########################
' #####  WinXUpdate  #####
' ########################
' Updates the specified window
' hWnd = the handle to the window
FUNCTION VOID WinXUpdate (hWnd)
	BINDING binding
	RECT rect
	'WinXGetUseableRect (hWnd, @rect)
	'InvalidateRect (hWnd, &rect, $$TRUE)
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	'PRINT binding.hUpdateRegion
	InvalidateRgn (hWnd, binding.hUpdateRegion, $$TRUE)
	DeleteObject (binding.hUpdateRegion)
	binding.hUpdateRegion = 0
	binding_update (idBinding, binding)
	
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
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
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
	END IF
	binding_update (idBinding, binding)
	
	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
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
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
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
	END IF
	binding_update (idBinding, binding)
	
	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
END FUNCTION
'
' ##########################
' #####  WinXNewMenu  #####
' ##########################
' Generates a new menu
' menu = a string representing the menu.  Items are seperated by commas, 
'  two commas in a row indicate a seperator.  Use & to specify hotkeys and && for &.
' firstID = the id of the first item, the other ids are assigned sequentially
' isPopup = $$TRUE if this is a popup menu else $$FALSE
' returns a handle to the menu or 0 on fail
FUNCTION WinXNewMenu (STRING menu, firstID, isPopup)
	'parse the string
	XstParseStringToStringArray (menu, ",", @items$[])
	
	IF isPopup THEN hMenu = CreatePopupMenu () ELSE hMenu = CreateMenu ()
	
	'now write the menu items
	cSep = 0	'the number of seperators
	FOR i = 0 TO UBOUND(items$[])
		'write the data
		items$[i] = TRIM$(items$[i])
		IF items$[i] = "" THEN 
			flags = $$MF_SEPARATOR
			INC cSep
		ELSE
			flags = 0
		END IF
		AppendMenuA (hMenu, $$MF_STRING|$$MF_ENABLED|flags, firstID+i-cSep, &items$[i])
	NEXT
	
	RETURN hMenu
END FUNCTION
'
' ###############################
' #####  WinXMenu_Attach  #####
' ###############################
' Attach a sub menu to another menu
' subMenu = the sub menu to attach
' newParent = the new parent menu
' id = the id to attach to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXMenu_Attach (subMenu, newParent, id)
	MENUITEMINFO	mii
	
	mii.cbSize = SIZE(MENUITEMINFO)
	mii.fMask = $$MIIM_SUBMENU
	mii.hSubMenu = subMenu
	
	IFZ SetMenuItemInfoA (newParent, id, $$FALSE, &mii) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ##############################
' #####  WinXAddStatusBar  #####
' ##############################
' Adds a status bar to a window
' hWnd = the window to add the status bar to
' initialStatus = a string to initialise the status bar with.  This string contains
'  a number of strings, one for each panel, separated by commas
' id = the id of the status bar
' returns a handle to the new status bar or 0 on fail
FUNCTION WinXAddStatusBar (hWnd, STRING initialStatus, id)
	BINDING	binding
	RECT rect
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN 0
	
	'get the parent window's style
	style = GetWindowLongA (hWnd, $$GWL_STYLE)
	IF style AND $$WS_SIZEBOX THEN sbStyle = $$SBARS_SIZEGRIP ELSE sbStyle = 0

	'make the status bar
	binding.hStatus = CreateWindowExA (0, &$$STATUSCLASSNAME, 0, sbStyle|$$WS_CHILD|$$WS_VISIBLE, _
	0, 0, 0, 0, hWnd, id, GetModuleHandleA (0), 0)
	
	GetClientRect (binding.hStatus, &rect)
	
	SendMessageA (binding.hStatus, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$TRUE)
	
	'now prepare the parts
	XstParseStringToStringArray (initialStatus, ",", @s$[])
	
	DIM parts[UBOUND(s$[])]
	
	binding.statusParts = UBOUND(parts[])
	
	FOR i = 0 TO UBOUND(s$[])
		parts[i] = ((i+1)*(rect.right-rect.left))/(UBOUND(s$[])+1)
		s$[i] = s$[i]
	NEXT
	
	'set the part info
	SendMessageA (binding.hStatus, $$SB_SETPARTS, UBOUND(parts[])+1, &parts[0])
	
	'and finnaly, set the text
	FOR i = 0 TO UBOUND(s$[])
		SendMessageA (binding.hStatus, $$SB_SETTEXT, i, &s$[i])
	NEXT
	
	'and update the binding
	binding_update (idBinding, binding)
	
	RETURN hSB
END FUNCTION
'
' ################################
' #####  WinXStatus_SetText  #####
' ################################
' Sets the text in a status bar
' hWnd = the window containing the status bar
' part = the partition to set the text for, 0 based
' text = the text to set the status to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXStatus_SetText (hWnd, part, STRING text)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	IF part > binding.statusParts THEN RETURN $$FALSE
	
	SendMessageA (binding.hStatus, $$SB_SETTEXT, part, &text)
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXStatus_GetText$  #####
' #################################
' Retreives the text from a status bar
' hWnd = the window containing the status bar
' part = the part to get the text from
' returns the status text from the specified part of the status bar, or the empty string on fail
FUNCTION WinXStatus_GetText$ (hWnd, part)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN ""
	
	IF part > binding.statusParts THEN RETURN ""
	
	cBuffer = SendMessageA(binding.hStatus, $$SB_GETTEXTLENGTH, part, 0)
	ret$ = NULL$(cBuffer+1)
	SendMessageA (binding.hStatus, $$SB_GETTEXT, part, &ret$)
	RETURN CSTRING$(&ret$)
END FUNCTION
'
' ################################
' #####  WinXRegOnMouseMove  #####
' ################################
' Registers a callback for whne the mouse is moved
' hWnd = the handle to the window
' onMouseMove = the function to call when the mouse moves
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseMove (hWnd, FUNCADDR onMouseMove)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onMouseMove = onMouseMove
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ################################
' #####  WinXRegOnMouseDown  #####
' ################################
' Registers a callback for when the mouse is pressed
' hWnd = the handle to the window
' onMouseDown = the function to call when the mouse is pressed
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseDown (hWnd, FUNCADDR onMouseDown)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onMouseDown = onMouseDown
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXRegOnMouseWheel  #####
' #################################
' Registers a callback for when the mouse wheel is rotated
' hWnd = the handle to the window
' onMouseWheel = the function to call when the mouse wheel is rotated
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseWheel (hWnd, FUNCADDR onMouseWheel)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onMouseWheel = onMouseWheel
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ##############################
' #####  WinXRegOnMouseUp  #####
' ##############################
' Registers a callback for when the mouse is released
' hWnd = the handle to the window
' onMouseUp = the function to call when the mouse is released
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseUp (hWnd, FUNCADDR onMouseUp)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onMouseUp = onMouseUp
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' #############################
' #####  WinXNewToolbar  #####
' #############################
' Generates a new toolbar
' wButton = The width of a button image in pixels
' hButton = the height of a button image in pixels
' nButtons = the number of buttons images
' hBmpButtons = the handle to a bitmap containing the button images
' hBmpGray = the appearance of the buttons when disabled, 0 for default
' hBmpHot = the appearance of the buttons when the mouse is over them, 0 for default
' rgbTrans = the colour to use as transparent
' toolTips = $$TRUE to use tooltips, $$FALSE to disable them
' customisable = $$TRUE if this toolbar can be customised.
'  !!THIS FEATURE IS NOT IMPLEMENTED YET, USE $$FALSE FOR THIS PARAMETER!!
' returns the handle to the toolbar or 0 on fail
FUNCTION WinXNewToolbar (wButton, hButton, nButtons, hBmpButtons, hBmpGray, hBmpHot, rgbTrans, toolTips, customisable)
	IFZ hBmpButtons THEN RETURN 0
	
	w = wButton*nButtons
	
	'make image lists
	hilMain = ImageList_Create (wButton, hButton, $$ILC_COLOR24|$$ILC_MASK, nButtons, 0)
	hilGray = ImageList_Create (wButton, hButton, $$ILC_COLOR24|$$ILC_MASK, nButtons, 0)
	hilHot = ImageList_Create (wButton, hButton, $$ILC_COLOR24|$$ILC_MASK, nButtons, 0)
	
	'make 2 memory DCs for image manipulations
	hdc = GetDC (GetDesktopWindow ())
	hMem = CreateCompatibleDC (hdc)
	hSource = CreateCompatibleDC (hdc)
	ReleaseDC (GetDesktopWindow (), hdc)
	
	'make a mask for the normal buttons
	hblankS = SelectObject (hSource, hBmpButtons)
	hBmpMask = CreateCompatibleBitmap (hSource, w, hButton)
	hblankM = SelectObject (hMem, hBmpMask)
	BitBlt (hMem, 0, 0, w, hButton, hSource, 0, 0, $$SRCCOPY)
	GOSUB makeMask
	hBmpButtons = SelectObject (hSource, hblankS)
	hBmpMask = SelectObject (hMem, hblankM)
	
	'Add to the image list
	ImageList_Add (hilMain, hBmpButtons, hBmpMask)
	
	'now let's do the gray buttons
	IFZ hBmpGray THEN
		'generate hBmpGray
		hblankS = SelectObject (hSource, hBmpMask)
		hBmpGray = CreateCompatibleBitmap (hSource, w, hButton)
		hblankM = SelectObject (hMem, hBmpGray)
		FOR y = 0 TO (hButton-1)
			FOR x = 0 TO (w-1)
				col = GetPixel (hSource, x, y)
				IF col = 0x00000000 THEN SetPixel (hMem, x, y, 0x00808080)
			NEXT
		NEXT
	ELSE
		'generate a mask
		hblankS = SelectObject (hSource, hBmpGray)
		hblankM = SelectObject (hMem, hBmpMask)
		BitBlt (hMem, 0, 0, w, hButton, hSource, 0, 0, $$SRCCOPY)
		GOSUB makeMask
	END IF
	
	SelectObject (hSource, hblankS)
	SelectObject (hMem, hblankM)
	ImageList_Add (hilGray, hBmpGray, hBmpMask)
	
	'and finnaly, the hot buttons
	IFZ hBmpHot THEN
		'generate a brighter version of hBmpButtons
'		hBmpHot = hBmpButtons
		hblankS = SelectObject (hSource, hBmpButtons)
		'hBmpHot = CopyImage (hBmpButtons, $$IMAGE_BITMAP, w, hButton, 0)
		hBmpHot = CreateCompatibleBitmap (hSource, w, hButton)
		hblankM = SelectObject (hMem, hBmpHot)
		FOR y = 0 TO (hButton-1)
			FOR x = 0 TO (w-1)
				col = GetPixel (hSource, x, y)
				c1 = (col AND 0x000000FF)
				c2 = (col AND 0x0000FF00)>>8
				c3 = (col AND 0x00FF0000)>>16
				c1 = c1+40 'c1+((0xFF-c1)\3)
				c2 = c2+40 'c2+((0xFF-c2)\3)
				c3 = c3+40 'c3+((0xFF-c3)\3)
				SELECT CASE ALL TRUE
					CASE c1>255 : c1=255
					CASE c2>255 : c2=255
					CASE c3>255 : c3=255
				END SELECT
				SetPixel (hMem, x, y, c1|(c2<<8)|(c3<<16))
			NEXT
		NEXT
	ELSE
		'generate a mask
		hblankS = SelectObject (hSource, hBmpHot)
		hblankM = SelectObject (hMem, hBmpMask)
		BitBlt (hMem, 0, 0, w, hButton, hSource, 0, 0, $$SRCCOPY)
		GOSUB makeMask
	END IF

	SelectObject (hSource, hblankS)
	SelectObject (hMem, hblankM)

	ImageList_Add (hilHot, hBmpHot, hBmpMask)
	
	'ok, now clean up
	DeleteObject (hBmpMask)
	IF genhBmpGray THEN DeleteObject (hBmpGray)
	DeleteDC (hMem)
	DeleteDC (hSource)
	
	'and make the toolbar
	RETURN WinXNewToolbarUsingIls (hilMain, hilGray, hilHot, toolTips, customisable)
	
	SUB makeMask
		FOR y = 0 TO (hButton-1)
			FOR x = 0 TO (w-1)
				col = GetPixel (hSource, x, y)
				IF col = rgbTrans THEN
					SetPixel (hMem, x, y, 0x00FFFFFF)
					SetPixel (hSource, x, y, 0x00FFFFFF)
				ELSE
					SetPixel (hMem, x, y, 0x00000000)
				END IF
			NEXT
		NEXT
	END SUB
END FUNCTION
'
' ###################################
' #####  WinXToolbar_AddButton  #####
' ###################################
' Adds a button to a toolbar
' hToolbar = the toolbar to add the button to
' commandId = the id for the button
' iImage = the index of the image to use for the button
' tooltipText = the text to use for the tooltip
' optional = $$TRUE if this button is optional, otherwise $$FALSE
'  !!THIS FEATURE IS NOT YET IMPLEMENTED, YOU SHOULD SET THIS PARAMETER TO $$FALSE!!
' moveable = $$TRUE if the button can be move, otherwise $$FALSE
'  !!THIS FEATURE IS NOT YET IMPLEMENTED, YOU SHOULD SET THIS PARAMETER TO $$FALSE!!
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddButton (hToolbar, commandId, iImage, STRING tooltipText, optional, moveable)
	TBBUTTON bt
	
	bt.iBitmap = iImage
	bt.idCommand = commandId
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_AUTOSIZE|$$BTNS_BUTTON
	bt.iString = &tooltipText
	
	RETURN SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
END FUNCTION
'
' ##################################
' #####  WinXSetWindowToolbar  #####
' ##################################
' Sets the window's toolbar
' hWnd = the window to set
' hToolbar = the toolbar to use
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetWindowToolbar (hWnd, hToolbar)
	BINDING	binding
	
	IFZ hToolbar THEN RETURN $$FALSE
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	'set the toolbar parent
	SetParent (hToolbar, hWnd)
	'set the toolbar style
	SetWindowLongA (hToolbar, $$GWL_STYLE, GetWindowLongA (hToolbar, $$GWL_STYLE)|$$WS_CHILD|$$WS_VISIBLE|$$CCS_TOP)
	
	SendMessageA (hToolbar, $$TB_SETPARENT, hWnd, 0)
	
	'and update the binding
	binding.hBar = hToolbar
	RETURN binding_update (idBinding, binding)
END FUNCTION
'
' ############################
' #####  WinXAddTooltip  #####
' ############################
' Adds a tooltip to a control
' hControl = the handle to the control to set the tooltip for
' tooltipText = the text of the tooltip
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAddTooltip (hControl, STRING tooltipText)
	BINDING binding
	TOOLINFO ti

	parent = GetParent (hControl)

	'get the binding
	idBinding = GetWindowLongA (parent, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	'is there any info on this control?
	ti.cbSize = SIZE(TOOLINFO)
	ti.hwnd = parent
	ti.uId = hControl
	IF SendMessageA (binding.hToolTips, $$TTM_GETTOOLINFO, 0, &ti) THEN
		'update the text
		msg = $$TTM_UPDATETIPTEXT
	ELSE
		'make a new entry
		msg = $$TTM_ADDTOOL
	END IF
	
	ti.cbSize = SIZE(TOOLINFO)
	ti.uFlags = $$TTF_SUBCLASS|$$TTF_IDISHWND
	ti.hwnd = parent
	ti.uId = hControl
	ti.lpszText = &tooltipText
	SendMessageA (binding.hToolTips, msg, 0, &ti)
	
	RETURN $$TRUE
END FUNCTION
'
' ################################
' #####  WinXGetUseableRect  #####
' ################################
' Gets a rect describing the usable protion of a window's client area,
' that is, the portion not obscured with a toolbar or status bar
' hWnd = the handle to the window to get the rect for
' rect = the variable to hold the rect structure
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXGetUseableRect (hWnd, RECT rect)
	BINDING binding
	RECT rect2

	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	GetClientRect (hWnd, &rect)
	IF binding.hBar THEN
		GetClientRect (binding.hBar, &rect2)
		rect.top = rect.top + (rect2.bottom-rect2.top)+2
	END IF
	
	IF binding.hStatus THEN
		GetClientRect (binding.hStatus, &rect2)
		rect.bottom = rect.bottom - (rect2.bottom-rect2.top)
	END IF
	
	RETURN $$TRUE
END FUNCTION
'
' #####################################
' #####  WinXNewToolbarUsingIls  #####
' #####################################
' Make a new toolbar using the specified image lists
' hilMain = image list for the buttons
' hilGray = the images to be displayed when the buttons are disabled
' hilHot = the images to be displayed on mouse over
' tooltips = $$TRUE to enable tooltips
' customisable = $$TRUE to enable customisation
' returns the handle of the toolbar
FUNCTION WinXNewToolbarUsingIls (hilMain, hilGray, hilHot, toolTips, customisable)
	style = $$TBSTYLE_FLAT|$$TBSTYLE_LIST
	IF toolTips THEN style = style|$$TBSTYLE_TOOLTIPS
'	IF customisable THEN
'		style = style|$$CCS_ADJUSTABLE
'		SetPropA (hToolbar, &"customisationData", tbbd_addGroup ())
'	ELSE
'		SetPropA (hToolbar, &"customisationData", -1)
'	END IF
	hToolbar = CreateWindowExA (0, &$$TOOLBARCLASSNAME, 0, style, 0, 0, 0, 0, 0, 0, GetModuleHandleA (0), 0)

	SendMessageA (hToolbar, $$TB_SETEXTENDEDSTYLE, 0, $$TBSTYLE_EX_MIXEDBUTTONS|$$TBSTYLE_EX_DOUBLEBUFFER|$$TBSTYLE_EX_DRAWDDARROWS)
	SendMessageA (hToolbar, $$TB_SETIMAGELIST, 0, hilMain)
	SendMessageA (hToolbar, $$TB_SETHOTIMAGELIST, 0, hilHot)
	SendMessageA (hToolbar, $$TB_SETDISABLEDIMAGELIST, 0, hilGray)
	SendMessageA (hToolbar, $$TB_BUTTONSTRUCTSIZE, SIZE(TBBUTTON), 0)
	
	RETURN hToolbar
END FUNCTION
'
' ######################
' #####  WinXUndo  #####
' ######################
' Undoes a drawing operation
' id = the id of the operation
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXUndo (hWnd, id)
	AUTODRAWRECORD	record
	BINDING			binding
	LINKEDLIST	autoDraw
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
'	LINKEDLIST_Get (binding.autoDrawInfo, @autoDraw)
'	LinkedList_GetItem (autoDraw, id, @iData)
	AUTODRAWRECORD_Get (id, @record)
	record.toDelete = $$TRUE
	IFZ binding.hUpdateRegion THEN
		binding.hUpdateRegion = record.hUpdateRegion
	ELSE
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
		DeleteObject(record.hUpdateRegion)
	END IF
	IF record.draw = &drawText() THEN STRING_Delete (record.text.iString)
	AUTODRAWRECORD_Update (id, record)
'	LinkedList_DeleteItem (@autoDraw, id)
'	LINKEDLIST_Update (binding.autoDrawInfo, @autoDraw)

	binding_update (idBinding, binding)
	
	RETURN $$TRUE
END FUNCTION
'
' ##############################
' #####  WinXRegOnKeyDown  #####
' ##############################
' Registers the onKeyDown callback function
' hWnd = the handle to the window to register the callback for
' onKeyDown = the address of the onKeyDown callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnKeyDown (hWnd, FUNCADDR onKeyDown)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onKeyDown = onKeyDown
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ############################
' #####  WinXRegOnKeyUp  #####
' ############################
' Registers the onKeyUp callback function
' hWnd = the handle to the window to register the callback for
' onKeyUp = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnKeyUp (hWnd, FUNCADDR onKeyUp)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onKeyUp = onKeyUp
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ###########################
' #####  WinXRegOnChar  #####
' ###########################
' Registers the onChar callback function
' hWnd = the handle to the window to register the callback for
' onChar = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnChar (hWnd, FUNCADDR onChar)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onChar = onChar
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ###########################
' #####  WinXIsKeyDown  #####
' ###########################
' Checks to see of a key is pressed
' key = the ascii code of the key or a VK code for special keys
' returns $$TRUE if the key is pressed and $$FALSE if it is not
FUNCTION WinXIsKeyDown (key)
	' Have to check the high order bit, and since this returns a short that might not be
	' where you expected it.
	IFZ GetKeyState (key) AND 0x8000 THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ################################
' #####  WinXIsMousePressed  #####
' ################################
' Checks to see if a mouse button is pressed
' button = a MBT constant
' returns $$TRUE if the button is pressed, $$FALSE if it is not
FUNCTION WinXIsMousePressed (button)

	SELECT CASE button
		CASE $$MBT_LEFT
			'we need to take into account the possibility that the mouse buttons are swapped
			IF GetSystemMetrics($$SM_SWAPBUTTON) THEN vk = $$VK_RBUTTON ELSE vk = $$VK_LBUTTON
		CASE $$MBT_MIDDLE
			vk = $$VK_MBUTTON
		CASE $$MBT_RIGHT
			IF GetSystemMetrics($$SM_SWAPBUTTON) THEN vk = $$VK_LBUTTON ELSE vk = $$VK_RBUTTON
	END SELECT
	
	IFZ GetAsyncKeyState (vk) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ############################
' #####  WinXAddControl  #####
' ############################
' Adds a new custom control
' parent = the window to add the control to
' class = the class name for the control - this will be in the control's documentation
' title = the initial text to appear in the control - not all controls use this parameter
' id = the unique id to identify the control
' style = the style of the control.  You do not have to include $$WS_CHILD or $$WS_VISIBLE
' exStyle = teh extended style of the control.  For most controls this will be 0
' returns the handle of the control, or 0 on fail
FUNCTION WinXAddControl (parent, STRING class, STRING title, style, exStyle, id)
	RETURN CreateWindowExA (exStyle, &class, &title, style|$$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
END FUNCTION
'
' ############################
' #####  WinXAddListBox  #####
' ############################
' Makes a new listbox
' parent = the parent window
' style = $$TRUE if listbox is sorted
' multiSelect = $$TRUE if the listbox can have multiple selections
' id = the id for the listbox
' returns the handle of the listbox
FUNCTION WinXAddListBox (parent, sort, multiSelect, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_VSCROLL|$$WS_HSCROLL|$$WS_TABSTOP|$$WS_GROUP|$$LBS_HASSTRINGS|$$LBS_NOINTEGRALHEIGHT 
	IF sort THEN style = style|$$LBS_SORT
	IF multiSelect THEN style = style|$$LBS_EXTENDEDSEL
	
	hWnd = CreateWindowExA (0, &"LISTBOX", 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	RETURN hWnd
END FUNCTION
'
' #############################
' #####  WinXAddComboBox  #####
' #############################
' creates a new combobox
' parent = the parent window for the combobox
' canEdit = $$TRUE if the user can enter their own item in the edit box
' images = if this combobox displays images with items, this is the handle to an image list, else 0
' id = the id for the control
' returns the handle to the combobox, or 0 on fail
FUNCTION WinXAddComboBox (parent, listHeight, canEdit, images, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP
	IF canEdit THEN style = style|$$CBS_DROPDOWN ELSE style = style|$$CBS_DROPDOWNLIST
	'style = style|$$CBS_SIMPLE
	
	hWnd = CreateWindowExA (0, &$$WC_COMBOBOXEX, 0, style, 0, 0, 0, listHeight+22, parent, id, GetModuleHandleA (0), 0)
	IF images THEN SendMessageA (hWnd, $$CBEM_SETIMAGELIST, 0, images)
	
	RETURN hWnd
END FUNCTION
'
' #################################
' #####  WinXListBox_AddItem  #####
' #################################
' Adds an item to a list box.
' hListBox = the list box to add to
' index = the 0 based index to insert the item at, -1 for the end of the list
' Item$ = the string to add to the list
' returns the index of the string in the list or $$LB_ERR on fail
FUNCTION WinXListBox_AddItem (hListBox, index, Item$)
	IF GetWindowLongA (hListBox, $$GWL_STYLE) AND $$LBS_SORT THEN
		RETURN SendMessageA (hListBox, $$LB_ADDSTRING, 0, &Item$)
	ELSE
		RETURN SendMessageA (hListBox, $$LB_INSERTSTRING, index, &Item$)
	END IF
END FUNCTION
'
' ####################################
' #####  WinXListBox_RemoveItem  #####
' ####################################
' removes an item from a list box
' hListBox = the list box to remove from
' index = the index of the item to remove, -1 to remove the last item
' returns the number of strings remaining in the list or $$LB_ERR if index is out of range
FUNCTION WinXListBox_RemoveItem (hListBox, index)
	IF index = -1 THEN index = SendMessageA (hListBox, $$LB_GETCOUNT, 0, 0) - 1
	RETURN SendMessageA (hListBox, $$LB_DELETESTRING, index, 0)
END FUNCTION
'
' ######################################
' #####  WinXListBox_GetSelection  #####
' ######################################
' Gets the selected items in a list box
' hListBox = the list box to get the items from
' index[] = the array to place the items into
' returns the number of selected items
FUNCTION WinXListBox_GetSelection (hListBox, index[])
	IF GetWindowLongA (hListBox, $$GWL_STYLE) AND $$LBS_EXTENDEDSEL THEN
		numItems = SendMessageA (hListBox, $$LB_GETSELCOUNT, 0, 0)
		IF numItems = 0 THEN RETURN 0
		DIM index[numItems-1]
		SendMessageA (hListBox, wMsg, numItems, &index[0])
		RETURN numItems
	ELSE
		DIM index[0]
		index[0] = SendMessageA (hListBox, $$LB_GETCURSEL, 0, 0)
		IF index[0] = $$LB_ERR THEN RETURN 0 ELSE RETURN 1
	END IF
END FUNCTION
'
' ##################################
' #####  WinXListBox_GetIndex  #####
' ##################################
' Gets the index of a particular string
' hListBox = the handle to the list box containing the string
' Item$ = the string to search for
' returns the index of the item or -1 on fail
FUNCTION WinXListBox_GetIndex (hListBox, Item$)
	pos = -1
	
	DO
		pos = SendMessageA (hListBox, $$LB_FINDSTRING, pos, &Item$)
		IF pos = $$LB_ERR THEN RETURN -1
	LOOP WHILE SendMessageA (hListBox, $$LB_GETTEXTLEN, pos, 0) > LEN(Item$)
	
	RETURN pos
END FUNCTION
'
' ################################
' #####  WinXListBox_SetSel  #####
' ################################
' Sets the selection on a list box
' hListBox = the handle to the list box to set the selection for
' index[] = an array of item indexes to select
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListBox_SetSelection (hListBox, index[])
	IF GetWindowLongA (hListBox, $$GWL_STYLE) AND $$LBS_EXTENDEDSEL THEN
		'first, deselect everything
		SendMessageA (hListBox, $$LB_SETSEL, $$FALSE, -1)
		
		failed = $$FALSE
		FOR i = 0 TO UBOUND(index[])
			IF SendMessageA (hListBox, $$LB_SETSEL, $$TRUE, index[i]) = $$LB_ERR THEN failed = $$TRUE
		NEXT
		
		IF failed THEN RETURN $$FALSE
	ELSE
		IF UBOUND(index[]) = 0 THEN
			IF (SendMessageA (hListBox, $$LB_SETCURSEL, index[0], 0) = -1) && (index[0] != -1) THEN RETURN $$FALSE
		ELSE
			RETURN $$FALSE
		END IF
	END IF
	
	RETURN $$TRUE
END FUNCTION
'
' ##################################
' #####  WinXDialog_OpenFile$  #####
' ##################################
' Displays an OpenFile dialog box
' parent = the handle to the window to own this dialog
' title$ = the title for the dialog
' extensions$ = a string containing the file extensions the dialog supports
' initialName$ = the filename to initialise the dialog with
' multiSelect = $$TRUE to enable selection of multiple items, otherwise $$FALSE
' returns the opened files or "" on cancel or error
FUNCTION WinXDialog_OpenFile$ (parent, title$, extensions$, initialName$, multiSelect)
	OPENFILENAME ofn
	
	buffer$ = initialName$+NULL$(4096-LEN(initialName$))
	ofn.lStructSize = SIZE(OPENFILENAME)
	ofn.hwndOwner = parent
	ofn.lpstrFilter = &extensions$
	ofn.lpstrFile = &buffer$
	ofn.nMaxFile = SIZE(buffer$)
	ofn.lpstrTitle = &title$
	ofn.flags = $$OFN_FILEMUSTEXIST|$$OFN_EXPLORER
	
	IF multiSelect THEN ofn.flags = ofn.flags|$$OFN_ALLOWMULTISELECT
	
	IFZ GetOpenFileNameA (&ofn) THEN RETURN ""
	
	IF multiSelect THEN
		ret$ = ""
		p = ofn.lpstrFile
		DO
			DO
				ret$ = ret$+CHR$(UBYTEAT(p))
				INC p
			LOOP WHILE UBYTEAT(p)
			ret$ = ret$+";"
			INC p
		LOOP WHILE UBYTEAT(p)
		
		RETURN RCLIP$(ret$)
	ELSE
		RETURN CSTRING$(ofn.lpstrFile)
	END IF
END FUNCTION
'
' ##################################
' #####  WinXDialog_SaveFile$  #####
' ##################################
' Displays a SaveFile dialog box
' parent = the handle to the parent window
' title$ = the title of the dialog box
' extensions$ = a string listing the supported extensions
' initialName$ = the name to initialise the dialog with
' overwritePrompt = $$TRUE to warn the user when they are about to overwrite a file, $$FALSE otherwise
' returns the name of the file or "" on error or cancel
FUNCTION WinXDialog_SaveFile$ (parent, title$, extensions$, initialName$, overwritePrompt)
	OPENFILENAME ofn
	
	buffer$ = initialName$+NULL$(4096-LEN(initialName$))
	ofn.lStructSize = SIZE(OPENFILENAME)
	ofn.hwndOwner = parent
	ofn.lpstrFilter = &extensions$
	ofn.lpstrFile = &buffer$
	ofn.nMaxFile = SIZE(buffer$)
	ofn.lpstrTitle = &title$
	i = INSTR(extensions$, "\0")
	IF i > 0 THEN
		defExt$ = CSTRING$(&extensions$+i)
		defExt$ = LEFT$(defExt$, INSTR(defExt$, ";")-1)
		defExt$ = MID$(defExt$, RINSTR(defExt$, ".")+1)
		IF defExt$ != "*" THEN ofn.lpstrDefExt = &defExt$
	END IF
	IF overwritePrompt THEN ofn.flags = $$OFN_OVERWRITEPROMPT
	
	IFZ GetSaveFileNameA (&ofn) THEN RETURN ""
	
	RETURN CSTRING$(ofn.lpstrFile)
END FUNCTION
'
' ##################################
' #####  WinXListBox_GetItem$  #####
' ##################################
' Gets a list box item
' hListBox = the handle to the listbox to get the item from
' index = the index of the item to get
' returns the string of the item, or "" on fail
FUNCTION WinXListBox_GetItem$ (hListBox, index)
	buffer$ = NULL$(SendMessageA (hListBox, $$LB_GETTEXTLEN, index, 0)+2)
	
	SendMessageA (hListBox, $$LB_GETTEXT, index, &buffer$)
	
	RETURN CSTRING$(&buffer$)
END FUNCTION
'
' ##################################
' #####  WinXComboBox_AddItem  #####
' ##################################
' adds an item to a combobox
' hCombo = the handle to the combobox
' index = the index to insert the item at, use -1 to add to the end
' indent = the number of indents to place the item at
' item$ = the item text
' iImage = the index to the image, ignored if this combobox doesn't have images
' iSelImage = the index of the image displayed when this item is selected
' returns the index of the new item, or -1 on fail
FUNCTION WinXComboBox_AddItem (hCombo, index, indent, item$, iImage, iSelImage)
	COMBOBOXEXITEM cbexi
	
	cbexi.mask = $$CBEIF_IMAGE|$$CBEIF_INDENT|$$CBEIF_SELECTEDIMAGE|$$CBEIF_TEXT
	cbexi.iItem = index
	cbexi.pszText = &item$
	cbexi.cchTextMax = LEN(item$)
	cbexi.iImage = iImage
	cbexi.iSelectedImage = iSelImage
	cbexi.iIndent = indent
	
	RETURN SendMessageA (hCombo, $$CBEM_INSERTITEM, 0, &cbexi)
END FUNCTION
'
' #####################################
' #####  WinXComboBox_RemoveItem  #####
' #####################################
' removes an item from a combobox
' hCombo = the handle to the combobox
' index = the o based index of the item to delete
' returns the number of items remaining in the list, or $$CB_ERR on fail
FUNCTION WinXComboBox_RemoveItem (hCombo, index)
	RETURN SendMessageA (hCombo, $$CBEM_DELETEITEM, index, 0)
END FUNCTION
'
' #######################################
' #####  WinXComboBox_GetSelection  #####
' #######################################
' gets the current selection
' hCombo = the handle to the combobox
' returns the currently selected item or $$CB_ERR on fail
FUNCTION WinXComboBox_GetSelection (hCombo)
	RETURN SendMessageA (hCombo, $$CB_GETCURSEL, 0, 0)
END FUNCTION
'
' #######################################
' #####  WinXComboBox_SetSelection  #####
' #######################################
' Selects an item in a combobox
' hCombo = the handle to the combobox
' index = the index of the item to select.  -1 to deselect everything
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXComboBox_SetSelection (hCombo, index)
	IF (SendMessageA (hCombo, $$CB_SETCURSEL, index, 0) = $$CB_ERR) && (index != -1) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ##################################
' #####  WinXComboBox_GetItem  #####
' ##################################
' Gets the text of an item
' hCombo = the handle to the combobox
' index = the 0 based index of the item to get
' returns the text of the item, or "" on fail
FUNCTION WinXComboBox_GetItem$ (hCombo, index)
	COMBOBOXEXITEM cbexi
	
	item$ = NULL$(4095)
	cbexi.mask = $$CBEIF_TEXT
	cbexi.iItem = index
	cbexi.pszText = &item$
	cbexi.cchTextMax = SIZE(item$)
	
	IFZ SendMessageA (hCombo, $$CBEM_GETITEM, 0, &cbexi) THEN RETURN ""
	
	RETURN CSTRING$(cbexi.pszText)
END FUNCTION
'
' #####################################
' #####  WinXNewAutoSizerSeries  #####
' #####################################
' Adds a new auto sizer series
' direction = $$DIR_VERT or $$DIR_HORIZ
' returns the handle of the new autosizer series
FUNCTION WinXNewAutoSizerSeries (direction)
	RETURN autoSizerInfo_addGroup (direction)
END FUNCTION
'
' ################################
' #####  WinXAddCheckButton  #####
' ################################
' Adds a new check button control
' parent = the handle to the parent window
' title = the title of the check control
' isFirst = $$TRUE if this is the first check button in the group, otherwise $$FALSE
' pushlike = $TRUE if the button is to be displayed as a pushbutton
' id = the unique id for this control
' returns the handle to the check button or 0 on fail
FUNCTION WinXAddCheckButton (parent, STRING title, isFirst, pushlike, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$BS_AUTOCHECKBOX
	IF isFirst THEN style = style|$$WS_GROUP
	IF pushlike THEN style = style|$$BS_PUSHLIKE
	hWnd = CreateWindowExA (0, &"BUTTON", &title, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	
	RETURN hWnd
END FUNCTION
'
' ################################
' #####  WinXAddRadioButton  #####
' ################################
' Adds a new radio button control
' parent = the handle to the parent window
' title = the title of the radio button
' isFirst = $$TRUE if this is the first radio button in the group, otherwise $$FALSE
' pushlike = $TRUE if the button is to be displayed as a pushbutton
' id = the unique id constant for the radio button
' returns the handle to the radio button or 0 on fail
FUNCTION WinXAddRadioButton (parent, STRING title, isFirst, pushlike, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$BS_AUTORADIOBUTTON
	IF isFirst THEN style = style|$$WS_GROUP
	IF pushlike THEN style = style|$$BS_PUSHLIKE
	hWnd = CreateWindowExA (0, &"BUTTON", &title, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	
	RETURN hWnd
END FUNCTION
'
' #################################
' #####  WinXButton_SetCheck  #####
' #################################
' Sets the check state of a check or radio button
' hButton = the handle to the button to set the check state for
' checked = $$TRUE to check the button, $$FALSE to uncheck it
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXButton_SetCheck (hButton, checked)
	IF checked THEN
		SendMessageA (hButton, $$BM_SETCHECK, $$BST_CHECKED, 0)
	ELSE
		SendMessageA (hButton, $$BM_SETCHECK, $$BST_UNCHECKED, 0)
	END IF
	
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXButton_GetCheck  #####
' #################################
' Gets the check state of a check or radio button
' hButton = the handle to the button to get the check state for
' returns $$TRUE if the button is checked, $$FALSE otherwise
FUNCTION WinXButton_GetCheck (hButton)
	SELECT CASE SendMessageA (hButton, $$BM_GETCHECK, 0, 0)
		CASE $$BST_CHECKED
			RETURN $$TRUE
		CASE $$BST_UNCHECKED
			RETURN $$FALSE
	END SELECT
	RETURN $$FALSE
END FUNCTION
'
' #############################
' #####  WinXAddTreeView  #####
' #############################
' Adds a new tree view
' parent = the parent window
' editable = $$TRUE to allow lable editing
' draggable = $$TRUE to enable dragging
' id = the unique id constant for this control
' returns the handle to the tree view or 0 on fail
FUNCTION WinXAddTreeView (parent, hImages, editable, draggable, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP|$$TVS_HASBUTTONS|$$TVS_HASLINES|$$TVS_LINESATROOT
	IFF draggable THEN style = style|$$TVS_DISABLEDRAGDROP
	IF editable THEN style = style|$$TVS_EDITLABELS
	hWnd = CreateWindowExA (0, &$$WC_TREEVIEW, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	SendMessageA (hWnd, $$TVM_SETIMAGELIST, $$TVSIL_NORMAL, hImages)
	RETURN hWnd
END FUNCTION
'
' ################################
' #####  WinXAddProgressBar  #####
' ################################
' Adds a new progress bar control
' parent = the handle to the parent window
' smooth = $$TRUE if the progress bar is not to be segmented
' id = the unique id constant for this control
' returns the handle to the progress bar or $$FALSE on fail
FUNCTION WinXAddProgressBar (parent, smooth, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP
	IF smooth THEN style = style|$$PBS_SMOOTH
	hWnd = CreateWindowExA (0, &$$PROGRESS_CLASS, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	
	SendMessageA (hWnd, $$PBM_SETRANGE, 0, MAKELONG(0, 1000))
	
	RETURN hWnd
END FUNCTION
'
' #############################
' #####  WinXAddTrackBar  #####
' #############################
' Adds a new trackbar control
' parent = the parent window for the trackbar
' enableSelection = $$TRUE to enable selctions in the trackbar
' posToolTip = $$TRUE to enable a tooltip which displays the position of the slider
' id = the unique id constant of this trackbar
' returns the handle to the trackbar or 0 on fail
FUNCTION WinXAddTrackBar (parent, enableSelection, posToolTip, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP|$$TBS_AUTOTICKS
	IF enableSelection THEN style = style|$$TBS_ENABLESELRANGE
	IF posToolTip THEN style = style|$$TBS_TOOLTIPS
	
	hWnd = CreateWindowExA (0, &$$TRACKBAR_CLASS, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$TRUE)
	
	RETURN hWnd
END FUNCTION
'
' #########################
' #####  WinXAddTabs  #####
' #########################
' Creates a new tab control
' parent = the handle to the parent window
' multiline = $$TRUE if this is a multiline control
' id = the unique id for this control
' returns the handle to the control or 0 on fail
FUNCTION WinXAddTabs (parent, multiline, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP|$$TCS_HOTTRACK
	IF multiline THEN style = style|$$TCS_MULTILINE
	
	hWnd = CreateWindowExA (0, &$$WC_TABCONTROL, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$TRUE)
	
	SetPropA (hWnd, &"WinXLeftSubSizer", &tabs_SizeContents())
	
	RETURN hWnd
END FUNCTION
'
' ##############################
' #####  WinXAddAnimation  #####
' ##############################
' Creates a new animation control
' parent = the handle to the parent window
' file = the animation file to play
' id = the unique id for this control
' returns the handle to the control or 0 on fail
FUNCTION WinXAddAnimation (parent, STRING file, id)
	hWnd = CreateWindowExA (0, &"SysAnimate32", 0, $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP| _
	$$ACS_CENTER, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	
	SendMessageA (hWnd, $$ACM_OPENA, 0, &file)
	
	RETURN hWnd
END FUNCTION
'
' ###########################
' #####  WinXRegOnDrag  #####
' ###########################
' Register onDrag
FUNCTION WinXRegOnDrag (hWnd, FUNCADDR onDrag)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onDrag = onDrag
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ########################################
' #####  WinXListBox_EnableDragging  #####
' ########################################
' Enables dragging on a list box.  Make sure to register the onDrag callback as well
' hListBox = the handle to the list box to enable dragging on
' reuturns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListBox_EnableDragging (hListBox)
	SHARED DLM_MESSAGE
	IFZ MakeDragList (hListBox) RETURN $$FALSE
	DLM_MESSAGE = RegisterWindowMessageA (&$$DRAGLISTMSGSTRING)
	RETURN $$TRUE
END FUNCTION
'
' ###############################
' #####  WinXAutoSizer_GetMainSeries  #####
' ###############################
' Gets the id of the main autosizer series for a window
' hWnd = the window to get the series for
' returns the id of the main series of the window
FUNCTION WinXAutoSizer_GetMainSeries (hWnd)
	BINDING binding
	
	IFF binding_get (GetWindowLongA (hWnd, $$GWL_USERDATA), @binding) THEN RETURN -1
	RETURN binding.autoSizerInfo
END FUNCTION
'
' ##########################
' #####  WinXDialog_Error  #####
' ##########################
' Displays an error dialog box
' message = the message to display
' title = the title of the message box
' severity = the severity of the error.  0 = debug, 1 = warning, 2 = error, 3 = unrecoverable error
' returns $$TRUE
FUNCTION WinXDialog_Error (STRING message, STRING title, severity)
	SELECT CASE severity
		CASE 0
			icon = $$MB_ICONASTERISK
		CASE 1
			icon = $$MB_ICONWARNING
		CASE 2
			icon = $$MB_ICONSTOP
		CASE 3
			icon = $$MB_ICONSTOP
	END SELECT
	MessageBoxA (0, &message, &title, $$MB_OK|icon)
	
	IF severity = 3 THEN QUIT(0)
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXProgress_SetPos  #####
' #################################
' Sets the position of a progress bar
' hProg = the handle to the progress bar
' pos = proportion of progress bar to shade
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXProgress_SetPos (hProg, DOUBLE pos)
	SendMessageA (hProg, $$PBM_SETPOS, 1000*pos, 0)
	RETURN $$TRUE
END FUNCTION
'
' #####################################
' #####  WinXProgress_SetMarquee  #####
' #####################################
' Enables or disables marquee mode
' hProg = the progress bar
' enable = $$TRUE to enable marquee mode, $$FALSE to disable
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXProgress_SetMarquee (hProg, enable)
	IF enable THEN 
		SetWindowLongA (hProg, $$GWL_STYLE, GetWindowLongA (hProg, $$GWL_STYLE)|$$PBS_MARQUEE)
		SendMessageA (hProg, $$PBM_SETMARQUEE, $$TRUE, 50)
	ELSE
		SetWindowLongA (hProg, $$GWL_STYLE, GetWindowLongA (hProg, $$GWL_STYLE) AND NOT $$PBS_MARQUEE)
		SendMessageA (hProg, $$PBM_SETMARQUEE, $$FALSE, 50)
	END IF
	RETURN $$TRUE
END FUNCTION
'
' #############################
' #####  WinXRegOnScroll  #####
' #############################
' Registers the onScroll callback
' hWnd = the handle to the window to register the callback for
' onScroll = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnScroll (hWnd, FUNCADDR onScroll)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onScroll = onScroll
	binding_update (idBinding, binding)
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
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXScroll_Show (hWnd, horiz, vert)
	style = GetWindowLongA (hWnd, $$GWL_STYLE)
	IF horiz THEN style = style|$$WS_HSCROLL ELSE style = style AND NOT $$WS_HSCROLL
	IF vert THEN style = style|$$WS_VSCROLL ELSE style = style AND NOT $$WS_VSCROLL
	SetWindowLongA (hWnd, $$GWL_STYLE, style)
	SetWindowPos (hWnd, 0, 0, 0, 0, 0, $$SWP_NOMOVE|$$SWP_NOSIZE|$$SWP_NOZORDER|$$SWP_FRAMECHANGED)
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
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXScroll_SetRange (hWnd, direction, min, max)
	SCROLLINFO si
	RECT rect
	
	SELECT CASE direction
		CASE $$DIR_HORIZ
			sb = $$SB_HORZ	
		CASE $$DIR_VERT
			sb = $$SB_VERT	
		CASE ELSE
			RETURN $$FALSE
	END SELECT

	si.cbSize	= SIZE(SCROLLINFO)
	si.fMask	= $$SIF_RANGE|$$SIF_DISABLENOSCROLL
	si.nMin		= min
	si.nMax		= max
	
	SetScrollInfo (hWnd, sb, &si, $$TRUE)
	
	GetClientRect (hWnd, &rect)
	sizeWindow (hWnd, rect.right, rect.bottom)
	
	RETURN $$TRUE
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
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXScroll_SetPage (hWnd, direction, DOUBLE mul, constant, scrollUnit)
	BINDING	binding
	RECT rect
	SCROLLINFO si
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	GetClientRect (hWnd, &rect)
	
	si.cbSize = SIZE(SCROLLINFO)
	si.fMask = $$SIF_PAGE|$$SIF_DISABLENOSCROLL
	
	SELECT CASE direction
		CASE $$DIR_HORIZ
			binding.hScrollPageM = mul
			binding.hScrollPageC = constant
			binding.hScrollUnit = scrollUnit
			sb = $$SB_HORZ
			
			si.nPage = (rect.right-rect.left)*mul + constant
		CASE $$DIR_VERT
			binding.vScrollPageM = mul
			binding.vScrollPageC = constant
			binding.vScrollUnit = scrollUnit
			sb = $$SB_VERT
			
			si.nPage = (rect.bottom-rect.top)*mul + constant
		CASE ELSE
			RETURN $$FALSE
	END SELECT
	
	binding_update (idBinding, binding)
	SetScrollInfo (hWnd, sb, &si, $$TRUE)
	
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXRegOnTrackerPos  #####
' #################################
' Registers the onTrackerPos callback
' hWnd = the handle of the window to register the callback for
' onTrackerPos = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnTrackerPos (hWnd, FUNCADDR onTrackerPos)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onTrackerPos = onTrackerPos
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ################################
' #####  WinXTracker_GetPos  #####
' ################################
' Gets the position of the slider in a tracker bar control
' hTracker = the handle to the tracker
' returns the position of the slider
FUNCTION WinXTracker_GetPos (hTracker)
	RETURN SendMessageA (hTracker, $$TBM_GETPOS, 0, 0)
END FUNCTION
'
' ################################
' #####  WinXTracker_SetPos  #####
' ################################
' Sets the position of the slider in a trackbar control
' hTracker = the handle to the tracker
' newPos = the new position of the slider
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTracker_SetPos (hTracker, newPos)
	SendMessageA (hTracker, $$TBM_SETPOS, $$TRUE, newPos)
	RETURN $$TRUE
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
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTracker_SetRange (hTracker, USHORT min, USHORT max, ticks)
	SendMessageA (hTracker, $$TBM_SETRANGE, $$TRUE, MAKELONG(min, max))
	SendMessageA (hTracker, $$TBM_SETTICFREQ, ticks, 0)
	RETURN $$TRUE
END FUNCTION
'
' #####################################
' #####  WinXTracker_SetSelRange  #####
' #####################################
' Sets the selection range for a tracker control
' hTracker = the handle to the tracker
' start = the start of the selection
' end  = the end of the selection
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTracker_SetSelRange (hTracker, USHORT start, USHORT end)
	SendMessageA (hTracker, $$TBM_SETSEL, $$TRUE, MAKELONG(start, end))
END FUNCTION
'
' ###################################
' #####  WinXTracker_SetLabels  #####
' ###################################
' Sets the labels for the start and end of a trackbar control
' hTracker = the handle to the tracker control
' leftLabel = the label for the left of the tracker
' rightLabel = the label for the right of the tracker
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTracker_SetLabels (hTracker, STRING leftLabel, STRING rightLabel)
	SIZEAPI left
	SIZEAPI right
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
	parent = GetParent (hTracker)
	hLeft = WinXAddStatic (parent, leftLabel, 0, $$SS_CENTER, 1)
	hRight = WinXAddStatic (parent, rightLabel, 0, $$SS_CENTER, 1)
	MoveWindow (hLeft, 0, 0, left.cx+4, left.cy+4, $$TRUE)
	MoveWindow (hRight, 0, 0, right.cx+4, right.cy+4, $$TRUE)
	
	'and set them
	SendMessageA (hTracker, $$TBM_SETBUDDY, $$TRUE, hLeft)
	SendMessageA (hTracker, $$TBM_SETBUDDY, $$FALSE, hRight)

	RETURN $$TRUE
END FUNCTION
'
' ###############################
' #####  WinXScroll_Update  #####
' ###############################
' Updates the client area of a window after a scroll
' hWnd = the handle to the window to scroll
' deltaX = the distance to scroll horizontally
' deltaY = the distance to scroll vertically
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXScroll_Update (hWnd, deltaX, deltaY)
	RECT rect
	GetClientRect (hWnd, &rect)
	
	ScrollWindowEx (hWnd, deltaX, deltaY, 0, &rect, 0, 0, $$SW_ERASE|$$SW_INVALIDATE)
	RETURN $$TRUE
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
	
	i = ABS(scrollingDirection)
	IF i THEN
		SELECT CASE direction
			CASE $$DIR_HORIZ
				FOR i = 1 TO i
					SendMessageA (hWnd, $$WM_HSCROLL, wParam, 0)
				NEXT
			CASE $$DIR_VERT
				FOR i = 1 TO i
					SendMessageA (hWnd, $$WM_VSCROLL, wParam, 0)
				NEXT 
			CASE ELSE
				RETURN $$FALSE
		END SELECT
	END IF
	
	RETURN $$TRUE
END FUNCTION
'
' #######################################
' #####  WinXEnableDialogInterface  #####
' #######################################
' Enables or disables the dialog interface
' hWnd = the handle to the window to enable or disable the dialog interface for
' enable = $$TRUE to enable the dialog interface, otherwise $$FALSE
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXEnableDialogInterface (hWnd, enable)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.useDialogInterface = enable
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ##########################
' #####  WinXAni_Play  #####
' ##########################
' Starts playing an animation control
' hAni = the animation control to play
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAni_Play (hAni)
	IFZ SendMessageA (hAni, $$ACM_PLAY, -1, MAKELONG(0,-1)) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ##########################
' #####  WinXAni_Stop  #####
' ##########################
' Stops playing and animation control
' hAni = the animation control to stop playing
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAni_Stop (hAni)
	IFZ SendMessageA (hAni, $$ACM_STOP, 0, 0) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ##################################
' #####  WinXListBox_SetCaret  #####
' ##################################
' Sets the caret item for a list box
' hListBox = the handle to the list box to set the caret for
' item = the item to move the caret to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListBox_SetCaret (hListBox, item)
	IF SendMessageA (hListBox, $$LB_SETCARETINDEX, item, $$FALSE) = $$LB_ERR THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ##########################
' #####  WinXSetStyle  #####
' ##########################
' Changes the window style of a window
' hWnd = the handle to the window the change the style of
' add = the styles to add
' addEx = the extended styles to add
' sub = the styles to remove
' subEx = the extended styles to remove
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetStyle (hWnd, add, addEx, sub, subEx)
	style = GetWindowLongA (hWnd, $$GWL_STYLE)
	styleEx = GetWindowLongA (hWnd, $$GWL_EXSTYLE)
	
	style = style|add
	styleEx = styleEx|addEx
	
	style = style AND NOT(sub)
	styleEx = styleEx AND NOT(subEx)
	
	SetWindowLongA (hWnd, $$GWL_STYLE, style)
	SetWindowLongA (hWnd, $$GWL_EXSTYLE, styleEx)
	
	RETURN $$TRUE
END FUNCTION
'
' ##################################
' #####  WinXTreeView_AddItem  #####
' ##################################
' Adds an item to a tree view control
' hTreeView = the handle to the tree view control to add the item to
' hParent = The parent item, 0 or $$TVI_ROOT for root
' hInsertAfter = The item to insert after, can be $$TVI_FIRST or $$TVI_LAST
' iImage = the index of the image for this item
' iImageSel = the index of the image to use when the item is expanded
' item = the text for the item
' data = extra data to associate with this item
' returns the handle to the item or 0 on fail
FUNCTION WinXTreeView_AddItem (hTreeView, hParent, hInsertAfter, iImage, iImageSelect, STRING item)
	TV_INSERTSTRUCT tvis
	
	tvis.hParent = hParent
	tvis.hInsertAfter = hInsertAfter
	tvis.item.mask = $$TVIF_IMAGE|$$TVIF_SELECTEDIMAGE|$$TVIF_TEXT|$$TVIF_PARAM
	tvis.item.pszText = &item
	tvis.item.cchTextMax = LEN(item)
	tvis.item.iImage = iImage
	tvis.item.iSelectedImage = iImageSelect
	tvis.item.lParam = 0
	
	RETURN SendMessageA (hTreeView, $$TVM_INSERTITEM, 0, &tvis)
END FUNCTION
'
' ######################################
' #####  WinXTreeView_GetNextItem  #####
' ######################################
' Gets the next item in the tree view
' hTreeView = the handle to the tree view
' hItem = the handle to the item to start from
' returns the handle of the next item or 0 on error
FUNCTION WinXTreeView_GetNextItem (hTreeView, hItem)
	RETURN SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_NEXT, hItem)
END FUNCTION
'
' #######################################
' #####  WinXTreeView_GetChildItem  #####
' #######################################
' Gets the first child of an item in a tree view
' hTreeView = the handle to the tree view
' hItem = teh item to get the first child from
' returns the handle to the child item or 0 on error
FUNCTION WinXTreeView_GetChildItem (hTreeView, hItem)
	RETURN SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_CHILD, hItem)
END FUNCTION
'
' ########################################
' #####  WinXTreeView_GetParentItem  #####
' ########################################
' Gets the parent of an item in a tree view
' hTreeView = the handle ot the tree view
' hItem = the item to get the parent of
' returns the handle to the parent, or $$TVI_ROOT if hItem has no parent.
FUNCTION WinXTreeView_GetParentItem (hTreeView, hItem)
	RETURN SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_PARENT, hItem)
END FUNCTION
'
' ##########################################
' #####  WinXTreeView_GetPreviousItem  #####
' ##########################################
' Gets the item that comes before a tree view item
' hTreeView = the handle to the tree view
' returns the handle to the previous item or 0 on error
FUNCTION WinXTreeView_GetPreviousItem (hTreeView, hItem)
	RETURN SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_PREVIOUS, hItem)
END FUNCTION
'
' #####################################
' #####  WinXTreeView_DeleteItem  #####
' #####################################
' Delete an item, including all children
' hTreeView = the handle to the tree view
' hItem = the handle to the item to delete
' returns $$TRUE on success or $$FALSE
FUNCTION WinXTreeView_DeleteItem (hTreeView, hItem)
	RETURN SendMessageA (hTreeView, $$TVM_DELETEITEM, 0, hItem)
END FUNCTION
'
' #######################################
' #####  WinXTreeView_GetSelection  #####
' #######################################
' Gets the current selection from a tree view control
' hTreeView = the tree view control
' returns the handle of the selected item
FUNCTION WinXTreeView_GetSelection (hTreeView)
 RETURN SendMessageA (hTreeView, $$TVM_GETNEXTITEM, $$TVGN_CARET, hItem)
END FUNCTION
'
' #######################################
' #####  WinXTreeView_SetSelection  #####
' #######################################
' Sets the selection for a tree view control
' hTreeView = the handle to the tree view
' hItem = the handle to the item to set the selection to, 0 to remove selection
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTreeView_SetSelection (hTreeView, hItem)
	RETURN SendMessageA (hTreeView, $$TVM_SELECTITEM, $$TVGN_CARET, hItem)
END FUNCTION
'
' ########################################
' #####  WinXTreeView_GetItemLabel$  #####
' ########################################
' Gets the label from an item
' hTreeView = the handle to the treeview
' hItem = the item to get the label from
' returns the item label or "" on fail
FUNCTION WinXTreeView_GetItemLabel$ (hTreeView, hItem)
	TVITEM tvi
	
	buffer$ = NULL$(256)
	tvi.mask = $$TVIF_HANDLE|$$TVIF_TEXT
	tvi.hItem = hItem
	tvi.pszText = &buffer$
	tvi.cchTextMax = 255
	IFF SendMessageA (hTreeView, $$TVM_GETITEM, 0, &tvi) THEN RETURN ""

	RETURN CSTRING$(&buffer$)
END FUNCTION
'
' #######################################
' #####  WinXTreeView_SetItemLabel  #####
' #######################################
' Sets the lable for a tree view item
' hTreeView = the handle to the tree view control
' hItem = the item to set the label for
' newLabel = the new label
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTreeView_SetItemLabel (hTreeView, hItem, STRING newLabel)
	TVITEM tvi
	
	tvi.mask = $$TVIF_HANDLE|$$TVIF_TEXT
	tvi.hItem = hItem
	tvi.pszText = &newLabel
	tvi.cchTextMax = LEN(newLabel)
	
	RETURN SendMessageA (hTreeView, $$TVM_SETITEM, 0, &tvi)
END FUNCTION
'
' ################################
' #####  WinXRegOnLabelEdit  #####
' ################################
' Register the onLabelEdit callback
FUNCTION WinXRegOnLabelEdit (hWnd, FUNCADDR onLabelEdit)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onLabelEdit = onLabelEdit
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ###################################
' #####  WinXTreeView_MoveItem  #####
' ###################################
' Move an item and it's children
' hTreeView = the hnalde to the tree vire control
' hParentItem = The parent of the item to move this item to
' hItemInsertAfter = The item that will come before this item
' hItem = the item to move
' returns the new handle to the item
FUNCTION WinXTreeView_CopyItem (hTreeView, hParentItem, hItemInsertAfter, hItem)
	TV_ITEM tvi
	TV_INSERTSTRUCT tvis
	
	tvi.mask = $$TVIF_CHILDREN|$$TVIF_HANDLE|$$TVIF_IMAGE|$$TVIF_PARAM|$$TVIF_SELECTEDIMAGE|$$TVIF_STATE|$$TVIF_TEXT
	tvi.hItem = hItem
	buffer$ = NULL$(512)
	tvi.pszText = &buffer$
	tvi.cchTextMax = 512
	tvi.stateMask = 0xFFFFFFFF
	SendMessageA (hTreeView, $$TVM_GETITEM, 0, &tvi)
	tvis.hParent = hParentItem
	tvis.hInsertAfter = hItemInsertAfter
	tvis.item = tvi
	tvis.item.mask = $$TVIF_IMAGE|$$TVIF_PARAM|$$TVIF_SELECTEDIMAGE|$$TVIF_STATE|$$TVIF_TEXT 
	tvis.item.cChildren = 0
	tvis.item.hItem = SendMessageA (hTreeView, $$TVM_INSERTITEM, 0, &tvis)
	
	IF tvi.cChildren != 0 THEN
		child = WinXTreeView_GetChildItem (hTreeView, hItem)
		WinXTreeView_CopyItem (hTreeView, tvis.item.hItem, $$TVI_FIRST, child)
		prevChild = child
		child = WinXTreeView_GetNextItem (hTreeView, prevChild)
		DO WHILE child != 0
			WinXTreeView_CopyItem (hTreeView, tvis.item.hItem, prevChild, child)
			prevChild = child
			child = WinXTreeView_GetNextItem (hTreeView, prevChild)
		LOOP
	END IF
	
	RETURN tvis.item.hItem
END FUNCTION
'
' #############################
' #####  WinXTabs_AddTab  #####
' #############################
' Add a new tab to a tab control
' hTabs = the handle to the tab control
' label = the label for the new tab
' insertAfter = the index to insert at, -1 for to append 
' returns the index of the tab
FUNCTION WinXTabs_AddTab (hTabs, STRING label, index)
	TC_ITEM tci
	
	tci.mask = $$TCIF_PARAM|$$TCIF_TEXT
	tci.pszText = &label
	tci.cchTextMax = LEN(label)
	tci.lParam = autoSizerInfo_addGroup ($$DIR_VERT)
	
	IF index = -1 THEN index = SendMessageA (hTabs, $$TCM_GETITEMCOUNT, 0, 0)
	
	RETURN SendMessageA (hTabs, $$TCM_INSERTITEM, index, &tci)
END FUNCTION
'
' ################################
' #####  WinXTabs_DeleteTab  #####
' ################################
' Deletes a tab in a tab control
' hTabs = the handle the tab control
' iTab = the index of the tab to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTabs_DeleteTab (hTabs, iTab)
	RETURN SendMessageA (hTabs, $$TCM_DELETEITEM, iTab, 0)
END FUNCTION
'
' ########################################
' #####  WinXTab_GetAutosizerSeries  #####
' ########################################
' Gets the auto sizer series for a tab
' hTabs = the tab control
' iTab = the index of the tab to get the autosizer series for
' returns the id of the autosizer series or -1 on fail
FUNCTION WinXTabs_GetAutosizerSeries (hTabs, iTab)
	TC_ITEM tci
	
	tci.mask = $$TCIF_PARAM
	IFF SendMessageA (hTabs, $$TCM_GETITEM, iTab, &tci) THEN RETURN -1
	RETURN tci.lParam
END FUNCTION
'
' ####################################
' #####  WinXTabs_GetCurrentTab  #####
' ####################################
' Gets the index of the currently selected tab
' hTabs = the handle to the tab control
' returns the index of the currently selected tab
FUNCTION WinXTabs_GetCurrentTab (hTabs)
	RETURN SendMessageA (hTabs, $$TCM_GETCURSEL, 0, 0)
END FUNCTION
'
' ####################################
' #####  WinXTabs_SetCurrentTab  #####
' ####################################
' Sets the current tab
' hTabs = the tab control
' iTab = the index of the new current tab
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTabs_SetCurrentTab (hTabs, iTab)
	RETURN SendMessageA (hTabs, $$TCM_SETCURSEL, iTab, 0)
END FUNCTION
'
' ###############################
' #####  tabs_SizeContents  #####
' ###############################
FUNCTION tabs_SizeContents (hTabs, pRect)
	GetClientRect (hTabs, pRect)
	SendMessageA (hTabs, $$TCM_ADJUSTRECT, 0, pRect)
	RETURN WinXTabs_GetAutosizerSeries (hTabs, WinXTabs_GetCurrentTab (hTabs))	
END FUNCTION
'
' #########################################
' #####  WinXToolbar_AddToggleButton  #####
' #########################################
' Adds a toggle button to a toolbar
' hToolbar = the handle to the toolbar
' commandId = the command constant the button will generate
' iImage = the 0 based index of the image for this button
' tooltipText = the text for this button's tooltip
' mutex = $$TRUE if this toggle is mutually exclusive, ie. only one from a group can be toggled at a time
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddToggleButton (hToolbar, commandId, iImage, STRING tooltipText, mutex, optional, moveable)
	TBBUTTON bt
	
	bt.iBitmap = iImage
	bt.idCommand = commandId
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_AUTOSIZE
	IF mutex THEN bt.fsStyle = bt.fsStyle|$$BTNS_CHECKGROUP ELSE bt.fsStyle = bt.fsStyle|$$BTNS_CHECK
	bt.iString = &tooltipText
	
	RETURN SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
END FUNCTION
'
' ######################################
' #####  WinXToolbar_AddSeperator  #####
' ######################################
' Adds a seperator to a toolbar
' hToolbar = the toolbar to add the seperator to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddSeperator (hToolbar)
	TBBUTTON bt
	
	bt.iBitmap = 4
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_SEP
	
	RETURN SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
END FUNCTION
'
' ####################################
' #####  WinXToolbar_AddControl  #####
' ####################################
' Adds a control to a toolbar control
' hToolbar = the handle to the toolbar to add the control to
' hControl = the handle to the control
' w = the width of the control in the toolbar, the control will be resized to the height of the toolbar and this width
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddControl (hToolbar, hControl, w)
	TBBUTTON bt
	RECT rect2
	
	bt.iBitmap = w+4
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_SEP
	
	iControl = SendMessageA (hToolbar, $$TB_BUTTONCOUNT, 0, 0)
	SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	SendMessageA (hToolbar, $$TB_GETITEMRECT, iControl, &rect2)
	
	MoveWindow (hControl, rect2.left+2, rect2.top, w, rect2.bottom-rect2.top, $$TRUE)

	SetParent (hControl, hToolbar)
	
	RETURN $$TRUE
END FUNCTION
'
' ######################################
' #####  WinXToolbar_EnableButton  #####
' ######################################
' Enables or disables a toolbar button
' hToolbar = the handle to the toolbar on which the button resides
' idButton = the command id of the button
' enable = $$TRUE to enable the button, $$FALSE to disable
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_EnableButton (hToolbar, idButton, enable)
	RETURN SendMessageA (hToolbar, $$TB_ENABLEBUTTON, idButton, enable)
END FUNCTION
'
' ######################################
' #####  WinXToolbar_ToggleButton  #####
' ######################################
' Toggles a toolbar button
' hToolbar = the handle to the toolbar on which the button resides
' idButton = the command id of the button
' on = $$TRUE to toggle the button on, $$FALSE to toggle the button off
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_ToggleButton (hToolbar, idButton, on)
	state = SendMessageA (hToolbar, $$TB_GETSTATE, idButton, 0)
	IF on THEN state = state|$$TBSTATE_CHECKED ELSE state = state AND NOT ($$TBSTATE_CHECKED)
	SendMessageA (hToolbar, $$TB_SETSTATE, idButton, state)
END FUNCTION
'
' #############################
' #####  WinXDrawEllipse  #####
' #############################
' Draws an ellipse
FUNCTION WinXDrawEllipse (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
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
	END IF
	binding_update (idBinding, binding)
	
	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
END FUNCTION
'
' ##########################
' #####  WinXDrawRect  #####
' ##########################
' Draws a rectangle
FUNCTION WinXDrawRect (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD	record
	BINDING			binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
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
	END IF
	binding_update (idBinding, binding)
	
	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
END FUNCTION
'
' ############################
' #####  WinXDrawBezier  #####
' ############################
' Draws a bezier spline
FUNCTION WinXDrawBezier (hWnd, hPen, x1, y1, x2, y2, xC1, yC1, xC2, yC2)
	AUTODRAWRECORD	record
	BINDING			binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
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
	END IF
	binding_update (idBinding, binding)
	
	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
END FUNCTION
'
' #########################
' #####  WinXDrawArc  #####
' #########################
' Draws an arc
FUNCTION WinXDrawArc (hWnd, hPen, x1, y1, x2, y2, DOUBLE theta1, DOUBLE theta2)
	AUTODRAWRECORD	record
	BINDING			binding
	
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
			END IF
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
			END IF
	END SELECT
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
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
	END IF
	binding_update (idBinding, binding)
	
	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
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
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
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
	END IF
	binding_update (idBinding, binding)
	
	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
END FUNCTION
'
' ################################
' #####  WinXFont_GetDialog  #####
' ################################
' Displays the get font dialog box
' hWndOwner = the owner of the dialog
' LogFont = the LOGFONT to store initialise the dialog and store the output
' colour = the colour of the returned font
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_GetFontDialog (hWndOwner, LOGFONT logFont, colour)
	CHOOSEFONT chf
	
	chf.lStructSize = SIZE(CHOOSEFONT)
	chf.hwndOwner = hWndOwner
	chf.lpLogFont = &logFont
	chf.flags = $$CF_EFFECTS|$$CF_SCREENFONTS|$$CF_INITTOLOGFONTSTRUCT
	chf.rgbColors = colour
	
	ret = ChooseFontA (&chf)
	
	logFont.height = ABS(logFont.height)
	colour = chf.rgbColors
	RETURN ret
END FUNCTION
'
' ##################################
' #####  WinXDraw_MakeLogFont  #####
' ##################################
' Creates a logical font structure which you can use to create a real font
' STRING font = the name of the font to use
' height = the height of the font in pixels
' style = a set of flags describing the style of the font
' returns the logical font
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
' ###############################
' #####  WinXFont_GetWidth  #####
' ###############################
' Gets the width of a string using a specified font
' hFont = the font to use
' text = the string to get the length for
' maxWidth = the maximum width available for the text, set to -1 if there is no maximum width
' returns the width of the text in pixels, or the number of characters in the string that can be displayed
' at a max width of maxWidth if the width of the text exceeds maxWidth.  If maxWidth is exceeded the return is < 0
FUNCTION WinXDraw_GetTextWidth (hFont, STRING text, maxWidth)
	SIZEAPI size
	
	hDC = CreateCompatibleDC (0)
	SelectObject (hDC, hFont)
	GetTextExtentExPointA (hDC, &text, LEN(text), maxWidth, &fit, 0, &size)
	DeleteDC (hDC)
	
	IF (maxWidth = -1) || (fit >= LEN(text)) THEN RETURN size.cx ELSE RETURN -fit
END FUNCTION
'
' ##########################
' #####  WinXDrawText  #####
' ##########################
' Draws some text on a window
' hWnd = the handle to the window
' hFont = the handle to the font
' text = the text to print
' x, y = the coordintates to print the text at
' backCol, forCol = the colours for the text
' returns the handle to the element or -1 on fail
FUNCTION WinXDrawText (hWnd, hFont, STRING text, x, y, backCol, forCol)
	AUTODRAWRECORD	record
	BINDING			binding
	TEXTMETRIC tm
	SIZEAPI size
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	hDC = CreateCompatibleDC (0)
	SelectObject (hDC, hFont)
	GetTextExtentPoint32A (hDC, &text, LEN(text), &size)
	DeleteDC (hDC)
	
	record.hUpdateRegion = CreateRectRgn (x-1, y-1, x+size.cx+1, y+size.cy+1)
	record.hFont = hFont
	record.text.x = x
	record.text.y = y
	record.text.iString = STRING_New(text)
	record.text.forColour = forCol
	record.text.backColour = backCol
	
	record.draw = &drawText()
	
	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	END IF
	binding_update (idBinding, binding)
	
	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
END FUNCTION
'
' ###############################
' #####  WinXDrawGetColour  #####
' ###############################
' Displays a dialog box allowing the user to select a colour
' initialColour = the colour to initialise the dialog box with
' returns the colour the user selected
FUNCTION WinXDraw_GetColour (hWndOwner, initialColour)
	SHARED customColours[]
	CHOOSECOLOR cc
	
	IF UBOUND(customColours[]) = -1 THEN
		'init the custom colours
		DIM customColours[15]
		FOR i = 0 TO 15
			customColours[i] = 0x00FFFFFF
		NEXT
	END IF
	
	cc.lStructSize = SIZE(CHOOSECOLOR)
	cc.hwndOwner = hWndOwner
	cc.rgbResult = initialColour
	cc.lpCustColors = &customColours[]
	cc.flags = $$CC_RGBINIT
	ChooseColorA (&cc)
	RETURN cc.rgbResult
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
	
	bmih.biSize = SIZE(BITMAPINFOHEADER)
	bmih.biWidth  = w
	bmih.biHeight = h
	bmih.biPlanes = 1
	bmih.biBitCount = 32
	bmih.biCompression = $$BI_RGB
	
	RETURN CreateDIBSection (0, &bmih, $$DIB_RGB_COLORS, &bits, 0, 0)
END FUNCTION
'
' ################################
' #####  WinXDraw_LoadImage  #####
' ################################
' Loads an image from disk
' fileName = the name of the file
' fileType = the type of file
' returns a handle to the image or 0 on fail
FUNCTION WinXDraw_LoadImage (STRING fileName, fileType)
	BITMAPINFOHEADER bmih
	BITMAPFILEHEADER bmfh
	BITMAP bmp
	
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
			DeleteDC (hDst)
			DeleteDC (hSrc)
			DeleteObject (hBmpTmp)
			'and return
			RETURN hBmpRet
	END SELECT
	
	RETURN 0
END FUNCTION
'
' ##################################
' #####  WinXDraw_DeleteImage  #####
' ##################################
' Deletes an image
' hImage = the image to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_DeleteImage (hImage)
	IFZ DeleteObject (hImage) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ###############################
' #####  WinXDraw_Snapshot  #####
' ###############################
' Takes a snapshot of a WinX window and stores the result in an image
' hWnd = the window to photograph
' x, y = the x and y coordinates of the upper left hand corner of the picture
' hImage = the image to store the result
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_Snapshot (hWnd, x, y, hImage)
	BINDING			binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	hDC = CreateCompatibleDC (0)
	hOld = SelectObject (hDC, hImage)
	autoDraw_draw (hDC, binding.autoDrawInfo, x, y)
	SelectObject (hDC, hOld)
	DeleteDC (hDC)
	
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXDraw_SaveBitmap  #####
' #################################
' Saves an image to a file on disk
' hImage = the image to save
' fileName = the name for the file
' fileType =  the format in which to save the file
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_SaveImage (hImage, STRING fileName, fileType)
	BITMAPINFOHEADER bmih
	BITMAPFILEHEADER bmfh
	BITMAP bmp
	
	SELECT CASE fileType
		CASE $$FILETYPE_WINBMP
			IFZ GetObjectA (hImage, SIZE(bmp), &bmp) THEN RETURN $$FALSE
			file = OPEN (fileName, $$WRNEW)
			IF file = -1 THEN RETURN 0
			
			bmfh.bfType = 0x4D42
			bmfh.bfSize = SIZE(BITMAPFILEHEADER)+SIZE(BITMAPINFOHEADER)+(bmp.widthBytes*bmp.height)
			bmfh.bfOffBits = SIZE(BITMAPFILEHEADER)+SIZE(BITMAPINFOHEADER)
			
			bmih.biSize = SIZE(BITMAPINFOHEADER)
			bmih.biWidth = bmp.width
			bmih.biHeight = bmp.height
			bmih.biPlanes = bmp.planes
			bmih.biBitCount = bmp.bitsPixel
			bmih.biCompression = $$BI_RGB
			
			WRITE[file], bmfh
			WRITE[file], bmih
			XstBinWrite (file, bmp.bits, bmp.widthBytes*bmp.height)
			CLOSE(file)
			
			RETURN $$TRUE
	END SELECT
	
	RETURN $$FALSE
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
	
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmpSrc) THEN RETURN 0
	hBmpRet = WinXDraw_CreateImage (w, h)
	IFZ hBmpRet THEN RETURN 0
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
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
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
	END IF
	binding_update (idBinding, binding)
	
	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
END FUNCTION
'
' #############################
' #####  WinXPrint_Start  #####
' #############################
' Optionally displays a print settings dialog box then starts printing.
' minPage = the minimum page the user can select
' maxPage = the maximum page the user can select
' rangeMin = the initial minimum page, 0 for selection.  The user may change this value
' rangeMax = the initial maximum page, -1 for all pages.  The user may change this value
' cxPhys = the number of device pixels accross - the margins
' cyPhys = the number of device units vertically - the margins
' showDialog = $$TRUE to display a dialog or $$FALSE to use defaults
' hWndOwner = the handle to the window that owns the print settins dialog box or 0 for none
' returns the handle to the printer or 0 on fail
FUNCTION WinXPrint_Start (minPage, maxPage, @rangeMin, @rangeMax, @cxPhys, @cyPhys, fileName$, showDialog, hWndOwner)
	SHARED	PRINTINFO	printInfo
	PRINTDLG printDlg
	DOCINFO docInfo
	
	' First, get a DC
	IF showDialog THEN
		printDlg.lStructSize = SIZE(PRINTDLG)
		printDlg.hwndOwner = hWndOwner
		printDlg.hDevMode = printInfo.hDevMode
		printDlg.hDevNames = printInfo.hDevNames
		printDlg.flags = printInfo.printSetupFlags|$$PD_RETURNDC|$$PD_USEDEVMODECOPIESANDCOLLATE
		IF rangeMin = 0 THEN
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
			END IF
		END IF
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
				END IF
			END IF
			hDC = printDlg.hdc
		ELSE
			RETURN 0
		END IF
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
		END IF
		' We need a pointer the the DEVMODE structure
		pDevMode = GlobalLock (printInfo.hDevMode)
		IF pDevMode THEN 
			' Get the device name safely
			devName$ = NULL$(32)
			FOR i = 0 TO 28 STEP 4
				ULONGAT(&devName$, i) = ULONGAT(pDevMode, i)
			NEXT
			hDC = CreateDCA (0, &devName$, 0, pDevMode)
		END IF
		GlobalUnlock (printInfo.hDevMode)
		
		IF hDC = 0 THEN RETURN 0
	END IF
	
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
' ############################
' #####  WinXPrint_Page  #####
' ############################
' Prints a single page
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
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
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

	'play the auto draw info into the printer
	StartPage (hPrinter)
	autoDraw_draw (hPrinter, binding.autoDrawInfo, x, y)
	IF EndPage (hPrinter) > 0 THEN RETURN $$TRUE ELSE RETURN $$FALSE
END FUNCTION
'
' ############################
' #####  WinXPrint_Done  #####
' ############################
' Finishes printing
' hPrinter =  the handle to the printer
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXPrint_Done (hPrinter)
	SHARED	PRINTINFO	printInfo
	
	EndDoc (hPrinter)
	DeleteDC (hPrinter)
	DestroyWindow (printInfo.hCancelDlg)
	printInfo.continuePrinting = $$FALSE
	RETURN $$TRUE
END FUNCTION
'
' ######################################
' #####  WinXComboBox_GetEditText  #####
' ######################################
' Gets the text in the edit cotrol of a combo box
' hCombo = the handle to the combo box
' returns the text or "" on fail
FUNCTION WinXComboBox_GetEditText$ (hCombo)
	hEdit = SendMessageA (hCombo, $$CBEM_GETEDITCONTROL, 0, 0)
	IFZ hEdit THEN RETURN "" ELSE RETURN WinXGetText$ (hEdit)
END FUNCTION
'
' ######################################
' #####  WinXComboBox_SetEditText  #####
' ######################################
' Sets the text in the edit control for a combo box
' hCombo = the handle to the combo box
' STRING text = the text to put in the control
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXComboBox_SetEditText (hCombo, STRING text)
	hEdit = SendMessageA (hCombo, $$CBEM_GETEDITCONTROL, 0, 0)
	IFZ hEdit THEN RETURN $$FALSE
	WinXSetText (hCombo, text)
	RETURN $$TRUE
END FUNCTION
'
' #############################
' #####  WinXAddGroupBox  #####
' #############################
' Creates a new group box and adds it to the specified window
' parent = the parent window
' label = the label for the group box
' id = the unique id for this control
' returns the handle to the window or 0 on fail
FUNCTION WinXAddGroupBox (parent, STRING label, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$BS_GROUPBOX
	hWnd = CreateWindowExA (0, &"button", &label, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	SetPropA (hWnd, &"WinXLeftSubSizer", &groupBox_SizeContents())
	SetPropA (hWnd, &"WinXAutoSizerSeries", autoSizerInfo_addGroup ($$DIR_VERT))
	RETURN hWnd
END FUNCTION
'
' #############################################
' #####  WinXGroupBox_GetAutosizerSeries  #####
' #############################################
' Gets the auto sizer series for a group box
' hGB = the handle to the group box
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXGroupBox_GetAutosizerSeries (hGB)
	ret = GetPropA (hGB, &"WinXAutoSizerSeries")
	IFZ ret THEN RETURN -1 ELSE RETURN ret
END FUNCTION
'
' ###################################
' #####  groupBox_SizeContents  #####
' ###################################
' get the viewable area for a group box, returns the auto sizer series
FUNCTION groupBox_SizeContents (hGB, pRect)
	RECT rect
	aRect = &rect
	XLONGAT(&&rect) = pRect
	
	GetClientRect (hGB, &rect)
	rect.left = rect.left+4
	rect.right = rect.right-4
	rect.top = rect.top+16
	rect.bottom = rect.bottom-4
	
	XLONGAT(&&rect) = aRect
	
	RETURN GetPropA (hGB, &"WinXAutoSizerSeries")
END FUNCTION
'
' ###############################
' #####  drawEllipseNoFill  #####
' ###############################
FUNCTION VOID drawEllipseNoFill (hdc, AUTODRAWRECORD record, x0, y0)
	xMid = (record.rect.x1+record.rect.x2)\2-x0
	y1py0 = record.rect.y1-y0
	Arc (hdc, record.rect.x1-x0, y1py0, record.rect.x2-x0, record.rect.y2-y0, xMid, y1py0, xMid, y1py0)
END FUNCTION
'
' ############################
' #####  drawRectNoFill  #####
' ############################
FUNCTION VOID drawRectNoFill (hdc, AUTODRAWRECORD record, x0, y0)
	POINT pt[]
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
' #####################
' #####  drawArc  #####
' #####################
FUNCTION VOID drawArc (hdc, AUTODRAWRECORD record, x0, y0)
	Arc (hdc, record.rectControl.x1-x0, record.rectControl.y1-y0, record.rectControl.x2-x0, _
	record.rectControl.y2-y0, record.rectControl.xC1-x0, record.rectControl.yC1-y0, _
	record.rectControl.xC2-x0, record.rectControl.yC2-y0)
END FUNCTION
'
' ######################
' #####  drawFill  #####
' ######################
FUNCTION VOID drawFill (hdc, AUTODRAWRECORD record, x0, y0)
	ExtFloodFill (hdc, record.simpleFill.x-x0, record.simpleFill.y-y0, record.simpleFill.col, $$FLOODFILLBORDER)
END FUNCTION
'
' ########################
' #####  drawBezier  #####
' ########################
FUNCTION VOID drawBezier (hdc, AUTODRAWRECORD record, x0, y0)
	POINT pt[]
	
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
END FUNCTION
'
' ############################
' #####  WinXRegOnClose  #####
' ############################
' Registers the onClose callback
FUNCTION WinXRegOnClose (hWnd, FUNCADDR onClose)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onClose = onClose
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ##########################
' #####  splitterProc  #####
' ##########################
' Window procedure for WinX Splitters.
FUNCTION splitterProc (hWnd, msg, wParam, lParam)
	STATIC dragging
	STATIC POINTAPI mousePos
	STATIC inDock
	STATIC mouseIn
	
	AUTOSIZERINFO autoSizerBlock
	SPLITTERINFO splitterInfo
	RECT rect
	RECT dock
	PAINTSTRUCT ps
	TRACKMOUSEEVENT tme
	POINTAPI newMousePos
	POINTAPI pt
	STATIC POINT vertex[]
	
	SPLITTERINFO_Get (GetWindowLongA (hWnd, $$GWL_USERDATA), @splitterInfo)
	
	SELECT CASE msg
		CASE $$WM_CREATE
			'lParam format = iSlitterInfo
			SetWindowLongA (hWnd, $$GWL_USERDATA, XLONGAT(lParam))
			mouseIn = 0
			
			DIM vertex[2]
		CASE $$WM_PAINT
			hDC = BeginPaint (hWnd, &ps)
			
			hShadPen = CreatePen ($$PS_SOLID, 1, GetSysColor ($$COLOR_3DSHADOW))
			hBlackPen = CreatePen ($$PS_SOLID, 1, 0x000000)
			hBlackBrush = CreateSolidBrush (0x000000)
			hHighlightBrush = CreateSolidBrush (GetSysColor($$COLOR_HIGHLIGHT))
			SelectObject (hDC, hShadPen)
			
			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hWnd, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN FillRect (hDC, &dock, hHighlightBrush)
			
			SELECT CASE splitterInfo.direction AND 0x00000003
				CASE $$DIR_VERT
					SELECT CASE TRUE
						CASE $$DOCK_DISABLED
						CASE ((splitterInfo.dock = $$DOCK_FOWARD)&&(splitterInfo.docked = 0))|| _
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
						((splitterInfo.dock = $$DOCK_FOWARD)&&(splitterInfo.docked > 0))
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
						CASE ((splitterInfo.dock = $$DOCK_FOWARD)&&(splitterInfo.docked = 0))|| _
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
						((splitterInfo.dock = $$DOCK_FOWARD)&&(splitterInfo.docked > 0))
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
			
			EndPaint (hWnd, &ps)
			
			RETURN 0
		CASE $$WM_LBUTTONDOWN
			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hWnd, &pt)
			IFF PtInRect (&dock, pt.x, pt.y) || splitterInfo.docked THEN
				SetCapture (hWnd)
				dragging = $$TRUE
				mousePos.x = LOWORD(lParam)
				mousePos.y = HIWORD(lParam)
				ClientToScreen (hWnd, &mousePos)
			END IF
			
			RETURN 0
			
		CASE $$WM_SETCURSOR
			GOSUB GetRect
			
			GetCursorPos (&pt)
			ScreenToClient (hWnd, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
				SetCursor (LoadCursorA (0, $$IDC_HAND))
			ELSE
				GOSUB SetSizeCursor
			END IF
			
			RETURN $$TRUE
		CASE $$WM_MOUSEMOVE
			GOSUB GetRect
			
			GetCursorPos (&pt)
			ScreenToClient (hWnd, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
				IFF inDock THEN
					'SetCursor (LoadCursorA (0, $$IDC_HAND))
					InvalidateRect (hWnd, 0, $$TRUE)
				END IF
				inDock = $$TRUE
			ELSE
				IF inDock THEN
					'GOSUB SetSizeCursor
					InvalidateRect (hWnd, 0, $$TRUE)
				END IF
				inDock = $$FALSE
			END IF
			
			IFF mouseIn THEN
				GetCursorPos (&pt)
				ScreenToClient (hWnd, &pt)
				IF PtInRect (&dock, pt.x, pt.y) THEN
					SetCursor (LoadCursorA (0, $$IDC_HAND))
					InvalidateRect (hWnd, 0, $$TRUE)
					inDock = $$TRUE
				ELSE
					GOSUB SetSizeCursor
					inDock = $$FALSE
				END IF
				
				tme.cbSize = SIZE(tme)
				tme.dwFlags = $$TME_LEAVE
				tme.hwndTrack = hWnd
				TrackMouseEvent (&tme)
				mouseIn = $$TRUE
			END IF
			
			IF dragging THEN
				newMousePos.x = LOWORD(lParam)
				newMousePos.y = HIWORD(lParam)
				ClientToScreen (hWnd, &newMousePos)
				
				'PRINT mouseX, newMouseX, mouseY, newMouseY
				
				autoSizerInfo_get (splitterInfo.group, splitterInfo.id, @autoSizerBlock)
				
				SELECT CASE splitterInfo.direction AND 0x00000003
					CASE $$DIR_HORIZ
						delta = newMousePos.x - mousePos.x
					CASE $$DIR_VERT
						delta = newMousePos.y - mousePos.y
				END SELECT
				
				IFZ delta THEN RETURN 0
				IF splitterInfo.direction AND $$DIR_REVERSE THEN
					autoSizerBlock.size = autoSizerBlock.size-delta
					IF splitterInfo.min && autoSizerBlock.size < splitterInfo.min THEN
						autoSizerBlock.size = splitterInfo.min
					ELSE
						IF splitterInfo.max && autoSizerBlock.size > splitterInfo.max THEN autoSizerBlock.size = splitterInfo.max
					END IF
				ELSE
					autoSizerBlock.size = autoSizerBlock.size+delta
					IF splitterInfo.max && autoSizerBlock.size > splitterInfo.max THEN
						autoSizerBlock.size = splitterInfo.max
					ELSE
						IF splitterInfo.min && autoSizerBlock.size < splitterInfo.min THEN autoSizerBlock.size = splitterInfo.min
					END IF
				END IF
				
				IF autoSizerBlock.size < 8 THEN
					autoSizerBlock.size = 8
				ELSE
					IF autoSizerBlock.size > splitterInfo.maxSize THEN autoSizerBlock.size = splitterInfo.maxSize
				END IF
				
				autoSizerInfo_update (splitterInfo.group, splitterInfo.id, autoSizerBlock)
				hParent = GetParent (hWnd)
				GetClientRect (hParent, &rect)
				sizeWindow (hParent, rect.right-rect.left, rect.bottom-rect.top)
				
				mousePos = newMousePos
			END IF
			
			RETURN 0
		CASE $$WM_LBUTTONUP
			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hWnd, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
				IF splitterInfo.docked THEN
					autoSizerInfo_get (splitterInfo.group, splitterInfo.id, @autoSizerBlock)
					autoSizerBlock.size = splitterInfo.docked
					splitterInfo.docked = 0
					
					SPLITTERINFO_Update (GetWindowLongA (hWnd, $$GWL_USERDATA), splitterInfo)
					
					autoSizerInfo_update (splitterInfo.group, splitterInfo.id, autoSizerBlock)
					hParent = GetParent (hWnd)
					GetClientRect (hParent, &rect)
					sizeWindow (hParent, rect.right-rect.left, rect.bottom-rect.top)
				ELSE
					autoSizerInfo_get (splitterInfo.group, splitterInfo.id, @autoSizerBlock)
					splitterInfo.docked = autoSizerBlock.size
					autoSizerBlock.size = 8
					
					SPLITTERINFO_Update (GetWindowLongA (hWnd, $$GWL_USERDATA), splitterInfo)
					
					autoSizerInfo_update (splitterInfo.group, splitterInfo.id, autoSizerBlock)
					hParent = GetParent (hWnd)
					GetClientRect (hParent, &rect)
					sizeWindow (hParent, rect.right-rect.left, rect.bottom-rect.top)
				END IF
			ELSE
				dragging = $$FALSE
				ReleaseCapture ()
			END IF
			
			RETURN 0
		CASE $$WM_MOUSELEAVE
			InvalidateRect (hWnd, 0, $$TRUE)
			mouseIn = $$FALSE
			
			RETURN 0
		CASE $$WM_DESTROY
			SPLITTERINFO_Delete (GetWindowLongA (hWnd, $$GWL_USERDATA))
			
			RETURN 0
		CASE ELSE
			
			RETURN DefWindowProcA (hWnd, msg, wParam, lParam)
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
		NEXT
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
		NEXT
	END SUB
	
	SUB GetRect
		IF splitterInfo.dock = $$DOCK_DISABLED THEN
			dock.left = 0
			dock.right = 0
			dock.bottom = 0
			dock.top = 0
		ELSE
			SELECT CASE splitterInfo.direction AND 0x00000003
				CASE $$DIR_VERT
					GetClientRect (hWnd, &rect)
					dock.left = (rect.right-120)/2
					dock.right = dock.left+120
					dock.top = 0
					dock.bottom = 8
				CASE $$DIR_HORIZ
					GetClientRect (hWnd, &rect)
					dock.top = (rect.bottom-120)/2
					dock.bottom = dock.top+120
					dock.left = 0
					dock.right = 8
			END SELECT
		END IF
	END SUB
	
	SUB SetSizeCursor
		IF splitterInfo.direction AND 0x00000003 = $$DIR_HORIZ THEN
			SetCursor (LoadCursorA (0, $$IDC_SIZEWE))		' vertical bar
		ELSE
			SetCursor (LoadCursorA (0, $$IDC_SIZENS))		' horizontal bar
		END IF
	END SUB
END FUNCTION
'
' #########################################
' #####  WinXAutoSizer_SetSimpleInfo  #####
' #########################################
' A simplified version of WinXAutoSizer_SetInfo
FUNCTION WinXAutoSizer_SetSimpleInfo (hWnd, series, DOUBLE space, DOUBLE size, flags)
	RETURN WinXAutoSizer_SetInfo (hWnd, series, space, size, 0, 0, 1, 1, flags)
END FUNCTION
'
' #############################
' #####  WinXAddListView  #####
' #############################
' Creates a new list view control
' editable enables/disables label editing.  view is a view constant
' returns the handle to the new window or 0 on fail
FUNCTION WinXAddListView (parent, hilLargeIcons, hilSmallIcons, editable, view, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP|view
	IF editable THEN style = style|$$LVS_EDITLABELS

	hWnd = CreateWindowExA (0, &$$WC_LISTVIEW, 0, style, 0, 0, 0, 0, parent, id, GetModuleHandleA (0), 0)
	
	SendMessageA (hWnd, $$LVM_SETIMAGELIST, $$LVSIL_NORMAL, hilLargeIcons)
	SendMessageA (hWnd, $$LVM_SETIMAGELIST, $$LVSIL_SMALL, hilSmallIcons)
	
	SendMessageA (hWnd, $$LVM_SETEXTENDEDLISTVIEWSTYLE, $$LVS_EX_FULLROWSELECT|$$LVS_EX_LABELTIP, $$LVS_EX_FULLROWSELECT|$$LVS_EX_LABELTIP)
	
	RETURN hWnd
END FUNCTION
'
' ##################################
' #####  WinXListView_SetView  #####
' ##################################
' Sets the view of a listview control
' hLV = the handle to the control
' view = the view to set
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_SetView (hLV, view)
	style = GetWindowLongA (hLV, $$GWL_STYLE)
	style = (style AND NOT($$LVS_ICON|$$LVS_SMALLICON|$$LVS_LIST|$$LVS_REPORT)) OR view
	SetWindowLongA (hLV, $$GWL_STYLE, style)
END FUNCTION
'
' ####################################
' #####  WinXListView_AddColumn  #####
' ####################################
' Adds a column to a listview control for use in report view
' iColumn = the 0 based index for the new column
' wColumn = the width of the column
' label = the label for the column
' iSubItem = the 1 based index of the sub item the column displays
' returns the index to the column or -1 on fail
FUNCTION WinXListView_AddColumn (hLV, iColumn, wColumn, STRING label, iSubItem)
	LVCOLUMN lvCol
	
	lvCol.mask = $$LVCF_FMT|$$LVCF_ORDER|$$LVCF_SUBITEM|$$LVCF_TEXT|$$LVCF_WIDTH
	lvCol.fmt = $$LVCFMT_LEFT
	lvCol.cx = wColumn
	lvCol.pszText = &label
	lvCol.iSubItem = iSubItem
	lvCol.iOrder = iColumn
	RETURN SendMessageA (hLV, $$LVM_INSERTCOLUMN, iColumn, &lvCol)
END FUNCTION
'
' #######################################
' #####  WinXListView_DeleteColumn  #####
' #######################################
' Deletes a column in a listview control
' iColumn = the 0 based index of the column to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_DeleteColumn (hLV, iColumn)
	IFZ SendMessageA (hLV, $$LVM_DELETECOLUMN, iColumn, 0) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ##################################
' #####  WinXListView_AddItem  #####
' ##################################
' Adds a new item to a list view control
' iItem = the index at which to insert the item, -1 to add to the end of the list
' STRING item = the label for the item plus subitems in the form "label\0subItem1\0subItem2..."
' iIcon = the index to the icon or -1 if this item has no icon
' returns the index to the item or -1 on error
FUNCTION WinXListView_AddItem (hLV, iItem, STRING item, iIcon)
	LVITEM	lvi
	
	'parse the string
	XstParseStringToStringArray (item, "\0", @s$[])
	IF UBOUND(s$[]) = -1 THEN RETURN -1
	
	'set the item
	lvi.mask = $$LVIF_TEXT
	IF iIcon > -1 THEN lvi.mask = lvi.mask|$$LVIF_IMAGE
	IF iItem > -1 THEN lvi.iItem = iItem ELSE lvi.iItem = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
	lvi.iSubItem = 0
	lvi.pszText = &s$[0]
	lvi.iImage = iIcon
	
	iItem = SendMessageA (hLV, $$LVM_INSERTITEM, 0, &lvi)
	IF iItem = -1 THEN RETURN -1
	
	'set the subitems
	FOR i = 1 TO UBOUND(s$[])
		lvi.mask = $$LVIF_TEXT
		lvi.iItem = iItem
		lvi.iSubItem = i
		lvi.pszText = &s$[i]
		SendMessageA (hLV, $$LVM_SETITEM, 0, &lvi)
	NEXT
	
	RETURN iItem
END FUNCTION
'
' #####################################
' #####  WinXListView_DeleteItem  #####
' #####################################
' Deletes an item from a listview control
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_DeleteItem (hLV, iItem)
	IFZ SendMessageA (hLV, $$LVM_DELETEITEM, iItem, 0) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' #######################################
' #####  WinXListView_GetSelection  #####
' #######################################
' Gets the current selection
' iItems[] = the array in which to store the indecies of selected items
' returns the number of selected items
FUNCTION WinXListView_GetSelection (hLV, iItems[])
	cSelItems = SendMessageA (hLV, $$LVM_GETSELECTEDCOUNT, 0, 0)
	IF cSelItems = 0 THEN RETURN 0
	DIM iItems[cSelItems-1]
	maxItem = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)-1
	
	slot = 0
	'now iterate over all the items to locate the selected ones
	FOR i = 0 TO maxItem
		IF SendMessageA (hLV, $$LVM_GETITEMSTATE, i, $$LVIS_SELECTED) THEN
			iItems[slot] = i
			INC slot
		END IF
	NEXT
	
	RETURN cSelItems
END FUNCTION
'
' #######################################
' #####  WinXListView_SetSelection  #####
' #######################################
' Sets the selection in a listview control
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_SetSelection (hLV, iItems[])
	LVITEM lvi
	
	FOR i = 0 TO UBOUND(iItems[])
		lvi.mask = $$LVIF_STATE
		lvi.iItem = iItems[i]
		lvi.state = $$LVIS_SELECTED
		lvi.stateMask = $$LVIS_SELECTED
		IFZ SendMessageA (hLV, $$LVM_SETITEM, 0, &lvi) THEN RETURN $$FALSE
	NEXT
	
	RETURN $$TRUE
END FUNCTION
'
' ######################################
' #####  WinXListView_SetItemText  #####
' ######################################
' Sets new text for an item
' iItem = the 0 based index of the item, iSubItem = 0 the 1 based index of the subitem or 0 if setting the main item
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_SetItemText (hLV, iItem, iSubItem, STRING newText)
	LVITEM lvi
	
	lvi.mask = $$LVIF_TEXT
	lvi.iItem = iItem
	lvi.iSubItem = iSubItem
	lvi.pszText = &newText
	IFZ SendMessageA (hLV, $$LVM_SETITEMTEXT, iItem, &lvi) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ######################
' #####  drawText  #####
' ######################
' Draws a text string
FUNCTION VOID drawText (hdc, AUTODRAWRECORD record, x0, y0)
	SetTextColor (hdc, record.text.forColour)
	IF record.text.backColour = -1 THEN
		SetBkMode (hdc, $$TRANSPARENT)
	ELSE
		SetBkMode (hdc, $$OPAQUE)
		SetBkColor (hdc, record.text.backColour)
	END IF
	STRING_Get (record.text.iString, @stri$)
	ExtTextOutA (hdc, record.text.x-x0, record.text.y-y0, options, 0, &stri$, LEN(stri$), 0)
END FUNCTION
'
' #######################
' #####  drawImage  #####
' #######################
' Draws an image
FUNCTION VOID drawImage (hdc, AUTODRAWRECORD record, x0, y0)
	BLENDFUNCTION blfn

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
	END IF
	SelectObject (hdcSrc, hOld)
END FUNCTION

'A wrapper for the misdefined AlphaBlend function
FUNCTION ApiAlphaBlend (hdcDest, nXOriginDest, nYOrigDest, nWidthDest, nHeightDest, hdcSrc, nXOriginSrc, nYOriginSrc, nWidthSrc, nHeightSrc, BLENDFUNCTION blendFunction)
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
	
	RETURN XstCall ("AlphaBlend", "msimg32.dll", @args[])
END FUNCTION
'
' ####################################
' #####  WinXDraw_SetImagePixel  #####
' ####################################
' Sets a pixel on a WinX image
' hImage = the handle to the image
' x, y = the coordinates of the pixel
' colour = the colour for the pixel
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_SetImagePixel (hImage, x, y, colour)
	BITMAP bmp
	
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN $$FALSE
	IF x < 0 || x >= bmp.width || y < 0 || y >= bmp.height THEN RETURN $$FALSE
	ULONGAT(bmp.bits, ((bmp.height-1-y)*bmp.width+x)<<2) = colour
	
	RETURN $$TRUE
END FUNCTION
'
' ####################################
' #####  WinXDraw_GetImagePixel  #####
' ####################################
' Gets a pixel on WinX image
' hImage =  the handle to the image
' x, y = the x and y coordinates of the pixel
' returns the colour at the point or 0 on fail
FUNCTION RGBA WinXDraw_GetImagePixel (hImage, x, y)
	BITMAP bmp
	RGBA ret
	
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN 0
	IF x < 0 || x >= bmp.width || y < 0 || y >= bmp.height THEN RETURN 0
	ULONGAT(&ret) = ULONGAT(bmp.bits, ((bmp.height-1-y)*bmp.width+x)<<2)
	RETURN ret
END FUNCTION
'
' #######################################
' #####  WinXDraw_SetConstantAlpha  #####
' #######################################
' Sets the transparency of an image to a constant value
' hImage = the handle to the image
' alpha = the constant alpha 
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_SetConstantAlpha (hImage, DOUBLE alpha)
	BITMAP bmp
	ULONG intAlpha
	
	IF alpha < 0 || alpha > 1 THEN RETURN $$FALSE
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN $$FALSE
	
	intAlpha = ULONG(alpha*255.0)<<24
	
	maxPixel = bmp.width*bmp.height - 1
	FOR i = 0 TO maxPixel
		ULONGAT(bmp.bits, i<<2) = (ULONGAT(bmp.bits, i<<2) AND 0x00FFFFFFFF)|intAlpha
	NEXT
	
	RETURN $$TRUE
END FUNCTION
'
' ######################################
' #####  WinXDraw_SetImageChannel  #####
' ######################################
' Sets one of the channels of a WinX image
' hImage = the handle to the image
' channel = the channel id, 0 for blue, 1 for green, 2 for red, 3 for alpha
' data[] = the channel data, a single dimensional UBYTE array containing the channel data
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_SetImageChannel (hImage, channel, UBYTE data[])
	BITMAP bmp
	
	IF channel < 0 || channel > 3 THEN RETURN $$FALSE
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN $$FALSE
	
	upshift = channel<<3
	mask = NOT(255<<upshift)
	
	maxPixel = bmp.width*bmp.height - 1
	IF maxPixel != UBOUND(data[]) THEN RETURN $$FALSE
	FOR i = 0 TO maxPixel
		ULONGAT(bmp.bits, i<<2) = (ULONGAT(bmp.bits, i<<2) AND mask)|ULONG(data[i])<<upshift
	NEXT
END FUNCTION
'
' ######################################
' #####  WinXDraw_GetImageChannel  #####
' ######################################
' Retrieves on of the channels of a WinX image
' hImage =  the handle of the image
' channel = the channel if, 0 for blue, 1 for green, 2 for red, 3 for alpha
' data[] =  the UBYTE array to store the channel data
' returns $$TRUE on success or $$FALSE on fail, dimensions data[] appropriately
FUNCTION WinXDraw_GetImageChannel (hImage, channel, UBYTE data[])
	BITMAP bmp
	ULONG pixel
	
	IF channel < 0 || channel > 3 THEN RETURN $$FALSE
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN $$FALSE
	
	downshift = channel<<3
	
	maxPixel = bmp.width*bmp.height - 1
	DIM data[maxPixel]
	FOR i = 0 TO maxPixel
		pixel = ULONGAT(bmp.bits, i<<2)
		data[i] = UBYTE((pixel>>downshift) AND 0x000000FF)
	NEXT
	
	RETURN $$TRUE
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
' Premultiplis an image with its alpha channel in preparation for alpha blending
' hImage =  the image to premultiply
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_PremultiplyImage (hImage)
	BITMAP bmp
	RGBA rgba
	
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) RETURN $$FALSE
	
	maxPixel = bmp.width*bmp.height-1
	FOR i = 0 TO maxPixel
		'get pixel
		ULONGAT(&rgba) = ULONGAT(bmp.bits, i<<2)
		rgba.blue		= UBYTE((XLONG(rgba.blue)*XLONG(rgba.alpha))\255)
		rgba.green	= UBYTE((XLONG(rgba.green)*XLONG(rgba.alpha))\255)
		rgba.red		= UBYTE((XLONG(rgba.red)*XLONG(rgba.alpha))\255)
		ULONGAT(bmp.bits, i<<2) = ULONGAT(&rgba)
	NEXT
	
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXPrint_PageSetup  #####
' #################################
' Displays a page setup dialog box to the user and updates the print parameters according to the result
' hWndOwner = the handle to the window that owns the dialog
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXPrint_PageSetup (hWndOwner)
	SHARED	PRINTINFO	printInfo
	PAGESETUPDLG pageSetupDlg
	UBYTE localeInfo[3]
	
	pageSetupDlg.lStructSize = SIZE(PAGESETUPDLG)
	pageSetupDlg.hwndOwner = hWndOwner
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
	END IF
	
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
		END IF
		RETURN $$TRUE
	ELSE
		RETURN $$FALSE
	END IF
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
' ###################################
' #####  WinXDraw_GetImageInfo  #####
' ###################################
' Gets information about an image
' hImage = the handle of the image to get info on
' w, h = the width and height of the image
' pBits = the pointer to the bits.  They are arranged row first with the last row at the top of the file
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_GetImageInfo (hImage, @w, @h, @pBits)
	BITMAP bmp
	IFZ GetObjectA (hImage, SIZE(BITMAP), &bmp) THEN RETURN $$FALSE
	
	w = bmp.width
	h = bmp.height
	pBits = bmp.bits
	RETURN $$TRUE
END FUNCTION
'
' ##############################
' #####  cancelDlgOnClose  #####
' ##############################
' onClose callback for the cancel printing dialog box
FUNCTION cancelDlgOnClose (hWnd)
	SHARED	PRINTINFO	printInfo
	printInfo.continuePrinting = $$FALSE
	printInfo.hCancelDlg = 0
	DestroyWindow (hWnd)
END FUNCTION
'
' ################################
' #####  cancelDlgOnCommand  #####
' ################################
' onCommand callback for the cancel printing dialog box
FUNCTION cancelDlgOnCommand (id, code, hWnd)
	SHARED	PRINTINFO	printInfo
	
	SELECT CASE id
		CASE $$IDCANCEL
			SendMessageA (printInfo.hCancelDlg, $$WM_CLOSE, 0, 0)
	END SELECT
END FUNCTION
'
' ############################
' #####  printAbortProc  #####
' ############################
' Abort proc for printing
FUNCTION printAbortProc (hdc, nCode)
	SHARED	PRINTINFO	printInfo
  MSG msg
 
	DO WHILE PeekMessageA (&msg, 0, 0, 0, $$PM_REMOVE)
		IF !IsDialogMessageA (printInfo.hCancelDlg, &msg) THEN
			TranslateMessage (&msg)
			DispatchMessageA (&msg)
		END IF
	LOOP

	RETURN printInfo.continuePrinting 
END FUNCTION
'
' #####################################
' #####  WinXDraw_PixelsPerPoint  #####
' #####################################
' gets the conversion factor between screen pixels and points
FUNCTION DOUBLE WinXDraw_PixelsPerPoint ()
	hDC = GetDC (GetDesktopWindow ())
	ret# = DOUBLE(GetDeviceCaps (hDC, $$LOGPIXELSY))/72.0
	ReleaseDC (GetDesktopWindow (), hDC)
	RETURN ret#
END FUNCTION
'
' ########################################
' #####  WinXPrint_LogUnitsPerPoint  #####
' ########################################
' Gets the conversion factor between logical units and points
FUNCTION DOUBLE WinXPrint_LogUnitsPerPoint (hPrinter, cyLog, cyPhys)
	RETURN (DOUBLE(GetDeviceCaps (hPrinter, $$LOGPIXELSY))*DOUBLE(cyLog))/(72.0*DOUBLE(cyPhys))
END FUNCTION
'
' #######################################
' #####  WinXPrint_DevUnitsPerInch  #####
' #######################################
' Gets the number of device units in an inch
' w, h = variables to store the width and height
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXPrint_DevUnitsPerInch (hPrinter, @w, @h)
	w = GetDeviceCaps (hPrinter, $$LOGPIXELSX)
	h = GetDeviceCaps (hPrinter, $$LOGPIXELSY)
	RETURN w
END FUNCTION
'
' ##################################
' #####  WinXRegOnFocusChange  #####
' ##################################
' Registers a callback for when the focus changes
' hWnd = the handle to the window
' onFocusChange = the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnFocusChange (hWnd, FUNCADDR onFocusChange)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onFocusChange = onFocusChange
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXSetWindowColour  #####
' #################################
' Changes the window background colour
' hWnd = the window to change the colour for
' colour = the new colour
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetWindowColour (hWnd, colour)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	IF binding.backCol THEN DeleteObject (binding.backCol)
	binding.backCol = CreateSolidBrush (colour)
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION

FUNCTION autoDraw_add (iList, iRecord)
	LINKEDLIST autoDraw
	
	LINKEDLIST_Get (iList, @autoDraw)
	LinkedList_Append (@autoDraw, iRecord)
	LINKEDLIST_Update (iList, autoDraw)
	
	RETURN autoDraw.cItems-1
END FUNCTION
'
' ######################################
' #####  WinXListView_GetItemText  #####
' ######################################
' Gets the text for a list view item
' hLV = the handle to the list view
' iItem = the 0 based index of the item
' cSubItems = the number of sub items to get
' text$[] = the array to store the result
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_GetItemText (hLV, iItem, cSubItems, @text$[])
	LVITEM lvi
	
	DIM text$[cSubItems]
	FOR i = 0 TO cSubItems
		buffer$ = NULL$(4096)
		lvi.mask = $$LVIF_TEXT
		lvi.pszText = &buffer$
		lvi.cchTextMax = 4095
		lvi.iItem = iItem
		lvi.iSubItem = i
		
		IFF SendMessageA (hLV, $$LVM_GETITEM, iItem, &lvi) THEN RETURN $$FALSE
		text$[i] = CSTRING$(&buffer$)
	NEXT
	
	RETURN $$TRUE
END FUNCTION
'
' ################################
' #####  WinXDialog_Message  #####
' ################################
' Displays a simple message dialog box
' hWnd = the handle to the owner window, 0 for none
' text$ = the text to display
' title$ = the title for the dialog
' iIcon = the id of the icon to use
' hMod = the handle to the module from which the icon comes, 0 for this module
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDialog_Message (hWnd, text$, title$, iIcon, hMod)
	SHARED hInst
	MSGBOXPARAMS mb
	
	mb.cbSize = SIZE(MSGBOXPARAMS)
	mb.hwndOwner = hWnd
	IFZ hMod THEN mb.hInstance = hInst ELSE mb.hInstance = hMod
	mb.lpszText = &text$
	mb.lpszCaption = &title$
	mb.dwStyle = $$MB_OK
	IF iIcon THEN mb.dwStyle = mb.dwStyle|$$MB_USERICON
	mb.lpszIcon = iIcon
	
	MessageBoxIndirectA (&mb)
	RETURN $$TRUE
END FUNCTION
'
' #################################
' #####  WinXDialog_Question  #####
' #################################
' Displays a dialog asking the user a question
' hWnd = the handle to the owner window or 0 for none
' text$ = the question
' title$ = the dialog box title
' cancel = $$TRUE to enable the cancel button
' defaultButton = the 0 based index of the default button
' returns the id of the button the user selected
FUNCTION WinXDialog_Question (hWnd, text$, title$, cancel, defaultButton)
	IF cancel THEN style = $$MB_YESNOCANCEL ELSE style = $$MB_YESNO
	SELECT CASE defaultButton
		CASE 1
			style = style|$$MB_DEFBUTTON2
		CASE 2
			style = style|$$MB_DEFBUTTON3
	END SELECT
	style = style|$$MB_ICONQUESTION
	
	RETURN MessageBoxA (hWnd, &text$, &title$, style)
END FUNCTION
'
' ########################################
' #####  WinXSplitter_SetProperties  #####
' ########################################
' Sets splitter info
' series = the series the control is located in
' hCtrl = the handle to the control
' min = the minimum size of the control
' max = the maximum size of the control
' dock = $$TRUE to allow docking - else $$FALSE
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSplitter_SetProperties (series, hCtrl, min, max, dock)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	SPLITTERINFO splitterInfo
	
	IFF series >= 0 && series <= UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[series].inUse THEN RETURN $$FALSE
	
	' Walk the list untill we find the autodraw record we need
	found = $$FALSE
	i = autoSizerInfoUM[series].firstItem
	DO WHILE i > -1
		IF autoSizerInfo[series, i].hWnd = hCtrl THEN
			found = $$TRUE
			EXIT DO
		END IF
		i = autoSizerInfo[series, i].nextItem
	LOOP
	
	IFF found THEN RETURN $$FALSE

	iSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (iSplitter, @splitterInfo)
	splitterInfo.min = min
	splitterInfo.max = max
	IF dock THEN

		IF autoSizerInfoUM[series].direction AND $$DIR_REVERSE
			splitterInfo.dock = $$DOCK_BACKWARD
		ELSE
			splitterInfo.dock = $$DOCK_FOWARD
		END IF
	ELSE
		splitterInfo.dock = $$DOCK_DISABLED
	END IF
	
	SPLITTERINFO_Update (iSplitter, splitterInfo)
	
	RETURN $$TRUE
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
' returns $$TRUE on success or $$FALSE on error
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
			END IF
		END IF
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ|$$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			SELECT CASE disposition
				CASE $$REG_CREATED_NEW_KEY
					IF createOnOpenFail THEN
						IF RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &result, 4) = $$ERROR_SUCCESS THEN ret = $$TRUE
					END IF
				CASE $$REG_OPENED_EXISTING_KEY
					IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result, &four) = $$ERROR_SUCCESS THEN ret = $$TRUE
			END SELECT
			RegCloseKey (hSubKey)
		END IF
	END IF
	
	RETURN ret
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
' returns $$TRUE on success or $$FALSE on error
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
					END IF
				CASE $$REG_OPENED_EXISTING_KEY
					GOSUB QueryVariable
			END SELECT
			RegCloseKey (hSubKey)
		END IF
	END IF
	
	RETURN ret
	
	SUB QueryVariable
		IF RegQueryValueExA (hSubKey, &value$, 0, &type, 0, &cbSize) = $$ERROR_SUCCESS THEN
			IF (type = $$REG_EXPAND_SZ)||(type = $$REG_SZ)||(type = $$REG_MULTI_SZ) THEN
				result$ = NULL$(cbSize)
				IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result$, &cbSize) = $$ERROR_SUCCESS THEN
					ret = $$TRUE
				END IF
			END IF
		ELSE
			IF createOnOpenFail THEN
				IF RegSetValueExA (hSubKey, &value$, 0, $$REG_EXPAND_SZ, &result$, LEN(result$)+1) = $$ERROR_SUCCESS THEN ret = $$TRUE
			END IF
		END IF
	END SUB
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
' returns $$TRUE on success or $$FALSE on error
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
					END IF
				CASE $$REG_OPENED_EXISTING_KEY
					GOSUB QueryVariable
			END SELECT
			RegCloseKey (hSubKey)
		END IF
	END IF
	
	RETURN ret
	
	SUB QueryVariable
		IF RegQueryValueExA (hSubKey, &value$, 0, &type, 0, &cbSize) = $$ERROR_SUCCESS THEN
			IF (type = $$REG_BINARY) THEN
				result$ = NULL$(cbSize)
				IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result$, &cbSize) = $$ERROR_SUCCESS THEN ret = $$TRUE
			END IF
		ELSE
			IF createOnOpenFail THEN
				IF RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &result$, LEN(result$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
			END IF
		END IF
	END SUB
END FUNCTION
'
' ###################################
' #####  WinXRegistry_WriteInt  #####
' ###################################
' Writes an integer into the registry
' hKey = the top level key to read from
' subKey$ = the subkey of the top level key
' value$ = the value to read, "" for default
' createOnFail = $$TRUE to create the key if it doesn't exist.  Assigns result to the key
' sa = the security attributes for the key if it is created
' int = the integer to write into the registry
' returns $$TRUE on success or $$FALSE on error
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
		END IF
	END IF
	
	RETURN ret
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
' buffer$ = the string to write into the registry
' returns $$TRUE on success or $$FALSE on error
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
		END IF
	END IF
	
	RETURN ret
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
' buffer$ = the binary data to write into the registry
' returns $$TRUE on success or $$FALSE on error
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
		END IF
	END IF
	
	RETURN ret
END FUNCTION
'
' ################################
' #####  WinXAddAccelerator  #####
' ################################
' Adds an accelerator to an accelerator array
' accel[] = an array of accelerators
' cmd = the command the accelerator sends to WM_COMMAND
' key = the VK key code
' control, alt, shit = $$TRUE if the modifier is down, $$FALSE otherwise
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAddAccelerator (ACCEL accel[], cmd, key, control, alt, shift)
	i = UBOUND(accel[])
	IF i = -1 THEN
		DIM accel[0]
	ELSE
		REDIM accel[i+1]
	END IF
	i = UBOUND(accel[])
	
	accel[i].fVirt = $$FVIRTKEY
	SELECT CASE ALL TRUE
		CASE control
			accel[i].fVirt = accel[i].fVirt|$$FCONTROL
		CASE alt
			accel[i].fVirt = accel[i].fVirt|$$FALT
		CASE shift
			accel[i].fVirt = accel[i].fVirt|$$FSHIFT
	END SELECT
	
	accel[i].key = key
	accel[i].cmd = cmd

	RETURN $$TRUE
END FUNCTION
'
' ################################
' #####  WinXSplitter_GetPos  #####
' ################################
' Get the current position of a splitter control
' series = the series to which the splitter belongs
' hCtrl = the control the splitter is attached to
' position = the variable to store the position of the splitter
' docked = the variable to store the docking state, $$TRUE when docked else $$FALSE
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSplitter_GetPos (series, hCtrl, @position, @docked)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	SPLITTERINFO splitterInfo
	
	IFF series >= 0 && series <= UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[series].inUse THEN RETURN $$FALSE
	
	' Walk the list untill we find the autodraw record we need
	found = $$FALSE
	i = autoSizerInfoUM[series].firstItem
	DO WHILE i > -1
		IF autoSizerInfo[series, i].hWnd = hCtrl THEN
			found = $$TRUE
			EXIT DO
		END IF
		i = autoSizerInfo[series, i].nextItem
	LOOP
	
	IFF found THEN RETURN $$FALSE

	iSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (iSplitter, @splitterInfo)

	IF splitterInfo.docked THEN
		position = splitterInfo.docked
		docked = $$TRUE
	ELSE
		position = autoSizerInfo[series, i].size
		docked = $$FALSE
	END IF
	
	RETURN $$TRUE
END FUNCTION
'
' ################################
' #####  WinXSplitter_SetPos  #####
' ################################
' Set the current position of a splitter control
' series = the series to which the splitter belongs
' hCtrl = the control the splitter is attached to
' position = the new position for the splitter
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSplitter_SetPos (series, hCtrl, position, docked)
	SHARED	AUTOSIZERINFO	autoSizerInfo[]	'info for the autosizer
	SHARED	SIZELISTHEAD	autoSizerInfoUM[]
	SPLITTERINFO splitterInfo
	RECT rect
	
	IFF series >= 0 && series <= UBOUND(autoSizerInfoUM[]) THEN RETURN $$FALSE
	IFF autoSizerInfoUM[series].inUse THEN RETURN $$FALSE
	
	' Walk the list untill we find the autosizer record we need
	found = $$FALSE
	i = autoSizerInfoUM[series].firstItem
	DO WHILE i > -1
		IF autoSizerInfo[series, i].hWnd = hCtrl THEN
			found = $$TRUE
			EXIT DO
		END IF
		i = autoSizerInfo[series, i].nextItem
	LOOP
	
	IFF found THEN RETURN $$FALSE

	iSplitter = GetWindowLongA (autoSizerInfo[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (iSplitter, @splitterInfo)

	IF docked THEN
		autoSizerInfo[series, i].size = 8
		splitterInfo.docked = position
	ELSE
		autoSizerInfo[series, i].size = position
		splitterInfo.docked = 0
	END IF
	
	SPLITTERINFO_Update (iSplitter, splitterInfo)
	
	GetClientRect (GetParent (hCtrl), &rect)
	sizeWindow (GetParent (hCtrl), rect.right-rect.left, rect.bottom-rect.top)
	
	RETURN $$TRUE
END FUNCTION
'
' ###############################
' #####  WinXClip_IsString  #####
' ###############################
' Checks to see if the clipboard contains a string
' Returns $$TRUE if the clipboard contains a string, otherwise $$FALSE
FUNCTION WinXClip_IsString ()
	IFZ IsClipboardFormatAvailable ($$CF_TEXT) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ################################
' #####  WinXClip_PutString  #####
' ################################
' Copies a string to the clipboard
' Stri$ = The string to copy
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClip_PutString (Stri$)
	SHARED hClipMem
	
	IFZ OpenClipboard (0) THEN RETURN $$FALSE
	EmptyClipboard ()
	
	hClipMem = GlobalAlloc ($$GMEM_MOVEABLE|$$GMEM_ZEROINIT, LEN(Stri$)+1)
	pMem = GlobalLock (hClipMem)
	RtlMoveMemory (pMem, &Stri$, LEN(Stri$))
	GlobalUnlock (hClipMem)
	
	SetClipboardData ($$CF_TEXT, hClipMem)
	CloseClipboard ()

	RETURN $$TRUE
END FUNCTION
'
' ################################
' #####  WinXClip_GetString  #####
' ################################
' Gets a string from the clipboard
' Returns the string or "" on fail
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
' Registers a callback for when the clipboard changes
' hWnd = the handle to the window
' onFocusChange = the address of the callback
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnClipChange (hWnd, FUNCADDR onClipChange)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.hWndNextClipViewer = SetClipboardViewer (hWnd)
	
	binding.onClipChange = onClipChange
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' #########################
' #####  WinXNewACL  #####
' #########################
' Creates a security attributes structure
' ssd$ = a string describing the ACL, 0 for null
' inherit = $$TRUE if these attributes can be inherited, otherwise $$FALSE
' returns the SECURITY_ATTRIBUTES structure
FUNCTION SECURITY_ATTRIBUTES WinXNewACL (ssd$, inherit)
	SECURITY_ATTRIBUTES ret
	
	ret.length = SIZE(SECURITY_ATTRIBUTES)
	IF inherit THEN ret.inherit = 1
	
	IF ssd$ THEN
		ConvertStringSecurityDescriptorToSecurityDescriptorA (&ssd$, $$SDDL_REVISION_1, &ret.securityDescriptor, 0)
	END IF
	
	RETURN ret
END FUNCTION
'
' #################################
' #####  WinXRegOnEnterLeave  #####
' #################################
' Registers the onEnterLeave callback
' hWnd = the handle to the window to register the callback for
' onEnterLeave = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnEnterLeave (hWnd, FUNCADDR onEnterLeave)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onEnterLeave = onEnterLeave
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ###########################
' #####  WinXSetCursor  #####
' ###########################
' Sets a window's cursor
' hWnd = the handle to the window
' hCursor = the cursor
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetCursor (hWnd, hCursor)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.hCursor = hCursor
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ###############################
' #####  WinXScroll_GetPos  #####
' ###############################
' Gets the scrolling position of a window
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
	
	RETURN $$TRUE
END FUNCTION
'
' ###############################
' #####  WinXScroll_GetPos  #####
' ###############################
' Sets the scrolling position of a window
' hWnd = the handle to the window
' direction = the scrolling direction
' pos = the new scrolling position
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXScroll_SetPos (hWnd, direction, pos)
	SCROLLINFO si
	
	si.cbSize = SIZE(SCROLLINFO)
	si.fMask = $$SIF_POS
	si.nPos = pos
	SELECT CASE direction
		CASE $$DIR_HORIZ
			SetScrollInfo (hWnd, $$SB_HORZ, &si, $$TRUE)
		CASE $$DIR_VERT
			SetScrollInfo (hWnd, $$SB_VERT, &si, $$TRUE)
	END SELECT

	RETURN $$TRUE
END FUNCTION
'
' ###########################
' #####  WinXRegOnItem  #####
' ###########################
' Registers the onItem callback for a listview control
' hWnd = the window to register the message for
' onItem = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnItem (hWnd, FUNCADDR onItem)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onItem = onItem
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ##################################
' #####  WinXRegOnColumnClick  #####
' ##################################
' Registers the onColumnClick callback for a listview control
' hWnd = the window to register the callback for
' onColumnClick = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnColumnClick (hWnd, FUNCADDR onColumnClick)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onColumnClick = onColumnClick
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ###########################################
' #####  WinXListView_GetItemFromPoint  #####
' ###########################################
' Gets a list view item given its coordinates
' hLV = the control to get the item from
' x, y = the x and y coordinates to find the item at
' returns the item index or -1 on fail
FUNCTION WinXListView_GetItemFromPoint (hLV, x, y)
	LVHITTESTINFO ht
	
	ht.pt.x = x
	ht.pt.y = y
	RETURN SendMessageA (hLV, $$LVM_HITTEST, 0, &ht)
END FUNCTION
'
' ###############################
' #####  WinXListView_Sort  #####
' ###############################
' Sorts the items in a list view control
' hLV = the list view control to sort
' iCol = the 0 based index of the column to sort by
' desc = $$TRUE to sort descending instead of ascending
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_Sort (hLV, iCol, desc)
	SHARED lvs_iCol
	SHARED lvs_desc
	
	lvs_iCol = iCol
	lvs_desc = desc
	RETURN SendMessageA (hLV, $$LVM_SORTITEMSEX, hLV, &CompareLVItems())
END FUNCTION
'
' ###########################################
' #####  WinXTreeView_GetItemFromPoint  #####
' ###########################################
' Gets a tree view item given its coordinates
' hTV = the control to get the item from
' x, y = the x and y coordinates to find the item at
' returns the item index or 0 on fail
FUNCTION WinXTreeView_GetItemFromPoint (hTV, x, y)
	TV_HITTESTINFO ht
	
	ht.pt.x = x
	ht.pt.y = y
	RETURN SendMessageA (hTV, $$TVM_HITTEST, 0, &ht)
END FUNCTION
'
' ############################
' #####  CompareLVItems  #####
' ############################
' Compares two listview items
FUNCTION CompareLVItems (item1, item2, hLV)
	SHARED lvs_iCol
	SHARED lvs_desc
	
	LV_ITEM lvi
	
	buffer$ = NULL$(1024)
	lvi.mask = $$LVIF_TEXT
	lvi.pszText = &buffer$
	lvi.cchTextMax = 1023
	lvi.iItem = item1
	lvi.iSubItem = lvs_iCol AND 0x7FFFFFFF
	SendMessageA (hLV, $$LVM_GETITEM, iItem1, &lvi)
	a$ = CSTRING$(&buffer$)
	buffer$ = NULL$(1024)
	lvi.pszText = &buffer$
	lvi.cchTextMax = 1023
	lvi.iItem = item2
	SendMessageA (hLV, $$LVM_GETITEM, iItem2, &lvi)
	b$ = CSTRING$(&buffer$)
	
	ret = 0
	FOR i = 0 TO MIN(UBOUND(a$), UBOUND(b$))
		IF a${i} < b${i} THEN
			ret = -1
			EXIT FOR
		END IF
		IF a${i} > b${i} THEN
			ret = 1
			EXIT FOR
		END IF
	NEXT
	
	IF ret = 0 THEN
		IF UBOUND(a$) < UBOUND(b$) THEN ret = -1
		IF UBOUND(a$) > UBOUND(b$) THEN ret = 1
	END IF
	
	IF lvs_desc THEN RETURN ret*-1 ELSE RETURN ret
END FUNCTION
'
' ##############################
' #####  WinXGetPlacement  #####
' ##############################
' hWnd = the handle to the window
' minMax = the variable to store the minimised/maximised state
' restored = the variable to store the restored position and size
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXGetPlacement (hWnd, @minMax, RECT restored)
	WINDOWPLACEMENT wp
	
	wp.length = SIZE(WINDOWPLACEMENT)
	IFZ GetWindowPlacement (hWnd, &wp) THEN RETURN $$FALSE
	
	restored = wp.rcNormalPosition
	minMax = wp.showCmd
	
	RETURN $$TRUE
END FUNCTION
'
' ##############################
' #####  WinXSetPlacement  #####
' ##############################
' hWnd = the handle to the window
' minMax = minimised/maximised state, can be null in which case no changes are made
' restored = the restored position and size, can be null in which case not changes are made
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetPlacement (hWnd, minMax, RECT restored)
	WINDOWPLACEMENT wp
	RECT rect
	
	wp.length = SIZE(WINDOWPLACEMENT)
	IFZ GetWindowPlacement (hWnd, &wp) THEN RETURN $$FALSE
	
	IF wp.showCmd THEN wp.showCmd = minMax
	IF (restored.left|restored.right|restored.top|restored.bottom) THEN wp.rcNormalPosition = restored
	
	IFZ SetWindowPlacement (hWnd, &wp) ret = $$FALSE ELSE ret = $$TRUE
	
	GetClientRect (hWnd, &rect)
	sizeWindow (hWnd, rect.right-rect.left, rect.bottom-rect.top)
	
	RETURN ret
END FUNCTION
'
' #############################
' #####  WinXGetMousePos  #####
' #############################
' Gets the mouse position
' hWnd = the handle to the window to get the coordinates relative to, 0 for none
' x = the variable to store the mouse x position
' y = the variable to store the mouse y position
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXGetMousePos (hWnd, @x, @y)
	POINTAPI pt
	
	GetCursorPos (&pt)
	IF hWnd THEN ScreenToClient (hWnd, &pt)
	x = pt.x : y = pt.y
	RETURN $$TRUE
END FUNCTION
'
' #############################
' #####  WinXAddCalendar  #####
' #############################
' Create a new calendar control
' monthsX = the number of months to display in the x direction, returns the width of the control
' monthsY = the number of months to display in the y direction, returns the height of the control
' id = the unique id for this control
' returns the handle to the new control
FUNCTION WinXAddCalendar (hParent, @monthsX, @monthsY, id)
	RECT rect
	
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP
	hWnd = CreateWindowExA (0, &$$MONTHCAL_CLASS, 0, style, 0, 0, 0, 0, hParent, id, GetModuleHandleA (0), 0)
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	
	SendMessageA (hWnd, $$MCM_GETMINREQRECT, 0, &rect)
	
	monthsX = monthsX*(rect.right-rect.left)
	monthsY = monthsY*(rect.bottom-rect.top)
	
	RETURN hWnd
END FUNCTION
'
' #######################################
' #####  WinXCalendar_SetSelection  #####
' #######################################
' Set the selection in a calendar control
' hCal = the handle to the calendard control
' start = the start of the selection range
' end = the end of the selection range
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXCalendar_SetSelection (hCal, SYSTEMTIME time)
	IFZ SendMessageA (hCal, $$MCM_SETCURSEL, 0, &time) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' #######################################
' #####  WinXCalendar_GetSelection  #####
' #######################################
' Get the selection in a calendar control
' hCal = the handle to the calendard control
' start = the variable to store the start of the selection range
' end = the variable to store the end of the selection range
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXCalendar_GetSelection (hCal, SYSTEMTIME time)
	IFZ SendMessageA (hCal, $$MCM_GETCURSEL, 0, &time) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' #####################################
' #####  WinXRegOnCalendarSelect  #####
' #####################################
' Set the onCalendarSelect callback
' hWnd = the handle to the window to set the callback for
' onCalendarSelect = the address of the callback
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnCalendarSelect (hWnd, FUNCADDR onCalendarSelect)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	binding.onCalendarSelect = onCalendarSelect
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ###############################
' #####  WinXAddTimePicker  #####
' ###############################
' Creates a new Date/Time Picker control
' format = the format for the control, should be $$DTS_LONGDATEFORMAT, $$DTS_SHORTDATEFORMAT or $$DTS_TIMEFORMAT
' initialTime = the time to initialise the control TO
' timeValid = $$TRUE if the initialTime parameter is valid
' id = the unique id for this control
' returns the handle to the control or 0 on fail
FUNCTION WinXAddTimePicker (hParent, format, SYSTEMTIME initialTime, timeValid, id)
	style = $$WS_CHILD|$$WS_VISIBLE|$$WS_TABSTOP|$$WS_GROUP|format
	hWnd = CreateWindowExA (0, &$$DATETIMEPICK_CLASS, 0, style, 0, 0, 0, 0, hParent, id, GetModuleHandleA (0), 0)
	SendMessageA (hWnd, $$WM_SETFONT, GetStockObject ($$DEFAULT_GUI_FONT), $$FALSE)
	
	IF timeValid THEN
		SendMessageA (hWnd, $$DTM_SETSYSTEMTIME, $$GDT_VALID, &initialTime)
	ELSE
		SendMessageA (hWnd, $$DTM_SETSYSTEMTIME, $$GDT_NONE, 0)
	END IF
	
	RETURN hWnd
END FUNCTION
'
' ####################################
' #####  WinXTimePicker_SetTime  #####
' ####################################
' Sets the time for a Date/Time Picker control
' hDTP = the handle to the control
' time = the time to set the control to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTimePicker_SetTime (hDTP, SYSTEMTIME time, timeValid)
	IF timeValid THEN
		SendMessageA (hDTP, $$DTM_SETSYSTEMTIME, $$GDT_VALID, &time)
	ELSE
		SendMessageA (hDTP, $$DTM_SETSYSTEMTIME, $$GDT_NONE, 0)
	END IF
END FUNCTION
'
' #####################################
' #####  WinXTimePicker_GetTime  #####
' #####################################
' Gets the time from a Date/Time Picker control
' hDTP = the handle to the control
' time = the structure to store the time
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTimePicker_GetTime (hDTP, SYSTEMTIME time, @timeValid)
	SELECT CASE SendMessageA (hDTP, $$DTM_GETSYSTEMTIME, 0, &time)
		CASE $$GDT_VALID
			timeValid = $$TRUE
		CASE $$GDT_NONE
			timeValid = $$FALSE
	END SELECT
	
	RETURN $$TRUE
END FUNCTION
'
' #########################
' #####  WinXSetFont  #####
' #########################
' Sets the font for a control
' hCtrl = the handle to the control
' hFont = the handle to the font
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetFont (hCtrl, hFont)
	SendMessageA (hCtrl, $$WM_SETFONT, hFont, $$TRUE)
	RETURN $$TRUE
END FUNCTION
'
' ##############################
' #####  WinXClip_IsImage  #####
' ##############################
' Checks to see if the clipboard contains an image
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClip_IsImage ()
	IFZ IsClipboardFormatAvailable ($$CF_DIB) THEN RETURN $$FALSE ELSE RETURN $$TRUE
END FUNCTION
'
' ###############################
' #####  WinXClip_GetImage  #####
' ###############################
' Get an image from the clipboard
' Returns the handle to the bitmap or 0 on error
FUNCTION WinXClip_GetImage ()
	BITMAPINFOHEADER bmi
	
	IFZ OpenClipboard (0) THEN RETURN $$FALSE
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
' Copy an image to the clipboad
' hImage = the handle to the image to add to the clipboard
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClip_PutImage (hImage)
	SHARED hClipMem
	BITMAPINFOHEADER bmi
	DIBSECTION ds
	
	IFZ hImage THEN RETURN $$FALSE
	IFZ GetObjectA (hImage, SIZE(DIBSECTION), &bmp) THEN RETURN $$FALSE
	
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
	
	RETURN $$TRUE
END FUNCTION
'
' ################################
' #####  WinXRegOnDropFiles  #####
' ################################
' Registers the onDropFiles callback for a window
' hWnd = the window to register the callback for
' onDropFiles = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnDropFiles (hWnd, FUNCADDR onDropFiles)
	BINDING	binding
	
	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF binding_get (idBinding, @binding) THEN RETURN $$FALSE
	
	DragAcceptFiles (hWnd, $$TRUE)
	binding.onDropFiles = onDropFiles
	binding_update (idBinding, binding)
	RETURN $$TRUE
END FUNCTION
'
' ####################################
' #####  WinXDraw_GetFontHeight  #####
' ####################################
'
'
'
FUNCTION WinXDraw_GetFontHeight (hFont, @ascent, @descenct)
	TEXTMETRIC tm
	hDC = CreateCompatibleDC (0)
	SelectObject (hDC, hFont)
	GetTextMetricsA (hDC, &tm)
	DeleteDC (hDC)
	
	ascent = tm.ascent
	descent = tm.descent
	RETURN tm.height
END FUNCTION

DefineAccess(SPLITTERINFO)
DefineAccess(LINKEDLIST)
DefineAccess(AUTODRAWRECORD)
END PROGRAM