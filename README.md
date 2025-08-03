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
Contributors:
    Callum Lowcay (original version 0.6.0.1 circa 2007)
    Guy "GL" Lonne (evolutions)

0.6.0.1-Callum Lowcay-2007-Original version.

0.6.0.2-Guy-10sep08-Small changes.
- GL-10nov08-Corrected function WinXListBox_GetSelectionArray():
             replaced wMsg by $$LB_GETSELITEMS since wMsg was not set and would be zero.
- GL-28oct09-Forced hideReadOnly in WinXDialog_OpenFile$()
             and allow to open "Read Only" (no lock) the selected file(s):
             ofn.flags = ofn.flags OR $$OFN_READONLY		show the checkbox "Read Only" (initially checked)
- GL-28oct09-Added GUI accelerators.

0.6.0.3-Guy-10nov08-Small changes.
- Corrected function WinXListBox_GetSelectionArray.
- Replaced wMsg by $$LB_GETSELITEMS since wMsg was not set and would be zero.
- Added the new functions.

Accelerators
- WinXAddAcceleratorTable: create an accelerator table
- WinXAttachAccelerator  : attach accelerator table to window

0.6.0.3-Guy-10sep08-Added new functions.
- WinXMakeFilterString$: make a filter string
- WinXVersion$         : retrieve WinX current version
- WinXKillFont         : release a logical font

0.6.0.4-Guy-09apr24-Compile WinX.x is now "stand-alone".
- GL removed any dependencies on:
    . M4 code snippets
    . xma.dll
    . adt.dll

0.6.0.5-Guy-27oct24-Added 5 new functions.
-  WinXCtr_Adjust_size					: resize the control to reflect its windows new width and height
-  WinXCtr_Adjust_width				: change the controls width to reflect its windows new width
-  WinXCtr_Adjust_height				: change the controls height to reflect its windows new height
-  WinXCtr_Slide_left_or_right	: slide left or right the control
-  WinXCtr_Slide_up_or_down		: slide up or down the control
Corrected WinXNewToolbar() and WinXAddStatic().

0.6.0.5-Guy-03aug25-Code tightening.
