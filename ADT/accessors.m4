m4_define(`DeclareAccess',`''

DECLARE FUNCTION $1_Delete (id) ' delete a $1 item accessed by its id
DECLARE FUNCTION $1_Get (id`,' $1 @$1_item) ' get the value of a $1 item accessed by its id
DECLARE FUNCTION $1_Get_count () ' get $1 list count
DECLARE FUNCTION $1_Get_idMax () ' get the maximum id of $1 list
DECLARE FUNCTION $1_Get_idMin () ' get the minimum id of $1 list
DECLARE FUNCTION $1_Init () ' initialize the $1 class
DECLARE FUNCTION $1_New ($1 $1_item) ' add $1 item to $1 list
DECLARE FUNCTION $1_Update (id`,' $1 $1_item) ' update the value of a $1 item accessed by its id)

m4_define(`DefineAccess',`''
'
' Deletes a $1 item accessed by its id
'
FUNCTION $1_Delete (id)
	SHARED $1 $1_pool[]
	SHARED $1_used[]

	$1 $1_Nil

	bOK = $$FALSE
	slot = id - 1
	upper_slot = UBOUND ($1_used[])
	IF (slot >= 0 && slot <= upper_slot) THEN
		IF $1_used[slot] THEN
			$1_pool[slot] = $1_Nil
			$1_used[slot] = $$FALSE
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK
END FUNCTION
'
' Gets the value of a $1 item accessed by its id
'
FUNCTION $1_Get (id`,' $1 r_$1_item)
	SHARED $1 $1_pool[]
	SHARED $1_used[]

	$1 $1_Nil

	bOK = $$FALSE
	r_$1_item = $1_Nil
	slot = id - 1
	upper_slot = UBOUND ($1_used[])
	IF (slot >= 0 && slot <= upper_slot) THEN
		IF $1_used[slot] THEN
			r_$1_item = $1_pool[slot]
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK
END FUNCTION
'
' Gets $1 list count
'
FUNCTION $1_Get_count ()
	SHARED $1_used[]

	r_count = 0
	IF $1_used[] THEN
		upper_slot = UBOUND ($1_used[])
		FOR slot = 0 TO upper_slot
			IF $1_used[slot] THEN INC r_count
		NEXT slot
	ENDIF
	RETURN r_count
END FUNCTION
'
' Gets $1 item id max
'
FUNCTION $1_Get_idMax ()
	SHARED $1_used[]

	r_idMax = 0
	IF $1_used[] THEN
		upper_slot = UBOUND ($1_used[])
		FOR slot = upper_slot TO 0 STEP -1
			IF $1_used[slot] THEN
				r_idMax = slot + 1
				EXIT FOR
			ENDIF
		NEXT slot
	ENDIF
	RETURN r_idMax
END FUNCTION
'
' Gets the minimum id of $1 list
'
FUNCTION $1_Get_idMin ()
	SHARED $1_used[]

	r_idMin = 0
	IF $1_used[] THEN
		upper_slot = UBOUND ($1_used[])
		FOR slot = 0 TO upper_slot
			IF $1_used[slot] THEN
				r_idMin = slot + 1
				EXIT FOR
			ENDIF
		NEXT slot
	ENDIF
	RETURN r_idMin
END FUNCTION
'
' Initializes the $1 class.
'
FUNCTION $1_Init ()
	SHARED $1 $1_pool[]
	SHARED $1_used[]

	$1 $1_Nil

	IFZ $1_pool[] THEN
		upper_slot = 7
		DIM $1_pool[upper_slot]
		DIM $1_used[upper_slot]
	ELSE
		upper_slot = UBOUND ($1_used[])
		FOR slot = 0 TO upper_slot
			$1_pool[slot] = $1_Nil
			$1_used[slot] = $$FALSE
		NEXT slot
	ENDIF
END FUNCTION
'
' Adds a new $1 item to $1 list.
'
FUNCTION $1_New ($1 $1_item)
	SHARED $1 $1_pool[]
	SHARED $1_used[]

	r_idNew = 0

	IFZ $1_used[] THEN $1_Init ()

	slotNew = -1

	upper_slot = UBOUND ($1_used[])
	FOR slot = 0 TO upper_slot
		IFF $1_used[slot] THEN
			slotNew = slot
			EXIT FOR
		ENDIF
	NEXT slot

	IF slotNew = -1 THEN
		upp = ((upper_slot + 1) * 2) - 1
		REDIM $1_pool[upp]
		REDIM $1_used[upp]
		slotNew = upper_slot + 1
	ENDIF

	IF slotNew >= 0 THEN
		$1_pool[slotNew] = $1_item
		$1_used[slotNew] = $$TRUE
		r_idNew = slotNew + 1
	ENDIF

	RETURN r_idNew
END FUNCTION
'
' Updates the value of a $1 item accessed by its id.
'
FUNCTION $1_Update (id`,' $1 $1_item)
	SHARED $1 $1_pool[]
	SHARED $1_used[]

	bOK = $$FALSE
	slot = id - 1
	upper_slot = UBOUND ($1_used[])
	IF (slot >= 0 && slot <= upper_slot) THEN
		IF $1_used[slot] THEN
			$1_pool[slot] = $1_item
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK
END FUNCTION
)
