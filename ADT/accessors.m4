m4_define(`DeclareAccess', `DECLARE FUNCTION $1_Init ()
DECLARE FUNCTION $1_New ($1 item)
DECLARE FUNCTION $1_Get (id, $1 @item)
DECLARE FUNCTION $1_Update (id, $1 item)
DECLARE FUNCTION $1_Delete (id)')

m4_define(`DefineAccess', `FUNCTION $1_Init ()
	SHARED $1 gadt_$1_array[]
	SHARED gadt_$1_arrayUM[]
	SHARED gadt_$1_idMax

	DIM gadt_$1_array[7]
	DIM gadt_$1_arrayUM[7]
	gadt_$1_idMax = 0
END FUNCTION

FUNCTION $1_New ($1 item)
	SHARED $1 gadt_$1_array[]
	SHARED gadt_$1_arrayUM[]
	SHARED gadt_$1_idMax

	upper_slot = UBOUND (gadt_$1_arrayUM[])

	slot = -1
	FOR i = gadt_$1_idMax TO upper_slot
		IFF gadt_$1_arrayUM[i] THEN
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	IF slot = -1 THEN
		upper_slot = ((upper_slot + 1) << 1) - 1
		REDIM gadt_$1_arrayUM[upper_slot]
		REDIM gadt_$1_array[upper_slot]
		slot = gadt_$1_idMax
	ENDIF

	gadt_$1_idMax = slot + 1
	gadt_$1_array[slot] = item
	gadt_$1_arrayUM[slot] = $$TRUE
	RETURN (slot + 1)
END FUNCTION

FUNCTION $1_Get (id, $1 item)
	SHARED $1 gadt_$1_array[]
	SHARED gadt_$1_arrayUM[]

	upper_slot = UBOUND (gadt_$1_arrayUM[])

	slot = id - 1

	IF (slot < 0) || (slot > upper_slot) THEN RETURN
	IFF gadt_$1_arrayUM[slot] THEN RETURN

	item = gadt_$1_array[slot]
	RETURN $$TRUE
END FUNCTION

FUNCTION $1_Update (id, $1 item)
	SHARED $1 gadt_$1_array[]
	SHARED gadt_$1_arrayUM[]

	upper_slot = UBOUND (gadt_$1_arrayUM[])

	slot = id - 1

	IF (slot < 0) || (slot > upper_slot) THEN RETURN
	IFF gadt_$1_arrayUM[slot] THEN RETURN

	gadt_$1_array[slot] = item
	RETURN $$TRUE
END FUNCTION

FUNCTION $1_Delete (id)
	SHARED $1 gadt_$1_array[]
	SHARED gadt_$1_arrayUM[]
	SHARED gadt_$1_idMax

	upper_slot = UBOUND (gadt_$1_arrayUM[])

	slot = id - 1

	IF (slot < 0) || (slot > upper_slot) THEN RETURN
	IFF gadt_$1_arrayUM[slot] THEN RETURN

	IF id >= gadt_$1_idMax THEN gadt_$1_idMax = id - 1
	gadt_$1_arrayUM[slot] = 0
END FUNCTION
')