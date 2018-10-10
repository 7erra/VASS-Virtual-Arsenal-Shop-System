/*
	Description:
	Get the cost of an item

	Parameter(s):
	 0: STRING - Item classname

	Returns:
	NUMBER - cost from the cost array

	Example:
	_itemCost = "arifle_AK12_F" call TER_fnc_itemCostFromTable;
*/
params ["_classname"];
_costArray = call TER_costArray;
_costIndex = _costArray find toLower _classname;
_itemCost = [_costArray select (_costIndex +1), 0] select (_costIndex == -1); // if object is not registered then set cost to 0
_itemCost