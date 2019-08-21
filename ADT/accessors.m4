m4_define(`DeclareAccess',`DECLARE FUNCTION $1_Delete (id)
DECLARE FUNCTION $1_Get (id`,' $1 @item)
DECLARE FUNCTION $1_Init ()
DECLARE FUNCTION $1_New ($1 item)
DECLARE FUNCTION $1_Update (id`,' $1 item)')

m4_define(`DefineAccess',`FUNCTION $1_Delete (id)
	SHARED $1 $1array[]
	SHARED UBYTE $1arrayUM[]

	$1 item_null

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1arrayUM[])) THEN
		$1array[slot] = item_null
		$1arrayUM[slot] = $$FALSE
		bOK = $$TRUE
	ENDIF
	RETURN bOK
END FUNCTION

FUNCTION $1_Get (id`,' $1 item)
	SHARED $1 $1array[]
	SHARED UBYTE $1arrayUM[]

	$1 item_null

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1arrayUM[])) THEN
		IF $1arrayUM[slot] THEN
			item = $1array[slot]
			bOK = $$TRUE
		ENDIF
	ENDIF
	IFF bOK THEN
		item = item_null
	ENDIF
	RETURN bOK
END FUNCTION

FUNCTION $1_Init ()
	SHARED $1 $1array[]
	SHARED UBYTE $1arrayUM[]

	$1 item_null

	IFZ $1array[] THEN
		DIM $1array[7]
		DIM $1arrayUM[7]
	ENDIF
	FOR slot = UBOUND ($1arrayUM[]) TO 0 STEP -1
		$1array[slot] = item_null
		$1arrayUM[slot] = $$FALSE
	NEXT slot
END FUNCTION

FUNCTION $1_New ($1 item)
	SHARED $1 $1array[]
	SHARED UBYTE $1arrayUM[]

	$1 item_null

	IFZ $1arrayUM[] THEN $1_Init ()

	slot = -1

	upper_slot = UBOUND ($1arrayUM[])
	FOR i = 0 TO upper_slot
		IFF $1arrayUM[i] THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	IF slot < 0 THEN
		slot = upper_slot + 1
		upp = (slot << 1) | 3
		REDIM $1array[upp]
		REDIM $1arrayUM[upp]
		FOR i = slot TO upp
			$1array[i] = item_null
		NEXT i
	ENDIF

	IF slot >= 0 THEN
		$1array[slot] = item
		$1arrayUM[slot] = $$TRUE
	ENDIF
	RETURN (slot + 1)
END FUNCTION

FUNCTION $1_Update (id`,' $1 item)
	SHARED $1 $1array[]
	SHARED UBYTE $1arrayUM[]

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND ($1arrayUM[])) THEN
		IF $1arrayUM[slot] THEN
			$1array[slot] = item
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK
END FUNCTION
')
