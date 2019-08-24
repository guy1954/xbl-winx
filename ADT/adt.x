'
'
' ####################
' #####  PROLOG  #####
' ####################
'
PROGRAM "adt"
VERSION "0.2"		' 30 May 2013
'CONSOLE
'
' ADT - Abstract Data Types library for XBLite.
' Copyright (c) LGPL 2GPL 2008 Callum Lowcay,
'                    2009-2013 Guy Lonne.
'
' ------------------------------------------------------------------------------
' The ADT library is distributed under the
' terms and conditions of the GNU LGPL, see the file COPYING_LIB
' which should be included in the WinX distribution.
' ------------------------------------------------------------------------------
'
' ***** Notes *****
'
' Requires m4 macro processing to compile.
' Also requires the accessors.m4 file.  I sugest that you copy this to your XBlite include folder and set the
'  M4PATH environment variable to the XBlite include folder.
'
' ***** Versions *****
'
' Contributors:
'     Callum Lowcay (original version)
'     Guy "GL" Lonne (evolutions)
'
' 0.1-2008-Callum Lowcay-Original version.
' 0.2-25mar11-GL-Small changes in accessors.m4.
'     04nov11-GL-Prevented adt.dll re-entry with SHARED variable #bReentry.
'     30may13-GL-Re-coded accessors.m4.
'
'
' ##############################
' #####  Import Libraries  #####
' ##############################
'
'
' XBLite headers
'
	IMPORT "xst"		' XBLite Standard Library
	IMPORT "xsx"		' XBLite Standard eXtended Library
