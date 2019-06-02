/*
	Author: 7erra <https://forums.bohemia.net/profile/1139559-7erra/>

	Description:
	Change the inventory of a shop.

	Parameter(s):
	0: OBJECT - The shop object whose inventory will be changed.
	1: ARRAY - List of items, prices and amounts to add
		Format: ["class0", price, amount, "class1", price, amount,..., "classN", price, amount]
		Price and amount are optional. In this case they will default to 0 (free) and -1 (unlimited).
	(optional) 2: NUMBER - Overwrite mode:
		0 - Don't overwrite, only add new things
		1 - (default) Overwrite soft, only adjust prices and add new things
		2 - Hard overwrite, the passed array becomes the new inventory
		3 - Overwrite old, don't add new entries, only modify old ones
	(optional) 3: BOOL - Change inventory for all players. If not specified, the _object's "TER_VASS_shared" variable is used. If this isn't set either it defaults to true.

	Returns:
	ARRAY - New inventory
*/

params ["_object","_inCargo", ["_overwrite",1]];
_global = param [3, _object getVariable ["TER_VASS_shared",true]];
//--- Adjust cargo array
_cargo = [];
{
	if (_x isEqualType "") then {
		_price = _inCargo select (_forEachIndex+1);
		_amount = _inCargo select (_forEachIndex+2);
		_cargo append [
			toLower _x,
			[0, _price] select (_price isEqualType 0),
			[-1, _amount] select ([_price,_amount] isEqualTypeAll 0)
		];
	};
} forEach _inCargo;

_cargoClasses = _cargo select {_x isEqualType ""};
_newCargo = [];
//--- Shop settings
if (_overwrite == 2) then {
	_newCargo = _cargo;
} else {
	_curCargo = _object getVariable ["TER_VASS_cargo",[]];
	{
		_class = _x;
		_findInd = _curCargo findIf {_x isEqualTo _class};
		if (_findInd != -1 && _overwrite == 1) then {
			//--- Overwrite current setting
			_curCargo set [_findInd+1, _cargo select ((_cargo find _class)+1)];
			_curCargo set [_findInd+2, _cargo select ((_cargo find _class)+2)];
		};
		if (_findInd == -1 && _overwrite != 3) then {
			//--- New entry
			_findInd = count _curCargo;
			_curCargo set [_findInd+0, _cargo select ((_cargo find _class)+0)];
			_curCargo set [_findInd+1, _cargo select ((_cargo find _class)+1)];
			_curCargo set [_findInd+2, _cargo select ((_cargo find _class)+2)];
		};

	} forEach _cargoClasses;
	_newCargo = _curCargo;
};
if (isNil {_object getVariable "TER_VASS_cargo_default"}) then {
	_object setVariable ["TER_VASS_cargo_default",_newCargo];
};
_object setVariable ["TER_VASS_cargo",_newCargo];
_newCargo
