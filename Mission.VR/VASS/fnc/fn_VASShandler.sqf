/*
	Author: Terra

	Description:
		This is meant as an "API" of sorts. The following modes are available:
		"getMoney":
			Description:
				Get the money of the given unit
			Parameter(s):
				0:	OBJECT - The unit whose money is checked
			Returns:
				NUMBER - Money of the unit
		"setMoney":
			Description:
				Set the money of the given unit
			Parameter(s):
				0:	OBJECT - The unit whose money is modified
				1:	NUMBER - Change (not final amount, that is up to this function!)
			Returns:
				NOTHING - No return expected


	Parameter(s):
		0:	STRING - Mode
		Optional:
		1:	ARRAY - Parameters passed to the different modes
			Default: []

	Returns:
		ANY - Whatever the mode returns

	Example(s):
		["getMoney", [player]] call TER_fnc_VASShandler; //-> 0
		["setMoney", [player, -5900]] call TER_fnc_VASShandler; //-> nil
*/

params ["_mode",["_params",[]]];

switch _mode do {
	case "getMoney":{
		_params params ["_unit"];
		/* EXAMPLE */
		rating _unit
	};
	case "setMoney":{
		_params params ["_unit", "_change"];
		/* EXAMPLE */
		_unit addRating _change;
	};
};
