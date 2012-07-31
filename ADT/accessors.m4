m4_define(`DeclareAccess', `DECLARE FUNCTION $1_Init ()
DECLARE FUNCTION $1_New ($1 $1_item)
DECLARE FUNCTION $1_Get (id, $1 @$1_item)
DECLARE FUNCTION $1_Update (id, $1 $1_item)
DECLARE FUNCTION $1_Delete (id)')

'm4_define(`DefineAccess', `FUNCTION $1_Init ()
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax

	DIM $1_array[7]
	DIM $1_arrayUM[7]
	$1_idMax = 0
END FUNCTION

FUNCTION $1_New ($1 v_$1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax

	IFZ $1_arrayUM[] THEN $1_Init ()

	upper_slot = UBOUND ($1_arrayUM[])
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

	r_id = 0
	IF (slot >= 0) && (slot <= UBOUND ($1_arrayUM[])) THEN
		$1_array[slot] = v_$1_item
		$1_arrayUM[slot] = $$TRUE
		r_id = slot + 1
	ENDIF
	RETURN r_id
END FUNCTION

FUNCTION $1_Get (v_id, $1 r_$1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax

	$1 $1_Nil

	slot = v_id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1_arrayUM[])) THEN
		IF $1_arrayUM[slot] THEN
			r_$1_item = $1_array[slot]
			RETURN $$TRUE
		ENDIF
	ENDIF
	r_$1_item = $1_Nil
END FUNCTION

FUNCTION $1_Update (v_id, $1 v_$1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax

	slot = v_id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1_arrayUM[])) THEN
		IF $1_arrayUM[slot] THEN
			$1_array[slot] = v_$1_item
			RETURN $$TRUE
		ENDIF
	ENDIF
END FUNCTION

FUNCTION $1_Delete (v_id)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]
	SHARED $1_idMax

	$1 $1_Nil

	slot = v_id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1_arrayUM[])) THEN
		$1_arrayUM[slot] = $$FALSE
		$1_array[slot] = $1_Nil
		RETURN $$TRUE
	ENDIF
END FUNCTION
')