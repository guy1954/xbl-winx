'
' ####################
' #####  PROLOG  #####
' ####################
'
' Demonstrates progress bars and trackbars, in what is a rather silly scenario
' also includes tooltips
'
' This program is public domain
'
VERSION	"1.00"
'
	IMPORT	"xst"   		' standard library	: required by most programs
'	IMPORT  "xsx"				' extended std library
'	IMPORT	"xio"				' console io library
	IMPORT	"gdi32"     ' gdi32.dll
	IMPORT  "user32"    ' user32.dll
	IMPORT  "kernel32"  ' kernel32.dll
	IMPORT  "comctl32"	' comctl32.dll			: common controls library
'	IMPORT	"comdlg32"  ' comdlg32.dll	    : common dialog library
'	IMPORT	"xma"   		' math library			: Sin/Asin/Sinh/Asinh/Log/Exp/Sqrt...
'	IMPORT	"xcm"				' complex math library
'	IMPORT  "msvcrt"		' msvcrt.dll				: C function library
'	IMPORT  "shell32"   ' shell32.dll
	IMPORT	"WinX"			' The Xwin GUI library
	
$$ID_PROG				= 100
$$ID_OPERATION	= 101
$$ID_MARQUEE		= 102
$$OP_TIMER			= 103
$$ID_TRACKER		= 104
'
DECLARE FUNCTION Entry ()
DECLARE FUNCTION initApp ()
DECLARE FUNCTION initWindow ()
DECLARE FUNCTION onCommand (id, code, hWnd)
DECLARE FUNCTION onTimer (hWnd, uMsg, idEvent, dwTime)
DECLARE FUNCTION onTrackerPos (id, pos)
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
  IF initApp () THEN QUIT(0)
	IF initWindow () THEN QUIT(0)
	
	WinXDoEvents (0)

END FUNCTION
'
' #####################
' #####  initApp  #####
' #####################
' 
'
'
FUNCTION initApp ()
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
' #####  initWindow  #####
' ########################
'
'
'
FUNCTION initWindow ()

	'create the main window
	#hMain = WinXNewWindow (0, "Progress bar demonstration", -1, -1, 400, 300, $$XWSS_APP, 0, 0, 0)
	
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
	
	WinXRegOnCommand (#hMain, &onCommand())
	WinXDisplay (#hMain)
	
	RETURN 0
END FUNCTION
'
' #######################
' #####  onCommand  #####
' #######################
'
'
'
FUNCTION onCommand (id, code, hWnd)
	SHARED operation
	SHARED marquee
	SHARED pos
	
	SELECT CASE id
		'insert cases for your ids here.
		CASE $$ID_OPERATION
			IF marquee THEN onCommand ($$ID_MARQUEE, $$BN_CLICKED, #hMain)
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
				#hTimer = SetTimer (0, 0, 30, &onTimer())
				EnableWindow (GetDlgItem (#hMain, $$ID_TRACKER), $$FALSE)
				WinXSetText (GetDlgItem (#hMain, $$ID_OPERATION), "Stop lengthy operation")
				operation = $$TRUE
			END IF
		CASE $$ID_MARQUEE
			IF operation THEN onCommand ($$ID_OPERATION, $$BN_CLICKED, #hMain)
			IF marquee THEN 
				'switch out of marquee mode
				hProg = GetDlgItem (#hMain, $$ID_PROG)
				WinXProgress_SetMarquee (hProg, $$FALSE)
				'redraw the progress bar
				WinXUpdate (hProg)
				WinXSetText (GetDlgItem (#hMain, $$ID_MARQUEE), "Start Marquee")
				marquee = $$FALSE
			ELSE
				WinXProgress_SetMarquee (GetDlgItem (#hMain, $$ID_PROG), $$TRUE)
				WinXSetText (GetDlgItem (#hMain, $$ID_MARQUEE), "Stop Marquee")
				marquee = $$TRUE
			END IF 
	END SELECT
	
END FUNCTION
'
' #####################
' #####  onTimer  #####
' #####################
'
'
'
FUNCTION onTimer (hWnd, uMsg, idEvent, dwTime)
	SHARED pos
	
	INC pos
	IF pos > 100 THEN
		'simulate an event to make to stop the timer
		onCommand ($$ID_OPERATION, $$BN_CLICKED, #hMain)
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