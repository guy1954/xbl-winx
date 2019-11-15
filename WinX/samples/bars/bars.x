'
'
' ####################
' #####  PROLOG  #####
' ####################
'
PROGRAM "bars"
VERSION "1.00"
'
' Demonstrates progress bars and trackbars, in what is a rather silly scenario
' also includes tooltips
'
' This program is public domain
'
' XBLite headers
'
	IMPORT "xst"		' XBLite Standard Library
	IMPORT "xsx"		' XBLite Standard eXtended Library
'	IMPORT "xio"		' console library
	IMPORT "WinX"		' Callum Lowcay's Windows GUI library
'
' WinAPI DLL headers
'
	IMPORT "kernel32"			' Operating System
'
' ---Note: import gdi32 BEFORE shell32 and user32
	IMPORT "gdi32"				' Graphic Device Interface
	IMPORT "shell32"			' interface to Operating System
	IMPORT "user32"				' Windows management
	IMPORT "comctl32"			' Common controls; ==> initialize w/ InitCommonControlsEx ()
'
DECLARE FUNCTION Entry () ' program entry point
DECLARE FUNCTION StartUp () ' program setup
DECLARE FUNCTION CreateWindows () ' create the windows of the program
DECLARE FUNCTION Main_onCommand (id, code, hWnd) ' handles message WM_COMMAND
DECLARE FUNCTION Main_onTimer (hWnd, uMsg, idEvent, dwTime)
DECLARE FUNCTION onTrackerPos (id, pos)
'
$$ID_PROG				= 100
$$ID_OPERATION	= 101
$$ID_MARQUEE		= 102
$$OP_TIMER			= 103
$$ID_TRACKER		= 104
'
'
' ######################
' #####  Entry ()  #####
' ######################
'
FUNCTION Entry ()
	'make sure WinX is properly initialised
	IF WinX() THEN QUIT(0)

	'quit if either of these fail
  IF StartUp () THEN QUIT(0)
	IF CreateWindows () THEN QUIT(0)

	WinXDoEvents (0)

END FUNCTION
'
' #####################
' #####  StartUp  #####
' #####################
'
'
'
FUNCTION StartUp ()
	SHARED operation
	SHARED marquee
	SHARED pos

	'initialise some info concerning the progress bar
	operation = $$FALSE
	marquee = $$FALSE
	pos = 0

	RETURN 0
END FUNCTION
'
' ########################
' #####  CreateWindows  #####
' ########################
'
'
'
FUNCTION CreateWindows ()

	'create the main window
	#hMain = WinXNewWindow (0, "Progress bar demonstration " + WinXVersion$ (), -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)

	'add the controls
	WinXAutoSizer_SetInfo (WinXAddProgressBar (#hMain, $$FALSE, $$ID_PROG), WinXAutoSizer_GetMainSeries (#hMain), 0, 25, 0, 0, 1, 1, 0)
	WinXAutoSizer_SetInfo (WinXAddButton (#hMain, "Start lengthy operation", 0, $$ID_OPERATION), WinXAutoSizer_GetMainSeries (#hMain), 0, 25, 0, 0, 1, 1, 0)
	WinXAutoSizer_SetInfo (WinXAddButton (#hMain, "Start Marquee", 0, $$ID_MARQUEE), WinXAutoSizer_GetMainSeries (#hMain), 0, 25, 0, 0, 1, 1, 0)
	WinXAutoSizer_SetInfo (WinXAddTrackBar (#hMain, $$FALSE, $$TRUE, $$ID_TRACKER), WinXAutoSizer_GetMainSeries (#hMain), 8, 30, -1, 0, 60, 1, $$SIZER_WCOMPLEMENT)

	'configure the tracker
	hTracker = GetDlgItem (#hMain, $$ID_TRACKER)
	WinXTracker_SetRange (hTracker, 0, 100, 5)
	WinXTracker_SetLabels (hTracker, "less", "more")
	WinXRegOnTrackerPos (#hMain, &onTrackerPos())
	WinXAddTooltip (hTracker, "A tracker")

	'add tooltips to the rest of the controls
	WinXAddTooltip (GetDlgItem (#hMain, $$ID_PROG), "The progress bar")
	WinXAddTooltip (GetDlgItem (#hMain, $$ID_OPERATION), "Start/stop the progress bar")
	WinXAddTooltip (GetDlgItem (#hMain, $$ID_MARQUEE), "Run the progress bar in marquee mode (requires Windows XP and manifest)")

	WinXRegOnCommand (#hMain, &Main_onCommand())
	WinXDisplay (#hMain)

	RETURN 0
END FUNCTION
'
' ############################
' #####  Main_onCommand  #####
' ############################
'
'
'
FUNCTION Main_onCommand (id, code, hWnd)
	SHARED operation
	SHARED marquee
	SHARED pos

	SELECT CASE id
		'insert cases for your ids here.
		CASE $$ID_OPERATION
			IF marquee THEN Main_onCommand ($$ID_MARQUEE, $$BN_CLICKED, #hMain)
			IF operation THEN
				'stop the operation
				pos = 0
				KillTimer (0, #hTimer)
				'reset the tracker
				WinXTracker_SetPos (GetDlgItem (#hMain, $$ID_TRACKER), 0)
				EnableWindow (GetDlgItem (#hMain, $$ID_TRACKER), $$TRUE)
				'reset the progress bar
				WinXProgress_SetPos (GetDlgItem (#hMain, $$ID_PROG), 0)
				WinXSetText (GetDlgItem (#hMain, $$ID_OPERATION), "Start lengthy operation")
				operation = $$FALSE
			ELSE
				'start the operation
				'notice how standard Win32 timers are used with WinX
				#hTimer = SetTimer (0, 0, 30, &Main_onTimer())
				EnableWindow (GetDlgItem (#hMain, $$ID_TRACKER), $$FALSE)
				WinXSetText (GetDlgItem (#hMain, $$ID_OPERATION), "Stop lengthy operation")
				operation = $$TRUE
			END IF
		CASE $$ID_MARQUEE
			IF operation THEN Main_onCommand ($$ID_OPERATION, $$BN_CLICKED, #hMain)
			'
			'toggle marquee mode
			marquee = NOT marquee
			'
			'redraw the progress bar
			hProg = GetDlgItem (#hMain, $$ID_PROG)
			WinXProgress_SetMarquee (hProg, marquee)
			WinXUpdate (hProg)
			'
			IF marquee THEN text$ = "Stop" ELSE text$ = "Start Marquee"
			WinXSetText (GetDlgItem (#hMain, $$ID_MARQUEE), text$)
	END SELECT

END FUNCTION
'
' #####################
' #####  Main_onTimer  #####
' #####################
'
'
'
FUNCTION Main_onTimer (hWnd, uMsg, idEvent, dwTime)
	SHARED pos

	INC pos
	IF pos > 100 THEN
		'simulate an event to make to stop the timer
		Main_onCommand ($$ID_OPERATION, $$BN_CLICKED, #hMain)
	ELSE
		WinXProgress_SetPos (GetDlgItem (#hMain, $$ID_PROG), DOUBLE(pos)/100.0)
		WinXTracker_SetPos (GetDlgItem (#hMain, $$ID_TRACKER), pos)
	END IF
END FUNCTION
'
' ##########################
' #####  onTrackerPos  #####
' ##########################
'
'
'
FUNCTION onTrackerPos (id, pos)
	SHARED operation
	SHARED marquee

	IFF (operation || marquee) THEN WinXProgress_SetPos (GetDlgItem (#hMain, $$ID_PROG), pos/100.0)
END FUNCTION
END PROGRAM
