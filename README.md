Win.dll
GUI library for XBlite

(c) Callum Lowcay 2007-2008  Distributed under the terms of the GNU LGPL.
    Guy Lonne     2011-2025

The WinX library (ie WinX.x and any binaries derived from that file) may only be used or redistributed under the terms of the GNU LGPL.  Please see COPYING_LIB for a full copy of this licence.

WARNING:

 BECAUSE THE LIBRARY IS LICENSED FREE OF CHARGE,
 THERE IS NO WARRANTY FOR THE LIBRARY, TO THE EXTENT
 PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN OTHERWISE
 STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER
 PARTIES PROVIDE THE LIBRARY "AS IS" WITHOUT WARRANTY
 OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING,
 BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF
 THE LIBRARY IS WITH YOU.  SHOULD THE LIBRARY PROVE
 DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY
 SERVICING, REPAIR OR CORRECTION.

The sample programs (everything in the Samples folder) are public domain.  Do whatever you like with them.


Installation
=====================
Copy WinX.dec to your XBlite include folder; WinX.lib to your XBlite lib folder; and WinX.dll to your XBlite programs folder and your windows system folder (usually windows\system32 on NT based systems).

Winx requires my ADT library, download and install it.

Make sure to copy over the winx.xxx template file.

Compiling
=====================
The WinX source code defines some constants which may be missing from your headers.  If you get duplicate definition errors just comment the duplicates out.

WinX uses m4 macros, so make sure to enable macro processing before compiling.

Change Log
=====================
0.6.0.1
	Bug Fixes:
		- Bug in WinXDrawImage which miscalculated update region
