m4_define(`DeclareAccess',`''
' === $1 class ===
'
DECLARE FUNCTION $1_Init () ' initialize the $1 class
DECLARE FUNCTION $1_New ($1 $1_item) ' add $1_item to $1 pool
DECLARE FUNCTION $1_Get (id`,' $1 @$1_item) ' get data of a $1 item using its id
DECLARE FUNCTION $1_Update (id`,' $1 $1_item) ' update data of a $1 item using its id
DECLARE FUNCTION $1_Delete (id) ' delete a $1 item using its id
DECLARE FUNCTION $1_Get_idMax () ' get $1 item id max)

m4_define(`DefineAccess',`''
' === $1 class ===
'
' Initializes the $1 class
FUNCTION $1_Init ()
	SHARED $1 $1_array[] ' an array of $1_item
	SHARED $1_arrayUM[] ' a usage map so we can see which array elements are in use
	SHARED $1_idMax

	IFZ $1_array[] THEN
		DIM $1_array[7]
		DIM $1_arrayUM[7]
	ELSE
		upper_slot = UBOUND ($1_arrayUM[])
		FOR i = 0 TO upper_slot
			$1_arrayUM[i] = $$FALSE
		NEXT i
	ENDIF
	$1_idMax = 0
END FUNCTION
'
' Adds a $1 item to $1 pool
' returns id on success or 0 on fail
'
' Usage:
'id = $1_New ($1_item)
'IFZ id THEN ' can't add $1 item
'
FUNCTION $1_New ($1 $1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[] ' usage map
	SHARED $1_idMax

	IFZ $1_arrayUM[] THEN $1_Init ()

	upper_slot = UBOUND ($1_arrayUM[])

	' since $1_array[] is oversized
	' look for a spot after $1_idMax
	slot = -1 ' spot not found
	IF $1_idMax <= upper_slot THEN
		FOR i = $1_idMax TO upper_slot
			IFF $1_arrayUM[i] THEN
				' spot found!
				slot = i
				$1_idMax = i + 1
				EXIT FOR
			ENDIF
		NEXT i
	ENDIF

	IF slot = -1 THEN
		' spot not found => expand $1_array[]
		upper_slot = ((upper_slot + 1) << 1) - 1
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
	RETURN id ' return id
END FUNCTION
'
' Gets data of a $1 item using its id
' id = id of $1 item
' $1_item = returned data
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'bOK = $1_Get (id`,' @$1_item)
'IFF bOK THEN ' can't get $1 item
'
FUNCTION $1_Get (id`,' $1 $1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[] ' usage map
	SHARED $1_idMax

	$1 $1_Nil

	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1_arrayUM[])) THEN
		IF $1_arrayUM[slot] THEN
			$1_item = $1_array[slot] ' get $1 item
			RETURN $$TRUE ' OK!
		ENDIF
	ENDIF
	$1_item = $1_Nil ' can't get $1 item
END FUNCTION
'
' Updates the data of a $1 item using its id
' id = id of $1 item
' $1_item = new data
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'bOK = $1_Update (id`,' $1_item)
'IFF bOK THEN ' can't update $1 item
'
FUNCTION $1_Update (id`,' $1 $1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[] ' usage map
	SHARED $1_idMax

	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1_arrayUM[])) THEN
		IF $1_arrayUM[slot] THEN
			$1_array[slot] = $1_item ' update $1 item
			RETURN $$TRUE ' OK!
		ENDIF
	ENDIF
END FUNCTION
'
' Deletes a $1 item using its id
' id = id of $1 item
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'bOK = $1_Delete (id)
'IFF bOK THEN ' can't delete $1 item
'
FUNCTION $1_Delete (id)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[] ' usage map
	SHARED $1_idMax

	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1_arrayUM[])) THEN
		$1_arrayUM[slot] = $$FALSE ' delete $1 item
		RETURN $$TRUE ' OK!
	ENDIF
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
END FUNCTION)