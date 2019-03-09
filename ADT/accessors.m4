m4_define(`DeclareAccess', `DECLARE FUNCTION $1_Delete ($1_id)
DECLARE FUNCTION $1_Get ($1_id`,' $1 @$1_item)
DECLARE FUNCTION $1_Get_count ()
DECLARE FUNCTION $1_Get_idMax ()
DECLARE FUNCTION $1_Get_idMin ()
DECLARE FUNCTION $1_Init ()
DECLARE FUNCTION $1_New ($1 $1_item)
DECLARE FUNCTION $1_Update ($1_id`,' $1 $1_item)')

m4_define(`DefineAccess',`FUNCTION $1_Delete ($1_id)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]

	$1 $1_null

	bOK = $$FALSE
	slot = $1_id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1_arrayUM[])) THEN
		$1_array[slot] = $1_null
		$1_arrayUM[slot] = $$FALSE
		bOK = $$TRUE
	ENDIF
	RETURN bOK
END FUNCTION

FUNCTION $1_Get ($1_id`,' $1 $1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]

	$1 $1_null

	bOK = $$FALSE
	slot = $1_id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1_arrayUM[])) THEN
		IF $1_arrayUM[slot] THEN
			$1_item = $1_array[slot]
			bOK = $$TRUE
		ENDIF
	ENDIF
	IFF bOK THEN
		$1_item = $1_null
	ENDIF
	RETURN bOK
END FUNCTION

FUNCTION $1_Get_count ()
	SHARED $1_arrayUM[]

	count = 0
	IF $1_arrayUM[] THEN
		FOR slot = UBOUND ($1_arrayUM[]) TO 0 STEP -1
			IF $1_arrayUM[slot] THEN INC count
		NEXT slot
	ENDIF
	RETURN count
END FUNCTION

FUNCTION $1_Get_idMax ()
	SHARED $1_arrayUM[]

	$1_idMax = 0
	IF $1_arrayUM[] THEN
		FOR slot = UBOUND ($1_arrayUM[]) TO 0 STEP -1
			IF $1_arrayUM[slot] THEN
				$1_idMax = slot + 1
				EXIT FOR
			ENDIF
		NEXT slot
	ENDIF
	RETURN $1_idMax
END FUNCTION

FUNCTION $1_Get_idMin ()
	SHARED $1_arrayUM[]

	$1_idMin = 0
	IF $1_arrayUM[] THEN
		upper_slot = UBOUND ($1_arrayUM[])
		FOR slot = 0 TO upper_slot
			IF $1_arrayUM[slot] THEN
				$1_idMin = slot + 1
				EXIT FOR
			ENDIF
		NEXT slot
	ENDIF
	RETURN $1_idMin
END FUNCTION

FUNCTION $1_Init ()
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]

	$1 $1_null

	IFZ $1_array[] THEN
		DIM $1_array[7]
		DIM $1_arrayUM[7]
	ENDIF
	FOR slot = UBOUND ($1_arrayUM[]) TO 0 STEP -1
		$1_array[slot] = $1_null
		$1_arrayUM[slot] = $$FALSE
	NEXT slot
END FUNCTION

FUNCTION $1_New ($1 $1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]

	$1 $1_null

	IFZ $1_arrayUM[] THEN $1_Init ()

	slotNew = -1

	upper_slot = UBOUND ($1_arrayUM[])
	FOR slot = 0 TO upper_slot
		IFF $1_arrayUM[slot] THEN
			slotNew = slot
			EXIT FOR
		ENDIF
	NEXT slot

	IF slotNew < 0 THEN
		slotNew = upper_slot + 1
		upp = (slotNew << 1) | 3
		REDIM $1_array[upp]
		REDIM $1_arrayUM[upp]
		FOR i = slotNew TO upp
			$1_array[i] = $1_null
		NEXT i
	ENDIF

	IF slotNew >= 0 THEN
		$1_array[slotNew] = $1_item
		$1_arrayUM[slotNew] = $$TRUE
	ENDIF
	RETURN (slotNew + 1)
END FUNCTION

FUNCTION $1_Update ($1_id`,' $1 $1_item)
	SHARED $1 $1_array[]
	SHARED $1_arrayUM[]

	bOK = $$FALSE
	slot = $1_id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1_arrayUM[])) THEN
		IF $1_arrayUM[slot] THEN
			$1_array[slot] = $1_item
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK
END FUNCTION
')
