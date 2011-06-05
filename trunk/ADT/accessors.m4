m4_define(`DeclareAccess', `DECLARE FUNCTION $1_Init ()
DECLARE FUNCTION $1_New ($1 item)
DECLARE FUNCTION $1_Get (id, $1 @item)
DECLARE FUNCTION $1_Update (id, $1 item)
DECLARE FUNCTION $1_Delete (id)
DECLARE FUNCTION $1_Get_idMax ()')

m4_define(`DefineAccess', `FUNCTION $1_Init ()
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax

	DIM $1_array[7]
	DIM $1_arrayUM[7]
	$1_idMax = 0
END FUNCTION

FUNCTION $1_New ($1 item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax

	IFZ $1_array[] THEN $1_Init ()

	upper_slot = UBOUND ($1_array[])
	slot = -1
	IF $1_idMax <= upper_slot THEN
		FOR i = $1_idMax TO upper_slot
			IFF $1_arrayUM[i] THEN
				slot = i
				$1_idMax = i + 1
				EXIT FOR
			ENDIF
		NEXT i
	ENDIF

	IF slot = -1 THEN
		upper_slot = ((upper_slot + 1) << 1) - 1
		REDIM $1_array[upper_slot]
		REDIM $1_arrayUM[upper_slot]
		slot = $1_idMax
		INC $1_idMax
	ENDIF

	IF (slot < 0) || (slot > upper_slot) THEN RETURN
	$1_array[slot] = item
	$1_arrayUM[slot] = $$TRUE
	RETURN (slot + 1)
END FUNCTION

FUNCTION $1_Get (id, $1 item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax

	$1 item_null

	item = item_null
	IFZ $1_array[] THEN RETURN
	IF id > $1_idMax THEN RETURN

	upper_slot = UBOUND ($1_array[])
	slot = id - 1
	IF (slot < 0) || (slot > upper_slot) THEN RETURN
	IFF $1_arrayUM[slot] THEN RETURN

	item = $1_array[slot]
	RETURN $$TRUE
END FUNCTION

FUNCTION $1_Update (id, $1 item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax

	IFZ $1_array[] THEN RETURN
	IF id > $1_idMax THEN RETURN

	upper_slot = UBOUND ($1_array[])
	slot = id - 1
	IF (slot < 0) || (slot > upper_slot) THEN RETURN
	IFF $1_arrayUM[slot] THEN RETURN

	$1_array[slot] = item
	RETURN $$TRUE
END FUNCTION

FUNCTION $1_Delete (id)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax

	IFZ $1_array[] THEN RETURN
	IF id > $1_idMax THEN RETURN

	upper_slot = UBOUND ($1_array[])
	slot = id - 1
	IF (slot < 0) || (slot > upper_slot) THEN RETURN
	IFF $1_arrayUM[slot] THEN RETURN

	$1_arrayUM[slot] = $$FALSE
	RETURN $$TRUE
END FUNCTION

FUNCTION $1_Get_idMax ()
	SHARED $1_idMax
	RETURN $1_idMax
END FUNCTION
')