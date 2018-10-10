/*
	Author: 7erra

	Description:
	Return the items which were changed. You can also achieve the opposite effect by
	passing array B first, so you get all new items.

	Parameter(s):
	0: ARRAY - Array A
	1: ARRAY - Array B

	Returns:
	ARRAY: Items which were in A but not in B

	Example:
	[[1,2,3],[1,3]] call TER_fnc_arrayChange; //[2]
*/

params ["_prevItems","_afterItems"];
// deleted items
private _deletedItems = [];
{
	private _removedItem = _afterItems deleteAt (_afterItems find _x);
	if (isNil "_removedItem") then {//item removed
		_deletedItems pushBack _x;
	};
} forEach _prevItems;
_deletedItems