m4_define(`DeclareAccess',`''
' === $1 class ===
'
DECLARE FUNCTION $1_Init () ' initialize the $1 class
DECLARE FUNCTION $1_Delete (id) ' delete a $1 item accessed by its id
DECLARE FUNCTION $1_Get (id`,' $1 @$1_item) ' get data of a $1 item accessed by its id
DECLARE FUNCTION $1_Get_count () ' get $1 item count
DECLARE FUNCTION $1_Get_idMax () ' get $1 item id max
DECLARE FUNCTION $1_Get_idMin () ' get $1 item id min
DECLARE FUNCTION $1_New ($1 $1_item) ' add $1 item to $1 pool
DECLARE FUNCTION $1_Update (id`,' $1 $1_item) ' update data of a $1 item accessed by its id)

m4_define(`DefineAccess',`''
' === $1 class ===
'
' Initializes the $1 class
'
FUNCTION $1_Init ()
	SHARED $1 $1_array[] ' an array of $1 items
	SHARED $1_arrayUM[] ' usage map so we can see which $1_array[] elements are in use
	SHARED $1_idMax     ' last id
	SHARED $1_idMin

	$1_idMax = 0
	$1_idMin = 0
	IFZ $1_array[] THEN
		upper_slot = 7
		DIM $1_array[upper_slot]
		DIM $1_arrayUM[upper_slot]
	ELSE
		' reset an existing $1_array[]
		upper_slot = UBOUND ($1_arrayUM[])
		FOR slot = 0 TO upper_slot
			$1_arrayUM[slot] = $$FALSE		' logical deletion
		NEXT slot
	ENDIF
END FUNCTION
'
' Deletes a $1 item accessed by its id
' id = id of the $1 item to delete
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'bOK = $1_Delete (id)
'IFF bOK THEN XstAlert ("$1_Delete: Can't delete $1 item id " + STRING$ (id))
'
FUNCTION $1_Delete (id)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax
	SHARED $1_idMin

	bOK = $$FALSE
	SELECT CASE TRUE
		CASE (id < $1_idMin || id > $1_idMax)
		CASE ELSE
			slot = id - 1
			upper_slot = UBOUND ($1_arrayUM[])
			IF (slot < 0 || slot > upper_slot) THEN EXIT SELECT
			IFF $1_arrayUM[slot] THEN EXIT SELECT
			' 
			$1_arrayUM[slot] = $$FALSE		' mark $1 item as deleted
			IF id = $1_idMax THEN
				FOR z = upper_slot TO slot + 1 STEP -1
					IFF $1_arrayUM[z] THEN
						$1_idMax = z + 1
						EXIT FOR
					ENDIF
				NEXT z
			ENDIF
			IF id = $1_idMin THEN
				FOR z = slot + 1 TO upper_slot
					IFF $1_arrayUM[z] THEN
						$1_idMin = z + 1
						EXIT FOR
					ENDIF
				NEXT z
			ENDIF
			bOK = $$TRUE
	END SELECT
	RETURN bOK
END FUNCTION
'
' Gets data of a $1 item accessed by its id
' id = id of $1 item
' $1_item = returned data
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'bOK = $1_Get (id`,' @$1_item)
'IFF bOK THEN XstAlert ("$1_Get: Can't get $1 item id " + STRING$ (id))
'
FUNCTION $1_Get (id`,' $1 $1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax
	SHARED $1_idMin

	$1 $1_Nil

	bOK = $$FALSE
	SELECT CASE TRUE
		CASE (id < $1_idMin || id > $1_idMax)
		CASE ELSE
			slot = id - 1
			upper_slot = UBOUND ($1_arrayUM[])
			IF (slot < 0 || slot > upper_slot) THEN EXIT SELECT
			IFF $1_arrayUM[slot] THEN EXIT SELECT
			' 
			$1_item = $1_array[slot]		' get $1 item
			bOK = $$TRUE
	END SELECT
	IFF bOK THEN $1_item = $1_Nil		' Can't get $1 item
	RETURN bOK
END FUNCTION
'
' Gets $1 item count
'
FUNCTION $1_Get_count ()
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]

	count = 0
	IF $1_arrayUM[] THEN
		FOR slot = UBOUND ($1_arrayUM[]) TO 0 STEP -1
			IF $1_arrayUM[slot] THEN INC count
		NEXT slot
	ENDIF
	RETURN count
END FUNCTION
'
' Gets $1 item id max
'
' Usage: walk thru the $1 pool
'idMax = $1_Get_idMax () ' get $1 item id max
'FOR id = 1 TO idMax
'	bOK = $1_Get (id`,' @$1_item)
'	IFF bOK THEN DO NEXT		' deleted
'NEXT id
'
FUNCTION $1_Get_idMax ()
	SHARED $1_idMax
	RETURN $1_idMax
END FUNCTION
'
' Gets $1 item id min
'
FUNCTION $1_Get_idMin ()
	SHARED $1_idMin
	RETURN $1_idMin
END FUNCTION
'
' Adds a $1 item to $1 pool
' returns id on success or 0 on fail
'
' Usage:
'id = $1_New ($1_item)
'IFZ id THEN XstAlert ("$1_New: Can't add $1 item")
'
FUNCTION $1_New ($1 $1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax

	IFZ $1_arrayUM[] THEN $1_Init ()

	slot = -1
	upper_slot = UBOUND ($1_arrayUM[])

	' since $1_array[] is oversized
	' look for an empty spot after $1_idMax
	IF $1_idMax <= upper_slot THEN
		FOR i = $1_idMax TO upper_slot
			IFF $1_arrayUM[i] THEN
				' use this empty spot
				slot = i
				$1_idMax = i + 1
				EXIT FOR
			ENDIF
		NEXT i
	ENDIF

	IF slot = -1 THEN
		' empty spot not found => expand $1_array[]
		upper_slot = ((upper_slot + 1) * 2) - 1
		REDIM $1_array[upper_slot]
		REDIM $1_arrayUM[upper_slot]
		slot = $1_idMax
		INC $1_idMax
	ENDIF

	id = 0
	IF (slot >= 0) && (slot <= UBOUND ($1_arrayUM[])) THEN
		$1_array[slot] = $1_item
		$1_arrayUM[slot] = $$TRUE
		id = slot + 1
	ENDIF
	RETURN id
END FUNCTION
'
' Updates the data of a $1 item accessed by its id
' id = id of $1 item
' $1_item = new data
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'bOK = $1_Update (id`,' $1_item)
'IFF bOK THEN XstAlert ("$1_Update: Can't update $1 item id " + STRING$ (id))
'
FUNCTION $1_Update (id`,' $1 $1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax
	SHARED $1_idMin

	bOK = $$FALSE
	SELECT CASE TRUE
		CASE (id < $1_idMin || id > $1_idMax)
		CASE ELSE
			slot = id - 1
			upper_slot = UBOUND ($1_arrayUM[])
			IF (slot < 0 || slot > upper_slot) THEN EXIT SELECT
			IFF $1_arrayUM[slot] THEN EXIT SELECT
			' 
			$1_array[slot] = $1_item		' update $1 item
			bOK = $$TRUE
	END SELECT
	RETURN bOK
END FUNCTION
)