0.6
	Bug Fixes:
		- Major changes to the internal implementation of AutoDraw eliminating serious crashing bugs
		- Removal of bugs preventing multiple windows
		- Fixed WinXDraw_GetImageInfo (it didn't work at all)
		- Changes to AutoDraw and AutoSizer to reduce flicker
		- numerous other bug fixes
	New Features
		- Splitter docking
		- Clipboard
		- Registry access
		- Increased window customisation, set background colour, cursor, font (for some controls)
		- New dialog boxes: message, question
		- New ListView and TreeView functions
	New Controls:
		- Calendar
		- Date/Time Picker
	Functions with new parameters:
		WinXNewWindow
		WinXMakeMenu (also renamed to WinXNewMenu)
	Renamed Functions:
		The renames are intended to make the WinX API more logical and consistent
		Hopefully this will be the last time I need to do a large scale rename
		---------------------------------------------------
		Old Name		New Name
		---------------------------------------------------
		WinXSetControlText	WinXSetText
		WinXGetControlText$	WinXGetText$
		WinXSetAutosizerInfo	WinXAutoSizer_SetInfo
		WinXMakeMenu		WinXNewMenu
		WinXAttachSubMenu	WinXMenu_Attach
		WinXMakeToolbar		WinXNewToolbar
		WinXMakeToolbarUsingIls	WinXNewToolbarUsingIls
		WinXOpenFile$		WinXDialog_OpenFile$
		WinXSaveFile$		WinXDialog_SaveFile$
		WinXMakeAutoSizerSeries	WinXNewAutoSizerSeries
		WinXErrorBox		WinXDialog_Error
		WinXSetSimpleSizerInfo	WinXAutoSizer_SetSimpleInfo
		WinXPixelsPerPoint	WinXDraw_PixelsPerPoint
		WinXLogUnitsPerPoint	WinXPrint_LogUnitsPerPoint
		WinXDevUnitsPerInch	WinXPrint_DevUnitsPerInch
		WinXGetMainSeries	WinXAutoSizer_GetMainSeries
	New Functions:
		WinXNewChildWindow (hParent, STRING title, style, exStyle, id)
		WinXRegOnFocusChange (hWnd, FUNCADDR onFocusChange)
		WinXSetWindowColour (hWnd, colour)
		WinXListView_GetItemText (hLV, iItem, cSubItems, @text$[])
		WinXDialog_Message (hWnd, text$, title$, iIcon, hMod)
		WinXDialog_Question (hWnd, text$, title$, cancel, defaultButton)
		WinXSplitter_SetProperties (series, hCtrl, min, max, dock)
		WinXRegistry_ReadInt (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result)
		WinXRegistry_ReadString (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
		WinXRegistry_ReadBin (hKey, subKey$, value$, createOnOpenFail, SECURITY_ATTRIBUTES sa, @result$)
		WinXRegistry_WriteInt (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, int)
		WinXRegistry_WriteString (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, buffer$)
		WinXRegistry_WriteBin (hKey, subKey$, value$, SECURITY_ATTRIBUTES sa, buffer$)
		WinXAddAccelerator (ACCEL @accel[], cmd, key, control, alt, shift)
		WinXSplitter_GetPos (series, hCtrl, @position, @docked)
		WinXSplitter_SetPos (series, hCtrl, position, docked)
		WinXClip_IsString ()
		WinXClip_PutString (Stri$)
		WinXClip_GetString$ ()
		WinXRegOnClipChange (hWnd, FUNCADDR onClipChange)
		SECURITY_ATTRIBUTES WinXNewACL (ssd$, inherit)
		WinXSetCursor (hWnd, hCursor)
		WinXScroll_GetPos (hWnd, direction, @pos)
		WinXScroll_SetPos (hWnd, direction, pos)
		WinXRegOnItem (hWnd, FUNCADDR onItem)
		WinXRegOnColumnClick (hWnd, FUNCADDR onColumnClick)
		WinXRegOnEnterLeave (hWnd, FUNCADDR onEnterLeave)
		WinXListView_GetItemFromPoint (hLV, x, y)
		WinXListView_Sort (hLV, iCol, desc)
		WinXTreeView_GetItemFromPoint (hTV, x, y)
		WinXGetPlacement (hWnd, @minMax, RECT @restored)
		WinXSetPlacement (hWnd, minMax, RECT restored)
		WinXGetMousePos (hWnd, @x, @y)
		WinXAddCalendar (hParent, @monthsX, @monthsY, id)
		WinXCalendar_SetSelection (hCal, SYSTEMTIME time)
		WinXCalendar_GetSelection (hCal, SYSTEMTIME @time)
		WinXRegOnCalendarSelect (hWnd, FUNCADDR onCalendarSelect)
		WinXAddTimePicker (hParent, format, SYSTEMTIME initialTime, timeValid, id)
		WinXTimePicker_SetTime (hDTP, SYSTEMTIME time, timeValid)
		WinXTimePicker_GetTime (hDTP, SYSTEMTIME @time, @timeValid)
		WinXSetFont (hCtrl, hFont)
		WinXClip_IsImage ()
		WinXClip_GetImage ()
		WinXClip_PutImage (hImage)
		WinXRegOnDropFiles (hWnd, FUNCADDR onDrag)
		WinXDraw_GetFontHeight (hFont, @ascent, @descenct)
0.5.0.1
	Bug Fixes:
	 - WinXOpenFile$ and WinXSaveFile$, fixed the initial filename parameter
0.5
	New Functions:
	 - WinXDraw_MakeLogFont		Font and text management
	 - WinXDraw_GetFontDialog
	 - WinXDraw_GetTextWidth
	 - WinXPixelsPerPoint
	 - WinXDrawText
	 - WinXDraw_GetColour		Colour dialog
	 - WinXDraw_CreateImage		Image support
	 - WinXDraw_LoadImage
	 - WinXDraw_DeleteImage
	 - WinXDraw_Snapshot
	 - WinXDraw_SaveImage
	 - WinXDraw_ResizeImage
	 - WinXDraw_SetImagePixel
	 - WinXDraw_GetImagePixel
	 - WinXDraw_SetConstantAlpha
	 - WinXDraw_SetImageChannel
	 - WinXDraw_GetImageChannel
	 - WinXDraw_GetImageInfo
	 - WinXDraw_CopyImage
	 - WinXDraw_PremultiplyImage
	 - WinXDrawImage
	 - WinXPrint_Start		Printing support
	 - WinXLogUnitsPerPoint
	 - WinXDevUnitsPerInch
	 - WinXPrint_PageSetup
	 - WinXPrint_Page
	 - WinXPrint_Done

	Bug Fixes
	 - WinXSaveFile$ didn't append default extension


0.4.2	New Controls:
	 - WinX Splitter		Splitter controls that works with Auto Sizer
	 - List View			List View support (no dragging yet)

	New Functions:
	 - WinXDrawEllipse		New Auto Draw functions
	 - WinXDrawRect
	 - WinXDrawBezier
	 - WinXDrawArc
	 - WinXDrawFilledArea
	 - WinXRegOnClose		Callback to trap window close event
	 - WinXSetSimpleSizerInfo	Simplified Auto Sizer registration
	 - WinXAddListView		List View support functions
	 - WinXListView_SetView
	 - WinXListView_AddColumn
	 - WinXListView_DeleteColumn
	 - WinXListView_AddItem
	 - WinXListView_DeleteItem
	 - WinXListView_GetSelection
	 - WinXListView_SetSelection
	 - WinXListView_SetItemText

	Changed Functions:
	 - WinXSetAutosizerInfo		Now supports reverse series (right to left)

	Bug Fixes:
	 - Scroll Bars not updating under Win2K and WinXP with classic skin
	 - Direct LBItemFromPt calls removed
	 - Fixed WinXOpenFile$ multiselect bugs
	 - Possibly others

0.6.0.4-Guy-10sep08
	New Functions:
	 - WinXVersion$: retrieve WinX's current version
	 - WinXDialog_OpenDir$: standard Windows directory picker dialog
	 - WinXFolder_GetDir$ : get the directory path for a Windows special folder
	 - WinXListView_AddCheckBoxes : add the check boxes to a list view
	 - WinXListView_SetCheckState : set the item's check state of a list view with check boxes
	 - WinXListView_GetCheckState : determine whether an item in a list view control is checked
	 - WinXListView_RemoveCheckBox: remove the check box
	 - WinXTreeView_AddCheckBoxes : add the check boxes to a tree view
	 - WinXTreeView_SetCheckState : set the item's check state of a tree view with check boxes
	 - WinXTreeView_GetCheckState : determine whether a node in a tree view control is checked
	 - WinXTreeView_RemoveCheckBox: remove the check box
	 - WinXTreeView_GetRootItem   : get the handle of the tree view root
	 - WinXTreeView_FindItemLabel : find an exact string in tree labels
	 - WinXTreeView_DeleteAllItems: clear the tree view
	 - WinXTreeView_ExpandItem    : expand a tree view item (Guy-26jan09)
	 - WinXTreeView_CollapseItem  : collapse a tree view item

0.6.0.5-Guy-9dec08
	New Functions:
' - WinXDialog_SysInfo       : run Microsoft program "System Information"
' - WinXCleanUp              : optional cleanup

0.6.0.6-Guy-21jan09
	New Functions:
' - WinXAddAcceleratorTable  : create an accelerator table
' - WinXAttachAccelerators   : attach an accelerator table to a window

0.6.0.7-Guy-21jan09
' - changed WinXDoEvents to handle several accelerator tables.
' - removed argument from WinXDoEvents ()

0.6.0.15 New Functions:
	New Functions:
	 - WinXComboBox_RemoveAllItems : remove all items from extended combo box

	 - WinXDate_GetCurrentTimeStamp$ ()  : compute a (date & time) stamp

	 - WinXDir_AppendSlash (@dir$)  : end directory path dir$ with $$PathSlash$
	 - WinXDir_ClipEndSlash (@dir$)  : remove the trailing \ from directory path
	 - WinXDir_Create (dir$)  : create directory dir$
	 - WinXDir_Exists (dir$)  : determine if directory dir$ exists
	 - WinXDir_GetXBasicDir$ ()  : get the complete path of XBasic's directory
	 - WinXDir_GetXblDir$ ()  : get the complete path of XBLite's directory
	 - WinXDir_GetXblProgramDir$ ()  : get xblite's program dir

	 - WinXDisplayHelpFile (helpFile$)  : display the contents of helpFile$

	 - WinXGetMinSize (hWnd, @w, @h)

	 - WinXIni_Delete (iniPath$, section$, key$)  : delete information from an .INI file
	 - WinXIni_DeleteSection (iniPath$, section$)  : delete section from .INI file
	 - WinXIni_LoadKeyList (iniPath$, section$, @key$[])  : load all key names of a given section
	 - WinXIni_LoadSectionList (iniPath$, @section$[])  : load all section names
	 - WinXIni_Read$ (iniPath$, section$, key$, defVal$)  : read data from .INI file
	 - WinXIni_Write (iniPath$, section$, key$, value$)  : write in the .INI file

	 - WinXKillFont (@hFont)  : release a font created by WinXNewFont

	 - WinXListBox_Find (hListBox, match$) : find exact match
	 - WinXListBox_GetIndex (hListBox, searchFor$) : get the index of a particular string
	 - WinXListBox_GetNextIndex (hListBox, searchFor$, indexFrom) : get next index of a particular string
	 - WinXListBox_RemoveAllItems : remove all items from a list box

	 - WinXListView_DeleteAllItems (hLV)
	 - WinXListView_FreezeOnSelect (hLV)
	 - WinXListView_UseOnSelect (hLV)
	 - WinXListView_GetHeaderHeight (hLV)
	 - WinXListView_SetAllChecked (hLV)
	 - WinXListView_SetAllSelected (hLV)
	 - WinXListView_SetAllUnchecked (hLV)
	 - WinXListView_SetAllUnselected (hLV)
	 - WinXListView_SetItemFocus (hLV, iItem, iSubItem)  : set the focus on item

	 - WinXMRU_LoadListFromIni (iniPath$, pathNew$, @mruList$[])  : load the Most Recently Used file list from the .INI file
	 - WinXMRU_MakeKey$ (id)
	 - WinXMRU_SaveListToIni (iniPath$, pathNew$, @mruList$[])  : save the Most Recently Used file list into the .INI file

	 - WinXNewFont (fontName$, pointSize, weight, italic, underline, strikeOut)  : create a new logical font

	 - WinXPath_Create (path$) : make sure the file is created
	 - WinXPath_Trim$ (path$)  : trim file path path$

	 - WinXSetDefaultFont (hCtr)  : use the default GUI font
	 - WinXSetFont (hCtr, hFont)
	 - WinXSetFontAndRedraw (hCtr, hFont)

	 - WinXTreeView_GetChildCount (hTV, hItem)
     GL-31jan15-$$WM_SETREDRAW gives odd results on a tree view
	 - WinXTreeView_FreezeOnSelect (hTV)
	 - WinXTreeView_UseOnSelect (hTV)
