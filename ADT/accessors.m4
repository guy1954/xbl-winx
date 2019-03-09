m4_define(`DeclareAccess',`''
' === $1 class ===
'
DECLARE FUNCTION $1_Delete (id) ' delete a $1 item accessed by its id
DECLARE FUNCTION $1_Get (id`,' $1 @$1_item) ' get data of a $1 item accessed by its id
DECLARE FUNCTION $1_Get_count () ' get $1 item count
DECLARE FUNCTION $1_Get_idMax () ' get $1 item id max
DECLARE FUNCTION $1_Get_idMin () ' get $1 item id min
DECLARE FUNCTION $1_Init () ' initialize the $1 class
DECLARE FUNCTION $1_New ($1 $1_item) ' add $1 item to $1 pool
DECLARE FUNCTION $1_Update (id`,' $1 $1_item) ' update data of a $1 item accessed by its id)

m4_define(`DefineAccess',`''
' === $1 class ===
'
'
' Deletes a $1 item accessed by its id
' id = id of the $1 item to delete
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'bOK = $1_Delete (id)
'IFF bOK THEN PRINT "$1_Delete: Can't delete $1 item from $1 pool by its id = "; id
'
FUNCTION $1_Delete (id)
	SHARED $1 $1_pool[]
	SHARED $1_poolUM[]

	$1 $1_Nil

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0 && slot <= UBOUND ($1_poolUM[])) THEN
		IF $1_poolUM[slot] THEN
			' empty the slot
			$1_pool[slot] = $1_Nil
			$1_poolUM[slot] = $$FALSE
			bOK = $$TRUE
		ENDIF
	ENDIF
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
'IFF bOK THEN PRINT "$1_Get: Can't get $1 item from $1 pool by its id = "; id
'
FUNCTION $1_Get (id`,' $1 $1_item)
	SHARED $1 $1_pool[]
	SHARED $1_poolUM[]

	$1 $1_Nil

	bOK = $$FALSE
	$1_item = $1_Nil
	slot = id - 1
	IF (slot >= 0 && slot <= UBOUND ($1_poolUM[])) THEN
		IF $1_poolUM[slot] THEN
			$1_item = $1_pool[slot]
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK
END FUNCTION
'
' Gets $1 item count
'
FUNCTION $1_Get_count ()
	SHARED $1_poolUM[]

	count = 0
	IF $1_poolUM[] THEN
		FOR slot = UBOUND ($1_poolUM[]) TO 0 STEP -1
			IF $1_poolUM[slot] THEN INC count
		NEXT slot
	ENDIF
	RETURN count
END FUNCTION
'
' Gets $1 item id max
'
FUNCTION $1_Get_idMax ()
	SHARED $1_poolUM[]

	$1_idMax = 0
	IF $1_poolUM[] THEN
		FOR slot = UBOUND ($1_poolUM[]) TO 0 STEP -1
			IF $1_poolUM[slot] THEN
				$1_idMax = slot + 1
				EXIT FOR
			ENDIF
		NEXT slot
	ENDIF
	RETURN $1_idMax
END FUNCTION
'
' Gets $1 item id min
'
FUNCTION $1_Get_idMin ()
	SHARED $1_poolUM[]

	IF $1_poolUM[] THEN
		upper_slot = UBOUND ($1_poolUM[])
		FOR slot = 0 TO upper_slot
			IF $1_poolUM[slot] THEN
				$1_idMin = slot + 1
				EXIT FOR
			ENDIF
		NEXT slot
	ENDIF
	RETURN $1_idMin
END FUNCTION
'
' Initializes the $1 class
'
FUNCTION $1_Init ()
	SHARED $1 $1_pool[] ' an array of $1 items
	SHARED $1_poolUM[] ' usage map so we can see which $1_pool[] elements are in use

	$1 $1_Nil

	IFZ $1_pool[] THEN
		upper_slot = 7
		DIM $1_pool[upper_slot]
		DIM $1_poolUM[upper_slot]
	ELSE
		' reset an existing $1_pool[]
		FOR slot = UBOUND ($1_poolUM[]) TO 0 STEP -1
			' empty the slot
			$1_pool[slot] = $1_Nil
			$1_poolUM[slot] = $$FALSE
		NEXT slot
	ENDIF
END FUNCTION
'
' Adds a $1 item to $1 pool
' returns id on success or 0 on fail
'
' Usage:
'id_new = $1_New ($1_item)
'IFZ id_new THEN PRINT "$1_New: Can't add item = "; $1_item; " to $1 pool"
'
FUNCTION $1_New ($1 $1_item)
	SHARED $1 $1_pool[]
	SHARED $1_poolUM[]

	IFZ $1_poolUM[] THEN $1_Init ()

	slot_new = -1

	upper_slot = UBOUND ($1_poolUM[])
	FOR slot = 0 TO upper_slot
		IFF $1_poolUM[slot] THEN
			' use/reuse this empty slot
			slot_new = slot
			EXIT FOR
		ENDIF
	NEXT slot

	IF slot_new = -1 THEN
		' empty slot_new not found => expand $1_pool[]
		upp = ((upper_slot + 1) * 2) - 1
		REDIM $1_pool[upp]
		REDIM $1_poolUM[upp]
		slot_new = upper_slot + 1
	ENDIF

	IF slot_new >= 0 THEN
		$1_pool[slot_new] = $1_item
		$1_poolUM[slot_new] = $$TRUE
	ENDIF
	RETURN (slot_new + 1)
END FUNCTION
'
' Updates the data of a $1 item accessed by its id
' id = id of $1 item
' $1_item = new data
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'bOK = $1_Update (id`,' $1_item)
'IFF bOK THEN PRINT "$1_Update: Can't update $1 item in $1 pool by its id = "; id
'
FUNCTION $1_Update (id`,' $1 $1_item)
	SHARED $1 $1_pool[]
	SHARED $1_poolUM[]

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0 && slot <= UBOUND ($1_poolUM[])) THEN
		IF $1_poolUM[slot] THEN
			$1_pool[slot] = $1_item
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK
END FUNCTION
')
