PROGRAM	"WinX"
VERSION "0.6.0.14"
'
' WinX - *The* GUI library for XBlite
' Copyright © LGPL Callum Lowcay 2007-2009.
'
' ***** Description *****
' The WinX GUI library is distributed under the
' terms and conditions of the GNU LGPL, see the file COPYING_LIB
' which should be included in the WinX distribution.
'
' ***** Versions *****
' Contributors:
'     Callum Lowcay (original version 0.6.0.1)
'     Guy Lonne (evolutions)
'
' 0.6.0.2-Guy-10sep08-added hideReadOnly argument to WinXDialog_OpenFile$.
'         Guy-28oct09-REVERTED to show again the check box "Read Only"
'         to allow to open "Read Only" (no lock) the selected file(s).
'
' 0.6.0.3-Guy-10nov08-corrected function WinXListBox_GetSelection,
' - replaced wMsg by $$LB_GETSELITEMS since wMsg was not set and would be zero.
'
' 0.6.0.4-Guy-10sep08-added the new functions
' - WinXVersion$: retrieve WinX's current version
'
' Standard Windows directory picker dialog
' - WinXDialog_OpenDir$: standard Windows directory picker dialog
' - WinXFolder_GetDir$ : get the directory path for a Windows special folder
'
' List view with check boxes
' - WinXListView_AddCheckBoxes : add the check boxes to a list view
' - WinXListView_SetCheckState : set the item's check state of a list view with check boxes
' - WinXListView_GetCheckState : determine whether an item in a list view control is checked
' - WinXListView_RemoveCheckBox: remove the check box
'
' Tree view with check boxes
' - WinXTreeView_AddCheckBoxes : add the check boxes to a tree view
' - WinXTreeView_SetCheckState : set the item's check state of a tree view with check boxes
' - WinXTreeView_GetCheckState : determine whether a node in a tree view control is checked
' - WinXTreeView_RemoveCheckBox: remove the check box
' - WinXTreeView_GetRootItem   : get the handle of the tree view root
' - WinXTreeView_FindItemLabel : find an exact string in tree labels
' - WinXTreeView_DeleteAllItems: clear the tree view
' - WinXTreeView_ExpandItem    : expand a tree view item (Guy-26jan09)
' - WinXTreeView_CollapseItem  : collapse a tree view item
'
' Guy-06dec08-corrected function WinXAddStatusBar to return the status bar's handle.
'
' 0.6.0.5-Guy-9dec08-added the new functions
' - WinXDialog_SysInfo       : run Microsoft program "System Information"
' - WinXCleanUp              : optional cleanup
'
' 0.6.0.6-Guy-21jan09-added handling of several accelerator tables.
' - WinXAddAcceleratorTable  : create an accelerator table
' - WinXAttachAccelerators   : attach an accelerator table to a window
'
' 0.6.0.7-Guy-21jan09-added accelerators processing.
' - changed WinXDoEvents to handle several accelerator tables.
' - removed argument from WinXDoEvents ()
' - created a version without m4-preprocessing for the static build.
'
' 0.6.0.8-Guy-08mar09-removed functions that did not belong to WinX.
'
' 0.6.0.9-Guy-27mar09-added error-checking to function WinXStatus_SetText.
'         Guy-15apr09-changed WinXListBox_GetSelection.
'
' 0.6.0.10-Guy-20apr09-must add style $$LBS_NOTIFY to get the notification code $$LBN_SELCHANGE:
'                     $$LBS_NOTIFY enables $$WM_COMMAND's notification code = $$LBN_SELCHANGE.
'          Guy-14sep09-both the tab and parent controls must have the $$WS_CLIPSIBLINGS window style.
'
' 0.6.0.11-Guy-29oct09-added the new argument readOnly to function WinXDialog_OpenFile$:
'                      readOnly = $$TRUE to allow to open "Read Only" (no lock) the selected file(s)
'                      (shows the check box "Read Only" and checks it initially).
'          Guy-09mar10-modified WinXDialog_SysInfo for Widowsn 7.
' 0.6.0.12-Guy-03sep10-corrected function WinXSetStyle.
' 0.6.0.13-Guy-04may11-added new functions.
' 0.6.0.14-Guy-25may11-added Most Recently Used file list and freeze/use .onSelect
'          Guy-06feb12-added new functions WinXGetMinSize, WinXSetFontAndRedraw, WinXGetWindowEffRect
'          Guy-18mar12-added $$ES_READONLY handling in WinXSetStyle
'
' Win32API DLL headers
'
	IMPORT "kernel32"   ' operating system
	IMPORT "gdi32"      ' Graphic Device Interface
	IMPORT "shell32"    ' interface to the operating system
	IMPORT "user32"     ' Windows management
	IMPORT "advapi32"   ' advanced API: security, services, registry ...
	IMPORT "comctl32"   ' common controls; ==> initialize w/ InitCommonControlsEx ()
	IMPORT "comdlg32"   ' standard dialog boxes (opening and saving files ...)
'
	IMPORT "msimg32"
'
' Xblite DLL headers
'
	IMPORT "xst"        ' xblite Standard Library
	IMPORT "xsx"        ' xblite Extended Standard Library
'	IMPORT "xio"        ' console
	IMPORT "xma"        ' math library (Sin/Asin/Sinh/Asinh/Log/Exp/Sqrt...)
	IMPORT "adt"        ' Callum's Abstract Data Types library
'
' the data type to manage bindings
TYPE BINDING
	XLONG .hwnd		'handle to the window this binds to, when 0, this record is not in use
	XLONG .backCol		'window background color
	XLONG .hStatus		'handle to the status bar, if there is one
	XLONG .statusParts		'the number of partitions in the status bar
	XLONG .msgHandlers		'index into an array of arrays of message handlers
	XLONG .minW
	XLONG .minH
	XLONG .maxW
	XLONG .maxH
	XLONG .autoDrawInfo		'information for the auto drawer
	XLONG .autoSizerInfo		'information for the auto sizer
	XLONG .hBar		'either a toolbar or a rebar
	XLONG .hToolTips		'each window gets a tooltip control
	DOUBLE .hScrollPageM		'the high level scrolling data
	XLONG .hScrollPageC
	XLONG .hScrollUnit
	DOUBLE .vScrollPageM
	XLONG .vScrollPageC
	XLONG .vScrollUnit
	XLONG .useDialogInterface		'true to enable dialog style keyboard navigation amoung controls
	XLONG .hwndNextClipViewer		'if the FnOnClipChange callback is used, we become a clipboard viewer
	XLONG .hCursor		'custom cursor for this window
	XLONG .isMouseInWindow
	XLONG .hUpdateRegion
	XLONG .hAccelTable		' Guy-21jan09-handle to the window's accelerator table
	XLONG .skipOnSelect		' Guy-25may11-skip/use .onSelect
	XLONG .hwndMDIParent	' parent window of an MDI child

	FUNCADDR .onPaint (XLONG, XLONG)		'hWnd, hdc : paint the window
	FUNCADDR .onDimControls (XLONG, XLONG, XLONG)		'hWnd, w, h : dimension the controls
	FUNCADDR .onCommand (XLONG, XLONG, XLONG)		'idCtr, notifyCode, lParam
	FUNCADDR .onMouseMove (XLONG, XLONG, XLONG)		'hWnd, x, y
	FUNCADDR .onMouseDown (XLONG, XLONG, XLONG, XLONG)		'hWnd, MBT_const, x, y
	FUNCADDR .onMouseUp (XLONG, XLONG, XLONG, XLONG)		'hWnd, MBT_const, x, y
	FUNCADDR .onMouseWheel (XLONG, XLONG, XLONG, XLONG)		'hWnd, delta, x, y
	FUNCADDR .onKeyDown (XLONG, XLONG)		'hWnd, VK
	FUNCADDR .onKeyUp (XLONG, XLONG)		'hWnd, VK
	FUNCADDR .onChar (XLONG, XLONG)		'hWnd, char
	FUNCADDR .onScroll (XLONG, XLONG, XLONG)		'pos, hWnd, direction
	FUNCADDR .onTrackerPos (XLONG, XLONG)		'idCtr, pos
	FUNCADDR .onDrag (XLONG, XLONG, XLONG, XLONG, XLONG)		'idCtr, drag const, item, x, y
	FUNCADDR .onLabelEdit (XLONG, XLONG, XLONG, STRING)		'idCtr, edit const, item, newLabel
	FUNCADDR .onClose (XLONG)		' hWnd
	FUNCADDR .onFocusChange (XLONG, XLONG)		' hWnd, hasFocus
	FUNCADDR .onClipChange ()		' Sent when clipboard changes
	FUNCADDR .onEnterLeave (XLONG, XLONG)		' hWnd, mouseInWindow
	FUNCADDR .onItem (XLONG, XLONG, XLONG)		' idCtr, event, parameter
	FUNCADDR .onColumnClick (XLONG, XLONG)		' idCtr, iColumn
	FUNCADDR .onCalendarSelect (XLONG, SYSTEMTIME)		' idcal, time
	FUNCADDR .onDropFiles (XLONG, XLONG, XLONG, STRING[])		' hWnd, x, y, files
	FUNCADDR .onSelect (XLONG, XLONG, XLONG)		' idCtr, event, parameter

END TYPE
' message handler data type
TYPE HANDLER
	XLONG .code		'when 0, this record is not in use
	FUNCADDR .handler (XLONG, XLONG, XLONG, XLONG)		' hWnd, wMsg, wParam, lParam
END TYPE

' Headers for grouped lists
TYPE AUTOSIZER_LINKEDLIST
	XLONG .inUse
	XLONG .iHead
	XLONG .iTail
	XLONG .direction
END TYPE
' info for the auto sizer
TYPE AUTOSIZERINFO
	XLONG .prevItem
	XLONG .nextItem
	XLONG .hwnd
	XLONG .hSplitter
	DOUBLE .space
	DOUBLE .size
	DOUBLE .x
	DOUBLE .y
	DOUBLE .w
	DOUBLE .h
	XLONG .flags
END TYPE
TYPE SPLITTERINFO
	XLONG .group
	XLONG .id
	XLONG .direction
	XLONG .maxSize

	XLONG .min
	XLONG .max
	XLONG .dock
	XLONG .docked		' 0 if not docked, old position when docked
END TYPE
$$DOCK_DISABLED = 0
$$DOCK_FORWARD = 1
$$DOCK_BACKWARD = 2
' data structures for auto draw
TYPE DRAWRECT
	XLONG .x1
	XLONG .y1
	XLONG .x2
	XLONG .y2
END TYPE
TYPE DRAWRECTCONTROL
	XLONG .x1
	XLONG .y1
	XLONG .x2
	XLONG .y2
	XLONG .xC1
	XLONG .yC1
	XLONG .xC2
	XLONG .yC2
END TYPE
TYPE SIMPLEFILL
	XLONG .x
	XLONG .y
	XLONG .col
END TYPE
TYPE DRAWTEXT
	XLONG .x
	XLONG .y
	XLONG .iString
	XLONG .forColour
	XLONG .backColour
END TYPE
TYPE DRAWIMAGE
	XLONG .x
	XLONG .y
	XLONG .w
	XLONG .h
	XLONG .xSrc
	XLONG .ySrc
	XLONG .hImage
	XLONG .blend
END TYPE
TYPE AUTODRAWRECORD
	XLONG .toDelete
	XLONG .hUpdateRegion
	XLONG .hPen
	XLONG .hBrush
	XLONG .hFont
	FUNCADDR .draw (XLONG, AUTODRAWRECORD, XLONG, XLONG)
	UNION
		DRAWRECT .rect
		DRAWRECTCONTROL .rectControl
		SIMPLEFILL .simpleFill
		DRAWTEXT .text
		DRAWIMAGE .image
	END UNION
END TYPE
TYPE PRINTINFO
	XLONG .hDevMode
	XLONG .hDevNames
	XLONG .rangeMin
	XLONG .rangeMax
	XLONG .marginLeft
	XLONG .marginRight
	XLONG .marginTop
	XLONG .marginBottom
	XLONG .printSetupFlags
	XLONG .continuePrinting
	XLONG .hCancelDlg
END TYPE
$$DLGCANCEL_ST_PAGE = 100

' Data structure for customising toolbars
TYPE TBBUTTONDATA
	XLONG .enabled
	XLONG .optional
	TBBUTTON .tbb
END TYPE
'
' #######################
' #####  M4 macros  #####
' #######################
' Notes:
' - use the compiler switch -m4
m4_include(`accessors.m4')
'
EXPORT

' WinX specific stuff
TYPE WINX_RGBA
	UBYTE .blue
	UBYTE .green
	UBYTE .red
	UBYTE .alpha
END TYPE

' Simplified window styles
$$XWSS_APP = 0x00000000
$$XWSS_APPNORESIZE = 0x00000001
$$XWSS_POPUP = 0x00000002
$$XWSS_POPUPNOTITLE = 0x00000003
$$XWSS_NOBORDER = 0x00000004

' mouse buttons
$$MBT_LEFT = 1
$$MBT_MIDDLE = 2
$$MBT_RIGHT = 3

' font styles
$$FONT_BOLD = 0x00000001
$$FONT_ITALIC = 0x00000002
$$FONT_UNDERLINE = 0x00000004
$$FONT_STRIKEOUT = 0x00000008

' file types
$$FILETYPE_WINBMP = 1

$$SIZER_SIZERELREST = 0x00000001
$$SIZER_XRELRIGHT = 0x00000002
$$SIZER_YRELBOTTOM = 0x00000004
$$SIZER_SERIES = 0x00000008
$$SIZER_WCOMPLEMENT = 0x00000010
$$SIZER_HCOMPLEMENT = 0x00000020
$$SIZER_SPLITTER = 0x00000040

$$CONTROL = 0
$$DIR_VERT = 1
$$DIR_HORIZ = 2
$$DIR_REVERSE = 0x80000000

$$UNIT_LINE = 0
$$UNIT_PAGE = 1
$$UNIT_END = 2

$$DRAG_START = 0
$$DRAG_DRAGGING = 1
$$DRAG_DONE = 2

$$EDIT_START = 0
$$EDIT_DONE = 1

$$CHANNEL_RED = 2
$$CHANNEL_GREEN = 1
$$CHANNEL_BLUE = 0
$$CHANNEL_ALPHA = 3

$$ACL_REG_STANDARD = "D:(A;OICI;GRKRKW;;;WD)(A;OICI;GAKA;;;BA)"

' Most Recently Used
$$MRU_SECTION$     = "Recent files"
$$UPP_MRU          = 19

$$WINX_CLASS$ = "WinX"
$$WINX_SPLITTER_CLASS$ = "WinXSplitterClass"

DECLARE FUNCTION WinX ()
DECLARE FUNCTION WinXNewWindow (hOwner, title$, x, y, w, h, simpleStyle, exStyle, icon, menu)
DECLARE FUNCTION WinXRegOnPaint (hWnd, FUNCADDR FnOnPaint)
DECLARE FUNCTION WinXDisplay (hWnd)
DECLARE FUNCTION WinXDoEvents ()
DECLARE FUNCTION WinXRegMessageHandler (hWnd, wMsg, FUNCADDR FnMsgHandler)
DECLARE FUNCTION WinXRegControlSizer (hWnd, FUNCADDR FnControlSizer)
DECLARE FUNCTION WinXAddButton (parent, title$, hImage, idCtr)
DECLARE FUNCTION WinXSetText (hWnd, text$)
DECLARE FUNCTION WinXGetText$ (hWnd)
DECLARE FUNCTION WinXHide (hWnd)
DECLARE FUNCTION WinXShow (hWnd)
DECLARE FUNCTION WinXAddStatic (parent, title$, hImage, style, idCtr)
DECLARE FUNCTION WinXAddEdit (parent, title$, style, idCtr)
DECLARE FUNCTION WinXAutoSizer_SetInfo (hWnd, series, DOUBLE space, DOUBLE size, DOUBLE x, DOUBLE y, DOUBLE w, DOUBLE h, flags)
DECLARE FUNCTION WinXSetMinSize (hWnd, w, h)
DECLARE FUNCTION WinXGetMinSize (hWnd, @w, @h)
DECLARE FUNCTION WinXRegOnCommand (hWnd, FUNCADDR FnOnCommand)

DECLARE FUNCTION WinXDrawLine (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXClear (hWnd)
DECLARE FUNCTION WinXUpdate (hWnd)
DECLARE FUNCTION WinXDrawFilledEllipse (hWnd, hPen, hBrush, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawFilledRect (hWnd, hPen, hBrush, x1, y1, x2, y2)
DECLARE FUNCTION WinXNewMenu (menu$, firstID, isPopup)
DECLARE FUNCTION WinXMenu_Attach (subMenu, newParent, idCtr)
DECLARE FUNCTION WinXAddStatusBar (hWnd, initialStatus$, idCtr)
DECLARE FUNCTION WinXStatus_SetText (hWnd, part, text$)
DECLARE FUNCTION WinXStatus_GetText$ (hWnd, part)
DECLARE FUNCTION WinXRegOnMouseMove (hWnd, FUNCADDR FnOnMouseMove)
DECLARE FUNCTION WinXRegOnMouseDown (hWnd, FUNCADDR FnOnMouseDown)
DECLARE FUNCTION WinXRegOnMouseWheel (hWnd, FUNCADDR FnOnMouseWheel)
DECLARE FUNCTION WinXRegOnMouseUp (hWnd, FUNCADDR FnOnMouseUp)
DECLARE FUNCTION WinXNewToolbar (wButton, hButton, nButtons, hBmpButtons, hBmpGray, hBmpHot, rgbTrans, toolTips, customisable)
DECLARE FUNCTION WinXToolbar_AddButton (hToolbar, commandId, iImage, tooltipText$, optional, moveable)
DECLARE FUNCTION WinXSetWindowToolbar (hWnd, hToolbar)
DECLARE FUNCTION WinXAddTooltip (hCtr, tip$)
DECLARE FUNCTION WinXGetUseableRect (hWnd, RECT @rect)
DECLARE FUNCTION WinXNewToolbarUsingIls (hilMain, hilGray, hilHot, toolTips, customisable)
DECLARE FUNCTION WinXUndo (hWnd, idCtr)
' new in 0.3
DECLARE FUNCTION WinXRegOnKeyDown (hWnd, FUNCADDR FnOnKeyDown)
DECLARE FUNCTION WinXRegOnKeyUp (hWnd, FUNCADDR FnOnKeyUp)
DECLARE FUNCTION WinXRegOnChar (hWnd, FUNCADDR FnOnChar)
DECLARE FUNCTION WinXIsKeyDown (key)
DECLARE FUNCTION WinXIsMousePressed (button)
DECLARE FUNCTION WinXAddControl (parent, class$, title$, style, exStyle, idCtr)
DECLARE FUNCTION WinXAddListBox (parent, sort, multiSelect, idCtr)
DECLARE FUNCTION WinXAddComboBox (parent, listHeight, canEdit, images, idCtr)
DECLARE FUNCTION WinXListBox_AddItem (hListBox, index, item$)
DECLARE FUNCTION WinXListBox_RemoveItem (hListBox, index)
DECLARE FUNCTION WinXListBox_GetSelection (hListBox, @index[])
DECLARE FUNCTION WinXListBox_GetIndex (hListBox, item$)
DECLARE FUNCTION WinXListBox_SetSelection (hListBox, index[])

DECLARE FUNCTION WinXDialog_OpenFile$ (parent, title$, extensions$, initialName$, multiSelect, readOnly)		' display an OpenFile dialog box
DECLARE FUNCTION WinXDialog_SaveFile$ (parent, title$, extensions$, initialName$, overwritePrompt)		' display a SaveFile dialog box

DECLARE FUNCTION WinXListBox_GetItem$ (hListBox, index)
DECLARE FUNCTION WinXComboBox_AddItem (hCombo, index, indent, item$, iImage, iSelImage)
DECLARE FUNCTION WinXComboBox_RemoveItem (hCombo, index)
DECLARE FUNCTION WinXComboBox_GetSelection (hCombo)
DECLARE FUNCTION WinXComboBox_SetSelection (hCombo, index)
DECLARE FUNCTION WinXComboBox_GetItem$ (hCombo, index)
DECLARE FUNCTION WinXNewAutoSizerSeries (direction)
' new in 0.4
DECLARE FUNCTION WinXAddCheckButton (parent, title$, isFirst, pushlike, idCtr)
DECLARE FUNCTION WinXAddRadioButton (parent, title$, isFirst, pushlike, idCtr)
DECLARE FUNCTION WinXButton_SetCheck (hButton, checked)
DECLARE FUNCTION WinXButton_GetCheck (hButton)
DECLARE FUNCTION WinXAddTreeView (parent, hImages, editable, draggable, idCtr)
DECLARE FUNCTION WinXAddProgressBar (parent, smooth, idCtr)
DECLARE FUNCTION WinXAddTrackBar (parent, enableSelection, posToolTip, idCtr)
DECLARE FUNCTION WinXAddTabs (parent, multiline, idCtr)
DECLARE FUNCTION WinXAddAnimation (parent, file$, idCtr)
DECLARE FUNCTION WinXRegOnDrag (hWnd, FUNCADDR FnOnDrag)
DECLARE FUNCTION WinXListBox_EnableDragging (hListBox)
DECLARE FUNCTION WinXAutoSizer_GetMainSeries (hWnd)
DECLARE FUNCTION WinXDialog_Error (msg$, title$, severity)
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
DECLARE FUNCTION WinXEnableDialogInterface (hWnd, enable)
DECLARE FUNCTION WinXAni_Play (hAni)
DECLARE FUNCTION WinXAni_Stop (hAni)
DECLARE FUNCTION WinXListBox_SetCaret (hListBox, item)
DECLARE FUNCTION WinXSetStyle (hWnd, add, addEx, sub, subEx)
DECLARE FUNCTION WinXTreeView_AddItem (hTV, hParent, hInsertAfter, iImage, iImageSelect, item$)
DECLARE FUNCTION WinXTreeView_GetNextItem (hTV, hItem)
DECLARE FUNCTION WinXTreeView_GetChildItem (hTV, hItem)
DECLARE FUNCTION WinXTreeView_GetParentItem (hTV, hItem)
DECLARE FUNCTION WinXTreeView_GetPreviousItem (hTV, hItem)
DECLARE FUNCTION WinXTreeView_DeleteItem (hTV, hItem)
DECLARE FUNCTION WinXTreeView_GetSelection (hTV)
DECLARE FUNCTION WinXTreeView_SetSelection (hTV, hItem)
DECLARE FUNCTION WinXTreeView_GetItemLabel$ (hTV, hItem)
DECLARE FUNCTION WinXTreeView_SetItemLabel (hTV, hItem, label$)
DECLARE FUNCTION WinXRegOnLabelEdit (hWnd, FUNCADDR FnOnLabelEdit)
DECLARE FUNCTION WinXTreeView_CopyItem (hTV, hParentItem, hItemInsertAfter, hItem)
DECLARE FUNCTION WinXTabs_AddTab (hTabs, label$, index)
DECLARE FUNCTION WinXTabs_DeleteTab (hTabs, iTab)
DECLARE FUNCTION WinXTabs_GetAutosizerSeries (hTabs, iTab)
DECLARE FUNCTION WinXTabs_GetCurrentTab (hTabs)
DECLARE FUNCTION WinXTabs_SetCurrentTab (hTabs, iTab)
DECLARE FUNCTION WinXToolbar_AddToggleButton (hToolbar, commandId, iImage, tooltipText$, mutex, optional, moveable)
DECLARE FUNCTION WinXToolbar_AddSeparator (hToolbar)
DECLARE FUNCTION WinXToolbar_AddControl (hToolbar, hCtr, w)
DECLARE FUNCTION WinXToolbar_EnableButton (hToolbar, iButton, enable)
DECLARE FUNCTION WinXToolbar_ToggleButton (hToolbar, iButton, on)
' 0.4.1
DECLARE FUNCTION WinXComboBox_GetEditText$ (hCombo)
DECLARE FUNCTION WinXComboBox_SetEditText (hCombo, text$)
DECLARE FUNCTION WinXAddGroupBox (parent, label$, idCtr)
DECLARE FUNCTION WinXGroupBox_GetAutosizerSeries (hGB)
' new in 0.4.2
DECLARE FUNCTION WinXDrawEllipse (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawRect (hWnd, hPen, x1, y1, x2, y2)
DECLARE FUNCTION WinXDrawBezier (hWnd, hPen, x1, y1, x2, y2, xC1, yC1, xC2, yC2)
DECLARE FUNCTION WinXDrawArc (hWnd, hPen, x1, y1, x2, y2, DOUBLE theta1, DOUBLE theta2)
DECLARE FUNCTION WinXDrawFilledArea (hWnd, hBrush, colBound, x, y)
DECLARE FUNCTION WinXRegOnClose (hWnd, FUNCADDR FnOnClose)
DECLARE FUNCTION WinXAutoSizer_SetSimpleInfo (hWnd, series, DOUBLE space, DOUBLE size, flags)
DECLARE FUNCTION WinXAddListView (parent, hilLargeIcons, hilSmallIcons, editable, view, idCtr)
DECLARE FUNCTION WinXListView_SetView (hLV, view)
DECLARE FUNCTION WinXListView_AddColumn (hLV, iColumn, wColumn, label$, iSubItem)
DECLARE FUNCTION WinXListView_DeleteColumn (hLV, iColumn)
DECLARE FUNCTION WinXListView_AddItem (hLV, iItem, item$, iIcon)
DECLARE FUNCTION WinXListView_DeleteItem (hLV, iItem)
DECLARE FUNCTION WinXListView_GetSelection (hLV, @iItems[])
DECLARE FUNCTION WinXListView_SetSelection (hLV, iItems[])
DECLARE FUNCTION WinXListView_SetItemText (hLV, iItem, iSubItem, newText$)
' new in 0.5
DECLARE FUNCTION LOGFONT WinXDraw_MakeLogFont (font$, height, style)
DECLARE FUNCTION WinXDraw_GetFontDialog (parent, LOGFONT @logFont, @color)		' display the get font dialog box
DECLARE FUNCTION WinXDraw_GetTextWidth (hFont, text$, maxWidth)
DECLARE FUNCTION DOUBLE WinXDraw_PixelsPerPoint ()
DECLARE FUNCTION WinXDrawText (hWnd, hFont, text$, x, y, backCol, forCol)
DECLARE FUNCTION WinXDraw_GetColour (parent, initialColour)
DECLARE FUNCTION WinXDraw_CreateImage (w, h)
DECLARE FUNCTION WinXDraw_LoadImage (fileName$, fileType)
DECLARE FUNCTION WinXDraw_DeleteImage (hImage)
DECLARE FUNCTION WinXDraw_Snapshot (hWnd, x, y, hImage)
DECLARE FUNCTION WinXDraw_SaveImage (hImage, fileName$, fileType)
DECLARE FUNCTION WinXDraw_ResizeImage (hImage, w, h)
DECLARE FUNCTION WinXDraw_SetImagePixel (hImage, x, y, color)
DECLARE FUNCTION WINX_RGBA WinXDraw_GetImagePixel (hImage, x, y)
DECLARE FUNCTION WinXDraw_SetConstantAlpha (hImage, DOUBLE alpha)
DECLARE FUNCTION WinXDraw_SetImageChannel (hImage, channel, UBYTE @data[])
DECLARE FUNCTION WinXDraw_GetImageChannel (hImage, channel, UBYTE @data[])
DECLARE FUNCTION WinXDraw_GetImageInfo (hImage, @w, @h, @pBits)
DECLARE FUNCTION WinXDraw_CopyImage (hImage)
DECLARE FUNCTION WinXDraw_PremultiplyImage (hImage)
DECLARE FUNCTION WinXDrawImage (hWnd, hImage, x, y, w, h, xSrc, ySrc, blend)
DECLARE FUNCTION WinXPrint_Start (minPage, maxPage, @rangeMin, @rangeMax, @cxPhys, @cyPhys, fileName$, showDialog, parent)
DECLARE FUNCTION DOUBLE WinXPrint_LogUnitsPerPoint (hPrinter, cyLog, cyPhys)
DECLARE FUNCTION WinXPrint_DevUnitsPerInch (hPrinter, @w, @h)
DECLARE FUNCTION WinXPrint_PageSetup (parent)
DECLARE FUNCTION WinXPrint_Page (hPrinter, hWnd, x, y, cxLog, cyLog, cxPhys, cyPhys, pageNum, pageCount)
DECLARE FUNCTION WinXPrint_Done (hPrinter)
' new in 0.6
DECLARE FUNCTION WinXNewChildWindow (hParent, title$, style, exStyle, idCtr)
DECLARE FUNCTION WinXRegOnFocusChange (hWnd, FUNCADDR FnOnFocusChange)
DECLARE FUNCTION WinXSetWindowColour (hWnd, color)
DECLARE FUNCTION WinXListView_GetItemText (hLV, iItem, uppSubItem, @text$[])
DECLARE FUNCTION WinXDialog_Message (hWnd, text$, title$, icon$, hMod)
DECLARE FUNCTION WinXDialog_Question (hWnd, text$, title$, cancel, defaultButton)
DECLARE FUNCTION WinXSplitter_SetProperties (series, hCtr, min, max, dock)
DECLARE FUNCTION WinXRegistry_ReadInt (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result)
DECLARE FUNCTION WinXRegistry_ReadString (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
DECLARE FUNCTION WinXRegistry_ReadBin (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
DECLARE FUNCTION WinXRegistry_WriteInt (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, int)
DECLARE FUNCTION WinXRegistry_WriteString (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, buffer$)
DECLARE FUNCTION WinXRegistry_WriteBin (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, buffer$)
DECLARE FUNCTION WinXAddAccelerator (ACCEL @accel[], cmd, key, control, alt, shift)
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
DECLARE FUNCTION WinXListView_GetItemFromPoint (hLV, x, y)
DECLARE FUNCTION WinXListView_Sort (hLV, iCol, desc)
DECLARE FUNCTION WinXTreeView_GetItemFromPoint (hTV, x, y)
DECLARE FUNCTION WinXGetPlacement (hWnd, @minMax, RECT @restored)
DECLARE FUNCTION WinXSetPlacement (hWnd, minMax, RECT restored)
DECLARE FUNCTION WinXGetMousePos (hWnd, @x, @y)
DECLARE FUNCTION WinXAddCalendar (hParent, @monthsX, @monthsY, idCtr)
DECLARE FUNCTION WinXCalendar_SetSelection (hCal, SYSTEMTIME time)
DECLARE FUNCTION WinXCalendar_GetSelection (hCal, SYSTEMTIME @time)
DECLARE FUNCTION WinXRegOnCalendarSelect (hWnd, FUNCADDR FnOnCalendarSelect)
DECLARE FUNCTION WinXAddTimePicker (hParent, format, SYSTEMTIME initialTime, timeValid, idCtr)
DECLARE FUNCTION WinXTimePicker_SetTime (hDTP, SYSTEMTIME time, timeValid)
DECLARE FUNCTION WinXTimePicker_GetTime (hDTP, SYSTEMTIME @time, @timeValid)
DECLARE FUNCTION WinXSetFont (hCtr, hFont)
DECLARE FUNCTION WinXSetFontAndRedraw (hCtr, hFont)
DECLARE FUNCTION WinXClip_IsImage ()
DECLARE FUNCTION WinXClip_GetImage ()
DECLARE FUNCTION WinXClip_PutImage (hImage)
DECLARE FUNCTION WinXRegOnDropFiles (hWnd, FUNCADDR FnOnDrag)
DECLARE FUNCTION WinXDraw_GetFontHeight (hFont, @ascent, @descenct)
' new in 0.6.0.3
DECLARE FUNCTION WinXListView_AddCheckBoxes (hLV)		' add the check boxes to a list view
DECLARE FUNCTION WinXListView_SetCheckState (hLV, iItem, checked)		' set the item's check state of a list view with check boxes
DECLARE FUNCTION WinXListView_GetCheckState (hLV, iItem)		' determine whether an item in a list view control is checked
DECLARE FUNCTION WinXListView_RemoveCheckBox (hLV, iItem)		' removes the check box of a list view item

DECLARE FUNCTION WinXTreeView_AddCheckBoxes (hTV)		' add the check boxes to a tree view
DECLARE FUNCTION WinXTreeView_SetCheckState (hTV, hItem, checked)		' set the item's check state of a tree view with check boxes
DECLARE FUNCTION WinXTreeView_GetCheckState (hTV, hItem)		' determine whether a node in a tree view control is checked
DECLARE FUNCTION WinXTreeView_RemoveCheckBox (hTV, hItem)		' remove the check box of a tree view item

DECLARE FUNCTION WinXTreeView_GetRootItem (hTV)		' get the handle of the tree view root
DECLARE FUNCTION WinXTreeView_FindItemLabel (hTV, find$)		' find an exact string in tree labels
DECLARE FUNCTION WinXTreeView_FindItem (hTV, hItem, find$)		' Search for a label in tree view nodes
DECLARE FUNCTION WinXTreeView_DeleteAllItems (hTV)		' clear the tree view
DECLARE FUNCTION WinXTreeView_ExpandItem (hTV, hItem)		' expand the tree view item
DECLARE FUNCTION WinXTreeView_CollapseItem (hTV, hItem)		' collapse the tree view item
' new in 0.6.0.4
DECLARE FUNCTION WinXDialog_OpenDir$ (parent, title$, initDirIDL)		' standard Windows directory picker dialog
DECLARE FUNCTION WinXFolder_GetDir$ (nFolder)		' get the path for a Windows special folder
DECLARE FUNCTION WinXVersion$ ()		' get WinX's current version

' new in 0.6.0.5
DECLARE FUNCTION WinXDialog_SysInfo (@msInfo$)		' run Microsoft program "System Information"
DECLARE FUNCTION WinXCleanUp ()		' optional cleanup

' new in 0.6.0.6
DECLARE FUNCTION WinXAddAcceleratorTable (ACCEL @accel[])		' create an accelerator table
DECLARE FUNCTION WinXAttachAccelerators (hWnd, hAccel)		' attach an accelerator table to a window

' new in 0.6.0.13
DECLARE FUNCTION WinXSetDefaultFont (hCtr)		' use the default GUI font
DECLARE FUNCTION WinXRegOnSelect (hWnd, FUNCADDR FnOnSelect)
DECLARE FUNCTION WinXListView_DeleteAllItems (hLV)
DECLARE FUNCTION WinXListView_SetItemFocus (hLV, iItem, iSubItem)		' set the focus on item
DECLARE FUNCTION WinXListView_GetHeaderHeight (hLV)
DECLARE FUNCTION WinXListView_ShowItemByIndex (hLV, iItem, iSubItem)
DECLARE FUNCTION WinXListView_SetTopItemByIndex (hLV, iItem, iSubItem)
DECLARE FUNCTION WinXListView_SetAllSelected (hLV)
DECLARE FUNCTION WinXListView_SetAllUnselected (hLV)
DECLARE FUNCTION WinXListView_SetAllChecked (hLV)
DECLARE FUNCTION WinXListView_SetAllUnchecked (hLV)
DECLARE FUNCTION WinXListView_FreezeOnSelect (hLV)
DECLARE FUNCTION WinXListView_UseOnSelect (hLV)

DECLARE FUNCTION WinXTreeView_FreezeOnSelect (hTV)
DECLARE FUNCTION WinXTreeView_UseOnSelect (hTV)

DECLARE FUNCTION WinXDir_AppendSlash (@dir$) ' end directory path dir$ with $$PathSlash$
DECLARE FUNCTION WinXDir_Create (dir$) ' create directory dir$
DECLARE FUNCTION WinXDir_Exists (dir$) ' determine if directory dir$ exists
DECLARE FUNCTION WinXPath_Trim$ (path$) ' trim file path path$
DECLARE FUNCTION WinXDir_GetXblDir$ () ' get xblite's dir
DECLARE FUNCTION WinXDir_GetXblProgramDir$ () ' get xblite's program dir

DECLARE FUNCTION WinXIni_Delete (iniPath$, section$, key$) ' delete information from an INI file
DECLARE FUNCTION WinXIni_Read$ (iniPath$, section$, key$, defVal$) ' read data from INI file
DECLARE FUNCTION WinXIni_Write (iniPath$, section$, key$, value$) ' write in the INI file
DECLARE FUNCTION WinXIni_LoadSectionList (iniPath$, @section$[]) ' load all section names
DECLARE FUNCTION WinXIni_LoadKeyList (iniPath$, section$, @key$[]) ' load all key names of a given section
DECLARE FUNCTION WinXIni_DeleteSection (iniPath$, section$) ' delete section from .INI file

DECLARE FUNCTION WinXMRU_LoadListFromIni (iniPath$, pathNew$, @mruList$[]) ' load the Most Recently Used file list from the .INI file
DECLARE FUNCTION WinXMRU_SaveListToIni (iniPath$, pathNew$, @mruList$[]) ' save the Most Recently Used file list into the .INI file
DECLARE FUNCTION WinXMRU_MakeKey$ (id)

DECLARE FUNCTION WinXAddSpinner (parent, hBuddy, buddy_x, buddy_y, buddy_w, buddy_h, uppVal, lowVal, curVal, idCtr) ' add spinner control
DECLARE FUNCTION WinXDate_GetCurrentTimeStamp$ () ' compute a (date & time) stamp
DECLARE FUNCTION WinXUser_GetName$ () ' retrieve the UserName with which the User is logged into the network

DECLARE FUNCTION WinXKillFont (@hFont) ' release a font created by WinXNewFont
DECLARE FUNCTION WinXNewFont (fontName$, pointSize, weight, italic, underline, strikeOut) ' create a new logical font
DECLARE FUNCTION WinXGetWindowEffRect (hWnd, RECT @rect) ' get the window's effective rectangle

END EXPORT


DECLARE FUNCTION ApiLBItemFromPt (hLB, x, y, bAutoScroll)
DECLARE FUNCTION ApiAlphaBlend (hdcDest, nXOriginDest, nYOrigDest, nWidthDest, nHeightDest, hdcSrc, nXOriginSrc, nYOriginSrc, nWidthSrc, nHeightSrc, BLENDFUNCTION blendFunction)

DECLARE FUNCTION mainWndProc (hWnd, wMsg, wParam, lParam)
DECLARE FUNCTION onNotify (hWnd, wParam, lParam, BINDING binding)
DECLARE FUNCTION splitterProc (hWnd, wMsg, wParam, lParam)
DECLARE FUNCTION sizeWindow (hWnd, w, h)
DECLARE FUNCTION autoSizer (AUTOSIZERINFO autoSizerBlock, direction, x0, y0, w, h, currPos)
DECLARE FUNCTION XWSStoWS (xwss)

' callbacks for internal dialogs
DECLARE FUNCTION cancelDlgOnClose (hWnd)
DECLARE FUNCTION cancelDlgOnCommand (idCtr, code, hWnd)
DECLARE FUNCTION printAbortProc (hdc, nCode)

DECLARE FUNCTION HANDLER_Init ()
DECLARE FUNCTION HANDLER_New ()
DECLARE FUNCTION HANDLER_Delete (group)

DECLARE FUNCTION HANDLER_AddItem (group, HANDLER handler)
DECLARE FUNCTION HANDLER_GetItem (group, index, HANDLER @handler)
DECLARE FUNCTION HANDLER_FindItemCode (group, find)

DECLARE FUNCTION HANDLER_CallItem (group, @ret, hWnd, wMsg, wParam, lParam)

DECLARE FUNCTION AUTOSIZER_LinkedList_Init ()
DECLARE FUNCTION AUTOSIZER_LinkedList_New (direction)
DECLARE FUNCTION AUTOSIZER_LinkedList_Get (group, idCtr, AUTOSIZERINFO @autoSizerBlock)
DECLARE FUNCTION AUTOSIZER_LinkedList_Update (group, idCtr, AUTOSIZERINFO autoSizerBlock)
DECLARE FUNCTION AUTOSIZER_LinkedList_Delete (group)

DECLARE FUNCTION autoSizerInfo_AddGroup (group, AUTOSIZERINFO autoSizerBlock)
DECLARE FUNCTION autoSizerBlock_Delete (group, idCtr)
DECLARE FUNCTION autoSizerInfo_sizeGroup (group, x0, y0, w, h)
DECLARE FUNCTION autoSizerInfo_showGroup (group, visible)
DECLARE FUNCTION autoDraw_clear (group)
DECLARE FUNCTION autoDraw_draw (hdc, group, x0, y0)
DECLARE FUNCTION autoDraw_add (iList, iRecord)
DECLARE FUNCTION initPrintInfo ()

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

DECLARE FUNCTION TellDialogError (parent, title$)		' display WinXDialog_'s run-time error message
DECLARE FUNCTION CreateMdiChild (hClient, title$)

DECLARE FUNCTION LOCK_Get_id_hCtr (hCtr)
DECLARE FUNCTION LOCK_Get_skipOnSelect (id)
DECLARE FUNCTION LOCK_Set_skipOnSelect (id, bSkip)

DECLARE FUNCTION BINDING_Ov_Delete (id)
'
' #######################
' #####  M4 macros  #####
' #######################
'
' These functions abstract away access to the arrays
DeclareAccess(BINDING)
DeclareAccess(SPLITTERINFO)
DeclareAccess(LINKEDLIST)
DeclareAccess(AUTODRAWRECORD)
'
$$LeftSubSizer$  = "WinXLeftSubSizer"
$$RightSubSizer$ = "WinXRightSubSizer"
'
'
' #####################
' #####  WinX ()  #####
' #####################
' [WinX]
' Description = Initialise the WinX library
' Function    = WinX ()
' ArgCount    = 0
' Return      = $$FALSE on success, else $$TRUE on fail.
' Remarks     = Sometimes this gets called automatically.  If your program crashes as soon as you call WinXNewWindow then WinX has not been initialised properly.
' See Also    =
' Examples    = IFF WinX () THEN QUIT(0)
'
FUNCTION WinX ()
	SHARED TBBUTTONDATA g_tbbd[]		' info for toolbar customisation
	SHARED g_tbbdUM[]

	INITCOMMONCONTROLSEX iccex
	WNDCLASS wc

	IF #bReentry THEN RETURN		' success: already initialized!

	' in prevision of a static build
	Xst ()		' initialize Xblite Standard Library
	Xsx ()		' initialize Xblite Standard eXtended Library

	ADT ()		' initialize the Abstract Data Types Library

	' initialize the specific common controls classes from the common
	' control dynamic-link library
	iccex.dwSize = SIZE (INITCOMMONCONTROLSEX)

	' $$ICC_ANIMATE_CLASS      : animate
	' $$ICC_BAR_CLASSES        : toolbar, statusbar, trackbar, tooltips
	' $$ICC_COOL_CLASSES       : rebar (coolbar) control
	' $$ICC_DATE_CLASSES       : month picker, date picker, time picker, updown
	' $$ICC_HOTKEY_CLASS       : hotkey
	' $$ICC_INTERNET_CLASSES   : WIN32_IE >= 0x0400
	' $$ICC_LISTVIEW_CLASSES   : list view, header
	' $$ICC_PAGESCROLLER_CLASS : page scroller (WIN32_IE >= 0x0400)
	' $$ICC_PROGRESS_CLASS     : progress
	' $$ICC_TAB_CLASSES        : tab, tooltips
	' $$ICC_TREEVIEW_CLASSES   : tree view, tooltips
	' $$ICC_UPDOWN_CLASS       : updown
	' $$ICC_USEREX_CLASSES     : comboex
	' $$ICC_WIN95_CLASSES      : everything else

	iccex.dwICC = $$ICC_ANIMATE_CLASS | $$ICC_BAR_CLASSES | $$ICC_COOL_CLASSES | $$ICC_DATE_CLASSES | _
	  $$ICC_HOTKEY_CLASS | $$ICC_INTERNET_CLASSES | $$ICC_LISTVIEW_CLASSES | $$ICC_NATIVEFNTCTL_CLASS | _
	  $$ICC_PAGESCROLLER_CLASS | $$ICC_PROGRESS_CLASS | $$ICC_TAB_CLASSES | $$ICC_TREEVIEW_CLASSES | _
	  $$ICC_UPDOWN_CLASS | $$ICC_USEREX_CLASSES | $$ICC_WIN95_CLASSES

	' Guy-04mar09-IFF InitCommonControlsEx (&iccex) THEN RETURN $$TRUE ' fail
	InitCommonControlsEx (&iccex) ' Guy-04mar09-don't care!

	BINDING_Init ()
	HANDLER_Init ()

	AUTOSIZER_LinkedList_Init ()

	DIM g_tbbd[0]
	DIM g_tbbdUM[0]

	STRING_Init ()
	SPLITTERINFO_Init ()
	LINKEDLIST_Init ()
	AUTODRAWRECORD_Init ()

	initPrintInfo ()

	' set hIcon with WinX's application icon
	st$ = "WinX.dll"
	hLib = LoadLibraryA (&st$)
	IFZ hLib THEN
		hWinXIcon = 0
	ELSE
		st$ = "WinXIcon"
		hWinXIcon = LoadIconA (hLib, &st$)
		FreeLibrary (hLib)
	ENDIF

	' register WinX main window class
	wc.style = $$CS_PARENTDC
	wc.lpfnWndProc = &mainWndProc ()
	wc.cbWndExtra = 4
	wc.hInstance = GetModuleHandleA (0)
	wc.hIcon = hWinXIcon
	wc.hCursor = LoadCursorA (0, $$IDC_ARROW)
	wc.hbrBackground = $$COLOR_BTNFACE + 1

	' gl-09feb12-generate WinX's main window class
	XstGetLocalDateAndTime (@year, @month, @day, @weekDay, @hour, @minute, @second, @nanos) ' get today's date

	DIM arr[4]
	arr[0] = second
	arr[1] = minute
	arr[2] = hour
	arr[3] = day
	arr[4] = month

	stamp$ = $$WINX_CLASS$
	FOR i = 0 TO 4
		IF arr[i] < 10 THEN stamp$ = stamp$ + "0"
		stamp$ = stamp$ + STRING$ (arr[i])
	NEXT i

	#WinXclass$ = stamp$
	wc.lpszClassName = &#WinXclass$

	ret = RegisterClassA (&wc)
	IFZ ret THEN RETURN $$TRUE		' fail

	' register WinX splitter class
	wc.style = $$CS_PARENTDC
	wc.lpfnWndProc = &splitterProc ()
	wc.cbWndExtra = 4
	wc.hInstance = GetModuleHandleA (0)
	wc.hIcon = 0
	wc.hCursor = 0
	wc.hbrBackground = $$COLOR_BTNFACE + 1
	wc.lpszClassName = &$$WINX_SPLITTER_CLASS$

	ret = RegisterClassA (&wc)
	IFZ ret THEN RETURN $$TRUE		' fail

	#bReentry = $$TRUE		' protect for reentry

END FUNCTION
'
' ################################
' #####  WinXAddAccelerator  #####
' ################################
' Adds an accelerator to an accelerator array
' r_accel[] = an array of accelerators
' cmd = the command the accelerator sends to WM_COMMAND
' key = the VK key code
' control, alt, shit = $$TRUE if the modifier is down, $$FALSE otherwise
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAddAccelerator (ACCEL r_accel[], cmd, key, control, alt, shift)

	IFZ r_accel[] THEN
		DIM r_accel[0]
		upp = 0
	ELSE
		upp = UBOUND (r_accel[]) + 1
		REDIM r_accel[upp]
	ENDIF

	fVirt = $$FVIRTKEY
	IF alt     THEN fVirt = fVirt | $$FALT
	IF control THEN fVirt = fVirt | $$FCONTROL
	IF shift   THEN fVirt = fVirt | $$FSHIFT

	r_accel[upp].fVirt = fVirt
	r_accel[upp].key = key
	r_accel[upp].cmd = cmd

	RETURN $$TRUE		' success
END FUNCTION
'
' #####################################
' #####  WinXAddAcceleratorTable  #####
' #####################################
' Creates an accelerator table
' accel[] = an array of accelerators
' returns a handle to the new accelerator table or 0 on fail
FUNCTION WinXAddAcceleratorTable (ACCEL accel[])
	' initialize the accelerator table
	cEntries = UBOUND (accel[]) + 1

	hAccel = CreateAcceleratorTableA (&accel[0], cEntries)		' create the accelerator table
	IFZ hAccel THEN RETURN

	RETURN hAccel
END FUNCTION
'
' ##############################
' #####  WinXAddAnimation  #####
' ##############################
' Creates a new animation control
' parent = the handle to the parent window
' file = the animation file to play
' idCtr = the unique idCtr for this control
' returns the handle to the control or 0 on fail
FUNCTION WinXAddAnimation (parent, STRING file, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE
	style = style | $$ACS_CENTER

	hInst = GetModuleHandleA (0)
	hAni = CreateWindowExA (0, &"SysAnimate32", 0, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hAni THEN RETURN

	SendMessageA (hAni, $$ACM_OPENA, 0, &file)
	RETURN hAni
END FUNCTION
'
' ###########################
' #####  WinXAddButton  #####
' ###########################
'
' [WinXAddButton]
' Description = Creates a new button and adds it to the specified window
' Function    = hButton = WinXAddButton (parent, STRING title, hImage, idCtr)
' ArgCount    = 4
' Arg1        = parent : The parent window to contain this control
' Arg2				= title : The text the button will display. If hImage is not 0, this is either "bitmap" or "icon" depending on whether hImage is a handle to a bitmap or an icon
' Arg3				= hImage : If this is an image button this parameter is the handle to the image, otherwise it must be 0
' Arg4				= idCtr : The unique idCtr for this button
' Return      = $$TRUE on success or $$FALSE on error
' Remarks     = To create a button that contains a text label, hImage must be 0.
' To create a button with an image, load either a bitmap or an icon using the standard gdi functions.
' Sets the hImage parameter to the handle gdi gives you and the title parameter to either "bitmap" or "icon"
' Depending on what kind of image you loaded.
' See Also    =
' Examples    = 'Define constants to identify the buttons
' $$IDBUTTON1 = 100$$IDBUTTON2 = 101
' 'Make a button with a text label
' hButton = WinXAddButton (#hMain, "Click me!", 0, $$IDBUTTON1)
' 'Make a button with a bitmap (which in this case is included in the resource file of your application)
' hBmp = LoadBitmapA (GetModuleHandleA(0), &"bitmapForButton2")
' hButton2 = WinXAddButton (#hMain, "bitmap", hBmp, $$IDBUTTON2)
'
FUNCTION WinXAddButton (parent, STRING title, hImage, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE
	style = style | $$BS_PUSHBUTTON | $$WS_TABSTOP
	IF hImage THEN
		SELECT CASE LCASE$ (title)
			CASE "icon"
				style = style | $$BS_ICON
				imageType = $$IMAGE_ICON
			CASE "bitmap"
				style = style | $$BS_BITMAP
				imageType = $$IMAGE_BITMAP
		END SELECT
	ENDIF

	hInst = GetModuleHandleA (0)
	hBtn = CreateWindowExA (0, &$$BUTTON, &title, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hBtn THEN RETURN

	WinXSetDefaultFont (hBtn)
	IF hImage THEN
		' add the image
		ret = SendMessageA (hBtn, $$BM_SETIMAGE, imageType, hImage)
		IFZ ret THEN WinXSetText (hBtn, "err " + title)		' fail
	ENDIF

	' and we're done!
	RETURN hBtn
END FUNCTION
'
' #############################
' #####  WinXAddCalendar  #####
' #############################
' Create a new calendar control
' monthsX = the number of months to display in the x direction, returns the width of the control
' monthsY = the number of months to display in the y direction, returns the height of the control
' idCtr = the unique idCtr for this control
' returns the handle to the new control
FUNCTION WinXAddCalendar (hParent, @monthsX, @monthsY, idCtr)
	RECT rect

	style = $$WS_CHILD | $$WS_VISIBLE
	style = style | $$WS_TABSTOP

	hInst = GetModuleHandleA (0)
	hCal = CreateWindowExA (0, &$$MONTHCAL_CLASS, 0, style, 0, 0, 0, 0, hParent, idCtr, hInst, 0)
	IFZ hCal THEN RETURN

	WinXSetDefaultFont (hCal)
	SendMessageA (hCal, $$MCM_GETMINREQRECT, 0, &rect)
	monthsX = monthsX * (rect.right - rect.left)
	monthsY = monthsY * (rect.bottom - rect.top)
	RETURN hCal
END FUNCTION
'
' ################################
' #####  WinXAddCheckButton  #####
' ################################
' Adds a new check button control
' parent = the handle to the parent window
' title = the title of the check control
' isFirst = $$TRUE if this is the first check button in the group, otherwise $$FALSE
' pushlike = $TRUE if the button is to be displayed as a push button
' idCtr = the unique idCtr for this control
' returns the handle to the check button or 0 on fail
FUNCTION WinXAddCheckButton (parent, STRING title, isFirst, pushlike, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE
	style = style | $$WS_TABSTOP | $$BS_AUTOCHECKBOX

	IF isFirst THEN style = style | $$WS_GROUP
	IF pushlike THEN style = style | $$BS_PUSHLIKE

	hInst = GetModuleHandleA (0)
	hCheck = CreateWindowExA (0, &$$BUTTON, &title, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hCheck THEN RETURN

	WinXSetDefaultFont (hCheck)
	RETURN hCheck
END FUNCTION
'
' #############################
' #####  WinXAddComboBox  #####
' #############################
' creates a new extended combo box
' parent = the parent window for the combo box
' canEdit = $$TRUE if the user can enter their own item in the edit box
' images = if this combo box displays images with items, this is the handle to an image list, else 0
' idCtr = the idCtr for the control
' returns the handle to the extended combo box, or 0 on fail
FUNCTION WinXAddComboBox (parent, listHeight, canEdit, images, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE
	style = style | $$WS_TABSTOP
	' $$CBS_DROPDOWN     : Editable Drop Down List
	' $$CBS_DROPDOWNLIST : Non-editable Drop Down List
	IF canEdit THEN style = style | $$CBS_DROPDOWN ELSE style = style | $$CBS_DROPDOWNLIST

	hInst = GetModuleHandleA (0)
	hCombo = CreateWindowExA (0, &$$WC_COMBOBOXEX, 0, style, 0, 0, 0, listHeight + 22, parent, idCtr, hInst, 0)
	IFZ hCombo THEN RETURN

	IF images THEN SendMessageA (hCombo, $$CBEM_SETIMAGELIST, 0, images)
	RETURN hCombo
END FUNCTION
'
' ############################
' #####  WinXAddControl  #####
' ############################
' Adds a new custom control
' parent = the window to add the control to
' class = the class name for the control - this will be in the control's documentation
' title = the initial text to appear in the control - not all controls use this parameter
' idCtr = the unique idCtr to identify the control
' style = the style of the control.  You do not have to include $$WS_CHILD or $$WS_VISIBLE
' exStyle = the extended style of the control.  For most controls this will be 0
' returns the handle of the control, or 0 on fail
FUNCTION WinXAddControl (parent, STRING class, STRING title, style, exStyle, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE | style		' passed style
	style = style | $$WS_TABSTOP

	hInst = GetModuleHandleA (0)
	hCtr = CreateWindowExA (exStyle, &class, &title, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hCtr THEN RETURN

	RETURN hCtr
END FUNCTION
'
' #########################
' #####  WinXAddEdit  #####
' #########################
' Adds a new edit control to the window
' parent = the parent window
' title = the initial text to display in the control
' style = the style of the control
' idCtr = the unique idCtr for this control
' returns a handle to the new edit control or 0 on fail
FUNCTION WinXAddEdit (parent, STRING title, style, idCtr)
	IFZ idCtr THEN RETURN

	style = $$WS_CHILD | $$WS_VISIBLE | style		' passed style
	style = style | $$WS_TABSTOP | $$WS_BORDER
	IF (style & $$ES_MULTILINE) = $$ES_MULTILINE THEN ' multiline edit box
		style = style | $$WS_VSCROLL | $$ES_AUTOHSCROLL | $$WS_HSCROLL
	ENDIF

	hInst = GetModuleHandleA (0)
	hEdit = CreateWindowExA ($$WS_EX_CLIENTEDGE, &$$EDIT, &title, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hEdit THEN RETURN

	WinXSetDefaultFont (hEdit)
	RETURN hEdit
END FUNCTION
'
' #############################
' #####  WinXAddGroupBox  #####
' #############################
' Creates a new group box and adds it to the specified window
' parent = the parent window
' label = the label for the group box
' idCtr = the unique idCtr for this control
' returns the handle to the window or 0 on fail
FUNCTION WinXAddGroupBox (parent, STRING label, idCtr)
	IFZ idCtr THEN RETURN

	style = $$WS_CHILD | $$WS_VISIBLE
	style = style | $$BS_GROUPBOX

	hInst = GetModuleHandleA (0)
	hGroup = CreateWindowExA (0, &$$BUTTON, &label, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hGroup THEN RETURN

	WinXSetDefaultFont (hGroup)

	SetPropA (hGroup, &$$LeftSubSizer$, &groupBox_SizeContents ())
	SetPropA (hGroup, &"WinXAutoSizerSeries", AUTOSIZER_LinkedList_New ($$DIR_VERT))
	RETURN hGroup
END FUNCTION
'
' ############################
' #####  WinXAddListBox  #####
' ############################
' Makes a new list box
' parent = the parent window
' style = $$TRUE if list box is sorted
' multiSelect = $$TRUE if the list box can have multiple selections
' idCtr = the idCtr for the list box
' returns the handle of the list box
FUNCTION WinXAddListBox (parent, sort, multiSelect, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE
	style = style | $$WS_TABSTOP

	' $$LBS_STANDARD         : enables $$WM_COMMAND's notification code ($$LBN_SELCHANGE)
	' $$LBS_NOINTEGRALHEIGHT : Predefined size
	style = style | $$WS_VSCROLL | $$WS_HSCROLL | $$LBS_HASSTRINGS | $$LBS_NOINTEGRALHEIGHT
	style = style | $$LBS_NOTIFY

	IF sort THEN style = style | $$LBS_SORT
	IF multiSelect THEN style = style | $$LBS_EXTENDEDSEL

	hInst = GetModuleHandleA (0)
	hListBox = CreateWindowExA (0, &$$LISTBOX, 0, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hListBox THEN RETURN

	WinXSetDefaultFont (hListBox)
	RETURN hListBox
END FUNCTION
'
' #############################
' #####  WinXAddListView  #####
' #############################
' Creates a new list view control
' editable enables/disables label editing.  view is a view constant
' returns the handle to the new window or 0 on fail
FUNCTION WinXAddListView (parent, hilLargeIcons, hilSmallIcons, editable, view, idCtr)

	style = $$WS_CHILD | $$WS_VISIBLE
	style = style | $$WS_TABSTOP
	IF editable THEN style = style | $$LVS_EDITLABELS

	' Guy-21sep10-don't keep a zero view, since it make the list view go berserk
	IFZ view THEN view = $$LVS_LIST
	style = style | view

	hInst = GetModuleHandleA (0)
	hLV = CreateWindowExA (0, &$$WC_LISTVIEW, 0, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hLV THEN RETURN

	IF hilLargeIcons THEN SendMessageA (hLV, $$LVM_SETIMAGELIST, $$LVSIL_NORMAL, hilLargeIcons)
	IF hilSmallIcons THEN SendMessageA (hLV, $$LVM_SETIMAGELIST, $$LVSIL_SMALL, hilSmallIcons)

	' set the list view's extended style mask
	exStyle = $$LVS_EX_FULLROWSELECT | $$LVS_EX_LABELTIP
	SendMessageA (hLV, $$LVM_SETEXTENDEDLISTVIEWSTYLE, 0, exStyle)

	RETURN hLV

END FUNCTION
'
' ################################
' #####  WinXAddProgressBar  #####
' ################################
' Adds a new progress bar control
' parent = the handle to the parent window
' smooth = $$TRUE if the progress bar is not to be segmented
' idCtr = the unique idCtr constant for this control
' returns the handle to the progress bar or $$FALSE on fail
FUNCTION WinXAddProgressBar (parent, smooth, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE
	IF smooth THEN style = style | $$PBS_SMOOTH

	hInst = GetModuleHandleA (0)
	hProg = CreateWindowExA (0, &$$PROGRESS_CLASS, 0, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hProg THEN RETURN

	SendMessageA (hProg, $$PBM_SETRANGE, 0, MAKELONG (0, 1000))
	RETURN hProg
END FUNCTION
'
' ################################
' #####  WinXAddRadioButton  #####
' ################################
' Adds a new radio button control
' parent = the handle to the parent window
' title = the title of the radio button
' isFirst = $$TRUE if this is the first radio button in the group, otherwise $$FALSE
' pushlike = $TRUE if the button is to be displayed as a push button
' idCtr = the unique idCtr constant for the radio button
' returns the handle to the radio button or 0 on fail
FUNCTION WinXAddRadioButton (parent, STRING title, isFirst, pushlike, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE
	style = style | $$WS_TABSTOP | $$BS_AUTORADIOBUTTON

	IF isFirst THEN style = style | $$WS_GROUP
	IF pushlike THEN style = style | $$BS_PUSHLIKE

	hInst = GetModuleHandleA (0)
	hRadio = CreateWindowExA (0, &$$BUTTON, &title, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hRadio THEN RETURN

	WinXSetDefaultFont (hRadio)
	RETURN hRadio
END FUNCTION
'
' ############################
' #####  WinXAddSpinner  #####
' ############################
'
FUNCTION WinXAddSpinner (parent, hBuddy, buddy_x, buddy_y, buddy_w, buddy_h, uppVal, lowVal, curVal, idCtr)

	IFZ parent THEN RETURN
	IFZ hBuddy THEN RETURN

	MoveWindow (hBuddy, buddy_x, buddy_y, buddy_w, buddy_h, 0)
	IF uppVal < lowVal THEN
		temp = uppVal
		uppVal = lowVal
		lowVal = temp
	ENDIF
	IF curVal < lowVal || curVal > uppVal THEN curVal = lowVal

	style = $$WS_CHILD | $$WS_VISIBLE | $$WS_BORDER

	' $$UDS_NOTHOUSANDS : no thousand separator
	' $$UDS_ARROWKEYS   : Arrow keys
	' $$UDS_ALIGNRIGHT  : Align right
	' $$UDS_SETBUDDYINT : Set buddy
	style = style | $$WS_TABSTOP | $$UDS_ALIGNRIGHT | $$UDS_SETBUDDYINT | $$UDS_ARROWKEYS | $$UDS_NOTHOUSANDS

	hInst = GetModuleHandleA (0)
	errNum = SetLastError (0)
	hSpinner = CreateUpDownControl (style, buddy_x, buddy_y, 15, buddy_h, parent, idCtr, hInst, hBuddy, uppVal, lowVal, curVal)
	RETURN hSpinner

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
' idCtr = the unique idCtr for this control
' returns a handle to the control or 0 on error
FUNCTION WinXAddStatic (parent, STRING title, hImage, style, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE | style		' passed style

	IF hImage THEN
		SELECT CASE LCASE$ (title)
			CASE "icon"
				style = style | $$SS_ICON
				imageType = $$IMAGE_ICON
			CASE "bitmap"
				style = style | $$SS_BITMAP
				imageType = $$IMAGE_BITMAP
		END SELECT
	ENDIF

	hInst = GetModuleHandleA (0)
	hStatic = CreateWindowExA (0, &$$STATIC_CLASS, &title, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hStatic THEN RETURN

	WinXSetDefaultFont (hStatic)
	IF hImage THEN
		ret = SendMessageA (hStatic, $$STM_SETIMAGE, imageType, hImage)
		IFZ ret THEN WinXSetText (hStatic, "err " + title)		' fail
	ENDIF
	RETURN hStatic
END FUNCTION
'
' ##############################
' #####  WinXAddStatusBar  #####
' ##############################
'
' Adds a status bar to a window
' hWnd      = the window to add the status bar to
' csvTexts$ = a string to initialise the status bar with.  This string contains
'             a number of strings for each panel, separated by commas
' idCtr     = the idCtr of the status bar
' returns a handle to the new status bar or 0 on fail
' NOTE: all status bar's parts are set to the same width
FUNCTION WinXAddStatusBar (hWnd, csvTexts$, idCtr)
	BINDING binding
	RECT rcWnd

	IFZ hWnd THEN RETURN
	IFZ idCtr THEN RETURN

	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	' now prepare the parts
	uppPart = XstTally (csvTexts$, ",")
	IFZ uppPart THEN
		DIM s$[0]
		s$[0] = csvTexts$
	ELSE
		XstParseStringToStringArray (csvTexts$, ",", @s$[])
	ENDIF
	uppPart = UBOUND (s$[])

	' create array parts[] for holding the right edge cooordinates
	cPart = uppPart + 1
	IF cPart >= 2 THEN
		' calculate the right edge coordinate for each part, and
		' copy the coordinates to the array
		GetClientRect (hWnd, &rcWnd)
		width = (rcWnd.right - rcWnd.left) / cPart
		'
		DIM parts[uppPart]
		'
		' calculate each segment bounds
		cumWidth = 0
		FOR i = 0 TO uppPart - 1
			cumWidth = cumWidth + width
			parts[i] = cumWidth
		NEXT i
		parts[uppPart] = -1 ' extend to the right edge of the window
	ENDIF

	style = $$WS_CHILD | $$WS_VISIBLE

	' get the parent window's style
	window_style = GetWindowLongA (hWnd, $$GWL_STYLE)
	IF (window_style & $$WS_SIZEBOX) = $$WS_SIZEBOX THEN style = style | $$SBARS_SIZEGRIP

	' make the status bar
'	hInst = GetModuleHandleA (0)
'	hCtr = CreateWindowExA (0, &$$STATUSCLASSNAME, 0, style, 0, 0, 0, 0, hWnd, idCtr, hInst, 0)

	' Guy-19feb12-use CreateStatusWindowA instead of CreateWindowExA
	hCtr = CreateStatusWindowA (style, 0, hWnd, idCtr)
	IFZ hCtr THEN RETURN

	hFont = GetStockObject ($$DEFAULT_GUI_FONT)
	WinXSetFont (hCtr, hFont)

	' set the part info
	cPart = UBOUND (parts[]) + 1
	IF cPart < 2 THEN
		cPart = 1
		SendMessageA (hCtr, $$SB_SIMPLE, 1, 0)
	ELSE
		SendMessageA (hCtr, $$SB_SETPARTS, cPart, &parts[0])
	ENDIF

	' and finally, set the text
	upp = UBOUND (s$[])
	FOR i = 0 TO upp
		text$ = s$[i]
		IFZ text$ THEN text$ = " "
		SendMessageA (hCtr, $$SB_SETTEXT, i, &text$)
	NEXT i

	' and update the binding
	binding.hStatus = hCtr
	binding.statusParts = cPart - 1
	BINDING_Update (idBinding, binding)
	DeleteObject (hFont)		' release the font

	RETURN hCtr
END FUNCTION
'
' #########################
' #####  WinXAddTabs  #####
' #########################
' Creates a new tab control
' parent = the handle to the parent window
' multiline = $$TRUE if this is a multiline control
' idCtr = the unique idCtr for this control
' returns the handle to the control or 0 on fail
FUNCTION WinXAddTabs (parent, multiline, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE

	' both the tab and parent controls must have the $$WS_CLIPSIBLINGS window style
	' $$WS_CLIPSIBLINGS : Clip Sibling Area
	' $$TCS_HOTTRACK    : Hot track
	style = style | $$WS_TABSTOP | $$TCS_HOTTRACK | $$WS_CLIPSIBLINGS
	IF multiline THEN style = style | $$TCS_MULTILINE

	' add $$WS_CLIPSIBLINGS style to the parent control if missing
	IF parent THEN
		parent_style = GetWindowLongA (parent, $$GWL_STYLE)
		IF (parent_style & $$WS_CLIPSIBLINGS) <> $$WS_CLIPSIBLINGS THEN		' is missing
			parent_style = parent_style | $$WS_CLIPSIBLINGS
			SetWindowLongA (parent, $$GWL_STYLE, parent_style)
		ENDIF
	ENDIF

	hInst = GetModuleHandleA (0)
	hTabs = CreateWindowExA (0, &$$WC_TABCONTROL, 0, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hTabs THEN RETURN

	WinXSetDefaultFont (hTabs)
	SetPropA (hTabs, &$$LeftSubSizer$, &tabs_SizeContents ())
	RETURN hTabs
END FUNCTION
'
' ###############################
' #####  WinXAddTimePicker  #####
' ###############################
' Creates a new Date/Time Picker control
' format = the format for the control, should be $$DTS_LONGDATEFORMAT, $$DTS_SHORTDATEFORMAT or $$DTS_TIMEFORMAT
' initialTime = the time to initialise the control to
' timeValid = $$TRUE if the initialTime parameter is valid
' idCtr = the unique idCtr for this control
' returns the handle to the control or 0 on fail
FUNCTION WinXAddTimePicker (hParent, format, SYSTEMTIME initialTime, timeValid, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE
	style = style | $$WS_TABSTOP

	SELECT CASE format
		CASE $$DTS_LONGDATEFORMAT, $$DTS_SHORTDATEFORMAT, $$DTS_TIMEFORMAT
			style = style | format
	END SELECT

	hInst = GetModuleHandleA (0)
	hCtr = CreateWindowExA (0, &$$DATETIMEPICK_CLASS, 0, style, 0, 0, 0, 0, hParent, idCtr, hInst, 0)
	IFZ hCtr THEN RETURN

	WinXSetDefaultFont (hCtr)
	IF timeValid THEN
		SendMessageA (hCtr, $$DTM_SETSYSTEMTIME, $$GDT_VALID, &initialTime)
	ELSE
		SendMessageA (hCtr, $$DTM_SETSYSTEMTIME, $$GDT_NONE, 0)
	ENDIF
	RETURN hCtr
END FUNCTION
'
' ############################
' #####  WinXAddTooltip  #####
' ############################
' Adds a tooltip to a control
' hCtr = the handle to the control to set the tooltip for
' tip$ = the text of the tooltip
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAddTooltip (hCtr, tip$)
	BINDING binding
	TOOLINFO ti

	IFZ hCtr THEN RETURN
	IFZ tip$ THEN RETURN

	parent = GetParent (hCtr)
	IFZ parent THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (parent, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	' is there any info on this control?
	ti.cbSize = SIZE (TOOLINFO)
	ti.hwnd = parent
	ti.uId = hCtr

	fInfo = SendMessageA (binding.hToolTips, $$TTM_GETTOOLINFO, 0, &ti)
	IFZ fInfo THEN
		' make a new entry
		wMsg = $$TTM_ADDTOOL
	ELSE
		' update the text
		wMsg = $$TTM_UPDATETIPTEXT
	ENDIF

	ti.cbSize = SIZE (TOOLINFO)
	ti.uFlags = $$TTF_SUBCLASS | $$TTF_IDISHWND
	ti.hwnd = parent
	ti.uId = hCtr
	ti.lpszText = &tip$
	SendMessageA (binding.hToolTips, wMsg, 0, &ti)

	RETURN $$TRUE		' success

END FUNCTION
'
' #############################
' #####  WinXAddTrackBar  #####
' #############################
' Adds a new trackbar control
' parent = the parent window for the trackbar
' enableSelection = $$TRUE to enable selections in the trackbar
' posToolTip = $$TRUE to enable a tooltip which displays the position of the slider
' idCtr = the unique idCtr constant of this trackbar
' returns the handle to the trackbar or 0 on fail
FUNCTION WinXAddTrackBar (parent, enableSelection, posToolTip, idCtr)
	style = $$WS_CHILD | $$WS_VISIBLE
	style = style | $$WS_TABSTOP | $$TBS_AUTOTICKS

	IF enableSelection THEN style = style | $$TBS_ENABLESELRANGE
	IF posToolTip THEN style = style | $$TBS_TOOLTIPS

	hInst = GetModuleHandleA (0)
	hTracker = CreateWindowExA (0, &$$TRACKBAR_CLASS, 0, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hTracker THEN RETURN

	WinXSetDefaultFont (hTracker)
	RETURN hTracker
END FUNCTION
'
' #############################
' #####  WinXAddTreeView  #####
' #############################
' Adds a new tree view
' parent = the parent window
' editable = $$TRUE to allow lable editing
' draggable = $$TRUE to enable dragging
' idCtr = the unique idCtr constant for this control
' returns the handle to the tree view or 0 on fail
FUNCTION WinXAddTreeView (parent, hImages, editable, draggable, idCtr)

	style = $$WS_CHILD | $$WS_VISIBLE
	' $$TVS_LINESATROOT : Lines at root
	' $$TVS_HASLINES    : |--lines
	' $$TVS_HASBUTTONS  : [-]/[+]
	style = style | $$WS_TABSTOP | $$TVS_HASBUTTONS | $$TVS_HASLINES | $$TVS_LINESATROOT

	IFF draggable THEN style = style | $$TVS_DISABLEDRAGDROP
	IF editable THEN style = style | $$TVS_EDITLABELS

	hInst = GetModuleHandleA (0)
	hTV = CreateWindowExA (0, &$$WC_TREEVIEW, 0, style, 0, 0, 0, 0, parent, idCtr, hInst, 0)
	IFZ hTV THEN RETURN

	WinXSetDefaultFont (hTV)
	IF hImages THEN SendMessageA (hTV, $$TVM_SETIMAGELIST, $$TVSIL_NORMAL, hImages)

	RETURN hTV

END FUNCTION
'
' ##########################
' #####  WinXAni_Play  #####
' ##########################
' Starts playing an animation control
' hAni = the animation control to play
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAni_Play (hAni)
	wFrom = 0		' zero-based index of the frame where playing begins
	wTo = -1		' -1 means end with the last frame in the AVI clip
	lParam = MAKELONG (wFrom, wTo)
	ret = SendMessageA (hAni, $$ACM_PLAY, -1, lParam)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ##########################
' #####  WinXAni_Stop  #####
' ##########################
' Stops playing and animation control
' hAni = the animation control to stop playing
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAni_Stop (hAni)
	ret = SendMessageA (hAni, $$ACM_STOP, 0, 0)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ####################################
' #####  WinXAttachAccelerators  #####
' ####################################
' Attaches an accelerator table to a window
' hWnd = the window to add the accelerator table to
' hAccel = the handle to the accelerator table
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAttachAccelerators (hWnd, hAccel)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ hAccel THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.hAccelTable = hAccel
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success

END FUNCTION
'
' #########################################
' #####  WinXAutoSizer_GetMainSeries  #####
' #########################################
' Gets the idCtr of the main autosizer series for a window
' hWnd = the window to get the series for
' returns the idCtr of the main series of the window, -1 on fail
FUNCTION WinXAutoSizer_GetMainSeries (hWnd)
	BINDING binding

	IFZ hWnd THEN RETURN -1		' fail

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN -1		' fail

	RETURN binding.autoSizerInfo
END FUNCTION
'
' ###################################
' #####  WinXAutoSizer_SetInfo  #####
' ###################################
' Sets info for the autosizer to use when sizing your controls
' hWnd = the handle to the window to resize
' series = the series to place the control in, -1 for parent's series
' space = the space from the previous control
' size = the size of this control
' x, y, w, h = the size and position of the control on the current window
' flags = a set of $$SIZER flags
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXAutoSizer_SetInfo (hWnd, series, DOUBLE space, DOUBLE size, DOUBLE x, DOUBLE y, DOUBLE w, DOUBLE h, flags)
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]

	BINDING binding
	AUTOSIZERINFO autoSizerBlock
	SPLITTERINFO splitterInfo
	RECT rect

	IFZ hWnd THEN RETURN

	IF series = -1 THEN
		' get the parent window
		parent = GetParent (hWnd)
		IFZ parent THEN RETURN
		' get the binding
		idBinding = GetWindowLongA (parent, $$GWL_USERDATA)
		IFF BINDING_Get (idBinding, @binding) THEN RETURN
		series = binding.autoSizerInfo
	ENDIF

	' associate the info
	autoSizerBlock.hwnd = hWnd
	autoSizerBlock.space = space
	autoSizerBlock.size = size
	autoSizerBlock.x = x
	autoSizerBlock.y = y
	autoSizerBlock.w = w
	autoSizerBlock.h = h
	autoSizerBlock.flags = flags

	' register the block
	prop$ = "autoSizerInfoBlock"
	idBlock = GetPropA (hWnd, &prop$)

	IF idBlock THEN
		' update the old one
		bOK = AUTOSIZER_LinkedList_Update (series, idBlock - 1, autoSizerBlock)
	ELSE
		' make a new block
		idBlock = autoSizerInfo_AddGroup (series, autoSizerBlock) + 1
		IFF idBlock THEN RETURN
		IFZ SetPropA (hWnd, &prop$, idBlock) THEN RETURN

		' make a splitter if we need one
		IF autoSizerBlock.flags AND $$SIZER_SPLITTER THEN
			splitterInfo.group = series
			splitterInfo.id = idBlock - 1
			splitterInfo.direction = AUTOSIZER_LinkedList[series].direction

			AUTOSIZER_LinkedList_Get (series, idBlock - 1, @autoSizerBlock)

			style = $$WS_CHILD | $$WS_VISIBLE | $$WS_CLIPSIBLINGS
			' Guy-14jun11-$$WS_CLIPSIBLINGS problem?
			lpParam = SPLITTERINFO_New (splitterInfo)

			hInst = GetModuleHandleA (0)
			parent = GetParent (hWnd)
			ret = CreateWindowExA (0, &$$WINX_SPLITTER_CLASS$, 0, style, 0, 0, 0, 0, parent, 0, hInst, lpParam)
			IFZ ret THEN RETURN

			autoSizerBlock.hSplitter = ret
			AUTOSIZER_LinkedList_Update (series, idBlock - 1, autoSizerBlock)
		ENDIF
		bOK = $$TRUE
	ENDIF

	ret = GetClientRect (hWnd, &rect)
	IF ret THEN
		w = rect.right - rect.left
		h = rect.bottom - rect.top
		sizeWindow (hWnd, w, h)
	ENDIF

	RETURN bOK
END FUNCTION
'
' #########################################
' #####  WinXAutoSizer_SetSimpleInfo  #####
' #########################################
' A simplified version of WinXAutoSizer_SetInfo
FUNCTION WinXAutoSizer_SetSimpleInfo (hWnd, series, DOUBLE space, DOUBLE size, flags)
	IFZ hWnd THEN RETURN
	' x, y, w, h = the size and position of the control on the current window
	RETURN WinXAutoSizer_SetInfo (hWnd, series, space, size, 0.0, 0.0, 1.0, 1.0, flags)
END FUNCTION
'
' #################################
' #####  WinXButton_GetCheck  #####
' #################################
' Gets the check state of a check or radio button
' hButton = the handle to the button to get the check state for
' returns $$TRUE if the button is checked, $$FALSE otherwise
FUNCTION WinXButton_GetCheck (hButton)
	ret = SendMessageA (hButton, $$BM_GETCHECK, 0, 0)
	IF ret = $$BST_CHECKED THEN RETURN $$TRUE ELSE RETURN $$FALSE
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
	IFF checked THEN wParam = $$BST_UNCHECKED ELSE wParam = $$BST_CHECKED
	ret = SendMessageA (hButton, $$BM_SETCHECK, wParam, 0)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' #######################################
' #####  WinXCalendar_GetSelection  #####
' #######################################
' Get the selection in a calendar control
' hCal = the handle to the calendar control
' start = the variable to store the start of the selection range
' end = the variable to store the end of the selection range
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXCalendar_GetSelection (hCal, SYSTEMTIME time)
	ret = SendMessageA (hCal, $$MCM_GETCURSEL, 0, &time)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' #######################################
' #####  WinXCalendar_SetSelection  #####
' #######################################
' Sets the selection in a calendar control
' hCal = the handle to the calendar control
' start = the start of the selection range
' end = the end of the selection range
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXCalendar_SetSelection (hCal, SYSTEMTIME time)
	ret = SendMessageA (hCal, $$MCM_SETCURSEL, 0, &time)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' #########################
' #####  WinXCleanUp  #####
' #########################
'
' cleanup of any resources that need to be deallocated (allocated memory is freed, ...)
'
FUNCTION WinXCleanUp ()		' optional cleanup
	SHARED BINDING BINDING_array[]		'a simple array of bindings
	SHARED g_hClipMem		' to copy to the clipboard
	STATIC s_entry
	WNDCLASS wc		' objet de la Structure WNDCLASS

	IF s_entry = 1 THEN RETURN

	hInst = GetModuleHandleA (0)

	IF g_hClipMem THEN
		GlobalFree (g_hClipMem)
		g_hClipMem = 0 ' don't free twice
	ENDIF

	IF BINDING_array[] THEN
		FOR i = UBOUND (BINDING_array[]) TO 0 STEP -1
			hWnd = BINDING_array[i].hwnd
			IF hWnd THEN
				ret = ShowWindow (hWnd, $$SW_HIDE)	' Guy-01feb10-prevent from crashing
				IF ret THEN DestroyWindow (hWnd)		' destroy the window
			ENDIF
		NEXT i
	ENDIF

	' unregister WinX main window class
	' 1. destroy any window that would still use this obsolete window class
	DO
		hWnd = FindWindowA (&#WinXclass$, 0)
		IFZ hWnd THEN EXIT DO
		'
		ShowWindow (hWnd, $$SW_HIDE)
		ret = DestroyWindow (hWnd)
		IFZ ret THEN EXIT DO		' prevent forever looping
	LOOP

	' 2. unregister it!
	UnregisterClassA (&#WinXclass$, hInst)		' unregister the window class

	s_entry = 1

END FUNCTION
'
' #######################
' #####  WinXClear  #####
' #######################
' Clears all the graphics in a window
' hWnd = the handle to the window to clear
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClear (hWnd)
	BINDING binding
	RECT rect

	IFZ hWnd THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	ret = GetClientRect (hWnd, &rect)
	IFZ ret THEN RETURN

	winRight = rect.right + 2
	winBottom = rect.bottom + 2
	binding.hUpdateRegion = CreateRectRgn (0, 0, winRight, winBottom)
	BINDING_Update (idBinding, binding)

	RETURN autoDraw_clear (binding.autoDrawInfo)
END FUNCTION
'
' ###############################
' #####  WinXClip_GetImage  #####
' ###############################
' Get an image from the clipboard
' Returns the handle to the bitmap or 0 on error
FUNCTION WinXClip_GetImage ()
	BITMAPINFOHEADER bmi

	IFZ OpenClipboard (0) THEN RETURN
	hClipData = GetClipboardData ($$CF_DIB)
	IFZ hClipData THEN
		CloseClipboard ()
		RETURN
	ENDIF

	pGobalMem = GlobalLock (hClipData)
	IFZ pGobalMem THEN
		CloseClipboard ()
		RETURN
	ENDIF

	RtlMoveMemory (&bmi, pGobalMem, ULONGAT (pGobalMem))
	hImage = WinXDraw_CreateImage (bmi.biWidth, bmi.biHeight)
	hDC = CreateCompatibleDC (0)
	hOld = SelectObject (hDC, hImage)

	height = ABS (bmi.biHeight)
	pBits = pGobalMem + SIZE (BITMAPINFOHEADER)

	SELECT CASE bmi.biBitCount
		CASE 1
			pBits = pBits + 8
		CASE 4
			pBits = pBits + 64
		CASE 8
			pBits = pBits + 1024
		CASE 16, 24, 32
			SELECT CASE bmi.biCompression
				CASE $$BI_RGB
				CASE $$BI_BITFIELDS
					pBits = pBits + 12
			END SELECT
	END SELECT

	PRINT bmi.biBitCount
	SetDIBitsToDevice (hDC, 0, 0, bmi.biWidth, height, 0, 0, 0, height, pBits, pGobalMem, $$DIB_RGB_COLORS)

	GlobalUnlock (hClipData)
	CloseClipboard ()

	SelectObject (hDC, hOld)
	DeleteDC (hDC)

	RETURN hImage
END FUNCTION
'
' ################################
' #####  WinXClip_GetString  #####
' ################################
' Gets a string from the clipboard
' Returns the string or "" on fail
FUNCTION WinXClip_GetString$ ()
	IFZ OpenClipboard (0) THEN RETURN ""		' fail

	hClipData = GetClipboardData ($$CF_TEXT)
	IFZ hClipData THEN
		CloseClipboard ()
		RETURN ""		' fail
	ENDIF

	pGobalMem = GlobalLock (hClipData)
	IFZ pGobalMem THEN
		CloseClipboard ()
		RETURN ""		' fail
	ENDIF

	text$ = CSTRING$ (pGobalMem)

	GlobalUnlock (hClipData)
	CloseClipboard ()

	RETURN text$
END FUNCTION
'
' ##############################
' #####  WinXClip_IsImage  #####
' ##############################
' Checks to see if the clipboard contains an image
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClip_IsImage ()
	ret = IsClipboardFormatAvailable ($$CF_DIB)
	IFZ ret THEN RETURN $$FALSE ELSE RETURN $$TRUE		' clipboard contains an image
END FUNCTION
'
' ###############################
' #####  WinXClip_IsString  #####
' ###############################
' Checks to see if the clipboard contains a string
' Returns $$TRUE if the clipboard contains a string, otherwise $$FALSE
FUNCTION WinXClip_IsString ()
	ret = IsClipboardFormatAvailable ($$CF_TEXT)
	IFZ ret THEN RETURN $$FALSE ELSE RETURN $$TRUE		' clipboard contains a string
END FUNCTION
'
' ###############################
' #####  WinXClip_PutImage  #####
' ###############################
' Copy an image to the clipboad
' hImage = the handle to the image to add to the clipboard
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClip_PutImage (hImage)
	SHARED g_hClipMem		' to copy to the clipboard

	BITMAPINFOHEADER bmi
	DIBSECTION ds

	IFZ hImage THEN RETURN
	IFZ GetObjectA (hImage, SIZE (DIBSECTION), &bmp) THEN RETURN

	cbBits = ds.dsBm.height * ((ds.dsBm.width * ds.dsBm.bitsPixel + 31) \ 32)

	IFZ OpenClipboard (0) THEN RETURN
	EmptyClipboard ()

	' Guy-07dec11-avoid memory leak
	IF g_hClipMem THEN
		GlobalFree (g_hClipMem)
		g_hClipMem = 0 ' don't free twice
	ENDIF

	' allocate memory
	g_hClipMem = GlobalAlloc ($$GMEM_MOVEABLE | $$GMEM_ZEROINIT, SIZE (BITMAPINFOHEADER) + cbBits)
	pGobalMem = GlobalLock (g_hClipMem)
	RtlMoveMemory (pGobalMem, &ds.dsBmih, SIZE (BITMAPINFOHEADER))
	RtlMoveMemory (pGobalMem + SIZE (BITMAPINFOHEADER), ds.dsBm.bits, cbBits)
	GlobalUnlock (g_hClipMem)

	SetClipboardData ($$CF_DIB, g_hClipMem)
	CloseClipboard ()

	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXClip_PutString  #####
' ################################
' Copies a string to the clipboard
' Stri$ = The string to copy
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXClip_PutString (Stri$)
	SHARED g_hClipMem		' to copy to the clipboard

	' open the clipboard
	IFZ OpenClipboard (0) THEN RETURN

	StriLen = LEN (Stri$)

	' Guy-07dec11-avoid memory leak
	IF g_hClipMem THEN
		GlobalFree (g_hClipMem)
		g_hClipMem = 0 ' don't free twice
	ENDIF

	' allocate memory
	g_hClipMem = GlobalAlloc ($$GMEM_MOVEABLE | $$GMEM_ZEROINIT, (StriLen + 1))
	IFZ g_hClipMem THEN RETURN

	' lock the object into memory
	pMem = GlobalLock (g_hClipMem)
	IFZ pMem THEN RETURN

	' move the string into the memory we locked
	RtlMoveMemory (pMem, &Stri$, StriLen)

	' don't send clipboard locked memory
	GlobalUnlock (g_hClipMem)

	' remove the current contents of the clipboard
	EmptyClipboard ()

	' copy the text into the clipboard
	SetClipboardData ($$CF_TEXT, g_hClipMem)

	CloseClipboard ()		' close the clipboard

	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  WinXComboBox_AddItem  #####
' ##################################
' adds an item to a extended combo box
' hCombo = the handle to the extended combo box
' index = the index to insert the item at, use -1 to add to the end
' indent = the number of indents to place the item at
' item$ = the item text
' iImage = the index to the image, ignored if this combo box doesn't have images
' iSelImage = the index of the image displayed when this item is selected
' returns the index of the new item, or -1 on fail
FUNCTION WinXComboBox_AddItem (hCombo, index, indent, item$, iImage, iSelImage)
	COMBOBOXEXITEM cbexi

	cbexi.mask = $$CBEIF_IMAGE | $$CBEIF_INDENT | $$CBEIF_SELECTEDIMAGE | $$CBEIF_TEXT
	cbexi.iItem = index
	cbexi.pszText = &item$
	cbexi.cchTextMax = LEN (item$)
	cbexi.iImage = iImage
	cbexi.iSelectedImage = iSelImage
	cbexi.iIndent = indent

	indexAdd = SendMessageA (hCombo, $$CBEM_INSERTITEM, 0, &cbexi)
	IF indexAdd < 0 THEN RETURN -1		' fail
	RETURN indexAdd
END FUNCTION
'
' ######################################
' #####  WinXComboBox_GetEditText  #####
' ######################################
' Gets the text in the edit cotrol of a combo box
' hCombo = the handle to the extended combo box
' returns the text or "" on fail
FUNCTION WinXComboBox_GetEditText$ (hCombo)
	hEdit = SendMessageA (hCombo, $$CBEM_GETEDITCONTROL, 0, 0)
	IFZ hEdit THEN RETURN ""		' fail
	RETURN WinXGetText$ (hEdit)
END FUNCTION
'
' ##################################
' #####  WinXComboBox_GetItem  #####
' ##################################
' Gets the text of an item
' hCombo = the handle to the extended combo box
' index = the zero-based index of the item to get
' returns the text of the item, or "" on fail
FUNCTION WinXComboBox_GetItem$ (hCombo, index)
	COMBOBOXEXITEM cbexi

	item$ = NULL$ (4095)
	cbexi.mask = $$CBEIF_TEXT
	cbexi.iItem = index
	cbexi.pszText = &item$
	cbexi.cchTextMax = SIZE (item$)

	IFZ SendMessageA (hCombo, $$CBEM_GETITEM, 0, &cbexi) THEN RETURN ""		' fail
	ret_text$ = CSTRING$ (cbexi.pszText)
	RETURN ret_text$
END FUNCTION
'
' #######################################
' #####  WinXComboBox_GetSelection  #####
' #######################################
' gets the current selection
' hCombo = the handle to the extended combo box
' returns the currently selected item or -1 on fail
FUNCTION WinXComboBox_GetSelection (hCombo)
	index = SendMessageA (hCombo, $$CB_GETCURSEL, 0, 0)
	IF index < 0 THEN RETURN -1		' fail
	RETURN index
END FUNCTION
'
' #####################################
' #####  WinXComboBox_RemoveItem  #####
' #####################################
' removes an item from a extended combo box
' hCombo = the handle to the extended combo box
' index = the zero-based index of the item to delete
' returns the number of items remaining in the list, or -1 on fail
FUNCTION WinXComboBox_RemoveItem (hCombo, index)
	index = SendMessageA (hCombo, $$CBEM_DELETEITEM, index, 0)
	IF index < 0 THEN RETURN -1		' fail
	RETURN index
END FUNCTION
'
' ######################################
' #####  WinXComboBox_SetEditText  #####
' ######################################
' Sets the text in the edit control for a combo box
' hCombo = the handle to the extended combo box
' STRING text = the text to put in the control
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXComboBox_SetEditText (hCombo, STRING text)
	hEdit = SendMessageA (hCombo, $$CBEM_GETEDITCONTROL, 0, 0)
	IFZ hEdit THEN RETURN
	' Guy-08feb11-WinXSetText (hCombo, text)
	WinXSetText (hEdit, text)
	RETURN $$TRUE		' success
END FUNCTION
'
' #######################################
' #####  WinXComboBox_SetSelection  #####
' #######################################
' Selects an item in a extended combo box
' hCombo = the handle to the extended combo box
' index = the index of the item to select.  -1 to deselect everything
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXComboBox_SetSelection (hCombo, index)
	IFZ hCombo THEN RETURN

	' IF (SendMessageA (hCombo, $$CB_SETCURSEL, index, 0) = $$CB_ERR) && (index != -1) THEN RETURN $$FALSE ELSE RETURN $$TRUE ' fail
	ret = SendMessageA (hCombo, $$CB_SETCURSEL, index, 0)
	IF (ret = $$CB_ERR) && (index <> -1) THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION

' Computes a (date & time) stamp "year_month_day_hour_minute_second"
' eg. stamp$ = "2011_05_24_13_26_05"
FUNCTION WinXDate_GetCurrentTimeStamp$ ()

	XstGetLocalDateAndTime (@year, @month, @day, @weekDay, @hour, @minute, @second, @nanos) ' get today's date

	stamp$ = STRING$ (year) ' 4 digits

	st$ = STRING$ (month)
	IF month < 10 THEN st$ = "0" + st$
	stamp$ = stamp$ + "_" + st$

	st$ = STRING$ (day)
	IF day < 10 THEN st$ = "0" + st$
	stamp$ = stamp$ + "_" + st$

	st$ = STRING$ (hour)
	IF hour < 10 THEN st$ = "0" + st$
	stamp$ = stamp$ + "_" + st$

	st$ = STRING$ (minute)
	IF minute < 10 THEN st$ = "0" + st$
	stamp$ = stamp$ + "_" + st$

	st$ = STRING$ (second)
	IF second < 10 THEN st$ = "0" + st$
	stamp$ = stamp$ + "_" + st$

	RETURN stamp$

END FUNCTION
'
' ##############################
' #####  WinXDialog_Error  #####
' ##############################
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
	MessageBoxA (0, &message, &title, $$MB_OK | icon)

	IF severity = 3 THEN QUIT (0)
	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXDialog_Message  #####
' ################################
' Displays a simple message dialog box
' hWnd = the handle to the owner window, 0 for none
' text$ = the text to display
' title$ = the title for the dialog
' icon$ = name of the icon to use
' hMod = the handle to the module from which the icon comes, 0 for this module
' returns $$TRUE on success or $$FALSE on fail
'
' Usage: WinXDialog_Message (#dlgAUD, "Not wanted", "Wanted?", "0", hInst)
'	--> SHARED hInst ' is needed by WinXDialog_Message for the icon "0"
'
FUNCTION WinXDialog_Message (hWnd, text$, title$, icon$, hMod)
	MSGBOXPARAMS mb

	flags = $$MB_OK
	IF icon$ THEN flags = flags | $$MB_USERICON

	IFZ hMod THEN hMod = GetModuleHandleA (0)

	mb.cbSize = SIZE (MSGBOXPARAMS)
	mb.hwndOwner = hWnd
	mb.hInstance = hMod
	mb.lpszText = &text$
	mb.lpszCaption = &title$
	mb.dwStyle = flags
	mb.lpszIcon = &icon$

	MessageBoxIndirectA (&mb)
	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXDialog_OpenDir$  #####
' #################################
' Displays a BrowseForFolder dialog box
' parent = the handle to the window to own this dialog
' title$ = the title for the dialog
' initDirIDL = the Windows' special folder to initialise the dialog with
' returns the directory path or "" on cancel or error
'
' Usage:
' dir$ = WinXDialog_OpenDir$ (#winMain, "", $$CSIDL_PERSONAL) ' My Documents' folder
'
FUNCTION WinXDialog_OpenDir$ (parent, title$, initDirIDL)		' standard Windows directory picker dialog

	BROWSEINFO bi

	IF initDirIDL < $$CSIDL_DESKTOP || initDirIDL > $$CSIDL_ADMINTOOLS THEN initDirIDL = $$CSIDL_DESKTOP

	' if no title, get the path for a Windows special folder
	IFZ TRIM$ (title$) THEN title$ = WinXFolder_GetDir$ (initDirIDL)

	bi.hWndOwner = parent
	bi.pIDLRoot = initDirIDL
	bi.lpszTitle = &title$
	bi.ulFlags = $$BIF_RETURNONLYFSDIRS + $$BIF_DONTGOBELOWDOMAIN

	' show the selection dialog
	oldErr = SetErrorMode ($$SEM_FAILCRITICALERRORS)		'D.-16apr08-fixed "no disk drive" error
	pidl = SHBrowseForFolderA (&bi)
	SetErrorMode (oldErr)

	IFZ pidl THEN RETURN ""		' fail: memory block not allocated

	' get the chosen directory path
	buf$ = NULL$ ($$MAX_PATH)
	ret = SHGetPathFromIDListA (pidl, &buf$)
	IFZ ret THEN RETURN ""		' fail

	directory$ = CSTRING$ (&buf$)
	WinXDir_AppendSlash (@directory$) ' append a \ to indicate a directory vs a file

	RETURN directory$

END FUNCTION
'
' ##################################
' #####  WinXDialog_OpenFile$  #####
' ##################################
'
' Displays an OpenFile dialog box
' parent       = the handle to the window to own this dialog
' title$       = the title for the dialog
' extensions$  = a string containing the file extensions the dialog supports
' initialName$ = the filename to initialise the dialog with
' multiSelect  = $$TRUE to enable selection of multiple file names,
' .              $$FALSE for single file name selection
' readOnly     = $$TRUE to allow to open "Read Only" (no lock) the selected file(s)
' .              (shows the check box "Read Only" and checks it initially)
' returns the opened files or "" on cancel or error
FUNCTION WinXDialog_OpenFile$ (parent, title$, extensions$, initialName$, multiSelect, readOnly)

	OPENFILENAME ofn

	' set initial file parts
	initDir$ = ""
	initFN$ = ""
	initExt$ = ""

	initialName$ = WinXPath_Trim$ (initialName$)
	SELECT CASE TRUE
		CASE LEN (initialName$) = 0
			XstGetCurrentDirectory (@initDir$)
			'
		CASE RIGHT$ (initialName$) = $$PathSlash$		' Guy-15dec08-initialName$ is a directory
			initDir$ = initialName$
			'
		CASE RIGHT$ (initialName$) = ":"		' Guy-14nov11-initialName$ is a drive
			initDir$ = initialName$
			'
		CASE ELSE
			XstDecomposePathname (initialName$, @initDir$, "", @initFN$, "", @initExt$)
			'
	END SELECT

	initDir$ = WinXPath_Trim$ (initDir$)
	IF initDir$ THEN
		' clip off a final $$PathSlash$
		IF RIGHT$ (initDir$) = $$PathSlash$ THEN initDir$ = RCLIP$ (initDir$)
		ofn.lpstrInitialDir = &initDir$
	ENDIF

	' SET file filter fileFilter$ WITH ARGUMENT extensions$
	' ==============================================================================
	' i.e.: extensions$ = "Text Files|*.TXT|Image Files|*.bmp;*.jpg)|
	'
	' fileFilter$ = buffer containing pairs of null-terminated filter strings:
	' i.e. extensions$ = "Desc_1|Ext_1|...Desc_n|Ext_n"
	' ==> fileFilter$ = "Desc_10Ext_10...Desc_n0Ext_n0"
	'
	' The 1st string in each pair describes a filter (for example, "Text Files"),
	' the 2nd string specifies the filter pattern (for example, "*.TXT").
	' ...
	'
	' Multiple filters can be specified for a single item by separating the
	' filter-pattern strings with a semicolon (for example, "*.TXT;*.DOC;*.BAK").
	' The last string in the buffer must be terminated by two NULL characters.
	' If this parameter is NULL, the dialog box will not display any filters.
	' The filter strings are assumed to be in the proper order, the operating
	' system not changing the order.
	' ==============================================================================

	fileFilter$ = TRIM$ (extensions$)
	IF RIGHT$ (fileFilter$) <> "|" THEN fileFilter$ = fileFilter$ + "|"		' add a final terminator

	' replace all separators "|" by the NULL character
	pos = INSTR (fileFilter$, "|")		' first separator '|'
	DO WHILE pos
		fileFilter${pos - 1} = '\0'		' replace '|' by NULL character
		pos = INSTR (fileFilter$, "|", pos + 1)		' next separator '|'
	LOOP

	ofn.lpstrFilter = &fileFilter$
	ofn.nFilterIndex = 1

	' initialize the return file name buffer buf$
	initFN$ = WinXPath_Trim$ (initFN$)
	length = LEN (initFN$)
	SELECT CASE length
		CASE 0 : buf$ = NULL$ ($$MAX_PATH)
		CASE $$MAX_PATH : buf$ = initFN$
		CASE ELSE
			IF length > $$MAX_PATH THEN
				buf$ = LEFT$ (initFN$, $$MAX_PATH)
			ELSE
				buf$ = initFN$ + NULL$ ($$MAX_PATH - LEN (initFN$))
			END IF
	END SELECT

	ofn.lpstrFile = &buf$
	ofn.nMaxFile = $$MAX_PATH
	ofn.lStructSize = SIZE (OPENFILENAME)		' length of the structure (in bytes)

	IF title$ THEN ofn.lpstrTitle = &title$		' dialog title

	' set dialog flags
	' Guy-28oct09-ofn.flags = $$OFN_FILEMUSTEXIST | $$OFN_EXPLORER | $$OFN_HIDEREADONLY ' hide the check box "Read Only"
	ofn.flags = $$OFN_FILEMUSTEXIST | $$OFN_EXPLORER
	IF multiSelect THEN ofn.flags = ofn.flags | $$OFN_ALLOWMULTISELECT
	' Guy-28oct09-allow to open "Read Only" (no lock) the selected file(s).
	IF readOnly THEN
		' show the check box "Read Only"
		ofn.flags = ofn.flags | $$OFN_READONLY		' causes the check box "Read Only" to be checked initially
	ELSE
		ofn.flags = ofn.flags | $$OFN_HIDEREADONLY		' hide the check box "Read Only"
	ENDIF

	ofn.lpstrDefExt = &initExt$
	ofn.hwndOwner = parent		' owner's handle
	ofn.hInstance = GetModuleHandleA (0)

	' ==================================================
	' IFZ GetOpenFileNameA (&ofn) THEN RETURN ""
	ret = GetOpenFileNameA (&ofn)		' fire off dialog
	' ==================================================
	IFZ ret THEN		' fail
		TellDialogError (parent, title$)
		RETURN ""		' fail
	ENDIF

	IFF multiSelect THEN
		ret$ = CSTRING$ (ofn.lpstrFile)
		RETURN ret$
	ENDIF

	' build a list of selected files, separated by ";"
	ret$ = ""
	p = ofn.lpstrFile
	DO
		DO
			ret$ = ret$ + CHR$ (UBYTEAT (p))
			INC p
		LOOP WHILE UBYTEAT (p)
		ret$ = ret$ + ";"
		INC p
	LOOP WHILE UBYTEAT (p)

	RETURN RCLIP$ (ret$)

END FUNCTION
'
' #################################
' #####  WinXDialog_Question  #####
' #################################
' Displays a dialog asking the user a question
' hWnd          = the handle to the owner window or 0 for none
' text$         = the question
' title$        = the dialog box title
' cancel        = $$TRUE to enable the cancel button
' defaultButton = the zero-based index of the default button
' returns the idCtr of the button the user selected
'
' Usage:
'	title$ = "Save File"
'	text$ = "Do you confirm?"
'	mret = WinXDialog_Question (#winMain, text$, title$, $$FALSE, 1) ' default to the 'No' button
'	SELECT CASE mret
'		CASE $$IDYES ' the 'Yes' button was selected
'			MessageBoxA (#winMain, &"Confirmed", &title$, $$MB_ICONINFORMATION)
'		CASE ELSE
'			MessageBoxA (#winMain, &"Not confirmed", &title$, $$MB_ICONINFORMATION)
'	END SELECT

FUNCTION WinXDialog_Question (hWnd, text$, title$, cancel, defaultButton)
	IF cancel THEN flags = $$MB_YESNOCANCEL ELSE flags = $$MB_YESNO
	SELECT CASE defaultButton
		CASE 1 : flags = flags | $$MB_DEFBUTTON2
		CASE 2 : flags = flags | $$MB_DEFBUTTON3
	END SELECT
	flags = flags | $$MB_ICONQUESTION

	RETURN MessageBoxA (hWnd, &text$, &title$, flags)
END FUNCTION
'
' ##################################
' #####  WinXDialog_SaveFile$  #####
' ##################################
'
' Displays a SaveFile dialog box
' parent          = the handle to the parent window
' title$          = the title of the dialog box
' extensions$     = a string listing the supported extensions
' initialName$    = the name to initialise the dialog with
' overwritePrompt = $$TRUE to warn the user when they are about to overwrite a file, $$FALSE otherwise
' returns the name of the file or "" on error or cancel
FUNCTION WinXDialog_SaveFile$ (parent, title$, extensions$, initialName$, overwritePrompt)

	OPENFILENAME ofn

	ofn.lStructSize = SIZE (OPENFILENAME)
	ofn.hwndOwner = parent

	' set file filter fileFilter$ with argument extensions$
	' i.e.: extensions$ = "Image Files (*.bmp, *.jpg)|*.bmp;*.jpg"
	' .                 ==> fileFilter$ = "Image Files (*.bmp, *.jpg)0*.bmp;*.jpg00"
	fileFilter$ = TRIM$ (extensions$)
	IF RIGHT$ (fileFilter$) <> "|" THEN fileFilter$ = fileFilter$ + "|"		' add a final terminator

	defExt$ = ""
	' use the 1st extension as a default----------------vvv
	' i.e.: fileFilter$ = "Image Files (*.bmp, *.jpg)|*.bmp;*.jpg|"
	' .            posSepBeg-------------------------^     ^     ^
	' .        posSemiColumn-------------------------------+     |
	' .            posSepEnd-------------------------------------+

	' extensions$ = "Image Files (*.bmp, *.jpg)|*.bmp;*.jpg||"
	' .             |-------description--------|--pattern--|
	' - state 1 = in filter description
	' - state 2 = in filter pattern
	filterState = 1		' start with a filter description (first pair element)

	' replace all separators "|" by the NULL character
	pos = INSTR (fileFilter$, "|")
	DO WHILE pos
		'
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
						IF pos THEN defExt$ = LCLIP$ (defExt$, pos)
					ENDIF
				ENDIF
				'
				filterState = 1		' switch to the description
				'
		END SELECT
		'
		fileFilter${pos - 1} = '\0'		' replace '|' by NULL character
		pos = INSTR (fileFilter$, "|", pos + 1)		' position of the next separator '|'
	LOOP

	ofn.lpstrFilter = &fileFilter$

	' buf$ = initialName$ + NULL$ (4096 - LEN (initialName$))
	IFZ initialName$ THEN
		buf$ = NULL$ ($$MAX_PATH)
	ELSE
		buf$ = initialName$ + NULL$ ($$MAX_PATH - LEN (initialName$))
	ENDIF
	ofn.lpstrFile = &buf$
	ofn.nMaxFile = $$MAX_PATH

	ofn.lpstrTitle = &title$
	IF defExt$ <> "*" THEN ofn.lpstrDefExt = &defExt$
	IF overwritePrompt THEN ofn.flags = $$OFN_OVERWRITEPROMPT

	' IFZ GetSaveFileNameA (&ofn) THEN RETURN ""
	ret = GetSaveFileNameA (&ofn)
	IFZ ret THEN
		TellDialogError (parent, title$)
		RETURN ""		' fail
	ENDIF

	ret$ = CSTRING$ (ofn.lpstrFile)
	RETURN ret$

END FUNCTION
'
' ################################
' #####  WinXDialog_SysInfo  #####
' ################################
'
' Runs Microsoft program "System Information"
' OUT			: msInfo$	- execution path
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'	bOK = WinXDialog_SysInfo (@msInfo$) ' System Information
'	IFF bOK THEN
'		msg$ = "WinXDialog_SysInfo: Can't run System Information"
'		msg$ = msg$ + $$CRLF$ + "Execution path: " + msInfo$
'		WinXDialog_Error (msg$, "System Information", 3)
'	ENDIF
'
FUNCTION WinXDialog_SysInfo (@msInfo$)
	SECURITY_ATTRIBUTES sa		' not used

	buf$ = NULL$ ($$MAX_PATH)
	ret = GetWindowsDirectoryA (&buf$, $$MAX_PATH)
	IFZ ret THEN
		msInfo$ = ""
	ELSE
		msInfo$ = CSTRING$ (&buf$)
		msInfo$ = WinXPath_Trim$ (msInfo$)
		IF msInfo$ THEN
			WinXDir_AppendSlash (@msInfo$)		' end directory path with \
			msInfo$ = msInfo$ + "system32" + $$PathSlash$ + "msinfo32.exe"
			'
			bErr = XstFileExists (msInfo$)
			IF bErr THEN msInfo$ = ""
		ENDIF
	ENDIF

	IFZ msInfo$ THEN

		subKey$ = "SOFTWARE\\Microsoft\\Shared Tools\\MSINFO"
		info$ = "PATH"

		bOK = WinXRegistry_ReadString ($$HKEY_LOCAL_MACHINE, subKey$, info$, $$FALSE, sa, @exeDir$) ' $$FALSE: don't create if missing
		IF bOK THEN
			msInfo$ = WinXPath_Trim$ (exeDir$)
		ELSE
			subKey$ = "SOFTWARE\\Microsoft\\Shared Tools Location"
			info$ = "MSINFO"
			'
			bOK = WinXRegistry_ReadString ($$HKEY_LOCAL_MACHINE, subKey$, info$, $$FALSE, sa, @exeDir$)
			IFF bOK THEN RETURN
			'
			WinXDir_AppendSlash (@exeDir$)		' end directory path with \
			msInfo$ = exeDir$ + "msinfo32.exe"
		ENDIF
	ENDIF

	bErr = XstFileExists (msInfo$)
	IF bErr THEN RETURN

	' build the command line command$
	IF INSTR (msInfo$, " ") THEN
		' if embedded spaces, add quotes
		command$ = "\"" + msInfo$ + "\""
	ELSE
		command$ = msInfo$
	ENDIF

	SHELL (command$)		' launch command$

	RETURN $$TRUE		' success

END FUNCTION

' Ends a directory path with \
' Usage:
' dir$ = "  c:/Lonné  "
' WinXDir_AppendSlash (@dir$) ' end directory path with \
' ' result: "  c:/Lonné  " --> "c:\\Lonné\\"
FUNCTION WinXDir_AppendSlash (@dir$)

	dir$ = WinXPath_Trim$ (dir$)
	IFZ dir$ THEN RETURN		' empty
	IF RIGHT$ (dir$) <> $$PathSlash$ THEN dir$ = dir$ + $$PathSlash$

END FUNCTION

' OUT			: dir$ - directory path

' returns $$TRUE on success or $$FALSE on fail

' Usage:
' ' create a missing directory
' bOK = WinXDir_Exists (dir$)
' IFF bOK THEN
'  bOK = WinXDir_Create (dir$)
'  IFF bOK THEN
'   msg$ = "WinXDir_Create: Can't create missing directory " + dir$
'		WinXDialog_Error (msg$, "Create Directory", 3)
'  ENDIF
' ENDIF

FUNCTION WinXDir_Create (dir$)		' Creates a directory making sure that the directory is created

	dir$ = TRIM$ (dir$)
	IFZ dir$ THEN RETURN $$TRUE		' dir$ is empty

	XstPathToAbsolutePath (dir$, @dir$)		' Get the complete path

	WinXDir_AppendSlash (@dir$)		' end directory path with \
	' create all the parent folders before creating the directory
	dirLen = LEN (dir$)
	posSlash = INSTR (dir$, $$PathSlash$)		' skip the drive
	IF posSlash = dirLen THEN RETURN $$TRUE		' fail: Can't create a drive
	DO
		posFirst = posSlash + 1
		IF posFirst > dirLen THEN EXIT DO

		posSlash = INSTR (dir$, $$PathSlash$, posFirst)
		IFZ posSlash THEN EXIT DO		' should never occur!

		subDir$ = LEFT$ (dir$, posSlash)

		' determine if subDir$ exists
		bOK = WinXDir_Exists (subDir$)
		IFF bOK THEN		' directory not found
			XstMakeDirectory (subDir$)		' creating the directory subDir$
		ENDIF
	LOOP

	' determine if dir$ was created
	bOK = WinXDir_Exists (dir$)
	RETURN bOK

END FUNCTION
'
' ############################
' #####  WinXDir_Exists  #####
' ############################
'
' [WinXDir_Exists]
' Description = determine if a directory exists
' Function    = WinXDir_Exists (dir$)
' ArgCount    = 1
' Return      = $$TRUE = directory exists, $$FALSE = directory not found
' Examples    = bFound = WinXDir_Exists (dir$)
'
FUNCTION WinXDir_Exists (dir$)

	' trim the directory path
	dirToFind$ = WinXPath_Trim$ (dir$)
	IFZ dirToFind$ THEN RETURN ' empty directory

	XstGetFileAttributes (@dirToFind$, @attrib)

	' check if dirToFind$ is really directory
	IF (attrib & $$FileDirectory) = $$FileDirectory THEN RETURN $$TRUE ' success directory exists

END FUNCTION
' returns "" on fail

' Usage:
' xblDir$ = WinXDir_GetXblDir$ () ' get xblite's dir
' eg. C:\xblite\
FUNCTION WinXDir_GetXblDir$ ()		' Gets the complete path of xblite's directory
	STATIC s_xblDir$

	IF s_xblDir$ THEN RETURN s_xblDir$

	XstGetEnvironmentVariable ("XBLDIR", @dir$)
	dir$ = TRIM$ (dir$)
	IFZ dir$ THEN
		envKey$ = "Environment"
		IFZ RegOpenKeyExA ($$HKEY_CURRENT_USER, &envKey$, 0, $$KEY_READ, &hkey) THEN
			index = 0
			type = 0
			DO
				szName$ = NULL$ ($$MAX_PATH)
				lenName = LEN (szName$)
				szData$ = NULL$ ($$MAX_PATH)
				lenData = LEN (szData$)
				ret = RegEnumValueA (hkey, index, &szName$, &lenName, 0, &type, &szData$, &lenData)
				IFZ ret THEN
					subKey$ = CSTRING$ (&szName$)
					IF UCASE$ (subKey$) = "XBLDIR" THEN
						dir$ = CSTRING$ (&szData$)
						dir$ = TRIM$ (dir$)
						EXIT DO
					ENDIF
					INC index
				ENDIF
			LOOP UNTIL ret
			RegCloseKey (hkey)
		ENDIF
	ENDIF
	IFZ dir$ THEN dir$ = "C:" + $$PathSlash$ + "xblite" + $$PathSlash$

	WinXDir_AppendSlash (@dir$)		' end directory path with \
	s_xblDir$ = dir$

	RETURN s_xblDir$

END FUNCTION

' returns "" on fail

' Usage:
' xblPgmDir$ = WinXDir_GetXblProgramDir$ () ' get xblite's program dir
FUNCTION WinXDir_GetXblProgramDir$ ()		' Gets the complete path of xblite's programs' directory

	xblPgmDir$ = WinXDir_GetXblDir$ () + "programs" + $$PathSlash$
	RETURN xblPgmDir$

END FUNCTION
'
' #########################
' #####  WinXDisplay  #####
' #########################
'
' [WinXDisplay]
' Description = Displays a window for the first time
' Function    = WinXDisplay (hWnd)
' ArgCount    = 1
' Arg1        = hWnd : The handle to the window to display
' Return      = 0
' Remarks     = This function should be called after all the child controls have been added to the window.  It calls the sizing function, which is either the registered callback or the auto sizer.
' See Also    =
' Examples    = WinXDisplay (#hMain)
'
FUNCTION WinXDisplay (hWnd)
	RECT rect

	GetClientRect (hWnd, &rect)

	sizeWindow (hWnd, rect.right - rect.left, rect.bottom - rect.top)

	RETURN ShowWindow (hWnd, $$SW_SHOWNORMAL)
END FUNCTION
'
' ##########################
' #####  WinXDoEvents  #####
' ##########################
'
' [WinXDoEvents]
' Description = Processes events
' Function    = WinXDoEvents ()
' ArgCount    = 0
' Return      = $$FALSE on receiving a quit message or $$TRUE on error
' Remarks     = This function doesn't return until a quit message is received.
' See Also    =
' Examples    = WinXDoEvents ()
'
FUNCTION WinXDoEvents ()
	BINDING binding
	MSG wMsg		' will be sent to window callback function when an event occurs

	' supervise system messages until
	' - the User decides to leave the application (RETURN $$FALSE)
	' - an error occurred (RETURN $$TRUE ' fail)

	DO		' the event loop
		ret = GetMessageA (&wMsg, 0, 0, 0) ' retrieve next event from queue
		SELECT CASE ret
			CASE 0  : RETURN $$FALSE	' received a quit message
			CASE -1 : RETURN $$TRUE		' fail
			CASE ELSE
				' deal with window messages
				hWnd = GetActiveWindow ()
				'
				idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
				bOK = BINDING_Get (idBinding, @binding)
				ret = 0
				IF bOK THEN
					' process accelerator keys for menu commands
					IF binding.hAccelTable THEN ret = TranslateAcceleratorA (hWnd, binding.hAccelTable, &wMsg)
				ENDIF
				IFZ ret THEN
					IF (!IsWindow (hWnd)) || (!IsDialogMessageA (hWnd, &wMsg)) THEN
						' send only non-dialog messages
						' translate virtual-key messages into character messages
						' ex.: SHIFT + a is translated as "A"
						TranslateMessage (&wMsg)
						DispatchMessageA (&wMsg) ' send message to window callback function
					ENDIF
				ENDIF
		END SELECT
	LOOP		' forever

END FUNCTION
'
' #########################
' #####  WinXDrawArc  #####
' #########################
' Draws an arc
FUNCTION WinXDrawArc (hWnd, hPen, x1, y1, x2, y2, DOUBLE theta1, DOUBLE theta2)
	AUTODRAWRECORD record
	BINDING binding

	halfW = (x2 - x1) / 2
	halfH = (y2 - y1) / 2

	' normalise the angles
	theta1 = theta1 - (INT (theta1 / $$TWOPI) * $$TWOPI)
	theta2 = theta2 - (INT (theta2 / $$TWOPI) * $$TWOPI)

	SELECT CASE theta1
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
			IF theta1 + $$PIDIV2 > $$PI THEN a1# = - halfW ELSE a1# = halfW
			o1# = a1# * Tan (theta1)
			IF ABS (o1#) > halfH THEN
				IF theta1 > $$PI THEN o1# = - halfH ELSE o1# = halfH
				a1# = o1# / Tan (theta1)
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
			a2# = - halfW
			o2# = 0
		CASE $$PI3DIV2
			a2# = 0
			o2# = - halfH
		CASE ELSE
			IF theta2 + $$PIDIV2 > $$PI THEN a2# = - halfW ELSE a2# = halfW
			o2# = a2# * Tan (theta2)
			IF ABS (o2#) > halfH THEN
				IF theta2 > $$PI THEN o2# = - halfH ELSE o2# = halfH
				a2# = o2# / Tan (theta2)
			ENDIF
	END SELECT

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

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
	BINDING_Update (idBinding, binding)

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
	AUTODRAWRECORD record
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

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
	BINDING_Update (idBinding, binding)

	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
END FUNCTION
'
' #############################
' #####  WinXDrawEllipse  #####
' #############################
' Draws an ellipse
FUNCTION WinXDrawEllipse (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD record
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

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
	BINDING_Update (idBinding, binding)

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
	AUTODRAWRECORD record
	BINDING binding
	RECT rect

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

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
	BINDING_Update (idBinding, binding)

	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
END FUNCTION
'
' #############################
' #####  WinXDrawEllipse  #####
' #############################
' Draws an ellipse
' hWnd = the window to draw the ellipse on
' hPen and hBrush = the handles to the pen and brush to use
' x1, y1, x2, y2 = the coordinates of the ellipse
' returns the idCtr of the ellipse
FUNCTION WinXDrawFilledEllipse (hWnd, hPen, hBrush, x1, y1, x2, y2)
	AUTODRAWRECORD record
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

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
	BINDING_Update (idBinding, binding)

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
' returns the idCtr of the filled rectangle
FUNCTION WinXDrawFilledRect (hWnd, hPen, hBrush, x1, y1, x2, y2)
	AUTODRAWRECORD record
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

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
	BINDING_Update (idBinding, binding)

	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
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
	AUTODRAWRECORD record
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

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
	BINDING_Update (idBinding, binding)

	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
END FUNCTION
'
' ##########################
' #####  WinXDrawLine  #####
' ##########################
' Draws a line
' hWnd = the handle to the window to draw to
' hPen = a handle to a pen to draw the line with
' x1, y1, x2, y2 = the coordinates of the line
' returns the idCtr of the line
FUNCTION WinXDrawLine (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD record
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

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
	BINDING_Update (idBinding, binding)

	idNew = AUTODRAWRECORD_New (record)
	IF idNew > 0 THEN
		autoDraw_add (binding.autoDrawInfo, idNew)
	ENDIF
	RETURN idNew
END FUNCTION
'
' ##########################
' #####  WinXDrawRect  #####
' ##########################
' Draws a rectangle
FUNCTION WinXDrawRect (hWnd, hPen, x1, y1, x2, y2)
	AUTODRAWRECORD record
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

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
	BINDING_Update (idBinding, binding)

	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
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
	AUTODRAWRECORD record
	BINDING binding
	TEXTMETRIC tm
	SIZEAPI size

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	hDC = CreateCompatibleDC (0)
	SelectObject (hDC, hFont)
	GetTextExtentPoint32A (hDC, &text, LEN (text), &size)
	DeleteDC (hDC)

	record.hUpdateRegion = CreateRectRgn (x - 1, y - 1, x + size.cx + 1, y + size.cy + 1)
	record.hFont = hFont
	record.text.x = x
	record.text.y = y
	record.text.iString = STRING_New (text)
	record.text.forColour = forCol
	record.text.backColour = backCol

	record.draw = &drawText ()

	IF binding.hUpdateRegion THEN
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
	ELSE
		binding.hUpdateRegion = record.hUpdateRegion
	ENDIF
	BINDING_Update (idBinding, binding)

	ret = AUTODRAWRECORD_New (record)
	autoDraw_add (binding.autoDrawInfo, ret)
	RETURN ret
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

	IFZ GetObjectA (hImage, SIZE (BITMAP), &bmpSrc) THEN RETURN
	hBmpRet = WinXDraw_CreateImage (bmpSrc.width, bmpSrc.height)
	IFZ hBmpRet THEN RETURN
	IFZ GetObjectA (hBmpRet, SIZE (BITMAP), &bmpDst) THEN RETURN

	RtlMoveMemory (bmpDst.bits, bmpSrc.bits, (bmpDst.width * bmpDst.height) << 2)

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

	bmih.biSize = SIZE (BITMAPINFOHEADER)
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
' Deletes an image
' hImage = the image to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_DeleteImage (hImage)
	IFZ DeleteObject (hImage) THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ###############################
' #####  WinXDrawGetColour  #####
' ###############################
' Displays a dialog box allowing the user to select a color
' initialColour = the color to initialise the dialog box with
' returns the color the user selected
FUNCTION WinXDraw_GetColour (parent, initialColour)
	SHARED customColours[]

	CHOOSECOLOR cc

	IFZ customColours[] THEN
		' init the custom colours
		DIM customColours[15]
		FOR i = 0 TO 15
			customColours[i] = 0x00FFFFFF
		NEXT i
	ENDIF

	cc.lStructSize = SIZE (CHOOSECOLOR)
	cc.hwndOwner = parent
	cc.rgbResult = initialColour
	cc.lpCustColors = &customColours[]
	cc.flags = $$CC_RGBINIT
	ChooseColorA (&cc)
	RETURN cc.rgbResult
END FUNCTION
'
' ################################
' #####  WinXFont_GetDialog  #####
' ################################
' Displays the get font dialog box
' parent = the owner of the dialog
' LogFont = the LOGFONT structure to store initialise the dialog and store the output
' color = the color of the returned font
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_GetFontDialog (parent, LOGFONT logFont, @color)
	CHOOSEFONT chf

	chf.lStructSize = SIZE (CHOOSEFONT)
	chf.hwndOwner = parent
	chf.lpLogFont = &logFont

	' - $$CF_EFFECTS            : allows to select strikeout, underline, and color options
	' - $$CF_SCREENFONTS        : causes dialog to show up
	' - $$CF_INITTOLOGFONTSTRUCT: initial settings shows up when the dialog appears
	chf.flags = $$CF_EFFECTS | $$CF_SCREENFONTS | $$CF_INITTOLOGFONTSTRUCT

	chf.rgbColors = color

	' create a Font dialog box that enables the User to choose attributes
	' for a logical font; these attributes include a typeface name, style
	' (bold, italic, or regular), point size, effects (underline,
	' strikeout, and text color), and a script (or character set)
	ret = ChooseFontA (&chf)
	IFZ ret THEN RETURN

	logFont.height = ABS (logFont.height)
	color = chf.rgbColors
	RETURN $$TRUE		' success
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
'
' ######################################
' #####  WinXDraw_GetImageChannel  #####
' ######################################
' Retrieves on of the channels of a WinX image
' hImage =  the handle of the image
' channel = the channel if, 0 for blue, 1 for green, 2 for red, 3 for alpha
' r_data[] =  the UBYTE array to store the channel data
' returns $$TRUE on success or $$FALSE on fail, dimensions r_data[] appropriately
FUNCTION WinXDraw_GetImageChannel (hImage, channel, UBYTE r_data[])
	BITMAP bmp
	ULONG pixel

	' reset the returned array
	DIM r_data[]

	IFZ hImage THEN RETURN
	IF channel < 0 || channel > 3 THEN RETURN
	IFZ GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN RETURN

	downshift = channel << 3

	maxPixel = bmp.width * bmp.height - 1
	DIM r_data[maxPixel]
	FOR i = 0 TO maxPixel
		pixel = ULONGAT (bmp.bits, i << 2)
		r_data[i] = UBYTE ((pixel >> downshift) AND 0x000000FF)
	NEXT i

	RETURN $$TRUE		' success
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
	IFZ GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN RETURN

	w = bmp.width
	h = bmp.height
	pBits = bmp.bits
	RETURN $$TRUE		' success
END FUNCTION
'
' ####################################
' #####  WinXDraw_GetImagePixel  #####
' ####################################
' Gets a pixel on WinX image
' hImage =  the handle to the image
' x, y = the x and y coordinates of the pixel
' returns the color at the point or 0 on fail
FUNCTION WINX_RGBA WinXDraw_GetImagePixel (hImage, x, y)
	BITMAP bmp
	WINX_RGBA ret

	IFZ GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN RETURN
	IF x < 0 || x >= bmp.width || y < 0 || y >= bmp.height THEN RETURN
	ULONGAT (&ret) = ULONGAT (bmp.bits, ((bmp.height - 1 - y) * bmp.width + x) << 2)
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
	GetTextExtentExPointA (hDC, &text, LEN (text), maxWidth, &fit, 0, &size)
	DeleteDC (hDC)

	IF (maxWidth = -1) || (fit >= LEN (text)) THEN RETURN size.cx ELSE RETURN - fit
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
			' first, load the bitmap
			hBmpTmp = LoadImageA (0, &fileName, $$IMAGE_BITMAP, 0, 0, $$LR_DEFAULTCOLOR | $$LR_CREATEDIBSECTION | $$LR_LOADFROMFILE)
			' now copy it to a standard format
			GetObjectA (hBmpTmp, SIZE (BITMAP), &bmp)
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
			' and return
			RETURN hBmpRet
	END SELECT

	RETURN
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
	LOGFONT logFont

	logFont.height = height
	logFont.width = 0
	IF style AND $$FONT_BOLD THEN logFont.weight = $$FW_BOLD ELSE logFont.weight = $$FW_NORMAL
	IF style AND $$FONT_ITALIC THEN logFont.italic = 1 ELSE logFont.italic = 0
	IF style AND $$FONT_UNDERLINE THEN logFont.underline = 1 ELSE logFont.underline = 0
	IF style AND $$FONT_STRIKEOUT THEN logFont.strikeOut = 1 ELSE logFont.strikeOut = 0
	logFont.charSet = $$DEFAULT_CHARSET
	logFont.outPrecision = $$OUT_DEFAULT_PRECIS
	logFont.clipPrecision = $$CLIP_DEFAULT_PRECIS
	logFont.quality = $$DEFAULT_QUALITY
	logFont.pitchAndFamily = $$DEFAULT_PITCH | $$FF_DONTCARE
	logFont.faceName = NULL$ (32)
	logFont.faceName = LEFT$ (font, 31)

	RETURN logFont
END FUNCTION
'
' #####################################
' #####  WinXDraw_PixelsPerPoint  #####
' #####################################
' gets the conversion factor between screen pixels and points
FUNCTION DOUBLE WinXDraw_PixelsPerPoint ()
	hDC = GetDC (GetDesktopWindow ())
	cvtHeight# = DOUBLE (GetDeviceCaps (hDC, $$LOGPIXELSY)) / 72.0
	ReleaseDC (GetDesktopWindow (), hDC)
	RETURN cvtHeight#
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
	WINX_RGBA rgba

	IFZ GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN RETURN

	maxPixel = bmp.width * bmp.height - 1
	FOR i = 0 TO maxPixel
		' get pixel
		ULONGAT (&rgba) = ULONGAT (bmp.bits, i << 2)
		rgba.blue = UBYTE ((XLONG (rgba.blue) * XLONG (rgba.alpha)) \ 255)
		rgba.green = UBYTE ((XLONG (rgba.green) * XLONG (rgba.alpha)) \ 255)
		rgba.red = UBYTE ((XLONG (rgba.red) * XLONG (rgba.alpha)) \ 255)
		ULONGAT (bmp.bits, i << 2) = ULONGAT (&rgba)
	NEXT i

	RETURN $$TRUE		' success
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

	IFZ GetObjectA (hImage, SIZE (BITMAP), &bmpSrc) THEN RETURN
	hBmpRet = WinXDraw_CreateImage (w, h)
	IFZ hBmpRet THEN RETURN
	IFZ GetObjectA (hBmpRet, SIZE (BITMAP), &bmpDst) THEN RETURN

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
			IFZ GetObjectA (hImage, SIZE (bmp), &bmp) THEN RETURN
			file = OPEN (fileName, $$WRNEW)
			IF file = -1 THEN RETURN

			bmfh.bfType = 0x4D42
			bmfh.bfSize = SIZE (BITMAPFILEHEADER) + SIZE (BITMAPINFOHEADER) + (bmp.widthBytes * bmp.height)
			bmfh.bfOffBits = SIZE (BITMAPFILEHEADER) + SIZE (BITMAPINFOHEADER)

			bmih.biSize = SIZE (BITMAPINFOHEADER)
			bmih.biWidth = bmp.width
			bmih.biHeight = bmp.height
			bmih.biPlanes = bmp.planes
			bmih.biBitCount = bmp.bitsPixel
			bmih.biCompression = $$BI_RGB

			WRITE[file], bmfh
			WRITE[file], bmih
			XstBinWrite (file, bmp.bits, bmp.widthBytes * bmp.height)
			CLOSE (file)

			RETURN $$TRUE		' success
	END SELECT
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

	IF alpha < 0 || alpha > 1 THEN RETURN
	IFZ GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN RETURN

	intAlpha = ULONG (alpha * 255.0) << 24

	maxPixel = bmp.width * bmp.height - 1
	FOR i = 0 TO maxPixel
		ULONGAT (bmp.bits, i << 2) = (ULONGAT (bmp.bits, i << 2) AND 0x00FFFFFFFF) | intAlpha
	NEXT i

	RETURN $$TRUE		' success
END FUNCTION
'
' ######################################
' #####  WinXDraw_SetImageChannel  #####
' ######################################
' Sets one of the channels of a WinX image
' hImage = the handle to the image
' channel = the channel idCtr, 0 for blue, 1 for green, 2 for red, 3 for alpha
' data[] = the channel data, a single dimensional UBYTE array containing the channel data
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_SetImageChannel (hImage, channel, UBYTE data[])
	BITMAP bmp

	IF channel < 0 || channel > 3 THEN RETURN
	IFZ GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN RETURN

	upshift = channel << 3
	mask = NOT (255 << upshift)

	maxPixel = bmp.width * bmp.height - 1
	IF maxPixel <> UBOUND (data[]) THEN RETURN
	FOR i = 0 TO maxPixel
		ULONGAT (bmp.bits, i << 2) = (ULONGAT (bmp.bits, i << 2) AND mask) | ULONG (data[i]) << upshift
	NEXT i

	RETURN $$TRUE		' success
END FUNCTION
'
' ####################################
' #####  WinXDraw_SetImagePixel  #####
' ####################################
' Sets a pixel on a WinX image
' hImage = the handle to the image
' x, y = the coordinates of the pixel
' color = the color for the pixel
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXDraw_SetImagePixel (hImage, x, y, color)
	BITMAP bmp

	IFZ GetObjectA (hImage, SIZE (BITMAP), &bmp) THEN RETURN
	IF x < 0 || x >= bmp.width || y < 0 || y >= bmp.height THEN RETURN
	ULONGAT (bmp.bits, ((bmp.height - 1 - y) * bmp.width + x) << 2) = color

	RETURN $$TRUE		' success
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
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	hDC = CreateCompatibleDC (0)
	hOld = SelectObject (hDC, hImage)
	autoDraw_draw (hDC, binding.autoDrawInfo, x, y)
	SelectObject (hDC, hOld)
	DeleteDC (hDC)

	RETURN $$TRUE		' success
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
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.useDialogInterface = enable
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXFolder_GetDir$  #####
' ################################
' Gets the qualified path for a Windows special folder
' nFolder = the Windows' special folder
' returns the qualified path, or "" on error
'
' Usage:
'' get the qualified path of folder "My Documents"
' dir$ = WinXFolder_GetDir$ ($$CSIDL_PERSONAL)
'
FUNCTION WinXFolder_GetDir$ (nFolder)		' get the path for a Windows special folder

	ITEMIDLIST idl

	IF nFolder < $$CSIDL_DESKTOP || nFolder > $$CSIDL_ADMINTOOLS THEN nFolder = $$CSIDL_DESKTOP

	' Fill the item idCtr list with the pointer of each folder item, returns 0 on success
	rc = SHGetSpecialFolderLocation (0, nFolder, &idl)
	IF rc THEN RETURN ""		' fail (0 is for OK!)

	' Get the path from the item idCtr list pointer
	buf$ = NULL$ ($$MAX_PATH)
	ret = SHGetPathFromIDListA (idl.mkid.cb, &buf$)
	IFZ ret THEN RETURN ""		' fail

	directory$ = CSTRING$ (&buf$)
	WinXDir_AppendSlash (@directory$) ' append a \ to indicate a directory vs a file
	RETURN directory$

END FUNCTION
'
' ############################
' #####  WinXGetMinSize  #####
' ############################
' Gets the minimum size for a window
' hWnd = the window handle
' w and h = the minimum width and height of the client area
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXGetMinSize (hWnd, @w, @h)
	BINDING binding

	w = 0
	h = 0
	IFZ hWnd THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	w = binding.minW
	IF w < 130 THEN w = 130
	h = binding.minH
	IF h < 30 THEN h = 30
	RETURN $$TRUE		' success
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
	RETURN $$TRUE		' success
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

	wp.length = SIZE (WINDOWPLACEMENT)
	IFZ GetWindowPlacement (hWnd, &wp) THEN RETURN

	restored = wp.rcNormalPosition
	minMax = wp.showCmd

	RETURN $$TRUE		' success
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
	buffer$ = NULL$ (cc + 1)
	GetWindowTextA (hWnd, &buffer$, cc + 1)
	text$ = CSTRING$ (&buffer$)
	RETURN text$
END FUNCTION
'
' ################################
' #####  WinXGetUseableRect  #####
' ################################
' Gets a rect describing the usable portion of a window's client area,
' that is, the portion not obscured with a toolbar or status bar
' hWnd = the handle to the window to get the rect for
' rect = the variable to hold the rect structure
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXGetUseableRect (hWnd, RECT rect)
	BINDING binding
	RECT rect2

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	GetClientRect (hWnd, &rect)
	IF binding.hBar THEN
		GetClientRect (binding.hBar, &rect2)
		rect.top = rect.top + (rect2.bottom - rect2.top) + 2
	ENDIF

	IF binding.hStatus THEN
		GetClientRect (binding.hStatus, &rect2)
		rect.bottom = rect.bottom - (rect2.bottom - rect2.top)
	ENDIF

	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  WinXGetWindowEffRect  #####
' ##################################
' hWnd = the handle to the window
' rect = the effective rectangle
FUNCTION WinXGetWindowEffRect (hWnd, RECT rect) ' get the window's effective rectangle

	rect.left = 0
	rect.top = 0
	rect.right = 0
	rect.bottom = 0
	IFZ hWnd THEN RETURN

	ret = GetWindowRect (hWnd, &rect)
	IFZ ret THEN RETURN

	style = GetWindowLongA (hWnd, $$GWL_STYLE)
	menu = GetMenu (hWnd)
	IFZ menu THEN fMenu = 0 ELSE fMenu = 1
	exStyle = GetWindowLongA (hWnd, $$GWL_EXSTYLE)
	AdjustWindowRectEx (&rect, style, fMenu, exStyle)

	IF (style & $$WS_VSCROLL) = $$WS_VSCROLL THEN
		rect.right = rect.right + GetSystemMetrics ($$SM_CXVSCROLL)	' width vertical scroll bar
	ENDIF
	IF (style & $$WS_HSCROLL) = $$WS_HSCROLL THEN
		rect.bottom = rect.bottom + GetSystemMetrics ($$SM_CXHSCROLL)	' width horizontal scroll bar
	ENDIF

	RETURN $$TRUE ' success

END FUNCTION
'
' #############################################
' #####  WinXGroupBox_GetAutosizerSeries  #####
' #############################################
' Gets the auto sizer series for a group box
' hGB = the handle to the group box
' returns the series on success or 0 on fail
FUNCTION WinXGroupBox_GetAutosizerSeries (hGB)
	IFZ hGB THEN RETURN
	RETURN GetPropA (hGB, &"WinXAutoSizerSeries")
END FUNCTION
'
' Guy-06may11-corrected
' returns $$TRUE on success or $$FALSE on fail
'FUNCTION WinXGroupBox_GetAutosizerSeries (hGB)
'	ret = GetPropA (hGB, &"WinXAutoSizerSeries")
'	IFZ ret THEN RETURN
'	RETURN $$TRUE		' success
'END FUNCTION
'
' ######################
' #####  WinXHide  #####
' ######################
' Hides a window or control
' hWnd = the handle to the control or window to hide
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXHide (hWnd)
	ShowWindow (hWnd, $$SW_HIDE)
	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  WinXIni_Delete  #####
' ############################
'
' [WinXIni_Delete]
' Description = delete an information from an .INI file
' Function    = WinXIni_Delete (iniPath$, section$, key$)
' ArgCount    = 3
' iniPath$    = the .INI file path
' section$    = the passed section
' key$        = the key to delete
' Return      = $$FALSE = failure, $$TRUE = success
' Examples    = bDeleted = WinXIni_Delete (iniPath$, section$, key$)
'
FUNCTION WinXIni_Delete (iniPath$, section$, key$)

	iniPath$ = WinXPath_Trim$ (iniPath$)
	IFZ iniPath$ THEN RETURN

	section$ = TRIM$ (section$)
	IFZ section$ THEN RETURN

	key$ = TRIM$ (key$)
	IFZ key$ THEN RETURN

	' passing argument lpString set to zero causes the key deletion
	SetLastError (0)
	ret = WritePrivateProfileStringA (&section$, &key$, 0, &iniPath$)
	IFZ ret THEN RETURN

	RETURN $$TRUE		' success

END FUNCTION
'
' ###################################
' #####  WinXIni_DeleteSection  #####
' ###################################
'
' Description = delete an information from an .INI file
' iniPath$    = the .INI file path
' section$    = the passed section
' key$        = the key to delete
' Return      = $$FALSE = failure, $$TRUE = sucess
' Examples    = bDeleted = WinXIni_DeleteSection (iniPath$, section$, key$)

FUNCTION WinXIni_DeleteSection (iniPath$, section$)

	IFZ TRIM$ (iniPath$) THEN RETURN
	IFZ TRIM$ (section$) THEN RETURN

	' passing key$=0 and value$=0 causes the section deletion
	ret = WritePrivateProfileStringA (&section$, 0, 0, &iniPath$)
	IFZ ret THEN RETURN

	RETURN $$TRUE		' success

END FUNCTION
'
' #################################
' #####  WinXIni_LoadKeyList  #####
' #################################
'
' load all key names of a given section
'
FUNCTION WinXIni_LoadKeyList (iniPath$, curSec$, @r_asKey$[])

	' reset the returned array
	DIM r_asKey$[]

	bracketed$ = "[" + TRIM$ (curSec$) + "]" '  [section]
	IF bracketed$ = "[]" THEN RETURN		' fail
	IFZ TRIM$ (iniPath$) THEN RETURN		' fail

	' open read the .INI file
	iniFile = OPEN (iniPath$, $$RD)
	IF iniFile < 3 THEN RETURN ' error

	' look for the section curSec$
	bSecFound = $$FALSE ' assume section curSec$ not found
	IFF EOF (iniFile) THEN
		DO
			line$ = INFILE$ (iniFile)
			IF EOF (iniFile) THEN EXIT DO		' end of file
			'
			line$ = TRIM$ (line$)
			IFZ line$ THEN DO DO ' skip an empty line
			'
			IF LEFT$ (line$) <> "[" THEN DO DO ' not a section
			IF RIGHT$ (line$) <> "]" THEN DO DO ' not a section
			'
			' trying section line$ == bracketed$
			IF line$ = bracketed$ THEN
				bSecFound = $$TRUE ' section curSec$ found
				EXIT DO
			ENDIF
			'
		LOOP
	ENDIF
	IFF bSecFound THEN RETURN $$TRUE ' section curSec$ not found

	DIM r_asKey$[7]
	upper_slot = 7
	slot = -1
	DO
		line$ = INFILE$ (iniFile)
		IF EOF (iniFile) THEN EXIT DO		' end of file
		'
		line$ = TRIM$ (line$)
		IFZ line$ THEN DO DO ' skip an empty line
		IF LEFT$ (line$) =";" THEN DO DO '  ' skip a comment
		'
		IF LEFT$ (line$) = "[" THEN EXIT DO ' end of section curSec$
		'
		' Parsing key line line$, e.g. key=value
		pos = INSTR (line$, "=", 1)
		IFZ pos THEN DO DO
		'
		key$ = TRIM$ (LEFT$ (line$, pos - 1))
		IFZ key$ THEN DO DO
		'
		' add key to r_asKey$[]
		INC slot
		IF slot > upper_slot THEN
			' expand r_asKey$[]
			upper_slot = ((upper_slot + 1) << 1) - 1
			REDIM r_asKey$[upper_slot]
		ENDIF
		r_asKey$[slot] = key$
		'
	LOOP
	IF slot < 0 THEN
		DIM r_asKey$[]
	ELSE
		IF slot < upper_slot THEN REDIM r_asKey$[slot]
	ENDIF

	RETURN $$TRUE		' OK!

END FUNCTION
'
' #####################################
' #####  WinXIni_LoadSectionList  #####
' #####################################
'
' load all section names
' Returns $$TRUE on success
'
FUNCTION WinXIni_LoadSectionList (iniPath$, @r_asSec$[])

	' reset the returned array
	DIM r_asSec$[]

	' open read the .INI file
	iniFile = OPEN (iniPath$, $$RD)
	IF iniFile < 3 THEN RETURN ' fail

	DIM r_asSec$[7]
	upper_slot = 7
	slot = -1

	IFF EOF (iniFile) THEN
		DO
			line$ = INFILE$ (iniFile)
			IF EOF (iniFile) THEN EXIT DO		' end of file
			'
			line$ = TRIM$ (line$)
			IFZ line$ THEN DO DO ' skip an empty line
			'
			IF LEFT$ (line$) <> "[" THEN DO DO ' not a section
			IF RIGHT$ (line$) <> "]" THEN DO DO ' not a section
			'
			' add section to r_asSec$[]
			INC slot
			IF slot > upper_slot THEN
				' expand r_asSec$[]
				upper_slot = ((upper_slot + 1) << 1) - 1
				REDIM r_asSec$[upper_slot]
			ENDIF
			'
			' trim off the brackets
			cCh = LEN (line$) - 2
			r_asSec$[slot] = MID$ (line$, 2, cCh)
			'
		LOOP
	ENDIF

	IF slot < 0 THEN
		DIM r_asSec$[]
	ELSE
		IF slot < upper_slot THEN REDIM r_asSec$[slot]
	ENDIF

	RETURN $$TRUE		' success

END FUNCTION
'
' ###########################
' #####  WinXIni_Read$  #####
' ###########################
'
' [WinXIni_Read$]
' Description = read an information from an .INI file
' Function    = WinXIni_Read$ (iniPath$, section$, key$, defVal$)
' ArgCount    = 4
' iniPath$    = the .INI file path
' section$    = the passed section
' key$        = the key to read from
' defVal$     = a default value
' Return      = defVal$ = failure, read value = success
' Examples    = value$ = WinXIni_Read$ (iniPath$, $$MRU_SECTION$, key$, "")
'
FUNCTION WinXIni_Read$ (iniPath$, section$, key$, defVal$)

	iniPath$ = WinXPath_Trim$ (iniPath$)
	IFZ iniPath$ THEN RETURN defVal$

	bErr = XstFileExists (iniPath$)
	IF bErr THEN RETURN defVal$ ' file NOT found

	section$ = TRIM$ (section$)
	IFZ section$ THEN RETURN defVal$

	' read from the INI file
	'bufSize = $$MAX_PATH
	bufSize = 4095
	buf$ = NULL$ (bufSize)
	SetLastError (0)
	cCh = GetPrivateProfileStringA (&section$, &key$, &defVal$, &buf$, bufSize, &iniPath$)
	IF cCh < 1 THEN RETURN defVal$		' default value returned

	' value$ = CSTRING$ (&buf$)
	value$ = LEFT$ (buf$, cCh)
	RETURN value$

END FUNCTION
'
' ###########################
' #####  WinXIni_Write  #####
' ###########################
'
' [WinXIni_Write]
' Description = write an information into an .INI file
' Function    = WinXIni_Write (iniPath$, section$, key$, value$)
' ArgCount    = 4
' iniPath$    = the .INI file path
' section$    = the passed section
' key$        = the information's key
' value$      = the information
' Return      = $$FALSE = failure, $$TRUE = success
' Examples    = WinXIni_Write (iniPath$, $$MRU_SECTION$, key$, fPath$)
'
FUNCTION WinXIni_Write (iniPath$, section$, key$, value$)

	iniPath$ = WinXPath_Trim$ (iniPath$)
	IFZ iniPath$ THEN RETURN

	section$ = TRIM$ (section$)
	IFZ section$ THEN RETURN

	key$ = TRIM$ (key$)
	IFZ key$ THEN RETURN

	ret = WritePrivateProfileStringA (&section$, &key$, &value$, &iniPath$)
	IFZ ret THEN RETURN

	RETURN $$TRUE		' success

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
	IFZ GetKeyState (key) AND 0x8000 THEN RETURN $$FALSE ELSE RETURN $$TRUE		' key pressed
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
			' we need to take into account the possibility that the mouse buttons are swapped
			IF GetSystemMetrics ($$SM_SWAPBUTTON) THEN vk = $$VK_RBUTTON ELSE vk = $$VK_LBUTTON
		CASE $$MBT_MIDDLE
			vk = $$VK_MBUTTON
		CASE $$MBT_RIGHT
			IF GetSystemMetrics ($$SM_SWAPBUTTON) THEN vk = $$VK_LBUTTON ELSE vk = $$VK_RBUTTON
	END SELECT

	IFZ GetAsyncKeyState (vk) THEN RETURN $$FALSE ELSE RETURN $$TRUE		' button pressed
END FUNCTION
'
' ##########################
' #####  WinXKillFont  #####
' ##########################
'
' release a font created by WinXNewFont
' hFont = the handle of the logical font
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXKillFont (@hFont)

	IFZ hFont THEN RETURN ' fail

	ret = DeleteObject (hFont) ' release the font
	hFont = 0
	RETURN $$TRUE ' success

END FUNCTION
'
' #################################
' #####  WinXListBox_AddItem  #####
' #################################
' Adds an item to a list box.
' hListBox = the list box to add to
' index = the zero-based index to insert the item at, -1 for the end of the list
' item$ = the string to add to the list
' returns the index of the string in the list or -1 on fail
FUNCTION WinXListBox_AddItem (hListBox, index, item$)
	IFZ hListBox THEN RETURN $$LB_ERR		' fail

	IF GetWindowLongA (hListBox, $$GWL_STYLE) AND $$LBS_SORT THEN
		RETURN SendMessageA (hListBox, $$LB_ADDSTRING, 0, &item$)
	ELSE
		IF index < 0 THEN index = -1
		RETURN SendMessageA (hListBox, $$LB_INSERTSTRING, index, &item$)
	ENDIF
END FUNCTION
'
' ########################################
' #####  WinXListBox_EnableDragging  #####
' ########################################
' Enables dragging on a list box.  Make sure to register the FnOnDrag callback as well
' hListBox = the handle to the list box to enable dragging on
' reuturns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListBox_EnableDragging (hListBox)
	SHARED DLM_MESSAGE

	IFZ hListBox THEN RETURN

	IFZ MakeDragList (hListBox) RETURN $$FALSE
	DLM_MESSAGE = RegisterWindowMessageA (&$$DRAGLISTMSGSTRING)
	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  WinXListBox_GetIndex  #####
' ##################################
' Gets the index of a particular string
' hListBox = the handle to the list box containing the string
' item$ = the string to search for
' returns the index of the item or $$LB_ERR on fail
FUNCTION WinXListBox_GetIndex (hListBox, item$)
	IFZ hListBox THEN RETURN $$LB_ERR		' fail
	IFZ item$ THEN RETURN $$LB_ERR		' fail

	' get count of items in listbox
	count = SendMessageA (hListBox, $$LB_GETCOUNT, 0, 0)
	IF count < 1 THEN RETURN $$LB_ERR		' empty listbox

	' Guy-17jun11-RETURN SendMessageA (hListBox, $$LB_FINDSTRINGEXACT, -1, &item$) ' find case INSENSITIVE

	item_length = LEN (item$)
	idxFound = -1
	DO
		indexStart = idxFound
		idxFound = SendMessageA (hListBox, $$LB_FINDSTRING, indexStart, &item$)
		IF idxFound < 0 THEN RETURN $$LB_ERR
		IF idxFound = indexStart THEN RETURN $$LB_ERR
		'
		found$ = WinXListBox_GetItem$ (hListBox, idxFound)
		'
		IF LEFT$ (found$, item_length) = item$ THEN RETURN idxFound		' found!
	LOOP
	RETURN $$LB_ERR		' fail

END FUNCTION
'
' ##################################
' #####  WinXListBox_GetItem$  #####
' ##################################
' Gets a list box item
' hListBox = the handle to the list box to get the item from
' index = the index of the item to get
' returns the string of the item, or "" on fail
FUNCTION WinXListBox_GetItem$ (hListBox, index)
	IFZ hListBox THEN RETURN ""		' fail

	sizeBuf = SendMessageA (hListBox, $$LB_GETTEXTLEN, index, 0) + 2 ' note bump 2!
	szBuf$ = NULL$ (sizeBuf)
	SendMessageA (hListBox, $$LB_GETTEXT, index, &szBuf$)
	RETURN CSTRING$ (&szBuf$)
END FUNCTION
'
' ######################################
' #####  WinXListBox_GetSelection  #####
' ######################################
' Gets the selected items in a list box
' hListBox = the list box to get the items from
' r_index[] = the array to place the items into
' returns the number of selected items
FUNCTION WinXListBox_GetSelection (hListBox, r_index[])

	DIM r_index[]
	cItem = 0
	IFZ hListBox THEN RETURN

	style = GetWindowLongA (hListBox, $$GWL_STYLE)
	SELECT CASE style AND $$LBS_EXTENDEDSEL
		CASE $$LBS_EXTENDEDSEL		' multi-selections
			cItem = SendMessageA (hListBox, $$LB_GETSELCOUNT, 0, 0)
			IF cItem > 0 THEN
				DIM r_index[cItem - 1]
				SendMessageA (hListBox, $$LB_GETSELITEMS, cItem, &r_index[0])
			ENDIF
			'
		CASE ELSE		' mono-selection
			selItem = SendMessageA (hListBox, $$LB_GETCURSEL, 0, 0)
			IF selItem >= 0 THEN
				DIM r_index[0]
				r_index[0] = selItem
				cItem = 1
			ENDIF
			'
	END SELECT

	RETURN cItem
END FUNCTION
'
' ####################################
' #####  WinXListBox_RemoveItem  #####
' ####################################
' removes an item from a list box
' hListBox = the list box to remove from
' index = the index of the item to remove, -1 to remove the last item
' returns the number of strings remaining in the list or -1 if index is out of range
FUNCTION WinXListBox_RemoveItem (hListBox, index)
	IFZ hListBox THEN RETURN $$LB_ERR		' fail

	' get count of items in listbox
	count = SendMessageA (hListBox, $$LB_GETCOUNT, 0, 0)
	IF count < 1 THEN RETURN $$LB_ERR		' empty listbox

	IF index < 0 THEN index = count - 1
	RETURN SendMessageA (hListBox, $$LB_DELETESTRING, index, 0)
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
	IFZ hListBox THEN RETURN

	IF SendMessageA (hListBox, $$LB_SETCARETINDEX, item, $$FALSE) < 0 THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ######################################
' #####  WinXListBox_SetSelection  #####
' ######################################
' Sets the selection on a list box
' hListBox = the handle to the list box to set the selection for
' index[] = an array of item indexes to select
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListBox_SetSelection (hListBox, index[])
	IFZ hListBox THEN RETURN
	IFZ index[] THEN RETURN

	style = GetWindowLongA (hListBox, $$GWL_STYLE)
	IF (style AND $$LBS_EXTENDEDSEL) = $$LBS_EXTENDEDSEL THEN
		' first, deselect everything
		SendMessageA (hListBox, $$LB_SETSEL, 0, -1)
		'
		upp = UBOUND (index[])
		FOR i = 0 TO upp
			SetLastError (0)
			ret = SendMessageA (hListBox, $$LB_SETSEL, 1, index[i])
			IF ret < 0 THEN RETURN
		NEXT i
	ELSE
		' single selection
		SetLastError (0)
		ret = SendMessageA (hListBox, $$LB_SETCURSEL, index[0], 0)
		' index[0] == -1 means "deselect previous selection"
		IF (ret < 0) && (index[0] <> -1) THEN RETURN
		'
		' Guy-21jun11-the list box is scrolled, if necessary, to bring the selected item into view
		SetLastError (0)
		SendMessageA (hListBox, $$LB_SETTOPINDEX, index[0], 0)
	ENDIF

	RETURN $$TRUE		' success
END FUNCTION
'
' ########################################
' #####  WinXListView_AddCheckBoxes  #####
' ########################################
' Adds the check boxes to a list view if they are missing
' $$LVS_EX_CHECKBOXES: Enables items in a list view control to be displayed
' as check boxes. This style uses item state images to produce the check
' box effect.
'
FUNCTION WinXListView_AddCheckBoxes (hLV)

	IFZ hLV THEN RETURN

	' add the check boxes if they are missing
	exStyle = SendMessageA (hLV, $$LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
	IF (exStyle & $$LVS_EX_CHECKBOXES) <> $$LVS_EX_CHECKBOXES THEN
		exStyle = exStyle | $$LVS_EX_CHECKBOXES
		SendMessageA (hLV, $$LVM_SETEXTENDEDLISTVIEWSTYLE, 0, exStyle)
	ENDIF

END FUNCTION
'
' ####################################
' #####  WinXListView_AddColumn  #####
' ####################################
' Adds a column to a list view control for use in report view
' iColumn = the zero-based index for the new column
' wColumn = the width of the column
' label = the label for the column
' iSubItem = the 1-based index of the sub item the column displays
' returns the index to the column or -1 on fail
FUNCTION WinXListView_AddColumn (hLV, iColumn, wColumn, STRING label, iSubItem)
	LVCOLUMN lvCol

	IFZ hLV THEN RETURN -1		' fail

	lvCol.mask = $$LVCF_FMT | $$LVCF_ORDER | $$LVCF_SUBITEM | $$LVCF_TEXT | $$LVCF_WIDTH
	lvCol.fmt = $$LVCFMT_LEFT
	lvCol.cx = wColumn
	lvCol.pszText = &label
	lvCol.iSubItem = iSubItem
	lvCol.iOrder = iColumn

	index = SendMessageA (hLV, $$LVM_INSERTCOLUMN, iColumn, &lvCol)
	IF index < 0 THEN RETURN -1		' fail
	RETURN index
END FUNCTION
'
' ##################################
' #####  WinXListView_AddItem  #####
' ##################################
'
' Adds a new item to a list view control
' iItem = the index at which to insert the item, -1 to add to the end of the list
' STRING item = the label for the item plus subitems in the form "label\0subItem1\0subItem2..."
' or (more User-frendly) "label|subItem1|subItem2..."
' iIcon = the index to the icon or -1 if this item has no icon
' returns the index to the item or -1 on error
FUNCTION WinXListView_AddItem (hLV, iItem, STRING item, iIcon)
	LVITEM lvi

	IFZ hLV THEN RETURN -1		' fail

	st$ = TRIM$ (item) + "|"

	' replace all embedded NULL characters by separator "|"
	upp = LEN (st$) - 1
	FOR i = 0 TO upp
		IF st${i} = '\0' THEN st${i} = '|'
	NEXT i

	' parse the string item
	XstParseStringToStringArray (st$, "|", @s$[])
	IFZ s$[] THEN RETURN -1		' fail (unlikely!)

	' set the item
	lvi.mask = $$LVIF_TEXT
	IF iIcon > -1 THEN lvi.mask = lvi.mask | $$LVIF_IMAGE
	IF iItem > -1 THEN lvi.iItem = iItem ELSE lvi.iItem = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
	lvi.iSubItem = 0
	lvi.pszText = &s$[0]
	lvi.iImage = iIcon

	index = SendMessageA (hLV, $$LVM_INSERTITEM, 0, &lvi)
	IF index < 0 THEN RETURN -1		' fail

	' set the subitems
	upp = UBOUND (s$[])
	FOR i = 1 TO upp
		lvi.mask = $$LVIF_TEXT
		lvi.iItem = index
		lvi.iSubItem = i
		lvi.pszText = &s$[i]
		SendMessageA (hLV, $$LVM_SETITEM, 0, &lvi)
	NEXT i

	RETURN index
END FUNCTION
'
' #########################################
' #####  WinXListView_DeleteAllItems  #####
' #########################################
'
' Deletes all item from a list view control
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_DeleteAllItems (hLV)

	IFZ hLV THEN RETURN

	' protect from an endless loop
	id = LOCK_Get_id_hCtr (hLV)
	statusOld = LOCK_Get_skipOnSelect (id)

	IF statusOld THEN
		ret = SendMessageA (hLV, $$LVM_DELETEALLITEMS, 0, 0)
	ELSE
		LOCK_Set_skipOnSelect (id, $$TRUE) ' freeze .onSelect
		ret = SendMessageA (hLV, $$LVM_DELETEALLITEMS, 0, 0)
		LOCK_Set_skipOnSelect (id, $$FALSE) ' use .onSelect
	ENDIF

	IFZ ret THEN RETURN
	RETURN $$TRUE		' success

END FUNCTION
'
' #######################################
' #####  WinXListView_DeleteColumn  #####
' #######################################
' Deletes a column in a list view control
' iColumn = the zero-based index of the column to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_DeleteColumn (hLV, iColumn)
	IFZ hLV THEN RETURN

	IFZ SendMessageA (hLV, $$LVM_DELETECOLUMN, iColumn, 0) THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' #####################################
' #####  WinXListView_DeleteItem  #####
' #####################################
' Deletes an item from a list view control
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_DeleteItem (hLV, iItem)
	IFZ hLV THEN RETURN

	IFZ SendMessageA (hLV, $$LVM_DELETEITEM, iItem, 0) THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' #########################################
' #####  WinXListView_FreezeOnSelect  #####
' #########################################
'
FUNCTION WinXListView_FreezeOnSelect (hLV)

	id = LOCK_Get_id_hCtr (hLV)
	statusOld = LOCK_Get_skipOnSelect (id)
	IF statusOld THEN RETURN $$TRUE ' already frozen
	RETURN LOCK_Set_skipOnSelect (id, $$TRUE) ' freeze .onSelect

END FUNCTION

' Determines if an item in a list view control is checked
' hLV = the handle to the list view
' iItem = the index of the item to get the check state for
' returns $$TRUE if the button is checked, $$FALSE otherwise
FUNCTION WinXListView_GetCheckState (hLV, iItem)
	IFZ hLV THEN RETURN
	IF iItem < 0 THEN iItem = 0
	ret = SendMessageA (hLV, $$LVM_GETITEMSTATE, iItem, $$LVIS_STATEIMAGEMASK)
	IF (ret & 0x2000) = 0x2000 THEN RETURN $$TRUE ELSE RETURN $$FALSE		' button NOT checked
END FUNCTION
'
' ##########################################
' #####  WinXListView_GetHeaderHeight  #####
' ##########################################
'
FUNCTION WinXListView_GetHeaderHeight (hLV)
	RECT rect

	IFZ hLV THEN RETURN
	hHeader = SendMessageA (hLV, $$LVM_GETHEADER, 0, 0)
	IFZ hHeader THEN RETURN
	GetWindowRect (hHeader, &rect)
	RETURN rect.bottom - rect.top

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
	LVHITTESTINFO tvHit

	IFZ hLV THEN RETURN -1		' fail

	tvHit.pt.x = x
	tvHit.pt.y = y
	index = SendMessageA (hLV, $$LVM_HITTEST, 0, &tvHit)
	IF index < 0 THEN RETURN -1		' fail
	RETURN index
END FUNCTION
'
' ######################################
' #####  WinXListView_GetItemText  #####
' ######################################
' Gets the text for a list view item
' hLV = the handle to the list view
' iItem = the zero-based index of the item
' uppSubItem = the upper index of sub items to get
' r_text$[] = the array to store the result
' returns $$TRUE on success or $$FALSE on fail

' Usage
'	count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
'	IF count > 0 THEN
'		iItem = count - 1 ' last item
'		WinXListView_GetItemText (hLV, iItem, 1, @text$[]) ' retrieve the first 2 columns
'	ENDIF
FUNCTION WinXListView_GetItemText (hLV, iItem, uppSubItem, @r_text$[])
	LVITEM lvi

	' reset the returned array
	DIM r_text$[]

	IFZ hLV THEN RETURN
	IF iItem < 0 THEN iItem = 0
	IF uppSubItem < 0 THEN RETURN

	DIM r_text$[uppSubItem]
	FOR i = 0 TO uppSubItem
		buffer$ = NULL$ (4096)
		lvi.mask = $$LVIF_TEXT
		lvi.pszText = &buffer$
		lvi.cchTextMax = 4095
		lvi.iItem = iItem
		lvi.iSubItem = i
		'
		IFZ SendMessageA (hLV, $$LVM_GETITEM, iItem, &lvi) THEN EXIT FOR
		r_text$[i] = CSTRING$ (&buffer$)
	NEXT i

	RETURN $$TRUE		' success
END FUNCTION
'
' #######################################
' #####  WinXListView_GetSelection  #####
' #######################################
' Gets the current selection
' r_iItems[] = the array in which to store the indexes of selected items
' returns the number of selected items
FUNCTION WinXListView_GetSelection (hLV, r_iItems[])

	' reset the returned array
	DIM r_iItems[]

	IFZ hLV THEN RETURN
	' get count of items in listview
	count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
	IF count < 1 THEN RETURN		' empty

	cSelItem = SendMessageA (hLV, $$LVM_GETSELECTEDCOUNT, 0, 0)
	IF cSelItem = 0 THEN RETURN

	upper_slot = cSelItem - 1
	DIM r_iItems[upper_slot]

	' now iterate over all the items to locate the selected ones
	slot = -1
	upp = count - 1
	FOR i = 0 TO upp
		ret = SendMessageA (hLV, $$LVM_GETITEMSTATE, i, $$LVIS_SELECTED)
		IF ret THEN
			INC slot
			IF slot > upper_slot THEN EXIT FOR
			r_iItems[slot] = i
		ENDIF
	NEXT i

	RETURN cSelItem
END FUNCTION
'
' #########################################
' #####  WinXListView_RemoveCheckBox  #####
' #########################################
' Removes the check box of a list view item
' hLV = the handle to the list view
' iItem = the index to the item to remove the check box
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_RemoveCheckBox (hLV, iItem)

	LV_ITEM lvi		' list view item

	IFZ hLV THEN RETURN

	lvi.state = 0		' no check box
	lvi.mask = $$LVIF_STATE
	lvi.stateMask = $$LVIS_STATEIMAGEMASK

	SendMessageA (hLV, $$LVM_SETITEMSTATE, iItem, &lvi)
	RETURN $$TRUE		' success
END FUNCTION
'
' ########################################
' #####  WinXListView_SetAllChecked  #####
' ########################################
'
' Checks all item's check state of a list view with check boxes
' hLV = the handle to the list view
'
FUNCTION WinXListView_SetAllChecked (hLV)
	LV_ITEM lvi		' list view item

	IFZ hLV THEN RETURN

	' get count of items in listview
	count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
	IF count < 1 THEN RETURN		' empty

	' protect from an endless loop
	id = LOCK_Get_id_hCtr (hLV)
	statusOld = LOCK_Get_skipOnSelect (id)
	IFF statusOld THEN LOCK_Set_skipOnSelect (id, $$TRUE) ' freeze .onSelect

	uppItem = count - 1
	IF uppItem >= 0 THEN
		FOR iItem = 0 TO uppItem
			lvi.mask = $$LVIF_STATE
			lvi.state = 0x2000
			lvi.stateMask = $$LVIS_STATEIMAGEMASK
			'
			SendMessageA (hLV, $$LVM_SETITEMSTATE, iItem, &lvi)
		NEXT iItem
	ENDIF

	IFF statusOld THEN LOCK_Set_skipOnSelect (id, $$FALSE) ' use .onSelect

	RETURN $$TRUE		' success

END FUNCTION
'
' #########################################
' #####  WinXListView_SetAllSelected  #####
' #########################################
'
' Selects all items
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_SetAllSelected (hLV)
	LVITEM lvi

	IFZ hLV THEN RETURN
	lvi.mask = $$LVIF_STATE
	lvi.stateMask = $$LVIS_SELECTED
	lvi.state = $$LVIS_SELECTED

	SendMessageA (hLV, $$LVM_SETITEMSTATE, -1, &lvi)

	RETURN $$TRUE		' success
END FUNCTION
'
' ##########################################
' #####  WinXListView_SetAllUnchecked  #####
' ##########################################
'
' Unchecks all item's check state of a list view with check boxes
' hLV = the handle to the list view
'
FUNCTION WinXListView_SetAllUnchecked (hLV)
	LV_ITEM lvi		' list view item

	IFZ hLV THEN RETURN

	' get count of items in listview
	count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
	IF count < 1 THEN RETURN		' empty

	' protect from an endless loop
	id = LOCK_Get_id_hCtr (hLV)
	statusOld = LOCK_Get_skipOnSelect (id)
	IFF statusOld THEN LOCK_Set_skipOnSelect (id, $$TRUE) ' freeze .onSelect

	uppItem = count - 1
	FOR iItem = 0 TO uppItem
		lvi.mask = $$LVIF_STATE
		lvi.state = 0x1000
		lvi.stateMask = $$LVIS_STATEIMAGEMASK
		'
		SendMessageA (hLV, $$LVM_SETITEMSTATE, iItem, &lvi)
	NEXT iItem

	IFF statusOld THEN LOCK_Set_skipOnSelect (id, $$FALSE) ' use .onSelect

	RETURN $$TRUE		' success

END FUNCTION
'
' ###########################################
' #####  WinXListView_SetAllUnselected  #####
' ###########################################
'
' Unselects all items
' returns $$TRUE on success or $$FALSE on fail
'
FUNCTION WinXListView_SetAllUnselected (hLV)
	LVITEM lvi

	IFZ hLV THEN RETURN
	lvi.mask = $$LVIF_STATE
	lvi.stateMask = $$LVIS_SELECTED
	lvi.state = 0

	SendMessageA (hLV, $$LVM_SETITEMSTATE, -1, &lvi)

	RETURN $$TRUE		' success
END FUNCTION
'
' ########################################
' #####  WinXListView_SetCheckState  #####
' ########################################
' Sets the item's check state of a list view with check boxes
' hLV = the handle to the list view
' iItem = the index to the item to set the check state for
' checked = $$TRUE to check the item, $$FALSE to uncheck it
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_SetCheckState (hLV, iItem, checked)
	LV_ITEM lvi		' list view item

	IFZ hLV THEN RETURN
	IF iItem < 0 THEN RETURN

	IF checked THEN
		lvi.state = 0x2000 ' on
	ELSE
		lvi.state = 0x1000 ' off
	ENDIF
	lvi.mask = $$LVIF_STATE
	lvi.stateMask = $$LVIS_STATEIMAGEMASK

	SendMessageA (hLV, $$LVM_SETITEMSTATE, iItem, &lvi)

	RETURN $$TRUE		' success
END FUNCTION
'
' #######################################
' #####  WinXListView_SetItemFocus  #####
' #######################################
'
' Sets the focus on an item
' iItem = the zero-based index of the item
' iSubItem = 0 the 1-based index of the subitem or 0 if setting the main item
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_SetItemFocus (hLV, iItem, iSubItem)
	LVITEM lvi

	IFZ hLV THEN RETURN

	' get count of items in listview
	count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
	IF count < 1 THEN RETURN		' empty

	IF iItem < 0 THEN iItem = 0
	IF iItem >= count THEN RETURN

	IF iSubItem < 0 THEN iSubItem = 0

	lvi.iItem = iItem
	lvi.iSubItem = iSubItem
	lvi.mask = $$LVIF_TEXT
	lvi.state = $$LVIS_FOCUSED | $$LVIS_SELECTED
	lvi.stateMask = $$LVIS_FOCUSED | $$LVIS_SELECTED

	ret = SendMessageA (hLV, $$LVM_SETITEMSTATE, iItem, &lvi)
	IFZ ret THEN RETURN

	' unselect all the items
	lvi.mask = $$LVIF_STATE
	lvi.stateMask = $$LVIS_SELECTED
	lvi.state = 0
	SendMessageA (hLV, $$LVM_SETITEMSTATE, -1, &lvi)

	' select the focused item
	lvi.iItem = iItem
	lvi.iSubItem = iSubItem
	lvi.mask = $$LVIF_STATE
	lvi.stateMask = $$LVIS_SELECTED
	lvi.state = $$LVIS_SELECTED
	SendMessageA (hLV, $$LVM_SETITEMSTATE, iItem, &lvi)

	' show the item
	SendMessageA (hLV, $$LVM_ENSUREVISIBLE, iItem, 0)

	RETURN $$TRUE		' success
END FUNCTION
'
' ######################################
' #####  WinXListView_SetItemText  #####
' ######################################
' Sets new text for an item
' iItem = the zero-based index of the item
' iSubItem = 0 the 1-based index of the subitem or 0 if setting the main item
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_SetItemText (hLV, iItem, iSubItem, STRING newText)
	LVITEM lvi

	IFZ hLV THEN RETURN

	lvi.mask = $$LVIF_TEXT
	lvi.iItem = iItem
	lvi.iSubItem = iSubItem
	lvi.pszText = &newText

	IFZ SendMessageA (hLV, $$LVM_SETITEMTEXT, iItem, &lvi) THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' #######################################
' #####  WinXListView_SetSelection  #####
' #######################################
' Sets the selection in a list view control
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_SetSelection (hLV, iItems[])
	LVITEM lvi

	IFZ hLV THEN RETURN

	' get count of items in listview
	count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
	IF count < 1 THEN RETURN		' empty

	IFZ iItems[] THEN RETURN

	' unselect all
	lvi.state = NOT $$LVIS_SELECTED
	lvi.stateMask = $$LVIS_SELECTED
	SendMessageA (hLV, $$LVM_SETITEMSTATE, -1, &lvi)

	upp = UBOUND (iItems[])
	FOR i = 0 TO upp
		iItem = iItems[i]
		IF iItem >= 0 && iItem < count THEN
			lvi.state = $$LVIS_SELECTED
			lvi.stateMask = $$LVIS_SELECTED
			SendMessageA (hLV, $$LVM_SETITEMSTATE, iItem, &lvi)
		ENDIF
	NEXT i

	RETURN $$TRUE		' success
END FUNCTION
'
' ############################################
' #####  WinXListView_SetTopItemByIndex  #####
' ############################################
'
' Shows an item on top using its index
' iItem = the zero-based index of the item
' iSubItem = 0 the 1-based index of the subitem or 0 if setting the main item
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_SetTopItemByIndex (hLV, iItem, iSubItem)
	RECT rect

	IFZ hLV THEN RETURN

	' get count of items in listview
	count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
	IF count < 1 THEN RETURN		' empty

	IF iItem < 0 THEN iItem = 0
	IF iItem >= count THEN RETURN

	IF iSubItem < 0 THEN iSubItem = 0

	topIndex = SendMessageA (hLV, $$LVM_GETTOPINDEX, 0, 0)
	IF iItem = topIndex THEN RETURN

	rect.left = $$LVIR_BOUNDS
	SendMessageA (hLV, $$LVM_GETITEMRECT, 0, &rect)
	scrollY = (iItem - topIndex) * (rect.bottom - rect.top)
	SendMessageA (hLV, $$LVM_SCROLL, 0, scrollY)
	SendMessageA (hLV, $$LVM_ENSUREVISIBLE, iItem, iSubItem)
	RETURN $$TRUE		' success

END FUNCTION
'
' ##################################
' #####  WinXListView_SetView  #####
' ##################################
' Sets the view of a list view control
' hLV = the handle to the control
' view = the view to set
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_SetView (hLV, view)

	IFZ hLV THEN RETURN

	style = GetWindowLongA (hLV, $$GWL_STYLE)
	style = (style AND NOT ($$LVS_ICON | $$LVS_SMALLICON | $$LVS_LIST | $$LVS_REPORT)) OR view
	SetWindowLongA (hLV, $$GWL_STYLE, style)
	RETURN $$TRUE		' success
END FUNCTION
'
' ##########################################
' #####  WinXListView_ShowItemByIndex  #####
' ##########################################
'
' Shows an item using its index
' iItem = the zero-based index of the item
' iSubItem = 0 the 1-based index of the subitem or 0 if setting the main item
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_ShowItemByIndex (hLV, iItem, iSubItem)

	IFZ hLV THEN RETURN

	' get count of items in listview
	count = SendMessageA (hLV, $$LVM_GETITEMCOUNT, 0, 0)
	IF count < 1 THEN RETURN		' empty

	IF iItem < 0 THEN iItem = 0
	IF iItem >= count THEN RETURN

	IF iSubItem < 0 THEN iSubItem = 0

	SendMessageA (hLV, $$LVM_ENSUREVISIBLE, iItem, iSubItem)
	RETURN $$TRUE		' success

END FUNCTION
'
' ###############################
' #####  WinXListView_Sort  #####
' ###############################
' Sorts the items in a list view control
' hLV = the list view control to sort
' iCol = the zero-based index of the column to sort by
' desc = $$TRUE to sort descending instead of ascending
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXListView_Sort (hLV, iCol, desc)
	SHARED lvs_iCol
	SHARED lvs_desc

	IFZ hLV THEN RETURN

	lvs_iCol = iCol
	lvs_desc = desc
	ret = SendMessageA (hLV, $$LVM_SORTITEMSEX, hLV, &CompareLVItems ())
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ######################################
' #####  WinXListView_UseOnSelect  #####
' ######################################
'
FUNCTION WinXListView_UseOnSelect (hLV)

	id = LOCK_Get_id_hCtr (hLV)
	statusOld = LOCK_Get_skipOnSelect (id)
	IFF statusOld THEN RETURN $$TRUE ' already in use
	RETURN LOCK_Set_skipOnSelect (id, $$FALSE) ' use .onSelect

END FUNCTION
'
' #####################################
' #####  WinXMRU_LoadListFromIni  #####
' #####################################
'
' load the Most Recently Used file list from the .INI file
' Returns $$FALSE = failure, $$TRUE = success
FUNCTION WinXMRU_LoadListFromIni (iniPath$, pathNew$, @r_mruList$[])

	' reset the returned array
	DIM r_mruList$[]

	iniPath$ = WinXPath_Trim$ (iniPath$)
	IFZ iniPath$ THEN RETURN

	' create ini file if it does not exist
	key$ = WinXMRU_MakeKey$ (0) ' $$MRU_SECTION$ entry
	value$ = WinXIni_Read$ (iniPath$, $$MRU_SECTION$, key$, "")
	IF value$ <> "-" THEN WinXIni_Write (iniPath$, $$MRU_SECTION$, key$, "-")

	DIM r_mruList$[$$UPP_MRU]
	upp = -1

	' add real file pathNew$ to r_mruList$[0]
	pathNew$ = WinXPath_Trim$ (pathNew$)
	IF pathNew$ THEN
		bErr = XstFileExists (pathNew$)
		IFF bErr THEN
			upp = 0
			r_mruList$[0] = pathNew$
		ENDIF
	ENDIF

	' load the MRU projects list into r_mruList$[]
	FOR id = 1 TO $$UPP_MRU + 1
		key$ = WinXMRU_MakeKey$ (id)
		fpath$ = WinXIni_Read$ (iniPath$, $$MRU_SECTION$, key$, "")
		fpath$ = WinXPath_Trim$ (fpath$)
		IFZ fpath$ THEN DO NEXT ' empty => skip it!
		'
		bErr = XstFileExists (fpath$)
		IF bErr THEN DO NEXT ' fpath$ does not exist => skip it!
		'
		' don't add fpath$ if already in r_mruList$[]
		bFound = $$FALSE
		IF upp >= 0 THEN
			find_lc$ = LCASE$ (fpath$)
			findLen = LEN (find_lc$)
			'
			FOR z = 0 TO upp
				IF LEN (r_mruList$[z]) <> findLen THEN DO NEXT
				IF LCASE$ (r_mruList$[z]) = find_lc$ THEN
					bFound = $$TRUE
					EXIT FOR
				ENDIF
			NEXT z
		ENDIF
		IF bFound THEN DO NEXT ' already in r_mruList$[] => skip it!
		'
		IF upp >= $$UPP_MRU THEN EXIT FOR ' r_mruList$[] is full
		'
		INC upp
		r_mruList$[upp] = fpath$
	NEXT id

	IF upp < 0 THEN
		DIM r_mruList$[]
	ELSE
		IF UBOUND (r_mruList$[]) <> upp THEN REDIM r_mruList$[upp]
	ENDIF
	RETURN $$TRUE		' success
END FUNCTION
'
' ##############################
' #####  WinXMRU_MakeKey$  #####
' ##############################
'
FUNCTION WinXMRU_MakeKey$ (id)

	IF id < 1 THEN id$ = " 0" ELSE id$ = STR$ (id)
	RETURN "File" + id$

END FUNCTION
'
' ###################################
' #####  WinXMRU_SaveListToIni  #####
' ###################################
'
' Save the Most Recently Used file list
' Returns $$FALSE = failure, $$TRUE = success
FUNCTION WinXMRU_SaveListToIni (iniPath$, pathNew$, @r_mruList$[])
	' Add file pathNew$ to MRU file list. If file already exists in list then it is
	' simply moved up to the top of the list and not added again. If list is
	' full then the least recently used item is removed to make room.

	DIM arr$[$$UPP_MRU]
	upp = -1

	' add real file pathNew$ to arr$[0]
	pathNew$ = WinXPath_Trim$ (pathNew$)
	IF pathNew$ THEN
		bErr = XstFileExists (pathNew$)
		IFF bErr THEN
			upp = 0
			arr$[0] = pathNew$
		ENDIF
	ENDIF

	' copy the current Most Recently Used file list
	IF r_mruList$[] THEN
		uppmru = UBOUND (r_mruList$[])
		FOR imru = 0 TO uppmru
			fpath$ = WinXPath_Trim$ (r_mruList$[imru])
			IFZ fpath$ THEN DO NEXT
			'
			bErr = XstFileExists (fpath$)
			IF bErr THEN DO NEXT
			'
			' don't add fpath$ if already in arr$[]
			bFound = $$FALSE
			IF upp >= 0 THEN
				find_lc$ = LCASE$ (fpath$)
				findLen = LEN (find_lc$)
				'
				FOR z = 0 TO upp
					IF LEN (arr$[z]) <> findLen THEN DO NEXT
					IF LCASE$ (arr$[z]) = find_lc$ THEN
						bFound = $$TRUE
						EXIT FOR
					ENDIF
				NEXT z
			ENDIF
			'
			IFF bFound THEN
				IF upp >= $$UPP_MRU THEN EXIT FOR ' MRU list is full
				INC upp
				arr$[upp] = fpath$
			ENDIF
		NEXT imru
	ENDIF
	IF upp < 0 THEN
		DIM arr$[]
	ELSE
		IF UBOUND (arr$[]) <> upp THEN REDIM arr$[upp]
	ENDIF

	' save the Most Recently Used project list in the .INI file
	idAdd = 0
	IF upp >= 0 THEN
		FOR i = 0 TO upp
			INC idAdd
			key$ = WinXMRU_MakeKey$ (idAdd)
			' replace an existing key
			value$ = WinXIni_Read$ (iniPath$, $$MRU_SECTION$, key$, "")
			IF value$ <> arr$[i] THEN WinXIni_Write (iniPath$, $$MRU_SECTION$, key$, arr$[i])
		NEXT i
	ENDIF

	' delete from .INI file extraneous MRU items
	idInf = idAdd + 1
	idSup = $$UPP_MRU + 1
	IF idInf <= idSup THEN
		FOR id = idInf TO idSup
			key$ = WinXMRU_MakeKey$ (id)
			WinXIni_Delete (iniPath$, $$MRU_SECTION$, key$)
		NEXT id
	ENDIF

	' reset the Most Recently Used project lists
	IFZ arr$[] THEN
		DIM r_mruList$[]
	ELSE
		upp = UBOUND (arr$[])
		DIM r_mruList$[upp]
		FOR i = 0 TO upp
			r_mruList$[i] = arr$[i]
		NEXT i
	ENDIF

	RETURN $$TRUE		' success
END FUNCTION
'
' ###############################
' #####  WinXMenu_Attach  #####
' ###############################
' Attach a sub menu to another menu
' subMenu = the sub menu to attach
' newParent = the new parent menu
' idCtr = the idCtr to attach to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXMenu_Attach (subMenu, newParent, idCtr)
	MENUITEMINFO mii

	IFZ subMenu THEN RETURN
	IFZ newParent THEN RETURN
	IFZ idCtr THEN RETURN

	mii.cbSize = SIZE (MENUITEMINFO)
	mii.fMask = $$MIIM_SUBMENU
	mii.hSubMenu = subMenu

	IFZ SetMenuItemInfoA (newParent, idCtr, 0, &mii) THEN RETURN
	RETURN $$TRUE		' success
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
	SECURITY_ATTRIBUTES oSecAttr

	oSecAttr.length = SIZE (SECURITY_ATTRIBUTES)
	IF inherit THEN oSecAttr.inherit = 1

	IF ssd$ THEN
		' Guy-30jul08-ConvertStringSecurityDescriptorToSecurityDescriptorA (&ssd$, $$SDDL_REVISION_1, &oSecAttr.securityDescriptor, 0)
		funcName$ = "ConvertStringSecurityDescriptorToSecurityDescriptorA"
		DIM args[3]
		args[0] = &ssd$
		args[1] = $$SDDL_REVISION_1
		args[2] = &oSecAttr.securityDescriptor
		args[3] = 0
		XstCall (funcName$, "advapi32", @args[])
	ENDIF

	RETURN oSecAttr
END FUNCTION
'
' ####################################
' #####  WinXNewAutoSizerSeries  #####
' ####################################
' Adds a new auto sizer series
' direction = $$DIR_VERT or $$DIR_HORIZ
' returns the handle of the new autosizer series
FUNCTION WinXNewAutoSizerSeries (direction)
	RETURN AUTOSIZER_LinkedList_New (direction)
END FUNCTION
'
' ################################
' #####  WinXNewChildWindow  #####
' ################################
' Creates a new control
FUNCTION WinXNewChildWindow (hParent, STRING title, style, exStyle, idCtr)
	BINDING binding
	LINKEDLIST autoDraw

	style = $$WS_CHILD | $$WS_VISIBLE | style		' passed style
	hInst = GetModuleHandleA (0)
	hWnd = CreateWindowExA (exStyle, &#WinXclass$, &title, style, 0, 0, 0, 0, hParent, idCtr, hInst, 0)

	' make a binding
	binding.hwnd = hWnd
	style = $$WS_POPUP | $$TTS_NOPREFIX | $$TTS_ALWAYSTIP
	hInst = GetModuleHandleA (0)
	binding.hToolTips = CreateWindowExA (0, &$$TOOLTIPS_CLASS, 0, style, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, hWnd, 0, hInst, 0)
	binding.msgHandlers = HANDLER_New ()
	LinkedList_Init (@autoDraw)
	binding.autoDrawInfo = LINKEDLIST_New (autoDraw)
	binding.autoSizerInfo = AUTOSIZER_LinkedList_New ($$DIR_VERT)

	SetWindowLongA (hWnd, $$GWL_USERDATA, BINDING_New (binding))

	' and we're done
	RETURN hWnd
END FUNCTION
'
' #########################
' #####  WinXNewFont  #####
' #########################
'
' create a new logical font
' fontName$ = the name of the font
' pointSize = the size of the font in points
' weight    = the weight of the font as $$FW_THIN,...
' italic    = $$TRUE for italic characters
' underline = $$TRUE for underlined characters
' strikeOut = $$TRUE for striken-out characters
' fontName$ = the name of the font
' Returns the font handle if success, 0 = fail
FUNCTION WinXNewFont (fontName$, pointSize, weight, italic, underline, strikeOut)

	LOGFONT oLogFont

	' check fontName$ not empty
	fontName$ = TRIM$ (fontName$)
	IFZ fontName$ THEN RETURN ' fail

	hfontToClone = GetStockObject ($$DEFAULT_GUI_FONT) ' get a font to clone
	' hfontToClone provides with a well-formed font structure
	bytes = GetObjectA (hfontToClone, SIZE (oLogFont), &oLogFont) ' allocate structure font
	' release the cloned font
	DeleteObject (hfontToClone)
	hfontToClone = 0

	' set the cloned font structure with the passed parameters
	oLogFont.faceName = fontName$

	IFZ pointSize THEN
		oLogFont.height = 0
	ELSE
		' character height is specified (in points)
		IF pointSize > 0 THEN
			pointH = pointSize
		ELSE
			pointH = -pointSize ' make it positive
		ENDIF
		'
		' convert pointSize to pixels
		hdc = GetDC ($$HWND_DESKTOP) ' get the desktop context's handle
		' Windows expects the font height to be in pixels and negative
		oLogFont.height = MulDiv (pointH, GetDeviceCaps (hdc, $$LOGPIXELSY), -72)
		ReleaseDC ($$HWND_DESKTOP, hdc) ' release the handle of the desktop context
	ENDIF

	SELECT CASE weight
		CASE $$FW_THIN, $$FW_EXTRALIGHT, $$FW_LIGHT, $$FW_NORMAL, $$FW_MEDIUM, _
		     $$FW_SEMIBOLD, $$FW_BOLD, $$FW_EXTRABOLD, $$FW_HEAVY, $$FW_DONTCARE
			oLogFont.weight = weight
			'
		CASE ELSE : oLogFont.weight = $$FW_NORMAL
	END SELECT

	IF italic    THEN oLogFont.italic    = 1 ELSE oLogFont.italic    = 0
	IF underline THEN oLogFont.underline = 1 ELSE oLogFont.underline = 0
	IF strikeOut THEN oLogFont.strikeOut = 1 ELSE oLogFont.strikeOut = 0

	hFont = CreateFontIndirectA (&oLogFont) ' create logical font hFont
	RETURN hFont

END FUNCTION
'
' #########################
' #####  WinXNewMenu  #####
' #########################
' Generates a new menu
' menu = a string representing the menu.  Items are seperated by commas,
' two commas in a row indicate a separator.  Use & to specify hotkeys and && for &.
' firstID = the idCtr of the first item, the other ids are assigned sequentially
' isPopup = $$TRUE if this is a popup menu else $$FALSE
' returns a handle to the menu or 0 on fail
FUNCTION WinXNewMenu (STRING menu, firstID, isPopup)
	' parse the string
	' Guy-19feb12-XstParseStringToStringArray (menu, ",", @items$[])
	IFZ menu THEN
		DIM items$[0]
	ELSE
		IFZ INSTR (menu, ",") THEN
			DIM items$[0]
			items$[0] = menu
		ELSE
			XstParseStringToStringArray (menu, ",", @items$[])
		ENDIF
	ENDIF

	IF isPopup THEN hMenu = CreatePopupMenu () ELSE hMenu = CreateMenu ()

	' now write the menu items
	cSep = 0		'the number of separators
	upp = UBOUND (items$[])
	FOR i = 0 TO upp
		' write the data
		items$[i] = TRIM$ (items$[i])
		IF items$[i] = "" THEN
			flags = $$MF_SEPARATOR
			INC cSep
		ELSE
			flags = 0
		ENDIF
		AppendMenuA (hMenu, $$MF_STRING | $$MF_ENABLED | flags, firstID + i - cSep, &items$[i])
	NEXT i

	RETURN hMenu
END FUNCTION
'
' ############################
' #####  WinXNewToolbar  #####
' ############################
' Generates a new toolbar
' wButton = The width of a button image in pixels
' hButton = the height of a button image in pixels
' nButtons = the number of buttons images
' hBmpButtons = the handle to a bitmap containing the button images
' hBmpGray = the appearance of the buttons when disabled, 0 for default
' hBmpHot = the appearance of the buttons when the mouse is over them, 0 for default
' rgbTrans = the color to use as transparent
' toolTips = $$TRUE to use tooltips, $$FALSE to disable them
' customisable = $$TRUE if this toolbar can be customised.
' !!THIS FEATURE IS NOT IMPLEMENTED YET, USE $$FALSE FOR THIS PARAMETER!!
' returns the handle to the toolbar or 0 on fail
FUNCTION WinXNewToolbar (wButton, hButton, nButtons, hBmpButtons, hBmpGray, hBmpHot, rgbTrans, toolTips, customisable)
	BITMAP bm

	' ignore null button images handle
	IFZ hBmpButtons THEN RETURN

	' bmpWidth = wButton*nButtons
	GetObjectA (hBmpButtons, SIZE (bm), &bm)		' get the bitmap's sizes
	bmpWidth = bm.width		' save bitmap size for later use

	' make image lists
	hilMain = ImageList_Create (wButton, hButton, $$ILC_COLOR24 | $$ILC_MASK, nButtons, 0)
	hilGray = ImageList_Create (wButton, hButton, $$ILC_COLOR24 | $$ILC_MASK, nButtons, 0)
	hilHot = ImageList_Create (wButton, hButton, $$ILC_COLOR24 | $$ILC_MASK, nButtons, 0)

	' make 2 memory DCs for image manipulations
	hdc = GetDC (GetDesktopWindow ())
	hMem = CreateCompatibleDC (hdc)
	hSource = CreateCompatibleDC (hdc)
	ReleaseDC (GetDesktopWindow (), hdc)

	' make a mask for the normal buttons
	hblankS = SelectObject (hSource, hBmpButtons)
	hBmpMask = CreateCompatibleBitmap (hSource, bmpWidth, hButton)
	hblankM = SelectObject (hMem, hBmpMask)
	BitBlt (hMem, 0, 0, bmpWidth, hButton, hSource, 0, 0, $$SRCCOPY)
	GOSUB makeMask
	hBmpButtons = SelectObject (hSource, hblankS)
	hBmpMask = SelectObject (hMem, hblankM)

	' Add to the image list
	ImageList_Add (hilMain, hBmpButtons, hBmpMask)

	' now let's do the gray buttons
	IF hBmpGray THEN
		' generate a mask
		hblankS = SelectObject (hSource, hBmpGray)
		hblankM = SelectObject (hMem, hBmpMask)
		BitBlt (hMem, 0, 0, bmpWidth, hButton, hSource, 0, 0, $$SRCCOPY)
		GOSUB makeMask
	ELSE
		' generate hBmpGray
		hblankS = SelectObject (hSource, hBmpMask)
		hBmpGray = CreateCompatibleBitmap (hSource, bmpWidth, hButton)
		hblankM = SelectObject (hMem, hBmpGray)
		FOR y = 0 TO (hButton - 1)
			FOR x = 0 TO (bmpWidth - 1)
				col = GetPixel (hSource, x, y)
				IF col = 0x00000000 THEN SetPixel (hMem, x, y, 0x00808080)
			NEXT x
		NEXT y
	ENDIF

	SelectObject (hSource, hblankS)
	SelectObject (hMem, hblankM)
	ImageList_Add (hilGray, hBmpGray, hBmpMask)

	' and finaly, the hot buttons
	IF hBmpHot THEN
		' generate a mask
		hblankS = SelectObject (hSource, hBmpHot)
		hblankM = SelectObject (hMem, hBmpMask)
		BitBlt (hMem, 0, 0, bmpWidth, hButton, hSource, 0, 0, $$SRCCOPY)
		GOSUB makeMask
	ELSE
		' generate a brighter version of hBmpButtons
		' hBmpHot = hBmpButtons
		hblankS = SelectObject (hSource, hBmpButtons)
		' hBmpHot = CopyImage (hBmpButtons, $$IMAGE_BITMAP, bmpWidth, hButton, 0)
		hBmpHot = CreateCompatibleBitmap (hSource, bmpWidth, hButton)
		hblankM = SelectObject (hMem, hBmpHot)
		FOR y = 0 TO (hButton - 1)
			FOR x = 0 TO (bmpWidth - 1)
				col = GetPixel (hSource, x, y)
				c1 = (col & 0x000000FF)
				c2 = (col & 0x0000FF00) >> 8
				c3 = (col & 0x00FF0000) >> 16
				c1 = c1 + 40		'c1+((0xFF-c1)\3)
				c2 = c2 + 40		'c2+((0xFF-c2)\3)
				c3 = c3 + 40		'c3+((0xFF-c3)\3)
				SELECT CASE ALL TRUE
					CASE c1 > 255 : c1 = 255
					CASE c2 > 255 : c2 = 255
					CASE c3 > 255 : c3 = 255
				END SELECT
				SetPixel (hMem, x, y, c1 | (c2 << 8) | (c3 << 16))
			NEXT x
		NEXT y
	ENDIF

	SelectObject (hSource, hblankS)
	SelectObject (hMem, hblankM)

	ImageList_Add (hilHot, hBmpHot, hBmpMask)

	' ok, now clean up
	DeleteDC (hMem)
	DeleteDC (hSource)

	' delete the bitmap handles they are no longer need
	IF hBmpButtons THEN
		DeleteObject (hBmpButtons)
		hBmpButtons = 0
	ENDIF
	IF hBmpGray THEN
		DeleteObject (hBmpGray)
		hBmpGray = 0
	ENDIF
	IF hBmpHot THEN
		DeleteObject (hBmpHot)
		hBmpHot = 0
	ENDIF

	' and make the toolbar
	hToolbar = WinXNewToolbarUsingIls (hilMain, hilGray, hilHot, toolTips, customisable)

	' return the handle of the toolbar
	RETURN hToolbar

SUB makeMask

	IFZ hMem THEN EXIT SUB

	FOR y = 0 TO (hButton - 1)
		FOR x = 0 TO (bmpWidth - 1)
			col = GetPixel (hSource, x, y)
			IF col = rgbTrans THEN
				SetPixel (hMem, x, y, 0x00FFFFFF)
				SetPixel (hSource, x, y, 0x00FFFFFF)
			ELSE
				SetPixel (hMem, x, y, 0x00000000)
			ENDIF
		NEXT x
	NEXT y

END SUB

END FUNCTION
'
' ####################################
' #####  WinXNewToolbarUsingIls  #####
' ####################################
' Make a new toolbar using the specified image lists
' hilMain = image list for the buttons
' hilGray = the images to be displayed when the buttons are disabled
' hilHot = the images to be displayed on mouse over
' tooltips = $$TRUE to enable tooltips
' customisable = $$TRUE to enable customisation
' returns the handle of the toolbar
FUNCTION WinXNewToolbarUsingIls (hilMain, hilGray, hilHot, toolTips, customisable)

	style = $$TBSTYLE_FLAT | $$TBSTYLE_LIST
	IF toolTips THEN style = style | $$TBSTYLE_TOOLTIPS

	' IF customisable THEN
	' style = style|$$CCS_ADJUSTABLE
	' SetPropA (hToolbar, &"customisationData", tbbd_addGroup ())
	' ELSE
	' SetPropA (hToolbar, &"customisationData", -1)
	' ENDIF

	hInst = GetModuleHandleA (0)
	hToolbar = CreateWindowExA (0, &$$TOOLBARCLASSNAME, 0, style, 0, 0, 0, 0, 0, 0, hInst, 0)
	IFZ hToolbar THEN RETURN

	WinXSetDefaultFont (hToolbar)		'give it a nice font

	SendMessageA (hToolbar, $$TB_SETEXTENDEDSTYLE, 0, $$TBSTYLE_EX_MIXEDBUTTONS | $$TBSTYLE_EX_DOUBLEBUFFER | $$TBSTYLE_EX_DRAWDDARROWS)
	SendMessageA (hToolbar, $$TB_SETIMAGELIST, 0, hilMain)
	SendMessageA (hToolbar, $$TB_SETHOTIMAGELIST, 0, hilHot)
	SendMessageA (hToolbar, $$TB_SETDISABLEDIMAGELIST, 0, hilGray)
	SendMessageA (hToolbar, $$TB_BUTTONSTRUCTSIZE, SIZE (TBBUTTON), 0)

	RETURN hToolbar
END FUNCTION
'
' ###########################
' #####  WinXNewWindow  #####
' ###########################
'
' [WinXNewWindow]
' Description = create a new window
' Function    = hWnd = WinXNewWindow (hOwner, title$, x, y, w, h, simpleStyle, exStyle, icon, menu)
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
' Return      = The handle to the new window or 0 on fail
' Remarks     = Simple style constants:
' - $$XWSS_APP: A standard window
' - $$XWSS_APPNORESIZE: Same as the standard window, but cannot be resized or maximised
' - $$XWSS_POPUP: A popup window, cannot be minimised
' - $$XWSS_POPUPNOTITLE: A popup window with no title bar
' - $$XWSS_NOBORDER: A window with no border, useful for full screen apps
' See Also    =
' Examples    = 'Make a simple window
' WinXNewWindow (0, "My window", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)
'
FUNCTION WinXNewWindow (hOwner, STRING title, x, y, w, h, simpleStyle, exStyle, icon, menu)
	BINDING binding
	RECT rect
	LINKEDLIST autoDraw

	IFF #bReentry THEN WinX () ' Guy-07nov11-initialize WinX library

	hWindow = 0
	style = XWSStoWS (simpleStyle)

	IF hOwner THEN
		' get the binding
		idBinding = GetWindowLongA (hOwner, $$GWL_USERDATA)
		IF BINDING_Get (idBinding, @binding) THEN
			hWindow = CreateMdiChild (hOwner, title)
			IF hWindow THEN
				' Guy-11feb12-position the child window
				' position and dimensions are relative to the upper-left corner of the parent window's client area
				WinXGetWindowEffRect (hOwner, @rect)
				width = rect.right - rect.left
				height = rect.bottom - rect.top
				MoveWindow (hWindow, rect.left, rect.top, width, height, 0)
			ENDIF
		ENDIF
	ENDIF

	IFZ hWindow THEN
		rect.right = w
		rect.bottom = h
		IFZ menu THEN fMenu = 0 ELSE fMenu = 1
		AdjustWindowRectEx (&rect, style, fMenu, exStyle)
		'
		IF (style & $$WS_VSCROLL) = $$WS_VSCROLL THEN
			rect.right = rect.right + GetSystemMetrics ($$SM_CXVSCROLL)		' width vertical scroll bar
		ENDIF
		IF (style & $$WS_HSCROLL) = $$WS_HSCROLL THEN
			rect.bottom = rect.bottom + GetSystemMetrics ($$SM_CXHSCROLL)		' width horizontal scroll bar
		ENDIF
		'
		width = rect.right - rect.left
		IF width < 0 THEN width = 0
		IF x = -1 THEN
			screenWidth = GetSystemMetrics ($$SM_CXSCREEN)
			x = (screenWidth - width) >> 1
		ENDIF
		'
		height = rect.bottom - rect.top
		IF height < 0 THEN height = 0
		IF y = -1 THEN
			screenHeight = GetSystemMetrics ($$SM_CYSCREEN)
			y = (screenHeight - height) >> 1
		ENDIF
		'
		IFZ title THEN lpWindowName = 0 ELSE lpWindowName = &title
		hInst = GetModuleHandleA (0)
		hWindow = CreateWindowExA (exStyle, &#WinXclass$, lpWindowName, style, x, y, width, height, hOwner, menu, hInst, 0)
	ENDIF

	' now add the icon
	IF icon THEN
		SendMessageA (hWindow, $$WM_SETICON, $$ICON_BIG, icon)
		SendMessageA (hWindow, $$WM_SETICON, $$ICON_SMALL, icon)
	ENDIF

	' make a binding
	binding.hwnd = hWindow
	binding.hwndMDIParent = hOwner

	lpWindowName = 0
	dwStyle = $$WS_POPUP | $$TTS_NOPREFIX | $$TTS_ALWAYSTIP
	hInst = GetModuleHandleA (0)

	binding.hToolTips = CreateWindowExA (0, &$$TOOLTIPS_CLASS, lpWindowName, dwStyle, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, hWindow, 0, hInst, 0)

	binding.msgHandlers = HANDLER_New ()
	LinkedList_Init (@autoDraw)
	binding.autoDrawInfo = LINKEDLIST_New (autoDraw)

	binding.autoSizerInfo = AUTOSIZER_LinkedList_New ($$DIR_VERT)

	SetWindowLongA (hWindow, $$GWL_USERDATA, BINDING_New (binding))

	' and we're done
	RETURN hWindow
END FUNCTION
'
' ############################
' #####  WinXPath_Trim$  #####
' ############################
'
' Trims a path, directory or file
' Usage
'	dir$ = "  c:/Lonné  "
' dir$ = WinXPath_Trim$ (dir$)
' result: "  c:/Lonné  " --> "c:\\Lonné"
FUNCTION WinXPath_Trim$ (path$)

' the direct way----------------------------------------------------
'	dir$ = "  c:/Lonné  "
'	dir$ = TRIM$ (dir$)
' is buggy: "  c:/Lonné  " --> "c:\\Lonn" BAD!!!
' ------------------------------------------------------------------

	IFZ path$ THEN RETURN "" ' empty
	upp = LEN (path$) - 1

	' search the last non-space character, its index is iLast
	iLast = -1
	FOR i = upp TO 0 STEP -1
		IF (path${i} >= 33) && (path${i} <= 253) THEN
			iLast = i
			EXIT FOR
		ENDIF
	NEXT i
	IF iLast = -1 THEN RETURN "" ' empty directory path => return a null string

	' search the 1st non-space character, its index is iFirst
	FOR i = 0 TO iLast
		IF (path${i} >= 33) && (path${i} <= 253) THEN
			iFirst = i
			EXIT FOR
		ENDIF
	NEXT i

	length = iLast - iFirst + 1
	IF length < 1 THEN RETURN "" ' empty

	' trim off leading and trailing spaces
	trimmed$ = MID$ (path$, iFirst + 1, length)

	' make sure there are only Windows PathSlashes
	IF INSTR (trimmed$, "/") THEN XstTranslateChars (@trimmed$, "/", $$PathSlash$)

	RETURN trimmed$

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
	IF w < 1 RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  WinXPrint_Done  #####
' ############################
' Finishes printing
' hPrinter =  the handle to the printer
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXPrint_Done (hPrinter)
	SHARED PRINTINFO printInfo

	EndDoc (hPrinter)
	DeleteDC (hPrinter)
	DestroyWindow (printInfo.hCancelDlg)
	printInfo.continuePrinting = $$FALSE
	RETURN $$TRUE		' success
END FUNCTION
'
' ########################################
' #####  WinXPrint_LogUnitsPerPoint  #####
' ########################################
' Gets the conversion factor between logical units and points
FUNCTION DOUBLE WinXPrint_LogUnitsPerPoint (hPrinter, cyLog, cyPhys)
	RETURN (DOUBLE (GetDeviceCaps (hPrinter, $$LOGPIXELSY)) * DOUBLE (cyLog)) / (72.0 * DOUBLE (cyPhys))
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
	SHARED PRINTINFO printInfo
	AUTODRAWRECORD record
	BINDING binding
	RECT rect

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	' get the clipping rect for the printer
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
	WinXSetText (GetDlgItem (printInfo.hCancelDlg, $$DLGCANCEL_ST_PAGE), "Printing page " + STRING$ (pageNum) + " of " + STRING$ (pageCount) + "...")

	' play the auto draw info into the printer
	StartPage (hPrinter)
	autoDraw_draw (hPrinter, binding.autoDrawInfo, x, y)
	IF EndPage (hPrinter) <= 0 THEN RETURN

	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXPrint_PageSetup  #####
' #################################
' Displays a page setup dialog box to the user and updates the print parameters according to the result
' parent = the handle to the window that owns the dialog
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXPrint_PageSetup (parent)
	SHARED PRINTINFO printInfo
	PAGESETUPDLG pageSetupDlg
	UBYTE localeInfo[3]

	pageSetupDlg.lStructSize = SIZE (PAGESETUPDLG)
	pageSetupDlg.hwndOwner = parent
	pageSetupDlg.hDevMode = printInfo.hDevMode
	pageSetupDlg.hDevNames = printInfo.hDevNames
	pageSetupDlg.flags = $$PSD_DEFAULTMINMARGINS | $$PSD_MARGINS
	pageSetupDlg.rtMargin.left = printInfo.marginLeft
	pageSetupDlg.rtMargin.right = printInfo.marginRight
	pageSetupDlg.rtMargin.top = printInfo.marginTop
	pageSetupDlg.rtMargin.bottom = printInfo.marginBottom

	GetLocaleInfoA ($$LOCALE_USER_DEFAULT, $$LOCALE_IMEASURE, &localeInfo[], SIZE (localeInfo[]))
	IF (localeInfo[0] = '0') THEN
		' The user prefers the metric system, so convert the units
		pageSetupDlg.rtMargin.left = XLONG (DOUBLE (pageSetupDlg.rtMargin.left) * 2.54)
		pageSetupDlg.rtMargin.right = XLONG (DOUBLE (pageSetupDlg.rtMargin.right) * 2.54)
		pageSetupDlg.rtMargin.top = XLONG (DOUBLE (pageSetupDlg.rtMargin.top) * 2.54)
		pageSetupDlg.rtMargin.bottom = XLONG (DOUBLE (pageSetupDlg.rtMargin.bottom) * 2.54)
	ENDIF

	ret = PageSetupDlgA (&pageSetupDlg)
	IFZ ret THEN RETURN		' User did not click the OK button

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
' parent = the handle to the window that owns the print settins dialog box or 0 for none
' returns the handle to the printer or 0 on fail
FUNCTION WinXPrint_Start (minPage, maxPage, @rangeMin, @rangeMax, @cxPhys, @cyPhys, fileName$, showDialog, parent)
	SHARED PRINTINFO printInfo
	PRINTDLG printDlg
	DOCINFO docInfo

	' First, get a DC
	IF showDialog THEN
		printDlg.lStructSize = SIZE (PRINTDLG)
		printDlg.hwndOwner = parent
		printDlg.hDevMode = printInfo.hDevMode
		printDlg.hDevNames = printInfo.hDevNames
		printDlg.flags = printInfo.printSetupFlags | $$PD_RETURNDC | $$PD_USEDEVMODECOPIESANDCOLLATE
		IF rangeMin = 0 THEN
			printDlg.flags = printDlg.flags | $$PD_SELECTION
			printDlg.nFromPage = minPage
			printDlg.nToPage = maxPage
		ELSE
			printDlg.flags = printDlg.flags | $$PD_NOSELECTION
			IF rangeMax <> -1 THEN
				printDlg.flags = printDlg.flags | $$PD_PAGENUMS
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
			RETURN
		ENDIF
	ELSE
		IFZ printInfo.hDevMode THEN
			' Get a DEVMODE structure for the default printer in the default configuration
			printDlg.lStructSize = SIZE (PRINTDLG)
			printDlg.hDevMode = 0
			printDlg.hDevNames = 0
			printDlg.flags = $$PD_USEDEVMODECOPIESANDCOLLATE | $$PD_RETURNDEFAULT
			PrintDlgA (&printDlg)
			printInfo.hDevMode = printDlg.hDevMode
			printInfo.hDevNames = printDlg.hDevNames
		ENDIF
		' We need a pointer the the DEVMODE structure
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

		IF hDC = 0 THEN RETURN
	ENDIF

	' OK, we have a DC.  Now let's get the physical sizes
	cxPhys = GetDeviceCaps (hDC, $$PHYSICALWIDTH) - (GetDeviceCaps (hDC, $$LOGPIXELSX) * (printInfo.marginLeft + printInfo.marginRight)) \ 1000
	cyPhys = GetDeviceCaps (hDC, $$PHYSICALHEIGHT) - (GetDeviceCaps (hDC, $$LOGPIXELSY) * (printInfo.marginTop + printInfo.marginBottom)) \ 1000

	' Sort out an abort proc
	printInfo.hCancelDlg = WinXNewWindow (0, "Printing " + fileName$, -1, -1, 300, 70, $$XWSS_POPUP, 0, 0, 0)
	MoveWindow (WinXAddStatic (printInfo.hCancelDlg, "Preparing to print", 0, $$SS_CENTER, $$DLGCANCEL_ST_PAGE), 0, 8, 300, 24, 1) ' repaint
	MoveWindow (WinXAddButton (printInfo.hCancelDlg, "Cancel", 0, $$IDCANCEL), 110, 30, 80, 25, 1) ' repaint
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
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXProgress_SetMarquee (hProg, enable)
	IF enable THEN
		SetWindowLongA (hProg, $$GWL_STYLE, GetWindowLongA (hProg, $$GWL_STYLE) | $$PBS_MARQUEE)
		SendMessageA (hProg, $$PBM_SETMARQUEE, 1, 50)
	ELSE
		SetWindowLongA (hProg, $$GWL_STYLE, GetWindowLongA (hProg, $$GWL_STYLE) AND NOT $$PBS_MARQUEE)
		SendMessageA (hProg, $$PBM_SETMARQUEE, $$FALSE, 50)
	ENDIF
	RETURN $$TRUE		' success
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
	SendMessageA (hProg, $$PBM_SETPOS, 1000 * pos, 0)
	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXRegControlSizer  #####
' #################################
'
' [WinXRegControlSizer]
' Description = Registers a callback function to handle the sizing of controls
' Function    = WinXRegControlSizer (hWnd, FUNCADDR FnControlSizer)
' ArgCount    = 2
' Arg1        = hWnd : The window to register the callback for
' Arg2				= FnControlSizer : The address of the callback function
' Return      = $$TRUE on success or $$FALSE on error
' Remarks     = This function allows you to use your own control sizing code instead of the default
' WinX auto sizer.  You will have to resize all controls, including status bars and toolbars, if you use
' this callback.  The callback function has two XLONG parameters, w and h.
' See Also    =
' Examples    = WinXRegControlSizer (#hMain, &customSizer())
'
FUNCTION WinXRegControlSizer (hWnd, FUNCADDR FnControlSizer)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnControlSizer THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	' set the function
	binding.onDimControls = FnControlSizer
	RETURN BINDING_Update (idBinding, binding)
END FUNCTION
'
' ###################################
' #####  WinXRegMessageHandler  #####
' ###################################
'
' [WinXRegMessageHandler]
' Description = Registers a message handler callback function
' Function    = WinXRegMessageHandler (hWnd, wMsg, FUNCADDR FnMsgHandler)
' ArgCount    = 3
' Arg1        = hWnd : The window to register the callback for
' Arg2				= wMsg : The message the callback processes
' Arg3				= FnMsgHandler : The address of the callback function
' Return      = $$TRUE on success or $$FALSE on error
' Remarks     = This function is designed for developers who need custom processing of a windows message,
' for example, to use a custom control that sends custom messages.
' If you register a handler for a message WinX normally handles itself then the message handler is called
' first, then WinX performs the default behaviour. The callback function takes 4 XLONG parameters, hWnd, wMsg,
' wParam and lParam
' See Also    =
' Examples    = WinXRegMessageHandler (#hMain, $$WM_NOTIFY, &handleNotify())
'
' Guy-17mar11-Note:
' mainWndProc expects FUNCTION FnMsgHandler (hWnd, wMsg, wParam, lParam)
' to return a non-zero value if it handled the message wMsg
'
FUNCTION WinXRegMessageHandler (hWnd, wMsg, FUNCADDR FnMsgHandler)
	BINDING binding
	HANDLER handler

	IFZ hWnd THEN RETURN
	IFZ wMsg THEN RETURN
	IFZ FnMsgHandler THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	bOK = BINDING_Get (idBinding, @binding)
	IFF bOK THEN RETURN
	IFZ binding.msgHandlers THEN RETURN

	' prepare the handler
	handler.code = wMsg
	handler.handler = FnMsgHandler		' (hWnd, wMsg, wParam, lParam)

	' and add it
	index = HANDLER_AddItem (binding.msgHandlers, handler)
	IF index < 0 THEN RETURN

	RETURN $$TRUE		' success
END FUNCTION
'
' #####################################
' #####  WinXRegOnCalendarSelect  #####
' #####################################
' Sets the FnOnCalendarSelect callback
' hWnd = the handle to the window to set the callback for
' FnOnCalendarSelect = the address of the callback
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnCalendarSelect (hWnd, FUNCADDR FnOnCalendarSelect)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnCalendarSelect THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onCalendarSelect = FnOnCalendarSelect
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ###########################
' #####  WinXRegOnChar  #####
' ###########################
' Registers the FnOnChar callback function
' hWnd = the handle to the window to register the callback for
' FnOnChar = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnChar (hWnd, FUNCADDR FnOnChar)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnChar THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onChar = FnOnChar
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXRegOnClipChange  #####
' #################################
' Registers a callback for when the clipboard changes
' hWnd = the handle to the window
' FnOnFocusChange = the address of the callback
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnClipChange (hWnd, FUNCADDR FnOnClipChange)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnClipChange THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.hwndNextClipViewer = SetClipboardViewer (hWnd)

	binding.onClipChange = FnOnClipChange
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  WinXRegOnClose  #####
' ############################
' Registers the FnOnClose callback
FUNCTION WinXRegOnClose (hWnd, FUNCADDR FnOnClose)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnClose THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onClose = FnOnClose
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  WinXRegOnColumnClick  #####
' ##################################
' Registers the FnOnColumnClick callback for a list view control
' hWnd = the window to register the callback for
' FnOnColumnClick = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnColumnClick (hWnd, FUNCADDR FnOnColumnClick)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnColumnClick THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onColumnClick = FnOnColumnClick
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ##############################
' #####  WinXRegOnCommand  #####
' ##############################
' Registers the FnOnCommand callback function
' hWnd = the window to register
' func = the function to process commands
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnCommand (hWnd, FUNCADDR FnOnCommand)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnCommand THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onCommand = FnOnCommand
	BINDING_Update (idBinding, binding)

	RETURN $$TRUE		' success
END FUNCTION
'
' ###########################
' #####  WinXRegOnDrag  #####
' ###########################
' Register FnOnDrag
FUNCTION WinXRegOnDrag (hWnd, FUNCADDR FnOnDrag)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnDrag THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onDrag = FnOnDrag
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXRegOnDropFiles  #####
' ################################
' Registers the FnOnDropFiles callback for a window
' hWnd = the window to register the callback for
' FnOnDropFiles = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnDropFiles (hWnd, FUNCADDR FnOnDropFiles)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnDropFiles THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	DragAcceptFiles (hWnd, 1)
	binding.onDropFiles = FnOnDropFiles
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXRegOnEnterLeave  #####
' #################################
' Registers the FnOnEnterLeave callback
' hWnd = the handle to the window to register the callback for
' FnOnEnterLeave = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnEnterLeave (hWnd, FUNCADDR FnOnEnterLeave)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnEnterLeave THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onEnterLeave = FnOnEnterLeave
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  WinXRegOnFocusChange  #####
' ##################################
' Registers a callback for when the focus changes
' hWnd = the handle to the window
' FnOnFocusChange = the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnFocusChange (hWnd, FUNCADDR FnOnFocusChange)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnFocusChange THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onFocusChange = FnOnFocusChange
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ###########################
' #####  WinXRegOnItem  #####
' ###########################
' Registers the FnOnItem callback for a list view or a tree view control
' hWnd = the window to register the message for
' FnOnItem = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnItem (hWnd, FUNCADDR FnOnItem)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnItem THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onItem = FnOnItem
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ##############################
' #####  WinXRegOnKeyDown  #####
' ##############################
' Registers the FnOnKeyDown callback function
' hWnd = the handle to the window to register the callback for
' FnOnKeyDown = the address of the FnOnKeyDown callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnKeyDown (hWnd, FUNCADDR FnOnKeyDown)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnKeyDown THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onKeyDown = FnOnKeyDown
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  WinXRegOnKeyUp  #####
' ############################
' Registers the FnOnKeyUp callback function
' hWnd = the handle to the window to register the callback for
' FnOnKeyUp = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnKeyUp (hWnd, FUNCADDR FnOnKeyUp)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnKeyUp THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onKeyUp = FnOnKeyUp
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXRegOnLabelEdit  #####
' ################################
' Register the FnOnLabelEdit callback
FUNCTION WinXRegOnLabelEdit (hWnd, FUNCADDR FnOnLabelEdit)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnLabelEdit THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onLabelEdit = FnOnLabelEdit
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXRegOnMouseDown  #####
' ################################
' Registers a callback for when the mouse is pressed
' hWnd = the handle to the window
' FnOnMouseDown = the function to call when the mouse is pressed
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseDown (hWnd, FUNCADDR FnOnMouseDown)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnMouseDown THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onMouseDown = FnOnMouseDown
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXRegOnMouseMove  #####
' ################################
' Registers a callback for when the mouse is moved
' hWnd = the handle to the window
' FnOnMouseMove = the function to call when the mouse moves
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseMove (hWnd, FUNCADDR FnOnMouseMove)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnMouseMove THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onMouseMove = FnOnMouseMove
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ##############################
' #####  WinXRegOnMouseUp  #####
' ##############################
' Registers a callback for when the mouse is released
' hWnd = the handle to the window
' FnOnMouseUp = the function to call when the mouse is released
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseUp (hWnd, FUNCADDR FnOnMouseUp)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnMouseUp THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onMouseUp = FnOnMouseUp
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXRegOnMouseWheel  #####
' #################################
' Registers a callback for when the mouse wheel is rotated
' hWnd = the handle to the window
' FnOnMouseWheel = the function to call when the mouse wheel is rotated
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnMouseWheel (hWnd, FUNCADDR FnOnMouseWheel)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnMouseWheel THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onMouseWheel = FnOnMouseWheel
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  WinXRegOnPaint  #####
' ############################
'
' [WinXRegOnPaint]
' Description = Registers a callback function to process painting events
' Function    = WinXRegOnPaint (hWnd, FUNCADDR FnOnPaint)
' ArgCount    = 2
' Arg1        = hWnd : The handle to the window to register the callback for
' Arg2				= FnOnPaint : The address of the function to use for the callback
' Return      = $$TRUE on success or $$FALSE on fail
' Remarks     = The callback function must take a single XLONG parameter called
' hdc, this parameter is the handle to the device context to draw on.
' If you register this callback, autodraw is disabled
' See Also    =
' Examples    = WinXRegOnPaint (#hMain, &FnOnPaint())
'
FUNCTION WinXRegOnPaint (hWnd, FUNCADDR FnOnPaint)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnPaint THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	' set the paint function
	binding.onPaint = FnOnPaint
	BINDING_Update (idBinding, binding)

	RETURN $$TRUE		' success
END FUNCTION
'
' #############################
' #####  WinXRegOnScroll  #####
' #############################
' Registers the FnOnScroll callback
' hWnd = the handle to the window to register the callback for
' FnOnScroll = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnScroll (hWnd, FUNCADDR FnOnScroll)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnScroll THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onScroll = FnOnScroll
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' #############################
' #####  WinXRegOnSelect  #####
' #############################
' Registers the FnOnSelect callback for a list view or a tree view control
' hWnd = the window to register the message for
' FnOnSelect = the address of the callback FUNCTION
'              FUNCTION FnOnSelect (idCtr, notifyCode, parameter)
'              idCtr= nmhdr.idFrom, notifyCode = nmhdr.code, parameter = lParam
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnSelect (hWnd, FUNCADDR FnOnSelect)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnSelect THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onSelect = FnOnSelect
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXRegOnTrackerPos  #####
' #################################
' Registers the FnOnTrackerPos callback
' hWnd = the handle of the window to register the callback for
' FnOnTrackerPos = the address of the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXRegOnTrackerPos (hWnd, FUNCADDR FnOnTrackerPos)
	BINDING binding

	IFZ hWnd THEN RETURN
	IFZ FnOnTrackerPos THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.onTrackerPos = FnOnTrackerPos
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
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
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ | $$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		GOSUB QueryVariable
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ | $$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			SELECT CASE disposition
				CASE $$REG_CREATED_NEW_KEY
					IF createOnOpenFail THEN
						IF RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &result$, LEN (result$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
					ENDIF
				CASE $$REG_OPENED_EXISTING_KEY
					GOSUB QueryVariable
			END SELECT
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN ret

SUB QueryVariable
	IF RegQueryValueExA (hSubKey, &value$, 0, &type, 0, &cbSize) = $$ERROR_SUCCESS THEN
		IF (type = $$REG_BINARY) THEN
			result$ = NULL$ (cbSize)
			IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result$, &cbSize) = $$ERROR_SUCCESS THEN ret = $$TRUE
		ENDIF
	ELSE
		IF createOnOpenFail THEN
			IF RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &result$, LEN (result$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
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
' returns $$TRUE on success or $$FALSE on error
FUNCTION WinXRegistry_ReadInt (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result)
	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	four = 4
	ret = $$FALSE
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ | $$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result, &four) = $$ERROR_SUCCESS THEN
			ret = $$TRUE
		ELSE
			IF createOnOpenFail THEN
				IF RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &result, 4) = $$ERROR_SUCCESS THEN ret = $$TRUE
			ENDIF
		ENDIF
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ | $$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			SELECT CASE disposition
				CASE $$REG_CREATED_NEW_KEY
					IF createOnOpenFail THEN
						IF RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &result, 4) = $$ERROR_SUCCESS THEN ret = $$TRUE
					ENDIF
				CASE $$REG_OPENED_EXISTING_KEY
					IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result, &four) = $$ERROR_SUCCESS THEN ret = $$TRUE
			END SELECT
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

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
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ | $$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		GOSUB QueryVariable
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ | $$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			SELECT CASE disposition
				CASE $$REG_OPENED_EXISTING_KEY : GOSUB QueryVariable
				CASE $$REG_CREATED_NEW_KEY
					IF createOnOpenFail THEN
						IF RegSetValueExA (hSubKey, &value$, 0, $$REG_EXPAND_SZ, &result$, LEN (result$) + 1) = $$ERROR_SUCCESS THEN ret = $$TRUE
					ENDIF
					'
			END SELECT
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN ret

SUB QueryVariable
	IF RegQueryValueExA (hSubKey, &value$, 0, &type, 0, &cbSize) = $$ERROR_SUCCESS THEN
		IF (type = $$REG_EXPAND_SZ) || (type = $$REG_SZ) || (type = $$REG_MULTI_SZ) THEN
			result$ = NULL$ (cbSize)
			IF RegQueryValueExA (hSubKey, &value$, 0, &type, &result$, &cbSize) = $$ERROR_SUCCESS THEN
				ret = $$TRUE
			ENDIF
		ENDIF
	ELSE
		IF createOnOpenFail THEN
			IF RegSetValueExA (hSubKey, &value$, 0, $$REG_EXPAND_SZ, &result$, LEN (result$) + 1) = $$ERROR_SUCCESS THEN ret = $$TRUE
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
' buffer$ = the binary data to write into the registry
' returns $$TRUE on success or $$FALSE on error
FUNCTION WinXRegistry_WriteBin (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, buffer$)
	IFZ sa.length THEN pSA = 0 ELSE pSA = &sa

	ret = $$FALSE
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ | $$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		IF RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &buffer$, LEN (buffer$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ | $$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			IF RegSetValueExA (hSubKey, &value$, 0, $$REG_BINARY, &buffer$, LEN (buffer$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN ret
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
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ | $$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		IF RegSetValueExA (hSubKey, &value$, 0, $$REG_DWORD, &int, 4) = $$ERROR_SUCCESS THEN ret = $$TRUE
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ | $$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
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
	IF RegOpenKeyExA (hKey, &subKey$, 0, $$KEY_READ | $$KEY_WRITE, &hSubKey) = $$ERROR_SUCCESS THEN
		IF RegSetValueExA (hSubKey, &value$, 0, $$REG_SZ, &buffer$, LEN (buffer$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
		RegCloseKey (hSubKey)
	ELSE
		IF RegCreateKeyExA (hKey, &subKey$, 0, 0, 0, $$KEY_READ | $$KEY_WRITE, pSA, &hSubKey, &disposition) = $$ERROR_SUCCESS THEN
			IF RegSetValueExA (hSubKey, &value$, 0, $$REG_SZ, &buffer$, LEN (buffer$)) = $$ERROR_SUCCESS THEN ret = $$TRUE
			RegCloseKey (hSubKey)
		ENDIF
	ENDIF

	RETURN ret
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

	si.cbSize = SIZE (SCROLLINFO)
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
			RETURN
	END SELECT

	i = ABS (scrollingDirection)
	IF i THEN
		SELECT CASE direction
			CASE $$DIR_HORIZ
				FOR i = 1 TO i
					SendMessageA (hWnd, $$WM_HSCROLL, wParam, 0)
				NEXT i
			CASE $$DIR_VERT
				FOR i = 1 TO i
					SendMessageA (hWnd, $$WM_VSCROLL, wParam, 0)
				NEXT i
			CASE ELSE
				RETURN
		END SELECT
	ENDIF

	RETURN $$TRUE		' success
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
	BINDING binding
	RECT rect
	SCROLLINFO si

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	GetClientRect (hWnd, &rect)

	si.cbSize = SIZE (SCROLLINFO)
	si.fMask = $$SIF_PAGE | $$SIF_DISABLENOSCROLL

	SELECT CASE direction
		CASE $$DIR_HORIZ
			binding.hScrollPageM = mul
			binding.hScrollPageC = constant
			binding.hScrollUnit = scrollUnit
			sb = $$SB_HORZ

			si.nPage = (rect.right - rect.left) * mul + constant
		CASE $$DIR_VERT
			binding.vScrollPageM = mul
			binding.vScrollPageC = constant
			binding.vScrollUnit = scrollUnit
			sb = $$SB_VERT

			si.nPage = (rect.bottom - rect.top) * mul + constant
		CASE ELSE
			RETURN
	END SELECT

	BINDING_Update (idBinding, binding)
	SetScrollInfo (hWnd, sb, &si, 1) ' redraw

	RETURN $$TRUE		' success
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

	si.cbSize = SIZE (SCROLLINFO)
	si.fMask = $$SIF_POS
	si.nPos = pos
	SELECT CASE direction
		CASE $$DIR_HORIZ : SetScrollInfo (hWnd, $$SB_HORZ, &si, 1) ' redraw
		CASE $$DIR_VERT : SetScrollInfo (hWnd, $$SB_VERT, &si, 1) ' redraw
	END SELECT

	RETURN $$TRUE		' success
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
			RETURN
	END SELECT

	si.cbSize = SIZE (SCROLLINFO)
	si.fMask = $$SIF_RANGE | $$SIF_DISABLENOSCROLL
	si.nMin = min
	si.nMax = max

	SetScrollInfo (hWnd, sb, &si, 1) ' redraw

	GetClientRect (hWnd, &rect)
	sizeWindow (hWnd, rect.right, rect.bottom)

	RETURN $$TRUE		' success
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
	IF horiz THEN style = style | $$WS_HSCROLL ELSE style = style AND NOT $$WS_HSCROLL
	IF vert THEN style = style | $$WS_VSCROLL ELSE style = style AND NOT $$WS_VSCROLL
	SetWindowLongA (hWnd, $$GWL_STYLE, style)
	SetWindowPos (hWnd, 0, 0, 0, 0, 0, $$SWP_NOMOVE | $$SWP_NOSIZE | $$SWP_NOZORDER | $$SWP_FRAMECHANGED)
	RETURN $$TRUE		' success
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

	ScrollWindowEx (hWnd, deltaX, deltaY, 0, &rect, 0, 0, $$SW_ERASE | $$SW_INVALIDATE)
	RETURN $$TRUE		' success
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
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.hCursor = hCursor
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  WinXSetDefaultFont  #####
' ################################
' Sets the font for a control to the default GUI font
' hCtr = the handle to the control
' hFont = the handle to the font
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetDefaultFont (hCtr)
	IFZ hCtr THEN RETURN		' ignore a null handle
	hFont = GetStockObject ($$DEFAULT_GUI_FONT)
	IFZ hFont THEN RETURN		' ignore a null handle
	SendMessageA (hCtr, $$WM_SETFONT, hFont, 0)
	DeleteObject (hFont)		' release the font
	RETURN $$TRUE		' success
END FUNCTION
'
' #########################
' #####  WinXSetFont  #####
' #########################
' Sets the font for a control
' hCtr = the handle to the control
' hFont = the handle to the font
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetFont (hCtr, hFont)
	IFZ hCtr THEN RETURN		' ignore a null handle
	IFZ hFont THEN RETURN		' ignore a null handle
	SendMessageA (hCtr, $$WM_SETFONT, hFont, 0)
	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  WinXSetFontAndRedraw  #####
' ##################################
' Sets the font for a control
' hCtr = the handle to the control
' hFont = the handle to the font
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetFontAndRedraw (hCtr, hFont)
	IFZ hCtr THEN RETURN		' ignore a null handle
	IFZ hFont THEN RETURN		' ignore a null handle
	SendMessageA (hCtr, $$WM_SETFONT, hFont, 1)		' redraw
	RETURN $$TRUE		' success
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
	BINDING binding
	RECT rect

	IFZ hWnd THEN RETURN
	IF w < 0 THEN w = 0
	IF h < 0 THEN h = 0

	rect.left = 0
	rect.top = 0
	rect.right = w
	rect.bottom = h

	style = GetWindowLongA (hWnd, $$GWL_STYLE)
	menu = GetMenu (hWnd)
	IFZ menu THEN fMenu = 0 ELSE fMenu = 1
	exStyle = GetWindowLongA (hWnd, $$GWL_EXSTYLE)
	AdjustWindowRectEx (&rect, style, fMenu, exStyle)

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	binding.minW = rect.right - rect.left
	binding.minH = rect.bottom - rect.top
	BINDING_Update (idBinding, binding)

	RETURN $$TRUE		' success
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

	wp.length = SIZE (WINDOWPLACEMENT)
	IFZ GetWindowPlacement (hWnd, &wp) THEN RETURN

	IF wp.showCmd THEN wp.showCmd = minMax
	IF (restored.left | restored.right | restored.top | restored.bottom) THEN wp.rcNormalPosition = restored

	ret = SetWindowPlacement (hWnd, &wp)
	IF ret THEN ret = $$TRUE  ' true should be coded $$TRUE
	GetClientRect (hWnd, &rect)
	sizeWindow (hWnd, rect.right - rect.left, rect.bottom - rect.top)

	RETURN ret
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
'
FUNCTION WinXSetStyle (hWnd, add, addEx, sub, subEx)

	IFZ hWnd THEN RETURN

	bOK = $$TRUE
	IF add <> sub THEN ' if add same as sub, style is unchanged
		'
		style = GetWindowLongA (hWnd, $$GWL_STYLE)
		styleNew = style
		'
		' add before subtracting
		IF add THEN
			' add only if not there
			IF (styleNew & add) <> add THEN styleNew = styleNew | add
		ENDIF
		'
		' subtract sub from styleNew
		IF sub THEN
			' subtract only if present
			IF (styleNew & sub) = sub THEN styleNew = styleNew & (~sub)
		ENDIF
		'
		' update the control only for a style change
		IF styleNew <> style THEN
			SetWindowLongA (hWnd, $$GWL_STYLE, styleNew)
			'
			' Guy-18mar12-added $$ES_READONLY handling
			IF add = $$ES_READONLY THEN SendMessageA (hWnd, $$EM_SETREADONLY, 1, 0)
			IF sub = $$ES_READONLY THEN SendMessageA (hWnd, $$EM_SETREADONLY, 0, 0)
			'
			styleUpd = GetWindowLongA (hWnd, $$GWL_STYLE)
			IF styleUpd <> styleNew THEN bOK = $$FALSE		' fail
		ENDIF
		'
	ENDIF

	IF addEx <> subEx THEN
		'
		styleEx = GetWindowLongA (hWnd, $$GWL_EXSTYLE)
		styleExNew = styleEx
		'
		' add before subtracting
		IF addEx THEN
			IF (styleExNew & addEx) <> addEx THEN styleExNew = styleExNew | addEx
		ENDIF
		'
		IF subEx THEN
			IF (styleExNew & subEx) = subEx THEN styleExNew = styleExNew & (~subEx)
		ENDIF
		'
		IF styleExNew <> styleEx THEN
			SetWindowLongA (hWnd, $$GWL_EXSTYLE, styleExNew)
			styleExUpd = GetWindowLongA (hWnd, $$GWL_EXSTYLE)
			IF styleExUpd <> styleExNew THEN bOK = $$FALSE		' fail
		ENDIF
		'
	ENDIF
	RETURN bOK
END FUNCTION
'
' #########################
' #####  WinXSetText  #####
' #########################
' Sets the text for a control
' hWnd = the handle to the control
' text = the text to set
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetText (hWnd, STRING text)
	IFZ hWnd THEN RETURN
	IFZ SetWindowTextA (hWnd, &text) THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXSetWindowColour  #####
' #################################
' Changes the window background color
' hWnd = the window to change the color for
' color = the new color
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSetWindowColour (hWnd, color)
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	IF binding.backCol THEN DeleteObject (binding.backCol)
	binding.backCol = CreateSolidBrush (color)
	BINDING_Update (idBinding, binding)
	RETURN $$TRUE		' success
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
	BINDING binding

	IFZ hToolbar THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	' set the toolbar parent
	SetParent (hToolbar, hWnd)

	' set the toolbar style
	' Guy-13jan11-SetWindowLongA (hToolbar, $$GWL_STYLE, GetWindowLongA (hToolbar, $$GWL_STYLE)|$$WS_CHILD|$$WS_VISIBLE|$$CCS_TOP)
	add = $$WS_CHILD | $$WS_VISIBLE | $$CCS_TOP
	WinXSetStyle (hToolbar, add, 0, 0, 0)

	SendMessageA (hToolbar, $$TB_SETPARENT, hWnd, 0)

	' and update the binding
	binding.hBar = hToolbar
	RETURN BINDING_Update (idBinding, binding)
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
	RETURN $$TRUE		' success
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
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSplitter_GetPos (series, hCtr, @position, @docked)
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]		'info for the autosizer
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]
	SPLITTERINFO splitterInfo

	IFF series >= 0 && series <= UBOUND (AUTOSIZER_LinkedList[]) THEN RETURN
	IFF AUTOSIZER_LinkedList[series].inUse THEN RETURN

	' Walk the list untill we find the autodraw record we need
	found = $$FALSE
	i = AUTOSIZER_LinkedList[series].iHead
	DO WHILE i > -1
		IF AUTOSIZERINFO_array[series, i].hwnd = hCtr THEN
			found = $$TRUE
			EXIT DO
		ENDIF
		i = AUTOSIZERINFO_array[series, i].nextItem
	LOOP

	IFF found THEN RETURN

	iSplitter = GetWindowLongA (AUTOSIZERINFO_array[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (iSplitter, @splitterInfo)

	IF splitterInfo.docked THEN
		position = splitterInfo.docked
		docked = $$TRUE
	ELSE
		position = AUTOSIZERINFO_array[series, i].size
		docked = $$FALSE
	ENDIF

	RETURN $$TRUE		' success
END FUNCTION
'
' #################################
' #####  WinXSplitter_SetPos  #####
' #################################
' Sets the current position of a splitter control
' series = the series to which the splitter belongs
' hCtr = the control the splitter is attached to
' position = the new position for the splitter
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSplitter_SetPos (series, hCtr, position, docked)
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]		'info for the autosizer
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]
	SPLITTERINFO splitterInfo
	RECT rect

	IFF series >= 0 && series <= UBOUND (AUTOSIZER_LinkedList[]) THEN RETURN
	IFF AUTOSIZER_LinkedList[series].inUse THEN RETURN

	' Walk the list untill we find the autosizer record we need
	found = $$FALSE
	i = AUTOSIZER_LinkedList[series].iHead
	DO WHILE i > -1
		IF AUTOSIZERINFO_array[series, i].hwnd = hCtr THEN
			found = $$TRUE
			EXIT DO
		ENDIF
		i = AUTOSIZERINFO_array[series, i].nextItem
	LOOP

	IFF found THEN RETURN

	iSplitter = GetWindowLongA (AUTOSIZERINFO_array[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (iSplitter, @splitterInfo)

	IF docked THEN
		AUTOSIZERINFO_array[series, i].size = 8
		splitterInfo.docked = position
	ELSE
		AUTOSIZERINFO_array[series, i].size = position
		splitterInfo.docked = 0
	ENDIF

	SPLITTERINFO_Update (iSplitter, splitterInfo)

	GetClientRect (GetParent (hCtr), &rect)
	sizeWindow (GetParent (hCtr), rect.right - rect.left, rect.bottom - rect.top)

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
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXSplitter_SetProperties (series, hCtr, min, max, dock)
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]		'info for the autosizer
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]
	SPLITTERINFO splitterInfo

	IFZ hCtr THEN RETURN
	IFF series >= 0 && series <= UBOUND (AUTOSIZER_LinkedList[]) THEN RETURN
	IFF AUTOSIZER_LinkedList[series].inUse THEN RETURN

	' Walk the list until we find the autodraw record we need
	found = $$FALSE
	i = AUTOSIZER_LinkedList[series].iHead
	DO WHILE i > -1
		IF AUTOSIZERINFO_array[series, i].hwnd = hCtr THEN
			found = $$TRUE
			EXIT DO
		ENDIF
		i = AUTOSIZERINFO_array[series, i].nextItem
	LOOP

	IFF found THEN RETURN

	iSplitter = GetWindowLongA (AUTOSIZERINFO_array[series, i].hSplitter, $$GWL_USERDATA)
	SPLITTERINFO_Get (iSplitter, @splitterInfo)
	splitterInfo.min = min
	splitterInfo.max = max

	IFF dock THEN
		splitterInfo.dock = $$DOCK_DISABLED
	ELSE
		IF (AUTOSIZER_LinkedList[series].direction AND $$DIR_REVERSE) = $$DIR_REVERSE THEN
			splitterInfo.dock = $$DOCK_BACKWARD
		ELSE
			splitterInfo.dock = $$DOCK_FORWARD
		ENDIF
	ENDIF

	SPLITTERINFO_Update (iSplitter, splitterInfo)

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
	BINDING binding

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN ""		' fail

	IF part > binding.statusParts THEN RETURN ""		' fail

	cBuffer = SendMessageA (binding.hStatus, $$SB_GETTEXTLENGTH, part, 0)
	buffer$ = NULL$ (cBuffer + 1)
	SendMessageA (binding.hStatus, $$SB_GETTEXT, part, &buffer$)
	ret$ = CSTRING$ (&buffer$)
	RETURN ret$
END FUNCTION
'
' ################################
' #####  WinXStatus_SetText  #####
' ################################
' Sets the text in a status bar
' hWnd = the window containing the status bar
' part = the partition to set the text for, zero-based
' text = the text to set the status to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXStatus_SetText (hWnd, part, STRING text)
	BINDING binding

	IFZ hWnd THEN RETURN

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	' validate argument part (zero-based partition)
	bOK = $$TRUE		' assume success
	SELECT CASE TRUE
		CASE part = 0
		CASE part < 0
			err$ = "partition " + STRING$ (part) + " should be >= 0 (zero-based)"
			bOK = $$FALSE
			'
		CASE ELSE
			IF part > binding.statusParts THEN
				err$ = "partition " + STRING$ (part) + " should be <= " + STRING$ (binding.statusParts)
				bOK = $$FALSE
			ENDIF
			'
	END SELECT
	IFF bOK THEN
		text = "Error: " + err$
		part = 0		' show the error message in the 1st partition
	ENDIF

	ret = SendMessageA (binding.hStatus, $$SB_SETTEXT, part, &text)
	IFZ ret THEN bOK = $$FALSE

	RETURN bOK
END FUNCTION
'
' #############################
' #####  WinXTabs_AddTab  #####
' #############################
' Add a new tab to a tab control
' hTabs = the handle to the tab control
' label = the label for the new tab
' insertAfter = the index to insert at, -1 for to append
' returns the index of the tab, -1 on fail
FUNCTION WinXTabs_AddTab (hTabs, STRING label, index)
	TC_ITEM tci

	tci.mask = $$TCIF_PARAM | $$TCIF_TEXT
	tci.pszText = &label
	tci.cchTextMax = LEN (label)
	tci.lParam = AUTOSIZER_LinkedList_New ($$DIR_VERT)

	IF index < 0 THEN index = SendMessageA (hTabs, $$TCM_GETITEMCOUNT, 0, 0)

	indexAdd = SendMessageA (hTabs, $$TCM_INSERTITEM, index, &tci)
	IF indexAdd < 0 THEN RETURN -1		' fail
	RETURN indexAdd
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
	' Guy-13jan11-RETURN SendMessageA (hTabs, $$TCM_DELETEITEM, iTab, 0)
	ret = SendMessageA (hTabs, $$TCM_DELETEITEM, iTab, 0)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ########################################
' #####  WinXTab_GetAutosizerSeries  #####
' ########################################
' Gets the auto sizer series for a tab
' hTabs = the tab control
' iTab = the index of the tab to get the autosizer series for
' returns the idCtr of the autosizer series or -1 on fail
FUNCTION WinXTabs_GetAutosizerSeries (hTabs, iTab)
	TC_ITEM tci

	tci.mask = $$TCIF_PARAM
	IFZ SendMessageA (hTabs, $$TCM_GETITEM, iTab, &tci) THEN RETURN -1		' fail
	RETURN tci.lParam
END FUNCTION
'
' ####################################
' #####  WinXTabs_GetCurrentTab  #####
' ####################################
' Gets the index of the currently selected tab
' hTabs = the handle to the tab control
' returns the index of the currently selected tab, -1 fail
FUNCTION WinXTabs_GetCurrentTab (hTabs)
	IFZ hTabs THEN RETURN -1		' fail
	currTab = SendMessageA (hTabs, $$TCM_GETCURSEL, 0, 0)
	IF currTab < 0 THEN RETURN -1		' fail
	RETURN currTab
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
	IFZ hTabs THEN RETURN
	ret = SendMessageA (hTabs, $$TCM_SETCURSEL, iTab, 0)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
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

	RETURN $$TRUE		' success
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
		ret = SendMessageA (hDTP, $$DTM_SETSYSTEMTIME, $$GDT_VALID, &time)
	ELSE
		ret = SendMessageA (hDTP, $$DTM_SETSYSTEMTIME, $$GDT_NONE, 0)
	ENDIF
	' Guy-13jan11-added checking
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ###################################
' #####  WinXToolbar_AddButton  #####
' ###################################
' Adds a button to a toolbar
' hToolbar = the toolbar to add the button to
' commandId = the idCtr for the button
' iImage = the index of the image to use for the button
' tooltipText = the text to use for the tooltip
' optional = $$TRUE if this button is optional, otherwise $$FALSE
' !!THIS FEATURE IS NOT YET IMPLEMENTED, YOU SHOULD SET THIS PARAMETER TO $$FALSE!!
' moveable = $$TRUE if the button can be move, otherwise $$FALSE
' !!THIS FEATURE IS NOT YET IMPLEMENTED, YOU SHOULD SET THIS PARAMETER TO $$FALSE!!
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddButton (hToolbar, commandId, iImage, STRING tooltipText, optional, moveable)
	TBBUTTON bt

	bt.iBitmap = iImage
	bt.idCommand = commandId
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_AUTOSIZE | $$BTNS_BUTTON
	bt.iString = &tooltipText

	' Guy-13jan11-RETURN SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	ret = SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ####################################
' #####  WinXToolbar_AddControl  #####
' ####################################
' Adds a control to a toolbar control
' hToolbar = the handle to the toolbar to add the control to
' hCtr = the handle to the control
' w = the width of the control in the toolbar, the control will be resized to the height of the toolbar and this width
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddControl (hToolbar, hCtr, w)
	TBBUTTON bt
	RECT rect2

	bt.iBitmap = w + 4
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_SEP

	iControl = SendMessageA (hToolbar, $$TB_BUTTONCOUNT, 0, 0)
	SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	SendMessageA (hToolbar, $$TB_GETITEMRECT, iControl, &rect2)

	MoveWindow (hCtr, rect2.left + 2, rect2.top, w, rect2.bottom - rect2.top, 1) ' repaint

	SetParent (hCtr, hToolbar)

	RETURN $$TRUE		' success
END FUNCTION
'
' ######################################
' #####  WinXToolbar_AddSeparator  #####
' ######################################
' Adds a separator to a toolbar
' hToolbar = the toolbar to add the separator to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddSeparator (hToolbar)
	TBBUTTON bt

	bt.iBitmap = 4
	bt.fsState = $$TBSTATE_ENABLED
	bt.fsStyle = $$BTNS_SEP

	' Guy-13jan11-RETURN SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	ret = SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' #########################################
' #####  WinXToolbar_AddToggleButton  #####
' #########################################
' Adds a toggle button to a toolbar
' hToolbar = the handle to the toolbar
' commandId = the command constant the button will generate
' iImage = the zero-based index of the image for this button
' tooltipText = the text for this button's tooltip
' mutex = $$TRUE if this toggle is mutually exclusive, ie. only one from a group can be toggled at a time
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_AddToggleButton (hToolbar, commandId, iImage, STRING tooltipText, mutex, optional, moveable)
	TBBUTTON bt

	bt.iBitmap = iImage
	bt.idCommand = commandId
	bt.fsState = $$TBSTATE_ENABLED

	style = $$BTNS_AUTOSIZE
	IF mutex THEN style = style | $$BTNS_CHECKGROUP ELSE style = style | $$BTNS_CHECK
	bt.fsStyle = style

	IF tooltipText THEN bt.iString = &tooltipText

	' Guy-13jan11-RETURN SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	ret = SendMessageA (hToolbar, $$TB_ADDBUTTONS, 1, &bt)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ######################################
' #####  WinXToolbar_EnableButton  #####
' ######################################
' Enables or disables a toolbar button
' hToolbar = the handle to the toolbar on which the button resides
' idButton = the command idCtr of the button
' enable = $$TRUE to enable the button, $$FALSE to disable
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_EnableButton (hToolbar, idButton, enable)
	IFZ hToolbar THEN RETURN

	' Guy-13jan11-RETURN SendMessageA (hToolbar, $$TB_ENABLEBUTTON, idButton, enable)
	IFZ enable THEN fEnable = 0 ELSE fEnable = 1		' enable
	ret = SendMessageA (hToolbar, $$TB_ENABLEBUTTON, idButton, fEnable)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ######################################
' #####  WinXToolbar_ToggleButton  #####
' ######################################
' Toggles a toolbar button
' hToolbar = the handle to the toolbar on which the button resides
' idButton = the command idCtr of the button
' on = $$TRUE to toggle the button on, $$FALSE to toggle the button off
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXToolbar_ToggleButton (hToolbar, idButton, on)
	state = SendMessageA (hToolbar, $$TB_GETSTATE, idButton, 0)
	IF on THEN state = state | $$TBSTATE_CHECKED ELSE state = state AND NOT ($$TBSTATE_CHECKED)
	' Guy-13jan11-SendMessageA (hToolbar, $$TB_SETSTATE, idButton, state)
	ret = SendMessageA (hToolbar, $$TB_SETSTATE, idButton, state)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
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
	' first, get any existing labels
	hLeft = SendMessageA (hTracker, $$TBM_GETBUDDY, 1, 0)
	hRight = SendMessageA (hTracker, $$TBM_GETBUDDY, $$FALSE, 0)

	IF hLeft THEN DestroyWindow (hLeft)
	IF hRight THEN DestroyWindow (hRight)

	' we need to get the width and height of the strings
	hdcMem = CreateCompatibleDC (0)

	' Guy-11dec08-SelectObject (hdcMem, GetStockObject ($$DEFAULT_GUI_FONT))
	hFont = GetStockObject ($$DEFAULT_GUI_FONT)
	SelectObject (hdcMem, hFont)

	GetTextExtentPoint32A (hdcMem, &leftLabel, LEN (leftLabel), &left)
	GetTextExtentPoint32A (hdcMem, &rightLabel, LEN (rightLabel), &right)
	DeleteDC (hdcMem)
	DeleteObject (hFont)		' release the font

	' now create the windows
	parent = GetParent (hTracker)
	hLeft = WinXAddStatic (parent, leftLabel, 0, $$SS_CENTER, 1)
	hRight = WinXAddStatic (parent, rightLabel, 0, $$SS_CENTER, 1)
	MoveWindow (hLeft, 0, 0, left.cx + 4, left.cy + 4, 1) ' repaint
	MoveWindow (hRight, 0, 0, right.cx + 4, right.cy + 4, 1) ' repaint

	' and set them
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
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTracker_SetPos (hTracker, newPos)
	SendMessageA (hTracker, $$TBM_SETPOS, $$TRUE, newPos)
	RETURN $$TRUE		' success
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
	' Guy-25oct09-SendMessageA (hTracker, $$TBM_SETRANGE, $$TRUE, MAKELONG(min, max))
	SendMessageA (hTracker, $$TBM_SETRANGE, 1, MAKELONG (min, max))
	SendMessageA (hTracker, $$TBM_SETTICFREQ, ticks, 0)
	RETURN $$TRUE		' success
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
	' Guy-25oct09-SendMessageA (hTracker, $$TBM_SETSEL, $$TRUE, MAKELONG(start, end))
	SendMessageA (hTracker, $$TBM_SETSEL, 1, MAKELONG (start, end))
END FUNCTION
'
' ########################################
' #####  WinXTreeView_AddCheckBoxes  #####
' ########################################
' Adds the check boxes to a tree view if they are missing
' $$TVS_CHECKBOXES: Enables items in a tree view control to be displayed
' as check boxes. This style uses item state images to produce the check
' box effect.
' returns $$TRUE on success or $$FALSE on fail
'
FUNCTION WinXTreeView_AddCheckBoxes (hTV)

	IFZ hTV THEN RETURN

	' add the check boxes if they are missing
	style = GetWindowLongA (hTV, $$GWL_STYLE)
	IFZ (style & $$TVS_CHECKBOXES) <> $$TVS_CHECKBOXES THEN
		style = style | $$TVS_CHECKBOXES
		SetWindowLongA (hTV, $$GWL_STYLE, style)
	ENDIF
	RETURN $$TRUE		' success

END FUNCTION
'
' ##################################
' #####  WinXTreeView_AddItem  #####
' ##################################
' Adds an item to a tree view control
' hTV = the handle to the tree view control to add the item to
' hParent = The parent item, 0 or $$TVI_ROOT for root
' hInsertAfter = The item to insert after, can be $$TVI_FIRST or $$TVI_LAST
' iImage = the index of the image for this item
' iImageSel = the index of the image to use when the item is expanded
' item = the text for the item
' data = extra data to associate with this item
' returns the handle to the item or 0 on fail
FUNCTION WinXTreeView_AddItem (hTV, hParent, hInsertAfter, iImage, iImageSelect, STRING item)
	TV_INSERTSTRUCT tvis

	IFZ hTV THEN RETURN

	tvis.hParent = hParent
	tvis.hInsertAfter = hInsertAfter

	' fill structure TV_ITEM tvis.item
	tvis.item.mask = $$TVIF_IMAGE | $$TVIF_SELECTEDIMAGE | $$TVIF_TEXT | $$TVIF_PARAM
	tvis.item.pszText = &item
	tvis.item.cchTextMax = LEN (item)
	tvis.item.iImage = iImage
	tvis.item.iSelectedImage = iImageSelect
	tvis.item.lParam = 0

	RETURN SendMessageA (hTV, $$TVM_INSERTITEM, 0, &tvis)
END FUNCTION
'
' #######################################
' #####  WinXTreeView_CollapseItem  #####
' #######################################
' Collapses an item of a tree view control
' hTV = the handle to the tree view
' hItem = the handle to the item to collapse, 0 for the root node
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTreeView_CollapseItem (hTV, hItem)
	IFZ hTV THEN RETURN
	IFZ hItem THEN hItem = WinXTreeView_GetRootItem (hTV)
	SendMessageA (hTV, $$TVM_EXPAND, $$TVE_COLLAPSE, hItem)
	RETURN $$TRUE		' success
END FUNCTION
'
' ###################################
' #####  WinXTreeView_MoveItem  #####
' ###################################
' Move an item and it's children
' hTV = the handle to the tree view control
' hParentItem = The parent of the item to move this item to
' hItemInsertAfter = The item that will come before this item
' hItem = the item to move
' returns the new handle to the item
FUNCTION WinXTreeView_CopyItem (hTV, hParentItem, hItemInsertAfter, hItem)
	TV_ITEM tvi
	TV_INSERTSTRUCT tvis

	IFZ hTV THEN RETURN

	tvi.mask = $$TVIF_CHILDREN | $$TVIF_HANDLE | $$TVIF_IMAGE | $$TVIF_PARAM | $$TVIF_SELECTEDIMAGE | $$TVIF_STATE | $$TVIF_TEXT
	tvi.hItem = hItem
	buffer$ = NULL$ ($$MAX_PATH)
	tvi.pszText = &buffer$
	tvi.cchTextMax = $$MAX_PATH
	tvi.stateMask = 0xFFFFFFFF
	ret = SendMessageA (hTV, $$TVM_GETITEM, 0, &tvi)
	IFZ ret THEN RETURN
	tvis.hParent = hParentItem
	tvis.hInsertAfter = hItemInsertAfter
	tvis.item = tvi
	tvis.item.mask = $$TVIF_IMAGE | $$TVIF_PARAM | $$TVIF_SELECTEDIMAGE | $$TVIF_STATE | $$TVIF_TEXT
	tvis.item.cChildren = 0
	tvis.item.hItem = SendMessageA (hTV, $$TVM_INSERTITEM, 0, &tvis)

	IF tvi.cChildren <> 0 THEN
		child = WinXTreeView_GetChildItem (hTV, hItem)
		WinXTreeView_CopyItem (hTV, tvis.item.hItem, $$TVI_FIRST, child)
		prevChild = child
		child = WinXTreeView_GetNextItem (hTV, prevChild)
		DO WHILE child <> 0
			WinXTreeView_CopyItem (hTV, tvis.item.hItem, prevChild, child)
			prevChild = child
			child = WinXTreeView_GetNextItem (hTV, prevChild)
		LOOP
	ENDIF

	RETURN tvis.item.hItem
END FUNCTION
'
' #########################################
' #####  WinXTreeView_DeleteAllItems  #####
' #########################################
' Delete all items
' hTV = the handle to the tree view
' returns $$TRUE on success or $$FALSE
FUNCTION WinXTreeView_DeleteAllItems (hTV)		' clear the tree view

	IFZ hTV THEN RETURN

	count = SendMessageA (hTV, $$TVM_GETCOUNT, 0, 0)
	IF count < 1 THEN RETURN $$TRUE		' success

	' protect from an endless loop
	id = LOCK_Get_id_hCtr (hLV)
	statusOld = LOCK_Get_skipOnSelect (id)

	IF statusOld THEN
		ret = SendMessageA (hTV, $$TVM_DELETEITEM, 0, $$TVI_ROOT)
	ELSE
		LOCK_Set_skipOnSelect (id, $$TRUE) ' freeze .onSelect
		ret = SendMessageA (hTV, $$TVM_DELETEITEM, 0, $$TVI_ROOT)
		LOCK_Set_skipOnSelect (id, $$FALSE) ' use .onSelect
	ENDIF

	IFZ ret THEN RETURN

	RETURN $$TRUE		' success

END FUNCTION
'
' #####################################
' #####  WinXTreeView_DeleteItem  #####
' #####################################
' Delete an item, including all children
' hTV = the handle to the tree view
' hItem = the handle to the item to delete
' returns $$TRUE on success or $$FALSE
FUNCTION WinXTreeView_DeleteItem (hTV, hItem)

	IFZ hTV THEN RETURN

	ret = SendMessageA (hTV, $$TVM_DELETEITEM, 0, hItem)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' #####################################
' #####  WinXTreeView_ExpandItem  #####
' #####################################
' Expands an item of a tree view control
' hTV = the handle to the tree view
' hItem = the handle to the item to expand, 0 for the root node
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTreeView_ExpandItem (hTV, hItem)
	IFZ hTV THEN RETURN

	IFZ hItem THEN hItem = WinXTreeView_GetRootItem (hTV)
	ret = SendMessageA (hTV, $$TVM_EXPAND, $$TVE_EXPAND, hItem)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ###################################
' #####  WinXTreeView_FindItem  #####
' ###################################
' Recursively search for a label in tree view nodes
' hTV = the handle to the tree view
' hItem = the handle to the item to search from
' returns the node handle, 0 if error
FUNCTION WinXTreeView_FindItem (hTV, hItem, find$)

	TV_ITEM tvi

	IFZ hTV THEN RETURN

	find$ = TRIM$ (find$)
	IFZ find$ THEN RETURN

	hItemFound = 0
	IFZ hItem THEN
		hItem = SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_ROOT, 0)
	ENDIF

	DO UNTIL hItem = 0
		'
		lenBuf = 128
		szBuf$ = NULL$ (lenBuf)
		tvi.hItem = hItem
		tvi.mask = $$TVIF_TEXT | $$TVIF_CHILDREN
		tvi.pszText = &szBuf$
		tvi.cchTextMax = lenBuf
		ret = SendMessageA (hTV, $$TVM_GETITEM, 0, &tvi)

		szBuf$ = CSTRING$ (&szBuf$)
		szBuf$ = TRIM$ (szBuf$)
		IF szBuf$ = find$ THEN RETURN hItem

		' Check whether we have child items.
		IF (tvi.cChildren) THEN
			' SendMessageA (hTV, $$TVM_EXPAND, $$TVE_EXPAND, hItem)
			' .................. Recursively traverse child items ...................
			hItemChild = SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_CHILD, hItem)
			hItemFound = WinXTreeView_FindItem (hTV, hItem, find$)
			' Did we find it?
			IF hItemFound THEN EXIT DO		' found it
		ENDIF
		' Go to next sibling item.
		hItem = SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_NEXT, hItem)
	LOOP

	RETURN hItemFound

END FUNCTION
'
' ########################################
' #####  WinXTreeView_FindItemLabel  #####
' ########################################
' find an exact string in tree labels
' hTV = the handle to the tree view
' returns the node handle, 0 if error
FUNCTION WinXTreeView_FindItemLabel (hTV, find$)

	IFZ hTV THEN RETURN

	find$ = TRIM$ (find$)
	IFZ find$ THEN RETURN

	hItemFound = WinXTreeView_FindItem (hTV, 0, find$)
	RETURN hItemFound

END FUNCTION
'
' #########################################
' #####  WinXTreeView_FreezeOnSelect  #####
' #########################################
'
FUNCTION WinXTreeView_FreezeOnSelect (hTV)

	id = LOCK_Get_id_hCtr (hTV)
	statusOld = LOCK_Get_skipOnSelect (id)
	IF statusOld THEN RETURN $$TRUE
	RETURN LOCK_Set_skipOnSelect (id, $$TRUE) ' freeze .onSelect

END FUNCTION
'
' ########################################
' #####  WinXTreeView_GetCheckState  #####
' ########################################
' Determines if a node in a tree view control is checked
' hTV = the handle to the tree view
' hItem = the handle of the node to get the check state for
' returns $$TRUE if the node is checked, $$FALSE otherwise
FUNCTION WinXTreeView_GetCheckState (hTV, hItem)

	TVITEM tvi		' tree view item

	IFZ hTV THEN RETURN

	tvi.hItem = hItem		' the selected item
	tvi.mask = $$TVIF_STATE		' item state attribute
	tvi.stateMask = $$TVIS_STATEIMAGEMASK
	' Guy-03mar09-SendMessageA (hTV, $$TVM_SETITEM, 0, &tvi)
	ret = SendMessageA (hTV, $$TVM_GETITEM, 0, &tvi)
	IFZ ret THEN RETURN
	IF (tvi.state & 0x2000) = 0x2000 THEN RETURN $$TRUE ELSE RETURN $$FALSE		' *not* checked
END FUNCTION
'
' #######################################
' #####  WinXTreeView_GetChildItem  #####
' #######################################
' Gets the first child of a node in a tree view
' hTV = the handle to the tree view
' hItem = the item to get the first child from
' returns the handle to the child item or 0 on error
FUNCTION WinXTreeView_GetChildItem (hTV, hItem)
	IFZ hTV THEN RETURN

	RETURN SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_CHILD, hItem)
END FUNCTION
'
' ###########################################
' #####  WinXTreeView_GetItemFromPoint  #####
' ###########################################
' Gets a tree view item given its coordinates
' hTV = the control to get the item from
' x, y = the x and y coordinates to find the item at
' returns the item handle or 0 on fail
FUNCTION WinXTreeView_GetItemFromPoint (hTV, x, y)
	TV_HITTESTINFO tvHit

	IFZ hTV THEN RETURN

	tvHit.pt.x = x
	tvHit.pt.y = y

	' Find out which item (if any) the cursor is over.
	RETURN SendMessageA (hTV, $$TVM_HITTEST, 0, &tvHit)
END FUNCTION
'
' ########################################
' #####  WinXTreeView_GetItemLabel$  #####
' ########################################
' Gets the label from an item
' hTV = the handle to the tree view
' hItem = the item to get the label from
' returns the item label or "" on fail
FUNCTION WinXTreeView_GetItemLabel$ (hTV, hItem)
	TVITEM tvi

	IFZ hTV THEN RETURN ""		' fail
	IFZ hItem THEN RETURN ""		' fail

	tvi.mask = $$TVIF_HANDLE | $$TVIF_TEXT
	tvi.hItem = hItem

	buffer$ = NULL$ (256)
	tvi.pszText = &buffer$
	tvi.cchTextMax = 255
	ret = SendMessageA (hTV, $$TVM_GETITEM, 0, &tvi)
	IFZ ret THEN RETURN ""		' fail

	text$ = CSTRING$ (&buffer$)
	RETURN text$
END FUNCTION
'
' ######################################
' #####  WinXTreeView_GetNextItem  #####
' ######################################
' Gets the next item in the tree view
' hTV = the handle to the tree view
' hItem = the handle to the item to start from
' returns the handle of the next item or 0 on error
FUNCTION WinXTreeView_GetNextItem (hTV, hItem)
	IFZ hTV THEN RETURN
	RETURN SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_NEXT, hItem)
END FUNCTION
'
' ########################################
' #####  WinXTreeView_GetParentItem  #####
' ########################################
' Gets the parent of a node in a tree view
' hTV = the handle ot the tree view
' hItem = the item to get the parent of
' returns the handle to the parent, or $$TVI_ROOT if hItem has no parent.
FUNCTION WinXTreeView_GetParentItem (hTV, hItem)
	IFZ hTV THEN RETURN
	RETURN SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_PARENT, hItem)
END FUNCTION
'
' ##########################################
' #####  WinXTreeView_GetPreviousItem  #####
' ##########################################
' Gets the item that comes before a tree view item
' hTV = the handle to the tree view
' returns the handle to the previous item or 0 on error
FUNCTION WinXTreeView_GetPreviousItem (hTV, hItem)
	IFZ hTV THEN RETURN
	RETURN SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_PREVIOUS, hItem)
END FUNCTION
'
' ######################################
' #####  WinXTreeView_GetRootItem  #####
' ######################################
' Gets the root node of a tree view control
' hTV = the handle to the tree view
' hItem = the handle to the item to expand, 0 for the root node
' returns root's handle on success or 0 on fail
FUNCTION WinXTreeView_GetRootItem (hTV)
	IFZ hTV THEN RETURN
	RETURN SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_ROOT, 0)
END FUNCTION
'
' #######################################
' #####  WinXTreeView_GetSelection  #####
' #######################################
' Gets the current selection from a tree view control
' hTV = the tree view control
' returns the handle of the selected item, 0 on fail
FUNCTION WinXTreeView_GetSelection (hTV)
	IFZ hTV THEN RETURN
	RETURN SendMessageA (hTV, $$TVM_GETNEXTITEM, $$TVGN_CARET, 0)
END FUNCTION
'
' #########################################
' #####  WinXTreeView_RemoveCheckBox  #####
' #########################################
' Removes the check box of a tree view item
' hTV = the handle to the tree view
' hItem = the handle of the node to remove the check box
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTreeView_RemoveCheckBox (hTV, hItem)

	TVITEM tvi		' tree view item

	IFZ hTV THEN RETURN

	tvi.state = 0		' removes the check box
	tvi.hItem = hItem
	tvi.mask = $$TVIF_STATE
	tvi.stateMask = $$TVIS_STATEIMAGEMASK

	SendMessageA (hTV, $$TVM_SETITEM, 0, &tvi)
	RETURN $$TRUE		' success
END FUNCTION
'
' ########################################
' #####  WinXTreeView_SetCheckState  #####
' ########################################
' Sets the item's check state of a tree view with check boxes
' hTV = the handle to the tree view
' hItem = the handle of the node to set the check state
' checked = $$TRUE to check the node, $$FALSE to uncheck it
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTreeView_SetCheckState (hTV, hItem, checked)

	TVITEM tvi		' tree view item

	IFZ hTV THEN RETURN

	IF checked THEN tvi.state = 0x2000 ELSE tvi.state = 0x1000		' unchecked
	tvi.hItem = hItem
	tvi.mask = $$TVIF_STATE
	tvi.stateMask = $$TVIS_STATEIMAGEMASK

	SendMessageA (hTV, $$TVM_SETITEM, 0, &tvi)
	RETURN $$TRUE		' success
END FUNCTION
'
' #######################################
' #####  WinXTreeView_SetItemLabel  #####
' #######################################
' Sets the lable for a tree view item
' hTV = the handle to the tree view control
' hItem = the item to set the label for
' newLabel = the new label
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTreeView_SetItemLabel (hTV, hItem, STRING newLabel)
	TVITEM tvi

	tvi.mask = $$TVIF_HANDLE | $$TVIF_TEXT
	tvi.hItem = hItem
	tvi.pszText = &newLabel
	tvi.cchTextMax = LEN (newLabel)

	RETURN SendMessageA (hTV, $$TVM_SETITEM, 0, &tvi)
END FUNCTION
'
' #######################################
' #####  WinXTreeView_SetSelection  #####
' #######################################
' Sets the selection for a tree view control
' hTV = the handle to the tree view
' hItem = the handle to the item to set the selection to, 0 to remove selection
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXTreeView_SetSelection (hTV, hItem)
	' Guy-26jan09-RETURN SendMessageA (hTV, $$TVM_SELECTITEM, $$TVGN_CARET, hItem)

	IFZ hTV THEN RETURN
	IFZ hItem THEN hItem = WinXTreeView_GetRootItem (hTV)
	IFZ hItem THEN RETURN

	ret = SendMessageA (hTV, $$TVM_SELECTITEM, $$TVGN_CARET, hItem)
	IFZ ret THEN RETURN
	RETURN $$TRUE		' success
END FUNCTION
'
' ######################################
' #####  WinXTreeView_UseOnSelect  #####
' ######################################
'
FUNCTION WinXTreeView_UseOnSelect (hTV)

	id = LOCK_Get_id_hCtr (hTV)
	statusOld = LOCK_Get_skipOnSelect (id)
	IF statusOld THEN RETURN $$TRUE
	RETURN LOCK_Set_skipOnSelect (id, $$FALSE) ' use .onSelect

END FUNCTION
'
' ######################
' #####  WinXUndo  #####
' ######################
' Undoes a drawing operation
' idCtr = the idCtr of the operation
' returns $$TRUE on success or $$FALSE on fail
FUNCTION WinXUndo (hWnd, idCtr)
	AUTODRAWRECORD record
	BINDING binding
	LINKEDLIST autoDraw

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	' LINKEDLIST_Get (binding.autoDrawInfo, @autoDraw)
	' LinkedList_GetItem (autoDraw, idCtr, @iData)
	AUTODRAWRECORD_Get (idCtr, @record)
	record.toDelete = $$TRUE
	IFZ binding.hUpdateRegion THEN
		binding.hUpdateRegion = record.hUpdateRegion
	ELSE
		CombineRgn (binding.hUpdateRegion, binding.hUpdateRegion, record.hUpdateRegion, $$RGN_OR)
		DeleteObject (record.hUpdateRegion)
	ENDIF
	IF record.draw = &drawText () THEN STRING_Delete (record.text.iString)
	AUTODRAWRECORD_Update (idCtr, record)
	' LinkedList_DeleteItem (@autoDraw, idCtr)
	' LINKEDLIST_Update (binding.autoDrawInfo, @autoDraw)

	BINDING_Update (idBinding, binding)

	RETURN $$TRUE		' success
END FUNCTION
'
' ########################
' #####  WinXUpdate  #####
' ########################
' Updates the specified window
' hWnd = the handle to the window
' Guy-09sep10-FUNCTION VOID WinXUpdate (hWnd)
FUNCTION WinXUpdate (hWnd)
	BINDING binding
	RECT rect
	' WinXGetUseableRect (hWnd, @rect)
	' InvalidateRect (hWnd, &rect, 1) ' erase

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	' PRINT binding.hUpdateRegion
	InvalidateRgn (hWnd, binding.hUpdateRegion, 1) ' erase
	DeleteObject (binding.hUpdateRegion)
	binding.hUpdateRegion = 0
	BINDING_Update (idBinding, binding)

END FUNCTION

' Retrieves the UserName with which the User is logged into the network
FUNCTION WinXUser_GetName$ ()

	lenBuf = 255
	szBuf$ = NULL$ (lenBuf)
	ret = GetUserNameA (&szBuf$, &lenBuf)
	IFZ ret THEN RETURN "?"

	user$ = CSIZE$ (szBuf$)
	RETURN user$

END FUNCTION
'
'
' #############################
' #####  WinXVersion$ ()  #####
' #############################
'
FUNCTION WinXVersion$ ()		' get WinX's current version
	version$ = VERSION$ (0)
	RETURN (version$)
END FUNCTION
'
' #####################################
' #####  AUTOSIZER_LinkedList_Delete  #####
' #####################################
' Deletes a group of auto sizer info blocks
' group = the group to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION AUTOSIZER_LinkedList_Delete (group)
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]		'info for the autosizer
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]
	SHARED AUTOSIZERINFO_idMax

	AUTOSIZERINFO autoSizerInfoLocal[]

	upper_slot = UBOUND (AUTOSIZER_LinkedList[])

	slot = group

	IF (slot < 0) || (slot > upper_slot) THEN RETURN
	IFF AUTOSIZER_LinkedList[slot].inUse THEN RETURN

	AUTOSIZER_LinkedList[group].inUse = $$FALSE
	SWAP AUTOSIZERINFO_array[group,], autoSizerInfoLocal[]

	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  AUTOSIZER_LinkedList_Get  #####
' ##################################
' Get an autosizer info block
' idCtr = the idCtr of the block to get
' item = the variable to store the block
' returns $$TRUE on success or $$FALSE on fail
FUNCTION AUTOSIZER_LinkedList_Get (id, idCtr, AUTOSIZERINFO item)
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]		'info for the autosizer
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]

	IF id < 0 || id > UBOUND (AUTOSIZER_LinkedList[]) THEN RETURN
	IFF AUTOSIZER_LinkedList[id].inUse THEN RETURN
	IF idCtr < 0 || idCtr > UBOUND (AUTOSIZERINFO_array[id,]) THEN RETURN
	IFZ AUTOSIZERINFO_array[id, idCtr].hwnd THEN RETURN

	item = AUTOSIZERINFO_array[id, idCtr]
	RETURN $$TRUE		' success
END FUNCTION
'
' ###################################
' #####  AUTOSIZER_LinkedList_Init  #####
' ###################################
'
FUNCTION AUTOSIZER_LinkedList_Init ()
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]
	SHARED autoSizerInfo_idMax

	DIM AUTOSIZERINFO_array[0, 0]
	DIM AUTOSIZER_LinkedList[0]
	autoSizerInfo_idMax = 0
END FUNCTION
'
' ##################################
' #####  AUTOSIZER_LinkedList_New  #####
' ##################################
' Adds a new group of auto sizer info blocks
' returns the if of the new group or -1 on fail
FUNCTION AUTOSIZER_LinkedList_New (direction)
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]		'info for the autosizer
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]
	SHARED AUTOSIZERINFO_idMax

	AUTOSIZERINFO autoSizerInfoLocal[]

	slot = -1
	upper_slot = UBOUND (AUTOSIZER_LinkedList[])
	FOR i = AUTOSIZERINFO_idMax TO upper_slot
		IFF AUTOSIZER_LinkedList[i].inUse THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	IF slot = -1 THEN
		upper_slot = ((upper_slot + 1) << 1) - 1
		REDIM AUTOSIZER_LinkedList[upper_slot]
		REDIM AUTOSIZERINFO_array[upper_slot,]
		slot = AUTOSIZERINFO_idMax
		INC AUTOSIZERINFO_idMax
	ELSE
		AUTOSIZERINFO_idMax = slot + 1
	ENDIF

	AUTOSIZER_LinkedList[slot].inUse = $$TRUE
	AUTOSIZER_LinkedList[slot].direction = direction
	AUTOSIZER_LinkedList[slot].iHead = -1
	AUTOSIZER_LinkedList[slot].iTail = -1

	DIM autoSizerInfoLocal[0]
	SWAP autoSizerInfoLocal[], AUTOSIZERINFO_array[slot,]

	RETURN slot
END FUNCTION
'
' #####################################
' #####  AUTOSIZER_LinkedList_Update  #####
' #####################################
' Update an autosizer info block
' idCtr = the block to update
' item = the new version of the info block
' returns $$TRUE on success or $$FALSE on fail
FUNCTION AUTOSIZER_LinkedList_Update (group, idCtr, AUTOSIZERINFO item)
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]		'info for the autosizer
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]

	IF group < 0 || group > UBOUND (AUTOSIZER_LinkedList[]) THEN RETURN
	IFF AUTOSIZER_LinkedList[group].inUse THEN RETURN
	IF idCtr < 0 || idCtr > UBOUND (AUTOSIZERINFO_array[group,]) THEN RETURN
	IFZ AUTOSIZERINFO_array[group, idCtr].hwnd THEN RETURN

	AUTOSIZERINFO_array[group, idCtr] = item
	RETURN $$TRUE		' success
END FUNCTION

' A wrapper for the misdefined AlphaBlend function
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
	args[10] = XLONGAT (&blendFunction)

	RETURN XstCall ("AlphaBlend", "msimg32.dll", @args[])
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
' ###############################
' #####  BINDING_Ov_Delete  #####
' ###############################
'
' Deletes a binding from the binding table
' id = the id of the binding to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION BINDING_Ov_Delete (id)
	BINDING item
	LINKEDLIST list

	bOK = BINDING_Get (id, @item)
	IFF bOK THEN RETURN

	IFZ item.hwnd THEN RETURN

	' delete the auto draw info
	autoDraw_clear (item.autoDrawInfo)
	LINKEDLIST_Get (item.autoDrawInfo, @list)
	LinkedList_Uninit (@list)
	LINKEDLIST_Delete (item.autoDrawInfo)

	' delete the message handlers
	HANDLER_Delete (item.msgHandlers)

	' delete the auto sizer info
	AUTOSIZER_LinkedList_Delete (item.autoSizerInfo)

	bOK = BINDING_Delete (id)
	RETURN bOK
END FUNCTION
'
' ############################
' #####  CompareLVItems  #####
' ############################
' Compares two list view items
FUNCTION CompareLVItems (item1, item2, hLV)
	SHARED lvs_iCol
	SHARED lvs_desc

	LV_ITEM lvi

	buffer$ = NULL$ (1024)
	lvi.mask = $$LVIF_TEXT
	lvi.pszText = &buffer$
	lvi.cchTextMax = 1023
	lvi.iItem = item1
	lvi.iSubItem = lvs_iCol AND 0x7FFFFFFF
	SendMessageA (hLV, $$LVM_GETITEM, iItem1, &lvi)
	a$ = CSTRING$ (&buffer$)
	buffer$ = NULL$ (1024)
	lvi.pszText = &buffer$
	lvi.cchTextMax = 1023
	lvi.iItem = item2
	SendMessageA (hLV, $$LVM_GETITEM, iItem2, &lvi)
	b$ = CSTRING$ (&buffer$)

	ret = 0
	FOR i = 0 TO MIN (UBOUND (a$), UBOUND (b$))
		IF a${i} < b${i} THEN
			ret = -1
			EXIT FOR
		ENDIF
		IF a${i} > b${i} THEN
			ret = 1
			EXIT FOR
		ENDIF
	NEXT i

	IF ret = 0 THEN
		IF UBOUND (a$) < UBOUND (b$) THEN ret = -1
		IF UBOUND (a$) > UBOUND (b$) THEN ret = 1
	ENDIF

	IF lvs_desc THEN RETURN (-ret) ELSE RETURN ret
END FUNCTION

FUNCTION CreateMdiChild (hClient, STRING title)
	MDICREATESTRUCT mdi

	IFZ hClient THEN RETURN

	hInst = GetWindowLongA (hClient, $$GWL_HINSTANCE)
	IFZ hInst THEN hInst = GetModuleHandleA (0)

	IFZ title THEN pTitle = 0 ELSE pTitle = &title
	hWindow = CreateWindowExA ($$WS_EX_MDICHILD, &#WinXclass$, pTitle, $$WS_MAXIMIZE, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, $$CW_USEDEFAULT, hClient, 0, hInst, 0)
	RETURN hWindow

END FUNCTION
'
' ##############################
' #####  LOCK_Get_id_hCtr  #####
' ##############################
'
FUNCTION LOCK_Get_id_hCtr (hCtr)

	IFZ hCtr THEN RETURN

	hWnd = GetParent (hCtr)

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	RETURN idBinding

END FUNCTION
'
' ###################################
' #####  LOCK_Get_skipOnSelect  #####
' ###################################
'
FUNCTION LOCK_Get_skipOnSelect (id)
	BINDING binding

	bSkip = $$FALSE

	bOK = BINDING_Get (id, @binding)
	IFF bOK THEN RETURN bSkip
	IFZ binding.onSelect THEN RETURN bSkip

	IF binding.skipOnSelect THEN bSkip = $$TRUE
	RETURN bSkip

END FUNCTION
'
' ###################################
' #####  LOCK_Set_skipOnSelect  #####
' ###################################
'
FUNCTION LOCK_Set_skipOnSelect (id, bSkip)
	BINDING binding

	bOK = BINDING_Get (id, @binding)
	IFF bOK THEN RETURN

	IF bSkip THEN bSkip = $$TRUE ' true value of TRUE
	IF binding.skipOnSelect = bSkip THEN RETURN $$TRUE

	' update the binding
	binding.skipOnSelect = bSkip
	bOK = BINDING_Update (id, binding)
	RETURN bOK

END FUNCTION

FUNCTION TellDialogError (parent, title$)		' display WinXDialog_'s run-time error message

	' call CommDlgExtendedError to get error code
	extErr = CommDlgExtendedError ()
	SELECT CASE extErr
		CASE 0
			' err$ = "Cancel pressed, no error"
			RETURN		' success
			'
		CASE $$CDERR_DIALOGFAILURE   : err$ = "Dialog box could not be created"
		CASE $$CDERR_FINDRESFAILURE  : err$ = "Failed to find a resource"
		CASE $$CDERR_NOHINSTANCE     : err$ = "Instance handle missing"
		CASE $$CDERR_INITIALIZATION  : err$ = "Failure during initialization. Possibly out of memory"
		CASE $$CDERR_NOHOOK          : err$ = "Hook procedure missing"
		CASE $$CDERR_LOCKRESFAILURE  : err$ = "Failed to lock a resource"
		CASE $$CDERR_NOTEMPLATE      : err$ = "Template missing"
		CASE $$CDERR_LOADRESFAILURE  : err$ = "Failed to load a resource"
		CASE $$CDERR_STRUCTSIZE      : err$ = "Internal error - invalid struct size"
		CASE $$CDERR_LOADSTRFAILURE  : err$ = "Failed to load a string"
		CASE $$CDERR_MEMALLOCFAILURE : err$ = "Unable to allocate memory for internal dialog structures"
		CASE $$CDERR_MEMLOCKFAILURE  : err$ = "Unable to lock memory"
		CASE ELSE                    : err$ = "Unknown error " + STRING$ (extErr)
	END SELECT
	MessageBoxA (parent, &err$, &title$, $$MB_ICONSTOP)

	RETURN $$TRUE		' fail

END FUNCTION
'
' #########################
' #####  mainWndProc  #####
' #########################
'
' The main window procedure
' parameters and return are as usual
FUNCTION mainWndProc (hWnd, wMsg, wParam, lParam)
	SHARED tvDragButton
	SHARED tvDragging
	SHARED hIml
	SHARED DLM_MESSAGE
	SHARED hClipMem ' to copy to the clipboard

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
	TV_HITTESTINFO tvHit
	POINT pt
	POINT mouseXY
	TRACKMOUSEEVENT tme

	IFZ hWnd THEN RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam) ' Guy-15apr09-should never occur!

	'get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	bOK = BINDING_Get (idBinding, @binding)
	IFF bOK THEN RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam) ' WinX does not know this window

	handled = $$FALSE 'set to true if we handle the message
	retCode = 0 'the return value

	'call any associated message handler
	IF binding.msgHandlers THEN
		handled = HANDLER_CallItem (binding.msgHandlers, @retCode, hWnd, wMsg, wParam, lParam)
		IFF handled THEN ret_value = 0 ' NOT handled
		IF ret_value THEN handled = $$TRUE ' handled
	ENDIF

	'and handle the message
	SELECT CASE wMsg
		CASE $$WM_COMMAND
			RETURN @binding.onCommand (LOWORD (wParam), HIWORD (wParam), lParam)

		CASE $$WM_NOTIFY
			RETURN onNotify (hWnd, wParam, lParam, binding)

		CASE $$WM_DRAWCLIPBOARD
			IF binding.hwndNextClipViewer THEN SendMessageA (binding.hwndNextClipViewer, $$WM_DRAWCLIPBOARD, wParam, lParam)
			RETURN @binding.onClipChange ()

		CASE $$WM_CHANGECBCHAIN
			IF wParam = binding.hwndNextClipViewer THEN
				binding.hwndNextClipViewer = lParam
			ELSE
				IF binding.hwndNextClipViewer THEN SendMessageA (binding.hwndNextClipViewer, $$WM_CHANGECBCHAIN, wParam, lParam)
			ENDIF
			RETURN

		CASE $$WM_DESTROYCLIPBOARD
			IF hClipMem THEN
				GlobalFree (hClipMem)
				hClipMem = 0 ' Guy-18dec08-prevents from freeing twice
				handled = $$TRUE
			ENDIF

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
			ENDIF

			DragFinish (wParam)
			RETURN

		CASE $$WM_ERASEBKGND
			IF binding.backCol THEN
				GetClientRect (hWnd, &rect)
				FillRect (wParam, &rect, binding.backCol)
				RETURN
			ENDIF

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
'				ENDIF

			autoDraw_draw(hDC, binding.autoDrawInfo, xOff, yOff)
			retCode = @binding.onPaint(hWnd, hDC)
			EndPaint (hWnd, &ps)
			RETURN retCode

		CASE $$WM_SIZE
			sizeWindow (hWnd, LOWORD (lParam), HIWORD (lParam))
			handled = $$TRUE

		CASE $$WM_HSCROLL,$$WM_VSCROLL
			buffer$ = NULL$(LEN($$TRACKBAR_CLASS)+1)
			GetClassNameA (lParam, &buffer$, LEN(buffer$))
			buffer$ = TRIM$(CSTRING$(&buffer$))
			IF buffer$ = $$TRACKBAR_CLASS THEN RETURN @binding.onTrackerPos (GetDlgCtrlID (lParam), SendMessageA (lParam, $$TBM_GETPOS, 0, 0))

			sbval = LOWORD(wParam)
			IF wMsg = $$WM_HSCROLL THEN
				sb = $$SB_HORZ
				dir = $$DIR_HORIZ
				scrollUnit = binding.hScrollUnit
			ELSE
				sb = $$SB_VERT
				dir = $$DIR_VERT
				scrollUnit = binding.vScrollUnit
			ENDIF

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
			ENDIF

			SetScrollInfo (hWnd, sb, &si, $$TRUE)
			RETURN @binding.onScroll(si.nPos, hWnd, dir)

		' This allows for mouse activation of child windows, for some reason WM_ACTIVATE doesn't work
		' unfortunately it interferes with label editing - hence the strange hWnd != wParam condition
		'CASE $$WM_MOUSEACTIVATE
			'IF hWnd != wParam THEN
			'	SetFocus (hWnd)
			'	RETURN $$MA_NOACTIVATE
			'ENDIF
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
			ENDIF

		CASE $$WM_MOUSEMOVE
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)

			IFF binding.isMouseInWindow THEN
				tme.cbSize = SIZE(tme)
				tme.dwFlags = $$TME_LEAVE
				tme.hwndTrack = hWnd
				TrackMouseEvent (&tme)
				binding.isMouseInWindow = $$TRUE
				BINDING_Update (idBinding, binding)

				@binding.onEnterLeave (hWnd, $$TRUE)
			ENDIF

			IF (tvDragButton = $$MBT_LEFT) || (tvDragButton = $$MBT_RIGHT) THEN
				GOSUB dragTreeViewItem
				IFZ retCode THEN SetCursor (LoadCursorA (0, $$IDC_NO)) ELSE SetCursor (LoadCursorA (0, $$IDC_ARROW))
				RETURN
			ELSE
				RETURN @binding.onMouseMove(hWnd, LOWORD(lParam), HIWORD(lParam))
			ENDIF

		CASE $$WM_MOUSELEAVE
				binding.isMouseInWindow = $$FALSE
				BINDING_Update (idBinding, binding)

				@binding.onEnterLeave (hWnd, $$FALSE)
			RETURN

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
				@binding.onDrag(GetDlgCtrlID (tvDragging), $$DRAG_DONE, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
				GOSUB endDragTreeViewItem
				RETURN
			ELSE
				RETURN @binding.onMouseUp(hWnd, $$MBT_LEFT,LOWORD(lParam), HIWORD(lParam))
			ENDIF

		CASE $$WM_MBUTTONUP
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			RETURN @binding.onMouseUp(hWnd, $$MBT_MIDDLE, LOWORD(lParam), HIWORD(lParam))

		CASE $$WM_RBUTTONUP
			mouseXY.x = LOWORD(lParam)
			mouseXY.y = HIWORD(lParam)
			IF tvDragButton = $$MBT_LEFT THEN
				GOSUB dragTreeViewItem
				@binding.onDrag(GetDlgCtrlID (tvDragging), $$DRAG_DONE, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
				GOSUB endDragTreeViewItem
				RETURN
			ELSE
				RETURN @binding.onMouseUp(hWnd, $$MBT_RIGHT, LOWORD(lParam), HIWORD(lParam))
			ENDIF

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
'				ENDIF
'			ENDIF

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
								ENDIF
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

					CASE $$DL_DROPPED
						InvalidateRect (dli.hWnd, 0, $$TRUE)
						item = ApiLBItemFromPt (dli.hWnd, dli.ptCursor.x, dli.ptCursor.y, $$TRUE)
						IFF @binding.onDrag(wParam, $$DRAG_DRAGGING, item, dli.ptCursor.x, dli.ptCursor.y) THEN item = -1
						@binding.onDrag(wParam, $$DRAG_DONE, item, dli.ptCursor.x, dli.ptCursor.y)
						WinXListBox_RemoveItem (dli.hWnd, -1)

				END SELECT
			ENDIF
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
					autoSizerBlock_Delete (binding.autoSizerInfo, GetPropA (lParam, &"autoSizerInfoBlock")-1)
			END SELECT
			handled = $$TRUE

		CASE $$WM_TIMER
			SELECT CASE wParam
				CASE -1
					IF lastDragItem = dragItem THEN
						ImageList_DragShowNolock ($$FALSE)
						SendMessageA (tvDragging, $$TVM_EXPAND, $$TVE_EXPAND, dragItem)
						ImageList_DragShowNolock ($$TRUE)
					ENDIF
					KillTimer (hWnd, -1)
			END SELECT
			RETURN

		CASE $$WM_CLOSE
			IFZ binding.onClose THEN
				DestroyWindow (hWnd)
				PostQuitMessage(0)
			ELSE
				RETURN @binding.onClose (hWnd)
			ENDIF

		CASE $$WM_DESTROY
			ChangeClipboardChain (hWnd, binding.hwndNextClipViewer)
			'clear the binding
			BINDING_Ov_Delete (idBinding)
			handled = $$TRUE

	END SELECT

	IF retCode THEN RETURN retCode
	IF handled THEN RETURN

	hWndClient = binding.hwndMDIParent
	IFZ hWndClient THEN
		RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam)
	ELSE
		' Send the message to the MDI frame window procedure
		RETURN DefFrameProcA (hWnd, hWndClient, wMsg, wParam, lParam)
	ENDIF

	SUB dragTreeViewItem
		IFZ tvDragging THEN EXIT SUB

		tvHit.pt.x = LOWORD(lParam)
		tvHit.pt.y = HIWORD(lParam)
		ClientToScreen (hWnd, &tvHit.pt)
		pt = tvHit.pt

		GetWindowRect (tvDragging, &rect)
		tvHit.pt.x = tvHit.pt.x - rect.left
		tvHit.pt.y = tvHit.pt.y - rect.top

		hItem = SendMessageA (tvDragging, $$TVM_HITTEST, 0, &tvHit)
		IFZ hItem THEN EXIT SUB

		IF tvHit.hItem != dragItem THEN
			ImageList_DragShowNolock ($$FALSE)
			SendMessageA (tvDragging, $$TVM_SELECTITEM, $$TVGN_DROPHILITE, tvHit.hItem)
			ImageList_DragShowNolock ($$TRUE)
			dragItem = tvHit.hItem
		ENDIF

		IF WinXTreeView_GetChildItem (tvDragging, tvHit.hItem) != 0 THEN
			SetTimer (hWnd, -1, 400, 0)
			lastDragItem = dragItem
		ENDIF

		retCode = @binding.onDrag(GetDlgCtrlID (tvDragging), $$DRAG_DRAGGING, tvHit.hItem, tvHit.pt.x, tvHit.pt.y)
		ImageList_DragMove (pt.x, pt.y)
	END SUB
	SUB endDragTreeViewItem
		tvDragButton = 0
		ImageList_EndDrag ()
		ImageList_Destroy (hIml)
		ReleaseCapture ()
		SendMessageA (tvDragging, $$TVM_SELECTITEM, $$TVGN_DROPHILITE, 0)
	END SUB
END FUNCTION ' mainWndProc
'
' ######################
' #####  onNotify  #####
' ######################
' Handles notify messages
FUNCTION onNotify (hWnd, wParam, lParam, BINDING binding)
	SHARED tvDragButton
	SHARED tvDragging
	SHARED hIml

	NMHDR nmhdr
	TV_DISPINFO nmtvdi
	NM_TREEVIEW nmtv
	LV_DISPINFO nmlvdi
	NMKEY nmkey
	NM_LISTVIEW nmlv
	NMSELCHANGE nmsc
	RECT rect

	IFZ lParam THEN RETURN

	retCode = 0

	nmhdrAddr = &nmhdr
'	XLONGAT(&&nmhdr) = lParam
	RtlMoveMemory (&nmhdr, lParam, SIZE (nmhdr))

	SELECT CASE nmhdr.code
		CASE $$NM_CLICK, $$NM_DBLCLK, $$NM_RCLICK, $$NM_RDBLCLK, $$NM_RETURN, $$NM_HOVER
			IF binding.onItem THEN retCode = @binding.onItem (nmhdr.idFrom, nmhdr.code, 0)

		CASE $$NM_KEYDOWN
			IF binding.onItem THEN
				pNmkey = &nmkey
				XLONGAT(&&nmkey) = lParam
				retCode = @binding.onItem (nmhdr.idFrom, nmhdr.code, nmkey.nVKey)
				XLONGAT(&&nmkey) = pNmkey
			ENDIF

		CASE $$MCN_SELECT
			IF binding.onCalendarSelect THEN
				pNmsc = &nmsc
				XLONGAT(&&nmsc) = lParam
				retCode = @binding.onCalendarSelect (nmhdr.idFrom, nmsc.stSelStart)
				XLONGAT(&&nmsc) = pNmsc
			ENDIF

		CASE $$TVN_BEGINLABELEDIT
			IF binding.onLabelEdit THEN
				pNmtvdi = &nmtvdi
				XLONGAT(&&nmtvdi) = lParam
				retCode = @binding.onLabelEdit(nmtvdi.hdr.idFrom, $$EDIT_START, nmtvdi.item.hItem, "")
				IFF retCode THEN retCode = $$TRUE ELSE retCode = $$FALSE
				XLONGAT(&&nmtvdi) = pNmtvdi
			ENDIF

		CASE $$TVN_ENDLABELEDIT
			IF binding.onLabelEdit THEN
				pNmtvdi = &nmtvdi
				XLONGAT(&&nmtvdi) = lParam
				retCode = @binding.onLabelEdit(nmtvdi.hdr.idFrom, $$EDIT_DONE, nmtvdi.item.hItem, CSTRING$(nmtvdi.item.pszText))
				XLONGAT(&&nmtvdi) = pNmtvdi
			ENDIF

		CASE $$TVN_BEGINDRAG,$$TVN_BEGINRDRAG
			pNmtv = &nmtv
			XLONGAT(&&nmtv) = lParam
			IF @binding.onDrag(nmtv.hdr.idFrom, $$DRAG_START, nmtv.itemNew.hItem, nmtv.ptDrag.x, nmtv.ptDrag.y) THEN
				tvDragging = nmtv.hdr.hwndFrom

				SELECT CASE nmhdr.code
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
			ENDIF
			XLONGAT(&&nmtv) = pNmtv

		CASE $$TCN_SELCHANGE
			currTab = WinXTabs_GetCurrentTab (nmhdr.hwndFrom)
			maxTab = SendMessageA (nmhdr.hwndFrom, $$TCM_GETITEMCOUNT, 0, 0)-1
			FOR i = 0 TO maxTab
				IF i != currTab THEN
					autoSizerInfo_showGroup (WinXTabs_GetAutosizerSeries (nmhdr.hwndFrom, i), $$FALSE)
				ELSE
					autoSizerInfo_showGroup (WinXTabs_GetAutosizerSeries (nmhdr.hwndFrom, i), $$TRUE)
					GetClientRect (GetParent(nmhdr.hwndFrom), &rect)
					sizeWindow (GetParent(nmhdr.hwndFrom), rect.right-rect.left, rect.bottom-rect.top)
				ENDIF
			NEXT i

		CASE $$LVN_COLUMNCLICK
			IF binding.onColumnClick THEN
				pNmlv = &nmlv
				XLONGAT(&&nmlv) = lParam
				retCode = @binding.onColumnClick (nmhdr.idFrom, nmlv.iSubItem)
				XLONGAT(&&nmlv) = pNmlv
			ENDIF

		CASE $$LVN_BEGINLABELEDIT
			IF binding.onLabelEdit THEN
				pNmlvdi = &nmlvdi
				XLONGAT(&&nmlvdi) = lParam
				retCode = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_START, nmlvdi.item.iItem, "")
				IFF retCode THEN retCode = $$TRUE ELSE retCode = $$FALSE
				XLONGAT(&&nmlvdi) = pNmlvdi
			ENDIF

		CASE $$LVN_ENDLABELEDIT
			IF binding.onLabelEdit THEN
				pNmlvdi = &nmlvdi
				XLONGAT(&&nmlvdi) = lParam
				retCode = @binding.onLabelEdit(nmlvdi.hdr.idFrom, $$EDIT_DONE, nmlvdi.item.iItem, CSTRING$(nmlvdi.item.pszText))
				XLONGAT(&&nmlvdi) = pNmlvdi
			ENDIF

		CASE $$TVN_SELCHANGED
			IF binding.onSelect THEN
				IF !binding.skipOnSelect THEN
					pNmtv = &nmtv ' tree view structure
					XLONGAT(&&nmtv) = lParam
					retCode = @binding.onSelect (nmhdr.idFrom, nmhdr.code, lParam)
					XLONGAT(&&nmtv) = pNmtv
				ENDIF
			ENDIF

		CASE $$LVN_ITEMCHANGED
			IF binding.onSelect THEN
				IF !binding.skipOnSelect THEN
					pNmlv = &nmlv ' list view structure
					XLONGAT(&&nmlv) = lParam
					retCode = @binding.onSelect (nmhdr.idFrom, nmhdr.code, lParam)
					XLONGAT(&&nmlv) = pNmlv
				ENDIF
			ENDIF

	END SELECT

	XLONGAT(&&nmhdr) = nmhdrAddr
	RETURN retCode
END FUNCTION ' onNotify
'
' ######################
' #####  XWSStoWS  #####
' ######################
' Convert a simplified window style to a window style
' xwss = the simplified style
' returns a window style.
FUNCTION XWSStoWS (xwss)
	SELECT CASE xwss
		CASE $$XWSS_APP						: style = $$WS_OVERLAPPEDWINDOW
		CASE $$XWSS_APPNORESIZE		: style = $$WS_OVERLAPPED | $$WS_CAPTION | $$WS_SYSMENU | $$WS_MINIMIZEBOX
		CASE $$XWSS_POPUP					: style = $$WS_POPUPWINDOW | $$WS_CAPTION
		CASE $$XWSS_POPUPNOTITLE	: style = $$WS_POPUPWINDOW
		CASE $$XWSS_NOBORDER			: style = $$WS_POPUP
		CASE ELSE									: style = 0
	END SELECT
	RETURN style
END FUNCTION

FUNCTION autoDraw_add (iList, iRecord)
	LINKEDLIST autoDraw

	LINKEDLIST_Get (iList, @autoDraw)
	LinkedList_Append (@autoDraw, iRecord)
	LINKEDLIST_Update (iList, autoDraw)

	RETURN autoDraw.cItems - 1
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

	IFF LINKEDLIST_Get (group, @list) THEN RETURN
	hWalk = LinkedList_StartWalk (list)
	DO WHILE LinkedList_Walk (hWalk, @iData)
		AUTODRAWRECORD_Get (iData, @record)
		IF record.draw = &drawText () THEN STRING_Delete (record.text.iString)
		DeleteObject (record.hUpdateRegion)
		AUTODRAWRECORD_Delete (iData)
	LOOP
	LinkedList_EndWalk (hWalk)
	LinkedList_DeleteAll (@list)

	LINKEDLIST_Update (group, list)

	RETURN $$TRUE		' success
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

	IFF LINKEDLIST_Get (group, @autoDraw) THEN RETURN
	hWalk = LinkedList_StartWalk (autoDraw)
	DO WHILE LinkedList_Walk (hWalk, @iData)
		AUTODRAWRECORD_Get (iData, @record)

		IF record.hPen <> 0 && record.hPen <> hPen THEN
			hPen = record.hPen
			SelectObject (hdc, record.hPen)
		ENDIF
		IF record.hBrush <> 0 && record.hBrush <> hBrush THEN
			hBrush = record.hBrush
			SelectObject (hdc, record.hBrush)
		ENDIF
		IF record.hFont <> 0 && record.hFont <> hFont THEN
			hFont = record.hFont
			SelectObject (hdc, record.hFont)
		ENDIF

		IF record.toDelete THEN
			AUTODRAWRECORD_Delete (iData)
			LinkedList_DeleteThis (hWalk, @autoDraw)
		ELSE
			@record.draw (hdc, record, x0, y0)
		ENDIF
	LOOP
	LinkedList_EndWalk (hWalk)

	RETURN $$TRUE		' success
END FUNCTION
'
' #######################
' #####  autoSizer  #####
' #######################
' The auto sizer function, resizes child windows
FUNCTION autoSizer (AUTOSIZERINFO autoSizerBlock, direction, x0, y0, nw, nh, currPos)
	RECT rect
	SPLITTERINFO splitterInfo
	FUNCADDR FnLeftInfo (XLONG, XLONG)		' groupBox_SizeContents (hGB, pRect)
	FUNCADDR FnRightInfo (XLONG, XLONG)		' Guy-16mar11-unused???
	' if there is an info block, here, resize the window

	hCtr = autoSizerBlock.hwnd
	IFZ hCtr THEN RETURN

	' calculate the SIZE
	' first, the x, y, w and h of the box
	SELECT CASE direction AND 0x00000003
		CASE $$DIR_VERT
			IF autoSizerBlock.space <= 1 THEN autoSizerBlock.space = autoSizerBlock.space * nh

			IF autoSizerBlock.flags AND $$SIZER_SIZERELREST THEN
				IF direction AND $$DIR_REVERSE THEN rest = currPos ELSE rest = nh - currPos
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size * rest ELSE autoSizerBlock.size = rest - autoSizerBlock.size
				autoSizerBlock.size = autoSizerBlock.size - autoSizerBlock.space
			ELSE
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size * nh
			ENDIF

			IF autoSizerBlock.x <= 1 THEN autoSizerBlock.x = autoSizerBlock.x * nw
			IF autoSizerBlock.y <= 1 THEN autoSizerBlock.y = autoSizerBlock.y * autoSizerBlock.size
			IF autoSizerBlock.w <= 1 THEN autoSizerBlock.w = autoSizerBlock.w * nw
			IF autoSizerBlock.h <= 1 THEN autoSizerBlock.h = autoSizerBlock.h * autoSizerBlock.size

			boxX = x0
			boxY = y0 + currPos + autoSizerBlock.space
			boxW = nw
			boxH = autoSizerBlock.size

			IF autoSizerBlock.flags AND $$SIZER_SPLITTER THEN
				boxH = boxH - 8
				autoSizerBlock.h = autoSizerBlock.h - 8

				IF direction AND $$DIR_REVERSE THEN h = boxY - boxH - 8 ELSE h = boxY + boxH
				MoveWindow (autoSizerBlock.hSplitter, boxX, h, boxW, 8, 0)
				InvalidateRect (autoSizerBlock.hSplitter, 0, 1) ' erase

				iSplitter = GetWindowLongA (autoSizerBlock.hSplitter, $$GWL_USERDATA)
				SPLITTERINFO_Get (iSplitter, @splitterInfo)
				IF direction AND $$DIR_REVERSE THEN splitterInfo.maxSize = currPos - autoSizerBlock.space ELSE splitterInfo.maxSize = nh - currPos - autoSizerBlock.space
				SPLITTERINFO_Update (iSplitter, splitterInfo)
			ENDIF

			IF direction AND $$DIR_REVERSE THEN boxY = boxY - boxH
		CASE $$DIR_HORIZ
			IF autoSizerBlock.space <= 1 THEN autoSizerBlock.space = autoSizerBlock.space * nw

			IF autoSizerBlock.flags AND $$SIZER_SIZERELREST THEN
				IF direction AND $$DIR_REVERSE THEN rest = currPos ELSE rest = nw - currPos
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size * rest ELSE autoSizerBlock.size = rest - autoSizerBlock.size
				autoSizerBlock.size = autoSizerBlock.size - autoSizerBlock.space
			ELSE
				IF autoSizerBlock.size <= 1 THEN autoSizerBlock.size = autoSizerBlock.size * nw
			ENDIF

			IF autoSizerBlock.x <= 1 THEN autoSizerBlock.x = autoSizerBlock.x * autoSizerBlock.size
			IF autoSizerBlock.y <= 1 THEN autoSizerBlock.y = autoSizerBlock.y * nh
			IF autoSizerBlock.w <= 1 THEN autoSizerBlock.w = autoSizerBlock.w * autoSizerBlock.size
			IF autoSizerBlock.h <= 1 THEN autoSizerBlock.h = autoSizerBlock.h * nh
			boxX = x0 + currPos + autoSizerBlock.space
			boxY = y0
			boxW = autoSizerBlock.size
			boxH = nh

			IF autoSizerBlock.flags AND $$SIZER_SPLITTER THEN
				boxW = boxW - 8
				autoSizerBlock.w = autoSizerBlock.w - 8

				IF direction AND $$DIR_REVERSE THEN h = boxX - boxW - 8 ELSE h = boxX + boxW
				MoveWindow (autoSizerBlock.hSplitter, h, boxY, 8, boxH, 0)
				InvalidateRect (autoSizerBlock.hSplitter, 0, 1) ' erase

				iSplitter = GetWindowLongA (autoSizerBlock.hSplitter, $$GWL_USERDATA)
				SPLITTERINFO_Get (iSplitter, @splitterInfo)
				IF direction AND $$DIR_REVERSE THEN splitterInfo.maxSize = currPos - autoSizerBlock.space ELSE splitterInfo.maxSize = nw - currPos - autoSizerBlock.space
				SPLITTERINFO_Update (iSplitter, splitterInfo)
			ENDIF

			IF direction AND $$DIR_REVERSE THEN boxX = boxX - boxW
	END SELECT

	' adjust the width and height as necassary
	IF autoSizerBlock.flags AND $$SIZER_WCOMPLEMENT THEN autoSizerBlock.w = boxW - autoSizerBlock.w
	IF autoSizerBlock.flags AND $$SIZER_HCOMPLEMENT THEN autoSizerBlock.h = boxH - autoSizerBlock.h

	' adjust x and y
	IF autoSizerBlock.x < 0 THEN
		autoSizerBlock.x = (boxW - autoSizerBlock.w) \ 2
	ELSE
		IF autoSizerBlock.flags AND $$SIZER_XRELRIGHT THEN autoSizerBlock.x = boxW - autoSizerBlock.x
	ENDIF
	IF autoSizerBlock.y < 0 THEN
		autoSizerBlock.y = (boxH - autoSizerBlock.h) \ 2
	ELSE
		IF autoSizerBlock.flags AND $$SIZER_YRELBOTTOM THEN autoSizerBlock.y = boxH - autoSizerBlock.y
	ENDIF

	IF autoSizerBlock.flags AND $$SIZER_SERIES THEN
		autoSizerInfo_sizeGroup (hCtr, autoSizerBlock.x + boxX, autoSizerBlock.y + boxY, autoSizerBlock.w, autoSizerBlock.h)
	ELSE
		' Actually size the control
		IF (autoSizerBlock.w < 1) || (autoSizerBlock.h < 1) THEN
			ShowWindow (hCtr, $$SW_HIDE)
		ELSE
			ShowWindow (hCtr, $$SW_SHOW)
			MoveWindow (hCtr, autoSizerBlock.x + boxX, autoSizerBlock.y + boxY, autoSizerBlock.w, autoSizerBlock.h, 1) ' repaint
		ENDIF

		FnLeftInfo = GetPropA (hCtr, &$$LeftSubSizer$)
		FnRightInfo = GetPropA (hCtr, &$$RightSubSizer$)
		IF FnLeftInfo THEN
			series = @FnLeftInfo (hCtr, &rect)
			autoSizerInfo_sizeGroup (series, autoSizerBlock.x + boxX + rect.left, autoSizerBlock.y + boxY + rect.top, (rect.right - rect.left), (rect.bottom - rect.top))
		ENDIF
		IF FnRightInfo THEN
			series = @FnRightInfo (hCtr, &rect)
			autoSizerInfo_sizeGroup (series, autoSizerBlock.x + boxX + rect.left, _
			autoSizerBlock.y + boxY + rect.top, (rect.right - rect.left), (rect.bottom - rect.top))
		ENDIF
	ENDIF

	IF direction AND $$DIR_REVERSE THEN
		RETURN currPos - autoSizerBlock.space - autoSizerBlock.size
	ELSE
		RETURN currPos + autoSizerBlock.space + autoSizerBlock.size
	ENDIF
END FUNCTION
'
' ###################################
' #####  autoSizerBlock_Delete  #####
' ###################################
' Deletes an autosizer info block
' idCtr = the id of the auto sizer to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION autoSizerBlock_Delete (id, idCtr)
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]		'info for the autosizer
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]

	IF id < 0 || id > UBOUND (AUTOSIZER_LinkedList[]) THEN RETURN
	IFF AUTOSIZER_LinkedList[id].inUse THEN RETURN
	IF idCtr < 0 || idCtr > UBOUND (AUTOSIZERINFO_array[id,]) THEN RETURN
	IFZ AUTOSIZERINFO_array[id, idCtr].hwnd THEN RETURN

	AUTOSIZERINFO_array[id, idCtr].hwnd = 0

	IF idCtr = AUTOSIZER_LinkedList[id].iHead THEN
		AUTOSIZER_LinkedList[id].iHead = AUTOSIZERINFO_array[id, idCtr].nextItem
		AUTOSIZERINFO_array[id, AUTOSIZERINFO_array[id, idCtr].nextItem].prevItem = -1
		IF AUTOSIZER_LinkedList[id].iHead = -1 THEN AUTOSIZER_LinkedList[id].iTail = -1
	ELSE
		IF idCtr = AUTOSIZER_LinkedList[id].iTail THEN
			AUTOSIZERINFO_array[id, AUTOSIZER_LinkedList[id].iTail].nextItem = -1
			AUTOSIZER_LinkedList[id].iTail = AUTOSIZERINFO_array[id, idCtr].prevItem
			IF AUTOSIZER_LinkedList[id].iTail = -1 THEN AUTOSIZER_LinkedList[id].iHead = -1
		ELSE
			AUTOSIZERINFO_array[id, AUTOSIZERINFO_array[id, idCtr].nextItem].prevItem = AUTOSIZERINFO_array[id, idCtr].prevItem
			AUTOSIZERINFO_array[id, AUTOSIZERINFO_array[id, idCtr].prevItem].nextItem = AUTOSIZERINFO_array[id, idCtr].nextItem
		ENDIF
	ENDIF

	RETURN $$TRUE		' success
END FUNCTION
'
' ####################################
' #####  autoSizerInfo_AddGroup  #####
' ####################################
' Adds a new autosizer info block
' item = the auto sizer block to add
' returns the idCtr of the auto sizer block or -1 on fail
FUNCTION autoSizerInfo_AddGroup (id, AUTOSIZERINFO item)
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]		'info for the autosizer
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]
	SHARED autoSizerInfo_idMax

	AUTOSIZERINFO autoSizerInfoLocal[]

	IF id < 0 || id > UBOUND (AUTOSIZER_LinkedList[]) THEN RETURN -1		' fail
	IFF AUTOSIZER_LinkedList[id].inUse THEN RETURN -1		' fail

	slot = -1
	upp = UBOUND (AUTOSIZERINFO_array[id,])
	FOR i = 0 TO upp
		IFZ AUTOSIZERINFO_array[id, i].hwnd THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	IF slot = -1 THEN
		slot = UBOUND (AUTOSIZERINFO_array[id,]) + 1
		SWAP autoSizerInfoLocal[], AUTOSIZERINFO_array[id,]
		REDIM autoSizerInfoLocal[ ((UBOUND (autoSizerInfoLocal[]) + 1) << 1) - 1]
		SWAP autoSizerInfoLocal[], AUTOSIZERINFO_array[id,]
	ENDIF

	AUTOSIZERINFO_array[id, slot] = item

	AUTOSIZERINFO_array[id, slot].nextItem = -1

	IF AUTOSIZER_LinkedList[id].iTail = -1 THEN
		' Make this the first item
		AUTOSIZER_LinkedList[id].iHead = slot
		AUTOSIZER_LinkedList[id].iTail = slot
		AUTOSIZERINFO_array[id, slot].prevItem = -1
	ELSE
		' add to the end of the list
		AUTOSIZERINFO_array[id, slot].prevItem = AUTOSIZER_LinkedList[id].iTail
		AUTOSIZERINFO_array[id, AUTOSIZER_LinkedList[id].iTail].nextItem = slot
		AUTOSIZER_LinkedList[id].iTail = slot
	ENDIF

	RETURN slot
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
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]		'info for the autosizer
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]

	IF group < 0 || group > UBOUND (AUTOSIZER_LinkedList[]) THEN RETURN
	IFF AUTOSIZER_LinkedList[group].inUse THEN RETURN

	IF visible THEN command = $$SW_SHOWNA ELSE command = $$SW_HIDE

	i = AUTOSIZER_LinkedList[group].iHead
	DO WHILE i > -1
		IF AUTOSIZERINFO_array[group, i].hwnd THEN
			ShowWindow (AUTOSIZERINFO_array[group, i].hwnd, command)
		ENDIF

		i = AUTOSIZERINFO_array[group, i].nextItem
	LOOP

	RETURN $$TRUE		' success
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
	SHARED AUTOSIZERINFO AUTOSIZERINFO_array[]		'info for the autosizer
	SHARED AUTOSIZER_LINKEDLIST AUTOSIZER_LinkedList[]

	IF group < 0 || group > UBOUND (AUTOSIZER_LinkedList[]) THEN RETURN
	IFF AUTOSIZER_LinkedList[group].inUse THEN RETURN

	' Guy-13jan11-#hWinPosInfo = BeginDeferWindowPos (cItem)
	cItem = 0
	i = AUTOSIZER_LinkedList[group].iHead
	DO WHILE i > -1
		IF AUTOSIZERINFO_array[group, i].hwnd THEN INC cItem
		i = AUTOSIZERINFO_array[group, i].nextItem
	LOOP
	IF cItem < 1 THEN RETURN

	IF AUTOSIZER_LinkedList[group].direction AND $$DIR_REVERSE THEN
		SELECT CASE AUTOSIZER_LinkedList[group].direction AND 0x00000003
			CASE $$DIR_HORIZ
				currPos = w
			CASE $$DIR_VERT
				currPos = h
		END SELECT
	ELSE
		currPos = 0
	ENDIF

	' Guy-13jan11-cItem is known
	' #hWinPosInfo = BeginDeferWindowPos (10)
	#hWinPosInfo = BeginDeferWindowPos (cItem)
	i = AUTOSIZER_LinkedList[group].iHead
	DO WHILE i > -1
		IF AUTOSIZERINFO_array[group, i].hwnd THEN
			currPos = autoSizer (AUTOSIZERINFO_array[group, i], AUTOSIZER_LinkedList[group].direction, x0, y0, w, h, currPos)
		ENDIF

		i = AUTOSIZERINFO_array[group, i].nextItem
	LOOP
	EndDeferWindowPos (#hWinPosInfo)

	RETURN $$TRUE		' success
END FUNCTION
'
' ##############################
' #####  cancelDlgOnClose  #####
' ##############################
' FnOnClose callback for the cancel printing dialog box
FUNCTION cancelDlgOnClose (hWnd)
	SHARED PRINTINFO printInfo
	printInfo.continuePrinting = $$FALSE
	printInfo.hCancelDlg = 0
	DestroyWindow (hWnd)
END FUNCTION
'
' ################################
' #####  cancelDlgOnCommand  #####
' ################################
' FnOnCommand callback for the cancel printing dialog box
FUNCTION cancelDlgOnCommand (idCtr, code, hWnd)
	SHARED PRINTINFO printInfo

	SELECT CASE idCtr
		CASE $$IDCANCEL
			SendMessageA (printInfo.hCancelDlg, $$WM_CLOSE, 0, 0)
	END SELECT
END FUNCTION
'
' #####################
' #####  drawArc  #####
' #####################
FUNCTION VOID drawArc (hdc, AUTODRAWRECORD record, x0, y0)
	Arc (hdc, record.rectControl.x1 - x0, record.rectControl.y1 - y0, record.rectControl.x2 - x0, _
	record.rectControl.y2 - y0, record.rectControl.xC1 - x0, record.rectControl.yC1 - y0, _
	record.rectControl.xC2 - x0, record.rectControl.yC2 - y0)
END FUNCTION
'
' ########################
' #####  drawBezier  #####
' ########################
FUNCTION VOID drawBezier (hdc, AUTODRAWRECORD record, x0, y0)
	POINT pt[]

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
END FUNCTION
'
' #########################
' #####  drawEllipse  #####
' #########################
' Draw an ellipse
' hdc = the dc to draw on
' record = the draw record
FUNCTION VOID drawEllipse (hdc, AUTODRAWRECORD record, x0, y0)
	Ellipse (hdc, record.rect.x1 - x0, record.rect.y1 - y0, record.rect.x2 - x0, record.rect.y2 - y0)
END FUNCTION
'
' ###############################
' #####  drawEllipseNoFill  #####
' ###############################
FUNCTION VOID drawEllipseNoFill (hdc, AUTODRAWRECORD record, x0, y0)
	xMid = (record.rect.x1 + record.rect.x2) \ 2 - x0
	y1py0 = record.rect.y1 - y0
	Arc (hdc, record.rect.x1 - x0, y1py0, record.rect.x2 - x0, record.rect.y2 - y0, xMid, y1py0, xMid, y1py0)
END FUNCTION
'
' ######################
' #####  drawFill  #####
' ######################
FUNCTION VOID drawFill (hdc, AUTODRAWRECORD record, x0, y0)
	ExtFloodFill (hdc, record.simpleFill.x - x0, record.simpleFill.y - y0, record.simpleFill.col, $$FLOODFILLBORDER)
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
		' AlphaBlend is misdefined in headers, so call it through a wrapper
		ApiAlphaBlend (hdc, record.image.x - x0, record.image.y - y0, record.image.w, record.image.h, hdcSrc, _
		record.image.xSrc, record.image.ySrc, record.image.w, record.image.h, blfn)
	ELSE
		BitBlt (hdc, record.image.x - x0, record.image.y - y0, record.image.w, record.image.h, hdcSrc, _
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
FUNCTION VOID drawLine (hdc, AUTODRAWRECORD record, x0, y0)
	MoveToEx (hdc, record.rect.x1 - x0, record.rect.y1 - y0, 0)
	LineTo (hdc, record.rect.x2 - x0, record.rect.y2 - y0)
END FUNCTION
'
' ######################
' #####  drawRect  #####
' ######################
' draws a rectangle
' hdc = the dc to draw on
' record = the draw record
FUNCTION VOID drawRect (hdc, AUTODRAWRECORD record, x0, y0)
	Rectangle (hdc, record.rect.x1 - x0, record.rect.y1 - y0, record.rect.x2 - x0, record.rect.y2 - y0)
END FUNCTION
'
' ############################
' #####  drawRectNoFill  #####
' ############################
FUNCTION VOID drawRectNoFill (hdc, AUTODRAWRECORD record, x0, y0)
	POINT pt[]
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
' Draws a text string
FUNCTION VOID drawText (hdc, AUTODRAWRECORD record, x0, y0)
	SetTextColor (hdc, record.text.forColour)
	IF record.text.backColour = -1 THEN
		SetBkMode (hdc, $$TRANSPARENT)
	ELSE
		SetBkMode (hdc, $$OPAQUE)
		SetBkColor (hdc, record.text.backColour)
	ENDIF
	STRING_Get (record.text.iString, @stri$)
	ExtTextOutA (hdc, record.text.x - x0, record.text.y - y0, options, 0, &stri$, LEN (stri$), 0)
END FUNCTION
'
' ###################################
' #####  groupBox_SizeContents  #####
' ###################################
' get the viewable area for a group box, returns the auto sizer series
FUNCTION groupBox_SizeContents (hGB, pRect)
	RECT rect
	aRect = &rect
	XLONGAT (&&rect) = pRect

	GetClientRect (hGB, &rect)
	rect.left = rect.left + 4
	rect.right = rect.right - 4
	rect.top = rect.top + 16
	rect.bottom = rect.bottom - 4

	XLONGAT (&&rect) = aRect

	RETURN GetPropA (hGB, &"WinXAutoSizerSeries")
END FUNCTION
'
' ##########################
' #####  HANDLER_Init  #####
' ##########################
'
FUNCTION HANDLER_Init ()
	SHARED HANDLER group_ragged[]		'a 2D array of handlers
	SHARED group_arrayUM[]		'a usage map so we can see which groups are in use
	SHARED group_idMax

	DIM group_ragged[7,]
	DIM group_arrayUM[7]
	group_idMax = 0
END FUNCTION
'
' #########################
' #####  HANDLER_New  #####
' #########################
' Adds a new group of handlers
' returns r_group_id, the id of the group
FUNCTION HANDLER_New ()
	SHARED HANDLER group_ragged[]
	SHARED group_arrayUM[]
	SHARED group_idMax

	IFZ group_arrayUM[] THEN HANDLER_Init ()

	upper_slot = UBOUND (group_arrayUM[])
	slot = -1
	IF group_idMax <= upper_slot THEN
		FOR i = group_idMax TO upper_slot
			IFF group_arrayUM[i] THEN
				slot = i
				group_idMax = i + 1
				EXIT FOR
			ENDIF
		NEXT i
	ENDIF

	IF slot = -1 THEN
		upper_slot = ((upper_slot + 1) << 1) - 1
		REDIM group_ragged[upper_slot,]
		REDIM group_arrayUM[upper_slot]
		slot = group_idMax
		INC group_idMax
	ENDIF

	IF (slot < 0) || (slot > upper_slot) THEN RETURN
	group_arrayUM[slot] = $$TRUE
	r_group_id = slot + 1
	RETURN r_group_id
END FUNCTION
'
' ############################
' #####  HANDLER_Delete  #####
' ############################
' Deletes a group of handlers
' v_group = the group to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION HANDLER_Delete (v_group)
	SHARED HANDLER group_ragged[]
	SHARED group_arrayUM[]
	SHARED group_idMax

	IFZ group_arrayUM[] THEN RETURN
	IF v_group >= group_idMax THEN RETURN

	upper_slot = UBOUND (group_arrayUM[])
	IF (v_group < 0) || (v_group > upper_slot) THEN RETURN
	IFF group_arrayUM[v_group] THEN RETURN

	group_arrayUM[v_group] = $$FALSE
	RETURN $$TRUE ' success
END FUNCTION
'
' #############################
' #####  HANDLER_AddItem  #####
' #############################
' Add a new handler to a group
' v_group_id = the group to add the handler to
' v_handler = the handler to add
' returns r_index = the index of the new handler or -1 on fail
FUNCTION HANDLER_AddItem (v_group_id, HANDLER v_handler)
	SHARED HANDLER group_ragged[]
	SHARED group_arrayUM[]
	SHARED group_idMax

	HANDLER local_group[]		'a local version of the group

	IFZ v_handler.code THEN RETURN -1		' Guy-17mar11-fail
	IF v_group_id < 1 || v_group_id > group_idMax THEN RETURN -1

	slot = v_group_id - 1
	IFF group_arrayUM[slot] THEN RETURN -1

	IFZ group_ragged[slot,] THEN
		DIM local_group[0]
		local_group[0] = v_handler
		ATTACH local_group[] TO group_ragged[slot,]
		RETURN
	ENDIF

	' find a free slot
	r_index = -1
	upper_index = UBOUND (group_ragged[slot,])
	DIM local_group[upper_index]
	FOR i = 0 TO upper_index
		IF group_ragged[slot, i].code = v_handler.code THEN RETURN -1
		local_group[i] = group_ragged[slot, i]
		IF r_index = -1 THEN
			IFZ group_ragged[slot, i].code THEN r_index = i ' free slot
		ENDIF
	NEXT i

	IF r_index = -1 THEN		'allocate more memmory
		INC upper_index
		REDIM local_group[upper_index]
		r_index = upper_index
	ENDIF

	' now finish it off
	local_group[r_index] = v_handler
	SWAP local_group[], group_ragged[slot,]
	RETURN r_index
END FUNCTION
'
' ##################################
' #####  HANDLER_FindItemCode  #####
' ##################################
' Locates a handler in the handler array
' v_group_id = the group id of the handler to search
' v_find = the message to search for
' returns r_index, the index of the message handler, -1 if it fails
' to find anything and -2 if there is a bounds error
FUNCTION HANDLER_FindItemCode (v_group_id, v_find)
	SHARED HANDLER group_ragged[]
	SHARED group_arrayUM[]
	SHARED group_idMax

	IF v_group_id < 1 || v_group_id > group_idMax THEN RETURN -1
	IFZ v_find THEN RETURN -2

	slot = v_group_id - 1
	upper_index = UBOUND (group_ragged[slot,])
	FOR r_index = 0 TO upper_index
		IFZ group_ragged[slot, r_index].code THEN DO NEXT
		IF group_ragged[slot, r_index].code = v_find THEN RETURN r_index
	NEXT r_index

	RETURN -1
END FUNCTION
'
' #############################
' #####  HANDLER_GetItem  #####
' #############################
' Retrieve a handler from the handler array
' v_group_id = the group id of the handler to retreive
' v_index = the index of the handler
' r_handler = the variable to store the handler
' returns $$TRUE on success or $$FALSE on fail
FUNCTION HANDLER_GetItem (v_group_id, v_index, HANDLER r_handler)
	SHARED HANDLER group_ragged[]
	SHARED group_arrayUM[]
	SHARED group_idMax

	HANDLER item_null

	r_handler = item_null ' reset
	IFZ group_arrayUM[] THEN RETURN
	IF v_group_id < 1 || v_group_id > group_idMax THEN RETURN
	IF v_index < 0 THEN RETURN

	upper_slot = UBOUND (group_arrayUM[])
	slot = v_group_id - 1
	IF slot > upper_slot THEN RETURN
	IFF group_arrayUM[slot] THEN RETURN
	IFZ group_ragged[slot,] THEN RETURN


	upper_index = UBOUND (group_ragged[slot,])
	IF v_index > upper_index THEN RETURN

	IFZ group_ragged[slot, v_index].code THEN RETURN

	r_handler = group_ragged[slot, v_index]
	RETURN $$TRUE ' success
END FUNCTION
'
' ##############################
' #####  HANDLER_CallItem  #####
' ##############################
' Calls the handler for a specified message
' group_id = the group_id to call from
' retCode = the variable to hold the message return value
' hWnd, wMsg, wParam, lParam = the usual definitions for these parameters
' returns $$TRUE on success or $$FALSE on fail
FUNCTION HANDLER_CallItem (group_id, @r_ret, hWnd, wMsg, wParam, lParam)
	HANDLER msgHandler

	' first, find the msgHandler
	index = HANDLER_FindItemCode (group_id, wMsg)
	IF index < 0 THEN RETURN

	bOK = HANDLER_GetItem (group_id, index, @msgHandler)
	IFF bOK THEN RETURN

	r_ret = @msgHandler.handler (hWnd, wMsg, wParam, lParam)
	RETURN $$TRUE ' success
END FUNCTION
'
' ###########################
' #####  initPrintInfo  #####
' ###########################
FUNCTION initPrintInfo ()
	SHARED PRINTINFO printInfo
	PAGESETUPDLG pageSetupDlg

	' pageSetupDlg.lStructSize = SIZE(PAGESETUPDLG)
	' pageSetupDlg.flags = $$PSD_DEFAULTMINMARGINS|$$PSD_RETURNDEFAULT
	' PageSetupDlgA (&pageSetupDlg)

	' printInfo.hDevMode = pageSetupDlg.hDevMode
	' printInfo.hDevNames = pageSetupDlg.hDevNames
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
' Abort proc for printing
FUNCTION printAbortProc (hdc, nCode)
	SHARED PRINTINFO printInfo
	MSG wMsg

	DO WHILE PeekMessageA (&wMsg, 0, 0, 0, $$PM_REMOVE)
		IF !IsDialogMessageA (printInfo.hCancelDlg, &wMsg) THEN
			TranslateMessage (&wMsg)
			DispatchMessageA (&wMsg)
		ENDIF
	LOOP

	RETURN printInfo.continuePrinting
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

	BINDING binding
	SCROLLINFO si
	RECT rect

	' get the binding
	idBinding = GetWindowLongA (hWnd, $$GWL_USERDATA)
	IFF BINDING_Get (idBinding, @binding) THEN RETURN

	' now handle the bar
	IF w > maxX THEN
		SendMessageA (binding.hBar, $$WM_SIZE, wParam, lParam)
		maxX = w
	ENDIF

	' handle the status bar
	' first, resize the partitions
	DIM parts[binding.statusParts]
	FOR i = 0 TO binding.statusParts
		parts[i] = ((i + 1) * w) / (binding.statusParts + 1)
	NEXT i
	SendMessageA (binding.hStatus, $$WM_SIZE, wParam, lParam)
	SendMessageA (binding.hStatus, $$SB_SETPARTS, binding.statusParts + 1, &parts[0])

	' and the scroll bars
	xoff = 0
	yoff = 0

	style = GetWindowLongA (hWnd, $$GWL_STYLE)
	SELECT CASE ALL TRUE
		CASE style AND $$WS_HSCROLL
			si.cbSize = SIZE (SCROLLINFO)
			si.fMask = $$SIF_PAGE | $$SIF_DISABLENOSCROLL
			si.nPage = w * binding.hScrollPageM + binding.hScrollPageC
			SetScrollInfo (hWnd, $$SB_HORZ, &si, $$TRUE)

			si.fMask = $$SIF_POS
			GetScrollInfo (hWnd, $$SB_HORZ, &si)
			xoff = si.nPos
		CASE style AND $$WS_VSCROLL
			si.cbSize = SIZE (SCROLLINFO)
			si.fMask = $$SIF_PAGE | $$SIF_DISABLENOSCROLL
			si.nPage = h * binding.vScrollPageM + binding.vScrollPageC
			SetScrollInfo (hWnd, $$SB_VERT, &si, $$TRUE)

			si.fMask = $$SIF_POS
			GetScrollInfo (hWnd, $$SB_VERT, &si)
			yoff = si.nPos
	END SELECT

	' use the auto sizer
	WinXGetUseableRect (hWnd, @rect)
	autoSizerInfo_sizeGroup (binding.autoSizerInfo, rect.left - xoff, rect.top - yoff, rect.right - rect.left, rect.bottom - rect.top)
	@binding.onScroll (xoff, hWnd, $$DIR_HORIZ)
	@binding.onScroll (yoff, hWnd, $$DIR_VERT)

	' InvalidateRect (hWnd, 0, 0)

	RETURN @binding.onDimControls (hWnd, w, h)
END FUNCTION
'
' ##########################
' #####  splitterProc  #####
' ##########################
' Window procedure for WinX Splitters.
FUNCTION splitterProc (hWnd, wMsg, wParam, lParam)
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

	SELECT CASE wMsg
		CASE $$WM_CREATE
			' lParam format = iSlitterInfo
			SetWindowLongA (hWnd, $$GWL_USERDATA, XLONGAT (lParam))
			mouseIn = 0

			DIM vertex[2]
		CASE $$WM_PAINT
			hDC = BeginPaint (hWnd, &ps)

			hShadPen = CreatePen ($$PS_SOLID, 1, GetSysColor ($$COLOR_3DSHADOW))
			hBlackPen = CreatePen ($$PS_SOLID, 1, 0x000000)
			hBlackBrush = CreateSolidBrush (0x000000)
			hHighlightBrush = CreateSolidBrush (GetSysColor ($$COLOR_HIGHLIGHT))
			SelectObject (hDC, hShadPen)

			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hWnd, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN FillRect (hDC, &dock, hHighlightBrush)

			SELECT CASE splitterInfo.direction AND 0x00000003
				CASE $$DIR_VERT
					SELECT CASE TRUE
						CASE $$DOCK_DISABLED
						CASE ((splitterInfo.dock = $$DOCK_FORWARD) && (splitterInfo.docked = 0)) || _
							((splitterInfo.dock = $$DOCK_BACKWARD) && (splitterInfo.docked > 0))
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
						CASE ((splitterInfo.dock = $$DOCK_BACKWARD) && (splitterInfo.docked = 0)) || _
							((splitterInfo.dock = $$DOCK_FORWARD) && (splitterInfo.docked > 0))
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
						CASE ((splitterInfo.dock = $$DOCK_FORWARD) && (splitterInfo.docked = 0)) || _
							((splitterInfo.dock = $$DOCK_BACKWARD) && (splitterInfo.docked > 0))
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
						CASE ((splitterInfo.dock = $$DOCK_BACKWARD) && (splitterInfo.docked = 0)) || _
							((splitterInfo.dock = $$DOCK_FORWARD) && (splitterInfo.docked > 0))
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

			EndPaint (hWnd, &ps)

			RETURN
		CASE $$WM_LBUTTONDOWN
			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hWnd, &pt)
			IFF PtInRect (&dock, pt.x, pt.y) || splitterInfo.docked THEN
				SetCapture (hWnd)
				dragging = $$TRUE
				mousePos.x = LOWORD (lParam)
				mousePos.y = HIWORD (lParam)
				ClientToScreen (hWnd, &mousePos)
			ENDIF

			RETURN

		CASE $$WM_SETCURSOR
			GOSUB GetRect

			GetCursorPos (&pt)
			ScreenToClient (hWnd, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
				SetCursor (LoadCursorA (0, $$IDC_HAND))
			ELSE
				GOSUB SetSizeCursor
			ENDIF

			RETURN $$TRUE		' fail
		CASE $$WM_MOUSEMOVE
			GOSUB GetRect

			GetCursorPos (&pt)
			ScreenToClient (hWnd, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
				IFF inDock THEN
					' SetCursor (LoadCursorA (0, $$IDC_HAND))
					InvalidateRect (hWnd, 0, 1) ' erase
				ENDIF
				inDock = $$TRUE
			ELSE
				IF inDock THEN
					' GOSUB SetSizeCursor
					InvalidateRect (hWnd, 0, 1) ' erase
				ENDIF
				inDock = $$FALSE
			ENDIF

			IFF mouseIn THEN
				GetCursorPos (&pt)
				ScreenToClient (hWnd, &pt)
				IF PtInRect (&dock, pt.x, pt.y) THEN
					SetCursor (LoadCursorA (0, $$IDC_HAND))
					InvalidateRect (hWnd, 0, 1) ' erase
					inDock = $$TRUE
				ELSE
					GOSUB SetSizeCursor
					inDock = $$FALSE
				ENDIF

				tme.cbSize = SIZE (tme)
				tme.dwFlags = $$TME_LEAVE
				tme.hwndTrack = hWnd
				TrackMouseEvent (&tme)
				mouseIn = $$TRUE
			ENDIF

			IF dragging THEN
				newMousePos.x = LOWORD (lParam)
				newMousePos.y = HIWORD (lParam)
				ClientToScreen (hWnd, &newMousePos)

				' PRINT mouseX, newMouseX, mouseY, newMouseY

				AUTOSIZER_LinkedList_Get (splitterInfo.group, splitterInfo.id, @autoSizerBlock)

				SELECT CASE splitterInfo.direction AND 0x00000003
					CASE $$DIR_HORIZ
						delta = newMousePos.x - mousePos.x
					CASE $$DIR_VERT
						delta = newMousePos.y - mousePos.y
				END SELECT

				IFZ delta THEN RETURN
				IF splitterInfo.direction AND $$DIR_REVERSE THEN
					autoSizerBlock.size = autoSizerBlock.size - delta
					IF splitterInfo.min && autoSizerBlock.size < splitterInfo.min THEN
						autoSizerBlock.size = splitterInfo.min
					ELSE
						IF splitterInfo.max && autoSizerBlock.size > splitterInfo.max THEN autoSizerBlock.size = splitterInfo.max
					ENDIF
				ELSE
					autoSizerBlock.size = autoSizerBlock.size + delta
					IF splitterInfo.max && autoSizerBlock.size > splitterInfo.max THEN
						autoSizerBlock.size = splitterInfo.max
					ELSE
						IF splitterInfo.min && autoSizerBlock.size < splitterInfo.min THEN autoSizerBlock.size = splitterInfo.min
					ENDIF
				ENDIF

				IF autoSizerBlock.size < 8 THEN
					autoSizerBlock.size = 8
				ELSE
					IF autoSizerBlock.size > splitterInfo.maxSize THEN autoSizerBlock.size = splitterInfo.maxSize
				ENDIF

				AUTOSIZER_LinkedList_Update (splitterInfo.group, splitterInfo.id, autoSizerBlock)
				hParent = GetParent (hWnd)
				GetClientRect (hParent, &rect)
				sizeWindow (hParent, rect.right - rect.left, rect.bottom - rect.top)

				mousePos = newMousePos
			ENDIF

			RETURN
		CASE $$WM_LBUTTONUP
			GOSUB GetRect
			GetCursorPos (&pt)
			ScreenToClient (hWnd, &pt)
			IF PtInRect (&dock, pt.x, pt.y) THEN
				IF splitterInfo.docked THEN
					AUTOSIZER_LinkedList_Get (splitterInfo.group, splitterInfo.id, @autoSizerBlock)
					autoSizerBlock.size = splitterInfo.docked
					splitterInfo.docked = 0

					SPLITTERINFO_Update (GetWindowLongA (hWnd, $$GWL_USERDATA), splitterInfo)

					AUTOSIZER_LinkedList_Update (splitterInfo.group, splitterInfo.id, autoSizerBlock)
					hParent = GetParent (hWnd)
					GetClientRect (hParent, &rect)
					sizeWindow (hParent, rect.right - rect.left, rect.bottom - rect.top)
				ELSE
					AUTOSIZER_LinkedList_Get (splitterInfo.group, splitterInfo.id, @autoSizerBlock)
					splitterInfo.docked = autoSizerBlock.size
					autoSizerBlock.size = 8

					SPLITTERINFO_Update (GetWindowLongA (hWnd, $$GWL_USERDATA), splitterInfo)

					AUTOSIZER_LinkedList_Update (splitterInfo.group, splitterInfo.id, autoSizerBlock)
					hParent = GetParent (hWnd)
					GetClientRect (hParent, &rect)
					sizeWindow (hParent, rect.right - rect.left, rect.bottom - rect.top)
				ENDIF
			ELSE
				dragging = $$FALSE
				ReleaseCapture ()
			ENDIF

			RETURN
		CASE $$WM_MOUSELEAVE
			InvalidateRect (hWnd, 0, 1) ' erase
			mouseIn = $$FALSE

			RETURN
		CASE $$WM_DESTROY
			SPLITTERINFO_Delete (GetWindowLongA (hWnd, $$GWL_USERDATA))

			RETURN
		CASE ELSE

			RETURN DefWindowProcA (hWnd, wMsg, wParam, lParam)
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
				SetPixel (hDC, dock.left + i, 3, GetSysColor ($$COLOR_3DHILIGHT))
				INC state
			CASE 1
				SetPixel (hDC, dock.left + i, 4, GetSysColor ($$COLOR_3DSHADOW))
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
				SetPixel (hDC, 3, i + dock.top, GetSysColor ($$COLOR_3DHILIGHT))
				INC state
			CASE 1
				SetPixel (hDC, 4, i + dock.top, GetSysColor ($$COLOR_3DSHADOW))
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
		SELECT CASE splitterInfo.direction AND 0x00000003
			CASE $$DIR_VERT
				GetClientRect (hWnd, &rect)
				dock.left = (rect.right - 120) / 2
				dock.right = dock.left + 120
				dock.top = 0
				dock.bottom = 8
			CASE $$DIR_HORIZ
				GetClientRect (hWnd, &rect)
				dock.top = (rect.bottom - 120) / 2
				dock.bottom = dock.top + 120
				dock.left = 0
				dock.right = 8
		END SELECT
	ENDIF
END SUB

SUB SetSizeCursor
	IF splitterInfo.direction AND 0x00000003 = $$DIR_HORIZ THEN
		SetCursor (LoadCursorA (0, $$IDC_SIZEWE))		' vertical bar
	ELSE
		SetCursor (LoadCursorA (0, $$IDC_SIZENS))		' horizontal bar
	ENDIF
END SUB
END FUNCTION
'
' ###############################
' #####  tabs_SizeContents  #####
' ###############################
'
FUNCTION tabs_SizeContents (hTabs, pRect)
	GetClientRect (hTabs, pRect)
	SendMessageA (hTabs, $$TCM_ADJUSTRECT, 0, pRect)
	RETURN WinXTabs_GetAutosizerSeries (hTabs, WinXTabs_GetCurrentTab (hTabs))
END FUNCTION
'
'
' #######################
' #####  M4 macros  #####
' #######################
' Notes:
' - use the compiler switch -m4
' - note the absence of spaces
'
DefineAccess(BINDING)
DefineAccess(SPLITTERINFO)
DefineAccess(LINKEDLIST)
DefineAccess(AUTODRAWRECORD)

END PROGRAM
