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

	bOK = $$FALSE
	slot = id - 1
	upper_slot = UBOUND ($1_arrayUM[])
	SELECT CASE TRUE
		CASE (slot < 0 || slot > upper_slot)
		CASE ELSE
			IFF $1_arrayUM[slot] THEN EXIT SELECT
			'
			$1_arrayUM[slot] = $$FALSE		' mark $1 item as deleted
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

	$1 $1_Nil

	bOK = $$FALSE
	slot = id - 1
	upper_slot = UBOUND ($1_arrayUM[])
	SELECT CASE TRUE
		CASE (slot < 0 || slot > upper_slot)
		CASE ELSE
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
	SHARED $1_arrayUM[]

	count = 0
	IF $1_arrayUM[] THEN
		FOR z = UBOUND ($1_arrayUM[]) TO 0 STEP -1
			IF $1_arrayUM[z] THEN INC count
		NEXT z
	ENDIF
	RETURN count
END FUNCTION
'
' Gets $1 item id max
'
FUNCTION $1_Get_idMax ()
	SHARED $1_arrayUM[]

	$1_idMax = 0
	IF $1_arrayUM[] THEN
		FOR z = UBOUND ($1_arrayUM[]) TO 0 STEP -1
			IFF $1_arrayUM[z] THEN
				$1_idMax = z + 1
				EXIT FOR
			ENDIF
		NEXT z
	ENDIF
	RETURN $1_idMax
END FUNCTION
'
' Gets $1 item id min
'
FUNCTION $1_Get_idMin ()
	SHARED $1_arrayUM[]

	IF $1_arrayUM[] THEN
		upper_slot = UBOUND ($1_arrayUM[])
		FOR z = 0 TO upper_slot
			IFF $1_arrayUM[z] THEN
				$1_idMin = z + 1
				EXIT FOR
			ENDIF
		NEXT z
	ENDIF
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

	IFZ $1_arrayUM[] THEN $1_Init ()

	upper_slot = UBOUND ($1_arrayUM[])

	' since $1_array[] is oversized
	' look for an empty spot from the upper slot
	slot = -1
	FOR i = upper_slot TO 0 STEP -1
		IF $1_arrayUM[i] THEN EXIT FOR
		slot = i
	NEXT i

	IF slot = -1 THEN
		slot = upper_slot + 1
		' empty spot not found => expand $1_array[]
		upper_slot = ((upper_slot + 1) * 2) - 1
		REDIM $1_array[upper_slot]
		REDIM $1_arrayUM[upper_slot]
	ENDIF

	IF slot = -1 THEN
		id = 0
	ELSE
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

	bOK = $$FALSE
	slot = id - 1
	upper_slot = UBOUND ($1_arrayUM[])
	SELECT CASE TRUE
		CASE (slot < 0 || slot > upper_slot)
		CASE ELSE
			IFF $1_arrayUM[slot] THEN EXIT SELECT
			'
			$1_array[slot] = $1_item		' update $1 item
			bOK = $$TRUE
	END SELECT
	RETURN bOK
END FUNCTION
)
