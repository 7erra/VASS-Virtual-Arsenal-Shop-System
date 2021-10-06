/*
	Author: Terra

	Description:
		Change the items of a shop after a certain time.

	Parameter(s):
		0:	OBJECT - Shop object
		1:	ARRAY or BOOL - List of items to readd/remove or true to reset the inventory to default
		Optional:
		2:	NUMBER - Time until reset. Negative values will use the "TER_VASS_refresh" variable from the object.
			Default: -1
		3:	BOOL - Passed items will become the only ones after reset. If items is true then it is automatically set to reset.
			Default: false

	Returns:
		BOOL - true when done

	Example(s):
		[cursorObject, ["10Rnd_338_Mag",1000,5,"50Rnd_570x28_SMG_03",50,40,"SMG_03_black",1000,5]] spawn TER_fnc_resetTimer; //-> Script handle
		[cursorObject, ["10Rnd_338_Mag",1000,5,"50Rnd_570x28_SMG_03",50,40,"SMG_03_black",1000,5], 59, true] spawn TER_fnc_resetTimer; //-> Script handle
*/
params ["_object", "_items", ["_sleep", -1], ["_reset",false]];

if (_sleep < 0) then {
	_sleep = _object getVariable "TER_VASS_refresh"
};
if (_items isEqualTo true) then {
	_items = _object getVariable "TER_VASS_cargo_default";
	_reset = true;
};
sleep _sleep;
[_object, _items, [4,2]select(_reset)] call TER_fnc_addShopCargo;
true
