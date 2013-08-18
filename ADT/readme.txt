===========
ADT Library
===========
Version 0.1
(C) Callum Lowcay 2008.  Distributed under the terms of the GNU LGPL.
    Guy Lonne 2011-2013. Small changes in accessors.m4.

=======================
Installing
=======================
I recommend that you copy accessors.m4 to your XBlite include folder and set the M4PATH environment variable to your XBlite include folder.  This way you can include the accessors in any project without having to copy the accessors.m4 file into the same folder as the source file.

Note that ADT.x requires m4 macro processing to compile, make sure to enable it.

=======================
Using the ADTs
=======================
You'll find each function in adt.x to be well documented.  This section explains in more detail which functions to use for which situations.

Linked Lists:
-------------
A linked list is an ordered list which can hold any number of items.  A linked list is represented by a LINKEDLIST structure.  The iHead and iTail fields are used internally to manage the nodes - you should never need to change them.  The cItems field keeps track of how many items are in the list, it could be usefull to delete the back of a list.

Before you can use a linked list you need to initialise the LINKEDLIST structure that will represent the list with the LinkedList_Init function.  If you are dynamically allocating linked lists you may need to delete an  entire list at some stage.  To do this use the LinkedList_Uninit.  After calling this function, the list will require initialisation before it can be used again.

You can add items to the list with the LinkedList_Append and LinkedList_Insert functions.  To retreive a particular item from the list use the LinkedList_GetItem function.  The LinkedList_DeleteItem and LinkedList_DeleteAll functions can be used to delete items from a linked list.

One of the most common opperations on a linked list is walking.  Walking a linked list is a procedure that visits each item in order.  To walk a linked list, get a walk handle with the LinkedList_StartWalk function.  You can then use the handle in calls to LinkedList_Walk to walk the list.  Each subsequent call to LinkedList_Walk returns the next item in the list.  If the walk has passed the end of the list, LinkedList_Walk returns $$FALSE, otherwise it returns $$TRUE.  Because of this, you can use it in a DO WHILE loop to visit every item in the list.  When the walking is complete, call the LinkedList_EndWalk function to delete the walk handle and avoid memmory leaks.

You can also use the LinkedList_Map function to invoke a callback function on every item in a linked list.  The callback function has three parameters: the index of the item, the data for the item and an XLONG result passed by reference.  You can use the result variable to return a result to the caller of LinkedList_Map.  The callback returns $$TRUE to continue walking the list or $$FALSE it is no longer necassary.

The linked list stores a single XLONG value for each item.  You can use this to store the index of an object allocated through the accessor macros to create a linked list of any object you like.

Stacks:
-------
A stack is an ordered list that can grow indefinately, like a linked list, but with some restrictions on how the list can be accessed.  Think of a stack like a stak of plates.  You can only remove the last item added to the stack.  Stacks are usually used to temporaly save variables.  A stack is represented with a STACK structure.  As with the linked list, you must call Stack_Init to initialise a stack and Stack_Uninit prior to deleteing it.

To add an item to the top of a stack use the Stack_Push function.  To read then remove the item at the top of the stack use the Stack_Pop function.  You can also peek at the item at the top of the stack with the Stack_Peek function.

BinTrees:
---------
A binary tree stores data in such a way that it can be easily searched and sorted.  An item in a bintree contains a key and some data.  Sorting and searching are done using the key.

The BinTree_Init function takes 2 functions as parameters.  A comparator and a keyDeleter.  The comparator takes 2 keys a and b.  It returns < 0 if a comes before b, 0 if a = b and > 0 if a comes after b.  Several comparators are provided by the ADT library.  A key deleter takes the id of a key and deletes it.

To add, remove and find items in a bintree use the BinTree_Add, BinTree_Remove and BinTree_Find functions.  To get the sorted items you need to traverse the tree.  This is similar to walking a linked list except you create and use a traversal object instead.  There are three traversal modes, preorder, inorder and postorder.  Preorder sorts the items ascending, postorder descending.  inorder is a bit strange.  You get the middle item first, then the inorder traversals of the left and right sub trees.

Associative Arrays:
-------------------
AssocArrays form a thin layer over BinTrees.  They allow you to associate integers with string keys.  You can traverse them by going down to the BinTree functions.


