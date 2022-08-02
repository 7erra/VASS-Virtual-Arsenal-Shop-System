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
private _moneySystem = getMissionConfigValue ["VASS_moneySystem", "rating"];
switch _mode do {
	case "getMoney":{
		_params params ["_unit"];
		if (_moneySystem == "GRAD_moneyMenu") exitWith {
			[_unit] call grad_lbm_fnc_getFunds;
		};

		if (_moneySystem == "HG_SimpleShops") exitWith {
			_unit getVariable HG_CASH_VAR;
		};

		if (_moneySystem == "Ravage") exitWith {
			{_x isEqualTo "rvg_money"} count magazines player;
		};
		
		if (_moneySystem in ["rating", "default"]) exitWith {
			rating _unit
		};

		["VASS: No money system selected! Add 'VASS_moneySystem = ""default"";' to your description.ext!"] call BIS_fnc_error;
		0
	};
	case "setMoney":{
		_params params ["_unit", "_change"];
		if (_moneySystem == "GRAD_moneyMenu") exitWith {
			[_unit, _change] call grad_moneymenu_fnc_addFunds;
		};

		if (_moneySystem == "HG_SimpleShops") exitWith {
			[_change, 0] call HG_fnc_addOrSubCash;
		};

		if (_moneySystem == "Ravage") exitWith {
			private _changeCode = [
				{_unit removeItem "rvg_money"},
				{_unit addItem "rvg_money"}
			] select (_change > 0);
			for "_i" from 1 to (abs _change) do _changeCode;
		};
		
		if (_moneySystem in ["rating", "default"]) exitWith {
			_unit addRating _change;
		};

		["VASS: No money system selected! Add 'VASS_moneySystem = ""default"";' to your description.ext!"] call BIS_fnc_error;
	};
};
