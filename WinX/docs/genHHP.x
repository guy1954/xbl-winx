'
' ####################
' #####  PROLOG  #####
' ####################
'
' A program to generate the HTML help project and contents files
'
VERSION "0.0001"
CONSOLE
'
	IMPORT "xst"				' Standard library : required by most programs
	IMPORT "xsx"				' Extended standard library
'	IMPORT "xio"				' Console input/ouput library

'	IMPORT "xst_s.lib"
' IMPORT "xsx_s.lib"
' IMPORT "xio_s.lib"

' IMPORT "gdi32"			' gdi32.dll
'	IMPORT "user32"		  ' user32.dll
'	IMPORT "kernel32"	  ' kernel32.dll
'	IMPORT "shell32"		' shell32.dll
'	IMPORT "msvcrt"		  ' msvcrt.dll

'
DECLARE FUNCTION Entry ()
DECLARE FUNCTION getFiles$ (folder$, indents)
DECLARE FUNCTION sortArray (@array$[])
DECLARE FUNCTION comesBefore (String1$, String2$)
DECLARE FUNCTION makeObj$ (name$, local$, indent)
DECLARE FUNCTION getName$ (folder$, file$)
DECLARE FUNCTION makeIndexObj$ (name$, local$, indent)
'
'
' ######################
' #####  Entry ()  #####
' ######################
'
FUNCTION Entry ()
	SHARED tocFile
	SHARED indexFile
	
	'open the config file
	fileNum = OPEN ("genHHPrt.txt", mode)
	
	IF fileNum = -1 THEN
		PRINT "Couldn't find genHHPrt.txt"
		QUIT(0)
	END IF
	
	'read the data
	title$ = INFILE$ (fileNum)
	DIM folders$[31]
	numFolders = 0
	DO WHILE !EOF(fileNum)
		IF numFolders < UBOUND(folders$[]) THEN REDIM folders$[((UBOUND(folders$[])+1)<<1)-1]
		folders$[numFolders] = INFILE$ (fileNum)
		INC numFolders
	LOOP
	
	CLOSE(fileNum)
	
	'open the out files
	fileNum = OPEN (title$+"Help.hhp", $$WRNEW)
	tocFile = OPEN (title$+"Help.hhc", $$WRNEW)
	indexFile = OPEN (title$+"Help.hhk", $$WRNEW)
	
	'initialise the toc
	PRINT[tocFile], "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML//EN\">\r"
	PRINT[tocFile], "<HTML>\r"
	PRINT[tocFile], "<HEAD>\r"
	PRINT[tocFile], "<meta name=\"GENERATOR\" content=\"genHHP\">\r"
	PRINT[tocFile], "<!-- Sitemap 1.0 -->\r"
	PRINT[tocFile], "</HEAD><BODY>\r"
	PRINT[tocFile], "<UL>\r"
	
	'and the index
	PRINT[indexFile], "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML//EN\">\r"
	PRINT[indexFile], "<HTML>\r"
	PRINT[indexFile], "<HEAD>\r"
	PRINT[indexFile], "<meta name=\"GENERATOR\" content=\"genHHP\">\r"
	PRINT[indexFile], "<!-- Sitemap 1.0 -->\r"
	PRINT[indexFile], "</HEAD><BODY>\r"
	PRINT[indexFile], "<UL>\r"
	
	'generate the options
	XstGetFileAttributes (folders$[0], @attributes)
	IF attributes AND (NOT $$FileDirectory) THEN
		defTopic$ = folders$[0]
	ELSE
		defTopicFile = OPEN (folders$[0]+"\\genHHPtopic.txt", $$RD)
			defTopic$ = folders$[0]+"/"+INFILE$(defTopicFile)
		CLOSE(defTopicFile)
	END IF
	
	PRINT[fileNum], "[OPTIONS]\r"
	PRINT[fileNum], "Compatibility=1.1 or later\r"
	PRINT[fileNum], "Compiled file="+title$+"Help.chm\r"
	PRINT[fileNum], "Contents file="+title$+"Help.hhc\r"
	PRINT[fileNum], "Default topic="+defTopic$+"\r"
	PRINT[fileNum], "Display compile progress=Yes\r"
	PRINT[fileNum], "Full-text search=Yes\r"
	PRINT[fileNum], "Index file="+title$+"Help.hhk\r"
	PRINT[fileNum], "Language=0x1409 English (New Zealand)\r"
	PRINT[fileNum], "Title="+title$+" Help\r\n\r\n\r"
	
	'dump the files
	PRINT[fileNum], "[FILES]\r"
	FOR i = 0 TO (numFolders-1)
		PRINT[fileNum], getFiles$(folders$[i], 1);
	NEXT
	
	PRINT[tocFile], "</UL>\r\n\r\n</BODY></HTML>\r"
	PRINT[indexFile], "</UL>\r\n\r\n</BODY></HTML>\r"
	
	CLOSE(tocFile)
	CLOSE(fileNum)
	CLOSE(indexFile)

