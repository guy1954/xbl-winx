m4_define(`DeclareAccess', `DECLARE FUNCTION $1_Init ()
DECLARE FUNCTION $1_New ($1 item)
DECLARE FUNCTION $1_Get (id, $1 @item)
DECLARE FUNCTION $1_Update (id, $1 item)
DECLARE FUNCTION $1_Delete (id)')

m4_define(`DefineAccess', `FUNCTION $1_Init ()
	SHARED $1 $1array[]
	SHARED UBYTE $1arrayUM[]
	SHARED $1Next
	DIM $1array[7]
	DIM $1arrayUM[7]
	$1Next = 0
END FUNCTION

FUNCTION $1_New ($1 item)
	SHARED $1 $1array[]
	SHARED UBYTE $1arrayUM[]
	SHARED $1Next
	
	slot = -1
	FOR i = $1Next TO UBOUND($1arrayUM[])
		IFZ $1arrayUM[i] THEN
			slot = i
			EXIT FOR
		END IF
	NEXT
	
	IF slot = -1 THEN
		slot = UBOUND($1arrayUM[])+1
		REDIM $1arrayUM[((UBOUND($1arrayUM[])+1)<<1)-1]
		REDIM $1array[UBOUND($1arrayUM[])]
	END IF
	
	$1Next = slot+1
	$1array[slot] = item
	$1arrayUM[slot] = $$TRUE
	RETURN slot+1
END FUNCTION

FUNCTION $1_Get (id, $1 item)
	SHARED $1 $1array[]
	SHARED UBYTE $1arrayUM[]
	
	DEC id
	
	IF id < 0 || id > UBOUND($1arrayUM[]) THEN RETURN $$FALSE
	IFZ $1arrayUM[id] THEN RETURN $$FALSE
	
	item = $1array[id]
	RETURN $$TRUE
END FUNCTION

FUNCTION $1_Update (id, $1 item)
	SHARED $1 $1array[]
	SHARED UBYTE $1arrayUM[]
	
	DEC id
	
	IF id < 0 || id > UBOUND($1arrayUM[]) THEN RETURN $$FALSE
	IFZ $1arrayUM[id] THEN RETURN $$FALSE
	
	$1array[id] = item
	RETURN $$TRUE
END FUNCTION

FUNCTION $1_Delete (id)
	SHARED $1 $1array[]
	SHARED UBYTE $1arrayUM[]
	SHARED $1Next
	
	DEC id
	
	IF id < 0 || id > UBOUND($1arrayUM[]) THEN RETURN $$FALSE
	IFZ $1arrayUM[id] THEN RETURN $$FALSE
	
	IF $1Next > id THEN $1Next = id
	$1arrayUM[id] = 0
	RETURN $$TRUE
END FUNCTION
')