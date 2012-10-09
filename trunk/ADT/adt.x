PROGRAM "adt"
VERSION "0.2"
'
' ADT - Abstract Data Types library for XBlite
' (C) Callum Lowcay 2008 - Licensed under the GNU LGPL
'
' Requires m4 macro processing to compile.
' Also requires the accessors.m4 file.  I sugest that you copy this to your XBlite include folder and set the
'  M4PATH environment variable to the XBlite include folder.
'
' ***** Versions *****
' Contributors:
'     Callum Lowcay (original version)
'     Guy Lonne (evolutions)
'
' 0.2-Guy-25mar11-small changes in accessors.m4.
'     Guy-04nov11-prevented adt.dll re-entry with SHARED variable #bReentry.
'
'
	IMPORT "xst"        ' xblite Standard Library

'
m4_include(`accessors.m4')

EXPORT
'
' ADT - Abstract Data Types library for XBlite
' (C) Callum Lowcay 2008 - Licensed under the GNU LGPL
'
' *********************************
' *****  ADT COMPOSITE TYPES  *****
' *********************************
'
TYPE LINKEDNODE
	XLONG	.iNext
	XLONG	.iData
END TYPE
'
TYPE LINKEDWALK
	XLONG	.first
	XLONG	.iPrev
	XLONG	.iCurrentNode
	XLONG	.iNext
	XLONG	.last
END TYPE
'
TYPE LINKEDLIST
	XLONG	.iHead
	XLONG	.iTail
	XLONG	.cItems
END TYPE
'
TYPE BINNODE
	XLONG	.iKey
	XLONG	.iLeft
	XLONG	.iRight
	XLONG	.iData
END TYPE
'
TYPE BINWALK
	XLONG		.order
	XLONG		.nextItem
	BINNODE	.node
END TYPE
'
'	XLONG		.order
$$ADT_PREORDER	= 0
$$ADT_INORDER		= 1
$$ADT_POSTORDER	= 2
'
TYPE BINTREE
	XLONG	.iHead
	FUNCADDR	.comparator(XLONG, XLONG) ' (id_1, id_2)
	FUNCADDR	.keyDeleter(XLONG) ' (indexDelete)
END TYPE
'
' The stack pointer is maintained implicitly by the linked list
TYPE STACK
	LINKEDLIST	.list
END TYPE
'
' Associative arrays are implemented with bin trees
TYPE ASSOCARRAY
	BINTREE	.tree
END TYPE
'
'
'
' ***********************************
' *****  ADT Library Functions  *****
' ***********************************
'
'
DECLARE FUNCTION ADT () ' initialization
'
' Linked Lists
DECLARE FUNCTION LinkedList_Init (LINKEDLIST @list)
DECLARE FUNCTION LinkedList_Append (LINKEDLIST @list, iData)
DECLARE FUNCTION LinkedList_Insert (LINKEDLIST @list, index, iData)
DECLARE FUNCTION LinkedList_GetItem (LINKEDLIST list, index, @iData)
DECLARE FUNCTION LinkedList_StartWalk (LINKEDLIST list)
DECLARE FUNCTION LinkedList_Walk (hWalk, @iData)
DECLARE FUNCTION LinkedList_Jump (hWalk, iItem)
DECLARE FUNCTION LinkedList_IsLastNode (hWalk)
DECLARE FUNCTION LinkedList_ResetWalk (hWalk)
DECLARE FUNCTION LinkedList_DeleteThis (hWalk, LINKEDLIST @list)
DECLARE FUNCTION LinkedList_EndWalk (hWalk)
DECLARE FUNCTION LinkedList_DeleteItem (LINKEDLIST @list, index)
DECLARE FUNCTION LinkedList_DeleteAll (LINKEDLIST @list)
DECLARE FUNCTION LinkedList_Map (LINKEDLIST list, FUNCADDR callBack, @result)
DECLARE FUNCTION LinkedList_Uninit (LINKEDLIST @list)
'
' Stacks
DECLARE FUNCTION Stack_Init (STACK @stack)
DECLARE FUNCTION Stack_Uninit (STACK @stack)
DECLARE FUNCTION Stack_Push (STACK @stack, iData)
DECLARE FUNCTION Stack_Pop (STACK @stack, @iData)
DECLARE FUNCTION Stack_Peek (STACK stack, @iData)
'
' Bin Trees
' User functions FnCompareNodeKeys(id_1, id_2) and FnDeleteTreeNode(indexDelete)
DECLARE FUNCTION BinTree_Init (BINTREE @tree, FUNCADDR FnCompareNodeKeys, FUNCADDR FnDeleteTreeNode)
DECLARE FUNCTION BinTree_Add (BINTREE @tree, iKey, iData)
DECLARE FUNCTION BinTree_Remove (BINTREE @tree, iKey, @iData)
DECLARE FUNCTION BinTree_Find (BINTREE tree, iKey, @iData)
DECLARE FUNCTION BinTree_Uninit (BINTREE @tree)
DECLARE FUNCTION BinTree_StartTraversal (BINTREE tree, order)
DECLARE FUNCTION BinTree_Traverse (traverse, @iData, @iKey)
DECLARE FUNCTION BinTree_EndTraversal (traverse)
'
' Needed for coding the body of User functions
' - FnCompareNodeKeys(id_1, id_2)
' - and FnDeleteTreeNode(indexDelete)
DeclareAccess(BINNODE)
'
' Associative arrays
DECLARE FUNCTION AssocArray_Insert (ASSOCARRAY @array, key$, iData)
DECLARE FUNCTION AssocArray_Delete (ASSOCARRAY @array, key$, @iData)
DECLARE FUNCTION AssocArray_Find (ASSOCARRAY array,key$, @iData)
DECLARE FUNCTION AssocArray_Clear (ASSOCARRAY @array)
DECLARE FUNCTION AssocArray_Init (ASSOCARRAY @array)
'
' === STRING class ===
'
DECLARE FUNCTION STRING_Init () ' initialize the STRING class
DECLARE FUNCTION STRING_Delete (id) ' delete a STRING item using its id
DECLARE FUNCTION STRING_Find (match$) ' find exact match of match$
DECLARE FUNCTION STRING_FindIns (match$) ' find match$ insensitive
DECLARE FUNCTION STRING_Get (id, @STRING_item$) ' get value by STRING item id
DECLARE FUNCTION STRING_Get_count () ' get item count
DECLARE FUNCTION STRING_Get_idMax () ' get STRING item id max
DECLARE FUNCTION STRING_Get_idMin () ' get STRING item id min
DECLARE FUNCTION STRING_New (STRING_item$) ' add STRING_item$ to STRING pool
DECLARE FUNCTION STRING_Update (id, STRING_item$) ' update value of a STRING item using its id
'
DECLARE FUNCTION IntCompare (a, b)
DECLARE FUNCTION StringCompare (a, b)
DECLARE FUNCTION IStringCompare (a, b)
'
END EXPORT
'
DECLARE FUNCTION LINKEDLIST_GetNode (LINKEDLIST list, index, iNode)
DECLARE FUNCTION BinTree_RealAdd (FUNCADDR FnCompareNodeKeys, iNode, iKey, iData)
DECLARE FUNCTION BinTree_RealUninit (iNode, FUNCADDR FnDeleteTreeNode)
DECLARE FUNCTION BinTree_RealFind (FUNCADDR FnCompareNodeKeys, @iParentNode, iKey, @iData)
DECLARE FUNCTION BinTree_RealRemove (FUNCADDR FnDeleteTreeNode, iNode, iParentNode)
'
DeclareAccess(LINKEDNODE)
DeclareAccess(LINKEDWALK)
'Declare_Access(BINNODE)
DeclareAccess(BINWALK)
DeclareAccess(STACK)
'
'
' ####################
' #####  ADT ()  #####
' ####################
' Initialises the ADT library
' returns $$TRUE on error otherwise $$FALSE
FUNCTION ADT ()

	IF #bReentry THEN RETURN ' already initialized!

	' in prevision of a static build
	Xst ()		' initialize Xblite Standard Library

	STRING_Init ()
	LINKEDNODE_Init ()
	LINKEDWALK_Init ()
	BINNODE_Init ()
	BINWALK_Init ()
	STACK_Init ()

	#bReentry = $$TRUE ' protect for reentry

END FUNCTION
'
' ##############################
' #####  AssocArray_Clear  #####
' ##############################
' Deletes all the items in an associative array so you can safely delete the array
' array = the array to clear
' returns $$TRUE on success or $$FALSE on fail
FUNCTION AssocArray_Clear (ASSOCARRAY array)
	BinTree_Uninit (@array.tree)
END FUNCTION
'
' ###############################
' #####  AssocArray_Delete  #####
' ###############################
' Deletes an item from an associative array
' array = the array to delete the item from
' key$ = the key for the item
' iData = the variable to store the data of the item
' returns $$TRUE on success or $$FALSE on fail
FUNCTION AssocArray_Delete (ASSOCARRAY array, key$, @iData)
	iKey = STRING_New (key$)
	ret = BinTree_Remove (@array.tree, iKey, @iData)
	STRING_Delete (iKey)
	RETURN ret
END FUNCTION
'
' #############################
' #####  AssocArray_Find  #####
' #############################
' Locates an item in an associative array
' array = the array to locate the item in
' key$ = the key of the item to locate
' iData = the variable to store the data for the item
' returns $$TRUE on success or $$FASLE on fail
FUNCTION AssocArray_Find (ASSOCARRAY array, key$, @iData)
	iKey = STRING_New (key$)
	bFound = BinTree_Find (@array.tree, iKey, @iData)
	STRING_Delete (iKey)
	RETURN bFound
END FUNCTION
'
' #############################
' #####  AssocArray_Init  #####
' #############################
' Initialises an associative arary
' array = the array to initialise
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION AssocArray_Init (ASSOCARRAY array)
	array.tree.comparator = &StringCompare ()
	array.tree.keyDeleter = &STRING_Delete ()
END FUNCTION
'
' ###############################
' #####  AssocArray_Insert  #####
' ###############################
' Inserts an item into an associative array
' array = the array to insert the item into
' key$ = the key for the item
' iData = the data for the item
' returns $$TRUE on success or $$FALSE on fail
FUNCTION AssocArray_Insert (ASSOCARRAY array, key$, iData)
	iKey = STRING_New (key$)
	RETURN BinTree_Add (@array.tree, iKey, iData)
END FUNCTION
'
' #########################
' #####  BinTree_Add  #####
' #########################
' Adds an item to a bin tree
' tree = the tree to add the item to
' iKey = the key used to locate the item
' iData = the item to add to the tree
' returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_Add (BINTREE tree, iKey, iData)
	BINNODE newNode

	IF tree.iHead = 0 THEN
		newNode.iKey = iKey
		newNode.iLeft = 0
		newNode.iRight = 0
		newNode.iData = iData
		tree.iHead = BINNODE_New (newNode)
		RETURN $$TRUE ' success
	END IF

	RETURN BinTree_RealAdd (tree.comparator, tree.iHead, iKey, iData)

END FUNCTION
'
' ##################################
' #####  BinTree_EndTraversal  #####
' ##################################
' Ends a BinTree traversal
' traverse = the traversal to end
' returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_EndTraversal (traverse)
	STACK traverseStack

	IFF STACK_Get (traverse, @traverseStack) THEN RETURN

	DO WHILE Stack_Pop (@traverseStack, @iData)
		BINWALK_Delete (iData)
	LOOP

	RETURN STACK_Delete (traverse)
END FUNCTION
'
' ##########################
' #####  BinTree_Find  #####
' ##########################
' Finds an item in a bin tree
' tree = the tree to find the item in
' iKey = the key of the item to locate
' iData = the variable to store the item
' returns $$TRUE if the item is found, otherwise $$FALSE
FUNCTION BinTree_Find (BINTREE tree, iKey, @iData)
	iParentNode = tree.iHead
	IF BinTree_RealFind (tree.comparator, @iParentNode, iKey, @iData) THEN RETURN $$TRUE ' found
END FUNCTION
'
' ##########################
' #####  BinTree_Init  #####
' ##########################
' Initialises a bin tree
' tree = the tree to initialise
' FnCompareNodeKeys = User comparator function for sorting keys
'                     FnCompareNodeKeys(id_1, id_2)
' FnDeleteTreeNode = User delete function: FnDeleteTreeNode(indexDelete)
' returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_Init (BINTREE tree, FUNCADDR FnCompareNodeKeys, FUNCADDR FnDeleteTreeNode)
	IFF #bReentry THEN ADT () ' Guy-07nov11-initialize Abstract Data Types library

	tree.comparator = FnCompareNodeKeys
	tree.keyDeleter = FnDeleteTreeNode
	tree.iHead = 0
	RETURN $$TRUE ' success
END FUNCTION
'
' ############################
' #####  BinTree_Remove  #####
' ############################
' Removes an item from a bin tree
' tree = the tree to remove the item from
' iKey = the key of the item to remove
' iData = the variable to store the item removed from the tree, you can use the to correctly deallocate it
' returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_Remove (BINTREE tree, iKey, @iData)
	STATIC lastMode
	BINNODE fakeNode

	iParentNode = tree.iHead
	iNode = BinTree_RealFind (tree.comparator, @iParentNode, iKey, @iData)
	IFZ iNode THEN RETURN

	IF iNode = iParentNode THEN
		' There is no parent node, so create a fake one
		fakeNode.iLeft = iNode
		iParentNode = BINNODE_New (fakeNode)
		ret = BinTree_RealRemove (tree.keyDeleter, iNode, iParentNode)
		' Now update the tree to reflect any changes to the fake node, plus don't forget to delete the fake
		BINNODE_Get (iParentNode, @fakeNode)
		BINNODE_Delete (iParentNode)
		tree.iHead = fakeNode.iLeft
	END IF

	RETURN BinTree_RealRemove (tree.keyDeleter, iNode, iParentNode)
END FUNCTION
'
' ####################################
' #####  BinTree_StartTraversal  #####
' ####################################
' Starts traversing a bintree
' order = the traversal order
' returns the id of the traversal object or 0 on fail
FUNCTION BinTree_StartTraversal (BINTREE tree, order)
	STACK traverseStack
	BINWALK traverse

	Stack_Init (@traverseStack)
	IFF BINNODE_Get (tree.iHead, @traverse.node) THEN RETURN 0
	traverse.order = order

	Stack_Push (@traverseStack, BINWALK_New (traverse))
	RETURN STACK_New (traverseStack)
END FUNCTION
'
' ##############################
' #####  BinTree_Traverse  #####
' ##############################
' Traverses a bintree according to a traversal object
' traverse = the traversal to use
' iData = the variable to store the return data
' iKey = the variable to store the key
' returns $$TRUE or $$FALSE if there are no more items in the tree
FUNCTION BinTree_Traverse (traverse, @iData, @iKey)
	STACK traverseStack
	BINWALK TOS
	BINNODE node

	IFF STACK_Get (traverse, @traverseStack) THEN RETURN

	IFF Stack_Peek (traverseStack, @iTOS) THEN RETURN
	IFF BINWALK_Get (iTOS, @TOS) THEN RETURN

	' Which item should we return?
	done = $$FALSE
	DO UNTIL done
		SELECT CASE TOS.order
			CASE $$ADT_PREORDER
				SELECT CASE TOS.nextItem
					CASE 0		' Get left node
						' get the leftmost child of the left node
						GOSUB GetLeftmostNode
						TOS.nextItem = 1
					CASE 1		' Get data
						' this case is simple
						iData = TOS.node.iData
						iKey = TOS.node.iKey
						TOS.nextItem = 2
						BINWALK_Update (iTOS, TOS)
						done = $$TRUE
					CASE 2		' Get right node
						' Get the leftmost child of the right node
						IF TOS.node.iRight THEN
							GOSUB GetRightNode

							' Get leftmost child
							GOSUB GetLeftmostNode
							TOS.nextItem = 1
						ELSE
							' This node is done
							TOS.nextItem = 3
						END IF
					CASE 3		' This node is done
						GOSUB PopJunkNode
				END SELECT
			CASE $$ADT_INORDER
				SELECT CASE TOS.nextItem
					CASE 0		' Get data
						iData = TOS.node.iData
						iKey = TOS.node.iKey
						TOS.nextItem = 1
						BINWALK_Update (iTOS, TOS)
						done = $$TRUE
					CASE 1		' Get left node
						IF TOS.node.iLeft THEN
							GOSUB GetLeftNode
							TOS.nextItem = 0
						ELSE
							TOS.nextItem = 2
						END IF
					CASE 2		' Get right node
						IF TOS.node.iRight THEN
							GOSUB GetRightNode
							TOS.nextItem = 0
						ELSE
							' This node is done
							TOS.nextItem = 3
						END IF
					CASE 3		' This node is done
						GOSUB PopJunkNode
				END SELECT
			CASE $$ADT_POSTORDER
				' Notice that I have swapped nextItem codes 2 and 3.  This is to eliminate code duplication
				SELECT CASE TOS.nextItem
					CASE 0		' Get right node
						GOSUB GetRightmostNode
						TOS.nextItem = 1
					CASE 1		' Get data
						iData = TOS.node.iData
						iKey = TOS.node.iKey
						TOS.nextItem = 3
						BINWALK_Update (iTOS, TOS)
						done = $$TRUE
					CASE 3		' Get left node
						IF TOS.node.iLeft THEN
							GOSUB GetLeftNode
							GOSUB GetRightmostNode
							TOS.nextItem = 1
						ELSE
							TOS.nextItem = 2
						END IF
					CASE 2		' This node is done
						GOSUB PopJunkNode
				END SELECT
		END SELECT
	LOOP

	STACK_Update (traverse, traverseStack)
	RETURN $$TRUE ' success

SUB GetLeftmostNode
	DO WHILE TOS.node.iLeft
		' Update the TOS
		TOS.nextItem = 1
		BINWALK_Update (iTOS, TOS)

		' Get the next node
		BINNODE_Get (TOS.node.iLeft, @TOS.node)
		iTOS = BINWALK_New (TOS)
		Stack_Push (@traverseStack, iTOS)
	LOOP
END SUB
SUB GetRightmostNode
	DO WHILE TOS.node.iRight
		' Update the TOS
		TOS.nextItem = 1
		BINWALK_Update (iTOS, TOS)

		' Get the next node
		BINNODE_Get (TOS.node.iRight, @TOS.node)
		iTOS = BINWALK_New (TOS)
		Stack_Push (@traverseStack, iTOS)
	LOOP
END SUB
SUB GetLeftNode
	' Update the TOS
	TOS.nextItem = 2
	BINWALK_Update (iTOS, TOS)

	' Get the next node
	BINNODE_Get (TOS.node.iLeft, @TOS.node)
	iTOS = BINWALK_New (TOS)
	Stack_Push (@traverseStack, iTOS)
END SUB
SUB GetRightNode
	' Update the TOS
	TOS.nextItem = 3
	BINWALK_Update (iTOS, TOS)

	' Get the next node
	BINNODE_Get (TOS.node.iRight, @TOS.node)
	iTOS = BINWALK_New (TOS)
	Stack_Push (@traverseStack, iTOS)
END SUB
SUB PopJunkNode
	BINWALK_Delete (iTos)
	IFF Stack_Pop (@traverseStack, @iTOS) THEN RETURN
	IFF Stack_Peek (traverseStack, @iTOS) THEN RETURN
	IFF BINWALK_Get (iTOS, @TOS) THEN RETURN
END SUB
END FUNCTION
'
' ############################
' #####  BinTree_Uninit  #####
' ############################
' Deallocates all the resources associated with a bin tree
' tree = the tree to uninit
' returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_Uninit (BINTREE tree)
	IF tree.iHead THEN
		tree.iHead = 0
		RETURN BinTree_RealUninit (tree.iHead, tree.keyDeleter)
	END IF
	RETURN $$TRUE ' success
END FUNCTION
'
' ############################
' #####  IStringCompare  #####
' ############################
' A case insensitive comparator for strings

'FUNCTION IStringCompare (a, b)
'	STRING_Get (a, @a$)
'	STRING_Get (b, @b$)

'	a$ = UCASE$ (a$)
'	a$ = UCASE$ (b$)

'	FOR i = 0 TO MIN (UBOUND (a$), UBOUND (b$))
'		IF a${i} < b${i} THEN RETURN -1
'		IF a${i} > b${i} THEN RETURN 1
'	NEXT
'	IF UBOUND (a$) < UBOUND (b$) THEN RETURN -1
'	IF UBOUND (a$) > UBOUND (b$) THEN RETURN 1

'	RETURN 0
'END FUNCTION

FUNCTION IStringCompare (a, b)

	STRING_Get (a, @a$)
	STRING_Get (b, @b$)

	' compare case insensitive
	aUC$ = UCASE$ (a$)
	bUC$ = UCASE$ (b$)

	upp_a = LEN (aUC$) - 1
	upp_b = LEN (bUC$) - 1

	upp = MIN (upp_a, upp_b)
	IF upp > -1 THEN
		' non-empty strings
		FOR i = 0 TO upp
			IF aUC${i} <> bUC${i} THEN
				IF aUC${i} > bUC${i} THEN
					RETURN 1		' a$ > b$
				ELSE
					RETURN -1		' a$ < b$
				ENDIF
			ENDIF
		NEXT i
	ENDIF

	IF upp_a = upp_b THEN RETURN 0		' a$ == b$

	IF upp_a > upp_b THEN
		' a$ is longer than b$
		' either a$ > b$ or a$ == b$ if a$ contains only trailing spaces
		FOR i = upp + 1 TO upp_a
			IF a${i} <> ' ' THEN RETURN 1		' a$ > b$
		NEXT i
	ELSE
		' b$ is longer than a$
		' either a$ < b$ or a$ == b$ if b$ contains only trailing spaces
		FOR i = upp + 1 TO upp_b
			IF b${i} <> ' ' THEN RETURN -1		' a$ < b$
		NEXT i
	ENDIF

	RETURN 0		' a$ == b$

END FUNCTION
'
' ########################
' #####  IntCompare  #####
' ########################
' A comparator for integers
FUNCTION IntCompare (a, b)
	' Guy-21apr11-RETURN b - a
	IF a = b THEN RETURN 0
	IF a > b THEN RETURN 1
	RETURN -1
END FUNCTION
'
' ###############################
' #####  LinkedList_Append  #####
' ###############################
' Appends an item to a linked list
' list = the linked list to append to
' iData = the data to append to the linked list
' returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_Append (LINKEDLIST list, iData)
	LINKEDNODE tail
	LINKEDNODE new

	IFF LINKEDNODE_Get (list.iTail, @tail) THEN RETURN
	new.iData = iData
	new.iNext = 0
	tail.iNext = LINKEDNODE_New (new)
	LINKEDNODE_Update (list.iTail, @tail)

	list.iTail = tail.iNext
	INC list.cItems

	RETURN $$TRUE ' success
END FUNCTION
'
' ##################################
' #####  LinkedList_DeleteAll  #####
' ##################################
' Deletes every item in a linked list
' list = the list to delete the items from
' returns $$TRUE on success or $$FALSE on fail.
FUNCTION LinkedList_DeleteAll (LINKEDLIST list)
	LINKEDNODE currNode

	' Get the head
	IFF LINKEDNODE_Get (list.iHead, @currNode) THEN RETURN

	DO WHILE currNode.iNext
		' Get the next node
		iCurrNode = currNode.iNext
		IFF LINKEDNODE_Get (iCurrNode, @currNode) THEN RETURN

		' Process this node
		IFF LINKEDNODE_Delete (iCurrNode) THEN RETURN
	LOOP

	' Update the head node
	LINKEDNODE_Get (list.iHead, @currNode)
	currNode.iNext = 0
	LINKEDNODE_Update (list.iHead, currNode)

	list.iTail = list.iHead
	list.cItems = 0
	RETURN $$TRUE ' success
END FUNCTION
'
' ###################################
' #####  LinkedList_DeleteItem  #####
' ###################################
' Deletes an item from a linked list
' list = the list to delete from
' index = the 0 based index of the item to delete
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_DeleteItem (LINKEDLIST list, index)
	LINKEDNODE previous
	LINKEDNODE currNode

	' Prevent the user from deleting the head node
	IF index < 0 THEN RETURN

	' get the previous node
	IFF LINKEDLIST_GetNode (list, index - 1, @iPrevious) THEN RETURN
	IFF LINKEDNODE_Get (iPrevious, @previous) THEN RETURN

	' Update the tail pointer if necessary
	IF previous.iNext = list.iTail THEN list.iTail = iPrevious

	' Now get the node we want to delete
	iCurrNode = previous.iNext
	IFF LINKEDNODE_Get (iCurrNode, @currNode) THEN RETURN

	' And delete
	previous.iNext = currNode.iNext
	IFF LINKEDNODE_Update (iPrevious, previous) THEN RETURN
	IFF LINKEDNODE_Delete (iCurrNode) THEN RETURN

	DEC list.cItems
	RETURN $$TRUE ' success
END FUNCTION
'
' ###################################
' #####  LinkedList_DeleteThis  #####
' ###################################
' Deletes the item LinkedList_Walk just returned
' hWalk = the walk handle
' list = the list the walk is associated with.  Need this to change item count
' returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_DeleteThis (hWalk, LINKEDLIST list)
	LINKEDNODE currNode
	LINKEDWALK walk

	IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN
	IF walk.iPrev = -1 THEN
		IFF LINKEDNODE_Get (walk.first, @currNode) THEN RETURN
		currNode.iNext = walk.iNext
		IFF LINKEDNODE_Update (walk.first, currNode) THEN RETURN
	ELSE
		IFF LINKEDNODE_Get (walk.iPrev, @currNode) THEN RETURN
		currNode.iNext = walk.iNext
		IFF LINKEDNODE_Update (walk.iPrev, currNode) THEN RETURN
	END IF

	IFF LINKEDNODE_Delete (walk.iCurrentNode) THEN RETURN
	DEC list.cItems

	RETURN $$TRUE ' success
END FUNCTION
'
' ################################
' #####  LinkedList_EndWalk  #####
' ################################
' Closes a walk handle
' hWalk = the walk handle to close
' returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_EndWalk (hWalk)
	RETURN LINKEDWALK_Delete (hWalk)
END FUNCTION
'
' ################################
' #####  LinkedList_GetItem  #####
' ################################
' Retrieves a particular item from a linked list
' list = the list to get the item from
' index = the 0 based index of the item to get
' iData = the variable to store the data
' returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_GetItem (LINKEDLIST list, index, @iData)
	LINKEDNODE node

	IFF LINKEDLIST_GetNode (list, index, @iNode) THEN RETURN
	IFF LINKEDNODE_Get (iNode, @node) THEN RETURN

	iData = node.iData
	RETURN $$TRUE ' success
END FUNCTION
'
' #############################
' #####  LinkedList_Init  #####
' #############################
' Initialises a linked list
' list = the linked list structure to initialise
' returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_Init (LINKEDLIST list)
	LINKEDNODE head

	IFF #bReentry THEN ADT () ' Guy-07nov11-initialize Abstract Data Types library

	head.iData = 0
	head.iNext = 0

	list.iHead = LINKEDNODE_New (head)
	list.iTail = list.iHead
	list.cItems = 0
	RETURN $$TRUE ' success
END FUNCTION
'
' ###############################
' #####  LinkedList_Insert  #####
' ###############################
' Inserts an item into a linked list
' list = the list to insert into
' index = the 0 based index to insert the item at
' iData = the data to insert into the list
' returns $$TRUE on succcess or $$FALSE on fail
FUNCTION LinkedList_Insert (LINKEDLIST list, index, iData)
	LINKEDNODE previous
	LINKEDNODE new

	' get the previous node
	IFF LINKEDLIST_GetNode (list, index - 1, @iPrevious) THEN RETURN
	IFF LINKEDNODE_Get (iPrevious, @previous) THEN RETURN

	new.iData = iData
	new.iNext = previous.iNext

	previous.iNext = LINKEDNODE_New (new)

	IF iPrevious = list.iTail THEN list.iTail = previous.iNext
	IFZ previous.iNext THEN RETURN

	IFF LINKEDNODE_Update (iPrevious, previous) THEN RETURN

	INC list.cItems
	RETURN $$TRUE ' success
END FUNCTION
'
' ###################################
' #####  LinkedList_IsLastNode  #####
' ###################################
' Checks to see if hWalk is on the last node
' hWalk = the walk to check
' returns $$TRUE if on last node
FUNCTION LinkedList_IsLastNode (hWalk)
	LINKEDWALK walk

	' Guy-21apr11-IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN
	IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN $$TRUE ' last node
	IFZ walk.iNext THEN RETURN $$TRUE ' last node
END FUNCTION
'
' #############################
' #####  LinkedList_Jump  #####
' #############################
' Jumps to the specified item, hence, item will be the next item returned by LinkedList_Walk
' hWalk = the walk handle
' iItem = the index of the item to jump to
' returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_Jump (hWalk, iItem)
	LINKEDNODE currNode
	LINKEDWALK walk

	IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN
	IFF LINKEDNODE_Get (walk.first, @currNode) THEN RETURN

	walk.iPrev = 0
	iNode = walk.first
	FOR i = 0 TO iItem - 1
		walk.iPrev = iNode
		iNode = currNode.iNext
		IFF LINKEDNODE_Get (currNode.iNext, @currNode) THEN RETURN
	NEXT

	iData = currNode.iData
	walk.iNext = currNode.iNext
	IFF LINKEDWALK_Update (hWalk, @walk) THEN RETURN

	RETURN $$TRUE ' success
END FUNCTION
'
' ############################
' #####  LinkedList_Map  #####
' ############################
' Calls a function for every item in a linked list.
' list = the linked list to map
' callBack = the function to map onto the list
' result = the result returned from the callback function
' returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_Map (LINKEDLIST list, FUNCADDR callBack, @result)
	LINKEDNODE currNode
	FUNCADDR func (XLONG, XLONG, XLONG)

	func = callBack

	' Get the head
	IFF LINKEDNODE_Get (list.iHead, @currNode) THEN RETURN

	i = 0
	DO WHILE currNode.iNext
		' Get the next node
		iCurrNode = currNode.iNext
		IFF LINKEDNODE_Get (iCurrNode, @currNode) THEN RETURN

		' Process this node
		IFF @func (i, currNode.iData, @result) THEN RETURN $$TRUE ' success
		INC i
	LOOP

	RETURN $$TRUE ' success
END FUNCTION
'
' ##################################
' #####  LinkedList_ResetWalk  #####
' ##################################
' Resets a walk, so the next item it returns is the first item in the list
' hWalk = the walk to reset
' returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_ResetWalk (hWalk)
	LINKEDWALK walk
	LINKEDNODE node

	IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN
	IFF LINKEDNODE_Get (walk.first, @node) THEN RETURN
	walk.iPrev = walk.first
	walk.iCurrentNode = -1
	walk.iNext = node.iNext
	RETURN LINKEDWALK_Update (hWalk, walk)
END FUNCTION
'
' ##################################
' #####  LinkedList_StartWalk  #####
' ##################################
' Initialises a walk of a linked list
' list = the list to walk
' returns a walk handle which you must pass to subsequent calls to LinkedList_Walk and LinkedList_EndWalk, or 0 on fail
FUNCTION LinkedList_StartWalk (LINKEDLIST list)
	LINKEDNODE currNode
	LINKEDWALK walk

	IFF LINKEDNODE_Get (list.iHead, @currNode) THEN RETURN 0
	walk.first = list.iHead
	walk.iPrev = list.iHead
	walk.iCurrentNode = -1
	walk.iNext = currNode.iNext
	walk.last = iTail

	RETURN LINKEDWALK_New (walk)
END FUNCTION
'
' ###############################
' #####  LinkedList_Uninit  #####
' ###############################
' Uninitialises a linked list.  Call if you are about to delete a linked list
' list = the linkedlist to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_Uninit (LINKEDLIST list)
	IFF LinkedList_DeleteAll (@list) THEN RETURN
	IFF LINKEDNODE_Delete (list.iHead) THEN RETURN
	list.iHead = 0
	list.iTail = 0
	RETURN $$TRUE ' success
END FUNCTION
'
' #############################
' #####  LinkedList_Walk  #####
' #############################
' Gets the next data item in a linked list
' hWalk = the walk handle generated with the LinkedList_StartWalk call
' iData = the variable to store the data
' returns $$TRUE if iData is valid or $$FALSE if the walk is complete or there is an error
FUNCTION LinkedList_Walk (hWalk, @iData)
	LINKEDNODE currNode
	LINKEDWALK walk

	IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN
	' ? "> ";walk.iPrev, walk.iCurrentNode, walk.iNext

	IFF LINKEDNODE_Get (walk.iNext, @currNode) THEN RETURN

	iData = currNode.iData
	walk.iPrev = walk.iCurrentNode
	walk.iCurrentNode = walk.iNext
	walk.iNext = currNode.iNext
	IFF LINKEDWALK_Update (hWalk, @walk) THEN RETURN

	RETURN $$TRUE ' success
END FUNCTION
'
' ###########################
' #####  StringCompare  #####
' ###########################
' A comparator for strings

' Guy-21apr11-new version
'FUNCTION StringCompare (a, b)
'	STRING_Get (a, @a$)
'	STRING_Get (b, @b$)

'	FOR i = 0 TO MIN (UBOUND (a$), UBOUND (b$))
'		IF a${i} < b${i} THEN RETURN -1
'		IF a${i} > b${i} THEN RETURN 1
'	NEXT
'	IF UBOUND (a$) < UBOUND (b$) THEN RETURN -1
'	IF UBOUND (a$) > UBOUND (b$) THEN RETURN 1

'	RETURN 0
'END FUNCTION

FUNCTION StringCompare (a, b)

	STRING_Get (a, @a$)
	STRING_Get (b, @b$)

	upp_a = LEN (a$) - 1
	upp_b = LEN (b$) - 1

	upp = MIN (upp_a, upp_b)
	IF upp > -1 THEN
		' non-empty strings
		FOR i = 0 TO upp
			IF a${i} <> b${i} THEN
				IF a${i} > b${i} THEN
					RETURN 1		' a$ > b$
				ELSE
					RETURN -1		' a$ < b$
				ENDIF
			ENDIF
		NEXT i
	ENDIF

	IF upp_a = upp_b THEN RETURN 0		' a$ == b$

	IF upp_a > upp_b THEN
		' a$ is longer than b$
		' either a$ > b$ or a$ == b$ if a$ contains only trailing spaces
		FOR i = upp + 1 TO upp_a
			IF a${i} <> ' ' THEN RETURN 1		' a$ > b$
		NEXT i
	ELSE
		' b$ is longer than a$
		' either a$ < b$ or a$ == b$ if b$ contains only trailing spaces
		FOR i = upp + 1 TO upp_b
			IF b${i} <> ' ' THEN RETURN -1		' a$ < b$
		NEXT i
	ENDIF

	RETURN 0		' a$ == b$

END FUNCTION
'
' ########################
' #####  Stack_Init  #####
' ########################
' Initialises a stack
' stack = the stack to initialise
' returns $$TRUE on success or $$FALSE on fail
FUNCTION Stack_Init (STACK stack)
	IFF #bReentry THEN ADT () ' Guy-07nov11-initialize Abstract Data Types library
	RETURN LinkedList_Init (@stack.list)
END FUNCTION
'
' ########################
' #####  Stack_Peek  #####
' ########################
' Peeks at an item on the stack
' stack = the stack to peek off
' iData = the variable to store the data peeked from the stack, unchanged on fail
' returns $$TRUE on success or $$FALSE on fail
FUNCTION Stack_Peek (STACK stack, @iData)
	LINKEDNODE node

	' Is the stack empty?
	IF stack.list.iHead = stack.list.iTail THEN RETURN

	IFF LINKEDNODE_Get (stack.list.iTail, @node) THEN RETURN

	iData = node.iData
	RETURN $$TRUE ' success
END FUNCTION
'
' #######################
' #####  Stack_Pop  #####
' #######################
' Pops an item off the stack
' stack = the stack to pop the data from
' iData = the variable to store the data popped off the stack, unchanged on fail
' returns $$TRUE on success or $$FALSE on fail
FUNCTION Stack_Pop (STACK stack, @iData)
	LINKEDNODE node

	' Is the stack empty?
	IF stack.list.iHead = stack.list.iTail THEN RETURN

	IFF LINKEDNODE_Get (stack.list.iTail, @node) THEN RETURN
	IFF LinkedList_DeleteItem (@stack.list, stack.list.cItems - 1) THEN RETURN

	iData = node.iData
	RETURN $$TRUE ' success
END FUNCTION
'
' ########################
' #####  Stack_Push  #####
' ########################
' Pushes an item onto the stack
' stack = the stack to push the item onto
' iData = the item to push onto the stack
' returns $$TRUE on success or $$FALSE on fail
FUNCTION Stack_Push (STACK stack, iData)
	ret = LinkedList_Append (@stack.list, iData)
	RETURN ret
END FUNCTION
'
' ##########################
' #####  Stack_Uninit  #####
' ##########################
' Uninitialises a stack, use prior to deleting
' stack = the stack to uninitialise
' returns $$TRUE on success or $$FALSE on fail
FUNCTION Stack_Uninit (STACK stack)
	RETURN LinkedList_Uninit (@stack.list)
END FUNCTION
'
' #############################
' #####  BinTree_RealAdd  #####
' #############################
' Adds an item to a bin tree
' FnCompareNodeKeys = the comparator to order the keys
' iNode = the node to add the item to
' iKey = the key for the data
' iData = the item to add
' returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_RealAdd (FUNCADDR FnCompareNodeKeys, iNode, iKey, iData)
	BINNODE node
	BINNODE newNode
	FUNCADDR comp (XLONG, XLONG)

	IFF BINNODE_Get (iNode, @node) THEN RETURN

	' Guy-10apr11-comp = FnCompareNodeKeys
	IFZ FnCompareNodeKeys THEN
		comp = &StringCompare()
	ELSE
		comp = FnCompareNodeKeys
	ENDIF
	order = @comp (iKey, node.iKey)

	IF order = 0 THEN RETURN		' duplicate key
	IF order < 0 THEN
		IFZ node.iLeft THEN
			newNode.iKey = iKey
			newNode.iLeft = 0
			newNode.iRight = 0
			newNode.iData = iData
			node.iLeft = BINNODE_New (newNode)
			' STRING_Get (iKey, @key$)
			' STRING_Get (node.iKey, @nodeKey$)
			' PRINT "Inserted ";key$;" before ";nodeKey$
			RETURN BINNODE_Update (iNode, node)
		ELSE
			RETURN BinTree_RealAdd (FnCompareNodeKeys, node.iLeft, iKey, iData)
		END IF
	ELSE
		IFZ node.iRight THEN
			newNode.iKey = iKey
			newNode.iLeft = 0
			newNode.iRight = 0
			newNode.iData = iData
			node.iRight = BINNODE_New (newNode)
			' STRING_Get (iKey, @key$)
			' STRING_Get (node.iKey, @nodeKey$)
			' PRINT "Inserted ";key$;" after ";nodeKey$
			RETURN BINNODE_Update (iNode, node)
		ELSE
			RETURN BinTree_RealAdd (FnCompareNodeKeys, node.iRight, iKey, iData)
		END IF
	END IF

	' We should never get to this point
	RETURN
END FUNCTION
'
' ##############################
' #####  BinTree_RealFind  #####
' ##############################
' Finds a particular node in a bin tree
' FnCompareNodeKeys = the comparator used to order the keys
' iParentNode = the node to search from
' iKey = the key of the node to find
' iData = the variable to store the item of the node
' returns the node with the matching key
FUNCTION BinTree_RealFind (FUNCADDR FnCompareNodeKeys, @iParentNode, iKey, @iData)
	BINNODE node
	FUNCADDR comp (XLONG, XLONG)

	IFF BINNODE_Get (iParentNode, @node) THEN RETURN 0

	comp = FnCompareNodeKeys
	order = @comp (iKey, node.iKey)

	IF order = 0 THEN		' This will only happen if this is the root node
		' PRINT "Root"
		iData = node.iData
		RETURN iParentNode
	ELSE
		' STRING_Get (iKey, @key$)
		' STRING_Get (node.iKey, @nodeKey$)
		IF order < 0 THEN
			' PRINT "Looking for ";key$;" left of ";nodeKey$
			iNode = node.iLeft
			GOSUB CheckNode
			iParentNode = iNode
		ELSE
			' PRINT "Looking for ";key$;" right of ";nodeKey$
			iNode = node.iRight
			GOSUB CheckNode
			iParentNode = iNode
		END IF
		' PRINT "Recursing"
		RETURN BinTree_RealFind (FnCompareNodeKeys, @iParentNode, iKey, @iData)
	END IF

	' We should never end up here
	RETURN 0

SUB CheckNode
	BINNODE_Get (iNode, @node)
	' STRING_Get (node.iKey, @key$)
	' PRINT " key is ";key$
	IFZ @comp (iKey, node.iKey) THEN		' this is the node
		iData = node.iData
		RETURN iNode
	END IF
END SUB
END FUNCTION
'
' ################################
' #####  BinTree_RealRemove  #####
' ################################
' Removes a node from a bin tree
' iNode = the node to remove
' iParentNode = the parent of the node to remove
' returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_RealRemove (FUNCADDR FnDeleteTreeNode, iNode, iParentNode)
	BINNODE node
	BINNODE parentNode
	BINNODE childNode
	FUNCADDR delete (XLONG)

	IFF BINNODE_Get (iNode, @node) THEN RETURN
	IFF BINNODE_Get (iParentNode, @parentNode) THEN RETURN

	delete = FnDeleteTreeNode
	SELECT CASE TRUE
		CASE (node.iLeft = 0) && (node.iRight = 0)
			' No children

			' Guy-10apr11-@delete (node.iKey)
			IF delete THEN @delete (node.iKey)
			iData = node.iData
			BINNODE_Delete (iNode)

			SELECT CASE iNode
				CASE parentNode.iLeft
					parentNode.iLeft = 0
				CASE parentNode.iRight
					parentNode.iRight = 0
			END SELECT
			BINNODE_Update (iParentNode, parentNode)
		CASE (node.iLeft = 0) || (node.iRight = 0)
			' One child

			' Get that child
			SELECT CASE TRUE
				CASE node.iLeft
					iChildNode = node.iLeft
				CASE node.iRight
					iChildNode = node.iRight
			END SELECT
			BINNODE_Get (iChildNode, @childNode)

			' Guy-10apr11-@delete (node.iKey)
			IF delete THEN @delete (node.iKey)
			iData = node.iData

			node.iKey = childNode.iKey
			node.iLeft = childNode.iLeft
			node.iRight = childNode.iRight
			node.iData = childNode.iData
			BINNODE_Update (iNode, node)
			BINNODE_Delete (iChildNode)
		CASE ELSE
			' Two children

			' which mode will we use?
			IF lastMode THEN
				lastMode = $$FALSE
				iChildNode = node.iLeft
				iParentNode = iNode
				DO
					BINNODE_Get (iChildNode, @childNode)
					IF childNode.iRight = 0 THEN
						EXIT DO
					ELSE
						iParentNode = iChildNode
						iChildNode = childNode.iRight
					END IF
				LOOP
			ELSE
				lastMode = $$TRUE
				iChildNode = node.iRight
				iParentNode = iNode
				DO
					BINNODE_Get (iChildNode, @childNode)
					IF childNode.iLeft = 0 THEN
						EXIT DO
					ELSE
						iParentNode = iChildNode
						iChildNode = childNode.iLeft
					END IF
				LOOP
			END IF

			' Guy-10apr11-@delete (node.iKey)
			IF delete THEN @delete (node.iKey)
			node.iKey = childNode.iKey
			node.iData = childNode.iData
			BINNODE_Update (iNode, node)
			childNode.iKey = 0
			BINNODE_Update (iChildNode, childNode)

			BinTree_RealRemove (FnDeleteTreeNode, iChildNode, iParentNode)
	END SELECT
END FUNCTION
'
' ################################
' #####  BinTree_RealUninit  #####
' ################################
' Deletes iNode and all its children
' iNode = the node to delete
' returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_RealUninit (iNode, FUNCADDR FnDeleteTreeNode)
	BINNODE node
	FUNCADDR delete (XLONG)

	IFF BINNODE_Get (iNode, @node) THEN RETURN
	IF node.iLeft THEN BinTree_RealUninit (node.iLeft, FnDeleteTreeNode)
	IF node.iRight THEN BinTree_RealUninit (node.iRight, FnDeleteTreeNode)

	delete = FnDeleteTreeNode
	@delete (node.iKey)

	BINNODE_Delete (iNode)

	RETURN $$TRUE ' success
END FUNCTION
'
' ################################
' #####  LINKEDLIST_GETNODE  #####
' ################################
' Gets a particular node from a linked list
' list = the list to get a node from
' index = the 0 based index of the node to get, use -1 to get the head node
' iNode = the variable to store the index to the node
' returns $$TRUE on success or $$FALSE on fail
FUNCTION LINKEDLIST_GetNode (LINKEDLIST list, index, iNode)
	LINKEDNODE node
	' Get the head node
	iThis = list.iHead

	FOR i = -1 TO index - 1
		IFF LINKEDNODE_Get (iThis, @node) THEN RETURN
		iThis = node.iNext
	NEXT

	iNode = iThis
	RETURN $$TRUE ' success
END FUNCTION
'
' === STRING class ===
'
' Initializes the STRING class
FUNCTION STRING_Init ()
	SHARED STRING_array$[]		' an array of STRING_item
	SHARED STRING_arrayUM[]		' a usage map so we can see which array elements are in use
	SHARED STRING_idMax

	IFZ STRING_array$[] THEN
		DIM STRING_array$[7]
		DIM STRING_arrayUM[7]
	ELSE
		' re-use existing STRING_array$[]
		upper_slot = UBOUND (STRING_arrayUM[])
		FOR i = 0 TO upper_slot
			STRING_array$[i] = ""
			STRING_arrayUM[i] = $$FALSE		' virtual deletion
		NEXT i
	ENDIF
	STRING_idMax = 0
END FUNCTION
'
' Deletes a STRING item using its id
' id = id of STRING item
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'bOK = STRING_Delete (id)
'IFF bOK THEN ' can't delete STRING item
'
FUNCTION STRING_Delete (id)
	SHARED STRING_array$[]
	SHARED STRING_arrayUM[]		' usage map
	SHARED STRING_idMax

	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND (STRING_arrayUM[])) THEN
		STRING_arrayUM[slot] = $$FALSE		' delete STRING item
		RETURN $$TRUE		' OK!
	ENDIF
END FUNCTION
'
' Finds a STRING item using its value
' match$ = the value to search for
' returns id on success or 0 on fail
'
' Usage:
'idFound = STRING_Find (match$)		' find exact match of match$
'IFZ idFound THEN ' can't find STRING item
'
FUNCTION STRING_Find (match$)
	SHARED STRING_array$[]
	SHARED STRING_arrayUM[]		' usage map
	SHARED STRING_idMax

	match$ = TRIM$ (match$)
	IFZ match$ THEN RETURN

	upper_slot = STRING_idMax - 1
	IF upper_slot > UBOUND (STRING_arrayUM[]) THEN upper_slot = UBOUND (STRING_arrayUM[])
	IF upper_slot < 0 THEN RETURN

	LEN_match = LEN (match$)
	FOR slot = 0 TO upper_slot
		IFF STRING_arrayUM[slot] THEN DO NEXT
		st$ = TRIM$ (STRING_array$[slot])
		IF LEN (st$) <> LEN_match THEN DO NEXT
		' find exact match
		IF st$ = match$ THEN RETURN (slot + 1)		' return id of found STRING item
	NEXT slot
END FUNCTION
'
' Finds case insensitive a STRING item using its value
' match$ = the value to search for
' returns id on success or 0 on fail
'
' Usage:
'idFound = STRING_FindIns (match$)		' find match of match$ (case insensitive)
'IFZ idFound THEN ' can't find (case insensitive) STRING item
'
FUNCTION STRING_FindIns (match$)
	SHARED STRING_array$[]
	SHARED STRING_arrayUM[]		' usage map
	SHARED STRING_idMax

	match$ = TRIM$ (match$)
	IFZ match$ THEN RETURN

	upper_slot = STRING_idMax - 1
	IF upper_slot > UBOUND (STRING_arrayUM[]) THEN upper_slot = UBOUND (STRING_arrayUM[])
	IF upper_slot < 0 THEN RETURN

	LEN_match = LEN (match$)
	find_lc$ = LCASE$ (match$)

	FOR slot = 0 TO upper_slot
		IFF STRING_arrayUM[slot] THEN DO NEXT
		st$ = TRIM$ (STRING_array$[slot])
		IF LEN (st$) <> LEN_match THEN DO NEXT
		' find case insensitive
		IF LCASE$ (st$) = find_lc$ THEN RETURN (slot + 1)		' return id of found STRING item
	NEXT slot
END FUNCTION
'
' Gets value of a STRING item using its id
' id = id of STRING item
' STRING_item$ = returned value
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'bOK = STRING_Get (id, @STRING_item$)
'IFF bOK THEN ' can't get STRING item
' or
'IFZ STRING_item$ THEN ' can't get STRING item
'
FUNCTION STRING_Get (id, @STRING_item$)
	SHARED STRING_array$[]
	SHARED STRING_arrayUM[]		' usage map
	SHARED STRING_idMax

	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND (STRING_arrayUM[])) THEN
		IF STRING_arrayUM[slot] THEN
			STRING_item$ = STRING_array$[slot]		' get STRING item
			RETURN $$TRUE		' OK!
		ENDIF
	ENDIF
	STRING_item$ = ""		' can't get STRING item
END FUNCTION
'
' Gets STRING item count
'
' Usage of STRING_Get_count(): walk thru a heavily deleted STRING pool
' IF STRING_Get_count () THEN
' idMin = STRING_Get_idMin ()
' idMax = STRING_Get_idMax ()
' FOR id = idMin TO idMax
' bOK = STRING_Get (id, @STRING_item$)
' IFF bOK THEN DO NEXT ' was deleted
' NEXT id
' ENDIF
'
FUNCTION STRING_Get_count ()
	SHARED STRING_arrayUM[]

	IFZ STRING_arrayUM[] THEN RETURN

	count = 0
	upper_slot = UBOUND (STRING_arrayUM[])
	FOR slot = 0 TO upper_slot
		IF STRING_arrayUM[slot] THEN INC count
	NEXT slot
	RETURN count
END FUNCTION
'
' Gets STRING item id max
'
' Usage: walk thru the STRING pool
'idMax = STRING_Get_idMax ()		' get STRING item id max
'FOR id = 1 TO idMax
'	bOK = STRING_Get (id, @STRING_item$)
'	IFF bOK THEN DO NEXT		' deleted
'NEXT id
'
FUNCTION STRING_Get_idMax ()
	SHARED STRING_idMax
	RETURN STRING_idMax
END FUNCTION
'
' Gets STRING item id min
'
' Usage: walk thru the STRING pool
'idMin = STRING_Get_idMin ()		' get STRING item id min
'FOR id = idMin TO STRING_Get_idMax ()
'	bOK = STRING_Get (id, @STRING_item$)
'	IFF bOK THEN DO NEXT ' was deleted
'NEXT id
'
FUNCTION STRING_Get_idMin ()
	SHARED STRING_arrayUM[]

	IFZ STRING_arrayUM[] THEN RETURN

	upper_slot = UBOUND (STRING_arrayUM[])
	FOR slot = 0 TO upper_slot
		IF STRING_arrayUM[slot] THEN RETURN (slot + 1)		' min id
	NEXT slot
END FUNCTION
'
' Adds a STRING item to STRING pool
' returns id on success or 0 on fail
'
' Usage:
'id = STRING_New (STRING_item$)
'IFZ id THEN ' can't add STRING item
'
FUNCTION STRING_New (STRING_item$)
	SHARED STRING_array$[]
	SHARED STRING_arrayUM[]		' usage map
	SHARED STRING_idMax

	IFZ STRING_arrayUM[] THEN STRING_Init ()

	upper_slot = UBOUND (STRING_arrayUM[])

	' since STRING_array$[] is oversized
	' look for a spot after STRING_idMax
	slot = -1		' spot not found
	IF STRING_idMax <= upper_slot THEN
		FOR i = STRING_idMax TO upper_slot
			IFF STRING_arrayUM[i] THEN
				' spot found!
				slot = i
				STRING_idMax = i + 1
				EXIT FOR
			ENDIF
		NEXT i
	ENDIF

	IF slot = -1 THEN
		' spot not found => expand STRING_array$[]
		upper_slot = ((upper_slot + 1) << 1) - 1
		REDIM STRING_array$[upper_slot]
		REDIM STRING_arrayUM[upper_slot]
		slot = STRING_idMax
		INC STRING_idMax
	ENDIF

	id = 0
	IF (slot >= 0) && (slot <= UBOUND (STRING_arrayUM[])) THEN
		STRING_array$[slot] = STRING_item$
		STRING_arrayUM[slot] = $$TRUE
		id = slot + 1
	ENDIF
	RETURN id		' return id
END FUNCTION
'
' Updates the value of a STRING item using its id
' id = id of STRING item
' STRING_item$ = new value
' returns $$TRUE on success or $$FALSE on fail
'
' Usage:
'bOK = STRING_Update (id, STRING_item$)
'IFF bOK THEN ' can't update STRING item
'
FUNCTION STRING_Update (id, STRING_item$)
	SHARED STRING_array$[]
	SHARED STRING_arrayUM[]		' usage map
	SHARED STRING_idMax

	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND (STRING_arrayUM[])) THEN
		IF STRING_arrayUM[slot] THEN
			STRING_array$[slot] = STRING_item$		' update STRING item
			RETURN $$TRUE		' OK!
		ENDIF
	ENDIF
END FUNCTION
DefineAccess(LINKEDNODE)
DefineAccess(LINKEDWALK)
DefineAccess(BINNODE)
DefineAccess(BINWALK)
DefineAccess(STACK)

END PROGRAM