END FUNCTION
'
' ######################
' #####  getFiles  #####
' ######################
'
'
'
FUNCTION getFiles$ (folder$, indents)
	SHARED tocFile
	SHARED indexFile
	FILEINFO info[]
	
	PRINT folder$
	
	'output the files
	indent$ = SPACE$(indents)
	FOR i = 0 TO UBOUND(indent$)
		indent${i} = '\t'
	NEXT
	
	XstGetFileAttributes (folder$, @attributes)
	IF attributes AND (NOT $$FileDirectory) THEN
		'this is just a single item
		PRINT[tocFile], makeObj$ (getName$ ("", folder$), folder$, indents)
		RETURN folder$+"\r\n"
	END IF
	
	XstGetFilesAndAttributes (folder$+"\\*.htm", 0xFFFFFFFF, @raw$[], @info[])
	
	DIM files$[UBOUND(raw$[])]
	DIM dirs$[UBOUND(raw$[])]

	'sperate the dirs from the folders
	dirCount = 0
	fileCount = 0
	FOR i = 0 TO UBOUND(raw$[])
		IF (info[i].attributes AND $$FileDirectory) THEN
			dirs$[dirCount] = raw$[i]
			INC dirCount
		ELSE
			files$[fileCount] = raw$[i]
			INC fileCount
		END IF
	NEXT
	
	'the top object
	fileNum = OPEN (folder$+"\\genHHPtopic.txt", $$RD)
	bookFile$ = INFILE$(fileNum)
	name$ = folder$
	last = RINSTR (name$, ".")
	IF last THEN name$ = MID$(name$, 1, last-1)
	last = RINSTR (name$, "\\")
	IF last THEN name$ = MID$(name$, last+1)
	
	PRINT[tocFile], makeObj$ (name$, folder$+"/"+bookFile$, indents)
	CLOSE(fileNum)
	
	'recurse on each folder
	
	FOR i = 0 TO (dirCount-1)
		PRINT[tocFile], indent$;+"<UL>\r"
		ret$ = ret$ + getFiles$ (folder$+"\\"+dirs$[i], indents+1)
		PRINT[tocFile], indent$;+"</UL>\r"
	NEXT
	
	PRINT[tocFile], indent$;"<UL>\r"
	
	FOR i = 0 TO (fileCount-1)
		IF files$[i] != bookFile$ THEN 
			PRINT[tocFile], makeObj$ (getName$ (folder$, files$[i]), folder$+"/"+files$[i], indents+1)
			PRINT[indexFile], makeIndexObj$ (getName$ (folder$, files$[i]), folder$+"/"+files$[i], 1)
			ret$ = ret$+folder$+"\\"+files$[i]+"\r\n"
		END IF
	NEXT
	PRINT[tocFile], indent$;"</UL>\r"
	
	RETURN ret$
	
END FUNCTION
'
' #######################
' #####  sortArray  #####
' #######################
'
'
'
FUNCTION sortArray (array$[])

	done = $$FALSE
	DO WHILE !done
		done = $$TRUE
		FOR i = 1 TO UBOUND(array$[])
			IF comesBefore(array$[i], array$[i-1]) THEN
				SWAP array$[i], array$[i-1]
				done = $$FALSE
			END IF
		NEXT
	LOOP

END FUNCTION
'
' #########################
' #####  comesBefore  #####
' #########################
' returns $$TRUE if String1$ comes before String2$
'
'
FUNCTION comesBefore (String1$, String2$)
	String1$ = UCASE$(String1$)
	String2$ = UCASE$(String2$)
	
	FOR i = 0 TO MIN(UBOUND(String1$), UBOUND(String2$))
		IF String1${i} > String2${i} THEN RETURN $$FALSE
		IF String1${i} < String2${i} THEN RETURN $$TRUE
	NEXT
	
	IF UBOUND(String1$) < UBOUND(String2$) THEN RETURN $$TRUE ELSE RETURN $$FALSE
END FUNCTION
'
' ######################
' #####  makeObj$  #####
' ######################
'
'
'
FUNCTION makeObj$ (name$, local$, indent)
	indent$ = SPACE$(indent)
	FOR i = 0 TO UBOUND(indent$)
		indent${i} = '\t'
	NEXT
	
	ret$ = indent$+"<LI> <OBJECT type=\"text/sitemap\">\r\n"
	
	ret$ = ret$+indent$+"\t<param name=\"Name\" value=\""+name$+"\">\r\n"
	ret$ = ret$+indent$+"\t<param name=\"Local\" value=\""+local$+"\">\r\n"
	ret$ = ret$+indent$+"\t</OBJECT>"
	
	RETURN ret$
	
END FUNCTION
'
' #####################
' #####  getName  #####
' #####################
'
'
'
FUNCTION getName$ (folder$, file$)
	IF folder$ = "" THEN fileName$ = file$ ELSE fileName$ = folder$+"\\"+file$
	htmlFile = OPEN (fileName$, $$RD)
	IF htmlFile = -1 THEN RETURN ""
	name$ = file$
	DO WHILE !EOF(htmlFile)
		line$ = INFILE$ (htmlFile)
		pos = INSTRI (line$, "<title>")
		IF pos > 0 THEN
			name$ = MID$(line$, pos+7, INSTRI (line$, "</title>", pos)-pos-7)
			EXIT DO
		END IF
	LOOP
	CLOSE(htmlFile)
	
	RETURN name$
END FUNCTION
'
' ###########################
' #####  makeIndexObj$  #####
' ###########################
'
'
'
FUNCTION makeIndexObj$ (name$, local$, indent)
	indent$ = SPACE$(indent)
	FOR i = 0 TO UBOUND(indent$)
		indent${i} = '\t'
	NEXT
	
	ret$ = indent$+"<LI> <OBJECT type=\"text/sitemap\">\r\n"
	
	ret$ = ret$+indent$+"\t<param name=\"Name\" value=\""+name$+"\">\r\n"
	ret$ = ret$+indent$+"\t<param name=\"Name\" value=\""+name$+"\">\r\n"
	ret$ = ret$+indent$+"\t<param name=\"Local\" value=\""+local$+"\">\r\n"
	ret$ = ret$+indent$+"\t</OBJECT>"
	
	RETURN ret$
END FUNCTION






















END PROGRAM