'	IMPORT "xio"		' console library
'
'
m4_include(`accessors.m4')
'
'
' *************************
' *****  BLOCK EXPORT *****
' *************************
'
EXPORT
'
' ADT - Abstract Data Types library for XBLite
' Copyright (c) Callum Lowcay 2008 - Licensed under the GNU LGPL
' Evolutions: Guy Lonne 2009-2013.
'
' *****************************
' *****   CONSTANTS and   *****
' *****  COMPOSITE TYPES  *****
' *****************************
'
TYPE LINKEDNODE
	XLONG	.iNext
	XLONG	.iData
END TYPE

TYPE LINKEDWALK
	XLONG	.first
	XLONG	.iPrev
	XLONG	.iCurrentNode
	XLONG	.iNext
	XLONG	.last
END TYPE

TYPE LINKEDLIST
	XLONG	.iHead
	XLONG	.iTail
	XLONG	.cItems
END TYPE

TYPE BINNODE
	XLONG	.iKey
	XLONG	.iLeft
	XLONG	.iRight
	XLONG	.iData
END TYPE

TYPE BINWALK
	XLONG		.order
	XLONG		.nextItem
	BINNODE	.node
END TYPE

$$ADT_PREORDER	= 0
$$ADT_INORDER		= 1
$$ADT_POSTORDER	= 2

TYPE BINTREE
	XLONG	.iHead
	FUNCADDR	.comparator(XLONG, XLONG) ' (id_1, id_2)
	FUNCADDR	.keyDeleter(XLONG) ' (indexDelete)
END TYPE

' The stack pointer is maintained implicitly by the linked list
TYPE STACK
	LINKEDLIST	.list
END TYPE

' Associative arrays are implemented with bin trees
TYPE ASSOCARRAY
	BINTREE	.tree
END TYPE
'
'
'
' *************************
' *****   FUNCTIONS   *****
' *************************
'
'
DECLARE FUNCTION ADT () ' To be called first

DECLARE FUNCTION AssocArray_Clear (ASSOCARRAY @array)
DECLARE FUNCTION AssocArray_Delete (ASSOCARRAY @array, key$, @iData)
DECLARE FUNCTION AssocArray_Find (ASSOCARRAY array, key$, @iData)
DECLARE FUNCTION AssocArray_Init (ASSOCARRAY @array)
DECLARE FUNCTION AssocArray_Insert (ASSOCARRAY @array, key$, iData)

DECLARE FUNCTION BinTree_Add (BINTREE @tree, iKey, iData)
DECLARE FUNCTION BinTree_EndTraversal (traverse)
DECLARE FUNCTION BinTree_Find (BINTREE tree, iKey, @iData)
DECLARE FUNCTION BinTree_Init (BINTREE @tree, FUNCADDR comparator, FUNCADDR keyDeleter)
DECLARE FUNCTION BinTree_Remove (BINTREE @tree, iKey, @iData)
DECLARE FUNCTION BinTree_StartTraversal (BINTREE tree, order)
DECLARE FUNCTION BinTree_Traverse (traverse, @iData, @iKey)
DECLARE FUNCTION BinTree_Uninit (BINTREE @tree)

DECLARE FUNCTION LinkedList_Append (LINKEDLIST @list, iData)
DECLARE FUNCTION LinkedList_DeleteAll (LINKEDLIST @list)
DECLARE FUNCTION LinkedList_DeleteItem (LINKEDLIST @list, index)
DECLARE FUNCTION LinkedList_DeleteThis (hWalk, LINKEDLIST @list)
DECLARE FUNCTION LinkedList_EndWalk (hWalk)
DECLARE FUNCTION LinkedList_GetItem (LINKEDLIST list, index, @iData)
DECLARE FUNCTION LinkedList_Init (LINKEDLIST @list)
DECLARE FUNCTION LinkedList_Insert (LINKEDLIST @list, index, iData)
DECLARE FUNCTION LinkedList_IsLastNode (hWalk)
DECLARE FUNCTION LinkedList_Jump (hWalk, iItem)
DECLARE FUNCTION LinkedList_Map (LINKEDLIST list, FUNCADDR callBack, @result)
DECLARE FUNCTION LinkedList_ResetWalk (hWalk)
DECLARE FUNCTION LinkedList_StartWalk (LINKEDLIST list)
DECLARE FUNCTION LinkedList_Uninit (LINKEDLIST @list)
DECLARE FUNCTION LinkedList_Walk (hWalk, @iData)

DECLARE FUNCTION Stack_Init (STACK @stack)
DECLARE FUNCTION Stack_Peek (STACK stack, @iData)
DECLARE FUNCTION Stack_Pop (STACK @stack, @iData)
DECLARE FUNCTION Stack_Push (STACK @stack, iData)
DECLARE FUNCTION Stack_Uninit (STACK @stack)

DECLARE FUNCTION STRING_Delete (id) ' delete STRING item
DECLARE FUNCTION STRING_Get (id, @item$) ' get STRING item
DECLARE FUNCTION STRING_Init () ' STRING Pool initialization
DECLARE FUNCTION STRING_New (item$) ' add a new item to STRING Pool
DECLARE FUNCTION STRING_Update (id, item$) ' update STRING item
DECLARE FUNCTION STRING_Extract$ (text$, start, end) ' extract a sub-string
DECLARE FUNCTION STRING_GetQuotedText (text$, pos1Quote, @lit$) ' extract a quoted text from a string

DECLARE FUNCTION IntCompare (a, b)
DECLARE FUNCTION StringCompare (a, b)
DECLARE FUNCTION IStringCompare (a, b)

END EXPORT


DECLARE FUNCTION BinTree_RealAdd (FUNCADDR comparator, iNode, iKey, iData)
DECLARE FUNCTION BinTree_RealFind (FUNCADDR comparator, @iParentNode, iKey, @iData)
DECLARE FUNCTION BinTree_RealRemove (FUNCADDR keyDeleter, iNode, iParentNode)
DECLARE FUNCTION BinTree_RealUninit (iNode, FUNCADDR keyDeleter)

DECLARE FUNCTION LINKEDLIST_GetNode (LINKEDLIST list, index, iNode)

DeclareAccess(LINKEDNODE)

DeclareAccess(LINKEDWALK)

DeclareAccess(BINNODE)

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

	IF #bReentry THEN RETURN $$FALSE		' enter once...
	#bReentry = $$TRUE		' ...and then no more

	STRING_Init ()
	LINKEDNODE_Init ()
	LINKEDWALK_Init ()
	BINNODE_Init ()
	BINWALK_Init ()
	STACK_Init ()
	RETURN $$FALSE		' success

END FUNCTION
'
' ##############################
' #####  AssocArray_Clear  #####
' ##############################
' Deletes all the items in an associative array so you can safely delete the array
' array = the array to clear
' Returns $$TRUE on success or $$FALSE on fail
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
' Returns $$TRUE on success or $$FALSE on fail
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
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION AssocArray_Find (ASSOCARRAY array, key$, @iData)
	iKey = STRING_New (key$)
	bFound = BinTree_Find (@array.tree, iKey, @iData)
	IF bFound THEN STRING_Delete (iKey)
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
' Returns $$TRUE on success or $$FALSE on fail
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
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_Add (BINTREE tree, iKey, iData)
	BINNODE newNode

	bOK = $$FALSE
	IFZ tree.iHead THEN
		newNode.iKey = iKey
		newNode.iLeft = 0
		newNode.iRight = 0
		newNode.iData = iData
		tree.iHead = BINNODE_New (newNode)
		bOK = $$TRUE		' success
	ELSE
		bOK = BinTree_RealAdd (tree.comparator, tree.iHead, iKey, iData)
	ENDIF
	RETURN bOK
END FUNCTION
'
' ##################################
' #####  BinTree_EndTraversal  #####
' ##################################
' Ends a BinTree traversal
' traverse = the traversal to end
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_EndTraversal (traverse)
	STACK traverseStack

	IFF STACK_Get (traverse, @traverseStack) THEN RETURN $$FALSE

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
' Returns $$TRUE if the item is found, otherwise $$FALSE
FUNCTION BinTree_Find (BINTREE tree, iKey, @iData)
	iParentNode = tree.iHead
	bFound = BinTree_RealFind (tree.comparator, @iParentNode, iKey, @iData)
	RETURN bFound
END FUNCTION
'
' ##########################
' #####  BinTree_Init  #####
' ##########################
' Initialises a bin tree
' tree = the tree to initialise
' comparator = User comparator function for sorting keys
'                     comparator(id_1, id_2)
' keyDeleter = User delete function: keyDeleter(indexDelete)
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_Init (BINTREE tree, FUNCADDR comparator, FUNCADDR keyDeleter)
	IFF #bReentry THEN ADT ()		' 0.2-initialize Abstract Data Types library

	tree.comparator = comparator
	tree.keyDeleter = keyDeleter
	tree.iHead = 0
	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  BinTree_Remove  #####
' ############################
' Removes an item from a bin tree
' tree = the tree to remove the item from
' iKey = the key of the item to remove
' iData = the variable to store the item removed from the tree, you can use the to correctly deallocate it
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_Remove (BINTREE tree, iKey, @iData)
	STATIC lastMode
	BINNODE fakeNode

	iParentNode = tree.iHead
	iNode = BinTree_RealFind (tree.comparator, @iParentNode, iKey, @iData)
	IFZ iNode THEN RETURN $$FALSE

	IF iNode = iParentNode THEN
		' There is no parent node, so create a fake one
		fakeNode.iLeft = iNode
		iParentNode = BINNODE_New (fakeNode)
		ret = BinTree_RealRemove (tree.keyDeleter, iNode, iParentNode)
		' Now update the tree to reflect any changes to the fake node, plus don't forget to delete the fake
		BINNODE_Get (iParentNode, @fakeNode)
		BINNODE_Delete (iParentNode)
		tree.iHead = fakeNode.iLeft
	ENDIF

	RETURN BinTree_RealRemove (tree.keyDeleter, iNode, iParentNode)
END FUNCTION
'
' ####################################
' #####  BinTree_StartTraversal  #####
' ####################################
' Starts traversing a bintree
' order = the traversal order
' Returns the ID of the traversal object or 0 on fail
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
' Returns $$TRUE or $$FALSE if there are no more items in the tree
FUNCTION BinTree_Traverse (traverse, @iData, @iKey)
	STACK traverseStack
	BINWALK TOS
	BINNODE node

	IFF STACK_Get (traverse, @traverseStack) THEN RETURN $$FALSE

	IFF Stack_Peek (traverseStack, @iTOS) THEN RETURN $$FALSE
	IFF BINWALK_Get (iTOS, @TOS) THEN RETURN $$FALSE

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
						ENDIF
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
						ENDIF
					CASE 2		' Get right node
						IF TOS.node.iRight THEN
							GOSUB GetRightNode
							TOS.nextItem = 0
						ELSE
							' This node is done
							TOS.nextItem = 3
						ENDIF
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
						ENDIF
					CASE 2		' This node is done
						GOSUB PopJunkNode
				END SELECT
		END SELECT
	LOOP

	STACK_Update (traverse, traverseStack)
	RETURN $$TRUE		' success

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
	IFF Stack_Pop (@traverseStack, @iTOS) THEN RETURN $$FALSE
	IFF Stack_Peek (traverseStack, @iTOS) THEN RETURN $$FALSE
	IFF BINWALK_Get (iTOS, @TOS) THEN RETURN $$FALSE
END SUB
END FUNCTION
'
' ############################
' #####  BinTree_Uninit  #####
' ############################
' Deallocates all the resources associated with a bin tree
' tree = the tree to uninit
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_Uninit (BINTREE tree)
	IF tree.iHead THEN
		tree.iHead = 0
		RETURN BinTree_RealUninit (tree.iHead, tree.keyDeleter)
	ENDIF
	RETURN $$TRUE		' success
END FUNCTION
'
' ###############################
' #####  LinkedList_Append  #####
' ###############################
' Appends an item to a linked list
' list = the linked list to append to
' iData = the data to append to the linked list
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_Append (LINKEDLIST list, iData)
	LINKEDNODE tail
	LINKEDNODE new

	IFF LINKEDNODE_Get (list.iTail, @tail) THEN RETURN $$FALSE
	new.iData = iData
	new.iNext = 0
	tail.iNext = LINKEDNODE_New (new)
	LINKEDNODE_Update (list.iTail, @tail)

	list.iTail = tail.iNext
	INC list.cItems

	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  LinkedList_DeleteAll  #####
' ##################################
' Deletes every item in a linked list
' list = the list to delete the items from
' Returns $$TRUE on success or $$FALSE on fail.
FUNCTION LinkedList_DeleteAll (LINKEDLIST list)
	LINKEDNODE currNode

	' Get the head
	IFF LINKEDNODE_Get (list.iHead, @currNode) THEN RETURN $$FALSE

	DO WHILE currNode.iNext
		' Get the next node
		iCurrNode = currNode.iNext
		IFF LINKEDNODE_Get (iCurrNode, @currNode) THEN RETURN $$FALSE

		' Process this node
		IFF LINKEDNODE_Delete (iCurrNode) THEN RETURN $$FALSE
	LOOP

	' Update the head node
	LINKEDNODE_Get (list.iHead, @currNode)
	currNode.iNext = 0
	LINKEDNODE_Update (list.iHead, currNode)

	list.iTail = list.iHead
	list.cItems = 0
	RETURN $$TRUE		' success
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
	IF index < 0 THEN RETURN $$FALSE

	' get the previous node
	IFF LINKEDLIST_GetNode (list, index - 1, @iPrevious) THEN RETURN $$FALSE
	IFF LINKEDNODE_Get (iPrevious, @previous) THEN RETURN $$FALSE

	' Update the tail pointer if necessary
	IF previous.iNext = list.iTail THEN list.iTail = iPrevious

	' Now get the node we want to delete
	iCurrNode = previous.iNext
	IFF LINKEDNODE_Get (iCurrNode, @currNode) THEN RETURN $$FALSE

	' And delete
	previous.iNext = currNode.iNext
	IFF LINKEDNODE_Update (iPrevious, previous) THEN RETURN $$FALSE
	IFF LINKEDNODE_Delete (iCurrNode) THEN RETURN $$FALSE

	DEC list.cItems
	RETURN $$TRUE		' success
END FUNCTION
'
' ###################################
' #####  LinkedList_DeleteThis  #####
' ###################################
' Deletes the item LinkedList_Walk just returned
' hWalk = the walk handle
' list = the list the walk is associated with.  Need this to change item count
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_DeleteThis (hWalk, LINKEDLIST list)
	LINKEDNODE currNode
	LINKEDWALK walk

	IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN $$FALSE
	IF walk.iPrev < 0 THEN
		IFF LINKEDNODE_Get (walk.first, @currNode) THEN RETURN $$FALSE
		currNode.iNext = walk.iNext
		IFF LINKEDNODE_Update (walk.first, currNode) THEN RETURN $$FALSE
	ELSE
		IFF LINKEDNODE_Get (walk.iPrev, @currNode) THEN RETURN $$FALSE
		currNode.iNext = walk.iNext
		IFF LINKEDNODE_Update (walk.iPrev, currNode) THEN RETURN $$FALSE
	ENDIF

	IFF LINKEDNODE_Delete (walk.iCurrentNode) THEN RETURN $$FALSE
	DEC list.cItems

	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  LinkedList_EndWalk  #####
' ################################
' Closes a walk handle
' hWalk = the walk handle to close
' Returns $$TRUE on success or $$FALSE on fail
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
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_GetItem (LINKEDLIST list, index, @iData)
	LINKEDNODE node

	IFF LINKEDLIST_GetNode (list, index, @iNode) THEN RETURN $$FALSE
	IFF LINKEDNODE_Get (iNode, @node) THEN RETURN $$FALSE

	iData = node.iData
	RETURN $$TRUE		' success
END FUNCTION
'
' #############################
' #####  LinkedList_Init  #####
' #############################
' Initialises a linked list
' list = the linked list structure to initialise
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_Init (LINKEDLIST list)
	LINKEDNODE head

	IFF #bReentry THEN ADT ()		' 0.2-initialize Abstract Data Types library

	head.iData = 0
	head.iNext = 0

	list.iHead = LINKEDNODE_New (head)
	list.iTail = list.iHead
	list.cItems = 0
	RETURN $$TRUE		' success
END FUNCTION
'
' ###############################
' #####  LinkedList_Insert  #####
' ###############################
' Inserts an item into a linked list
' list = the list to insert into
' index = the 0 based index to insert the item at
' iData = the data to insert into the list
' Returns $$TRUE on succcess or $$FALSE on fail
FUNCTION LinkedList_Insert (LINKEDLIST list, index, iData)
	LINKEDNODE previous
	LINKEDNODE new

	' get the previous node
	IFF LINKEDLIST_GetNode (list, index - 1, @iPrevious) THEN RETURN $$FALSE
	IFF LINKEDNODE_Get (iPrevious, @previous) THEN RETURN $$FALSE

	new.iData = iData
	new.iNext = previous.iNext

	previous.iNext = LINKEDNODE_New (new)

	IF iPrevious = list.iTail THEN list.iTail = previous.iNext
	IFZ previous.iNext THEN RETURN $$FALSE

	IFF LINKEDNODE_Update (iPrevious, previous) THEN RETURN $$FALSE

	INC list.cItems
	RETURN $$TRUE		' success
END FUNCTION
'
' ###################################
' #####  LinkedList_IsLastNode  #####
' ###################################
' Checks to see if hWalk is on the last node
' hWalk = the walk to check
' Returns $$TRUE if on last node
FUNCTION LinkedList_IsLastNode (hWalk)
	LINKEDWALK walk

	bLast = $$FALSE		' regular node
	IFF LINKEDWALK_Get (hWalk, @walk) THEN
		bLast = $$TRUE		' last node
	ELSE
		IFZ walk.iNext THEN bLast = $$TRUE		' last node
	ENDIF
	RETURN bLast
END FUNCTION
'
' #############################
' #####  LinkedList_Jump  #####
' #############################
' Jumps to the specified item, hence, item will be the next item returned by LinkedList_Walk
' hWalk = the walk handle
' iItem = the index of the item to jump to
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_Jump (hWalk, iItem)
	LINKEDNODE currNode
	LINKEDWALK walk

	IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN $$FALSE
	IFF LINKEDNODE_Get (walk.first, @currNode) THEN RETURN $$FALSE

	walk.iPrev = 0
	iNode = walk.first
	FOR i = 0 TO iItem - 1
		walk.iPrev = iNode
		iNode = currNode.iNext
		IFF LINKEDNODE_Get (currNode.iNext, @currNode) THEN RETURN $$FALSE
	NEXT i

	iData = currNode.iData
	walk.iNext = currNode.iNext
	IFF LINKEDWALK_Update (hWalk, @walk) THEN RETURN $$FALSE

	RETURN $$TRUE		' success
END FUNCTION
'
' ############################
' #####  LinkedList_Map  #####
' ############################
' Calls a function for every item in a linked list.
' list = the linked list to map
' callBack = the function to map onto the list
' result = the result returned from the callback function
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_Map (LINKEDLIST list, FUNCADDR callBack, @result)
	LINKEDNODE currNode
	FUNCADDR func (XLONG, XLONG, XLONG)

	func = callBack

	' Get the head
	IFF LINKEDNODE_Get (list.iHead, @currNode) THEN RETURN $$FALSE

	i = 0
	DO WHILE currNode.iNext
		' Get the next node
		iCurrNode = currNode.iNext
		IFF LINKEDNODE_Get (iCurrNode, @currNode) THEN RETURN $$FALSE

		' Process this node
		IFF @func (i, currNode.iData, @result) THEN RETURN $$TRUE		' success
		INC i
	LOOP

	RETURN $$TRUE		' success
END FUNCTION
'
' ##################################
' #####  LinkedList_ResetWalk  #####
' ##################################
' Resets a walk, so the next item it returns is the first item in the list
' hWalk = the walk to reset
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_ResetWalk (hWalk)
	LINKEDWALK walk
	LINKEDNODE node

	IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN $$FALSE
	IFF LINKEDNODE_Get (walk.first, @node) THEN RETURN $$FALSE
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
' Returns a walk handle which you must pass to subsequent calls to LinkedList_Walk and LinkedList_EndWalk,
' or 0 on fail.
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
' Uninitialises a linked list.
' Call if you are about to delete a linked list
' list = the linkedlist to delete
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION LinkedList_Uninit (LINKEDLIST list)
	IFF LinkedList_DeleteAll (@list) THEN RETURN $$FALSE
	IFF LINKEDNODE_Delete (list.iHead) THEN RETURN $$FALSE
	list.iHead = 0
	list.iTail = 0
	RETURN $$TRUE		' success
END FUNCTION
'
' #############################
' #####  LinkedList_Walk  #####
' #############################
' Gets the next data item in a linked list
' hWalk = the walk handle generated with the LinkedList_StartWalk call
' iData = the variable to store the data
' Returns $$TRUE if iData is valid,
' or $$FALSE if the walk is complete or there is an error.
FUNCTION LinkedList_Walk (hWalk, @iData)
	LINKEDNODE currNode
	LINKEDWALK walk

	IFF LINKEDWALK_Get (hWalk, @walk) THEN RETURN $$FALSE
	'? "> ";walk.iPrev, walk.iCurrentNode, walk.iNext

	IFF LINKEDNODE_Get (walk.iNext, @currNode) THEN RETURN $$FALSE

	iData = currNode.iData
	walk.iPrev = walk.iCurrentNode
	walk.iCurrentNode = walk.iNext
	walk.iNext = currNode.iNext
	IFF LINKEDWALK_Update (hWalk, @walk) THEN RETURN $$FALSE

	RETURN $$TRUE		' success
END FUNCTION
'
' ########################
' #####  Stack_Init  #####
' ########################
' Initialises a stack
' stack = the stack to initialise
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION Stack_Init (STACK stack)
	IFF #bReentry THEN ADT ()		' 0.2-initialize Abstract Data Types library
	RETURN LinkedList_Init (@stack.list)
END FUNCTION
'
' ########################
' #####  Stack_Peek  #####
' ########################
' Peeks at an item on the stack
' stack = the stack to peek off
' iData = the variable to store the data peeked from the stack, unchanged on fail
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION Stack_Peek (STACK stack, @iData)
	LINKEDNODE node

	' Is the stack empty?
	IF stack.list.iHead = stack.list.iTail THEN RETURN $$FALSE

	IFF LINKEDNODE_Get (stack.list.iTail, @node) THEN RETURN $$FALSE

	iData = node.iData
	RETURN $$TRUE		' success
END FUNCTION
'
' #######################
' #####  Stack_Pop  #####
' #######################
' Pops an item off the stack
' stack = the stack to pop the data from
' iData = the variable to store the data popped off the stack, unchanged on fail
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION Stack_Pop (STACK stack, @iData)
	LINKEDNODE node

	' Is the stack empty?
	IF stack.list.iHead = stack.list.iTail THEN RETURN $$FALSE

	IFF LINKEDNODE_Get (stack.list.iTail, @node) THEN RETURN $$FALSE
	IFF LinkedList_DeleteItem (@stack.list, stack.list.cItems - 1) THEN RETURN $$FALSE

	iData = node.iData
	RETURN $$TRUE		' success
END FUNCTION
'
' ########################
' #####  Stack_Push  #####
' ########################
' Pushes an item onto the stack
' stack = the stack to push the item onto
' iData = the item to push onto the stack
' Returns $$TRUE on success or $$FALSE on fail
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
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION Stack_Uninit (STACK stack)
	RETURN LinkedList_Uninit (@stack.list)
END FUNCTION
'
' Deletes an item from STRING Pool.
' id = ID of the item to delete
' returns bOK: $$TRUE on success.
'
' Usage:
'	bOK = STRING_Delete (id)
'	IFF bOK THEN
'		msg$ = "STRING_Delete: Can't delete the item of ID = " + STRING$ (id)
'		PRINT msg$
'	ENDIF
'
FUNCTION STRING_Delete (id)
	SHARED STRINGarray$[]
	SHARED UBYTE STRINGarrayUM[]

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND (STRINGarrayUM[])) THEN
		STRINGarray$[slot] = ""
		STRINGarrayUM[slot] = $$FALSE
		bOK = $$TRUE
	ENDIF
	RETURN bOK
END FUNCTION
'
' Gets STRING item from the STRING Pool.
' id = ID of the item to get
' item$ = returned item
' returns bOK: $$TRUE on success.
'
' Usage:
'	bOK = STRING_Get (id, @item$)
'	IFF bOK THEN
'		msg$ = "STRING_Get: Can't get the item of ID = " + STRING$ (id)
'		PRINT msg$
'	ENDIF
'
FUNCTION STRING_Get (id, @item$)
	SHARED STRINGarray$[]
	SHARED UBYTE STRINGarrayUM[]

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND (STRINGarrayUM[])) THEN
		IF STRINGarrayUM[slot] THEN
			item$ = STRINGarray$[slot]
			bOK = $$TRUE
		ENDIF
	ENDIF
	IFF bOK THEN
		item$ = ""
	ENDIF
	RETURN bOK
END FUNCTION
'
' Initializes the STRING Pool.
'
FUNCTION STRING_Init ()
	SHARED STRINGarray$[]  ' array of STRING items
	SHARED UBYTE STRINGarrayUM[] ' usage map so we can see which STRINGarray$[] elements are in use

	IFZ STRINGarray$[] THEN
		DIM STRINGarray$[7]
		DIM STRINGarrayUM[7]
	ENDIF
	FOR slot = UBOUND (STRINGarrayUM[]) TO 0 STEP -1
		STRINGarray$[slot] = ""
		STRINGarrayUM[slot] = $$FALSE
	NEXT slot
END FUNCTION
'
' Adds a new item to STRING Pool.
' returns the new item ID, 0 on fail.
'
' Usage:
'	id = STRING_New (item$)
'	IFZ id THEN
'		msg$ = "STRING_New: Can't add a new item to STRING Pool " + item$
'		PRINT msg$
'	ENDIF
'
FUNCTION STRING_New (item$)
	SHARED STRINGarray$[]
	SHARED UBYTE STRINGarrayUM[]

	IFZ STRINGarrayUM[] THEN STRING_Init ()
	IFZ TRIM$ (item$) THEN RETURN

	slot = -1

	' find an open slot
	upper_slot = UBOUND (STRINGarrayUM[])
	FOR i = 0 TO upper_slot
		IFF STRINGarrayUM[i] THEN
			' reuse this open slot
			slot = i
			EXIT FOR
		ENDIF
	NEXT i

	IF slot < 0 THEN
		' no open slots found => add a bunch of new open slots
		slot = upper_slot + 1
		'
		' expand both STRINGarray$[] and STRINGarrayUM[]
		upp = (slot << 1) | 3
		REDIM STRINGarray$[upp]
		REDIM STRINGarrayUM[upp]
	ENDIF

	IF slot >= 0 THEN
		STRINGarray$[slot] = item$
		STRINGarrayUM[slot] = $$TRUE
	ENDIF
	RETURN (slot + 1)
END FUNCTION
'
FUNCTION STRING_Update (id, item$)
	SHARED STRINGarray$[]
	SHARED UBYTE STRINGarrayUM[]

	bOK = $$FALSE
	slot = id - 1
	IF (slot >= 0) && (slot <= UBOUND (STRINGarrayUM[])) THEN
		IF STRINGarrayUM[slot] THEN
			STRINGarray$[slot] = item$
			bOK = $$TRUE
		ENDIF
	ENDIF
	RETURN bOK
END FUNCTION
'
' #############################
' #####  STRING_Extract$  #####
' #############################
'
' Extracts a sub-string from a string.
'
' string$  = the passed string
' start  = position of the first character of the sub-string
'             < 1 indicates "first character"
' end    = position of the last character of the sub-string
'             < 1 indicates "up to the last character"
'
' Usage:
'posSepPrev = 0
'posSep = INSTR (csv$, ",")
'
'DO WHILE posSep > 1
'	' extract the next CSV field
'	start = posSepPrev + 1
'	end = posSep - 1
'	'
'	field$ = STRING_Extract$ (csv$, start, end)
'	'
'	' (...)
'	'
'	posSepPrev = posSep
'	posSep = INSTR (csv$, ",", posSep+1)
'	'
'LOOP
'
FUNCTION STRING_Extract$ (text$, start, end)

	IF start < 1 THEN start = 1

	IF end < start THEN end = LEN (text$)
	IF end > LEN (text$) THEN end = LEN (text$)

	IF end < start THEN
		ret$ = ""
	ELSE
		length = end - start + 1
		ret$ = TRIM$ (MID$ (text$, start, length))
	ENDIF

	RETURN ret$

END FUNCTION
'
' ##################################
' #####  STRING_GetQuotedText  #####
' ##################################
'
' Extracts a quoted text from a string.
'
' text$     = the passed string
' pos1Quote = position of the first double-quote
'             < 1 indicates "first character"
' r_lit$    = returned literal
'
' Returns bOK: $$TRUE if it has extracted the literal successfully.
'
FUNCTION STRING_GetQuotedText (text$, pos1Quote, @r_lit$)

	bOK = $$FALSE

	final = LEN (text$)		' 0 offset to null-terminator
	SELECT CASE final
		CASE 0		' the passed string is empty
			r_lit$ = ""
			'
		CASE ELSE
			IF (pos1Quote <= 0) THEN pos1Quote = 1
			'
			GOSUB double_quote
			'
	END SELECT

	RETURN bOK

SUB double_quote

	start = pos1Quote		' 1 offset to opening double-quote
	IF (text${pos1Quote - 1} <> '"') THEN
		IF (start > 0) THEN DEC start		' not starting by a "
	ENDIF

	prevChar = 0 : cCh = 0
	FOR scans = start TO final
		IF (text${scans} = '"') THEN
			IF (prevChar <> '\\') THEN
				IF (text${pos1Quote - 1} = '"') THEN bOK = $$TRUE		' OK!
				EXIT FOR
			ENDIF
		ENDIF
		INC cCh
		prevChar = text${scans}
	NEXT scans

	IFZ cCh THEN
		r_lit$ = ""
	ELSE
		r_lit$ = MID$ (text$, (start + 1), cCh)
	ENDIF

END SUB

END FUNCTION
'
' ########################
' #####  IntCompare  #####
' ########################
' A comparator for integers
FUNCTION IntCompare (a, b)
	' GL-21apr11-RETURN b - a
	IF a = b THEN
		ret = 0
	ELSE
		IF a > b THEN ret = 1 ELSE ret = -1
	ENDIF
	RETURN ret
END FUNCTION
'
' ###########################
' #####  StringCompare  #####
' ###########################
' A comparator for strings
'
' 0.2-old---
' FUNCTION StringCompare (a, b)
' STRING_Get (a, @a$)
' STRING_Get (b, @b$)
'
' FOR i = 0 TO MIN (UBOUND (a$), UBOUND (b$))
' 	IF a${i} < b${i} THEN RETURN -1
' 	IF a${i} > b${i} THEN RETURN 1
' NEXT i
' IF UBOUND (a$) < UBOUND (b$) THEN RETURN -1
' IF UBOUND (a$) > UBOUND (b$) THEN RETURN 1
'
' RETURN 0
' END FUNCTION
' 0.2-old~~~
' 0.2-new+++
FUNCTION StringCompare (a, b)
	STRING_Get (a, @a$)
	STRING_Get (b, @b$)

	upp_a = LEN (a$) - 1
	upp_b = LEN (b$) - 1

	' compare the characters up to the smaller length (but not zero)
	upperMin = MIN (upp_a, upp_b)
	IF upperMin > -1 THEN
		' non-empty strings
		FOR i = 0 TO upperMin
			IF a${i} = b${i} THEN DO NEXT
			'
			IF a${i} > b${i} THEN
				RETURN 1		' a$ > b$
			ELSE
				RETURN -1		' a$ < b$
			ENDIF
		NEXT i
	ENDIF

	SELECT CASE TRUE
		CASE upp_a = upp_b
			'
		CASE upp_a > upp_b
			' a$ is longer than b$
			FOR i = upperMin + 1 TO upp_a
				IF a${i} <> ' ' THEN RETURN 1		' a$ > b$
			NEXT i
			' a$ contains only trailing spaces
			'
		CASE ELSE
			' b$ is longer than a$
			FOR i = upperMin + 1 TO upp_b
				IF b${i} <> ' ' THEN RETURN -1		' a$ < b$
			NEXT i
			' b$ contains only trailing spaces
			'
	END SELECT
	RETURN 0		' a$ == b$
END FUNCTION
' 0.2-new~~~
'
' ############################
' #####  IStringCompare  #####
' ############################
' A case insensitive comparator for strings
'
' 0.2-old---
'FUNCTION IStringCompare (a, b)
'	STRING_Get (a, @a$)
'	STRING_Get (b, @b$)
'
'	a$ = UCASE$ (a$)
'	a$ = UCASE$ (b$)
'
'	FOR i = 0 TO MIN (UBOUND (a$), UBOUND (b$))
'		IF a${i} < b${i} THEN RETURN -1
'		IF a${i} > b${i} THEN RETURN 1
'	NEXT i
'	IF UBOUND (a$) < UBOUND (b$) THEN RETURN -1
'	IF UBOUND (a$) > UBOUND (b$) THEN RETURN 1
'
'	RETURN 0
'END FUNCTION
' 0.2-old~~~
' 0.2-new+++
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
' 0.2-new~~~
'
' #############################
' #####  BinTree_RealAdd  #####
' #############################
' Adds an item to a bin tree
' comparator = the comparator to order the keys
' iNode = the node to add the item to
' iKey = the key for the data
' iData = the item to add
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_RealAdd (FUNCADDR comparator, iNode, iKey, iData)
	BINNODE node
	BINNODE newNode
	FUNCADDR comp (XLONG, XLONG)

	IFF BINNODE_Get (iNode, @node) THEN RETURN $$FALSE

	IFZ comparator THEN
		comp = &StringCompare ()
	ELSE
		comp = comparator
	ENDIF
	order = @comp (iKey, node.iKey)
	IFZ order THEN RETURN $$FALSE		' duplicate key
	IF order < 0 THEN
		IFZ node.iLeft THEN
			newNode.iKey = iKey
			newNode.iLeft = 0
			newNode.iRight = 0
			newNode.iData = iData
			node.iLeft = BINNODE_New (newNode)
'			STRING_Get (iKey, @key$)
'			STRING_Get (node.iKey, @nodeKey$)
'			PRINT "Inserted ";key$;" before ";nodeKey$
			RETURN BINNODE_Update (iNode, node)
		ELSE
			RETURN BinTree_RealAdd (comparator, node.iLeft, iKey, iData)
		ENDIF
	ELSE
		IFZ node.iRight THEN
			newNode.iKey = iKey
			newNode.iLeft = 0
			newNode.iRight = 0
			newNode.iData = iData
			node.iRight = BINNODE_New (newNode)
'			STRING_Get (iKey, @key$)
'			STRING_Get (node.iKey, @nodeKey$)
'			PRINT "Inserted ";key$;" after ";nodeKey$
			RETURN BINNODE_Update (iNode, node)
		ELSE
			RETURN BinTree_RealAdd (comparator, node.iRight, iKey, iData)
		ENDIF
	ENDIF

	' We should never get to this point
	RETURN $$FALSE		' fail
END FUNCTION
'
' ##############################
' #####  BinTree_RealFind  #####
' ##############################
' Finds a particular node in a bin tree
' comparator = the comparator used to order the keys
' iParentNode = the node to search from
' iKey = the key of the node to find
' iData = the variable to store the item of the node
' Returns the node with the matching key
FUNCTION BinTree_RealFind (FUNCADDR comparator, @iParentNode, iKey, @iData)
	BINNODE node
	FUNCADDR comp (XLONG, XLONG)

	IFF BINNODE_Get (iParentNode, @node) THEN RETURN 0

	IFZ comparator THEN
		comp = &StringCompare ()
	ELSE
		comp = comparator
	ENDIF
	order = @comp (iKey, node.iKey)
	IFZ order THEN
		' This will only happen if this is the root node
'		PRINT "Root"
		iData = node.iData
		RETURN iParentNode
	ELSE
'		STRING_Get (iKey, @key$)
'		STRING_Get (node.iKey, @nodeKey$)
		IF order < 0 THEN
'			PRINT "Looking for ";key$;" left of ";nodeKey$
			iNode = node.iLeft
			GOSUB CheckNode
			iParentNode = iNode
		ELSE
'			PRINT "Looking for ";key$;" right of ";nodeKey$
			iNode = node.iRight
			GOSUB CheckNode
			iParentNode = iNode
		ENDIF
'		PRINT "Recursing"
		RETURN BinTree_RealFind (comparator, @iParentNode, iKey, @iData)
	ENDIF

	' We should never end up here
	RETURN 0

SUB CheckNode
	BINNODE_Get (iNode, @node)
'	STRING_Get (node.iKey, @key$)
'	PRINT " key is ";key$
	IFZ @comp (iKey, node.iKey) THEN
		' this is the node
		iData = node.iData
		RETURN iNode
	ENDIF
END SUB
END FUNCTION
'
' ################################
' #####  BinTree_RealRemove  #####
' ################################
' Removes a node from a bin tree
' iNode = the node to remove
' iParentNode = the parent of the node to remove
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_RealRemove (FUNCADDR keyDeleter, iNode, iParentNode)
	BINNODE node
	BINNODE parentNode
	BINNODE childNode
	FUNCADDR delete (XLONG)

	IFF BINNODE_Get (iNode, @node) THEN RETURN $$FALSE
	IFF BINNODE_Get (iParentNode, @parentNode) THEN RETURN $$FALSE

	delete = keyDeleter
	SELECT CASE TRUE
		CASE (node.iLeft = 0) && (node.iRight = 0)
			' No children

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
					ENDIF
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
					ENDIF
				LOOP
			ENDIF

			IF delete THEN @delete (node.iKey)
			node.iKey = childNode.iKey
			node.iData = childNode.iData
			BINNODE_Update (iNode, node)
			childNode.iKey = 0
			BINNODE_Update (iChildNode, childNode)

			BinTree_RealRemove (keyDeleter, iChildNode, iParentNode)
	END SELECT
END FUNCTION
'
' ################################
' #####  BinTree_RealUninit  #####
' ################################
' Deletes iNode and all its children
' iNode = the node to delete
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION BinTree_RealUninit (iNode, FUNCADDR keyDeleter)
	BINNODE node
	FUNCADDR delete (XLONG)

	IFF BINNODE_Get (iNode, @node) THEN RETURN $$FALSE

	IF node.iLeft THEN BinTree_RealUninit (node.iLeft, keyDeleter)
	IF node.iRight THEN BinTree_RealUninit (node.iRight, keyDeleter)
	IF keyDeleter THEN
		delete = keyDeleter
		@delete (node.iKey)
	ENDIF
	BINNODE_Delete (iNode)

	RETURN $$TRUE		' success
END FUNCTION
'
' ################################
' #####  LINKEDLIST_GETNODE  #####
' ################################
' Gets a particular node from a linked list
' list = the list to get a node from
' index = the 0 based index of the node to get, use -1 to get the head node
' iNode = the variable to store the index to the node
' Returns $$TRUE on success or $$FALSE on fail
FUNCTION LINKEDLIST_GetNode (LINKEDLIST list, index, iNode)
	LINKEDNODE node
	' Get the head node
	iThis = list.iHead

	FOR i = -1 TO index - 1
		IFF LINKEDNODE_Get (iThis, @node) THEN RETURN $$FALSE
		iThis = node.iNext
	NEXT i

	iNode = iThis
	RETURN $$TRUE		' success
END FUNCTION

DefineAccess(LINKEDNODE)
DefineAccess(LINKEDWALK)
DefineAccess(BINNODE)
DefineAccess(BINWALK)
DefineAccess(STACK)

END PROGRAM
