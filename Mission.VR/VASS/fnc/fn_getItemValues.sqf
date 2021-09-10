/*
	Author: Terra

	Description:
		Get the price and amount of an item in a shop.

	Parameter(s):
		0:	OBJECT - Shop object
		1:	STRING - Classname of the item
		Optional:
		2:	NUMBER - Type of return:
				0: class
				1: price
				2: amount
				-1: array of [class, price, amount]
			Default: -1
		3:	ARRAY - Default return when item is not in the shop
			Default: [parameter 0, 0, -1]

	Returns:
		ARRAY or STRING or NUMBER - Depending on param 2, the requested value

	Example(s):
		[cursorObject, "SMG_03_black"] call TER_fnc_getItemValues; //-> ["SMG_03_black", 1000, 5]
		[cursorObject, "SMG_03_black", 1] call TER_fnc_getItemValues; //-> 1000
		[cursorObject, "bogus", nil, ["bogus", 1234, 56]] call TER_fnc_getItemValues; //-> ["bogus", 1234, 56]
*/
params ["_object","_class",["_return",-1]];
private _default = param [3,[_class,0,0]];
_default params [["_dClass",_class],["_dPrice",0],["_dAmount",0]];
private _cargo = _object getVariable ["TER_VASS_cargo",[]];
_class = toLower _class;

_cargo = [_dPrice, _dAmount] +_cargo;
private _findInd = _cargo findIf {_x isEqualTo _class};
private _rArray = [_dClass, _cargo#(_findInd+1), _cargo#(_findInd+2)];
if (_return < 0) then {
	_rArray
} else {
	_rArray#_return
};
